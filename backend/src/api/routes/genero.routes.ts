import { Router } from 'express';
import { GeneroController } from '../controllers/genero.controller';

const router = Router();

/**
 * @route GET /api/generos
 * @desc Obtiene todos los géneros disponibles
 * @access Public
 */
router.get('/', GeneroController.getGeneros);

export default router;