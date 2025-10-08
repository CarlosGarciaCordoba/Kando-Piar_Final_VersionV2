import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../../config/database';
import { sendGmail } from '../../utils/gmailSender';
import crypto from 'crypto';

// Almacenamiento temporal en memoria (reemplazar por tabla password_resets)
interface ResetTokenRecord {
    email: string;
    tokenHash: string;
    expiresAt: Date;
    used: boolean;
}
const resetTokens: ResetTokenRecord[] = [];

// Controlador para recuperación de contraseña
export const recoverPassword = async (req: Request, res: Response) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({ success: false, message: 'El correo es requerido' });
        }
        // Buscar usuario por email
        const userResult = await pool.query(
            'SELECT nombres, apellidos FROM usuarios WHERE email = $1',
            [email]
        );
        const user = userResult.rows[0];
        if (!user) {
            return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
        }
        // Generar token seguro (64 chars hex) y guardar hash + expiración
        const rawToken = crypto.randomBytes(32).toString('hex');
        const tokenHash = await bcrypt.hash(rawToken, 10);
        const expiresMinutes = parseInt(process.env.RESET_TOKEN_EXP_MINUTES || '30', 10);
        const expiresAt = new Date(Date.now() + expiresMinutes * 60 * 1000);

        // Limpiar tokens anteriores del mismo email
        for (let i = resetTokens.length - 1; i >= 0; i--) {
            if (resetTokens[i].email === email) resetTokens.splice(i, 1);
        }
        resetTokens.push({ email, tokenHash, expiresAt, used: false });

        const frontendBase = process.env.FRONTEND_BASE_URL || 'http://localhost:5173';
        const resetLink = `${frontendBase}/reset-password?token=${rawToken}`;

    // Asunto definitivo con acentos correcto (UTF-8)
    const subject = 'Recuperacion Kando PIAR';
        const html = `
            <div style="font-family:Arial,sans-serif;line-height:1.5;color:#222;max-width:600px;margin:0 auto;">
              <h2 style="color:#2b5797;">Recuperación de contraseña</h2>
              <p>Hola ${user.nombres} ${user.apellidos},</p>
              <p>Hemos recibido una solicitud para restablecer tu contraseña. Si no fuiste tú, puedes ignorar este mensaje.</p>
              <p style="margin:24px 0;">
                <a href="${resetLink}" style="background:#2b5797;color:#fff;padding:12px 20px;text-decoration:none;border-radius:6px;display:inline-block;">Restablecer contraseña</a>
              </p>
              <p>O copia y pega este enlace en tu navegador:</p>
              <p style="word-break:break-all;font-size:13px;color:#555;">${resetLink}</p>
              <p style="font-size:12px;color:#777;">Este enlace expira en ${expiresMinutes} minutos.</p>
              <hr style="border:none;border-top:1px solid #ddd;margin:30px 0;" />
              <p style="font-size:11px;color:#777;">Si no solicitaste el cambio, te recomendamos revisar la seguridad de tu cuenta.</p>
            </div>
        `;
    console.log('[[RECOVER vFINAL]] Subject a enviar:', subject);
    console.log('[RECOVER DEBUG] HTML preview:', html.substring(0, 120).replace(/\n/g,' '), '...');
    await sendGmail(email, subject, html);
    const DEBUG_ID = 'RP-' + new Date().getTime();
    res.json({ success: true, message: 'Correo de recuperación enviado', debug: { subject, resetLink, expiresMinutes, debugId: DEBUG_ID } });
    } catch (error: any) {
        console.error('Error en recoverPassword:', error);
        res.status(500).json({ success: false, message: 'Error enviando el correo de recuperación' });
    }
};

