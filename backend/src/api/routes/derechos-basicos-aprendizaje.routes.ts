import { Router } from 'express';
import { DerechosBasicosAprendizajeController } from '../controllers/derechos-basicos-aprendizaje.controller';

const router = Router();

/**
 * @route   GET /api/dba/asignatura/:idAsignatura/grado/:idGrado
 * @desc    Obtener todos los DBA de una asignatura y grado específico
 * @access  Public
 * @example GET /api/dba/asignatura/2/grado/4 (Matemáticas - 1° grado)
 */
router.get('/asignatura/:idAsignatura/grado/:idGrado', DerechosBasicosAprendizajeController.getDbaByAsignaturaAndGrado);

/**
 * @route   GET /api/dba/:idDba/evidencias
 * @desc    Obtener un DBA específico con todas sus evidencias
 * @access  Public
 * @example GET /api/dba/1/evidencias
 */
router.get('/:idDba/evidencias', DerechosBasicosAprendizajeController.getDbaWithEvidencias);

/**
 * @route   GET /api/dba/asignaturas-grados
 * @desc    Obtener todas las asignaturas y grados que tienen DBA disponibles
 * @access  Public
 */
router.get('/asignaturas-grados', DerechosBasicosAprendizajeController.getAsignaturasGradosConDba);

/**
 * @route   GET /api/dba/buscar?q=termino
 * @desc    Buscar DBA por palabra clave en título, descripción o evidencias
 * @access  Public
 * @example GET /api/dba/buscar?q=números
 */
router.get('/buscar', DerechosBasicosAprendizajeController.buscarDba);

/**
 * @route   GET /api/dba/estadisticas
 * @desc    Obtener estadísticas de DBA por nivel educativo
 * @access  Public
 */
router.get('/estadisticas', DerechosBasicosAprendizajeController.getEstadisticasDba);

export default router;