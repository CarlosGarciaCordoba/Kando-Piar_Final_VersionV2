import { Request, Response } from 'express';
import pool from '../../config/database';

export class EpsController {
    /**
     * Obtiene todas las EPS disponibles
     */
    static async getEps(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_eps, nombre, descripcion
                FROM eps 
                WHERE estado = true
                ORDER BY 
                    CASE 
                        WHEN LOWER(nombre) = 'otro' THEN 1 
                        ELSE 0 
                    END ASC,
                    nombre ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'EPS obtenidas exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener EPS:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener EPS',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene una EPS específica por ID
     */
    static async getEpsById(req: Request, res: Response): Promise<void> {
        try {
            const { id_eps } = req.params;
            
            const query = `
                SELECT id_eps, nombre, descripcion, estado
                FROM eps 
                WHERE id_eps = $1
            `;
            
            const result = await pool.query(query, [id_eps]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'EPS no encontrada'
                });
                return;
            }
            
            res.json({
                success: true,
                data: result.rows[0],
                message: 'EPS obtenida exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener EPS por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener EPS',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}