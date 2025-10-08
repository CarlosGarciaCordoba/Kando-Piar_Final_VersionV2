import { Request, Response } from 'express';
import pool from '../../config/database';

export class FrecuenciasRehabilitacionController {
    
    /**
     * Obtiene todas las frecuencias de rehabilitación activas
     */
    public async getFrecuenciasRehabilitacion(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    id_frecuencia,
                    nombre,
                    descripcion,
                    estado,
                    created_at,
                    updated_at
                FROM frecuencias_rehabilitacion 
                WHERE estado = true 
                ORDER BY id_frecuencia ASC
            `;
            
            const result = await pool.query(query);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'No se encontraron frecuencias de rehabilitación disponibles',
                    data: []
                });
                return;
            }

            res.status(200).json({
                success: true,
                message: 'Frecuencias de rehabilitación obtenidas exitosamente',
                data: result.rows,
                total: result.rows.length
            });

        } catch (error) {
            console.error('Error al obtener frecuencias de rehabilitación:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener las frecuencias de rehabilitación',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene una frecuencia de rehabilitación específica por ID
     */
    public async getFrecuenciaRehabilitacionById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            // Validar que el ID sea un número
            if (isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'El ID de la frecuencia debe ser un número válido'
                });
                return;
            }

            const query = `
                SELECT 
                    id_frecuencia,
                    nombre,
                    descripcion,
                    estado,
                    created_at,
                    updated_at
                FROM frecuencias_rehabilitacion 
                WHERE id_frecuencia = $1 AND estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: `No se encontró la frecuencia de rehabilitación con ID ${id}`
                });
                return;
            }

            res.status(200).json({
                success: true,
                message: 'Frecuencia de rehabilitación obtenida exitosamente',
                data: result.rows[0]
            });

        } catch (error) {
            console.error('Error al obtener frecuencia de rehabilitación por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener la frecuencia de rehabilitación',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}