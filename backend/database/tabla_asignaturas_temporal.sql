-- =============================================
-- TABLA ASIGNATURAS - ARCHIVO TEMPORAL
-- Para agregar manualmente a la base de datos
-- =============================================

-- =============================================
-- TABLA ASIGNATURAS
-- Parametrización para las asignaturas académicas del sistema educativo
-- =============================================
CREATE TABLE asignaturas (
    id_asignatura INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- ÍNDICES PARA TABLA ASIGNATURAS
-- =============================================
CREATE INDEX idx_asignaturas_nombre ON asignaturas(nombre);

-- =============================================
-- TRIGGER PARA TABLA ASIGNATURAS
-- =============================================
CREATE TRIGGER update_asignaturas_updated_at 
    BEFORE UPDATE ON asignaturas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- DATOS INICIALES - ASIGNATURAS
-- =============================================
INSERT INTO asignaturas (id_asignatura, nombre, descripcion, estado) VALUES 
(1, 'Lengua Castellana', 'Asignatura de lengua y literatura castellana', true),
(2, 'Matemáticas', 'Asignatura de matemáticas y álgebra', true),
(3, 'Ciencias Naturales', 'Asignatura de ciencias naturales y biología', true),
(4, 'Ciencias Sociales', 'Asignatura de ciencias sociales e historia', true),
(5, 'Educación Artística', 'Asignatura de educación artística y cultural', true),
(6, 'Educación Física, Recreación y Deporte', 'Asignatura de educación física y deportes', true),
(7, 'Educación Religiosa o Ética y Valores', 'Asignatura de religión, ética y valores', true),
(8, 'Filosofía', 'Asignatura de filosofía', true),
(9, 'Química', 'Asignatura de química', true),
(10, 'Física', 'Asignatura de física', true);

-- =============================================
-- CONSULTAS DE VERIFICACIÓN
-- =============================================
-- Para verificar que la tabla se creó correctamente:
-- SELECT * FROM asignaturas ORDER BY id_asignatura;

-- Para verificar la estructura de la tabla:
-- \d asignaturas;