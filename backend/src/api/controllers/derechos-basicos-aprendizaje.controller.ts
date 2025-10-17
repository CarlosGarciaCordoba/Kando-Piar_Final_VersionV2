import { Request, Response } from 'express';
import pool from '../../config/database';

export class DerechosBasicosAprendizajeController {
    /**
     * Obtener todos los DBA de una asignatura y grado específico
     */
    static async getDbaByAsignaturaAndGrado(req: Request, res: Response): Promise<void> {
        try {
            const { idAsignatura, idGrado } = req.params;

            if (!idAsignatura || !idGrado || isNaN(Number(idAsignatura)) || isNaN(Number(idGrado))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de asignatura y grado son requeridos y deben ser números válidos'
                });
                return;
            }

            const query = `
                SELECT 
                    dba.id_dba,
                    dba.numero_dba,
                    dba.titulo,
                    dba.descripcion,
                    a.nombre as asignatura,
                    g.nombre as grado,
                    COUNT(ev.id_evidencia) as total_evidencias
                FROM derechos_basicos_aprendizaje dba
                INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
                INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
                LEFT JOIN evidencias_aprendizaje ev ON dba.id_dba = ev.id_dba AND ev.estado = true
                WHERE dba.id_asignatura = $1 
                    AND dba.id_grado = $2 
                    AND dba.estado = true
                    AND a.estado = true
                    AND g.estado = true
                GROUP BY dba.id_dba, dba.numero_dba, dba.titulo, dba.descripcion, a.nombre, g.nombre
                ORDER BY dba.numero_dba ASC
            `;

            const result = await pool.query(query, [idAsignatura, idGrado]);

