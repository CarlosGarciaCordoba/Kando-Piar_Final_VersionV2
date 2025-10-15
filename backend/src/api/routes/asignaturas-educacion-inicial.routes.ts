import { Router } from 'express';
import { AsignaturasEducacionInicialController } from '../controllers/asignaturas-educacion-inicial.controller';

const router = Router();

/**
 * @route   GET /api/asignaturas-educacion-inicial
 * @desc    Obtener todas las dimensiones de educación inicial activas
 * @access  Public
 */
router.get('/', AsignaturasEducacionInicialController.getAsignaturasEducacionInicial);

/**
 * @route   GET /api/asignaturas-educacion-inicial/:id
 * @desc    Obtener una dimensión específica por ID
 * @access  Public
 */
router.get('/:id', AsignaturasEducacionInicialController.getAsignaturaEducacionInicialById);

/**
 * @route   GET /api/asignaturas-educacion-inicial/resumen/dimensiones
 * @desc    Obtener resumen de dimensiones por tipo
 * @access  Public
 */
router.get('/resumen/dimensiones', AsignaturasEducacionInicialController.getResumenDimensiones);

export default router;