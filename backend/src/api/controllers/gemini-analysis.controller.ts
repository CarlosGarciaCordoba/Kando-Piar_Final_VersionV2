import { Request, Response } from 'express';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Inicializar Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

interface FuncionCognitiva {
    pregunta: string;
    respuesta: string;
    categoria: string;
}

export const analizarFuncionesCognitivas = async (req: Request, res: Response) => {
    try {
        const { funcionesCognitivas } = req.body;

        // Validar que se recibieron los datos
        if (!funcionesCognitivas || !Array.isArray(funcionesCognitivas) || funcionesCognitivas.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'Se requieren datos de funciones cognitivas para el análisis'
            });
        }

        // Verificar que la API key esté configurada
        if (!process.env.GEMINI_API_KEY || process.env.GEMINI_API_KEY === 'YOUR_GEMINI_API_KEY_HERE') {
            return res.status(500).json({
                success: false,
                message: 'API key de Gemini no configurada correctamente'
            });
        }

        // Preparar el prompt para Gemini
        const prompt = construirPromptAnalisis(funcionesCognitivas);

        // Obtener el modelo Gemini 2.5 Flash
        const model = genAI.getGenerativeModel({ 
            model: process.env.GEMINI_MODEL || 'gemini-2.5-flash' 
        });

        // Generar el análisis
        const result = await model.generateContent(prompt);
        const response = await result.response;
        let analisis = response.text();

        // Limpiar referencias a IA/Gemini
        analisis = limpiarRespuesta(analisis);

        // Responder con el análisis completo
        res.json({
            success: true,
            message: 'Análisis completado exitosamente',
            data: {
                analisis: analisis,
                timestamp: new Date().toISOString(),
                totalPreguntas: funcionesCognitivas.length,
                palabrasGeneradas: contarPalabras(analisis)
            }
        });

    } catch (error: any) {
        console.error('Error en análisis de funciones cognitivas:', error);
        
        // Manejar errores específicos de la API de Gemini
        if (error.message?.includes('API_KEY_INVALID')) {
            return res.status(401).json({
                success: false,
                message: 'API key de Gemini inválida'
            });
        }

        if (error.message?.includes('QUOTA_EXCEEDED')) {
            return res.status(429).json({
                success: false,
                message: 'Cuota de API de Gemini excedida'
            });
        }

        res.status(500).json({
            success: false,
            message: 'Error interno al realizar el análisis con IA'
        });
    }
};

function construirPromptAnalisis(funcionesCognitivas: FuncionCognitiva[]): string {
    let prompt = `
Actúa como un especialista en psicología educativa y neuropsicología infantil. Tu tarea es analizar las respuestas de un estudiante en el área de "Funciones Cognitivas Básicas Para Aprender" dentro del contexto de un Plan Individual de Ajustes Razonables (PIAR) en Colombia.

CONTEXTO:
El PIAR es un documento que garantiza los procesos de enseñanza y aprendizaje de los estudiantes, basados en la valoración pedagógica y social, que incluye los apoyos y ajustes razonables requeridos, entre ellos los curriculares, de infraestructura y todos los demás necesarios para garantizar el aprendizaje, la participación, permanencia y promoción del estudiante.

FUNCIONES COGNITIVAS EVALUADAS:
`;

    // Agrupar por categorías para mejor análisis
    const categorias = agruparPorCategorias(funcionesCognitivas);
    
    Object.keys(categorias).forEach(categoria => {
        prompt += `\n--- ${categoria.toUpperCase()} ---\n`;
        categorias[categoria].forEach((item, index) => {
            prompt += `${index + 1}. ${item.pregunta}\n   Respuesta: ${item.respuesta}\n`;
        });
    });

    prompt += `

INSTRUCCIONES PARA EL ANÁLISIS:
1. Genera un RESUMEN COMPLETO Y PRECISO de las funciones cognitivas del estudiante
2. Sé conciso pero asegúrate de incluir toda la información relevante
3. Identifica las fortalezas y áreas de oportunidad más importantes
4. Incluye recomendaciones pedagógicas específicas y prácticas
5. Considera el contexto educativo colombiano y las normativas de educación inclusiva
6. Mantén un lenguaje profesional pero comprensible para educadores
7. Estructura tu respuesta de manera clara y organizada
8. Prioriza la COMPLETITUD y PRECISIÓN sobre la extensión
9. Evita información genérica, enfócate en lo específico del perfil evaluado

FORMATO DE RESPUESTA ESPERADO:
**PERFIL COGNITIVO DEL ESTUDIANTE:**
[Resumen ejecutivo conciso del perfil general]

**FORTALEZAS PRINCIPALES:**
[Capacidades destacadas identificadas en la evaluación]

**ÁREAS QUE REQUIEREN APOYO:**
[Aspectos específicos que necesitan atención o refuerzo]

**RECOMENDACIONES PEDAGÓGICAS:**
[Estrategias concretas y aplicables para el aula]

**AJUSTES SUGERIDOS:**
[Modificaciones específicas recomendadas para optimizar el aprendizaje]

Proporciona un resumen completo y preciso, sin información genérica. Enfócate en los hallazgos específicos basados en las respuestas del estudiante evaluado.`;

    return prompt;
}

