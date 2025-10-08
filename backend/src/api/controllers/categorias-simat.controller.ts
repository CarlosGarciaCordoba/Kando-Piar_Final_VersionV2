import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class CategoriasSIMATController {
    /**
     * Obtiene todas las categorías SIMAT disponibles
     */
    static async getCategoriasSIMAT(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_categoria_simat, nombre, descripcion
                FROM categorias_simat 
                WHERE estado = true
                ORDER BY id_categoria_simat ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Categorías SIMAT obtenidas exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener categorías SIMAT:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener categorías SIMAT',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene una categoría SIMAT específica por ID
     */
    static async getCategoriaSIMATById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            // Validar que el ID sea un número válido
            if (!id || isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de categoría SIMAT inválido'
                });
                return;
            }

            const query = `
                SELECT id_categoria_simat, nombre, descripcion, created_at, updated_at
                FROM categorias_simat 
                WHERE id_categoria_simat = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Categoría SIMAT no encontrada'
                });
                return;
            }

            res.json({
                success: true,
                data: result.rows[0],
                message: 'Categoría SIMAT obtenida exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener categoría SIMAT por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener categoría SIMAT',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}