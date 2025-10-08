import { Router } from 'express';
import { HorariosMedicamentosController } from '../controllers/horarios-medicamentos.controller';

const router = Router();
const horariosMedicamentosController = new HorariosMedicamentosController();

/**
 * @route GET /api/horarios-medicamentos
 * @description Obtiene todos los horarios de medicamentos disponibles
 * @access Public
 */
router.get('/', horariosMedicamentosController.getHorariosMedicamentos);

/**
 * @route GET /api/horarios-medicamentos/:id
 * @description Obtiene un horario de medicamentos específico por ID
 * @access Public
 */
router.get('/:id', horariosMedicamentosController.getHorarioMedicamentosById);

export default router;