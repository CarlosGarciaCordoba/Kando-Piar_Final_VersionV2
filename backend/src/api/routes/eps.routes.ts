import { Router } from 'express';
import { EpsController } from '../controllers/eps.controller';

const router = Router();

/**
 * @route GET /api/eps
 * @desc Obtiene todas las EPS disponibles
 * @access Public
 */
router.get('/', EpsController.getEps);

/**
 * @route GET /api/eps/:id_eps
 * @desc Obtiene una EPS específica por ID
 * @access Public
 */
router.get('/:id_eps', EpsController.getEpsById);

export default router;