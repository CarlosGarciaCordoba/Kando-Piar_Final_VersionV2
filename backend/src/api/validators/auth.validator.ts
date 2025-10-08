import { body } from 'express-validator';

/**
 * Validador para la ruta de login
 * Verifica que el código de usuario, contraseña y código de institución cumplan con los requisitos
 */
export const loginValidator = [
    body('userCode')
        .notEmpty()
        .withMessage('El código de usuario es requerido')
        .trim()
        .isLength({ min: 2, max: 3 })
        .withMessage('El código de usuario debe tener entre 2 y 3 caracteres')
        .matches(/^[A-Z0-9]+$/)
        .withMessage('El código de usuario solo puede contener letras mayúsculas y números'),

    body('password')
        .notEmpty()
        .withMessage('La contraseña es requerida'),

    body('institution')
        .notEmpty()
        .withMessage('El código de institución es requerido')
        .trim()
        .isLength({ min: 3, max: 15 })
        .withMessage('El código de institución debe tener entre 3 y 15 caracteres')
        .matches(/^[A-Z0-9]+$/)
        .withMessage('El código de institución solo puede contener letras mayúsculas y números')
];

export const recoverPasswordValidator = [
    body('email')
        .notEmpty().withMessage('El correo es requerido')
        .isEmail().withMessage('Correo inválido')
];

export const resetPasswordValidator = [
    body('token')
        .notEmpty().withMessage('Token requerido')
        .isLength({ min: 32 }).withMessage('Token inválido'),
    body('newPassword')
        .notEmpty().withMessage('Nueva contraseña requerida')
        .isLength({ min: 8 }).withMessage('Debe tener mínimo 8 caracteres')
];
