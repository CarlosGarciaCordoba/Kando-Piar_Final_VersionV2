import { Request, Response } from 'express';
import pool from '../../config/database';

export class DepartamentoController {
    /**
     * Obtiene todos los departamentos disponibles
     */
    static async getDepartamentos(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT id_departamento, descripcion
                FROM departamentos 
                WHERE estado = true
                ORDER BY descripcion ASC
            `;
            
            const result = await pool.query(query);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Departamentos obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener departamentos:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener departamentos',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }

    /**
     * Obtiene los municipios de un departamento específico
     */
    static async getMunicipiosByDepartamento(req: Request, res: Response): Promise<void> {
        try {
            const { id_departamento } = req.params;
            
            const query = `
                SELECT id_municipio, descripcion
                FROM municipios 
                WHERE id_departamento = $1 AND estado = true
                ORDER BY descripcion ASC
            `;
            
            const result = await pool.query(query, [id_departamento]);
            
            res.json({
                success: true,
                data: result.rows,
                message: 'Municipios obtenidos exitosamente'
            });
            
        } catch (error) {
            console.error('Error al obtener municipios:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener municipios',
                error: process.env.NODE_ENV === 'development' ? error : {}
            });
        }
    }
}