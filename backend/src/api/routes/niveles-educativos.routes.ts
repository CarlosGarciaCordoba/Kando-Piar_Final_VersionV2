import { Router } from 'express';
import { NivelesEducativosController } from '../controllers/niveles-educativos.controller';

const router = Router();

/**
 * @route GET /api/niveles-educativos
 * @desc Obtiene todos los niveles educativos disponibles
 * @access Public
 */
router.get('/', NivelesEducativosController.getNivelesEducativos);

/**
 * @route GET /api/niveles-educativos/:id
 * @desc Obtiene un nivel educativo por ID
 * @access Public
 */
router.get('/:id', NivelesEducativosController.getNivelEducativoById);

export default router;