import { Request, Response } from 'express';
import { Pool } from 'pg';
import db from '../../config/database';

/**
 * Controlador para manejar las relaciones con el estudiante
 * Proporciona endpoints para obtener tipos de relaciones familiares y de apoyo
 */
export class RelacionesEstudianteController {
    
    /**
     * Obtiene todas las relaciones activas con el estudiante
     * GET /api/relaciones-estudiante
     */
    public static async getAllRelaciones(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    id_relacion as id,
                    nombre,
                    descripcion,
                    estado,
                    created_at,
                    updated_at
                FROM relaciones_estudiante 
                WHERE estado = true 
                ORDER BY id_relacion ASC
            `;
            
            const result = await db.query(query);
            
            res.status(200).json({
                success: true,
                message: 'Relaciones con el estudiante obtenidas exitosamente',
                data: result.rows,
                total: result.rows.length
            });
            
        } catch (error) {
            console.error('Error al obtener relaciones con el estudiante:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener relaciones con el estudiante',
                error: process.env.NODE_ENV === 'development' ? error : undefined
            });
        }
    }
    
    /**
     * Obtiene una relación específica por ID
     * GET /api/relaciones-estudiante/:id
     */
    public static async getRelacionById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            // Validar que el ID sea un número
            if (isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'El ID debe ser un número válido'
                });
                return;
            }
            
            const query = `
                SELECT 
                    id_relacion as id,
                    nombre,
                    descripcion,
                    estado,
                    created_at,
                    updated_at
                FROM relaciones_estudiante 
                WHERE id_relacion = $1 AND estado = true
            `;
            
            const result = await db.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Relación con el estudiante no encontrada'
                });
                return;
            }
            
            res.status(200).json({
                success: true,
                message: 'Relación con el estudiante obtenida exitosamente',
                data: result.rows[0]
            });
            
        } catch (error) {
            console.error('Error al obtener relación con el estudiante por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener la relación con el estudiante',
                error: process.env.NODE_ENV === 'development' ? error : undefined
            });
        }
    }
    
    /**
     * Obtiene solo los nombres de las relaciones para usar en selects del frontend
     * GET /api/relaciones-estudiante/nombres
     */
    public static async getNombresRelaciones(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    id_relacion as id,
                    nombre
                FROM relaciones_estudiante 
                WHERE estado = true 
                ORDER BY id_relacion ASC
            `;
            
            const result = await db.query(query);
            
            res.status(200).json({
                success: true,
                message: 'Nombres de relaciones obtenidos exitosamente',
                data: result.rows,
                total: result.rows.length
            });
            
        } catch (error) {
            console.error('Error al obtener nombres de relaciones:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener nombres de relaciones',
                error: process.env.NODE_ENV === 'development' ? error : undefined
            });
        }
    }
}