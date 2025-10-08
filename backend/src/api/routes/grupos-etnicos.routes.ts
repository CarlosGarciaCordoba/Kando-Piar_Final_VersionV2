import { Router } from 'express';
import { GruposEtnicosController } from '../controllers/grupos-etnicos.controller';

const router = Router();

/**
 * @route GET /api/grupos-etnicos
 * @desc Obtiene todos los grupos étnicos disponibles
 * @access Public
 */
router.get('/', GruposEtnicosController.getGruposEtnicos);

/**
 * @route GET /api/grupos-etnicos/:id
 * @desc Obtiene un grupo étnico específico por ID
 * @access Public
 */
router.get('/:id', GruposEtnicosController.getGrupoEtnicoById);

export default router;