import { Request, Response, NextFunction } from 'express';

/**
 * Middleware global de manejo de errores.
 * Cualquier error pasado a next(err) o lanzado en rutas async cae aquí.
 */
export function errorHandler(err: any, _req: Request, res: Response, _next: NextFunction) {
  console.error('💥 Error no controlado:', err);
  const status = err.status || 500;
  res.status(status).json({
    success: false,
    message: err.message || 'Error interno del servidor'
  });
}