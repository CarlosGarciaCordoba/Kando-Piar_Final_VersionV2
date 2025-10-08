import { Router } from 'express';
import { TiposDocumentoController } from '../controllers/tipos-documento.controller';

const router = Router();

/**
 * @route GET /api/tipos-documento
 * @desc Obtener todos los tipos de documento
 * @query {string} incluir_inactivos - Si es 'true', incluye tipos de documento inactivos
 */
router.get('/', TiposDocumentoController.getAllTiposDocumento);

/**
 * @route GET /api/tipos-documento/:id
 * @desc Obtener un tipo de documento específico por ID
 * @param {string} id - ID del tipo de documento
 */
router.get('/:id', TiposDocumentoController.getTipoDocumentoById);

/**
 * @route POST /api/tipos-documento
 * @desc Crear un nuevo tipo de documento
 * @body {object} tipoDocumento - Datos del tipo de documento (codigo, descripcion, activo)
 */
router.post('/', TiposDocumentoController.createTipoDocumento);

/**
 * @route PUT /api/tipos-documento/:id
 * @desc Actualizar un tipo de documento existente
 * @param {string} id - ID del tipo de documento a actualizar
 * @body {object} tipoDocumento - Datos actualizados del tipo de documento
 */
router.put('/:id', TiposDocumentoController.updateTipoDocumento);

/**
 * @route DELETE /api/tipos-documento/:id
 * @desc Eliminar un tipo de documento
 * @param {string} id - ID del tipo de documento a eliminar
 */
router.delete('/:id', TiposDocumentoController.deleteTipoDocumento);

export default router;