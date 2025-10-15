-- Script temporal para crear y poblar la tabla asignaturas_educacion_inicial
-- Fecha: 14 de octubre de 2025
-- Propósito: Agregar tabla de dimensiones/asignaturas para educación inicial (preescolar) en el sistema PIAR

-- Crear la tabla asignaturas_educacion_inicial
CREATE TABLE IF NOT EXISTS asignaturas_educacion_inicial (
    id_asignatura_inicial SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    dimension_tipo VARCHAR(50) NOT NULL,
    orden_dimension INTEGER NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar las dimensiones de educación inicial

-- Dimensión Comunicativa
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(1, 'Dimensión comunicativa', 'Desarrollo de habilidades comunicativas, lenguaje oral y escrito, expresión y comprensión', 'dimension_desarrollo', 1);

-- Dimensión Cognitiva  
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(2, 'Dimensión cognitiva', 'Desarrollo del pensamiento, procesos mentales, resolución de problemas y construcción del conocimiento', 'dimension_desarrollo', 2);

-- Dimensión Corporal
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(3, 'Dimensión corporal', 'Desarrollo motriz, esquema corporal, coordinación y expresión corporal', 'dimension_desarrollo', 3);

-- Dimensión Socioafectiva
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(4, 'Dimensión socioafectiva', 'Desarrollo emocional, relaciones interpersonales, autoestima y habilidades sociales', 'dimension_desarrollo', 4);

-- Dimensión Espiritual
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(5, 'Dimensión espiritual', 'Desarrollo de valores, trascendencia, sentido de vida y conexión con lo sagrado', 'dimension_desarrollo', 5);

-- Dimensión Ética
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(6, 'Dimensión ética', 'Desarrollo moral, valores, normas de convivencia y formación ciudadana', 'dimension_desarrollo', 6);

-- Dimensión Estética
INSERT INTO asignaturas_educacion_inicial (id_asignatura_inicial, nombre, descripcion, dimension_tipo, orden_dimension) VALUES
(7, 'Dimensión estética', 'Desarrollo artístico, apreciación de la belleza, creatividad y expresión artística', 'dimension_desarrollo', 7);

-- Crear índices para optimizar consultas
CREATE INDEX idx_asignaturas_inicial_dimension_tipo ON asignaturas_educacion_inicial(dimension_tipo);
CREATE INDEX idx_asignaturas_inicial_orden ON asignaturas_educacion_inicial(orden_dimension);
CREATE INDEX idx_asignaturas_inicial_estado ON asignaturas_educacion_inicial(estado);

-- Comentarios sobre la tabla
COMMENT ON TABLE asignaturas_educacion_inicial IS 'Tabla que almacena las dimensiones del desarrollo integral para educación inicial (preescolar) según lineamientos del MEN';
COMMENT ON COLUMN asignaturas_educacion_inicial.id_asignatura_inicial IS 'Identificador único de la dimensión de educación inicial';
COMMENT ON COLUMN asignaturas_educacion_inicial.nombre IS 'Nombre de la dimensión (Comunicativa, Cognitiva, etc.)';
COMMENT ON COLUMN asignaturas_educacion_inicial.descripcion IS 'Descripción detallada de la dimensión y sus objetivos';
COMMENT ON COLUMN asignaturas_educacion_inicial.dimension_tipo IS 'Tipo de dimensión (dimension_desarrollo)';
COMMENT ON COLUMN asignaturas_educacion_inicial.orden_dimension IS 'Orden secuencial de la dimensión';
COMMENT ON COLUMN asignaturas_educacion_inicial.estado IS 'Estado activo/inactivo de la dimensión';

-- Verificar que los datos se insertaron correctamente
SELECT 
    id_asignatura_inicial,
    nombre,
    dimension_tipo,
    orden_dimension,
    estado
FROM asignaturas_educacion_inicial 
ORDER BY orden_dimension;

-- Consulta para verificar todas las dimensiones activas
SELECT 
    COUNT(*) as total_dimensiones,
    STRING_AGG(nombre, ', ' ORDER BY orden_dimension) as dimensiones
FROM asignaturas_educacion_inicial 
WHERE estado = true;