function agruparPorCategorias(funcionesCognitivas: FuncionCognitiva[]): { [key: string]: FuncionCognitiva[] } {
    const categorias: { [key: string]: FuncionCognitiva[] } = {};
    
    funcionesCognitivas.forEach(item => {
        const categoria = item.categoria || 'General';
        if (!categorias[categoria]) {
            categorias[categoria] = [];
        }
        categorias[categoria].push(item);
    });
    
    return categorias;
}

function contarPalabras(texto: string): number {
    return texto.trim().split(/\s+/).filter(word => word.length > 0).length;
}

function limitarPalabras(texto: string, maxPalabras: number): string {
    const palabras = texto.trim().split(/\s+/);
    if (palabras.length <= maxPalabras) {
        return texto;
    }
    
    const textoTruncado = palabras.slice(0, maxPalabras).join(' ');
    return textoTruncado + '\n\n[Análisis truncado para cumplir el límite de palabras establecido]';
}

function limpiarRespuesta(analisis: string): string {
    // Eliminar cualquier referencia a IA, Gemini, o sistemas automatizados
    let analisisLimpio = analisis
        .replace(/.*gemini.*\n?/gi, '')
        .replace(/.*inteligencia artificial.*\n?/gi, '')
        .replace(/.*\bIA\b.*\n?/gi, '')
        .replace(/.*generado automáticamente.*\n?/gi, '')
        .replace(/.*sistema automatizado.*\n?/gi, '')
        .replace(/.*análisis generado por.*\n?/gi, '')
        .replace(/.*este análisis fue.*\n?/gi, '')
        .replace(/.*modelo de lenguaje.*\n?/gi, '')
        .replace(/.*asistente virtual.*\n?/gi, '')
        .replace(/.*sistema de.*IA.*\n?/gi, '')
        .trim();
    
    return analisisLimpio;
}

// Endpoint para verificar la configuración de Gemini
export const verificarConfiguracionGemini = async (req: Request, res: Response) => {
    try {
        if (!process.env.GEMINI_API_KEY || process.env.GEMINI_API_KEY === 'YOUR_GEMINI_API_KEY_HERE') {
            return res.status(400).json({
                success: false,
                message: 'API key de Gemini no configurada',
                configured: false
            });
        }

        // Hacer una prueba simple con Gemini
        const model = genAI.getGenerativeModel({ 
            model: process.env.GEMINI_MODEL || 'gemini-2.5-flash' 
        });

        const result = await model.generateContent('Responde solo "OK" si recibes este mensaje.');
        const response = await result.response;
        
        res.json({
            success: true,
            message: 'Configuración de Gemini verificada correctamente',
            configured: true,
            model: process.env.GEMINI_MODEL || 'gemini-2.5-flash',
            testResponse: response.text()
        });

    } catch (error: any) {
        console.error('Error verificando configuración de Gemini:', error);
        res.status(500).json({
            success: false,
            message: 'Error al verificar la configuración de Gemini',
            configured: false,
            error: error.message
        });
    }
};