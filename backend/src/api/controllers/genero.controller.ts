import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class GeneroController {
    /**
     * Obtiene todos los géneros disponibles
     */
    static async getGeneros(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_genero, descripcion
                FROM generos 
                WHERE estado = true
                ORDER BY id_genero ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Géneros obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener géneros:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener géneros',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}