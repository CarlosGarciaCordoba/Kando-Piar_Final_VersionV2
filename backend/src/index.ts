import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import pool from './config/database';
import authRoutes from './api/routes/auth.routes';
import tiposDocumentoRoutes from './api/routes/tipos-documento.routes';
import generoRoutes from './api/routes/genero.routes';
import departamentoRoutes from './api/routes/departamento.routes';
import epsRoutes from './api/routes/eps.routes';
import frecuenciasRehabilitacionRoutes from './api/routes/frecuencias-rehabilitacion.routes';
import frecuenciasMedicamentosRoutes from './api/routes/frecuencias-medicamentos.routes';
import horariosMedicamentosRoutes from './api/routes/horarios-medicamentos.routes';
import categoriasSIMATRoutes from './api/routes/categorias-simat.routes';
import gruposEtnicosRoutes from './api/routes/grupos-etnicos.routes';
import colegiosRoutes from './api/routes/colegios.routes';
import nivelesEducativosRoutes from './api/routes/niveles-educativos.routes';
import ingresosPromediosMensualesRoutes from './api/routes/ingresos-promedios-mensuales.routes';
import relacionesEstudianteRoutes from './api/routes/relaciones-estudiante.routes';
import asignaturasRoutes from './api/routes/asignaturas.routes';
import asignaturasEducacionInicialRoutes from './api/routes/asignaturas-educacion-inicial.routes';
import geminiAnalysisRoutes from './api/routes/gemini-analysis.routes';
import barrerasRoutes from './api/routes/barreras.routes';
import { errorHandler } from './middleware/errorHandler';

dotenv.config();

const app = express();
// ID de build para depuración (reinicia en cada proceso)
const BUILD_ID = `build-${Date.now()}`;

// Middlewares
app.use(cors());
app.use(express.json());

// Servir archivos estáticos del frontend
app.use('/frontend', express.static(path.join(__dirname, '../../frontend')));
// Header de versión en todas las respuestas
app.use((req: Request, res: Response, next: NextFunction) => {
  res.setHeader('X-App-Build', BUILD_ID);
  next();
});

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/tipos-documento', tiposDocumentoRoutes);
app.use('/api/generos', generoRoutes);
app.use('/api/departamentos', departamentoRoutes);
app.use('/api/eps', epsRoutes);
app.use('/api/frecuencias-rehabilitacion', frecuenciasRehabilitacionRoutes);
app.use('/api/frecuencias-medicamentos', frecuenciasMedicamentosRoutes);
app.use('/api/horarios-medicamentos', horariosMedicamentosRoutes);
app.use('/api/categorias-simat', categoriasSIMATRoutes);
app.use('/api/grupos-etnicos', gruposEtnicosRoutes);
app.use('/api/colegios', colegiosRoutes);
app.use('/api/niveles-educativos', nivelesEducativosRoutes);
app.use('/api/ingresos-promedios-mensuales', ingresosPromediosMensualesRoutes);
app.use('/api/relaciones-estudiante', relacionesEstudianteRoutes);
app.use('/api/asignaturas', asignaturasRoutes);
app.use('/api/asignaturas-educacion-inicial', asignaturasEducacionInicialRoutes);
app.use('/api/gemini', geminiAnalysisRoutes);
app.use('/api/barreras', barrerasRoutes);

// Ruta de prueba
app.get('/', (_req: Request, res: Response) => {
  res.json({ 
    message: 'API Kando PIAR funcionando correctamente',
    build: BUILD_ID
  });
});

// Ruta de diagnóstico para identificar el proceso que responde
app.get('/whoami', (_req: Request, res: Response) => {
  res.json({
    build: BUILD_ID,
    pid: process.pid,
    cwd: process.cwd(),
    execPath: process.execPath,
    uptimeSeconds: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Ruta de prueba para la base de datos
app.get('/db-test', async (_req: Request, res: Response) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ 
      message: 'Conexión exitosa a la base de datos',
      timestamp: result.rows[0].now
    });
  } catch (error: any) {
    res.status(500).json({ 
      message: 'Error conectando a la base de datos',
      error: error.message 
    });
  }
});

const PORT: number = Number(process.env.PORT) || 3000;

// 404 para rutas no encontradas
app.use((req: Request, res: Response, _next: NextFunction) => {
  res.status(404).json({ success: false, message: 'Ruta no encontrada' });
});

// Middleware global de errores (debe ir al final)
app.use(errorHandler);

// Iniciar el servidor independientemente de la conexión a la base de datos
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
  console.log(`🆔 BUILD_ID: ${BUILD_ID}`);
  console.log(`📌 PID: ${process.pid}`);
  console.log(`📂 CWD: ${process.cwd()}`);
});

// Verificar conexión a la base de datos (opcional, no bloquea el servidor)
pool.query('SELECT NOW()', (error, result) => {
  if (error) {
    console.error('❌ Error conectando a la base de datos al iniciar el servidor:', error.message);
    console.log('⚠️ El servidor continuará ejecutándose sin conexión a la base de datos');
  } else {
    console.log('✅ Conexión exitosa a la base de datos al iniciar el servidor');
  }
});

export default app;