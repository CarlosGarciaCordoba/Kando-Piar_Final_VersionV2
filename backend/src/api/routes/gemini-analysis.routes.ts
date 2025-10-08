import { Router } from 'express';
import { analizarFuncionesCognitivas, verificarConfiguracionGemini } from '../controllers/gemini-analysis.controller';
import { funcionesCognitivasValidator } from '../validators/gemini-analysis.validator';
import { validateRequest } from '../../middleware/validateRequest';

const router = Router();

// Ruta para analizar funciones cognitivas con Gemini AI
router.post('/analizar-funciones-cognitivas', funcionesCognitivasValidator, validateRequest, analizarFuncionesCognitivas);

// Ruta para verificar la configuración de Gemini
router.get('/verificar-configuracion', verificarConfiguracionGemini);

// Ruta de diagnóstico para el servicio
router.get('/status', (_req, res) => {
    res.json({
        service: 'Gemini Analysis API',
        version: '1.0.0',
        status: 'active',
        model: process.env.GEMINI_MODEL || 'gemini-2.5-flash',
        timestamp: new Date().toISOString()
    });
});

export default router;