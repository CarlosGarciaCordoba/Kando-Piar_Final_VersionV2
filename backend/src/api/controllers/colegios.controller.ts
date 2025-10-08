import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class ColegiosController {
    /**
     * Obtiene todos los colegios disponibles
     */
    static async getColegios(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id, codigo_institucion, nombre
                FROM colegios 
                WHERE estado = true
                ORDER BY nombre ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Colegios obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener colegios:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener colegios',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene un colegio por ID
     */
    static async getColegioById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            const query = `
                SELECT id, codigo_institucion, nombre
                FROM colegios 
                WHERE id = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Colegio no encontrado'
                });
                return;
            }
            
            res.json({
                success: true,
                data: result.rows[0],
                message: 'Colegio obtenido exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener colegio por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener colegio',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}