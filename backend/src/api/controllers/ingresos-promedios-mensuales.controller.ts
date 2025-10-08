import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class IngresosPromediosMensualesController {
    /**
     * Obtiene todos los rangos de ingresos promedios mensuales disponibles
     */
    static async getIngresosPromediosMensuales(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_ingreso as id, nombre, descripcion
                FROM ingresos_promedios_mensuales 
                WHERE estado = true
                ORDER BY id_ingreso ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Ingresos promedios mensuales obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener ingresos promedios mensuales:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener ingresos promedios mensuales',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene un rango de ingresos por ID
     */
    static async getIngresoPromedioMensualById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            const query = `
                SELECT id_ingreso as id, nombre, descripcion
                FROM ingresos_promedios_mensuales 
                WHERE id_ingreso = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Rango de ingresos no encontrado'
                });
                return;
            }
            
            res.json({
                success: true,
                data: result.rows[0],
                message: 'Rango de ingresos obtenido exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener rango de ingresos por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener rango de ingresos',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}