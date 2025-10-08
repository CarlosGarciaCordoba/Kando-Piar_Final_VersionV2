import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class NivelesEducativosController {
    /**
     * Obtiene todos los niveles educativos disponibles
     */
    static async getNivelesEducativos(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_nivel_educativo as id, nombre, descripcion
                FROM niveles_educativos 
                WHERE estado = true
                ORDER BY id_nivel_educativo ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Niveles educativos obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener niveles educativos:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener niveles educativos',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene un nivel educativo por ID
     */
    static async getNivelEducativoById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            const query = `
                SELECT id_nivel_educativo as id, nombre, descripcion
                FROM niveles_educativos 
                WHERE id_nivel_educativo = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Nivel educativo no encontrado'
                });
                return;
            }
            
            res.json({
                success: true,
                data: result.rows[0],
                message: 'Nivel educativo obtenido exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener nivel educativo por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener nivel educativo',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}