            if (result.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'No se encontraron DBA para la asignatura y grado especificados'
                });
                return;
            }

            res.status(200).json({
                success: true,
                message: 'DBA obtenidos exitosamente',
                data: {
                    asignatura: result.rows[0].asignatura,
                    grado: result.rows[0].grado,
                    dba: result.rows.map(row => ({
                        id_dba: row.id_dba,
                        numero_dba: row.numero_dba,
                        titulo: row.titulo,
                        descripcion: row.descripcion,
                        total_evidencias: row.total_evidencias
                    }))
                }
            });

        } catch (error) {
            console.error('Error al obtener DBA:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor al obtener los DBA'
            });
        }
    }

    /**
     * Obtener un DBA específico con todas sus evidencias
     */
    static async getDbaWithEvidencias(req: Request, res: Response): Promise<void> {
        try {
            const { idDba } = req.params;

            if (!idDba || isNaN(Number(idDba))) {
                res.status(400).json({
                    success: false,
                    message: 'ID de DBA inválido'
                });
                return;
            }

            const queryDba = `
                SELECT 
                    dba.id_dba,
                    dba.numero_dba,
                    dba.titulo,
                    dba.descripcion,
                    a.nombre as asignatura,
                    g.nombre as grado
                FROM derechos_basicos_aprendizaje dba
                INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
                INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
                WHERE dba.id_dba = $1 AND dba.estado = true
            `;

            const queryEvidencias = `
                SELECT 
                    id_evidencia,
                    numero_evidencia,
                    descripcion
                FROM evidencias_aprendizaje
                WHERE id_dba = $1 AND estado = true
                ORDER BY numero_evidencia ASC
            `;

            const [dbaResult, evidenciasResult] = await Promise.all([
                pool.query(queryDba, [idDba]),
                pool.query(queryEvidencias, [idDba])
            ]);

            if (dbaResult.rows.length === 0) {
                res.status(404).json({
                    success: false,
                    message: 'DBA no encontrado'
                });
                return;
            }

            const dba = dbaResult.rows[0];
            const evidencias = evidenciasResult.rows;

            res.status(200).json({
                success: true,
                message: 'DBA con evidencias obtenido exitosamente',
                data: {
                    id_dba: dba.id_dba,
                    numero_dba: dba.numero_dba,
                    titulo: dba.titulo,
                    descripcion: dba.descripcion,
                    asignatura: dba.asignatura,
                    grado: dba.grado,
                    evidencias: evidencias
                }
            });

        } catch (error) {
            console.error('Error al obtener DBA con evidencias:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }

    /**
     * Obtener todas las asignaturas y grados que tienen DBA disponibles
     */
    static async getAsignaturasGradosConDba(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT DISTINCT
                    a.id_asignatura,
                    a.nombre as asignatura,
                    g.id_grado,
                    g.nombre as grado,
                    g.nivel_educativo,
                    g.orden_grado,
                    COUNT(dba.id_dba) as total_dba
                FROM derechos_basicos_aprendizaje dba
                INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
                INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
                WHERE dba.estado = true AND a.estado = true AND g.estado = true
                GROUP BY a.id_asignatura, a.nombre, g.id_grado, g.nombre, g.nivel_educativo, g.orden_grado
                ORDER BY a.nombre, g.orden_grado
            `;

            const result = await pool.query(query);

            res.status(200).json({
                success: true,
                message: 'Asignaturas y grados con DBA obtenidos exitosamente',
                data: result.rows
            });

        } catch (error) {
            console.error('Error al obtener asignaturas y grados con DBA:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }

    /**
     * Buscar DBA por palabra clave
     */
    static async buscarDba(req: Request, res: Response): Promise<void> {
        try {
            const { q } = req.query; // Query parameter para búsqueda

            if (!q || typeof q !== 'string' || q.trim().length < 3) {
                res.status(400).json({
                    success: false,
                    message: 'El término de búsqueda debe tener al menos 3 caracteres'
                });
                return;
            }

            const searchTerm = `%${q.trim().toLowerCase()}%`;

            const query = `
                SELECT 
                    dba.id_dba,
                    dba.numero_dba,
                    dba.titulo,
                    dba.descripcion,
                    a.nombre as asignatura,
                    g.nombre as grado,
                    g.nivel_educativo
                FROM derechos_basicos_aprendizaje dba
                INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
                INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
                WHERE (
                    LOWER(dba.titulo) LIKE $1 
                    OR LOWER(dba.descripcion) LIKE $1
                    OR EXISTS (
                        SELECT 1 FROM evidencias_aprendizaje ev 
                        WHERE ev.id_dba = dba.id_dba 
                        AND LOWER(ev.descripcion) LIKE $1 
                        AND ev.estado = true
                    )
                )
                AND dba.estado = true AND a.estado = true AND g.estado = true
                ORDER BY a.nombre, g.orden_grado, dba.numero_dba
                LIMIT 50
            `;

            const result = await pool.query(query, [searchTerm]);

            res.status(200).json({
                success: true,
                message: `Se encontraron ${result.rows.length} DBA que coinciden con la búsqueda`,
                data: result.rows
            });

        } catch (error) {
            console.error('Error al buscar DBA:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }

    /**
     * Obtener estadísticas de DBA por nivel educativo
     */
    static async getEstadisticasDba(req: Request, res: Response): Promise<void> {
        try {
            const query = `
                SELECT 
                    g.nivel_educativo,
                    COUNT(DISTINCT a.id_asignatura) as total_asignaturas,
                    COUNT(DISTINCT g.id_grado) as total_grados,
                    COUNT(dba.id_dba) as total_dba,
                    COUNT(ev.id_evidencia) as total_evidencias
                FROM derechos_basicos_aprendizaje dba
                INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
                INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
                LEFT JOIN evidencias_aprendizaje ev ON dba.id_dba = ev.id_dba AND ev.estado = true
                WHERE dba.estado = true AND a.estado = true AND g.estado = true
                GROUP BY g.nivel_educativo
                ORDER BY 
                    CASE g.nivel_educativo
                        WHEN 'preescolar' THEN 1
                        WHEN 'basica' THEN 2
                        WHEN 'media' THEN 3
                        ELSE 4
                    END
            `;

            const result = await pool.query(query);

            res.status(200).json({
                success: true,
                message: 'Estadísticas de DBA obtenidas exitosamente',
                data: result.rows
            });

        } catch (error) {
            console.error('Error al obtener estadísticas de DBA:', error);
            res.status(500).json({
                success: false,
                message: 'Error interno del servidor'
            });
        }
    }
}