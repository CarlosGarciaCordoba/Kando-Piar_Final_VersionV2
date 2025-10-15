import { Request, Response } from 'express';
import pool from '../../config/database';

export class AsignaturasEducacionInicialController {
    /**
     * Obtener todas las dimensiones de educación inicial activas
     */
    static async getAsignaturasEducacionInicial(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    id_asignatura_inicial,
                    nombre,
                    descripcion,
                    dimension_tipo,
                    orden_dimension,
                    estado
                FROM asignaturas_educacion_inicial 
                WHERE estado = true 
                ORDER BY orden_dimension ASC
            `;

            const result = await pool.query(query);

            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'No se encontraron dimensiones de educación inicial'
                });
                return;
            }

            res.status(200).json({
                success: true,
                message: 'Dimensiones de educación inicial obtenidas exitosamente',
                data: result.rows
            });

        } catch (error) {
            console.error('Error al obtener dimensiones de educación inicial:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener las dimensiones'
            });
        }
    }

    /**
     * Obtener una dimensión específica por ID
     */
    static async getAsignaturaEducacionInicialById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;

            if (!id || isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de dimensión inválido'
                });
                return;
            }

            const query = `
                SELECT 
                    id_asignatura_inicial,
                    nombre,
                    descripcion,
                    dimension_tipo,
                    orden_dimension,
                    estado,
                    fecha_creacion,
                    fecha_actualizacion
                FROM asignaturas_educacion_inicial 
                WHERE id_asignatura_inicial = $1 AND estado = true
            `;

            const result = await pool.query(query, [id]);

            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Dimensión de educación inicial no encontrada'
                });
                return;
            }

            res.status(200).json({
                success: true,
                message: 'Dimensión encontrada exitosamente',
                data: result.rows[0]
            });

        } catch (error) {
            console.error('Error al obtener dimensión por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }

    /**
     * Obtener resumen de dimensiones por tipo
     */
    static async getResumenDimensiones(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    dimension_tipo,
                    COUNT(*) as total_dimensiones,
                    STRING_AGG(nombre, ', ' ORDER BY orden_dimension) as dimensiones
                FROM asignaturas_educacion_inicial 
                WHERE estado = true
                GROUP BY dimension_tipo
                ORDER BY dimension_tipo
            `;

            const result = await pool.query(query);

            res.status(200).json({
                success: true,
                message: 'Resumen de dimensiones obtenido exitosamente',
                data: result.rows
            });

        } catch (error) {
            console.error('Error al obtener resumen de dimensiones:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }
}