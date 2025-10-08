import { Router } from 'express';
import { ColegiosController } from '../controllers/colegios.controller';

const router = Router();

/**
 * @route GET /api/colegios
 * @desc Obtiene todos los colegios disponibles
 * @access Public
 */
router.get('/', ColegiosController.getColegios);

/**
 * @route GET /api/colegios/:id
 * @desc Obtiene un colegio por ID
 * @access Public
 */
router.get('/:id', ColegiosController.getColegioById);

export default router;