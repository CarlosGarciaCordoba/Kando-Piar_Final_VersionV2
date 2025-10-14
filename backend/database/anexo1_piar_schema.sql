-- =============================================
-- ESQUEMA PARA ALMACENAMIENTO DEL ANEXO 1 DEL FORMULARIO PIAR
-- Diseño relacional escalable con auditoría completa
-- =============================================

-- =============================================
-- TABLA PRINCIPAL: FORMULARIOS PIAR ANEXO 1
-- Almacena la información principal del estudiante y el formulario
-- =============================================
CREATE TABLE formularios_piar_anexo1 (
    -- Identificación primaria
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_documento_estudiante VARCHAR(20) NOT NULL,
    
    -- Información básica del estudiante
    nombres_estudiante VARCHAR(100) NOT NULL,
    apellidos_estudiante VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad INTEGER,
    lugar_nacimiento TEXT,
    
    -- Documento y ubicación
    id_tipo_documento VARCHAR(10) REFERENCES tipos_documento(codigo),
    id_departamento INTEGER REFERENCES departamentos(id_departamento),
    id_municipio INTEGER REFERENCES municipios(id_municipio),
    barrio VARCHAR(100),
    direccion TEXT,
    
    -- Información personal
    id_genero INTEGER REFERENCES generos(id_genero),
    telefono VARCHAR(20),
    email VARCHAR(100),
    
    -- Sistema de salud
    afiliado_salud BOOLEAN,
    id_eps INTEGER REFERENCES eps(id_eps),
    eps_otro VARCHAR(100),
    lugar_atencion_emergencia TEXT,
    
    -- Rehabilitación y salud
    asiste_rehabilitacion BOOLEAN,
    institucion_rehabilitacion VARCHAR(150),
    id_frecuencia_rehabilitacion INTEGER REFERENCES frecuencias_rehabilitacion(id_frecuencia),
    
    -- Diagnóstico médico
    tiene_diagnostico BOOLEAN,
    id_categoria_simat INTEGER REFERENCES categorias_simat(id_categoria_simat),
    
    -- Enfermedad actual
    tiene_enfermedad_actual BOOLEAN,
    enfermedad_actual TEXT,
    
    -- Medicamentos
    consume_medicamentos BOOLEAN,
    medicamentos_cuales TEXT,
    id_frecuencia_medicamentos INTEGER REFERENCES frecuencias_medicamentos(id_frecuencia_medicamento),
    id_horario_medicamentos INTEGER REFERENCES horarios_medicamentos(id_horario_medicamento),
    horario_medicamentos_otro VARCHAR(100),
    
    -- Grupo étnico del estudiante
    pertenece_grupo_etnico BOOLEAN,
    id_grupo_etnico INTEGER REFERENCES grupos_etnicos(id_grupo_etnico),
    grupo_etnico_otro VARCHAR(100),
    
    -- Historial educativo
    ingreso_sistema_educativo BOOLEAN,
    jornada VARCHAR(20), -- 'mañana', 'tarde', 'nocturna', 'sabatino', 'completa'
    ultimo_grado_cursado VARCHAR(10),
    ultimo_ciclo_cursado VARCHAR(10),
    establecimiento_educativo VARCHAR(200),
    establecimiento_educativo_otro VARCHAR(200),
    tipo_matricula VARCHAR(50),
    motivo_retiro TEXT,
    grado_aspirante VARCHAR(10),
    ciclo_aspirante VARCHAR(10),
    
    -- INFORMACIÓN DE LA MADRE
    nombres_madre VARCHAR(100),
    apellidos_madre VARCHAR(100),
    edad_madre INTEGER,
    id_tipo_documento_madre VARCHAR(10) REFERENCES tipos_documento(codigo),
    numero_documento_madre VARCHAR(20),
    id_genero_madre INTEGER REFERENCES generos(id_genero),
    pertenece_grupo_etnico_madre BOOLEAN,
    id_grupo_etnico_madre INTEGER REFERENCES grupos_etnicos(id_grupo_etnico),
    grupo_etnico_madre_otro VARCHAR(100),
    id_nivel_educativo_madre INTEGER REFERENCES niveles_educativos(id_nivel_educativo),
    ocupacion_madre VARCHAR(100),
    id_ingresos_madre INTEGER REFERENCES ingresos_promedios_mensuales(id_ingreso),
    direccion_madre TEXT,
    telefono_madre VARCHAR(20),
    email_madre VARCHAR(100),
    id_departamento_madre INTEGER REFERENCES departamentos(id_departamento),
    id_municipio_madre INTEGER REFERENCES municipios(id_municipio),
    lugar_trabajo_madre VARCHAR(150),
    direccion_empresa_madre TEXT,
    telefono_empresa_madre VARCHAR(20),
    
    -- INFORMACIÓN DEL PADRE
    nombres_padre VARCHAR(100),
    apellidos_padre VARCHAR(100),
    edad_padre INTEGER,
    id_tipo_documento_padre VARCHAR(10) REFERENCES tipos_documento(codigo),
    numero_documento_padre VARCHAR(20),
    id_genero_padre INTEGER REFERENCES generos(id_genero),
    pertenece_grupo_etnico_padre BOOLEAN,
    id_grupo_etnico_padre INTEGER REFERENCES grupos_etnicos(id_grupo_etnico),
    grupo_etnico_padre_otro VARCHAR(100),
    id_nivel_educativo_padre INTEGER REFERENCES niveles_educativos(id_nivel_educativo),
    ocupacion_padre VARCHAR(100),
    id_ingresos_padre INTEGER REFERENCES ingresos_promedios_mensuales(id_ingreso),
    direccion_padre TEXT,
    telefono_padre VARCHAR(20),
    email_padre VARCHAR(100),
    id_departamento_padre INTEGER REFERENCES departamentos(id_departamento),
    id_municipio_padre INTEGER REFERENCES municipios(id_municipio),
    lugar_trabajo_padre VARCHAR(150),
    direccion_empresa_padre TEXT,
    telefono_empresa_padre VARCHAR(20),
    
    -- DINÁMICA FAMILIAR
    padres_viven_juntos BOOLEAN,
    id_ingresos_familiares INTEGER REFERENCES ingresos_promedios_mensuales(id_ingreso),
    actividades_generadoras_ingresos TEXT,
    otros_ingresos_cuales TEXT,
    otras_actividades_ingresos TEXT,
    vivienda VARCHAR(50), -- 'propia', 'arrendada', 'familiar', 'otra'
    
    -- HISTORIA DE VIDA - CONTEXTO INICIAL
    con_quien_vivia_primeros_meses TEXT,
    donde_dormia_principalmente TEXT,
    como_se_calmaba_cuando_lloraba TEXT,
    como_regulaba_sueno TEXT,
    alimentacion_primer_ano VARCHAR(50), -- 'lactancia_materna', 'formula', 'mixta'
    
    -- DESARROLLO MOTOR, LENGUAJE, SOCIAL Y SEXUAL
    dificultades_desarrollo_motor BOOLEAN,
    cuales_dificultades_motor TEXT,
    dificultades_lenguaje BOOLEAN,
    cuales_dificultades_lenguaje TEXT,
    dificultades_desarrollo_social TEXT,
    conductas_desarrollo_sexual_temprano TEXT,
    
    -- SALUD Y EVENTOS MÉDICOS
    enfermedad_primer_ano BOOLEAN,
    cual_enfermedad_primer_ano TEXT,
    tratamiento_medico_relevante BOOLEAN,
    cual_tratamiento_medico TEXT,
    
    -- ACTIVIDADES FAMILIARES
    actividades_compartia_familia TEXT,
    
    -- PRIMEROS CONTACTOS CON EDUCACIÓN FORMAL
    nivel_inicio_escolaridad VARCHAR(50),
    edad_inicio_escolaridad_anos INTEGER,
    edad_inicio_escolaridad_meses INTEGER,
    
    -- EXPERIENCIAS SIGNIFICATIVAS
    experiencias_significativas_escolares TEXT,
    valoracion_estudiante_experiencias VARCHAR(50), -- 'positiva', 'negativa', 'neutra', 'mixta'
    
    -- APRENDIZAJES Y DIFICULTADES INICIALES
    aprendizajes_mayor_facilidad TEXT,
    aspectos_mayor_dificultad TEXT,
    
    -- DIFICULTADES EVIDENTES
    dificultades_escolaridad_inicial BOOLEAN,
    cuales_dificultades_iniciales TEXT,
    
    -- FORTALEZAS OBSERVADAS
    fortalezas_etapa_inicial TEXT,
    
    -- IMPACTO EN APRENDIZAJES INTEGRALES
    vinculacion_experiencias_desarrollo TEXT,
    
    -- FAMILIA ACTUAL - COMPOSICIÓN
    con_quien_vive_actualmente TEXT,
    tipo_familia_nuclear VARCHAR(50), -- 'nuclear', 'monoparental', 'extendida', 'compuesta', 'otra'
    
    -- RELACIONES DEL ESTUDIANTE CON LA FAMILIA
    relaciones_familia_nuclear VARCHAR(50), -- 'excelentes', 'buenas', 'regulares', 'dificiles', 'conflictivas'
    relaciones_familia_extensa VARCHAR(50), -- 'excelentes', 'buenas', 'regulares', 'dificiles', 'conflictivas'
    aspectos_destacan_relaciones TEXT,
    
    -- RELACIONES DE LA FAMILIA CON EL ESTUDIANTE
    trato_familia_estudiante TEXT,
    
    -- MANEJO DE CONFLICTOS Y CRISIS
    manejo_conflictos_familia TEXT,
    reaccion_estudiante_conflictos TEXT,
    
    -- FACTORES DE UNIÓN FAMILIAR
    mantiene_unida_familia TEXT,
    
    -- DIAGNÓSTICO DE DISCAPACIDAD Y TRAYECTORIA
    estudiante_tiene_diagnostico_discapacidad BOOLEAN,
    sospechas_iniciales_como TEXT,
    quien_emitio_diagnostico VARCHAR(50), -- 'medico_general', 'especialista', 'psicologo', 'neurologo', 'equipo_interdisciplinario', 'otro'
    como_asumio_familia_diagnostico VARCHAR(50), -- 'aceptacion_total', 'negacion_inicial', 'busqueda_segundas_opiniones', 'confusion_desorientacion', 'otro'
    cuidadores_aceptaron_proceso BOOLEAN,
    
    -- INFORMACIÓN AL ESTUDIANTE
    se_informo_estudiante_diagnostico BOOLEAN,
    como_asumio_estudiante VARCHAR(50), -- 'naturalmente', 'con_dificultad', 'negacion', 'preocupacion', 'indiferencia', 'otro'
    
    -- TERAPIAS Y TRATAMIENTOS
    terapias_tratamientos_asistido TEXT,
    efectos_en_estudiante TEXT,
    continua_terapias_tratamientos BOOLEAN,
    porque_detuvo_terapias VARCHAR(50), -- 'falta_recursos', 'no_veia_avances', 'distancia_geografica', 'tiempo', 'cambio_prioridades', 'otro'
    otro_porque_detuvo_terapias TEXT,
    
    -- VIDA ACTUAL DEL ESTUDIANTE
    nivel_independencia_estudiante VARCHAR(50), -- 'muy_independiente', 'independiente', 'parcialmente_independiente', 'dependiente', 'muy_dependiente'
    actividades_independiente TEXT,
    actividades_requiere_apoyo TEXT,
    
    -- FORTALEZAS Y DEBILIDADES ACTUALES
    principales_fortalezas_observadas TEXT,
    principales_debilidades_observadas TEXT,
    
    -- DESARROLLO Y RELACIONES ACTUALES
    caracterizado_desarrollo_ultimos_anos TEXT,
    como_relaciona_cuidadores VARCHAR(50), -- 'excelente', 'buena', 'regular', 'dificil', 'conflictiva'
    
    -- HÁBITOS, PREFERENCIAS E INTERESES
    habitos_destacados TEXT,
    preferencias_vida_cotidiana TEXT,
    intereses_personales_predominan TEXT,
    
    -- DESTACADOS Y LIMITACIONES
    en_que_se_destaca TEXT,
    limitaciones_importantes_actualmente TEXT,
    
    -- SITUACIONES Y REACCIONES VIDA COTIDIANA
    situaciones_afectan_estudiante TEXT,
    como_reacciona_situaciones TEXT,
    intensidad_reaccion VARCHAR(50), -- 'muy_intensa', 'intensa', 'moderada', 'leve', 'muy_leve'
    que_hacen_adultos_reacciones TEXT,
    efectividad_estrategias VARCHAR(50), -- 'muy_efectivas', 'efectivas', 'parcialmente_efectivas', 'poco_efectivas', 'nada_efectivas'
    como_manejan_situaciones TEXT,
    
    -- EXPERIENCIAS EN ESTABLECIMIENTOS EDUCATIVOS
    principales_fortalezas_instituciones TEXT,
    importancia_fortalezas VARCHAR(50), -- 'muy_importantes', 'importantes', 'moderadamente_importantes', 'poco_importantes', 'nada_importantes'
    dificultades_importantes_instituciones TEXT,
    impacto_dificultades TEXT,
    
    -- FORTALEZAS A POTENCIAR Y APOYOS REQUERIDOS
    fortalezas_potenciar_establecimiento TEXT,
    prioridad_fortalecimiento VARCHAR(50), -- 'muy_alta', 'alta', 'media', 'baja', 'muy_baja'
    apoyos_requiere_estudiante TEXT,
    quien_ofrecer_apoyos TEXT,
    
    -- APOYOS BRINDADOS EN CASA
    apoyos_recibido_casa TEXT,
    frecuencia_apoyos_casa VARCHAR(50), -- 'diaria', 'semanal', 'quincenal', 'mensual', 'ocasional'
    quien_brinda_apoyos_casa TEXT,
    apoyos_familiares_implementar_institucion TEXT,
    
    -- CAMPOS DE TEXTO EXTENSO PARA SECCIONES J, K, L, M, N
    eventos_familiares_impacto TEXT,
    eventos_comunitarios_impacto TEXT,
    redes_apoyo_familia TEXT,
    percepcion_estudiante_historia_vida TEXT,
    percepcion_estudiante_situacion_escolar TEXT,
    
    -- OBSERVACIONES GENERALES
    observaciones_generales TEXT,
    
    -- FIRMA DIGITAL Y AUDITORÍA
    firma_ruta VARCHAR(255),
    firma_timestamp TIMESTAMP,
    firma_ip INET,
    firma_hash VARCHAR(64),
    
    -- Relaciones con otras tablas
    codigo_institucion VARCHAR(15) REFERENCES sedes(codigo_completo),
    usuario_creacion VARCHAR(20), -- Para cuando se implemente la tabla de usuarios
    
    -- Campos de auditoría
    estado VARCHAR(20) DEFAULT 'activo', -- 'activo', 'inactivo', 'archivado'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Índices y restricciones
    UNIQUE(numero_documento_estudiante, codigo_institucion)
);

