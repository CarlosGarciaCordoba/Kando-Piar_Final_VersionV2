import { Router } from 'express';
import { CategoriasSIMATController } from '../controllers/categorias-simat.controller';

const router = Router();

/**
 * @route GET /api/categorias-simat
 * @desc Obtiene todas las categorías SIMAT disponibles
 * @access Public
 */
router.get('/', CategoriasSIMATController.getCategoriasSIMAT);

/**
 * @route GET /api/categorias-simat/:id
 * @desc Obtiene una categoría SIMAT específica por ID
 * @access Public
 */
router.get('/:id', CategoriasSIMATController.getCategoriaSIMATById);

export default router;