import { Router } from 'express';
import { FrecuenciasRehabilitacionController } from '../controllers/frecuencias-rehabilitacion.controller';

const router = Router();
const frecuenciasRehabilitacionController = new FrecuenciasRehabilitacionController();

/**
 * @route GET /api/frecuencias-rehabilitacion
 * @description Obtiene todas las frecuencias de rehabilitación disponibles
 * @access Public
 */
router.get('/', frecuenciasRehabilitacionController.getFrecuenciasRehabilitacion);

/**
 * @route GET /api/frecuencias-rehabilitacion/:id
 * @description Obtiene una frecuencia de rehabilitación específica por ID
 * @access Public
 */
router.get('/:id', frecuenciasRehabilitacionController.getFrecuenciaRehabilitacionById);

export default router;