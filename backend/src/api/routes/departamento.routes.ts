import { Router } from 'express';
import { DepartamentoController } from '../controllers/departamento.controller';

const router = Router();

/**
 * @route GET /api/departamentos
 * @desc Obtiene todos los departamentos disponibles
 * @access Public
 */
router.get('/', DepartamentoController.getDepartamentos);

/**
 * @route GET /api/departamentos/:id_departamento/municipios
 * @desc Obtiene los municipios de un departamento específico
 * @access Public
 */
router.get('/:id_departamento/municipios', DepartamentoController.getMunicipiosByDepartamento);

export default router;