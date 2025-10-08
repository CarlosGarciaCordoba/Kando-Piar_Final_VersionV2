import { Router } from 'express';
import { IngresosPromediosMensualesController } from '../controllers/ingresos-promedios-mensuales.controller';

const router = Router();

/**
 * @route GET /api/ingresos-promedios-mensuales
 * @desc Obtiene todos los rangos de ingresos promedios mensuales disponibles
 * @access Public
 */
router.get('/', IngresosPromediosMensualesController.getIngresosPromediosMensuales);

/**
 * @route GET /api/ingresos-promedios-mensuales/:id
 * @desc Obtiene un rango de ingresos por ID
 * @access Public
 */
router.get('/:id', IngresosPromediosMensualesController.getIngresoPromedioMensualById);

export default router;