import { Router } from 'express';
import { FrecuenciasMedicamentosController } from '../controllers/frecuencias-medicamentos.controller';

const router = Router();
const frecuenciasMedicamentosController = new FrecuenciasMedicamentosController();

/**
 * @route GET /api/frecuencias-medicamentos
 * @description Obtiene todas las frecuencias de medicamentos disponibles
 * @access Public
 */
router.get('/', frecuenciasMedicamentosController.getFrecuenciasMedicamentos);

/**
 * @route GET /api/frecuencias-medicamentos/:id
 * @description Obtiene una frecuencia de medicamentos específica por ID
 * @access Public
 */
router.get('/:id', frecuenciasMedicamentosController.getFrecuenciaMedicamentosById);

export default router;