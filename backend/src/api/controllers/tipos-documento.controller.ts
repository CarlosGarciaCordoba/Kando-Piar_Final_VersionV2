import { Request, Response } from 'express';
import pool from '../../config/database';

// Interface para Tipo de Documento
interface TipoDocumento {
    id?: string; // UUID en PostgreSQL
    codigo: string;
    descripcion: string;
    activo: boolean;
    orden?: number;
    observaciones?: string;
    created_at?: string;
    updated_at?: string;
}

export class TiposDocumentoController {
    
    /**
     * Obtener todos los tipos de documento
     * GET /api/tipos-documento
     */
    static async getAllTiposDocumento(req: Request, res: Response) {
        try {
            const { incluir_inactivos = 'false' } = req.query;
            
            let query = `
                SELECT id, codigo, descripcion, activo, orden, observaciones, 
                       created_at, updated_at 
                FROM tipos_documento
            `;
            
            const queryParams: any[] = [];
            
            // Filtrar por activos si no se especifica incluir inactivos
            if (incluir_inactivos !== 'true') {
                query += ' WHERE activo = $1';
                queryParams.push(true);
            }
            
            query += ' ORDER BY orden ASC, codigo ASC';
            
            const result = await pool.query(query, queryParams);
            
            res.json({
                success: true,
                message: 'Tipos de documento obtenidos exitosamente',
                data: result.rows,
                total: result.rows.length
            });
            
        } catch (error) {
            console.error('Error en getAllTiposDocumento:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener tipos de documento',
                error: error instanceof Error ? error.message : 'Error desconocido'
            });
        }
    }
    
    /**
     * Obtener un tipo de documento por ID
     * GET /api/tipos-documento/:id
     */
    static async getTipoDocumentoById(req: Request, res: Response) {
        try {
            const { id } = req.params;
            
            // Validar que el ID sea un UUID válido
            const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
            if (!id || !uuidRegex.test(id)) {
                return res.status(400).json({
                    success: false,
                    message: 'ID de tipo de documento inválido. Debe ser un UUID válido.'
                });
            }
            
            const query = `
                SELECT id, codigo, descripcion, activo, orden, observaciones, 
                       created_at, updated_at 
                FROM tipos_documento 
                WHERE id = $1
            `;            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Tipo de documento no encontrado'
                });
            }
            
            res.json({
                success: true,
                message: 'Tipo de documento obtenido exitosamente',
                data: result.rows[0]
            });
            
        } catch (error) {
            console.error('Error en getTipoDocumentoById:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener tipo de documento',
                error: error instanceof Error ? error.message : 'Error desconocido'
            });
        }
    }
    
    /**
     * Crear nuevo tipo de documento
     * POST /api/tipos-documento
     */
    static async createTipoDocumento(req: Request, res: Response) {
        try {
            const {
                codigo,
                descripcion,
                activo = true,
                orden = 1,
                observaciones
            }: TipoDocumento = req.body;            // Validaciones básicas
            if (!codigo || !descripcion) {
                return res.status(400).json({
                    success: false,
                    message: 'Código y descripción son campos obligatorios'
                });
            }
            
            if (codigo.length > 10) {
                return res.status(400).json({
                    success: false,
                    message: 'El código no puede exceder 10 caracteres'
                });
            }
            
            if (descripcion.length > 100) {
                return res.status(400).json({
                    success: false,
                    message: 'La descripción no puede exceder 100 caracteres'
                });
            }
            
            // Verificar que el código no exista
            const checkQuery = 'SELECT id FROM tipos_documento WHERE UPPER(codigo) = UPPER($1)';
            const existingResult = await pool.query(checkQuery, [codigo]);
            
            if (existingResult.rows.length > 0) {
                return res.status(409).json({
                    success: false,
                    message: 'Ya existe un tipo de documento con ese código'
                });
            }
            
            // Insertar nuevo tipo de documento
            const insertQuery = `
                INSERT INTO tipos_documento (codigo, descripcion, activo, orden, observaciones)
                VALUES ($1, $2, $3, $4, $5)
                RETURNING id, codigo, descripcion, activo, orden, observaciones, created_at
            `;
            
            const insertResult = await pool.query(insertQuery, [
                codigo.toUpperCase(),
                descripcion.trim(),
                activo,
                orden || 1,
                observaciones || null
            ]);
            
            res.status(201).json({
                success: true,
                message: 'Tipo de documento creado exitosamente',
                data: insertResult.rows[0]
            });
            
        } catch (error) {
            console.error('Error en createTipoDocumento:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al crear tipo de documento',
                error: error instanceof Error ? error.message : 'Error desconocido'
            });
        }
    }
    
    /**
     * Actualizar tipo de documento
     * PUT /api/tipos-documento/:id
     */
    static async updateTipoDocumento(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const { 
                codigo, 
                descripcion, 
                activo, 
                orden, 
                observaciones
            }: TipoDocumento = req.body;
            
            // Validar UUID
            const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
            if (!id || !uuidRegex.test(id)) {
                return res.status(400).json({
                    success: false,
                    message: 'ID de tipo de documento inválido'
                });
            }
            
            // Validaciones básicas
            if (!codigo || !descripcion) {
                return res.status(400).json({
                    success: false,
                    message: 'Código y descripción son campos obligatorios'
                });
            }
            
            // Verificar que el tipo de documento existe
            const checkExistsQuery = 'SELECT id, codigo FROM tipos_documento WHERE id = $1';
            const existsResult = await pool.query(checkExistsQuery, [id]);
            
            if (existsResult.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Tipo de documento no encontrado'
                });
            }
            
            // Verificar que no exista otro registro con el mismo código (excepto el actual)
            const checkDuplicateQuery = 'SELECT id FROM tipos_documento WHERE UPPER(codigo) = UPPER($1) AND id != $2';
            const duplicateResult = await pool.query(checkDuplicateQuery, [codigo, id]);
            
            if (duplicateResult.rows.length > 0) {
                return res.status(409).json({
                    success: false,
                    message: 'Ya existe otro tipo de documento con ese código'
                });
            }
            
            // Actualizar el tipo de documento
            const updateQuery = `
                UPDATE tipos_documento 
                SET codigo = $1, descripcion = $2, activo = $3, orden = $4, 
                    observaciones = $5, updated_at = CURRENT_TIMESTAMP
                WHERE id = $6
                RETURNING id, codigo, descripcion, activo, orden, observaciones, updated_at
            `;
            
            const updateResult = await pool.query(updateQuery, [
                codigo.toUpperCase(),
                descripcion.trim(),
                activo,
                orden || 1,
                observaciones || null,
                id
            ]);
            
            if (updateResult.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'No se pudo actualizar el tipo de documento'
                });
            }
            
            res.json({
                success: true,
                message: 'Tipo de documento actualizado exitosamente',
                data: updateResult.rows[0]
            });
            
        } catch (error) {
            console.error('Error en updateTipoDocumento:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al actualizar tipo de documento',
                error: error instanceof Error ? error.message : 'Error desconocido'
            });
        }
    }
    
    /**
     * Eliminar tipo de documento
     * DELETE /api/tipos-documento/:id
     */
    static async deleteTipoDocumento(req: Request, res: Response) {
        try {
            const { id } = req.params;
            
            // Validar UUID
            const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
            if (!id || !uuidRegex.test(id)) {
                return res.status(400).json({
                    success: false,
                    message: 'ID de tipo de documento inválido'
                });
            }
            
            // Verificar que el tipo de documento existe
            const checkQuery = 'SELECT id, codigo, descripcion FROM tipos_documento WHERE id = $1';
            const existsResult = await pool.query(checkQuery, [id]);
            
            if (existsResult.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Tipo de documento no encontrado'
                });
            }
            
            const tipoDocumento = existsResult.rows[0];
            
            // Eliminar el tipo de documento
            const deleteQuery = 'DELETE FROM tipos_documento WHERE id = $1';
            const deleteResult = await pool.query(deleteQuery, [id]);
            
            if (deleteResult.rowCount === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'No se pudo eliminar el tipo de documento'
                });
            }
            
            res.json({
                success: true,
                message: 'Tipo de documento eliminado exitosamente',
                data: {
                    id: tipoDocumento.id,
                    codigo: tipoDocumento.codigo,
                    descripcion: tipoDocumento.descripcion
                }
            });
            
        } catch (error) {
            console.error('Error en deleteTipoDocumento:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al eliminar tipo de documento',
                error: error instanceof Error ? error.message : 'Error desconocido'
            });
        }
    }
}