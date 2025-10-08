import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class GruposEtnicosController {
    /**
     * Obtiene todos los grupos étnicos disponibles
     */
    static async getGruposEtnicos(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_grupo_etnico, nombre, descripcion
                FROM grupos_etnicos 
                WHERE estado = true
                ORDER BY id_grupo_etnico ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Grupos étnicos obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener grupos étnicos:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener grupos étnicos',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene un grupo étnico específico por ID
     */
    static async getGrupoEtnicoById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            // Validar que el ID sea un número válido
            if (!id || isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de grupo étnico inválido'
                });
                return;
            }

            const query = `
                SELECT id_grupo_etnico, nombre, descripcion, created_at, updated_at
                FROM grupos_etnicos 
                WHERE id_grupo_etnico = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Grupo étnico no encontrado'
                });
                return;
            }

            res.json({
                success: true,
                data: result.rows[0],
                message: 'Grupo étnico obtenido exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener grupo étnico por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener grupo étnico',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}