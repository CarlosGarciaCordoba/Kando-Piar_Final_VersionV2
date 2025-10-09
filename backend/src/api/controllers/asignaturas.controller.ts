import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class AsignaturasController {
    /**
     * Obtiene todas las asignaturas disponibles
     */
    static async getAsignaturas(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_asignatura, nombre, descripcion
                FROM asignaturas 
                WHERE estado = true
                ORDER BY id_asignatura ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Asignaturas obtenidas exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener asignaturas:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener asignaturas',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}