import { Router } from 'express';
import { RelacionesEstudianteController } from '../controllers/relaciones-estudiante.controller';

const router = Router();

/**
 * @route GET /api/relaciones-estudiante
 * @desc Obtiene todas las relaciones activas con el estudiante
 * @access Public (puede requerir autenticación según necesidades)
 */
router.get('/', RelacionesEstudianteController.getAllRelaciones);

/**
 * @route GET /api/relaciones-estudiante/nombres
 * @desc Obtiene solo los nombres de las relaciones para selects del frontend
 * @access Public (puede requerir autenticación según necesidades)
 */
router.get('/nombres', RelacionesEstudianteController.getNombresRelaciones);

/**
 * @route GET /api/relaciones-estudiante/:id
 * @desc Obtiene una relación específica por ID
 * @access Public (puede requerir autenticación según necesidades)
 */
router.get('/:id', RelacionesEstudianteController.getRelacionById);

export default router;