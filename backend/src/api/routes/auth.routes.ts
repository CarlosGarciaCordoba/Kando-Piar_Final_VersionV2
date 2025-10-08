import { Router } from 'express';
import { login, recoverPassword, resetPassword } from '../controllers/auth.controller';
import { loginValidator, recoverPasswordValidator, resetPasswordValidator } from '../validators/auth.validator';
import { validateRequest } from '../../middleware/validateRequest';

const router = Router();

// Ruta de autenticación
router.post('/login', loginValidator, validateRequest, login);

// Endpoint para recuperación de contraseña
router.post('/recover-password', recoverPasswordValidator, validateRequest, recoverPassword);
router.post('/reset-password', resetPasswordValidator, validateRequest, resetPassword);

// Endpoint de diagnóstico rápido
router.get('/recover-password-signature', (_req, res) => {
	res.json({
		expectedSubjectPattern: 'RECUP TEST <timestamp> - Kando PIAR',
		note: 'Si no ves este patrón en el correo, la petición va a otra instancia o un proceso previo',
		now: Date.now()
	});
});

// Exportar el router
export default router;