-- =============================================
-- TABLA: COMPOSICIÓN FAMILIAR DINÁMICA
-- Para manejar la información de "con quién vive"
-- =============================================
CREATE TABLE composicion_familiar (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    formulario_piar_id UUID REFERENCES formularios_piar_anexo1(id) ON DELETE CASCADE,
    
    -- Información de la persona con quien vive
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    edad INTEGER,
    id_relacion_estudiante INTEGER REFERENCES relaciones_estudiante(id_relacion),
    id_genero INTEGER REFERENCES generos(id_genero),
    id_nivel_educativo INTEGER REFERENCES niveles_educativos(id_nivel_educativo),
    ocupacion VARCHAR(100),
    telefono VARCHAR(20),
    
    -- Orden de registro y auditoría
    orden_registro INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA: FIGURAS DE APOYO
-- Para manejar las figuras de apoyo que no viven en la misma vivienda
-- =============================================
CREATE TABLE figuras_apoyo (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    formulario_piar_id UUID REFERENCES formularios_piar_anexo1(id) ON DELETE CASCADE,
    
    -- Información de la figura de apoyo
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    edad INTEGER,
    id_relacion_estudiante INTEGER REFERENCES relaciones_estudiante(id_relacion),
    telefono VARCHAR(20),
    direccion TEXT,
    
    -- Tipo de apoyo que brinda
    tipo_apoyo TEXT,
    frecuencia_apoyo VARCHAR(50), -- 'diario', 'semanal', 'quincenal', 'mensual', 'ocasional'
    
    -- Orden de registro y auditoría
    orden_registro INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA: HISTORIAL DE CAMBIOS (AUDITORÍA)
-- Para rastrear cambios en los formularios
-- =============================================
CREATE TABLE formularios_piar_anexo1_historial (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    formulario_piar_id UUID REFERENCES formularios_piar_anexo1(id) ON DELETE CASCADE,
    
    -- Información del cambio
    campo_modificado VARCHAR(100) NOT NULL,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    
    -- Auditoría del cambio
    usuario_modificacion VARCHAR(20), -- Para cuando se implemente usuarios
    ip_modificacion INET,
    razon_cambio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- =============================================

-- Índices principales
CREATE INDEX idx_formularios_piar_anexo1_documento ON formularios_piar_anexo1(numero_documento_estudiante);
CREATE INDEX idx_formularios_piar_anexo1_institucion ON formularios_piar_anexo1(codigo_institucion);
CREATE INDEX idx_formularios_piar_anexo1_categoria_simat ON formularios_piar_anexo1(id_categoria_simat);
CREATE INDEX idx_formularios_piar_anexo1_created_at ON formularios_piar_anexo1(created_at);
CREATE INDEX idx_formularios_piar_anexo1_estado ON formularios_piar_anexo1(estado);

-- Índices para composición familiar
CREATE INDEX idx_composicion_familiar_formulario ON composicion_familiar(formulario_piar_id);
CREATE INDEX idx_composicion_familiar_orden ON composicion_familiar(formulario_piar_id, orden_registro);

-- Índices para figuras de apoyo
CREATE INDEX idx_figuras_apoyo_formulario ON figuras_apoyo(formulario_piar_id);
CREATE INDEX idx_figuras_apoyo_orden ON figuras_apoyo(formulario_piar_id, orden_registro);

-- Índices para historial
CREATE INDEX idx_historial_formulario ON formularios_piar_anexo1_historial(formulario_piar_id);
CREATE INDEX idx_historial_fecha ON formularios_piar_anexo1_historial(created_at);

-- =============================================
-- TRIGGERS PARA AUDITORÍA AUTOMÁTICA
-- =============================================

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para updated_at en tabla principal
CREATE TRIGGER update_formularios_piar_anexo1_updated_at 
    BEFORE UPDATE ON formularios_piar_anexo1 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Función para registrar cambios en historial
CREATE OR REPLACE FUNCTION registrar_cambios_formulario()
RETURNS TRIGGER AS $$
DECLARE
    campo_nombre TEXT;
    valor_viejo TEXT;
    valor_nuevo TEXT;
BEGIN
    -- Solo registrar si hay cambios reales
    IF OLD IS DISTINCT FROM NEW THEN
        -- Aquí se pueden especificar campos críticos para auditoría
        -- Por simplicidad, registramos cambios en campos principales
        
        IF OLD.nombres_estudiante IS DISTINCT FROM NEW.nombres_estudiante THEN
            INSERT INTO formularios_piar_anexo1_historial 
            (formulario_piar_id, campo_modificado, valor_anterior, valor_nuevo, usuario_modificacion, ip_modificacion)
            VALUES (NEW.id, 'nombres_estudiante', OLD.nombres_estudiante, NEW.nombres_estudiante, 
                    NEW.usuario_creacion, inet_client_addr());
        END IF;
        
        -- Agregar más campos según necesidad...
        
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para auditoría de cambios
CREATE TRIGGER audit_formularios_piar_anexo1_changes
    AFTER UPDATE ON formularios_piar_anexo1
    FOR EACH ROW
    EXECUTE FUNCTION registrar_cambios_formulario();

-- =============================================
-- COMENTARIOS EN TABLAS Y COLUMNAS
-- =============================================

COMMENT ON TABLE formularios_piar_anexo1 IS 'Almacena toda la información del Anexo 1 del formulario PIAR, incluyendo datos del estudiante, padres e historia de vida';
COMMENT ON TABLE composicion_familiar IS 'Registra dinámicamente las personas con quienes vive el estudiante';
COMMENT ON TABLE figuras_apoyo IS 'Registra las figuras de apoyo externas que no viven con el estudiante';
COMMENT ON TABLE formularios_piar_anexo1_historial IS 'Auditoría completa de cambios realizados en los formularios';

COMMENT ON COLUMN formularios_piar_anexo1.numero_documento_estudiante IS 'Número de documento del estudiante - identificador principal';
COMMENT ON COLUMN formularios_piar_anexo1.firma_ruta IS 'Ruta del archivo de firma digital en el sistema de storage';
COMMENT ON COLUMN formularios_piar_anexo1.firma_hash IS 'Hash SHA-256 del archivo de firma para verificar integridad';
COMMENT ON COLUMN formularios_piar_anexo1.codigo_institucion IS 'Código de la sede educativa donde se registra el PIAR';