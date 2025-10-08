-- =============================================
-- SISTEMA PIAR - BASE DE DATOS COMPLETA
-- Sistema de Login, Estructura Básica y Parametrizaciones
-- =============================================

-- =============================================
-- EXTENSIONES NECESARIAS
-- =============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- TABLA DE COLEGIOS
-- Contiene información de las instituciones educativas
-- =============================================
CREATE TABLE colegios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    codigo_institucion VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE SEDES
-- Contiene las diferentes sedes de cada colegio
-- =============================================
CREATE TABLE sedes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    colegio_id UUID REFERENCES colegios(id) ON DELETE CASCADE,
    codigo_sede VARCHAR(5) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    codigo_completo VARCHAR(15) UNIQUE NOT NULL, -- Código institución + sede
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(colegio_id, codigo_sede)
);

-- =============================================
-- TABLA DE GRADOS
-- Contiene los grados académicos disponibles en cada sede
-- =============================================
CREATE TABLE grados (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sede_id UUID REFERENCES sedes(id) ON DELETE CASCADE,
    grado VARCHAR(10) NOT NULL, -- 1, 2, 3, ..., 11
    nivel VARCHAR(20) NOT NULL, -- Primaria, Secundaria, Media
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE USUARIOS
-- Contiene información de los usuarios del sistema
-- =============================================
CREATE TABLE usuarios (
    cedula VARCHAR(20) PRIMARY KEY,
    codigo_usuario VARCHAR(3) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    codigo_institucion VARCHAR(15) NOT NULL,
    estado BOOLEAN DEFAULT true,
    debe_cambiar_password BOOLEAN DEFAULT true,
    ultimo_acceso TIMESTAMP,
    intentos_fallidos INTEGER DEFAULT 0,
    bloqueado_hasta TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (codigo_institucion) REFERENCES sedes(codigo_completo)
);

-- =============================================
-- PARAMETRIZACIONES DEL SISTEMA
-- =============================================

-- =============================================
-- TABLA DE TIPOS DE DOCUMENTO
-- Parametrización para tipos de documentos de identidad
-- Usada en formularios PIAR para estandarizar opciones
-- =============================================
CREATE TABLE tipos_documento (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    codigo VARCHAR(10) UNIQUE NOT NULL, -- Siglas del documento (RC, TI, CC, etc.)
    descripcion VARCHAR(100) NOT NULL, -- Nombre completo del documento
    activo BOOLEAN DEFAULT true, -- Estado del parámetro
    orden INTEGER DEFAULT 1, -- Orden de visualización en listas
    observaciones TEXT, -- Comentarios adicionales sobre el tipo de documento
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(20) REFERENCES usuarios(cedula), -- Usuario que creó el registro
    updated_by VARCHAR(20) REFERENCES usuarios(cedula) -- Usuario que modificó el registro
);

-- =============================================
-- NOTA: PARAMETRIZACIONES FUTURAS
-- Las siguientes tablas se implementarán en futuras iteraciones:
-- - departamentos: Para ubicación geográfica
-- - municipios: Relacionados con departamentos  
-- - niveles_educativos: Preescolar a Postgrado
-- - ocupaciones: Profesiones/trabajos
-- - entidades_salud: EPS, ARS, Prepagadas
-- =============================================

-- =============================================
-- FUNCIONES DEL SISTEMA
-- =============================================

-- Función para generar código de usuario único
-- Genera códigos de 3 caracteres basados en iniciales + número/letra
CREATE OR REPLACE FUNCTION generar_codigo_usuario(p_nombres TEXT, p_apellidos TEXT)
RETURNS VARCHAR(3) AS $$
DECLARE
    codigo_base VARCHAR(3);
    codigo_final VARCHAR(3);
    contador INTEGER := 1;
    primera_inicial CHAR(1);
    segunda_inicial CHAR(1);
BEGIN
    primera_inicial := UPPER(SUBSTRING(TRIM(p_nombres), 1, 1));
    segunda_inicial := UPPER(SUBSTRING(TRIM(p_apellidos), 1, 1));
    codigo_base := primera_inicial || segunda_inicial;
    
    -- Intentar generar código único
    WHILE contador <= 99 LOOP
        IF contador <= 9 THEN
            codigo_final := codigo_base || contador::TEXT;
        ELSE 
            codigo_final := codigo_base || CHR(65 + ((contador - 10) % 26));
        END IF;
        
        -- Verificar si el código ya existe
        IF NOT EXISTS (SELECT 1 FROM usuarios WHERE codigo_usuario = codigo_final) THEN
            RETURN codigo_final;
        END IF;
        
        contador := contador + 1;
    END LOOP;
    
    -- Si no se puede generar código único, lanzar excepción
    RAISE EXCEPTION 'No se pudo generar un código único para: % %', p_nombres, p_apellidos;
END;
$$ LANGUAGE plpgsql;

-- Función para validar contraseña segura
-- Valida que la contraseña cumpla con criterios de seguridad
CREATE OR REPLACE FUNCTION validar_password_segura(password TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Mínimo 10 caracteres
    IF LENGTH(password) < 10 THEN
        RETURN FALSE;
    END IF;
    
    -- Mínimo 3 números
    IF (SELECT LENGTH(REGEXP_REPLACE(password, '[^0-9]', '', 'g'))) < 3 THEN
        RETURN FALSE;
    END IF;
    
    -- Mínimo 2 mayúsculas
    IF (SELECT LENGTH(REGEXP_REPLACE(password, '[^A-Z]', '', 'g'))) < 2 THEN
        RETURN FALSE;
    END IF;
    
    -- Mínimo 2 minúsculas
    IF (SELECT LENGTH(REGEXP_REPLACE(password, '[^a-z]', '', 'g'))) < 2 THEN
        RETURN FALSE;
    END IF;
    
    -- Mínimo 2 caracteres especiales
    IF (SELECT LENGTH(REGEXP_REPLACE(password, '[A-Za-z0-9]', '', 'g'))) < 2 THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- TRIGGERS DEL SISTEMA
-- =============================================

-- Trigger para generar código de usuario automáticamente
CREATE OR REPLACE FUNCTION trigger_generar_codigo_usuario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo_usuario IS NULL OR NEW.codigo_usuario = '' THEN
        NEW.codigo_usuario := generar_codigo_usuario(NEW.nombres, NEW.apellidos);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER usuarios_generar_codigo
    BEFORE INSERT ON usuarios
    FOR EACH ROW
    EXECUTE FUNCTION trigger_generar_codigo_usuario();

-- Trigger para actualizar timestamp automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de timestamp a todas las tablas principales
CREATE TRIGGER update_usuarios_updated_at
    BEFORE UPDATE ON usuarios
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_colegios_updated_at
    BEFORE UPDATE ON colegios
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sedes_updated_at
    BEFORE UPDATE ON sedes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tipos_documento_updated_at
    BEFORE UPDATE ON tipos_documento
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers para parametrizaciones futuras se agregarán según se implementen

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- =============================================

-- Índices para usuarios
CREATE INDEX idx_usuarios_codigo_institucion ON usuarios(codigo_institucion);
CREATE INDEX idx_usuarios_estado ON usuarios(estado);
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- Índices para estructura organizacional
CREATE INDEX idx_sedes_codigo_completo ON sedes(codigo_completo);
CREATE INDEX idx_colegios_codigo_institucion ON colegios(codigo_institucion);
CREATE INDEX idx_grados_sede ON grados(sede_id, grado);

-- Índices para parametrizaciones
CREATE INDEX idx_tipos_documento_codigo ON tipos_documento(codigo);
CREATE INDEX idx_tipos_documento_activo ON tipos_documento(activo);
CREATE INDEX idx_tipos_documento_orden ON tipos_documento(orden);

-- Índices para parametrizaciones futuras se agregarán según se implementen

-- =============================================
-- VISTAS DEL SISTEMA
-- =============================================

-- Vista completa de usuarios con información de institución
CREATE VIEW vista_usuarios_completa AS
SELECT 
    u.cedula,
    u.codigo_usuario,
    u.nombres,
    u.apellidos,
    u.email,
    u.telefono,
    u.codigo_institucion,
    c.nombre AS colegio_nombre,
    s.nombre AS sede_nombre,
    u.estado,
    u.ultimo_acceso,
    u.debe_cambiar_password,
    u.created_at
FROM usuarios u
JOIN sedes s ON u.codigo_institucion = s.codigo_completo
JOIN colegios c ON s.colegio_id = c.id;

-- Vistas adicionales se agregarán según se implementen las parametrizaciones

-- =============================================
-- RESTRICCIONES DE INTEGRIDAD
-- =============================================

-- Restricciones para usuarios
ALTER TABLE usuarios 
ADD CONSTRAINT check_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE usuarios 
ADD CONSTRAINT check_telefono_format 
CHECK (telefono ~ '^[0-9]{10}$');

ALTER TABLE usuarios 
ADD CONSTRAINT check_codigo_usuario_format 
CHECK (codigo_usuario ~ '^[A-Z0-9]{3}$');

-- Restricciones para tipos de documento
ALTER TABLE tipos_documento 
ADD CONSTRAINT check_codigo_uppercase 
CHECK (codigo = UPPER(codigo));

ALTER TABLE tipos_documento 
ADD CONSTRAINT check_codigo_format 
CHECK (codigo ~ '^[A-Z]{2,10}$');

-- Restricciones adicionales se agregarán según se implementen las parametrizaciones

-- =============================================
-- DATOS INICIALES DEL SISTEMA
-- =============================================

-- =============================================
-- DATOS INICIALES - TIPOS DE DOCUMENTO
-- =============================================
INSERT INTO tipos_documento (codigo, descripcion, orden, observaciones) VALUES
('RC', 'Registro Civil de Nacimiento', 1, 'Para menores de 7 años'),
('TI', 'Tarjeta de Identidad', 2, 'Para personas entre 7 y 17 años'),
('CC', 'Cédula de Ciudadanía', 3, 'Para ciudadanos colombianos mayores de 18 años'),
('CE', 'Cédula de Extranjería', 4, 'Para extranjeros residentes en Colombia'),
('PA', 'Pasaporte', 5, 'Documento de viaje internacional'),
('DIE', 'Documento de Identificación Extranjero', 6, 'Documentos de identidad de otros países'),
('NIT', 'Número de Identificación Tributaria', 7, 'Para personas jurídicas');

-- =============================================
-- DATOS INICIALES - GÉNEROS
-- =============================================
INSERT INTO generos (id_genero, descripcion) VALUES
(1, 'MASCULINO'),
(2, 'FEMENINO'),
(3, 'TRANS'),
(4, 'PREFIERO NO DECIRLO');

-- =============================================
-- DATOS INICIALES - EPS
-- =============================================
INSERT INTO eps (id_eps, nombre, descripcion) VALUES
(1, 'ASMETSALUD', 'Asociación Mutual Ser Empresa Solidaria de Salud'),
(2, 'COOSALUD', 'Cooperativa de Salud y Desarrollo Integral'),
(3, 'COOMEVA', 'Cooperativa Médica del Valle y de Profesionales de Colombia'),
(4, 'COMPARTA', 'EPS Comparta'),
(5, 'FAMISANAR', 'Famisanar EPS'),
(6, 'NUEVA EPS', 'Nueva EPS S.A.'),
(7, 'MEDIMAS', 'Medimás EPS S.A.S.'),
(8, 'SALUDMIA', 'Salud Mía EPS S.A.S.'),
(9, 'SALUD TOTAL', 'EPS Salud Total S.A.'),
(10, 'SANITAS', 'EPS Sanitas S.A.'),
(11, 'SURA', 'EPS SURA S.A.'),
(12, 'ECOPETROL', 'EPS Ecopetrol S.A.'),
(13, 'AVANZAR MEDICO', 'Avanzar Médico EPS'),
(14, 'UIS SALUD', 'Universidad Industrial de Santander - Salud'),
(15, 'FERROCARRILES NACIONALES', 'EPS Ferrocarriles Nacionales de Colombia'),
(16, 'SANIDAD MILITAR', 'Dirección de Sanidad Militar'),
(17, 'POLICIA NACIONAL', 'Dirección Nacional de Sanidad Policía Nacional');

-- =============================================
-- DATOS INICIALES PARA PARAMETRIZACIONES FUTURAS
-- Se agregarán según se implementen las tablas correspondientes:
-- - niveles_educativos: Preescolar, Primaria, Secundaria, etc.
-- - departamentos y municipios: Datos DANE


-- =============================================
-- TABLA DE DEPARTAMENTOS
-- Contiene los 32 departamentos + Bogotá D.C.
-- =============================================
CREATE TABLE departamentos (
    id_departamento INTEGER PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL UNIQUE,
    codigo_dane VARCHAR(2), -- Para futuras integraciones con DANE
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE MUNICIPIOS
-- Contiene todos los municipios de Colombia
-- =============================================
CREATE TABLE municipios (
    id_municipio INTEGER PRIMARY KEY,
    id_departamento INTEGER REFERENCES departamentos(id_departamento) ON DELETE RESTRICT,
    descripcion VARCHAR(150) NOT NULL,
    codigo_dane VARCHAR(5), -- Código DANE completo del municipio
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_departamento, descripcion)
);

-- =============================================
-- TABLA DE GÉNEROS
-- Contiene los diferentes géneros disponibles en el sistema PIAR
-- =============================================
CREATE TABLE generos (
    id_genero INTEGER PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL UNIQUE,
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE EPS
-- Contiene las diferentes Entidades Promotoras de Salud disponibles en Colombia
-- =============================================
CREATE TABLE eps (
    id_eps INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE FRECUENCIAS DE REHABILITACIÓN
-- =============================================
-- Contiene las diferentes frecuencias de asistencia a instituciones de rehabilitación
-- =============================================
CREATE TABLE frecuencias_rehabilitacion (
    id_frecuencia INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE FRECUENCIAS DE MEDICAMENTOS
-- =============================================
-- Contiene las diferentes frecuencias de consumo de medicamentos
-- =============================================
CREATE TABLE frecuencias_medicamentos (
    id_frecuencia_medicamento INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE HORARIOS DE MEDICAMENTOS
-- =============================================
-- Contiene los diferentes horarios de administración de medicamentos
-- =============================================
CREATE TABLE horarios_medicamentos (
    id_horario_medicamento INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE CATEGORÍAS SIMAT
-- =============================================
-- Contiene las categorías de discapacidad del Sistema Integrado de Matrícula (SIMAT)
-- =============================================
CREATE TABLE categorias_simat (
    id_categoria_simat INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE GRUPOS ÉTNICOS
-- =============================================
-- Contiene los grupos étnicos reconocidos en Colombia
-- =============================================
CREATE TABLE grupos_etnicos (
    id_grupo_etnico INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE NIVELES EDUCATIVOS
-- =============================================
-- Contiene los niveles educativos disponibles en Colombia
-- =============================================
CREATE TABLE niveles_educativos (
    id_nivel_educativo INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA DE INGRESOS PROMEDIOS MENSUALES
-- =============================================
-- Contiene los rangos de ingresos mensuales disponibles
-- =============================================
CREATE TABLE ingresos_promedios_mensuales (
    id_ingreso INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================
CREATE INDEX idx_municipios_departamento ON municipios(id_departamento);
CREATE INDEX idx_municipios_descripcion ON municipios(descripcion);
CREATE INDEX idx_departamentos_descripcion ON departamentos(descripcion);
CREATE INDEX idx_generos_descripcion ON generos(descripcion);
CREATE INDEX idx_eps_nombre ON eps(nombre);
CREATE INDEX idx_frecuencias_rehabilitacion_nombre ON frecuencias_rehabilitacion(nombre);
CREATE INDEX idx_frecuencias_medicamentos_nombre ON frecuencias_medicamentos(nombre);
CREATE INDEX idx_horarios_medicamentos_nombre ON horarios_medicamentos(nombre);
CREATE INDEX idx_categorias_simat_nombre ON categorias_simat(nombre);
CREATE INDEX idx_grupos_etnicos_nombre ON grupos_etnicos(nombre);
CREATE INDEX idx_niveles_educativos_nombre ON niveles_educativos(nombre);
CREATE INDEX idx_ingresos_promedios_mensuales_nombre ON ingresos_promedios_mensuales(nombre);

-- =============================================
-- TRIGGERS PARA UPDATED_AT
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_departamentos_updated_at BEFORE UPDATE ON departamentos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_municipios_updated_at BEFORE UPDATE ON municipios
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_generos_updated_at BEFORE UPDATE ON generos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_eps_updated_at BEFORE UPDATE ON eps
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_frecuencias_rehabilitacion_updated_at BEFORE UPDATE ON frecuencias_rehabilitacion
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_frecuencias_medicamentos_updated_at BEFORE UPDATE ON frecuencias_medicamentos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_horarios_medicamentos_updated_at BEFORE UPDATE ON horarios_medicamentos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categorias_simat_updated_at BEFORE UPDATE ON categorias_simat
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grupos_etnicos_updated_at BEFORE UPDATE ON grupos_etnicos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_niveles_educativos_updated_at BEFORE UPDATE ON niveles_educativos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ingresos_promedios_mensuales_updated_at BEFORE UPDATE ON ingresos_promedios_mensuales
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_generos_updated_at BEFORE UPDATE ON generos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- DATOS INICIALES - DEPARTAMENTOS
-- =============================================
INSERT INTO departamentos (id_departamento, descripcion) VALUES
(1,'Amazonas'),
(2,'Antioquia'),
(3,'Arauca'),
(4,'Atlántico'),
(5,'Bolívar'),
(6,'Boyacá'),
(7,'Caldas'),
(8,'Caquetá'),
(9,'Casanare'),
(10,'Cauca'),
(11,'Cesar'),
(12,'Chocó'),
(13,'Córdoba'),
(14,'Cundinamarca'),
(15,'Guainía'),
(16,'Guaviare'),
(17,'Huila'),
(18,'La Guajira'),
(19,'Magdalena'),
(20,'Meta'),
(21,'Nariño'),
(22,'Norte de Santander'),
(23,'Putumayo'),
(24,'Quindío'),
(25,'Risaralda'),
(26,'San Andrés, Providencia y Santa Catalina'),
(27,'Santander'),
(28,'Sucre'),
(29,'Tolima'),
(30,'Valle del Cauca'),
(31,'Vaupés'),
(32,'Vichada'),
(33,'Bogotá, D.C.');
-- =============================================
-- INSERCIÓN MASIVA DE TODOS LOS MUNICIPIOS
-- =============================================

-- AMAZONAS (1) - 11 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(91001, 1, 'Leticia'),
(91263, 1, 'El Encanto'),
(91405, 1, 'La Chorrera'),
(91407, 1, 'La Pedrera'),
(91430, 1, 'La Victoria'),
(91460, 1, 'Miriti - Paraná'),
(91530, 1, 'Puerto Alegría'),
(91536, 1, 'Puerto Arica'),
(91540, 1, 'Puerto Nariño'),
(91669, 1, 'Puerto Santander'),
(91798, 1, 'Tarapacá');

-- ANTIOQUIA (2) - 125 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(5001, 2, 'Medellín'),
(5002, 2, 'Abejorral'),
(5004, 2, 'Abriaquí'),
(5021, 2, 'Alejandría'),
(5030, 2, 'Amagá'),
(5031, 2, 'Amalfi'),
(5034, 2, 'Andes'),
(5036, 2, 'Angelópolis'),
(5038, 2, 'Angostura'),
(5040, 2, 'Anorí'),
(5042, 2, 'Santa Fe de Antioquia'),
(5044, 2, 'Anza'),
(5045, 2, 'Apartadó'),
(5051, 2, 'Arboletes'),
(5055, 2, 'Argelia'),
(5059, 2, 'Armenia'),
(5079, 2, 'Barbosa'),
(5086, 2, 'Belmira'),
(5088, 2, 'Bello'),
(5091, 2, 'Betania'),
(5093, 2, 'Betulia'),
(5101, 2, 'Ciudad Bolívar'),
(5107, 2, 'Briceño'),
(5113, 2, 'Buriticá'),
(5120, 2, 'Cáceres'),
(5125, 2, 'Caicedo'),
(5129, 2, 'Caldas'),
(5134, 2, 'Campamento'),
(5138, 2, 'Cañasgordas'),
(5142, 2, 'Caracolí'),
(5145, 2, 'Caramanta'),
(5147, 2, 'Carepa'),
(5148, 2, 'El Carmen de Viboral'),
(5150, 2, 'Carolina'),
(5154, 2, 'Castillo'),
(5172, 2, 'Caucasia'),
(5190, 2, 'Chigorodó'),
(5197, 2, 'Cisneros'),
(5206, 2, 'Cocorná'),
(5209, 2, 'Colosó'),
(5212, 2, 'Concepción'),
(5234, 2, 'Concordia'),
(5237, 2, 'Copacabana'),
(5240, 2, 'Dabeiba'),
(5250, 2, 'Don Matías'),
(5264, 2, 'Ebéjico'),
(5266, 2, 'El Bagre'),
(5282, 2, 'Entrerrios'),
(5284, 2, 'Envigado'),
(5306, 2, 'Fredonia'),
(5308, 2, 'Frontino'),
(5310, 2, 'Giraldo'),
(5313, 2, 'Girardota'),
(5315, 2, 'Gómez Plata'),
(5318, 2, 'Granada'),
(5321, 2, 'Guadalupe'),
(5347, 2, 'Guarne'),
(5353, 2, 'Guatapé'),
(5360, 2, 'Heliconia'),
(5361, 2, 'Hispania'),
(5364, 2, 'Itagüí'),
(5368, 2, 'Ituango'),
(5376, 2, 'Jardín'),
(5380, 2, 'Jericó'),
(5390, 2, 'La Ceja'),
(5400, 2, 'La Estrella'),
(5411, 2, 'La Pintada'),
(5425, 2, 'La Unión'),
(5440, 2, 'Liborina'),
(5467, 2, 'Maceo'),
(5475, 2, 'Marinilla'),
(5480, 2, 'Montebello'),
(5483, 2, 'Murindó'),
(5490, 2, 'Mutatá'),
(5501, 2, 'Nariño'),
(5543, 2, 'Nechí'),
(5576, 2, 'Necoclí'),
(5579, 2, 'Olaya'),
(5585, 2, 'Peñol'),
(5591, 2, 'Peque'),
(5604, 2, 'Pueblorrico'),
(5607, 2, 'Puerto Berrío'),
(5615, 2, 'Puerto Nare'),
(5628, 2, 'Puerto Triunfo'),
(5631, 2, 'Remedios'),
(5642, 2, 'El Retiro'),
(5647, 2, 'Rionegro'),
(5649, 2, 'Sabanalarga'),
(5652, 2, 'Sabaneta'),
(5656, 2, 'Salgar'),
(5658, 2, 'San Andrés de Cuerquia'),
(5659, 2, 'San Carlos'),
(5660, 2, 'San Francisco'),
(5664, 2, 'San Jerónimo'),
(5665, 2, 'San José de la Montaña'),
(5667, 2, 'San Juan de Urabá'),
(5670, 2, 'San Luis'),
(5674, 2, 'San Pedro'),
(5679, 2, 'San Pedro de los Milagros'),
(5686, 2, 'San Rafael'),
(5690, 2, 'San Roque'),
(5697, 2, 'San Vicente'),
(5736, 2, 'Santa Bárbara'),
(5756, 2, 'Santa Rosa de Osos'),
(5761, 2, 'Santo Domingo'),
(5789, 2, 'El Santuario'),
(5790, 2, 'Segovia'),
(5792, 2, 'Sonsón'),
(5809, 2, 'Sopetrán'),
(5819, 2, 'Támesis'),
(5837, 2, 'Tarazá'),
(5842, 2, 'Tarso'),
(5847, 2, 'Titiribí'),
(5854, 2, 'Toledo'),
(5856, 2, 'Turbo'),
(5858, 2, 'Uramita'),
(5861, 2, 'Urrao'),
(5873, 2, 'Valdivia'),
(5885, 2, 'Valparaíso'),
(5887, 2, 'Vegachí'),
(5890, 2, 'Venecia'),
(5893, 2, 'Vigía del Fuerte'),
(5895, 2, 'Yalí'),
(5898, 2, 'Yarumal'),
(5901, 2, 'Yolombó'),
(5907, 2, 'Yondó'),
(5910, 2, 'Zaragoza');

-- ARAUCA (3) - 7 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(81001, 3, 'Arauca'),
(81065, 3, 'Arauquita'),
(81220, 3, 'Cravo Norte'),
(81300, 3, 'Fortul'),
(81591, 3, 'Puerto Rondón'),
(81736, 3, 'Saravena'),
(81794, 3, 'Tame');

-- ATLÁNTICO (4) - 23 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(8001, 4, 'Barranquilla'),
(8078, 4, 'Baranoa'),
(8137, 4, 'Campo de la Cruz'),
(8141, 4, 'Candelaria'),
(8296, 4, 'Galapa'),
(8372, 4, 'Juan de Acosta'),
(8421, 4, 'Luruaco'),
(8433, 4, 'Malambo'),
(8436, 4, 'Manatí'),
(8520, 4, 'Palmar de Varela'),
(8549, 4, 'Piojó'),
(8558, 4, 'Polonuevo'),
(8560, 4, 'Ponedera'),
(8573, 4, 'Puerto Colombia'),
(8606, 4, 'Repelón'),
(8634, 4, 'Sabanagrande'),
(8638, 4, 'Sabanalarga'),
(8675, 4, 'Santa Lucía'),
(8685, 4, 'Santo Tomás'),
(8758, 4, 'Soledad'),
(8770, 4, 'Suan'),
(8832, 4, 'Tubará'),
(8849, 4, 'Usiacurí');

-- BOLÍVAR (5) - 46 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(13001, 5, 'Cartagena'),
(13006, 5, 'Achí'),
(13030, 5, 'Altos del Rosario'),
(13042, 5, 'Arenal'),
(13052, 5, 'Arjona'),
(13062, 5, 'Arroyohondo'),
(13074, 5, 'Barranco de Loba'),
(13140, 5, 'Calamar'),
(13160, 5, 'Cantagallo'),
(13188, 5, 'Cicuco'),
(13212, 5, 'Córdoba'),
(13222, 5, 'Clemencia'),
(13244, 5, 'El Carmen de Bolívar'),
(13248, 5, 'El Guamo'),
(13268, 5, 'El Peñón'),
(13300, 5, 'Hatillo de Loba'),
(13430, 5, 'Magangué'),
(13433, 5, 'Mahates'),
(13440, 5, 'Margarita'),
(13442, 5, 'María la Baja'),
(13458, 5, 'Montecristo'),
(13468, 5, 'Mompós'),
(13473, 5, 'Morales'),
(13490, 5, 'Norosí'),
(13549, 5, 'Pinillos'),
(13580, 5, 'Regidor'),
(13600, 5, 'Río Viejo'),
(13620, 5, 'San Cristóbal'),
(13647, 5, 'San Estanislao'),
(13650, 5, 'San Fernando'),
(13654, 5, 'San Jacinto'),
(13655, 5, 'San Jacinto del Cauca'),
(13657, 5, 'San Juan Nepomuceno'),
(13667, 5, 'San Martín de Loba'),
(13670, 5, 'San Pablo'),
(13673, 5, 'Santa Catalina'),
(13683, 5, 'Santa Rosa'),
(13688, 5, 'Santa Rosa del Sur'),
(13744, 5, 'Simití'),
(13760, 5, 'Soplaviento'),
(13780, 5, 'Talaigua Nuevo'),
(13810, 5, 'Tiquisio'),
(13836, 5, 'Turbaco'),
(13838, 5, 'Turbaná'),
(13873, 5, 'Villanueva'),
(13894, 5, 'Zambrano');

-- BOYACÁ (6) - 123 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(15001, 6, 'Tunja'),
(15022, 6, 'Almeida'),
(15047, 6, 'Aquitania'),
(15051, 6, 'Arcabuco'),
(15087, 6, 'Belén'),
(15090, 6, 'Berbeo'),
(15092, 6, 'Betéitiva'),
(15097, 6, 'Boavita'),
(15104, 6, 'Boyacá'),
(15106, 6, 'Briceño'),
(15109, 6, 'Buenavista'),
(15114, 6, 'Busbanzá'),
(15131, 6, 'Caldas'),
(15135, 6, 'Campohermoso'),
(15162, 6, 'Cerinza'),
(15172, 6, 'Chinavita'),
(15176, 6, 'Chiquinquirá'),
(15180, 6, 'Chiscas'),
(15183, 6, 'Chita'),
(15185, 6, 'Chitaraque'),
(15187, 6, 'Chivatá'),
(15189, 6, 'Ciénega'),
(15204, 6, 'Cómbita'),
(15212, 6, 'Coper'),
(15215, 6, 'Corrales'),
(15218, 6, 'Covarachía'),
(15223, 6, 'Cubará'),
(15224, 6, 'Cucaita'),
(15226, 6, 'Cuítiva'),
(15232, 6, 'Chíquiza'),
(15236, 6, 'Chivor'),
(15238, 6, 'Duitama'),
(15244, 6, 'El Cocuy'),
(15248, 6, 'El Espino'),
(15272, 6, 'Firavitoba'),
(15276, 6, 'Floresta'),
(15293, 6, 'Gachantivá'),
(15296, 6, 'Gámeza'),
(15299, 6, 'Garagoa'),
(15317, 6, 'Guacamayas'),
(15322, 6, 'Guateque'),
(15325, 6, 'Guayatá'),
(15332, 6, 'Güicán'),
(15362, 6, 'Iza'),
(15367, 6, 'Jenesano'),
(15368, 6, 'Jericó'),
(15377, 6, 'Labranzagrande'),
(15380, 6, 'La Capilla'),
(15401, 6, 'La Victoria'),
(15403, 6, 'La Uvita'),
(15407, 6, 'Villa de Leyva'),
(15425, 6, 'Macanal'),
(15442, 6, 'Maripí'),
(15455, 6, 'Miraflores'),
(15464, 6, 'Mongua'),
(15466, 6, 'Monguí'),
(15469, 6, 'Moniquirá'),
(15476, 6, 'Motavita'),
(15480, 6, 'Muzo'),
(15491, 6, 'Nobsa'),
(15494, 6, 'Nuevo Colón'),
(15500, 6, 'Oicatá'),
(15507, 6, 'Otanche'),
(15511, 6, 'Pachavita'),
(15514, 6, 'Páez'),
(15516, 6, 'Paipa'),
(15518, 6, 'Pajarito'),
(15522, 6, 'Panqueba'),
(15531, 6, 'Pauna'),
(15533, 6, 'Paya'),
(15537, 6, 'Paz de Río'),
(15542, 6, 'Pesca'),
(15550, 6, 'Pisba'),
(15572, 6, 'Puerto Boyacá'),
(15580, 6, 'Quípama'),
(15599, 6, 'Ramiriquí'),
(15600, 6, 'Ráquira'),
(15621, 6, 'Rondón'),
(15632, 6, 'Saboyá'),
(15638, 6, 'Sáchica'),
(15646, 6, 'Samacá'),
(15660, 6, 'San Eduardo'),
(15664, 6, 'San José de Pare'),
(15667, 6, 'San Luis de Gaceno'),
(15673, 6, 'San Mateo'),
(15676, 6, 'San Miguel de Sema'),
(15681, 6, 'San Pablo de Borbur'),
(15686, 6, 'Santana'),
(15690, 6, 'Santa María'),
(15693, 6, 'Santa Rosa de Viterbo'),
(15696, 6, 'Santa Sofía'),
(15720, 6, 'Sativanorte'),
(15723, 6, 'Sativasur'),
(15740, 6, 'Siachoque'),
(15753, 6, 'Soatá'),
(15755, 6, 'Socotá'),
(15757, 6, 'Socha'),
(15759, 6, 'Sogamoso'),
(15761, 6, 'Somondoco'),
(15762, 6, 'Sora'),
(15763, 6, 'Sotaquirá'),
(15764, 6, 'Soracá'),
(15774, 6, 'Susacón'),
(15776, 6, 'Sutamarchán'),
(15778, 6, 'Sutatenza'),
(15790, 6, 'Tasco'),
(15798, 6, 'Tenza'),
(15804, 6, 'Tibaná'),
(15806, 6, 'Tibasosa'),
(15808, 6, 'Tinjacá'),
(15810, 6, 'Tipacoque'),
(15814, 6, 'Toca'),
(15816, 6, 'Togüí'),
(15820, 6, 'Tópaga'),
(15822, 6, 'Tota'),
(15832, 6, 'Tununguá'),
(15835, 6, 'Turmequé'),
(15837, 6, 'Tuta'),
(15839, 6, 'Tutazá'),
(15842, 6, 'Úmbita'),
(15861, 6, 'Ventaquemada'),
(15879, 6, 'Viracachá'),
(15897, 6, 'Zetaquira');

-- CALDAS (7) - 27 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(17001, 7, 'Manizales'),
(17013, 7, 'Aguadas'),
(17042, 7, 'Anserma'),
(17050, 7, 'Aranzazu'),
(17088, 7, 'Belalcázar'),
(17174, 7, 'Chinchiná'),
(17272, 7, 'Filadelfia'),
(17380, 7, 'La Dorada'),
(17388, 7, 'La Merced'),
(17433, 7, 'Manzanares'),
(17442, 7, 'Marmato'),
(17444, 7, 'Marquetalia'),
(17446, 7, 'Marulanda'),
(17486, 7, 'Neira'),
(17495, 7, 'Norcasia'),
(17513, 7, 'Pácora'),
(17524, 7, 'Palestina'),
(17541, 7, 'Pensilvania'),
(17614, 7, 'Riosucio'),
(17616, 7, 'Risaralda'),
(17653, 7, 'Salamina'),
(17662, 7, 'Samaná'),
(17665, 7, 'San José'),
(17777, 7, 'Supía'),
(17867, 7, 'Victoria'),
(17873, 7, 'Villamaría'),
(17877, 7, 'Viterbo');

-- CAQUETÁ (8) - 16 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(18001, 8, 'Florencia'),
(18029, 8, 'Albania'),
(18094, 8, 'Belén de los Andaquíes'),
(18150, 8, 'Cartagena del Chairá'),
(18205, 8, 'Curillo'),
(18247, 8, 'El Doncello'),
(18256, 8, 'El Paujil'),
(18410, 8, 'La Montañita'),
(18460, 8, 'Milán'),
(18479, 8, 'Morelia'),
(18592, 8, 'Puerto Rico'),
(18610, 8, 'San José del Fragua'),
(18753, 8, 'San Vicente del Caguán'),
(18756, 8, 'Solano'),
(18785, 8, 'Solita'),
(18860, 8, 'Valparaíso');

-- CASANARE (9) - 19 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(85001, 9, 'Yopal'),
(85010, 9, 'Aguazul'),
(85015, 9, 'Chámeza'),
(85125, 9, 'Hato Corozal'),
(85136, 9, 'La Salina'),
(85139, 9, 'Maní'),
(85162, 9, 'Monterrey'),
(85225, 9, 'Nunchía'),
(85230, 9, 'Orocué'),
(85250, 9, 'Paz de Ariporo'),
(85263, 9, 'Pore'),
(85279, 9, 'Recetor'),
(85300, 9, 'Sabanalarga'),
(85315, 9, 'Sácama'),
(85325, 9, 'San Luis de Palenque'),
(85400, 9, 'Támara'),
(85410, 9, 'Tauramena'),
(85430, 9, 'Trinidad'),
(85440, 9, 'Villanueva');

-- CAUCA (10) - 42 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(19001, 10, 'Popayán'),
(19022, 10, 'Almaguer'),
(19050, 10, 'Argelia'),
(19075, 10, 'Balboa'),
(19100, 10, 'Bolívar'),
(19110, 10, 'Buenos Aires'),
(19130, 10, 'Cajibío'),
(19137, 10, 'Caldono'),
(19142, 10, 'Caloto'),
(19212, 10, 'Corinto'),
(19256, 10, 'El Tambo'),
(19290, 10, 'Florencia'),
(19300, 10, 'Guachené'),
(19318, 10, 'Guapí'),
(19355, 10, 'Inzá'),
(19364, 10, 'Jambaló'),
(19392, 10, 'La Sierra'),
(19397, 10, 'La Vega'),
(19418, 10, 'López de Micay'),
(19450, 10, 'Mercaderes'),
(19455, 10, 'Miranda'),
(19473, 10, 'Morales'),
(19513, 10, 'Padilla'),
(19517, 10, 'Páez'),
(19532, 10, 'Patía'),
(19533, 10, 'Piamonte'),
(19548, 10, 'Piendamó'),
(19573, 10, 'Puerto Tejada'),
(19585, 10, 'Puracé'),
(19622, 10, 'Rosas'),
(19693, 10, 'San Sebastián'),
(19698, 10, 'Santander de Quilichao'),
(19701, 10, 'Santa Rosa'),
(19743, 10, 'Silvia'),
(19760, 10, 'Sotará'),
(19780, 10, 'Suárez'),
(19785, 10, 'Sucre'),
(19807, 10, 'Timbío'),
(19809, 10, 'Timbiquí'),
(19821, 10, 'Toribío'),
(19824, 10, 'Totoró'),
(19845, 10, 'Villa Rica');

-- CESAR (11) - 25 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(20001, 11, 'Valledupar'),
(20011, 11, 'Aguachica'),
(20013, 11, 'Agustín Codazzi'),
(20032, 11, 'Astrea'),
(20045, 11, 'Becerril'),
(20060, 11, 'Bosconia'),
(20175, 11, 'Chimichagua'),
(20178, 11, 'Chiriguaná'),
(20228, 11, 'Curumaní'),
(20238, 11, 'El Copey'),
(20250, 11, 'El Paso'),
(20295, 11, 'Gamarra'),
(20310, 11, 'González'),
(20383, 11, 'La Gloria'),
(20400, 11, 'La Jagua de Ibirico'),
(20443, 11, 'Manaure'),
(20517, 11, 'Pailitas'),
(20550, 11, 'Pelaya'),
(20570, 11, 'Pueblo Bello'),
(20614, 11, 'Río de Oro'),
(20621, 11, 'La Paz'),
(20710, 11, 'San Alberto'),
(20750, 11, 'San Diego'),
(20770, 11, 'San Martín'),
(20787, 11, 'Tamalameque');

-- CHOCÓ (12) - 31 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(27001, 12, 'Quibdó'),
(27006, 12, 'Acandí'),
(27025, 12, 'Alto Baudó'),
(27050, 12, 'Atrato'),
(27073, 12, 'Bagadó'),
(27075, 12, 'Bahía Solano'),
(27077, 12, 'Bajo Baudó'),
(27099, 12, 'Bojayá'),
(27135, 12, 'El Cantón del San Pablo'),
(27150, 12, 'Carmen del Darién'),
(27160, 12, 'Cértegui'),
(27205, 12, 'Condoto'),
(27245, 12, 'El Carmen de Atrato'),
(27250, 12, 'El Litoral del San Juan'),
(27361, 12, 'Istmina'),
(27372, 12, 'Juradó'),
(27413, 12, 'Lloró'),
(27425, 12, 'Medio Atrato'),
(27430, 12, 'Medio Baudó'),
(27450, 12, 'Medio San Juan'),
(27491, 12, 'Nóvita'),
(27495, 12, 'Nuquí'),
(27580, 12, 'Río Iró'),
(27600, 12, 'Río Quito'),
(27615, 12, 'Riosucio'),
(27660, 12, 'San José del Palmar'),
(27745, 12, 'Sipí'),
(27787, 12, 'Tadó'),
(27800, 12, 'Unguía'),
(27810, 12, 'Unión Panamericana'),
(27901, 12, 'Nuevo Belén de Bajirá');

-- CÓRDOBA (13) - 30 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(23001, 13, 'Montería'),
(23068, 13, 'Ayapel'),
(23079, 13, 'Buenavista'),
(23090, 13, 'Canalete'),
(23162, 13, 'Cereté'),
(23168, 13, 'Chimá'),
(23182, 13, 'Chinú'),
(23189, 13, 'Ciénaga de Oro'),
(23300, 13, 'Cotorra'),
(23350, 13, 'La Apartada'),
(23417, 13, 'Lorica'),
(23419, 13, 'Los Córdobas'),
(23464, 13, 'Momil'),
(23466, 13, 'Montelíbano'),
(23500, 13, 'Moñitos'),
(23555, 13, 'Planeta Rica'),
(23570, 13, 'Pueblo Nuevo'),
(23574, 13, 'Puerto Escondido'),
(23580, 13, 'Puerto Libertador'),
(23586, 13, 'Purísima'),
(23660, 13, 'Sahagún'),
(23670, 13, 'San Andrés Sotavento'),
(23672, 13, 'San Antero'),
(23675, 13, 'San Bernardo del Viento'),
(23678, 13, 'San Carlos'),
(23682, 13, 'San José de Uré'),
(23686, 13, 'San Pelayo'),
(23807, 13, 'Tierralta'),
(23815, 13, 'Tuchín'),
(23855, 13, 'Valencia');

-- Continuando con los demás departamentos...
-- Por ahora incluiré algunos departamentos más críticos

-- CUNDINAMARCA (14) - 116 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(25001, 14, 'Agua de Dios'),
(25019, 14, 'Albán'),
(25035, 14, 'Anapoima'),
(25040, 14, 'Anolaima'),
(25053, 14, 'Arbeláez'),
(25086, 14, 'Beltrán'),
(25095, 14, 'Bituima'),
(25099, 14, 'Bojacá'),
(25120, 14, 'Cabrera'),
(25123, 14, 'Cachipay'),
(25126, 14, 'Cajicá'),
(25148, 14, 'Caparrapí'),
(25151, 14, 'Cáqueza'),
(25154, 14, 'Carmen de Carupa'),
(25168, 14, 'Chaguaní'),
(25175, 14, 'Chía'),
(25178, 14, 'Chipaque'),
(25181, 14, 'Choachí'),
(25183, 14, 'Chocontá'),
(25200, 14, 'Cogua'),
(25214, 14, 'Cota'),
(25224, 14, 'Cucunubá'),
(25245, 14, 'El Colegio'),
(25258, 14, 'El Peñón'),
(25260, 14, 'El Rosal'),
(25269, 14, 'Facatativá'),
(25279, 14, 'Fomeque'),
(25281, 14, 'Fosca'),
(25286, 14, 'Funza'),
(25288, 14, 'Fúquene'),
(25290, 14, 'Fusagasugá'),
(25293, 14, 'Gachalá'),
(25295, 14, 'Gachancipá'),
(25297, 14, 'Gachetá'),
(25299, 14, 'Gama'),
(25307, 14, 'Girardot'),
(25312, 14, 'Granada'),
(25317, 14, 'Guachetá'),
(25320, 14, 'Guaduas'),
(25322, 14, 'Guasca'),
(25324, 14, 'Guataquí'),
(25326, 14, 'Guatavita'),
(25328, 14, 'Guayabal de Síquima'),
(25335, 14, 'Guayabetal'),
(25339, 14, 'Gutiérrez'),
(25368, 14, 'Jerusalén'),
(25372, 14, 'Junín'),
(25377, 14, 'La Calera'),
(25386, 14, 'La Mesa'),
(25394, 14, 'La Palma'),
(25398, 14, 'La Peña'),
(25402, 14, 'La Vega'),
(25407, 14, 'Lenguazaque'),
(25426, 14, 'Macheta'),
(25430, 14, 'Madrid'),
(25436, 14, 'Manta'),
(25438, 14, 'Medina'),
(25473, 14, 'Mosquera'),
(25483, 14, 'Nariño'),
(25486, 14, 'Nemocón'),
(25488, 14, 'Nilo'),
(25489, 14, 'Nimaima'),
(25491, 14, 'Nocaima'),
(25506, 14, 'Venecia'),
(25513, 14, 'Pacho'),
(25518, 14, 'Paime'),
(25524, 14, 'Pandi'),
(25530, 14, 'Paratebueno'),
(25535, 14, 'Pasca'),
(25572, 14, 'Puerto Salgar'),
(25580, 14, 'Pulí'),
(25592, 14, 'Quebradanegra'),
(25594, 14, 'Quetame'),
(25596, 14, 'Quipile'),
(25599, 14, 'Apulo'),
(25612, 14, 'Ricaurte'),
(25645, 14, 'San Antonio del Tequendama'),
(25649, 14, 'San Bernardo'),
(25653, 14, 'San Cayetano'),
(25658, 14, 'San Francisco'),
(25662, 14, 'San Juan de Río Seco'),
(25718, 14, 'Sasaima'),
(25736, 14, 'Sesquilé'),
(25740, 14, 'Sibaté'),
(25743, 14, 'Silvania'),
(25745, 14, 'Simijaca'),
(25754, 14, 'Soacha'),
(25758, 14, 'Sopó'),
(25769, 14, 'Subachoque'),
(25772, 14, 'Suesca'),
(25777, 14, 'Supatá'),
(25779, 14, 'Susa'),
(25781, 14, 'Sutatausa'),
(25785, 14, 'Tabio'),
(25793, 14, 'Tausa'),
(25797, 14, 'Tena'),
(25799, 14, 'Tenjo'),
(25805, 14, 'Tibacuy'),
(25807, 14, 'Tibirita'),
(25815, 14, 'Tocaima'),
(25817, 14, 'Tocancipá'),
(25823, 14, 'Topaipí'),
(25839, 14, 'Ubalá'),
(25841, 14, 'Ubaque'),
(25843, 14, 'Villa de San Diego de Ubate'),
(25845, 14, 'Une'),
(25851, 14, 'Útica'),
(25862, 14, 'Vergara'),
(25867, 14, 'Vianí'),
(25871, 14, 'Villagómez'),
(25873, 14, 'Villapinzón'),
(25875, 14, 'Villeta'),
(25878, 14, 'Viotá'),
(25885, 14, 'Yacopí'),
(25898, 14, 'Zipacón'),
(25899, 14, 'Zipaquirá');

-- SANTANDER (27) - 87 municipios (COMPLETOS)
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(68001, 27, 'Bucaramanga'),
(68013, 27, 'Aguada'),
(68020, 27, 'Albania'),
(68051, 27, 'Aratoca'),
(68077, 27, 'Barbosa'),
(68079, 27, 'Barichara'),
(68081, 27, 'Barrancabermeja'),
(68092, 27, 'Betulia'),
(68101, 27, 'Bolívar'),
(68121, 27, 'Cabrera'),
(68132, 27, 'California'),
(68147, 27, 'Capitanejo'),
(68152, 27, 'Carcasí'),
(68160, 27, 'Cepitá'),
(68162, 27, 'Cerrito'),
(68167, 27, 'Charalá'),
(68169, 27, 'Charta'),
(68176, 27, 'Chima'),
(68179, 27, 'Chipatá'),
(68190, 27, 'Cimitarra'),
(68207, 27, 'Concepción'),
(68209, 27, 'Confines'),
(68211, 27, 'Contratación'),
(68217, 27, 'Coromoro'),
(68229, 27, 'Curití'),
(68235, 27, 'El Carmen de Chucurí'),
(68245, 27, 'El Guacamayo'),
(68250, 27, 'El Peñón'),
(68255, 27, 'El Playón'),
(68264, 27, 'Encino'),
(68266, 27, 'Enciso'),
(68271, 27, 'Florián'),
(68276, 27, 'Floridablanca'),
(68296, 27, 'Galán'),
(68298, 27, 'Gambita'),
(68307, 27, 'Girón'),
(68318, 27, 'Guaca'),
(68320, 27, 'Guadalupe'),
(68322, 27, 'Guapotá'),
(68324, 27, 'Guavatá'),
(68327, 27, 'Güepsa'),
(68344, 27, 'Hato'),
(68368, 27, 'Jesús María'),
(68370, 27, 'Jordán'),
(68377, 27, 'La Belleza'),
(68385, 27, 'Landázuri'),
(68397, 27, 'La Paz'),
(68406, 27, 'Lebrija'),
(68418, 27, 'Los Santos'),
(68425, 27, 'Macaravita'),
(68432, 27, 'Málaga'),
(68444, 27, 'Matanza'),
(68464, 27, 'Mogotes'),
(68468, 27, 'Molagavita'),
(68498, 27, 'Ocamonte'),
(68500, 27, 'Oiba'),
(68502, 27, 'Onzaga'),
(68522, 27, 'Palmar'),
(68524, 27, 'Palmas del Socorro'),
(68533, 27, 'Páramo'),
(68547, 27, 'Piedecuesta'),
(68549, 27, 'Pinchote'),
(68572, 27, 'Puente Nacional'),
(68573, 27, 'Puerto Parra'),
(68575, 27, 'Puerto de la Cruz'),
(68615, 27, 'Rionegro'),
(68655, 27, 'Sabana de Torres'),
(68669, 27, 'San Andrés'),
(68673, 27, 'San Benito'),
(68679, 27, 'San Gil'),
(68682, 27, 'San Joaquín'),
(68684, 27, 'San José de Miranda'),
(68686, 27, 'San Miguel'),
(68689, 27, 'San Vicente de Chucurí'),
(68705, 27, 'Santa Bárbara'),
(68720, 27, 'Santa Helena del Opón'),
(68745, 27, 'Simacota'),
(68755, 27, 'Socorro'),
(68770, 27, 'Suaita'),
(68773, 27, 'Sucre'),
(68780, 27, 'Suratá'),
(68820, 27, 'Tona'),
(68855, 27, 'Valle de San José'),
(68861, 27, 'Vélez'),
(68867, 27, 'Vetas'),
(68872, 27, 'Villanueva'),
(68895, 27, 'Zapatoca');

-- BOGOTÁ D.C. (33) - 1 distrito
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(11001, 33, 'Bogotá, D.C.');
-- GUAINÍA (15) - 9 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(94001, 15, 'Inírida'),
(94343, 15, 'Barranco Minas'),
(94663, 15, 'Mapiripana'),
(94883, 15, 'San Felipe'),
(94884, 15, 'Puerto Colombia'),
(94885, 15, 'La Guadalupe'),
(94886, 15, 'Cacahual'),
(94887, 15, 'Pana Pana'),
(94888, 15, 'Morichal');

-- GUAVIARE (16) - 4 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(95001, 16, 'San José del Guaviare'),
(95015, 16, 'Calamar'),
(95025, 16, 'El Retorno'),
(95200, 16, 'Miraflores');

-- HUILA (17) - 37 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(41001, 17, 'Neiva'),
(41006, 17, 'Acevedo'),
(41013, 17, 'Agrado'),
(41016, 17, 'Aipe'),
(41020, 17, 'Algeciras'),
(41026, 17, 'Altamira'),
(41078, 17, 'Baraya'),
(41132, 17, 'Campoalegre'),
(41206, 17, 'Colombia'),
(41244, 17, 'Elías'),
(41298, 17, 'Garzón'),
(41306, 17, 'Gigante'),
(41319, 17, 'Guadalupe'),
(41349, 17, 'Hobo'),
(41357, 17, 'Íquira'),
(41359, 17, 'Isnos'),
(41378, 17, 'La Argentina'),
(41396, 17, 'La Plata'),
(41483, 17, 'Nátaga'),
(41503, 17, 'Oporapa'),
(41518, 17, 'Paicol'),
(41524, 17, 'Palermo'),
(41548, 17, 'Palestina'),
(41551, 17, 'Pital'),
(41615, 17, 'Rivera'),
(41660, 17, 'Saladoblanco'),
(41668, 17, 'San Agustín'),
(41676, 17, 'Santa María'),
(41770, 17, 'Suaza'),
(41791, 17, 'Tarqui'),
(41797, 17, 'Tesalia'),
(41799, 17, 'Tello'),
(41801, 17, 'Teruel'),
(41807, 17, 'Timaná'),
(41872, 17, 'Villavieja'),
(41885, 17, 'Yaguará'),
(41260, 17, 'Pitalito');

-- LA GUAJIRA (18) - 15 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(44001, 18, 'Riohacha'),
(44035, 18, 'Albania'),
(44078, 18, 'Barrancas'),
(44090, 18, 'Dibulla'),
(44098, 18, 'Distracción'),
(44110, 18, 'El Molino'),
(44279, 18, 'Fonseca'),
(44378, 18, 'Hatonuevo'),
(44420, 18, 'La Jagua del Pilar'),
(44430, 18, 'Maicao'),
(44560, 18, 'Manaure'),
(44650, 18, 'San Juan del Cesar'),
(44847, 18, 'Uribia'),
(44855, 18, 'Urumita'),
(44874, 18, 'Villanueva');

-- MAGDALENA (19) - 30 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(47001, 19, 'Santa Marta'),
(47030, 19, 'Algarrobo'),
(47053, 19, 'Aracataca'),
(47058, 19, 'Ariguaní'),
(47161, 19, 'Cerro San Antonio'),
(47170, 19, 'Chivolo'),
(47189, 19, 'Ciénaga'),
(47205, 19, 'Concordia'),
(47245, 19, 'El Banco'),
(47258, 19, 'El Piñón'),
(47268, 19, 'El Retén'),
(47288, 19, 'Fundación'),
(47318, 19, 'Guamal'),
(47460, 19, 'Nueva Granada'),
(47541, 19, 'Pedraza'),
(47545, 19, 'Pijiño del Carmen'),
(47551, 19, 'Pivijay'),
(47555, 19, 'Plato'),
(47570, 19, 'Puebloviejo'),
(47605, 19, 'Remolino'),
(47660, 19, 'Sabanas de San Ángel'),
(47675, 19, 'Salamina'),
(47692, 19, 'San Sebastián de Buenavista'),
(47703, 19, 'San Zenón'),
(47707, 19, 'Santa Ana'),
(47720, 19, 'Santa Bárbara de Pinto'),
(47745, 19, 'Sitionuevo'),
(47798, 19, 'Tenerife'),
(47960, 19, 'Zapayán'),
(47980, 19, 'Zona Bananera');

-- META (20) - 29 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(50001, 20, 'Villavicencio'),
(50006, 20, 'Acacías'),
(50110, 20, 'Barranca de Upía'),
(50124, 20, 'Cabuyaro'),
(50150, 20, 'Castilla la Nueva'),
(50223, 20, 'Cubarral'),
(50226, 20, 'Cumaral'),
(50245, 20, 'El Calvario'),
(50251, 20, 'El Castillo'),
(50270, 20, 'El Dorado'),
(50287, 20, 'Fuente de Oro'),
(50313, 20, 'Granada'),
(50318, 20, 'Guamal'),
(50325, 20, 'Mapiripán'),
(50330, 20, 'Mesetas'),
(50350, 20, 'La Macarena'),
(50370, 20, 'Uribe'),
(50400, 20, 'Lejanías'),
(50450, 20, 'Puerto Concordia'),
(50568, 20, 'Puerto Gaitán'),
(50573, 20, 'Puerto López'),
(50577, 20, 'Puerto Lleras'),
(50590, 20, 'Puerto Rico'),
(50606, 20, 'Restrepo'),
(50680, 20, 'San Carlos de Guaroa'),
(50683, 20, 'San Juan de Arama'),
(50686, 20, 'San Juanito'),
(50689, 20, 'San Martín'),
(50711, 20, 'Vistahermosa');

-- NARIÑO (21) - 64 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(52001, 21, 'Pasto'),
(52019, 21, 'Albán'),
(52022, 21, 'Aldana'),
(52036, 21, 'Ancuyá'),
(52051, 21, 'Arboleda'),
(52079, 21, 'Barbacoas'),
(52083, 21, 'Belén'),
(52110, 21, 'Buesaco'),
(52203, 21, 'Colón'),
(52207, 21, 'Consacá'),
(52210, 21, 'Contadero'),
(52215, 21, 'Córdoba'),
(52224, 21, 'Cuaspud'),
(52227, 21, 'Cumbal'),
(52233, 21, 'Cumbitara'),
(52240, 21, 'Chachagüí'),
(52250, 21, 'El Charco'),
(52254, 21, 'El Peñol'),
(52256, 21, 'El Rosario'),
(52258, 21, 'El Tablón de Gómez'),
(52260, 21, 'El Tambo'),
(52287, 21, 'Funes'),
(52317, 21, 'Guachavés'),
(52320, 21, 'Guaitarilla'),
(52323, 21, 'Gualmatán'),
(52352, 21, 'Iles'),
(52354, 21, 'Imués'),
(52356, 21, 'Ipiales'),
(52378, 21, 'La Cruz'),
(52381, 21, 'La Florida'),
(52385, 21, 'La Llanada'),
(52390, 21, 'La Tola'),
(52399, 21, 'La Unión'),
(52405, 21, 'Leiva'),
(52411, 21, 'Linares'),
(52418, 21, 'Los Andes'),
(52427, 21, 'Magüí Payán'),
(52435, 21, 'Mallama'),
(52473, 21, 'Mosquera'),
(52480, 21, 'Nariño'),
(52490, 21, 'Olaya Herrera'),
(52506, 21, 'Ospina'),
(52520, 21, 'Francisco Pizarro'),
(52540, 21, 'Policarpa'),
(52560, 21, 'Potosí'),
(52565, 21, 'Providencia'),
(52573, 21, 'Puerres'),
(52585, 21, 'Pupiales'),
(52612, 21, 'Ricaurte'),
(52621, 21, 'Roberto Payán'),
(52678, 21, 'Samaniego'),
(52683, 21, 'Sandoná'),
(52685, 21, 'San Bernardo'),
(52687, 21, 'San Lorenzo'),
(52693, 21, 'San Pablo'),
(52694, 21, 'San Pedro de Cartago'),
(52696, 21, 'Santa Bárbara'),
(52699, 21, 'Santacruz'),
(52720, 21, 'Sapuyes'),
(52786, 21, 'Taminango'),
(52788, 21, 'Tangua'),
(52835, 21, 'Túquerres'),
(52838, 21, 'Tumaco'),
(52885, 21, 'Yacuanquer');

-- NORTE DE SANTANDER (22) - 40 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(54001, 22, 'Cúcuta'),
(54003, 22, 'Ábrego'),
(54051, 22, 'Arboledas'),
(54099, 22, 'Bochalema'),
(54109, 22, 'Bucarasica'),
(54125, 22, 'Cácota'),
(54128, 22, 'Cachirá'),
(54172, 22, 'Chinácota'),
(54174, 22, 'Chitagá'),
(54206, 22, 'Convención'),
(54223, 22, 'Cúcutilla'),
(54239, 22, 'Durania'),
(54245, 22, 'El Carmen'),
(54250, 22, 'El Tarra'),
(54261, 22, 'El Zulia'),
(54313, 22, 'Gramalote'),
(54344, 22, 'Hacarí'),
(54347, 22, 'Herrán'),
(54377, 22, 'Labateca'),
(54385, 22, 'La Esperanza'),
(54398, 22, 'La Playa'),
(54405, 22, 'Los Patios'),
(54418, 22, 'Lourdes'),
(54480, 22, 'Mutiscua'),
(54498, 22, 'Ocaña'),
(54518, 22, 'Pamplona'),
(54520, 22, 'Pamplonita'),
(54553, 22, 'Puerto Santander'),
(54599, 22, 'Ragonvalia'),
(54660, 22, 'Salazar'),
(54670, 22, 'San Calixto'),
(54673, 22, 'San Cayetano'),
(54680, 22, 'Santiago'),
(54720, 22, 'Sardinata'),
(54743, 22, 'Silos'),
(54800, 22, 'Teorama'),
(54810, 22, 'Tibú'),
(54820, 22, 'Toledo'),
(54871, 22, 'Villa Caro'),
(54874, 22, 'Villa del Rosario');

-- PUTUMAYO (23) - 13 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(86001, 23, 'Mocoa'),
(86219, 23, 'Colón'),
(86320, 23, 'Orito'),
(86568, 23, 'Puerto Asís'),
(86569, 23, 'Puerto Caicedo'),
(86571, 23, 'Puerto Guzmán'),
(86573, 23, 'Leguízamo'),
(86749, 23, 'Sibundoy'),
(86755, 23, 'San Francisco'),
(86757, 23, 'San Miguel'),
(86760, 23, 'Santiago'),
(86865, 23, 'Valle del Guamuez'),
(86885, 23, 'Villagarzón');

-- QUINDÍO (24) - 12 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(63001, 24, 'Armenia'),
(63111, 24, 'Buenavista'),
(63130, 24, 'Calarcá'),
(63190, 24, 'Circasia'),
(63212, 24, 'Córdoba'),
(63272, 24, 'Filandia'),
(63302, 24, 'Génova'),
(63401, 24, 'La Tebaida'),
(63470, 24, 'Montenegro'),
(63548, 24, 'Pijao'),
(63594, 24, 'Quimbaya'),
(63690, 24, 'Salento');

-- RISARALDA (25) - 14 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(66001, 25, 'Pereira'),
(66045, 25, 'Apía'),
(66075, 25, 'Balboa'),
(66088, 25, 'Belén de Umbría'),
(66170, 25, 'Dosquebradas'),
(66318, 25, 'Guática'),
(66383, 25, 'La Celia'),
(66400, 25, 'La Virginia'),
(66440, 25, 'Marsella'),
(66456, 25, 'Mistrató'),
(66572, 25, 'Pueblo Rico'),
(66594, 25, 'Quinchía'),
(66682, 25, 'Santa Rosa de Cabal'),
(66687, 25, 'Santuario');

-- SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA (26) - 2 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(88001, 26, 'San Andrés'),
(88564, 26, 'Providencia');

-- SUCRE (28) - 26 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(70001, 28, 'Sincelejo'),
(70110, 28, 'Buenavista'),
(70124, 28, 'Caimito'),
(70204, 28, 'Coloso'),
(70215, 28, 'Corozal'),
(70221, 28, 'Coveñas'),
(70230, 28, 'Chalán'),
(70233, 28, 'El Roble'),
(70235, 28, 'Galeras'),
(70265, 28, 'Guaranda'),
(70400, 28, 'La Unión'),
(70418, 28, 'Los Palmitos'),
(70429, 28, 'Majagual'),
(70473, 28, 'Morroa'),
(70508, 28, 'Ovejas'),
(70523, 28, 'Palmito'),
(70670, 28, 'Sampués'),
(70678, 28, 'San Benito Abad'),
(70702, 28, 'San Juan de Betulia'),
(70708, 28, 'San Marcos'),
(70713, 28, 'San Onofre'),
(70717, 28, 'San Pedro'),
(70742, 28, 'Since'),
(70771, 28, 'Sucre'),
(70820, 28, 'Santiago de Tolú'),
(70823, 28, 'Tolú Viejo');

-- TOLIMA (29) - 47 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(73001, 29, 'Ibagué'),
(73024, 29, 'Alpujarra'),
(73026, 29, 'Alvarado'),
(73030, 29, 'Ambalema'),
(73043, 29, 'Anzoátegui'),
(73055, 29, 'Armero'),
(73067, 29, 'Ataco'),
(73124, 29, 'Cajamarca'),
(73148, 29, 'Carmen de Apicalá'),
(73152, 29, 'Casabianca'),
(73168, 29, 'Chaparral'),
(73200, 29, 'Coello'),
(73217, 29, 'Coyaima'),
(73226, 29, 'Cunday'),
(73236, 29, 'Dolores'),
(73268, 29, 'Espinal'),
(73270, 29, 'Falan'),
(73283, 29, 'Flandes'),
(73319, 29, 'Fresno'),
(73347, 29, 'Guamo'),
(73349, 29, 'Herveo'),
(73352, 29, 'Honda'),
(73408, 29, 'Icononzo'),
(73411, 29, 'Lérida'),
(73443, 29, 'Líbano'),
(73449, 29, 'Mariquita'),
(73461, 29, 'Melgar'),
(73483, 29, 'Murillo'),
(73504, 29, 'Natagaima'),
(73520, 29, 'Ortega'),
(73547, 29, 'Palocabildo'),
(73555, 29, 'Piedras'),
(73563, 29, 'Planadas'),
(73585, 29, 'Prado'),
(73616, 29, 'Purificación'),
(73622, 29, 'Rioblanco'),
(73624, 29, 'Roncevales'),
(73671, 29, 'Rovira'),
(73675, 29, 'Saldaña'),
(73678, 29, 'San Antonio'),
(73686, 29, 'San Luis'),
(73770, 29, 'Santa Isabel'),
(73854, 29, 'Suárez'),
(73861, 29, 'Valle de San Juan'),
(73870, 29, 'Venadillo'),
(73873, 29, 'Villahermosa'),
(73895, 29, 'Villarrica');

-- VALLE DEL CAUCA (30) - 42 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(76001, 30, 'Cali'),
(76020, 30, 'Alcalá'),
(76036, 30, 'Andalucía'),
(76041, 30, 'Ansermanuevo'),
(76054, 30, 'Argelia'),
(76100, 30, 'Bolívar'),
(76109, 30, 'Buenaventura'),
(76111, 30, 'Guadalajara de Buga'),
(76113, 30, 'Bugalagrande'),
(76122, 30, 'Caicedonia'),
(76126, 30, 'Calima'),
(76130, 30, 'Candelaria'),
(76147, 30, 'Cartago'),
(76233, 30, 'Dagua'),
(76243, 30, 'El Águila'),
(76246, 30, 'El Cairo'),
(76248, 30, 'El Cerrito'),
(76250, 30, 'El Dovio'),
(76275, 30, 'Florida'),
(76306, 30, 'Ginebra'),
(76318, 30, 'Guacarí'),
(76364, 30, 'Jamundí'),
(76377, 30, 'La Cumbre'),
(76400, 30, 'La Unión'),
(76403, 30, 'La Victoria'),
(76497, 30, 'Obando'),
(76520, 30, 'Palmira'),
(76563, 30, 'Pradera'),
(76606, 30, 'Restrepo'),
(76616, 30, 'Riofrío'),
(76622, 30, 'Roldanillo'),
(76670, 30, 'San Pedro'),
(76736, 30, 'Sevilla'),
(76823, 30, 'Toro'),
(76828, 30, 'Trujillo'),
(76834, 30, 'Tuluá'),
(76845, 30, 'Ulloa'),
(76863, 30, 'Versalles'),
(76869, 30, 'Vijes'),
(76890, 30, 'Yotoco'),
(76892, 30, 'Yumbo'),
(76895, 30, 'Zarzal');

-- VAUPÉS (31) - 3 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(97001, 31, 'Mitú'),
(97161, 31, 'Carurú'),
(97511, 31, 'Pacoa');

-- VICHADA (32) - 4 municipios
INSERT INTO municipios (id_municipio, id_departamento, descripcion) VALUES
(99001, 32, 'Puerto Carreño'),
(99524, 32, 'La Primavera'),
(99624, 32, 'Santa Rosalía'),
(99773, 32, 'Cumaribo');
-- =============================================
-- TABLAS FUTURAS DE PARAMETRIZACIÓN
-- - ocupaciones: Clasificación de profesiones
-- =============================================

-- =============================================
-- COMENTARIOS FINALES
-- =============================================

-- Este script crea la estructura base de la base de datos del Sistema PIAR
-- Incluye:
-- 1. Estructura organizacional (Colegios, Sedes, Grados)
-- 2. Sistema de usuarios con autenticación
-- 3. Parametrización inicial: Tipos de Documento (prueba de concepto)
-- 4. Funciones de utilidad y validación
-- 5. Triggers para automatización
-- 6. Índices para optimización
-- 7. Vistas para consultas complejas
-- 8. Restricciones de integridad
-- 9. Datos iniciales para tipos de documento

-- =============================================
-- TABLA RELACIONES CON EL ESTUDIANTE
-- Parametrización para relaciones familiares y de apoyo
-- =============================================
CREATE TABLE relaciones_estudiante (
    id_relacion INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- ÍNDICES PARA TABLA RELACIONES ESTUDIANTE
-- =============================================
CREATE INDEX idx_relaciones_estudiante_nombre ON relaciones_estudiante(nombre);

-- =============================================
-- TRIGGER PARA TABLA RELACIONES ESTUDIANTE
-- =============================================
CREATE TRIGGER update_relaciones_estudiante_updated_at 
    BEFORE UPDATE ON relaciones_estudiante
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- DATOS INICIALES - RELACIONES CON EL ESTUDIANTE
-- =============================================
INSERT INTO relaciones_estudiante (id_relacion, nombre, descripcion, estado) VALUES 
(1, 'Madre', 'Madre del estudiante', true),
(2, 'Padre', 'Padre del estudiante', true),
(3, 'Abuelo/a', 'Abuelo o abuela del estudiante', true),
(4, 'Hermano/a', 'Hermano o hermana del estudiante', true),
(5, 'Tío/a', 'Tío o tía del estudiante', true),
(6, 'Primo/a', 'Primo o prima del estudiante', true),
(7, 'Amigo/a de la familia', 'Amigo o amiga de la familia', true),
(8, 'Vecino/a', 'Vecino o vecina', true);

-- PARAMETRIZACIONES FUTURAS:
-- Se implementarán gradualmente según las necesidades del proyecto:
-- - Departamentos y municipios (ubicación geográfica)
-- - Niveles educativos (preescolar a postgrado)
-- - Ocupaciones y profesiones
-- - Entidades de salud (EPS, ARS, prepagadas)

-- Para ejecutar:
-- 1. Crear base de datos: CREATE DATABASE kando_piar;
-- 2. Ejecutar este script completo
-- 3. Verificar que todas las extensiones estén habilitadas
-- 4. Configurar usuarios y permisos según necesidades