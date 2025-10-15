-- Script temporal para crear y poblar la tabla grados_piar
-- Fecha: 14 de octubre de 2025
-- Propósito: Agregar tabla de grados académicos para el sistema PIAR

-- Crear la tabla grados_piar
CREATE TABLE IF NOT EXISTS grados_piar (
    id_grado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    nivel_educativo VARCHAR(20) NOT NULL CHECK (nivel_educativo IN ('preescolar', 'basica', 'media')),
    orden_grado INTEGER NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar los grados académicos
-- Preescolar
INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(1, 'Pre-Jardín', 'Nivel de educación inicial para niños de 3 años', 'preescolar', 1);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(2, 'Jardín', 'Nivel de educación inicial para niños de 4 años', 'preescolar', 2);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(3, 'Transición', 'Nivel de educación inicial para niños de 5 años', 'preescolar', 3);

-- Básica
INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(4, '1°', 'Primer grado de educación básica', 'basica', 4);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(5, '2°', 'Segundo grado de educación básica', 'basica', 5);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(6, '3°', 'Tercer grado de educación básica', 'basica', 6);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(7, '4°', 'Cuarto grado de educación básica', 'basica', 7);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(8, '5°', 'Quinto grado de educación básica', 'basica', 8);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(9, '6°', 'Sexto grado de educación básica', 'basica', 9);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(10, '7°', 'Séptimo grado de educación básica', 'basica', 10);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(11, '8°', 'Octavo grado de educación básica', 'basica', 11);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(12, '9°', 'Noveno grado de educación básica', 'basica', 12);

-- Media
INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(13, '10°', 'Décimo grado de educación media', 'media', 13);

INSERT INTO grados_piar (id_grado, nombre, descripcion, nivel_educativo, orden_grado) VALUES
(14, '11°', 'Undécimo grado de educación media', 'media', 14);

-- Crear índices para optimizar consultas
CREATE INDEX idx_grados_piar_nivel_educativo ON grados_piar(nivel_educativo);
CREATE INDEX idx_grados_piar_orden_grado ON grados_piar(orden_grado);
CREATE INDEX idx_grados_piar_estado ON grados_piar(estado);

-- Comentarios sobre la tabla
COMMENT ON TABLE grados_piar IS 'Tabla que almacena los grados académicos del sistema educativo colombiano para el sistema PIAR';
COMMENT ON COLUMN grados_piar.id_grado IS 'Identificador único del grado académico';
COMMENT ON COLUMN grados_piar.nombre IS 'Nombre del grado (Pre-Jardín, Jardín, etc.)';
COMMENT ON COLUMN grados_piar.descripcion IS 'Descripción detallada del grado académico';
COMMENT ON COLUMN grados_piar.nivel_educativo IS 'Nivel educativo: preescolar, basica, media';
COMMENT ON COLUMN grados_piar.orden_grado IS 'Orden secuencial del grado en el sistema educativo';
COMMENT ON COLUMN grados_piar.estado IS 'Estado activo/inactivo del grado';

-- Verificar que los datos se insertaron correctamente
SELECT 
    id_grado,
    nombre,
    nivel_educativo,
    orden_grado,
    estado
FROM grados_piar 
ORDER BY orden_grado;

-- Consulta para verificar por nivel educativo
SELECT 
    nivel_educativo,
    COUNT(*) as cantidad_grados,
    STRING_AGG(nombre, ', ' ORDER BY orden_grado) as grados
FROM grados_piar 
WHERE estado = true
GROUP BY nivel_educativo
ORDER BY MIN(orden_grado);