import { Request, Response } from 'express';
import { Pool } from 'pg';
import pool from '../../config/database';

export class BarrerasController {
    /**
     * Obtiene todas las barreras por categoría SIMAT
     */
    static async getBarrerasByCategoria(req: Request, res: Response): Promise<void> {
        try {
            const { categoriaId } = req.params;
            
            // Validar que el ID sea un número válido
            if (!categoriaId || isNaN(Number(categoriaId))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de categoría SIMAT inválido'
                });
                return;
            }

            const query = `
                SELECT 
                    b.id_barrera,
                    b.tipo_barrera,
                    b.situacion_observable,
                    b.impacto,
                    b.ajustes_estrategias,
                    b.orden,
                    cs.nombre as categoria_nombre
                FROM barreras b
                INNER JOIN categorias_simat cs ON b.id_categoria_simat = cs.id_categoria_simat
                WHERE b.id_categoria_simat = $1 AND b.estado = true
                ORDER BY b.orden ASC
            `;
            
            const result = await pool.query(query, [categoriaId]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'No se encontraron barreras para esta categoría SIMAT'
                });
                return;
            }

            // Organizar las barreras por tipo
            const barrerasOrganizadas: { [key: string]: any } = {};
            
            result.rows.forEach((barrera) => {
                const tipoNormalizado = barrera.tipo_barrera.toLowerCase()
                    .replace(/\s+/g, '_')
                    .replace(/[áàäâ]/g, 'a')
                    .replace(/[éèëê]/g, 'e')
                    .replace(/[íìïî]/g, 'i')
                    .replace(/[óòöô]/g, 'o')
                    .replace(/[úùüû]/g, 'u')
                    .replace(/ñ/g, 'n');

                barrerasOrganizadas[tipoNormalizado] = {
                    id: barrera.id_barrera,
                    tipo: barrera.tipo_barrera,
                    situacion_observable: barrera.situacion_observable,
                    impacto: barrera.impacto,
                    ajustes_estrategias: barrera.ajustes_estrategias,
                    orden: barrera.orden
                };
            });

            res.json({
                success: true,
                data: {
                    categoria_id: categoriaId,
                    categoria_nombre: result.rows[0].categoria_nombre,
                    barreras: barrerasOrganizadas,
                    total_barreras: result.rows.length
                },
                message: 'Barreras obtenidas exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener barreras por categoría:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener barreras',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene todas las barreras disponibles
     */
    static async getAllBarreras(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    b.id_barrera,
                    b.id_categoria_simat,
                    b.tipo_barrera,
                    b.situacion_observable,
                    b.impacto,
                    b.ajustes_estrategias,
                    b.orden,
                    cs.nombre as categoria_nombre
                FROM barreras b
                INNER JOIN categorias_simat cs ON b.id_categoria_simat = cs.id_categoria_simat
                WHERE b.estado = true
                ORDER BY b.id_categoria_simat ASC, b.orden ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Todas las barreras obtenidas exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener todas las barreras:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener barreras',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene una barrera específica por ID
     */
    static async getBarreraById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            
            if (!id || isNaN(Number(id))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de barrera inválido'
                });
                return;
            }

            const query = `
                SELECT 
                    b.id_barrera,
                    b.id_categoria_simat,
                    b.tipo_barrera,
                    b.situacion_observable,
                    b.impacto,
                    b.ajustes_estrategias,
                    b.orden,
                    cs.nombre as categoria_nombre
                FROM barreras b
                INNER JOIN categorias_simat cs ON b.id_categoria_simat = cs.id_categoria_simat
                WHERE b.id_barrera = $1 AND b.estado = true
            `;
            
            const result = await pool.query(query, [id]);
            
            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'Barrera no encontrada'
                });
                return;
            }

            res.json({
                success: true,
                data: result.rows[0],
                message: 'Barrera obtenida exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener barrera por ID:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener barrera',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}