// Endpoint de reseteo de contraseña usando token temporal (memoria). Debe migrarse a tabla.
export const resetPassword = async (req: Request, res: Response) => {
    try {
        const { token, newPassword } = req.body;
        if (!token || !newPassword) {
            return res.status(400).json({ success: false, message: 'Token y nueva contraseña requeridos' });
        }
        // Buscar token válido
        const record = resetTokens.find(r => !r.used && r.expiresAt > new Date());
        if (!record) {
            return res.status(400).json({ success: false, message: 'Token inválido o expirado' });
        }
        const match = await bcrypt.compare(token, record.tokenHash);
        if (!match) {
            return res.status(400).json({ success: false, message: 'Token inválido' });
        }
        // Obtener usuario por email
        const userResult = await pool.query('SELECT cedula FROM usuarios WHERE email = $1', [record.email]);
        const user = userResult.rows[0];
        if (!user) {
            return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
        }
        const newHash = await bcrypt.hash(newPassword, 10);
        await pool.query('UPDATE usuarios SET password_hash = $1, debe_cambiar_password = false WHERE cedula = $2', [newHash, user.cedula]);
        record.used = true;
        res.json({ success: true, message: 'Contraseña actualizada correctamente' });
    } catch (error: any) {
        console.error('Error en resetPassword:', error);
        res.status(500).json({ success: false, message: 'Error interno al restablecer contraseña' });
    }
};

export const login = async (req: Request, res: Response) => {
    try {
        const { userCode, password, institution } = req.body;

        // Validación básica redundante (el validator ya cubre pero se deja por robustez)
        if (!userCode || !password || !institution) {
            return res.status(400).json({
                success: false,
                message: 'Código de usuario, contraseña y código de institución son requeridos'
            });
        }

        // Buscar usuario por código de usuario y código de institución
        const userResult = await pool.query(
            `SELECT cedula, codigo_usuario, nombres, apellidos, email, telefono, 
                    password_hash, codigo_institucion, debe_cambiar_password, 
                    estado, intentos_fallidos, bloqueado_hasta 
             FROM usuarios 
             WHERE codigo_usuario = $1 AND codigo_institucion = $2 AND estado = true`,
            [userCode, institution]
        );

        const user = userResult.rows[0];

        // Verificar si el usuario existe
        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Código de usuario, contraseña o código de institución incorrectos'
            });
        }

        // Verificar si el usuario está bloqueado
        if (user.bloqueado_hasta && new Date() < new Date(user.bloqueado_hasta)) {
            return res.status(423).json({
                success: false,
                message: 'Usuario bloqueado temporalmente. Intente más tarde'
            });
        }

        // Verificar la contraseña
        const validPassword = await bcrypt.compare(password, user.password_hash);

        if (!validPassword) {
            // Incrementar intentos fallidos
            const intentos = user.intentos_fallidos + 1;
            const bloqueado_hasta = intentos >= 3 ? 
                new Date(Date.now() + 15 * 60 * 1000) : // 15 minutos de bloqueo
                null;

            await pool.query(
                'UPDATE usuarios SET intentos_fallidos = $1, bloqueado_hasta = $2 WHERE cedula = $3',
                [intentos, bloqueado_hasta, user.cedula]
            );

            return res.status(401).json({
                success: false,
                message: 'Código de usuario, contraseña o código de institución incorrectos'
            });
        }

        // Login exitoso - resetear intentos fallidos y actualizar último acceso
        await pool.query(
            'UPDATE usuarios SET intentos_fallidos = 0, bloqueado_hasta = NULL, ultimo_acceso = CURRENT_TIMESTAMP WHERE cedula = $1',
            [user.cedula]
        );

        // Generar token JWT
        const token = jwt.sign(
            {
                cedula: user.cedula,
                codigo_usuario: user.codigo_usuario,
                nombres: user.nombres,
                apellidos: user.apellidos,
                codigo_institucion: user.codigo_institucion
            },
            process.env.JWT_SECRET || 'tu_clave_secreta_kando',
            { expiresIn: '8h' }
        );

        // Enviar respuesta exitosa
        res.json({
            success: true,
            message: 'Inicio de sesión exitoso',
            token,
            user: {
                cedula: user.cedula,
                codigo_usuario: user.codigo_usuario,
                nombres: user.nombres,
                apellidos: user.apellidos,
                email: user.email,
                telefono: user.telefono,
                codigo_institucion: user.codigo_institucion,
                debe_cambiar_password: user.debe_cambiar_password
            }
        });

    } catch (error: any) {
        console.error('Error en login:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};