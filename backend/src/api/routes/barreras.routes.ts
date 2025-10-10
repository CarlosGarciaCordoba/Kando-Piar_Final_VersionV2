import { Router } from 'express';
import { BarrerasController } from '../controllers/barreras.controller';

const router = Router();

/**
 * @route GET /api/barreras
 * @desc Obtiene todas las barreras disponibles
 * @access Public
 */
router.get('/', BarrerasController.getAllBarreras);

/**
 * @route GET /api/barreras/:id
 * @desc Obtiene una barrera específica por ID
 * @access Public
 */
router.get('/:id', BarrerasController.getBarreraById);

/**
 * @route GET /api/barreras/categoria/:categoriaId
 * @desc Obtiene todas las barreras de una categoría SIMAT específica
 * @access Public
 */
router.get('/categoria/:categoriaId', BarrerasController.getBarrerasByCategoria);

export default router;