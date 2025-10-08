import { body } from 'express-validator';

/**
 * Validador para el análisis de funciones cognitivas con Gemini
 * Verifica que se reciban los datos correctos para el análisis
 */
export const funcionesCognitivasValidator = [
    body('funcionesCognitivas')
        .isArray({ min: 1 })
        .withMessage('Se requiere al menos una función cognitiva para analizar'),
    
    body('funcionesCognitivas.*.pregunta')
        .notEmpty()
        .withMessage('Cada función cognitiva debe tener una pregunta')
        .isLength({ min: 5, max: 500 })
        .withMessage('La pregunta debe tener entre 5 y 500 caracteres'),
    
    body('funcionesCognitivas.*.respuesta')
        .notEmpty()
        .withMessage('Cada función cognitiva debe tener una respuesta')
        .isLength({ min: 1, max: 200 })
        .withMessage('La respuesta debe tener entre 1 y 200 caracteres'),
    
    body('funcionesCognitivas.*.categoria')
        .optional()
        .isLength({ min: 2, max: 50 })
        .withMessage('La categoría debe tener entre 2 y 50 caracteres')
];

/**
 * Validador simple para endpoints que no requieren body
 */
export const simpleValidator = [];