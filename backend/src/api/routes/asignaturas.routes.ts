import { Router } from 'express';
import { AsignaturasController } from '../controllers/asignaturas.controller';

const router = Router();

/**
 * @route GET /api/asignaturas
 * @desc Obtiene todas las asignaturas disponibles
 * @access Public
 */
router.get('/', AsignaturasController.getAsignaturas);

export default router;