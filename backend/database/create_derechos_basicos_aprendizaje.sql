-- =============================================
-- TABLA DE DERECHOS BÁSICOS DE APRENDIZAJE (DBA)
-- Fecha de creación: 14 de octubre de 2025
-- Propósito: Almacenar los derechos básicos de aprendizaje por área y grado
-- =============================================

-- Crear la tabla principal de derechos básicos de aprendizaje
CREATE TABLE IF NOT EXISTS derechos_basicos_aprendizaje (
    id_dba SERIAL PRIMARY KEY,
    id_asignatura INTEGER NOT NULL REFERENCES asignaturas(id_asignatura) ON DELETE CASCADE,
    id_grado INTEGER NOT NULL REFERENCES grados_piar(id_grado) ON DELETE CASCADE,
    numero_dba INTEGER NOT NULL, -- Número del DBA (1, 2, 3, etc.)
    titulo TEXT NOT NULL, -- Título descriptivo del DBA
    descripcion TEXT NOT NULL, -- Descripción completa del DBA
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricciones
    CONSTRAINT unique_dba_asignatura_grado_numero UNIQUE (id_asignatura, id_grado, numero_dba),
    CONSTRAINT check_numero_dba_positivo CHECK (numero_dba > 0)
);

-- Crear la tabla de evidencias de aprendizaje (relacionada con cada DBA)
CREATE TABLE IF NOT EXISTS evidencias_aprendizaje (
    id_evidencia SERIAL PRIMARY KEY,
    id_dba INTEGER NOT NULL REFERENCES derechos_basicos_aprendizaje(id_dba) ON DELETE CASCADE,
    numero_evidencia INTEGER NOT NULL, -- Orden de la evidencia dentro del DBA
    descripcion TEXT NOT NULL, -- Descripción de la evidencia
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricciones
    CONSTRAINT unique_evidencia_dba_numero UNIQUE (id_dba, numero_evidencia),
    CONSTRAINT check_numero_evidencia_positivo CHECK (numero_evidencia > 0)
);

-- Crear índices para optimizar consultas
CREATE INDEX idx_dba_asignatura ON derechos_basicos_aprendizaje(id_asignatura);
CREATE INDEX idx_dba_grado ON derechos_basicos_aprendizaje(id_grado);
CREATE INDEX idx_dba_asignatura_grado ON derechos_basicos_aprendizaje(id_asignatura, id_grado);
CREATE INDEX idx_dba_estado ON derechos_basicos_aprendizaje(estado);
CREATE INDEX idx_evidencias_dba ON evidencias_aprendizaje(id_dba);
CREATE INDEX idx_evidencias_estado ON evidencias_aprendizaje(estado);

-- Crear triggers para actualizar fecha de modificación
CREATE TRIGGER update_dba_updated_at
    BEFORE UPDATE ON derechos_basicos_aprendizaje
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_evidencias_updated_at
    BEFORE UPDATE ON evidencias_aprendizaje
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentarios sobre las tablas
COMMENT ON TABLE derechos_basicos_aprendizaje IS 'Tabla que almacena los Derechos Básicos de Aprendizaje (DBA) por asignatura y grado según el MEN';
COMMENT ON COLUMN derechos_basicos_aprendizaje.id_dba IS 'Identificador único del derecho básico de aprendizaje';
COMMENT ON COLUMN derechos_basicos_aprendizaje.id_asignatura IS 'Referencia a la asignatura (tabla asignaturas)';
COMMENT ON COLUMN derechos_basicos_aprendizaje.id_grado IS 'Referencia al grado académico (tabla grados_piar)';
COMMENT ON COLUMN derechos_basicos_aprendizaje.numero_dba IS 'Número secuencial del DBA dentro de la asignatura y grado';
COMMENT ON COLUMN derechos_basicos_aprendizaje.titulo IS 'Título descriptivo del derecho básico de aprendizaje';
COMMENT ON COLUMN derechos_basicos_aprendizaje.descripcion IS 'Descripción completa del DBA';

COMMENT ON TABLE evidencias_aprendizaje IS 'Tabla que almacena las evidencias de aprendizaje asociadas a cada DBA';
COMMENT ON COLUMN evidencias_aprendizaje.id_evidencia IS 'Identificador único de la evidencia de aprendizaje';
COMMENT ON COLUMN evidencias_aprendizaje.id_dba IS 'Referencia al DBA al que pertenece la evidencia';
COMMENT ON COLUMN evidencias_aprendizaje.numero_evidencia IS 'Número secuencial de la evidencia dentro del DBA';
COMMENT ON COLUMN evidencias_aprendizaje.descripcion IS 'Descripción de la evidencia de aprendizaje';

-- =============================================
-- INSERTAR DATOS DE EJEMPLO: MATEMÁTICAS GRADO 1°
-- =============================================

-- Obtener IDs necesarios para las referencias
-- Matemáticas (id_asignatura = 2) y 1° grado (id_grado = 4)

-- DBA 1: Identifica los usos de los números
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 1, 
'Identifica los usos de los números y las operaciones en contextos cotidianos',
'Identifica los usos de los números (como código, cardinal, medida, ordinal) y las operaciones (suma y resta) en contextos de juego, familiares, económicos, entre otros.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 1), 1,
'Construye e interpreta representaciones pictóricas y diagramas para representar relaciones entre cantidades que se presentan en situaciones o fenómenos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 1), 2,
'Explica cómo y por qué es posible hacer una operación (suma o resta) en relación con los usos de los números y el contexto en el cual se presentan.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 1), 3,
'Reconoce en sus actuaciones cotidianas posibilidades de uso de los números y las operaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 1), 4,
'Interpreta y resuelve problemas de juntar, quitar y completar, que involucren la cantidad de elementos de una colección o la medida de magnitudes como longitud, peso, capacidad y duración.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 1), 5,
'Utiliza las operaciones (suma y resta) para representar el cambio en una cantidad.');

-- DBA 2: Utiliza diferentes estrategias para contar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 2,
'Utiliza diferentes estrategias para contar y resolver problemas aditivos',
'Utiliza diferentes estrategias para contar, realizar operaciones (suma y resta) y resolver problemas aditivos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 2), 1,
'Realiza conteos (de uno en uno, de dos en dos, etc.) iniciando en cualquier número.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 2), 2,
'Determina la cantidad de elementos de una colección agrupándolos de 1 en 1, de 2 en 2, de 5 en 5.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 2), 3,
'Describe y resuelve situaciones variadas con las operaciones de suma y resta en problemas cuya estructura puede ser a + b = ?, a + ? = c, o ? + b = c.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 2), 4,
'Establece y argumenta conjeturas de los posibles resultados en una secuencia numérica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 2), 5,
'Utiliza las características del sistema decimal de numeración para crear estrategias de cálculo y estimación de sumas y restas.');

-- DBA 3: Sistema de Numeración Decimal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 3,
'Utiliza las características posicionales del Sistema de Numeración Decimal',
'Utiliza las características posicionales del Sistema de Numeración Decimal (SND) para establecer relaciones entre cantidades y comparar números.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 3), 1,
'Realiza composiciones y descomposiciones de números de dos dígitos en términos de la cantidad de "dieces" y de "unos" que los conforman.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 3), 2,
'Encuentra parejas de números que al adicionarse dan como resultado otro número dado.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 3), 3,
'Halla los números correspondientes a tener "diez más" o "diez menos" que una cantidad determinada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 3), 4,
'Emplea estrategias de cálculo como "el paso por el diez" para realizar adiciones o sustracciones.');

-- DBA 4: Reconoce y compara atributos medibles
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 4,
'Reconoce y compara atributos que pueden ser medidos',
'Reconoce y compara atributos que pueden ser medidos en objetos y eventos (longitud, duración, rapidez, masa, peso, capacidad, cantidad de elementos de una colección, entre otros).');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 4), 1,
'Identifica atributos que se pueden medir en los objetos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 4), 2,
'Diferencia atributos medibles (longitud, masa, capacidad, duración, cantidad de elementos de una colección), en términos de los instrumentos y las unidades utilizadas para medirlos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 4), 3,
'Compara y ordena objetos de acuerdo con atributos como altura, peso, intensidades de color, entre otros, y recorridos según la distancia de cada trayecto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 4), 4,
'Compara y ordena colecciones según la cantidad de elementos.');

-- DBA 5: Realiza mediciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 5,
'Realiza medición utilizando instrumentos y unidades',
'Realiza medición de longitudes, capacidades, peso, masa, entre otros, para ello utiliza instrumentos y unidades no estandarizadas y estandarizadas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 5), 1,
'Mide longitudes con diferentes instrumentos y expresa el resultado en unidades estandarizadas o no estandarizadas comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 5), 2,
'Compara objetos a partir de su longitud, masa, capacidad y duración de eventos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 5), 3,
'Toma decisiones a partir de las mediciones realizadas y de acuerdo con los requerimientos del problema.');

-- DBA 6: Compara objetos y características geométricas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 6,
'Compara objetos empleando características geométricas',
'Compara objetos del entorno y establece semejanzas y diferencias empleando características geométricas de las formas bidimensionales y tridimensionales (curvo o recto, abierto o cerrado, plano o sólido, número de lados, número de caras, entre otros).');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 6), 1,
'Crea, compone y descompone formas bidimensionales y tridimensionales, para ello utiliza plastilina, papel, palitos, cajas, etc.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 6), 2,
'Describe de forma verbal las cualidades y propiedades de un objeto relativas a su forma.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 6), 3,
'Agrupa objetos de su entorno de acuerdo con las semejanzas y las diferencias en la forma y en el tamaño y explica el criterio que utiliza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 6), 4,
'Identifica objetos a partir de las descripciones verbales que hacen de sus características geométricas.');

-- DBA 7: Describe trayectorias y posiciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 7,
'Describe y representa trayectorias y posiciones espaciales',
'Describe y representa trayectorias y posiciones de objetos y personas para orientar a otros o a sí mismo en el espacio circundante.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 7), 1,
'Utiliza representaciones como planos para ubicarse en el espacio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 7), 2,
'Toma decisiones a partir de la ubicación espacial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 7), 3,
'Dibuja recorridos, para ello considera los ángulos y la lateralidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 7), 4,
'Compara distancias a partir de la observación del plano al estimar con pasos, baldosas, etc.');

-- DBA 8: Describe situaciones de cambio y variación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 8,
'Describe cualitativamente situaciones de cambio y variación',
'Describe cualitativamente situaciones para identificar el cambio y la variación usando gestos, dibujos, diagramas, medios gráficos y simbólicos.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 8), 1,
'Identifica y nombra diferencias entre objetos o grupos de objetos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 8), 2,
'Comunica las características identificadas y justifica las diferencias que encuentra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 8), 3,
'Establece relaciones de dependencia entre magnitudes.');

-- DBA 9: Reconoce el signo igual como equivalencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 9,
'Reconoce el signo igual como equivalencia en expresiones matemáticas',
'Reconoce el signo igual como una equivalencia entre expresiones con sumas y restas.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 9), 1,
'Propone números que satisfacen una igualdad con sumas y restas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 9), 2,
'Describe las características de los números que deben ubicarse en una ecuación de tal manera que satisfaga la igualdad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 9), 3,
'Argumenta sobre el uso de la propiedad transitiva en un conjunto de igualdades.');

-- DBA 10: Clasifica y organiza datos estadísticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 4, 10,
'Clasifica y organiza datos utilizando representaciones gráficas',
'Clasifica y organiza datos, los representa utilizando tablas de conteo y pictogramas sin escalas, y comunica los resultados obtenidos para responder preguntas sencillas.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 10), 1,
'Identifica en fichas u objetos reales los valores de la variable en estudio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 10), 2,
'Organiza los datos en tablas de conteo y/o en pictogramas sin escala.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 10), 3,
'Lee la información presentada en tablas de conteo y/o pictogramas sin escala (1 a 1).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4 AND numero_dba = 10), 4,
'Comunica los resultados respondiendo preguntas tales como: ¿cuántos hay en total?, ¿cuántos hay de cada dato?, ¿cuál es el dato que más se repite?, ¿cuál es el dato que menos aparece?');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 2°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 2° grado (id_grado = 5)

-- DBA 1: Interpreta, propone y resuelve problemas aditivos y multiplicativos sencillos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 1, 
'Interpreta, propone y resuelve problemas aditivos y multiplicativos sencillos',
'Interpreta, propone y resuelve problemas aditivos (de composición, transformación y relación) que involucren la cantidad en una colección, la medida de magnitudes (longitud, peso, capacidad y duración de eventos) y problemas multiplicativos sencillos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 1), 1,
'Interpreta y construye diagramas para representar relaciones aditivas y multiplicativas entre cantidades que se presentan en situaciones o fenómenos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 1), 2,
'Describe y resuelve situaciones variadas con las operaciones de suma y resta en problemas cuya estructura puede ser a + b = ?, a + ? = c, o ? + b = c.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 1), 3,
'Reconoce en diferentes situaciones relaciones aditivas y multiplicativas y formula problemas a partir de ellas.');

-- DBA 2: Utiliza diferentes estrategias para calcular
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 2,
'Utiliza diferentes estrategias para calcular y estimar resultados',
'Utiliza diferentes estrategias para calcular (agrupar, representar elementos en colecciones, etc.) o estimar el resultado de una suma y resta, multiplicación o reparto equitativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 2), 1,
'Construye representaciones pictóricas y establece relaciones entre las cantidades involucradas en diferentes fenómenos o situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 2), 2,
'Usa algoritmos no convencionales para calcular o estimar el resultado de sumas, restas, multiplicaciones y divisiones entre números naturales, los describe y los justifica.');

-- DBA 3: Utiliza el Sistema de Numeración Decimal para comparar y ordenar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 3,
'Utiliza el Sistema de Numeración Decimal para comparar y ordenar',
'Utiliza el Sistema de Numeración Decimal para comparar, ordenar y establecer diferentes relaciones entre dos o más secuencias de números con ayuda de diferentes recursos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 3), 1,
'Compara y ordena números de menor a mayor y viceversa a través de recursos como la calculadora, aplicación, material gráfico que represente billetes, diagramas de colecciones, etc.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 3), 2,
'Propone ejemplos y comunica de forma oral y escrita las condiciones que puede establecer para conservar una relación (mayor que, menor que) cuando se aplican algunas operaciones a ellos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 3), 3,
'Reconoce y establece relaciones entre expresiones numéricas (hay más, hay menos, hay la misma cantidad) y describe el tipo de operaciones que debe realizarse para que, a pesar de cambiar los valores numéricos, la relación se conserve.');

-- DBA 4: Compara y explica características medibles
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 4,
'Compara y explica características que se pueden medir',
'Compara y explica características que se pueden medir, en el proceso de resolución de problemas relativos a longitud, superficie, velocidad, peso o duración de los eventos, entre otros.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 4), 1,
'Utiliza instrumentos y unidades de medición apropiados para medir magnitudes diferentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 4), 2,
'Describe los procedimientos necesarios para medir longitudes, superficies, capacidades, pesos de los objetos y la duración de los eventos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 4), 3,
'Mide magnitudes con unidades arbitrarias y estandarizadas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 4), 4,
'Estima la medida de diferentes magnitudes en situaciones prácticas.');

-- DBA 5: Utiliza patrones, unidades e instrumentos en procesos de medición
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 5,
'Utiliza patrones, unidades e instrumentos en procesos de medición',
'Utiliza patrones, unidades e instrumentos convencionales y no convencionales en procesos de medición, cálculo y estimación de magnitudes como longitud, peso, capacidad y tiempo.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 5), 1,
'Describe objetos y eventos de acuerdo con atributos medibles: superficie, tiempo, longitud, peso, ángulos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 5), 2,
'Realiza mediciones con instrumentos y unidades no convencionales, como pasos, cuadrados o rectángulos, cuartas, metros, entre otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 5), 3,
'Compara eventos según su duración, para ello utiliza relojes convencionales.');

-- DBA 6: Clasifica, describe y representa objetos del entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 6,
'Clasifica y describe objetos según propiedades geométricas',
'Clasifica, describe y representa objetos del entorno a partir de sus propiedades geométricas para establecer relaciones entre las formas bidimensionales y tridimensionales.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 6), 1,
'Reconoce las figuras geométricas según el número de lados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 6), 2,
'Diferencia los cuerpos geométricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 6), 3,
'Compara figuras y cuerpos geométricos y establece relaciones y diferencias entre ambos.');

-- DBA 7: Describe desplazamientos y referencia posición de objetos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 7,
'Describe desplazamientos y posiciones usando nociones geométricas',
'Describe desplazamientos y referencia la posición de un objeto mediante nociones de horizontalidad, verticalidad, paralelismo y perpendicularidad en la solución de problemas.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 7), 1,
'Describe desplazamientos a partir de las posiciones de las líneas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 7), 2,
'Representa líneas y reconoce las diferentes posiciones y la relación entre ellas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 7), 3,
'En dibujos, objetos o espacios reales, identifica posiciones de objetos, de aristas o líneas que son paralelas, verticales o perpendiculares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 7), 4,
'Argumenta las diferencias entre las posiciones de las líneas.');

-- DBA 8: Propone e identifica patrones en expresiones aritméticas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 8,
'Propone e identifica patrones en expresiones aritméticas',
'Propone e identifica patrones y utiliza propiedades de los números y de las operaciones para calcular valores desconocidos en expresiones aritméticas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 8), 1,
'Establece relaciones de reversibilidad entre la suma y la resta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 8), 2,
'Utiliza diferentes procedimientos para calcular un valor desconocido.');

-- DBA 9: Opera sobre secuencias numéricas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 9,
'Opera sobre secuencias numéricas para encontrar elementos faltantes',
'Opera sobre secuencias numéricas para encontrar números u operaciones faltantes y utiliza las propiedades de las operaciones en contextos escolares o extraescolares.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 9), 1,
'Utiliza las propiedades de las operaciones para encontrar números desconocidos en igualdades numéricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 9), 2,
'Utiliza las propiedades de las operaciones para encontrar operaciones faltantes en un proceso de cálculo numérico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 9), 3,
'Reconoce que un número puede escribirse de varias maneras equivalentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 9), 4,
'Utiliza ensayo y error para encontrar valores u operaciones desconocidas.');

-- DBA 10: Clasifica y organiza datos con escalas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 10,
'Clasifica y organiza datos con representaciones escaladas',
'Clasifica y organiza datos, los representa utilizando tablas de conteo, pictogramas con escalas y gráficos de puntos, comunica los resultados obtenidos para responder preguntas sencillas.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 10), 1,
'Identifica la equivalencia de fichas u objetos con el valor de la variable.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 10), 2,
'Organiza los datos en tablas de conteo y en pictogramas con escala (uno a muchos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 10), 3,
'Lee la información presentada en tablas de conteo, pictogramas con escala y gráficos de puntos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 10), 4,
'Comunica los resultados respondiendo preguntas tales como: ¿cuántos hay en total?, ¿cuántos hay de cada dato?, ¿cuál es el dato que más se repite?, ¿cuál es el dato que menos se repite?');

-- DBA 11: Explica la posibilidad de ocurrencia de eventos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 5, 11,
'Explica la posibilidad de ocurrencia de eventos cotidianos',
'Explica, a partir de la experiencia, la posibilidad de ocurrencia o no de un evento cotidiano y el resultado lo utiliza para predecir la ocurrencia de otros eventos.');

-- Evidencias para DBA 11
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 11), 1,
'Diferencia situaciones cotidianas cuyo resultado puede ser incierto de aquellas cuyo resultado es conocido o seguro.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 11), 2,
'Identifica resultados posibles o imposibles, según corresponda, en una situación cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 5 AND numero_dba = 11), 3,
'Predice la ocurrencia o no de eventos cotidianos basado en sus observaciones.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 3°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 3° grado (id_grado = 6)

-- DBA 1: Interpreta, formula y resuelve problemas aditivos y multiplicativos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 1, 
'Interpreta, formula y resuelve problemas aditivos y multiplicativos en diferentes contextos',
'Interpreta, formula y resuelve problemas aditivos de composición, transformación y comparación en diferentes contextos; y multiplicativos, directos e inversos, en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 1), 1,
'Construye diagramas para representar las relaciones observadas entre las cantidades presentes en una situación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 1), 2,
'Resuelve problemas aditivos (suma o resta) y multiplicativos (multiplicación o división) de composición de medida y de conteo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 1), 3,
'Propone estrategias para calcular el número de combinaciones posibles de un conjunto de atributos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 1), 4,
'Analiza los resultados ofrecidos por el cálculo matemático e identifica las condiciones bajo las cuales ese resultado es o no plausible.');

-- DBA 2: Propone, desarrolla y justifica estrategias para estimaciones y cálculos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 2,
'Propone y justifica estrategias para estimaciones y cálculos con operaciones básicas',
'Propone, desarrolla y justifica estrategias para hacer estimaciones y cálculos con operaciones básicas en la solución de problemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 2), 1,
'Utiliza las propiedades de las operaciones y del Sistema de Numeración Decimal para justificar acciones como: descomposición de números, completar hasta la decena más cercana, duplicar, cambiar la posición, multiplicar abreviadamente por múltiplos de 10, entre otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 2), 2,
'Reconoce el uso de las operaciones para calcular la medida (compuesta) de diferentes objetos de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 2), 3,
'Argumenta cuáles atributos de los objetos pueden ser medidos mediante la comparación directa con una unidad y cuáles pueden ser calculados con algunas operaciones entre números.');

-- DBA 3: Establece comparaciones entre cantidades y expresiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 3,
'Establece comparaciones entre cantidades y expresiones con operaciones',
'Establece comparaciones entre cantidades y expresiones que involucran operaciones y relaciones aditivas y multiplicativas y sus representaciones numéricas.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 3), 1,
'Realiza mediciones de un mismo objeto con otros de diferente tamaño y establece equivalencias entre ellas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 3), 2,
'Utiliza las razones y fracciones como una manera de establecer comparaciones entre dos cantidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 3), 3,
'Propone ejemplos de cantidades que se relacionan entre sí según correspondan a una fracción dada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 3), 4,
'Utiliza fracciones para expresar la relación de "el todo" con algunas de sus "partes", asimismo diferencia este tipo de relación de otras como las relaciones de equivalencia (igualdad) y de orden (mayor que y menor que).');

-- DBA 4: Describe y argumenta relaciones entre área y perímetro
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 4,
'Describe y argumenta relaciones entre área y perímetro de figuras planas',
'Describe y argumenta posibles relaciones entre los valores del área y el perímetro de figuras planas (especialmente cuadriláteros).');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 4), 1,
'Toma decisiones sobre la magnitud a medir (área o longitud) según la necesidad de una situación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 4), 2,
'Realiza recubrimientos de superficies con diferentes figuras planas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 4), 3,
'Mide y calcula el área y el perímetro de un rectángulo y expresa el resultado en unidades apropiadas según el caso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 4), 4,
'Explica cómo figuras de igual perímetro pueden tener diferente área.');

-- DBA 5: Realiza estimaciones y mediciones de diferentes magnitudes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 5,
'Realiza estimaciones y mediciones de diferentes magnitudes para resolver problemas',
'Realiza estimaciones y mediciones de volumen, capacidad, longitud, área, peso de objetos o la duración de eventos como parte del proceso para resolver diferentes problemas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 5), 1,
'Compara objetos según su longitud, área, capacidad, volumen, etc.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 5), 2,
'Hace estimaciones de longitud, área, volumen, peso y tiempo según su necesidad en la situación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 5), 3,
'Hace estimaciones de volumen, área y longitud en presencia de los objetos y los instrumentos de medida y en ausencia de ellos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 5), 4,
'Empaca objetos en cajas y recipientes variados y calcula la cantidad que podría caber; para ello tiene en cuenta la forma y volumen de los objetos a empacar y la capacidad del recipiente en el que se empaca.');

-- DBA 6: Describe y representa formas bidimensionales y tridimensionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 6,
'Describe y representa formas geométricas según propiedades',
'Describe y representa formas bidimensionales y tridimensionales de acuerdo con las propiedades geométricas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 6), 1,
'Relaciona objetos de su entorno con formas bidimensionales y tridimensionales, nombra y describe sus elementos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 6), 2,
'Clasifica y representa formas bidimensionales y tridimensionales tomando en cuenta sus características geométricas comunes y describe el criterio utilizado.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 6), 3,
'Interpreta, compara y justifica propiedades de formas bidimensionales y tridimensionales.');

-- DBA 7: Formula y resuelve problemas de posición, dirección y movimiento
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 7,
'Formula y resuelve problemas de posición, dirección y movimiento',
'Formula y resuelve problemas que se relacionan con la posición, la dirección y el movimiento de objetos en el entorno.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 7), 1,
'Localiza objetos o personas a partir de la descripción o representación de una trayectoria y construye representaciones pictóricas para describir sus relaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 7), 2,
'Identifica y describe patrones de movimiento de figuras bidimensionales que se asocian con transformaciones como: reflexiones, traslaciones y rotaciones de figuras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 7), 3,
'Identifica las propiedades de los objetos que se conservan y las que varían cuando se realizan este tipo de transformaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 7), 4,
'Plantea y resuelve situaciones en las que se requiere analizar las transformaciones de diferentes figuras en el plano.');

-- DBA 8: Describe y representa aspectos de variación en secuencias
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 8,
'Describe y representa aspectos de variación en secuencias y situaciones',
'Describe y representa los aspectos que cambian y permanecen constantes en secuencias y en otras situaciones de variación.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 8), 1,
'Describe de manera cualitativa situaciones de cambio y variación utilizando lenguaje natural, gestos, dibujos y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 8), 2,
'Construye secuencias numéricas y geométricas utilizando propiedades de los números y de las figuras geométricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 8), 3,
'Encuentra y representa generalidades y valida sus hallazgos de acuerdo al contexto.');

-- DBA 9: Argumenta sobre situaciones con datos desconocidos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 9,
'Argumenta sobre situaciones con datos desconocidos según el contexto',
'Argumenta sobre situaciones numéricas, geométricas y enunciados verbales en los que aparecen datos desconocidos para definir sus posibles valores según el contexto.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 9), 1,
'Propone soluciones con base en los datos a pesar de no conocer el número.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 9), 2,
'Toma decisiones sobre cantidades aunque no conozca exactamente los valores.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 9), 3,
'Trabaja sobre números desconocidos y con esos números para dar respuestas a los problemas.');

-- DBA 10: Lee e interpreta información estadística
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 10,
'Lee e interpreta información en representaciones estadísticas',
'Lee e interpreta información contenida en tablas de frecuencia, gráficos de barras y/o pictogramas con escala, para formular y resolver preguntas de situaciones de su entorno.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 10), 1,
'Identifica las características de la población y halla su tamaño a partir de diferentes representaciones estadísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 10), 2,
'Construye tablas y gráficos que representan los datos a partir de la información dada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 10), 3,
'Analiza e interpreta información que ofrecen las tablas y los gráficos de acuerdo con el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 10), 4,
'Identifica la moda a partir de datos que se presentan en gráficos y tablas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 10), 5,
'Compara la información representada en diferentes tablas y gráficos para formular y responder preguntas.');

-- DBA 11: Plantea y resuelve preguntas sobre situaciones aleatorias
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 6, 11,
'Plantea y resuelve preguntas sobre situaciones aleatorias y probabilidad',
'Plantea y resuelve preguntas sobre la posibilidad de ocurrencia de situaciones aleatorias cotidianas y cuantifica la posibilidad de ocurrencia de eventos simples en una escala cualitativa (mayor, menor e igual).');

-- Evidencias para DBA 11
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 11), 1,
'Formula y resuelve preguntas que involucran expresiones que jerarquizan la posibilidad de ocurrencia de un evento, por ejemplo: imposible, menos posible, igualmente posible, más posible, seguro.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 11), 2,
'Representa los posibles resultados de una situación aleatoria simple por enumeración o usando diagramas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 11), 3,
'Asigna la posibilidad de ocurrencia de un evento de acuerdo con la escala definida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 6 AND numero_dba = 11), 4,
'Predice la posibilidad de ocurrencia de un evento al utilizar los resultados de una situación aleatoria.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 4°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 4° grado (id_grado = 7)

-- DBA 1: Interpreta las fracciones como razón, relación parte-todo, cociente y operador
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 1, 
'Interpreta las fracciones como razón, relación parte-todo, cociente y operador en diferentes contextos',
'Interpreta las fracciones como razón, relación parte-todo, cociente y operador en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 1), 1,
'Describe situaciones en las cuales puede usar fracciones y decimales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 1), 2,
'Reconoce situaciones en las que dos cantidades covarían y cuantifica el efecto que los cambios en una de ellas tienen en los cambios de la otra y a partir de este comportamiento determina la razón entre ellas.');

-- DBA 2: Describe y justifica diferentes estrategias para representar, operar y hacer estimaciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 2,
'Describe y justifica diferentes estrategias para representar, operar y hacer estimaciones con números naturales y racionales',
'Describe y justifica diferentes estrategias para representar, operar y hacer estimaciones con números naturales y números racionales (fraccionarios), expresados como fracción o como decimal.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 2), 1,
'Utiliza el sistema de numeración decimal para representar, comparar y operar con números mayores o iguales a 10.000.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 2), 2,
'Describe y desarrolla estrategias para calcular sumas y restas basadas en descomposiciones aditivas y multiplicativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 2), 3,
'Utiliza y justifica algoritmos estandarizados y no estandarizados para realizar operaciones aditivas con representaciones decimales provenientes de fraccionarios cuyas expresiones tengan denominador 10, 100, etc.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 2), 4,
'Identifica y construye fracciones equivalentes a una fracción dada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 2), 5,
'Propone estrategias para calcular sumas y restas de algunos fraccionarios.');

-- DBA 3: Establece relaciones mayor que, menor que, igual que y relaciones multiplicativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 3,
'Establece relaciones de comparación y multiplicativas entre números racionales',
'Establece relaciones mayor que, menor que, igual que y relaciones multiplicativas entre números racionales en sus formas de fracción o decimal.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 3), 1,
'Construye y utiliza representaciones pictóricas para comparar números racionales (como fracción o decimales).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 3), 2,
'Establece, justifica y utiliza criterios para comparar fracciones y decimales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 3), 3,
'Construye y compara expresiones numéricas que contienen decimales y fracciones.');

-- DBA 4: Caracteriza y compara atributos medibles de los objetos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 4,
'Caracteriza y compara atributos medibles de los objetos con procedimientos e instrumentos',
'Caracteriza y compara atributos medibles de los objetos (densidad, dureza, viscosidad, masa, capacidad de los recipientes, temperatura) con respecto a procedimientos, instrumentos y unidades de medición; y con respecto a las necesidades a las que responden.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 4), 1,
'Reconoce que para medir la capacidad y la masa se hacen comparaciones con la capacidad de recipientes de diferentes tamaños y con paquetes de diferentes masas, respectivamente (litros, centilitros, galón, botella, etc., para capacidad; gramos, kilogramos, libras, arrobas, etc., para masa).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 4), 2,
'Diferencia los atributos medibles como capacidad, masa, volumen, entre otros, a partir de los procedimientos e instrumentos empleados para medirlos y los usos de cada uno en la solución de problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 4), 3,
'Identifica unidades y los instrumentos para medir masa y capacidad, y establece relaciones entre ellos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 4), 4,
'Describe procesos para medir capacidades de un recipiente o el peso de un objeto o producto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 4), 5,
'Argumenta sobre la importancia y necesidad de medir algunas magnitudes como densidad, dureza, viscosidad, masa, capacidad, etc.');

-- DBA 5: Elige instrumentos y unidades estandarizadas y no estandarizadas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 5,
'Elige instrumentos y unidades para estimar y medir diferentes magnitudes',
'Elige instrumentos y unidades estandarizadas y no estandarizadas para estimar y medir longitud, área, volumen, capacidad, peso y masa, duración, rapidez, temperatura, y a partir de ellos hace los cálculos necesarios para resolver problemas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 5), 1,
'Expresa una misma medida en diferentes unidades, establece equivalencias entre ellas y toma decisiones de la unidad más conveniente según las necesidades de la situación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 5), 2,
'Propone diferentes procedimientos para realizar cálculos (suma y resta de medidas, multiplicación y división de una medida y un número) que aparecen al resolver problemas en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 5), 3,
'Emplea las relaciones de proporcionalidad directa e inversa para resolver diversas situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 5), 4,
'Propone y explica procedimientos para lograr mayor precisión en la medición de cantidades de líquidos, masa, etc.');

-- DBA 6: Identifica, describe y representa figuras bidimensionales y tridimensionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 6,
'Identifica, describe y representa figuras geométricas y establece relaciones',
'Identifica, describe y representa figuras bidimensionales y tridimensionales, y establece relaciones entre ellas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 6), 1,
'Arma, desarma y crea formas bidimensionales y tridimensionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 6), 2,
'Reconoce entre un conjunto de desarrollos planos, los que corresponden a determinados sólidos atendiendo a las relaciones entre la posición de las diferentes caras y aristas.');

-- DBA 7: Identifica los movimientos realizados a una figura en el plano
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 7,
'Identifica movimientos y modificaciones de figuras en el plano',
'Identifica los movimientos realizados a una figura en el plano respecto a una posición o eje (rotación, traslación y simetría) y las modificaciones que pueden sufrir las formas (ampliación–reducción).');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 7), 1,
'Aplica movimientos a figuras en el plano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 7), 2,
'Diferencia los efectos de la ampliación y la reducción.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 7), 3,
'Elabora argumentos referentes a las modificaciones que sufre una imagen al ampliarla o reducirla.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 7), 4,
'Representa elementos del entorno que sufren modificaciones en su forma.');

-- DBA 8: Identifica, documenta e interpreta variaciones de dependencia entre cantidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 8,
'Identifica e interpreta variaciones de dependencia entre cantidades',
'Identifica, documenta e interpreta variaciones de dependencia entre cantidades en diferentes fenómenos (en las matemáticas y en otras ciencias) y los representa por medio de gráficas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 8), 1,
'Realiza cálculos numéricos, organiza la información en tablas, elabora representaciones gráficas y las interpreta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 8), 2,
'Propone patrones de comportamiento numérico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 8), 3,
'Trabaja sobre números desconocidos y con esos números para dar respuestas a los problemas.');

-- DBA 9: Identifica patrones en secuencias y utiliza generalizaciones aritméticas o algebraicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 9,
'Identifica patrones en secuencias y establece generalizaciones',
'Identifica patrones en secuencias (aditivas o multiplicativas) y los utiliza para establecer generalizaciones aritméticas o algebraicas.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 9), 1,
'Comunica en forma verbal y pictórica las regularidades observadas en una secuencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 9), 2,
'Establece diferentes estrategias para calcular los siguientes elementos en una secuencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 9), 3,
'Conjetura y argumenta un valor futuro en una secuencia aritmética o geométrica (por ejemplo, en una secuencia de figuras predecir la posición 10, 20 o 100).');

-- DBA 10: Recopila y organiza datos en tablas de doble entrada
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 10,
'Recopila y organiza datos en representaciones estadísticas avanzadas',
'Recopila y organiza datos en tablas de doble entrada y los representa en gráficos de barras agrupadas o gráficos de líneas, para dar respuesta a una pregunta planteada. Interpreta la información y comunica sus conclusiones.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 10), 1,
'Elabora encuestas sencillas para obtener la información pertinente para responder la pregunta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 10), 2,
'Construye tablas de doble entrada y gráficos de barras agrupadas, gráficos de líneas o pictogramas con escala.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 10), 3,
'Lee e interpreta los datos representados en tablas de doble entrada, gráficos de barras agrupados, gráficos de línea o pictogramas con escala.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 10), 4,
'Encuentra e interpreta la moda y el rango del conjunto de datos y describe el comportamiento de los datos para responder las preguntas planteadas.');

-- DBA 11: Comprende y explica la diferencia entre situaciones aleatorias y determinísticas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 7, 11,
'Comprende situaciones aleatorias y determinísticas usando vocabulario adecuado',
'Comprende y explica, usando vocabulario adecuado, la diferencia entre una situación aleatoria y una determinística y predice, en una situación de la vida cotidiana, la presencia o no del azar.');

-- Evidencias para DBA 11
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 11), 1,
'Reconoce situaciones aleatorias en contextos cotidianos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 11), 2,
'Enuncia diferencias entre situaciones aleatorias y deterministas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 11), 3,
'Usa adecuadamente expresiones como azar o posibilidad, aleatoriedad, determinístico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 7 AND numero_dba = 11), 4,
'Anticipa los posibles resultados de una situación aleatoria.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 5°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 5° grado (id_grado = 8)

-- DBA 1: Interpreta, formula y resuelve problemas con operaciones básicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 1, 
'Interpreta, formula y resuelve problemas con adición, sustracción, multiplicación y división',
'Interpreta, formula y resuelve problemas que involucren adición, sustracción, multiplicación y división con números naturales, fraccionarios y decimales, en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 1), 1,
'Analiza los datos y las condiciones de un problema para determinar qué operaciones realizar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 1), 2,
'Representa y comunica la información dada en un problema con ayuda de diagramas, tablas o esquemas que muestren las relaciones entre las cantidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 1), 3,
'Utiliza las propiedades de las operaciones para desarrollar estrategias de cálculo y justifica sus resultados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 1), 4,
'Realiza operaciones con números naturales, fraccionarios y decimales y verifica la coherencia de los resultados en el contexto del problema.');

-- DBA 2: Emplea diferentes estrategias para estimar, calcular y verificar resultados
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 2,
'Emplea diferentes estrategias para estimar, calcular y verificar resultados de operaciones',
'Emplea diferentes estrategias (mentales, escritas, gráficas o tecnológicas) para estimar, calcular y verificar los resultados de operaciones con números naturales, fraccionarios y decimales.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 2), 1,
'Usa diferentes procedimientos para estimar resultados antes de calcularlos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 2), 2,
'Selecciona y aplica algoritmos convencionales y no convencionales de cálculo de acuerdo con la situación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 2), 3,
'Utiliza instrumentos tecnológicos (como calculadora, software o recursos digitales) para verificar o comprobar sus resultados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 2), 4,
'Argumenta la validez de sus respuestas en función del contexto.');

-- DBA 3: Utiliza el Sistema de Numeración Decimal y relaciones entre fracciones, decimales y porcentajes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 3,
'Utiliza relaciones entre fracciones, decimales y porcentajes para comparar y ordenar',
'Utiliza el Sistema de Numeración Decimal y las relaciones entre fracciones, decimales y porcentajes para comparar, ordenar y establecer equivalencias entre cantidades.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 3), 1,
'Representa una misma cantidad en diferentes formas (como fracción, número decimal o porcentaje).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 3), 2,
'Identifica y utiliza equivalencias entre fracciones, decimales y porcentajes para comparar y ordenar cantidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 3), 3,
'Establece relaciones de proporcionalidad directa entre cantidades y usa razones y porcentajes para resolver problemas.');

-- DBA 4: Describe y compara atributos medibles aplicando fórmulas y procedimientos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 4,
'Describe y compara atributos medibles aplicando fórmulas y procedimientos',
'Describe y compara atributos medibles (longitud, área, volumen, masa, capacidad, tiempo, temperatura) y aplica fórmulas y procedimientos para calcular medidas en contextos de su entorno.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 4), 1,
'Utiliza instrumentos adecuados y unidades convencionales para medir diferentes atributos de objetos y eventos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 4), 2,
'Aplica las relaciones entre las unidades del sistema métrico decimal en la resolución de problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 4), 3,
'Calcula áreas y perímetros de figuras planas (triángulos, rectángulos, paralelogramos, entre otros) y volúmenes de prismas rectos y cubos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 4), 4,
'Explica la diferencia entre medir, estimar y calcular una magnitud.');

-- DBA 5: Realiza mediciones con unidades estandarizadas y expresa equivalencias
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 5,
'Realiza mediciones con unidades estandarizadas y expresa equivalencias',
'Realiza mediciones con unidades estandarizadas y expresa los resultados usando equivalencias entre unidades del mismo sistema o entre diferentes sistemas de medida.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 5), 1,
'Mide longitudes, áreas, volúmenes y tiempos usando unidades adecuadas y expresa las equivalencias entre ellas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 5), 2,
'Convierte medidas entre unidades del sistema métrico decimal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 5), 3,
'Justifica las conversiones realizadas mediante razonamientos proporcionales.');

-- DBA 6: Reconoce, describe, clasifica y representa figuras y cuerpos geométricos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 6,
'Reconoce y representa figuras y cuerpos geométricos según sus propiedades',
'Reconoce, describe, clasifica y representa figuras y cuerpos geométricos a partir de sus propiedades (lados, ángulos, caras, vértices, aristas, simetrías).');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 6), 1,
'Identifica figuras y cuerpos geométricos en objetos de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 6), 2,
'Clasifica figuras planas según el número y medida de sus lados y ángulos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 6), 3,
'Construye figuras geométricas con instrumentos de medición o programas informáticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 6), 4,
'Describe y explica las propiedades de las figuras que construye.');

-- DBA 7: Identifica y representa movimientos y transformaciones geométricas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 7,
'Identifica y representa movimientos y transformaciones geométricas en el plano',
'Identifica y representa movimientos y transformaciones (traslación, rotación, reflexión, ampliación o reducción) en el plano y en objetos del entorno.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 7), 1,
'Reconoce figuras y objetos que se relacionan mediante transformaciones geométricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 7), 2,
'Aplica transformaciones en el plano y describe los cambios en la posición, tamaño o forma.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 7), 3,
'Dibuja o genera mediante software figuras resultantes de transformaciones geométricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 7), 4,
'Explica qué propiedades se conservan y cuáles cambian en una figura sometida a transformaciones.');

-- DBA 8: Reconoce y describe relaciones de dependencia y variación entre cantidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 8,
'Reconoce relaciones de dependencia y variación entre cantidades',
'Reconoce y describe relaciones de dependencia y variación entre dos o más cantidades en diferentes contextos y las representa mediante tablas y gráficas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 8), 1,
'Identifica en una situación las magnitudes que covarían y describe cómo cambian.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 8), 2,
'Representa relaciones de dependencia entre cantidades en tablas y gráficos de coordenadas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 8), 3,
'Interpreta las gráficas para describir comportamientos o hacer predicciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 8), 4,
'Formula conclusiones sobre los patrones de cambio observados.');

-- DBA 9: Reconoce, describe y aplica patrones numéricos y geométricos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 9,
'Reconoce y aplica patrones numéricos y geométricos estableciendo generalizaciones',
'Reconoce, describe y aplica patrones numéricos y geométricos y establece generalizaciones mediante expresiones simbólicas o reglas.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 9), 1,
'Identifica regularidades en secuencias numéricas, gráficas o geométricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 9), 2,
'Formula y justifica una regla general que permite obtener cualquier término de la secuencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 9), 3,
'Explica cómo utilizar una expresión aritmética o algebraica para representar el patrón encontrado.');

-- DBA 10: Recoge, organiza y representa datos estadísticos interpretando conclusiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 10,
'Recoge y representa datos estadísticos interpretando y comunicando conclusiones',
'Recoge, organiza y representa datos en tablas, diagramas y gráficos estadísticos, los interpreta y comunica conclusiones pertinentes.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 10), 1,
'Formula preguntas estadísticas y planifica la recolección de datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 10), 2,
'Organiza los datos recolectados en tablas de frecuencia y los representa mediante gráficos de barras, de líneas o pictogramas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 10), 3,
'Interpreta y compara representaciones gráficas para responder preguntas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 10), 4,
'Calcula e interpreta medidas de tendencia central como la moda y el promedio.');

-- DBA 11: Identifica, describe y predice la posibilidad de ocurrencia de eventos simples
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 8, 11,
'Identifica y predice la posibilidad de ocurrencia de eventos simples en contextos de azar',
'Identifica, describe y predice la posibilidad de ocurrencia de eventos simples en contextos de azar y los representa mediante expresiones cualitativas o numéricas.');

-- Evidencias para DBA 11
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 11), 1,
'Distingue entre situaciones deterministas y aleatorias en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 11), 2,
'Enumera los posibles resultados de un experimento aleatorio simple.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 11), 3,
'Estima y expresa cualitativa o cuantitativamente la probabilidad de ocurrencia de un evento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 8 AND numero_dba = 11), 4,
'Compara eventos según su mayor o menor posibilidad de ocurrencia.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 6°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 6° grado (id_grado = 9)

-- DBA 1: Interpreta, formula y resuelve problemas con operaciones básicas en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 1, 
'Interpreta, formula y resuelve problemas con números naturales, enteros, fraccionarios y decimales',
'Interpreta, formula y resuelve problemas que involucran las operaciones con números naturales, enteros, fraccionarios y decimales en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 1), 1,
'Reconoce las diferentes clases de números y los usos que tienen en situaciones cotidianas y matemáticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 1), 2,
'Usa las propiedades de las operaciones y las relaciones entre los números para realizar cálculos exactos o aproximados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 1), 3,
'Elige y aplica estrategias de cálculo mental, escrito o tecnológico para resolver problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 1), 4,
'Explica y justifica los procedimientos y resultados obtenidos en el contexto del problema.');

-- DBA 2: Establece relaciones y equivalencias entre fracciones, decimales y porcentajes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 2,
'Establece relaciones y equivalencias entre fracciones, decimales y porcentajes',
'Establece relaciones y equivalencias entre fracciones, números decimales y porcentajes para comparar, ordenar y resolver problemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 2), 1,
'Representa una misma cantidad en forma de fracción, número decimal y porcentaje.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 2), 2,
'Explica las relaciones entre las tres representaciones y las utiliza en el análisis de situaciones de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 2), 3,
'Aplica los porcentajes en la resolución de problemas de la vida cotidiana.');

-- DBA 3: Identifica, interpreta y utiliza propiedades de potencias y raíces cuadradas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 3,
'Identifica y utiliza propiedades de potencias y raíces cuadradas en resolución de problemas',
'Identifica, interpreta y utiliza las propiedades de las potencias y raíces cuadradas en la resolución de problemas.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 3), 1,
'Representa productos repetidos mediante potencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 3), 2,
'Reconoce y utiliza la raíz cuadrada como operación inversa de la potencia con exponente 2.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 3), 3,
'Aplica las propiedades de las potencias y raíces cuadradas para resolver problemas numéricos o geométricos.');

-- DBA 4: Mide y compara magnitudes utilizando unidades convencionales, instrumentos y fórmulas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 4,
'Mide y compara magnitudes utilizando unidades convencionales, instrumentos y fórmulas',
'Mide y compara longitudes, áreas, volúmenes, capacidades, masas, tiempos y ángulos utilizando unidades convencionales, instrumentos de medida y fórmulas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 4), 1,
'Reconoce las unidades de medida más adecuadas para cada magnitud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 4), 2,
'Utiliza instrumentos apropiados (regla, transportador, balanza, cronómetro, entre otros) para medir.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 4), 3,
'Calcula perímetros, áreas y volúmenes de figuras y cuerpos geométricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 4), 4,
'Justifica los procedimientos usados y verifica la coherencia de los resultados.');

-- DBA 5: Establece relaciones entre perímetro, área y volumen en resolución de problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 5,
'Establece relaciones entre perímetro, área y volumen de figuras y cuerpos geométricos',
'Establece relaciones entre el perímetro, el área y el volumen de figuras y cuerpos geométricos en la resolución de problemas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 5), 1,
'Explica la relación entre las dimensiones lineales de una figura y su perímetro, área o volumen.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 5), 2,
'Compara figuras o cuerpos con igual área y diferente perímetro, y viceversa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 5), 3,
'Formula y resuelve problemas que impliquen calcular perímetros, áreas o volúmenes según el contexto.');

-- DBA 6: Identifica y representa figuras planas y cuerpos geométricos en sistemas de referencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 6,
'Identifica y representa figuras planas y cuerpos geométricos en distintos sistemas de referencia',
'Identifica, describe y representa figuras planas y cuerpos geométricos en distintos sistemas de referencia.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 6), 1,
'Dibuja figuras geométricas usando coordenadas cartesianas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 6), 2,
'Reconoce y describe las propiedades de las figuras y cuerpos en función de sus elementos (lados, vértices, ángulos, caras, aristas).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 6), 3,
'Interpreta representaciones planas de cuerpos tridimensionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 6), 4,
'Usa software geométrico o herramientas digitales para construir y analizar figuras.');

-- DBA 7: Describe y representa movimientos y transformaciones en el plano
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 7,
'Describe y representa movimientos y transformaciones geométricas en el plano',
'Describe y representa movimientos y transformaciones en el plano (traslaciones, rotaciones, simetrías, ampliaciones y reducciones).');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 7), 1,
'Aplica transformaciones geométricas a figuras en el plano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 7), 2,
'Reconoce figuras congruentes y semejantes resultantes de transformaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 7), 3,
'Explica qué propiedades geométricas se conservan en cada tipo de transformación.');

-- DBA 8: Reconoce relaciones de dependencia y variación entre cantidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 8,
'Reconoce relaciones de dependencia y variación representándolas mediante expresiones, tablas y gráficas',
'Reconoce y describe relaciones de dependencia y variación entre dos o más cantidades y las representa mediante expresiones, tablas y gráficas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 8), 1,
'Identifica la relación de dependencia entre magnitudes en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 8), 2,
'Representa las relaciones mediante tablas de valores y gráficos cartesianos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 8), 3,
'Interpreta y explica la información contenida en una gráfica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 8), 4,
'Utiliza expresiones algebraicas simples para representar la relación entre las magnitudes.');

-- DBA 9: Usa expresiones algebraicas, igualdades y desigualdades para representar y resolver problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 9,
'Usa expresiones algebraicas, igualdades y desigualdades para representar y resolver problemas',
'Usa expresiones algebraicas, igualdades y desigualdades para representar y resolver problemas.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 9), 1,
'Representa situaciones mediante expresiones algebraicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 9), 2,
'Identifica y utiliza igualdades y desigualdades numéricas y algebraicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 9), 3,
'Sustituye valores en una expresión para verificar la validez de una igualdad o desigualdad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 9), 4,
'Resuelve ecuaciones sencillas de primer grado con una incógnita.');

-- DBA 10: Recoge, organiza, representa e interpreta datos estadísticos comunicando conclusiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 10,
'Recoge y representa datos estadísticos interpretando y comunicando conclusiones basadas en la información',
'Recoge, organiza, representa e interpreta datos en tablas y gráficos de barras, de líneas o circulares y comunica conclusiones basadas en la información.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 10), 1,
'Formula preguntas estadísticas y planifica la recolección de datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 10), 2,
'Organiza los datos en tablas de frecuencia y los representa mediante diferentes tipos de gráficos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 10), 3,
'Interpreta la información representada y comunica conclusiones coherentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 10), 4,
'Calcula e interpreta medidas de tendencia central (media, mediana y moda).');

-- DBA 11: Identifica y describe eventos aleatorios determinando su probabilidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 9, 11,
'Identifica eventos aleatorios simples y determina su probabilidad de ocurrencia',
'Identifica y describe eventos aleatorios simples y determina su probabilidad de ocurrencia de manera cualitativa y cuantitativa.');

-- Evidencias para DBA 11
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 11), 1,
'Reconoce situaciones aleatorias y determinísticas en distintos contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 11), 2,
'Enumera los posibles resultados de un experimento aleatorio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 11), 3,
'Calcula la probabilidad teórica de ocurrencia de un evento simple.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 9 AND numero_dba = 11), 4,
'Compara probabilidades y argumenta sus conclusiones.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 7°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 7° grado (id_grado = 10)

-- DBA 1: Interpreta, formula y resuelve problemas con números racionales en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 1, 
'Interpreta, formula y resuelve problemas con números enteros, fraccionarios, decimales y racionales',
'Interpreta, formula y resuelve problemas que involucran operaciones con números enteros, fraccionarios, decimales y racionales, en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 1), 1,
'Utiliza los números racionales para representar, comparar y ordenar cantidades en distintas situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 1), 2,
'Aplica las propiedades de las operaciones para realizar cálculos exactos o aproximados con números racionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 1), 3,
'Escoge y aplica estrategias de cálculo mental, escrito o tecnológico para resolver problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 1), 4,
'Verifica y justifica los resultados de las operaciones en función del contexto del problema.');

-- DBA 2: Reconoce, representa y utiliza potencias con exponente entero, raíces y notación científica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 2,
'Reconoce y utiliza potencias con exponente entero, raíces y notación científica',
'Reconoce, representa y utiliza potencias con exponente entero, raíces y notación científica para resolver problemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 2), 1,
'Representa productos repetidos y razones inversas mediante potencias y raíces.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 2), 2,
'Aplica las propiedades de las potencias y raíces en la resolución de problemas numéricos o geométricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 2), 3,
'Usa la notación científica para expresar, comparar y operar con números muy grandes o muy pequeños.');

-- DBA 3: Formula y resuelve ecuaciones e inecuaciones de primer grado con una incógnita
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 3,
'Formula procedimientos para resolver ecuaciones e inecuaciones de primer grado',
'Formula, desarrolla y justifica procedimientos para resolver ecuaciones e inecuaciones de primer grado con una incógnita y problemas que las involucran.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 3), 1,
'Representa situaciones de la vida cotidiana mediante ecuaciones o inecuaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 3), 2,
'Despeja la incógnita aplicando las propiedades de la igualdad y la desigualdad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 3), 3,
'Verifica la validez de una solución sustituyendo el valor encontrado.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 3), 4,
'Interpreta el significado del resultado obtenido dentro del contexto del problema.');

-- DBA 4: Reconoce propiedades y relaciones entre ángulos, triángulos y polígonos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 4,
'Reconoce propiedades y relaciones entre ángulos, triángulos, cuadriláteros y polígonos',
'Reconoce y describe propiedades y relaciones entre ángulos, triángulos, cuadriláteros y otros polígonos en diferentes contextos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 4), 1,
'Identifica y clasifica los triángulos y cuadriláteros según sus lados y ángulos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 4), 2,
'Reconoce las propiedades de los ángulos formados por dos rectas paralelas cortadas por una secante.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 4), 3,
'Calcula medidas de ángulos y lados aplicando relaciones geométricas conocidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 4), 4,
'Utiliza las propiedades geométricas para resolver problemas de su entorno.');

-- DBA 5: Calcula y compara perímetros, áreas y volúmenes usando fórmulas y proporcionalidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 5,
'Calcula y compara perímetros, áreas y volúmenes usando fórmulas y relaciones de proporcionalidad',
'Calcula y compara perímetros, áreas y volúmenes de figuras planas y cuerpos geométricos usando fórmulas y relaciones de proporcionalidad.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 5), 1,
'Aplica fórmulas conocidas para calcular perímetros, áreas y volúmenes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 5), 2,
'Establece relaciones entre las dimensiones lineales y las medidas de área y volumen.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 5), 3,
'Compara figuras o cuerpos geométricos de igual volumen o área pero diferentes formas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 5), 4,
'Explica las diferencias observadas en los resultados.');

-- DBA 6: Reconoce y representa transformaciones geométricas en el plano cartesiano
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 6,
'Reconoce y representa transformaciones geométricas en el plano cartesiano',
'Reconoce y representa transformaciones geométricas (traslaciones, rotaciones, simetrías y homotecias) en el plano cartesiano.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 6), 1,
'Representa figuras en el plano cartesiano y las transforma aplicando diferentes movimientos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 6), 2,
'Determina las coordenadas de los puntos transformados y las compara con las originales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 6), 3,
'Explica las propiedades que permanecen invariantes en cada tipo de transformación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 6), 4,
'Utiliza software o herramientas tecnológicas para construir y analizar transformaciones geométricas.');

-- DBA 7: Reconoce relaciones de proporcionalidad directa e inversa y las aplica en problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 7,
'Reconoce relaciones de proporcionalidad directa e inversa aplicándolas en resolución de problemas',
'Reconoce y representa relaciones de proporcionalidad directa e inversa y las aplica en la resolución de problemas.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 7), 1,
'Identifica en una situación las magnitudes que se relacionan de manera directa o inversa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 7), 2,
'Representa la relación entre magnitudes mediante tablas, expresiones algebraicas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 7), 3,
'Interpreta la constante de proporcionalidad y su significado en el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 7), 4,
'Usa la proporcionalidad para resolver problemas de la vida cotidiana.');

-- DBA 8: Reconoce relaciones lineales y no lineales representándolas mediante tablas, expresiones y gráficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 8,
'Reconoce relaciones lineales y no lineales entre magnitudes representándolas en diferentes formas',
'Reconoce y describe relaciones lineales y no lineales entre magnitudes y las representa mediante tablas, expresiones y gráficas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 8), 1,
'Distingue entre relaciones lineales y no lineales observando el comportamiento de los datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 8), 2,
'Representa las relaciones mediante expresiones algebraicas y las grafica en el plano cartesiano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 8), 3,
'Interpreta los parámetros de una relación lineal (pendiente y punto de corte).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 8), 4,
'Explica la diferencia entre un comportamiento lineal y uno no lineal.');

-- DBA 9: Interpreta, organiza y representa información estadística en diferentes gráficos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 9,
'Interpreta y representa información estadística en tablas de frecuencia y diversos gráficos',
'Interpreta, organiza y representa información estadística en tablas de frecuencia, gráficos de barras, de líneas o circulares y diagramas de tallo y hoja.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 9), 1,
'Recolecta y organiza datos de manera adecuada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 9), 2,
'Representa la información mediante gráficos apropiados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 9), 3,
'Calcula e interpreta medidas de tendencia central (media, mediana y moda) y de dispersión (rango).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 9), 4,
'Comunica conclusiones basadas en la información obtenida.');

-- DBA 10: Reconoce y calcula probabilidad de eventos simples y compuestos en experimentos aleatorios
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 10, 10,
'Reconoce y calcula probabilidad de eventos simples y compuestos en experimentos aleatorios',
'Reconoce y calcula la probabilidad de ocurrencia de eventos simples y compuestos en experimentos aleatorios.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 10), 1,
'Enumera los posibles resultados de un experimento aleatorio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 10), 2,
'Determina el espacio muestral y los eventos de interés.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 10), 3,
'Calcula probabilidades teóricas y experimentales y las compara.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 10 AND numero_dba = 10), 4,
'Argumenta sobre la validez de los resultados obtenidos.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 8°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 8° grado (id_grado = 11)

-- DBA 1: Interpreta, formula y resuelve problemas con números racionales e irracionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 1, 
'Interpreta, formula y resuelve problemas con números racionales e irracionales en diferentes contextos',
'Interpreta, formula y resuelve problemas que involucran operaciones con números racionales e irracionales en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 1), 1,
'Reconoce y utiliza diferentes formas de representación de los números racionales e irracionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 1), 2,
'Aplica las propiedades de las operaciones para realizar cálculos con estos números.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 1), 3,
'Escoge y justifica estrategias de cálculo adecuadas según el tipo de número y el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 1), 4,
'Explica la pertinencia y razonabilidad de los resultados obtenidos.');

-- DBA 2: Representa y utiliza potencias con exponente racional y notación científica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 2,
'Representa y utiliza potencias con exponente racional y notación científica',
'Representa y utiliza potencias con exponente racional y notación científica para resolver problemas en distintos contextos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 2), 1,
'Expresa y compara cantidades grandes o pequeñas utilizando notación científica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 2), 2,
'Aplica las propiedades de las potencias con exponentes racionales para realizar cálculos y simplificar expresiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 2), 3,
'Resuelve problemas que impliquen el uso de potencias con exponente fraccionario o negativo.');

-- DBA 3: Resuelve ecuaciones e inecuaciones de primer grado con una o dos incógnitas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 3,
'Formula procedimientos para resolver ecuaciones e inecuaciones de primer grado con una o dos incógnitas',
'Formula, desarrolla y justifica procedimientos para resolver ecuaciones e inecuaciones de primer grado con una o dos incógnitas y problemas que las involucren.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 3), 1,
'Traduce situaciones del contexto a lenguaje algebraico mediante ecuaciones o inecuaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 3), 2,
'Aplica las propiedades de la igualdad y la desigualdad para resolver ecuaciones e inecuaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 3), 3,
'Sustituye valores y verifica la validez de las soluciones obtenidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 3), 4,
'Interpreta los resultados en el contexto del problema.');

-- DBA 4: Reconoce figuras geométricas y calcula perímetros, áreas, volúmenes y medidas angulares
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 4,
'Reconoce figuras geométricas y calcula perímetros, áreas, volúmenes y medidas angulares',
'Reconoce y representa figuras geométricas planas y cuerpos sólidos en diferentes posiciones, y calcula perímetros, áreas, volúmenes y medidas angulares en distintos contextos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 4), 1,
'Identifica y describe las propiedades geométricas de figuras y cuerpos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 4), 2,
'Calcula medidas de longitudes, áreas, volúmenes y ángulos aplicando fórmulas adecuadas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 4), 3,
'Justifica los procedimientos utilizados en los cálculos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 4), 4,
'Verifica la coherencia de los resultados obtenidos en relación con el problema planteado.');

-- DBA 5: Reconoce y aplica relaciones de semejanza y congruencia entre figuras
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 5,
'Reconoce y aplica relaciones de semejanza y congruencia para resolver problemas geométricos',
'Reconoce y aplica relaciones de semejanza y congruencia entre figuras planas y cuerpos sólidos para resolver problemas geométricos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 5), 1,
'Identifica figuras semejantes o congruentes en el entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 5), 2,
'Explica las condiciones de semejanza y congruencia entre figuras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 5), 3,
'Usa razones de semejanza para determinar medidas desconocidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 5), 4,
'Argumenta sobre los resultados obtenidos.');

-- DBA 6: Reconoce transformaciones geométricas en el plano y el espacio
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 6,
'Reconoce y representa movimientos y transformaciones geométricas en el plano y el espacio',
'Reconoce, describe y representa movimientos y transformaciones geométricas en el plano y el espacio, y las propiedades que se conservan en ellas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 6), 1,
'Representa traslaciones, rotaciones, reflexiones y homotecias en el plano cartesiano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 6), 2,
'Determina las coordenadas de los puntos transformados y los compara con las iniciales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 6), 3,
'Explica qué propiedades geométricas permanecen invariantes y cuáles cambian.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 6), 4,
'Utiliza herramientas digitales para realizar transformaciones y verificar resultados.');

-- DBA 7: Identifica relaciones de proporcionalidad directa e inversa en problemas de variación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 7,
'Identifica relaciones de proporcionalidad directa e inversa aplicándolas en resolución de problemas de variación',
'Identifica, describe y representa relaciones de proporcionalidad directa e inversa y las aplica en la resolución de problemas de variación.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 7), 1,
'Reconoce relaciones de proporcionalidad directa e inversa entre magnitudes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 7), 2,
'Representa las relaciones mediante tablas, expresiones algebraicas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 7), 3,
'Interpreta y utiliza la constante de proporcionalidad en el análisis de situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 7), 4,
'Aplica las relaciones de proporcionalidad en la resolución de problemas prácticos.');

-- DBA 8: Reconoce y representa relaciones lineales y cuadráticas entre variables
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 8,
'Reconoce relaciones lineales y cuadráticas entre variables aplicándolas en resolución de problemas',
'Reconoce y representa relaciones lineales y cuadráticas entre variables y las aplica en la resolución de problemas.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 8), 1,
'Identifica patrones y relaciones de dependencia en situaciones de variación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 8), 2,
'Representa las relaciones mediante expresiones algebraicas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 8), 3,
'Interpreta los coeficientes y términos en las expresiones lineales y cuadráticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 8), 4,
'Usa las representaciones gráficas para analizar el comportamiento de las relaciones.');

-- DBA 9: Recolecta y representa información estadística analizándola para comunicar conclusiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 9,
'Recolecta y representa información estadística en tablas y gráficos analizando para comunicar conclusiones',
'Recolecta, organiza y representa información estadística en tablas y diferentes tipos de gráficos y analiza la información para comunicar conclusiones.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 9), 1,
'Formula preguntas estadísticas y diseña estrategias de recolección de datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 9), 2,
'Representa los datos mediante tablas de frecuencia y gráficos adecuados (barras, sectores, líneas, histogramas).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 9), 3,
'Calcula e interpreta medidas de tendencia central y de dispersión (media, mediana, moda, rango).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 9), 4,
'Comunica los resultados con base en el análisis de los datos.');

-- DBA 10: Identifica y calcula probabilidad de eventos simples y compuestos para hacer predicciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 11, 10,
'Identifica y calcula probabilidad de eventos simples y compuestos para hacer predicciones',
'Identifica, describe y calcula la probabilidad de ocurrencia de eventos simples y compuestos y la usa para hacer predicciones.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 10), 1,
'Reconoce situaciones aleatorias y determinísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 10), 2,
'Determina el espacio muestral y los eventos posibles.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 10), 3,
'Calcula probabilidades teóricas y experimentales de eventos simples y compuestos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 11 AND numero_dba = 10), 4,
'Usa la probabilidad para hacer predicciones y justificar decisiones.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 9°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 9° grado (id_grado = 12)

-- DBA 1: Interpreta, formula y resuelve problemas con números racionales e irracionales, potencias y raíces
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 1, 
'Interpreta, formula y resuelve problemas con números racionales e irracionales, potencias y raíces',
'Interpreta, formula y resuelve problemas que involucran operaciones con números racionales e irracionales, potencias y raíces en distintos contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 1), 1,
'Reconoce las diferentes clases de números y sus propiedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 1), 2,
'Aplica las operaciones y las propiedades de los números reales para resolver problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 1), 3,
'Usa estrategias de cálculo mental, escrito o tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 1), 4,
'Explica y justifica los procedimientos y resultados obtenidos en función del contexto del problema.');

-- DBA 2: Representa y opera con expresiones algebraicas, potencias, radicales y notación científica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 2,
'Representa y opera con expresiones algebraicas, potencias, radicales y notación científica para modelar situaciones',
'Representa y opera con expresiones algebraicas, potencias, radicales y notación científica para modelar y resolver situaciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 2), 1,
'Simplifica expresiones algebraicas aplicando las propiedades de las operaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 2), 2,
'Utiliza potencias y radicales en la resolución de problemas algebraicos y geométricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 2), 3,
'Expresa y compara cantidades utilizando notación científica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 2), 4,
'Interpreta los resultados obtenidos según el contexto.');

-- DBA 3: Resuelve ecuaciones e inecuaciones lineales y cuadráticas con una incógnita
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 3,
'Formula procedimientos para resolver ecuaciones e inecuaciones lineales y cuadráticas',
'Formula, desarrolla y justifica procedimientos para resolver ecuaciones e inecuaciones lineales y cuadráticas con una incógnita, y problemas que las involucran.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 3), 1,
'Traduce situaciones de la vida cotidiana o científica al lenguaje algebraico mediante ecuaciones o inecuaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 3), 2,
'Aplica las propiedades de la igualdad y de la desigualdad para resolverlas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 3), 3,
'Verifica la validez de las soluciones sustituyendo los valores obtenidos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 3), 4,
'Interpreta los resultados dentro del contexto del problema.');

-- DBA 4: Reconoce y utiliza funciones lineales y cuadráticas para modelar y resolver problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 4,
'Reconoce y utiliza funciones lineales y cuadráticas para modelar y resolver problemas',
'Reconoce, representa y utiliza las funciones lineales y cuadráticas para modelar y resolver problemas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 4), 1,
'Distingue entre una relación y una función.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 4), 2,
'Representa funciones lineales y cuadráticas mediante expresiones algebraicas, tablas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 4), 3,
'Interpreta los parámetros de las funciones (pendiente, intercepto, vértice, etc.) y su significado en el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 4), 4,
'Utiliza las gráficas de las funciones para analizar el comportamiento y resolver problemas.');

-- DBA 5: Reconoce relaciones de proporcionalidad directa, inversa y compuesta para resolver problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 5,
'Reconoce relaciones de proporcionalidad directa, inversa y compuesta para resolver problemas',
'Reconoce, describe y utiliza relaciones de proporcionalidad directa, inversa y compuesta para resolver problemas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 5), 1,
'Identifica relaciones de proporcionalidad en situaciones numéricas, geométricas y del entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 5), 2,
'Representa la proporcionalidad mediante tablas, razones, expresiones algebraicas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 5), 3,
'Interpreta la constante de proporcionalidad y su relación con las variables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 5), 4,
'Aplica las relaciones de proporcionalidad para resolver problemas de variación directa, inversa y compuesta.');

-- DBA 6: Identifica y representa figuras y cuerpos geométricos calculando perímetros, áreas y volúmenes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 6,
'Identifica figuras y cuerpos geométricos calculando perímetros, áreas y volúmenes en diferentes contextos',
'Identifica, caracteriza y representa figuras y cuerpos geométricos a partir de sus propiedades, y calcula perímetros, áreas y volúmenes en diferentes contextos.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 6), 1,
'Describe y compara figuras y cuerpos geométricos según sus propiedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 6), 2,
'Calcula longitudes, áreas y volúmenes aplicando las fórmulas adecuadas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 6), 3,
'Usa unidades y herramientas apropiadas para medir y representar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 6), 4,
'Explica la pertinencia y coherencia de los resultados obtenidos.');

-- DBA 7: Reconoce y aplica relaciones trigonométricas en triángulos rectángulos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 7,
'Reconoce y aplica relaciones trigonométricas en triángulos rectángulos para resolver problemas del entorno',
'Reconoce y aplica las relaciones trigonométricas en triángulos rectángulos para resolver problemas del entorno.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 7), 1,
'Identifica los elementos de un triángulo rectángulo (catetos, hipotenusa, ángulos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 7), 2,
'Define y utiliza las razones trigonométricas (seno, coseno y tangente).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 7), 3,
'Aplica las razones trigonométricas para calcular medidas desconocidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 7), 4,
'Interpreta los resultados obtenidos dentro del contexto del problema.');

-- DBA 8: Recolecta e interpreta información estadística univariada y bivariada
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 8,
'Recolecta e interpreta información estadística univariada y bivariada comunicando conclusiones',
'Recolecta, organiza, representa e interpreta información estadística univariada y bivariada y comunica conclusiones basadas en los datos.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 8), 1,
'Formula preguntas estadísticas y diseña estrategias para recolectar datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 8), 2,
'Representa la información mediante tablas, diagramas y gráficos adecuados (barras, sectores, dispersión).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 8), 3,
'Calcula e interpreta medidas de tendencia central (media, mediana, moda) y de dispersión (rango, desviación media).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 8), 4,
'Analiza y comunica conclusiones con base en los resultados obtenidos.');

-- DBA 9: Identifica y calcula probabilidad aplicándola para predecir y tomar decisiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 9,
'Identifica y calcula probabilidad de eventos simples y compuestos aplicándola para predecir y tomar decisiones',
'Identifica y calcula la probabilidad de ocurrencia de eventos simples y compuestos, y la aplica para predecir y tomar decisiones.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 9), 1,
'Determina el espacio muestral y los eventos de un experimento aleatorio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 9), 2,
'Calcula probabilidades teóricas y experimentales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 9), 3,
'Compara resultados y explica las diferencias entre ambos tipos de probabilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 9), 4,
'Utiliza la probabilidad para justificar predicciones o decisiones en diferentes contextos.');

-- DBA 10: Reconoce y utiliza patrones numéricos, geométricos y algebraicos para establecer generalizaciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 12, 10,
'Reconoce y utiliza patrones numéricos, geométricos y algebraicos para establecer generalizaciones y resolver problemas',
'Reconoce y utiliza patrones numéricos, geométricos y algebraicos para establecer generalizaciones y resolver problemas.');

-- Evidencias para DBA 10
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 10), 1,
'Identifica regularidades en secuencias y configuraciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 10), 2,
'Representa las regularidades mediante expresiones algebraicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 10), 3,
'Formula conjeturas y las justifica mediante argumentos matemáticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 12 AND numero_dba = 10), 4,
'Usa las generalizaciones para resolver problemas y predecir resultados.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 10°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 10° grado (id_grado = 13)

-- DBA 1: Interpreta, formula y resuelve problemas con las operaciones y propiedades de números reales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 1, 
'Interpreta, formula y resuelve problemas que involucran operaciones y propiedades de números reales',
'Interpreta, formula y resuelve problemas que involucran las operaciones y propiedades de los números reales en distintos contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 1), 1,
'Reconoce las características y propiedades de los números reales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 1), 2,
'Aplica las propiedades de las operaciones para simplificar y resolver expresiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 1), 3,
'Selecciona estrategias de cálculo mental, escrito o tecnológico según el tipo de número y el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 1), 4,
'Justifica los procedimientos y resultados obtenidos.');

-- DBA 2: Representa y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 2,
'Representa y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios',
'Representa, simplifica y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios para modelar y resolver situaciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 2), 1,
'Simplifica expresiones algebraicas aplicando propiedades de las operaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 2), 2,
'Opera con potencias, radicales y fracciones algebraicas para resolver problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 2), 3,
'Realiza operaciones con polinomios (suma, resta, multiplicación y factorización).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 2), 4,
'Aplica los resultados al análisis y resolución de problemas contextualizados.');

-- DBA 3: Resuelve ecuaciones e inecuaciones lineales, cuadráticas y sistemas de ecuaciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 3,
'Formula procedimientos para resolver ecuaciones e inecuaciones lineales, cuadráticas y sistemas de ecuaciones',
'Formula, desarrolla y justifica procedimientos para resolver ecuaciones e inecuaciones lineales, cuadráticas y sistemas de ecuaciones.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 3), 1,
'Representa situaciones mediante ecuaciones e inecuaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 3), 2,
'Aplica procedimientos algebraicos y gráficos para encontrar soluciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 3), 3,
'Verifica la validez de las soluciones sustituyendo los valores obtenidos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 3), 4,
'Interpreta los resultados dentro del contexto del problema.');

-- DBA 4: Reconoce funciones lineales, cuadráticas, exponenciales y racionales aplicándolas en resolución de problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 4,
'Reconoce funciones lineales, cuadráticas, exponenciales y racionales aplicándolas en resolución de problemas',
'Reconoce y representa funciones lineales, cuadráticas, exponenciales y racionales y las aplica en la resolución de problemas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 4), 1,
'Representa funciones mediante expresiones, tablas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 4), 2,
'Identifica características de las funciones (crecimiento, decrecimiento, intersecciones, asíntotas, máximos y mínimos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 4), 3,
'Interpreta los parámetros de las funciones en el contexto del problema.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 4), 4,
'Compara y analiza comportamientos de diferentes tipos de funciones.');

-- DBA 5: Aplica el concepto de variación y de razón de cambio en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 5,
'Aplica el concepto de variación y de razón de cambio en diferentes contextos',
'Aplica el concepto de variación y de razón de cambio en diferentes contextos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 5), 1,
'Reconoce situaciones de variación y las representa mediante gráficas o expresiones algebraicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 5), 2,
'Calcula e interpreta razones de cambio promedio y las utiliza para describir fenómenos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 5), 3,
'Argumenta sobre la relación entre la razón de cambio y el comportamiento de la gráfica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 5), 4,
'Aplica el concepto de razón de cambio en la resolución de problemas de contextos reales.');

-- DBA 6: Reconoce propiedades de funciones trigonométricas aplicándolas en resolución de problemas geométricos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 6,
'Reconoce propiedades de funciones trigonométricas aplicándolas en resolución de problemas geométricos y de variación periódica',
'Reconoce y utiliza las propiedades de las funciones trigonométricas y las aplica en la resolución de problemas geométricos y de variación periódica.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 6), 1,
'Identifica las funciones seno, coseno y tangente y sus gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 6), 2,
'Calcula y representa las razones trigonométricas de ángulos agudos y obtusos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 6), 3,
'Aplica las funciones trigonométricas en la resolución de problemas que involucran triángulos y fenómenos periódicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 6), 4,
'Interpreta el significado de los resultados en el contexto del problema.');

-- DBA 7: Interpreta y resuelve problemas aplicando teorema de Pitágoras, razones trigonométricas y ley de senos y cosenos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 7,
'Interpreta y resuelve problemas aplicando teorema de Pitágoras, razones trigonométricas y ley de senos y cosenos',
'Interpreta, formula y resuelve problemas que implican la aplicación del teorema de Pitágoras, las razones trigonométricas y la ley de senos y cosenos.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 7), 1,
'Identifica y relaciona los elementos de triángulos rectángulos y oblicuángulos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 7), 2,
'Aplica el teorema de Pitágoras y las leyes de senos y cosenos para calcular medidas desconocidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 7), 3,
'Formula y resuelve problemas en contextos geométricos o físicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 7), 4,
'Justifica los procedimientos y verifica la coherencia de los resultados.');

-- DBA 8: Recolecta y analiza información estadística calculando medidas de tendencia central y dispersión
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 8,
'Recolecta y analiza información estadística calculando medidas de tendencia central y dispersión',
'Recolecta, organiza, representa y analiza información estadística y calcula medidas de tendencia central y de dispersión.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 8), 1,
'Diseña instrumentos para recolectar datos y determina el tipo de variable.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 8), 2,
'Representa la información mediante tablas de frecuencia, histogramas, polígonos y diagramas circulares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 8), 3,
'Calcula e interpreta la media, mediana, moda, varianza y desviación estándar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 8), 4,
'Analiza y comunica conclusiones basadas en los datos recolectados.');

-- DBA 9: Calcula y analiza probabilidad de eventos simples y compuestos, dependientes e independientes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 13, 9,
'Calcula y analiza probabilidad de eventos simples y compuestos, dependientes e independientes',
'Calcula y analiza la probabilidad de ocurrencia de eventos simples y compuestos, dependientes e independientes, en diferentes contextos.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 9), 1,
'Determina el espacio muestral y los eventos de un experimento aleatorio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 9), 2,
'Calcula la probabilidad teórica y experimental de eventos simples y compuestos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 9), 3,
'Distingue entre eventos dependientes e independientes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 13 AND numero_dba = 9), 4,
'Argumenta y comunica sus conclusiones basadas en los resultados obtenidos.');

-- =============================================
-- INSERTAR DATOS: MATEMÁTICAS GRADO 11°
-- =============================================

-- Matemáticas (id_asignatura = 2) y 11° grado (id_grado = 14)

-- DBA 1: Interpreta, formula y resuelve problemas con números reales y complejos en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 1, 
'Interpreta, formula y resuelve problemas que involucran operaciones y propiedades de números reales y complejos',
'Interpreta, formula y resuelve problemas que involucran las operaciones y propiedades de los números reales y complejos en diferentes contextos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 1), 1,
'Reconoce las propiedades y operaciones de los números reales y complejos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 1), 2,
'Representa los números complejos en el plano cartesiano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 1), 3,
'Realiza operaciones con números reales y complejos y justifica los procedimientos utilizados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 1), 4,
'Aplica los resultados al análisis y resolución de problemas del entorno.');

-- DBA 2: Representa y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 2,
'Representa y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios para modelar situaciones',
'Representa, simplifica y opera con expresiones algebraicas, potencias, radicales, fracciones algebraicas y polinomios para modelar y resolver situaciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 2), 1,
'Simplifica y opera con expresiones algebraicas racionales e irracionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 2), 2,
'Aplica propiedades de las operaciones para simplificar expresiones y resolver problemas algebraicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 2), 3,
'Interpreta el significado de los resultados en función del contexto del problema.');

-- DBA 3: Resuelve ecuaciones e inecuaciones polinómicas, racionales, exponenciales y logarítmicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 3,
'Formula procedimientos para resolver ecuaciones e inecuaciones polinómicas, racionales, exponenciales y logarítmicas',
'Formula, desarrolla y justifica procedimientos para resolver ecuaciones e inecuaciones polinómicas, racionales, exponenciales y logarítmicas, así como sistemas de ecuaciones.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 3), 1,
'Traduce situaciones a expresiones algebraicas mediante ecuaciones o sistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 3), 2,
'Aplica procedimientos algebraicos, gráficos o numéricos para encontrar soluciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 3), 3,
'Verifica la validez de las soluciones y argumenta su pertinencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 3), 4,
'Interpreta los resultados en el contexto del problema.');

-- DBA 4: Reconoce y analiza funciones lineales, cuadráticas, polinómicas, racionales, exponenciales, logarítmicas y trigonométricas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 4,
'Reconoce y analiza funciones lineales, cuadráticas, polinómicas, racionales, exponenciales, logarítmicas y trigonométricas',
'Reconoce, representa y analiza funciones lineales, cuadráticas, polinómicas, racionales, exponenciales, logarítmicas y trigonométricas, y las aplica en la resolución de problemas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 4), 1,
'Representa funciones mediante expresiones, tablas y gráficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 4), 2,
'Analiza el dominio, rango, crecimiento, decrecimiento, intervalos y comportamiento de las funciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 4), 3,
'Interpreta los parámetros de las funciones y su significado en el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 4), 4,
'Utiliza las funciones para modelar fenómenos del entorno y resolver problemas.');

-- DBA 5: Aplica el concepto de derivada como razón de cambio para analizar comportamiento de funciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 5,
'Aplica el concepto de derivada como razón de cambio para analizar el comportamiento de funciones',
'Aplica el concepto de derivada como razón de cambio en diferentes contextos y lo utiliza para analizar el comportamiento de funciones.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 5), 1,
'Calcula la razón de cambio promedio y la derivada de funciones polinómicas y racionales sencillas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 5), 2,
'Interpreta la derivada como la pendiente de la recta tangente a una curva en un punto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 5), 3,
'Usa la derivada para analizar el crecimiento y decrecimiento de funciones y encontrar máximos y mínimos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 5), 4,
'Aplica el concepto de derivada en la resolución de problemas de la vida cotidiana.');

-- DBA 6: Reconoce propiedades de funciones trigonométricas en resolución de problemas geométricos y de variación periódica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 6,
'Reconoce propiedades de funciones trigonométricas en resolución de problemas geométricos y de variación periódica',
'Reconoce y utiliza las propiedades de las funciones trigonométricas en la resolución de problemas geométricos y de variación periódica.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 6), 1,
'Representa y analiza las funciones trigonométricas seno, coseno y tangente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 6), 2,
'Aplica identidades trigonométricas para simplificar expresiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 6), 3,
'Resuelve problemas que involucran triángulos rectángulos y fenómenos periódicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 6), 4,
'Interpreta los resultados en relación con el contexto.');

-- DBA 7: Recolecta y analiza información estadística aplicando medidas de tendencia central, dispersión y posición
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 7,
'Recolecta y analiza información estadística aplicando medidas de tendencia central, dispersión y posición',
'Recolecta, organiza, representa y analiza información estadística y aplica medidas de tendencia central, de dispersión y de posición.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 7), 1,
'Diseña instrumentos para recolectar datos y determina el tipo de variable.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 7), 2,
'Representa la información mediante tablas, diagramas y gráficos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 7), 3,
'Calcula e interpreta la media, mediana, moda, varianza, desviación estándar y percentiles.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 7), 4,
'Analiza y comunica conclusiones basadas en los datos recolectados.');

-- DBA 8: Calcula probabilidad de eventos simples y compuestos aplicando probabilidad condicional
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 8,
'Calcula probabilidad de eventos simples y compuestos aplicando probabilidad condicional',
'Calcula y analiza la probabilidad de ocurrencia de eventos simples y compuestos, dependientes e independientes, en distintos contextos, y aplica la probabilidad condicional.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 8), 1,
'Determina el espacio muestral y los eventos de un experimento aleatorio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 8), 2,
'Calcula probabilidades teóricas, experimentales y condicionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 8), 3,
'Distingue entre eventos dependientes e independientes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 8), 4,
'Utiliza la probabilidad para justificar predicciones o decisiones.');

-- DBA 9: Reconoce y aplica conceptos básicos del cálculo integral en resolución de problemas geométricos y de acumulación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(2, 14, 9,
'Reconoce y aplica conceptos básicos del cálculo integral en resolución de problemas geométricos y de acumulación',
'Reconoce y aplica conceptos básicos del cálculo integral en la resolución de problemas geométricos y de acumulación.');

-- Evidencias para DBA 9
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 9), 1,
'Identifica la integral como el proceso inverso de la derivada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 9), 2,
'Calcula áreas bajo la curva de funciones sencillas mediante aproximaciones o procedimientos analíticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 9), 3,
'Interpreta el significado geométrico y físico de la integral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 14 AND numero_dba = 9), 4,
'Aplica la integral en la resolución de problemas de acumulación o área.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 1°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 1° grado (id_grado = 4)

-- DBA 1: Identifica diferentes medios de comunicación como posibilidad para informarse, participar y acceder al universo cultural
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 1, 
'Identifica diferentes medios de comunicación como posibilidad para informarse, participar y acceder al universo cultural',
'Identifica los diferentes medios de comunicación como una posibilidad para informarse, participar y acceder al universo cultural que lo rodea.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 1), 1,
'Establece semejanzas y diferencias entre los principales medios de comunicación de su contexto: radio, periódicos, televisión, revistas, vallas publicitarias, afiches e internet.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 1), 2,
'Comprende los mensajes emitidos por diferentes medios de comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 1), 3,
'Distingue los medios de comunicación para reconocer los posibles usos que tienen en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 1), 4,
'Describe los diferentes tipos de voz que se usan en los programas radiales y televisivos para dar una noticia, narrar un partido de fútbol o leer un texto escrito.');

-- DBA 2: Relaciona códigos no verbales con el significado que pueden tomar de acuerdo con el contexto
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 2,
'Relaciona códigos no verbales con el significado que pueden tomar de acuerdo con el contexto',
'Relaciona códigos no verbales, como los movimientos corporales y los gestos de las manos o del rostro, con el significado que pueden tomar de acuerdo con el contexto.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 2), 1,
'Identifica las intenciones de los gestos y los movimientos corporales de los interlocutores para dar cuenta de lo que quieren comunicar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 2), 2,
'Interpreta ilustraciones e imágenes en relación a sus colores, formas y tamaños.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 2), 3,
'Representa objetos, personas y lugares mediante imágenes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 2), 4,
'Reconoce el sentido de algunas cualidades sonoras como la entonación, las pausas y los silencios.');

-- DBA 3: Reconoce en los textos literarios la posibilidad de desarrollar su capacidad creativa y lúdica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 3,
'Reconoce en los textos literarios la posibilidad de desarrollar su capacidad creativa y lúdica',
'Reconoce en los textos literarios la posibilidad de desarrollar su capacidad creativa y lúdica.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 3), 1,
'Escucha o lee adivinanzas, anagramas, retahílas, pregones y acrósticos que hacen parte de su entorno cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 3), 2,
'Comprende el sentido de los textos de la tradición oral como canciones y cuentos con los que interactúa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 3), 3,
'Entiende que hay diferencias en la forma en que se escriben algunos textos como los acrósticos y adivinanzas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 3), 4,
'Interactúa con sus compañeros en dinámicas grupales que incluyen declamación, canto, música y recitales, teniendo en cuenta los sonidos y juegos de palabras.');

-- DBA 4: Interpreta textos literarios como parte de su iniciación en la comprensión de textos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 4,
'Interpreta textos literarios como parte de su iniciación en la comprensión de textos',
'Interpreta textos literarios como parte de su iniciación en la comprensión de textos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 4), 1,
'Comparte sus impresiones sobre los textos literarios y las relaciona con situaciones que se dan en los contextos donde vive.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 4), 2,
'Emplea las imágenes o ilustraciones de los textos literarios para comprenderlos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 4), 3,
'Expresa sus opiniones e impresiones a través de dibujos, caricaturas o canciones, y los comparte con sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 4), 4,
'Identifica la repetición de algunos sonidos al final de los versos en textos de la tradición oral y los vincula con su respectiva escritura.');

-- DBA 5: Reconoce las temáticas presentes en los mensajes que escucha, a partir de la diferenciación de los sonidos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 5,
'Reconoce las temáticas presentes en los mensajes que escucha, a partir de la diferenciación de los sonidos',
'Reconoce las temáticas presentes en los mensajes que escucha, a partir de la diferenciación de los sonidos que componen las palabras.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 5), 1,
'Extrae información del contexto comunicativo que le permite identificar quién lo produce y en dónde.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 5), 2,
'Comprende las temáticas tratadas en diferentes textos que escucha.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 5), 3,
'Segmenta los discursos que escucha en unidades significativas como las palabras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 5), 4,
'Identifica los sonidos presentes en las palabras, oraciones y discursos que escucha para comprender el sentido de lo que oye.');

-- DBA 6: Interpreta diversos textos a partir de la lectura de palabras sencillas y de las imágenes que contienen
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 6,
'Interpreta diversos textos a partir de la lectura de palabras sencillas y de las imágenes que contienen',
'Interpreta diversos textos a partir de la lectura de palabras sencillas y de las imágenes que contienen.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 6), 1,
'Comprende el propósito de los textos que lee, apoyándose en sus títulos, imágenes e ilustraciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 6), 2,
'Explica las semejanzas y diferencias que encuentra entre lo que dice un texto y lo que muestran las imágenes o ilustraciones que lo acompañan.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 6), 3,
'Lee palabras sencillas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 6), 4,
'Identifica la letra o grupo de letras que corresponden con un sonido al momento de pronunciar las palabras escritas.');

-- DBA 7: Enuncia textos orales de diferente índole sobre temas de su interés o sugeridos por otros
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 7,
'Enuncia textos orales de diferente índole sobre temas de su interés o sugeridos por otros',
'Enuncia textos orales de diferente índole sobre temas de su interés o sugeridos por otros.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 7), 1,
'Emplea palabras adecuadas según la situación comunicativa en sus conversaciones y diálogos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 7), 2,
'Expresa sus ideas con claridad, teniendo en cuenta el orden de las palabras en los textos orales que produce.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 7), 3,
'Practica las palabras que representan dificultades en su pronunciación y se autocorrige cuando las articula erróneamente en sus discursos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 7), 4,
'Adecúa el volumen de la voz teniendo en cuenta a su interlocutor y el espacio en el que se encuentra.');

-- DBA 8: Escribe palabras que le permiten comunicar sus ideas, preferencias y aprendizajes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 4, 8,
'Escribe palabras que le permiten comunicar sus ideas, preferencias y aprendizajes',
'Escribe palabras que le permiten comunicar sus ideas, preferencias y aprendizajes.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 8), 1,
'Construye textos cortos para relatar, comunicar ideas o hacer peticiones al interior del contexto en el que interactúa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 8), 2,
'Expresa sus ideas en torno a una sola temática a partir del vocabulario que conoce.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 8), 3,
'Elabora listas de palabras parecidas y reconoce las diferencias que guardan entre sí (luna, lupa, lucha; casa, caza, taza; pelo, peso, perro).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 8), 4,
'Escribe palabras sencillas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 4 AND numero_dba = 8), 5,
'Relaciona los sonidos de la lengua con sus diferentes grafemas.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 2°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 2° grado (id_grado = 5)

-- DBA 1: Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 1, 
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación y sus características como una posibilidad para informarse, interactuar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 1), 1,
'Describe los principales medios de comunicación de su entorno (radio, televisión, periódicos, revistas, afiches, internet, entre otros).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 1), 2,
'Comprende los mensajes que recibe a través de los diferentes medios de comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 1), 3,
'Identifica las diferencias entre los medios de comunicación oral, escrito y audiovisual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 1), 4,
'Reconoce los medios de comunicación que existen en su entorno escolar y familiar.');

-- DBA 2: Identifica los gestos, movimientos corporales y señales visuales como complementos de la comunicación oral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 2,
'Identifica los gestos, movimientos corporales y señales visuales como complementos de la comunicación oral',
'Identifica los gestos, movimientos corporales y señales visuales como complementos de la comunicación oral.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 2), 1,
'Diferencia los gestos que denotan agrado, desagrado, sorpresa, aprobación o desaprobación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 2), 2,
'Interpreta los mensajes que transmiten las expresiones faciales y corporales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 2), 3,
'Utiliza los gestos y movimientos del cuerpo como recursos expresivos en sus interacciones comunicativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 2), 4,
'Explica el significado de algunas señales visuales utilizadas en su contexto (semáforos, señales de tránsito, pictogramas).');

-- DBA 3: Reconoce los textos literarios como posibilidad para desarrollar su imaginación y creatividad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 3,
'Reconoce los textos literarios como posibilidad para desarrollar su imaginación y creatividad',
'Reconoce los textos literarios como una posibilidad para desarrollar su imaginación y creatividad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 3), 1,
'Escucha, lee y recrea textos de la tradición oral como cuentos, rondas, canciones y adivinanzas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 3), 2,
'Identifica las características de los textos literarios que le permiten diferenciar entre lo real y lo imaginario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 3), 3,
'Crea textos cortos inspirados en los textos literarios que lee o escucha.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 3), 4,
'Participa en actividades grupales de lectura y dramatización de textos literarios.');

-- DBA 4: Interpreta textos literarios breves a partir de personajes, acciones y lugares que aparecen en ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 4,
'Interpreta textos literarios breves a partir de personajes, acciones y lugares que aparecen en ellos',
'Interpreta textos literarios breves a partir de los personajes, las acciones y los lugares que aparecen en ellos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica los personajes principales y secundarios en los textos literarios que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 4), 2,
'Reconoce el lugar y las acciones principales en los textos narrativos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 4), 3,
'Explica lo que ocurre en el texto a partir de la secuencia de los hechos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 4), 4,
'Expresa sus opiniones e impresiones sobre los textos leídos y los relaciona con su entorno.');

-- DBA 5: Comprende mensajes orales en situaciones comunicativas cotidianas, escolares y de su entorno inmediato
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 5,
'Comprende mensajes orales en situaciones comunicativas cotidianas, escolares y de su entorno inmediato',
'Comprende mensajes orales en situaciones comunicativas cotidianas, escolares y de su entorno inmediato.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 5), 1,
'Escucha con atención diferentes tipos de mensajes orales y los comprende.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 5), 2,
'Diferencia las intenciones comunicativas de quien habla (informar, pedir, ordenar, saludar, agradecer, despedirse).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 5), 3,
'Identifica los elementos principales de los mensajes orales (emisor, receptor, propósito, tema).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 5), 4,
'Sigue instrucciones sencillas y las ejecuta correctamente.');

-- DBA 6: Interpreta textos breves a partir del significado de las palabras, de las imágenes y del contexto
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 6,
'Interpreta textos breves a partir del significado de las palabras, de las imágenes y del contexto',
'Interpreta textos breves a partir del significado de las palabras, de las imágenes y del contexto.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 6), 1,
'Comprende el tema principal y los detalles más relevantes de los textos que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 6), 2,
'Usa las ilustraciones y el título como apoyo para la comprensión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 6), 3,
'Reconoce palabras nuevas en los textos y deduce su significado por el contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 6), 4,
'Lee textos cortos en voz alta con entonación y ritmo adecuados.');

-- DBA 7: Produce textos orales breves para expresar ideas, sentimientos y opiniones en diferentes situaciones comunicativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 7,
'Produce textos orales breves para expresar ideas, sentimientos y opiniones en diferentes situaciones comunicativas',
'Produce textos orales breves para expresar ideas, sentimientos y opiniones en diferentes situaciones comunicativas.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 7), 1,
'Expresa sus ideas y sentimientos en forma ordenada y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 7), 2,
'Utiliza palabras adecuadas al contexto comunicativo y al interlocutor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 7), 3,
'Mantiene el hilo temático en las conversaciones que sostiene.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 7), 4,
'Escucha a sus interlocutores y responde de manera pertinente.');

-- DBA 8: Escribe oraciones y textos cortos sobre temas de su interés, con coherencia y claridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 5, 8,
'Escribe oraciones y textos cortos sobre temas de su interés, con coherencia y claridad',
'Escribe oraciones y textos cortos sobre temas de su interés, con coherencia y claridad.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 8), 1,
'Produce textos cortos para narrar experiencias, describir objetos o expresar sentimientos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 8), 2,
'Organiza sus ideas en oraciones sencillas y coherentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 8), 3,
'Revisa y corrige sus escritos con la ayuda del docente o de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 5 AND numero_dba = 8), 4,
'Usa correctamente mayúsculas y signos de puntuación básicos.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 3°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 3° grado (id_grado = 6)

-- DBA 1: Reconoce los medios de comunicación y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 1, 
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación y sus características como una posibilidad para informarse, participar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 1), 1,
'Identifica los diferentes medios de comunicación masiva que hay en su entorno (radio, televisión, prensa escrita, internet, entre otros).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 1), 2,
'Distingue las características principales de los medios de comunicación oral, escrito y audiovisual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 1), 3,
'Comprende la intención comunicativa de los mensajes que recibe a través de los diferentes medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 1), 4,
'Explica el propósito de los mensajes publicitarios que observa y escucha en su entorno.');

-- DBA 2: Reconoce la importancia de gestos, miradas, movimientos corporales y señales visuales como complementos de la comunicación oral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 2,
'Reconoce la importancia de gestos, miradas, movimientos corporales y señales visuales como complementos de la comunicación oral',
'Reconoce la importancia de los gestos, las miradas, los movimientos corporales y las señales visuales como complementos de la comunicación oral.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 2), 1,
'Distingue los diferentes gestos, posturas y expresiones faciales que acompañan la comunicación oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 2), 2,
'Interpreta el significado de algunos gestos, miradas y movimientos del cuerpo según el contexto comunicativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 2), 3,
'Utiliza gestos, miradas y posturas adecuadas al comunicarse en diferentes situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 2), 4,
'Explica cómo las señales visuales, los gestos y los movimientos pueden modificar el significado del mensaje oral.');

-- DBA 3: Reconoce en los textos literarios la posibilidad de disfrutar, imaginar y crear mundos posibles
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 3,
'Reconoce en los textos literarios la posibilidad de disfrutar, imaginar y crear mundos posibles',
'Reconoce en los textos literarios la posibilidad de disfrutar, imaginar y crear mundos posibles.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 3), 1,
'Escucha, lee y recrea textos literarios pertenecientes a diferentes géneros y tradiciones orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 3), 2,
'Identifica las características que diferencian los textos literarios de los informativos y expositivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 3), 3,
'Expresa sus emociones, opiniones e interpretaciones frente a los textos literarios leídos o escuchados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 3), 4,
'Crea textos literarios cortos inspirados en los textos leídos o en experiencias personales.');

-- DBA 4: Interpreta textos literarios breves a partir de la identificación de personajes, lugares, tiempos y acciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 4,
'Interpreta textos literarios breves a partir de la identificación de personajes, lugares, tiempos y acciones',
'Interpreta textos literarios breves a partir de la identificación de personajes, lugares, tiempos y acciones.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 4), 1,
'Identifica los personajes principales y secundarios en los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 4), 2,
'Reconoce los lugares donde se desarrollan las acciones del relato.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 4), 3,
'Determina el orden de los acontecimientos en los textos narrativos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 4), 4,
'Explica con sus propias palabras lo que sucede en el texto y lo relaciona con su experiencia.');

-- DBA 5: Comprende mensajes orales e identifica sus propósitos e intenciones comunicativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 5,
'Comprende mensajes orales e identifica sus propósitos e intenciones comunicativas',
'Comprende mensajes orales e identifica sus propósitos e intenciones comunicativas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 5), 1,
'Escucha atentamente diferentes tipos de mensajes orales y los comprende.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 5), 2,
'Diferencia los propósitos comunicativos de quien habla (informar, pedir, convencer, ordenar).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 5), 3,
'Identifica los elementos principales de la comunicación (emisor, receptor, mensaje, canal y código).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 5), 4,
'Sigue y ejecuta instrucciones orales de varias acciones.');

-- DBA 6: Comprende textos escritos de diversa índole mediante identificación de ideas principales, detalles y propósitos comunicativos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 6,
'Comprende textos escritos de diversa índole mediante identificación de ideas principales, detalles y propósitos comunicativos',
'Comprende textos escritos de diversa índole mediante la identificación de ideas principales, detalles y propósitos comunicativos.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 6), 1,
'Identifica el tema principal y los detalles relevantes de los textos que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 6), 2,
'Reconoce el propósito comunicativo de los textos (informar, narrar, describir, instruir).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 6), 3,
'Formula inferencias sencillas a partir de la información leída.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 6), 4,
'Utiliza títulos, subtítulos e ilustraciones como apoyo para la comprensión.');

-- DBA 7: Produce textos orales para expresar ideas, sentimientos y opiniones, adecuándolos a diferentes situaciones comunicativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 7,
'Produce textos orales para expresar ideas, sentimientos y opiniones, adecuándolos a diferentes situaciones comunicativas',
'Produce textos orales para expresar ideas, sentimientos y opiniones, adecuándolos a diferentes situaciones comunicativas.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 7), 1,
'Expresa sus ideas en forma ordenada y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 7), 2,
'Mantiene la atención de sus interlocutores durante la exposición de sus ideas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 7), 3,
'Emplea un vocabulario adecuado al contexto y a la audiencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 7), 4,
'Escucha y responde con respeto a las intervenciones de otros.');

-- DBA 8: Escribe textos breves sobre temas de su interés, cuidando la coherencia, la secuencia y la presentación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 6, 8,
'Escribe textos breves sobre temas de su interés, cuidando la coherencia, la secuencia y la presentación',
'Escribe textos breves sobre temas de su interés, cuidando la coherencia, la secuencia y la presentación.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 8), 1,
'Produce textos breves en los que expresa experiencias, opiniones o información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 8), 2,
'Organiza las ideas de manera coherente en párrafos cortos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 8), 3,
'Revisa sus escritos para corregir errores ortográficos y de puntuación con la ayuda del docente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 6 AND numero_dba = 8), 4,
'Presenta sus textos de forma ordenada y legible.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 4°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 4° grado (id_grado = 7)

-- DBA 1: Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 1, 
'Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación masiva y sus características como una posibilidad para informarse, interactuar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 1), 1,
'Identifica los diferentes medios de comunicación masiva y describe sus principales características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 1), 2,
'Reconoce la intención comunicativa de los mensajes transmitidos por los medios de comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 1), 3,
'Diferencia los mensajes informativos, publicitarios y de entretenimiento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 1), 4,
'Explica el propósito de los mensajes que circulan en su entorno y reflexiona sobre su influencia en la vida cotidiana.');

-- DBA 2: Reconoce la importancia de gestos, posturas y movimientos corporales como parte de la comunicación no verbal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 2,
'Reconoce la importancia de gestos, posturas y movimientos corporales como parte de la comunicación no verbal',
'Reconoce la importancia de los gestos, las posturas y los movimientos corporales como parte de la comunicación no verbal.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 2), 1,
'Distingue los gestos y posturas que expresan distintos estados de ánimo o intenciones comunicativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 2), 2,
'Explica cómo los gestos y las posturas corporales complementan o reemplazan la comunicación oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 2), 3,
'Emplea adecuadamente la comunicación no verbal en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos, posturas y movimientos en conversaciones y presentaciones orales.');

-- DBA 3: Reconoce los textos literarios como forma de disfrutar, imaginar y expresar sentimientos, emociones y pensamientos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 3,
'Reconoce los textos literarios como forma de disfrutar, imaginar y expresar sentimientos, emociones y pensamientos',
'Reconoce los textos literarios como una forma de disfrutar, imaginar y expresar sentimientos, emociones y pensamientos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 3), 1,
'Escucha, lee y comenta textos literarios de diferentes géneros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 3), 2,
'Identifica las características que diferencian los textos literarios de otros tipos de textos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 3), 3,
'Expresa opiniones e interpretaciones personales sobre los textos literarios leídos o escuchados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 3), 4,
'Crea textos literarios breves, como cuentos, poemas o fábulas, inspirados en sus lecturas o experiencias personales.');

-- DBA 4: Interpreta textos literarios a partir del análisis de personajes, acciones, lugares y tiempos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 4,
'Interpreta textos literarios a partir del análisis de personajes, acciones, lugares y tiempos',
'Interpreta textos literarios a partir del análisis de sus personajes, acciones, lugares y tiempos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 4), 1,
'Identifica los personajes, lugares, tiempos y acciones de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 4), 2,
'Reconoce los temas principales de los textos leídos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 4), 3,
'Explica la secuencia de los acontecimientos en un texto narrativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 4), 4,
'Relaciona los textos literarios con situaciones de su entorno y con experiencias propias.');

-- DBA 5: Comprende mensajes orales e identifica propósitos, intenciones y elementos de la comunicación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 5,
'Comprende mensajes orales e identifica propósitos, intenciones y elementos de la comunicación',
'Comprende mensajes orales e identifica sus propósitos, intenciones y elementos de la comunicación.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 5), 1,
'Escucha activamente distintos tipos de mensajes orales y los comprende.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 5), 2,
'Diferencia los propósitos comunicativos de quien habla (informar, persuadir, ordenar, preguntar).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 5), 3,
'Reconoce los elementos del proceso comunicativo (emisor, receptor, mensaje, canal y código).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 5), 4,
'Interpreta y evalúa el contenido de los mensajes orales escuchados.');

-- DBA 6: Comprende textos escritos identificando información explícita e implícita y propósitos comunicativos del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 6,
'Comprende textos escritos identificando información explícita e implícita y propósitos comunicativos del autor',
'Comprende textos escritos identificando la información explícita e implícita y los propósitos comunicativos del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 6), 1,
'Identifica la idea principal y las ideas secundarias en los textos que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 6), 2,
'Reconoce el propósito comunicativo del texto (informar, narrar, describir, convencer).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 6), 3,
'Establece inferencias a partir de la información implícita en el texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 6), 4,
'Utiliza conectores y referencias textuales para comprender la organización del texto.');

-- DBA 7: Produce textos orales para comunicar ideas, sentimientos y opiniones en distintas situaciones comunicativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 7,
'Produce textos orales para comunicar ideas, sentimientos y opiniones en distintas situaciones comunicativas',
'Produce textos orales para comunicar ideas, sentimientos y opiniones en distintas situaciones comunicativas.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 7), 1,
'Expone ideas y opiniones de manera ordenada y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 7), 2,
'Emplea un vocabulario adecuado y pertinente al contexto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 7), 3,
'Mantiene una actitud de respeto y escucha hacia sus interlocutores.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 7), 4,
'Ajusta su discurso oral según el propósito comunicativo y el público.');

-- DBA 8: Escribe textos de diferente tipo con coherencia, cohesión y corrección ortográfica básica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 7, 8,
'Escribe textos de diferente tipo con coherencia, cohesión y corrección ortográfica básica',
'Escribe textos de diferente tipo (narrativos, descriptivos, informativos) con coherencia, cohesión y corrección ortográfica básica.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 8), 1,
'Planifica sus textos teniendo en cuenta el propósito y el destinatario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 8), 2,
'Organiza las ideas en párrafos coherentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 8), 3,
'Utiliza conectores adecuados para dar cohesión al texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 7 AND numero_dba = 8), 4,
'Revisa sus escritos para mejorar la ortografía, la puntuación y la presentación.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 5°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 5° grado (id_grado = 8)

-- DBA 1: Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 1, 
'Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación masiva y sus características como una posibilidad para informarse, participar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica los medios de comunicación masiva y sus funciones principales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 1), 2,
'Diferencia los mensajes informativos, publicitarios y de opinión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 1), 3,
'Analiza el propósito y la intención de los mensajes que circulan en los medios de comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 1), 4,
'Reflexiona sobre la influencia de los medios en la vida cotidiana y en la construcción de la opinión pública.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 2), 1,
'Identifica gestos, posturas y movimientos que acompañan la comunicación oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 2), 2,
'Explica el valor comunicativo de los gestos, las miradas y las posturas en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 2), 3,
'Emplea la comunicación no verbal para fortalecer su expresión oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 2), 4,
'Interpreta la intención de los gestos y posturas corporales en diversas situaciones comunicativas.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística y cultural que permite desarrollar imaginación y creatividad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 3,
'Reconoce los textos literarios como forma de expresión artística y cultural que permite desarrollar imaginación y creatividad',
'Reconoce los textos literarios como una forma de expresión artística y cultural que le permite desarrollar su imaginación y creatividad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 3), 1,
'Lee, escucha y comenta textos literarios de diferentes géneros y tradiciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 3), 2,
'Identifica las características de los textos narrativos, poéticos y dramáticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 3), 3,
'Expresa sus emociones y opiniones frente a los textos literarios leídos o escuchados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 3), 4,
'Crea textos literarios breves en los que expresa su imaginación y sentimientos.');

-- DBA 4: Interpreta textos literarios a partir del análisis de personajes, acciones, ambientes y recursos expresivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 4,
'Interpreta textos literarios a partir del análisis de personajes, acciones, ambientes y recursos expresivos',
'Interpreta textos literarios a partir del análisis de sus personajes, acciones, ambientes y recursos expresivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 4), 1,
'Reconoce los personajes principales y secundarios y sus características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 4), 2,
'Describe los ambientes en que ocurren los hechos del texto literario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 4), 3,
'Identifica los recursos expresivos y estilísticos que usa el autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 4), 4,
'Explica el sentido de los textos literarios y los relaciona con su experiencia personal o con otras lecturas.');

-- DBA 5: Comprende mensajes orales de distinta índole y evalúa su propósito, intención y estructura
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 5,
'Comprende mensajes orales de distinta índole y evalúa su propósito, intención y estructura',
'Comprende mensajes orales de distinta índole y evalúa su propósito, intención y estructura.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 5), 1,
'Escucha y comprende mensajes orales informativos, argumentativos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 5), 2,
'Identifica el propósito comunicativo y la intención del hablante.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 5), 3,
'Reconoce las ideas principales y secundarias en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 5), 4,
'Evalúa la claridad, coherencia y pertinencia de los mensajes orales que escucha.');

-- DBA 6: Comprende textos escritos de diferentes tipos, reconociendo organización, propósito comunicativo e intención del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 6,
'Comprende textos escritos de diferentes tipos, reconociendo organización, propósito comunicativo e intención del autor',
'Comprende textos escritos de diferentes tipos, reconociendo la organización, el propósito comunicativo y la intención del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 6), 1,
'Identifica la estructura de los textos narrativos, descriptivos, informativos y argumentativos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 6), 2,
'Reconoce las ideas principales y secundarias en los textos que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 6), 3,
'Establece relaciones entre las ideas del texto y sus conocimientos previos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 6), 4,
'Formula inferencias y conclusiones a partir de la información explícita e implícita.');

-- DBA 7: Produce textos orales para comunicar ideas, sentimientos y opiniones con coherencia y adecuación al contexto
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 7,
'Produce textos orales para comunicar ideas, sentimientos y opiniones con coherencia y adecuación al contexto',
'Produce textos orales para comunicar ideas, sentimientos y opiniones con coherencia y adecuación al contexto.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 7), 1,
'Expone ideas y argumentos de manera ordenada y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 7), 2,
'Utiliza recursos expresivos y de apoyo (voz, gestos, entonación, material visual).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 7), 3,
'Participa en debates, exposiciones y presentaciones orales respetando los turnos y las opiniones de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa y al público destinatario.');

-- DBA 8: Escribe textos narrativos, descriptivos, informativos y argumentativos con coherencia, cohesión y corrección ortográfica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 8, 8,
'Escribe textos narrativos, descriptivos, informativos y argumentativos con coherencia, cohesión y corrección ortográfica',
'Escribe textos narrativos, descriptivos, informativos y argumentativos con coherencia, cohesión y corrección ortográfica.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 8), 1,
'Planifica sus textos según el propósito comunicativo y el público.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 8), 2,
'Organiza las ideas en párrafos coherentes y conectados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 8), 3,
'Emplea conectores y signos de puntuación adecuados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 8 AND numero_dba = 8), 4,
'Revisa y corrige sus escritos para mejorar su claridad, presentación y ortografía.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 6°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 6° grado (id_grado = 9)

-- DBA 1: Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 1, 
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica los medios de comunicación masiva y sus funciones principales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 1), 2,
'Diferencia los mensajes informativos, publicitarios y de opinión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 1), 3,
'Analiza el propósito y la intención comunicativa de los mensajes que circulan en los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 1), 4,
'Reflexiona sobre la influencia de los medios en la construcción de la opinión pública y en la vida cotidiana.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 2), 1,
'Identifica los recursos de la comunicación no verbal en distintos contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 2), 2,
'Explica cómo los gestos, posturas y movimientos complementan el mensaje oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 2), 3,
'Emplea conscientemente la comunicación no verbal en exposiciones y conversaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos, posturas y movimientos de otras personas.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística y cultural que permite desarrollar imaginación, creatividad y sensibilidad estética
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 3,
'Reconoce los textos literarios como forma de expresión artística y cultural que permite desarrollar imaginación, creatividad y sensibilidad estética',
'Reconoce los textos literarios como una forma de expresión artística y cultural que le permite desarrollar su imaginación, creatividad y sensibilidad estética.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 3), 1,
'Lee, escucha y comenta textos literarios de distintos géneros y tradiciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 3), 2,
'Identifica las características de los textos narrativos, poéticos y dramáticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 3), 3,
'Interpreta los significados simbólicos y expresivos de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 3), 4,
'Expresa sus emociones, opiniones e interpretaciones frente a los textos leídos.');

-- DBA 4: Interpreta textos literarios a partir del análisis de personajes, acciones, ambientes, recursos expresivos y estructura
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 4,
'Interpreta textos literarios a partir del análisis de personajes, acciones, ambientes, recursos expresivos y estructura',
'Interpreta textos literarios a partir del análisis de personajes, acciones, ambientes, recursos expresivos y estructura.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 4), 1,
'Identifica los elementos estructurales de los textos literarios (inicio, nudo, desenlace).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 4), 2,
'Reconoce los recursos expresivos que usa el autor para construir significado.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 4), 3,
'Analiza las relaciones entre personajes, acciones y contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 4), 4,
'Formula opiniones argumentadas sobre el sentido y los valores que transmite el texto.');

-- DBA 5: Comprende mensajes orales de diversa índole e identifica propósitos, intenciones comunicativas y estructuras
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 5,
'Comprende mensajes orales de diversa índole e identifica propósitos, intenciones comunicativas y estructuras',
'Comprende mensajes orales de diversa índole e identifica sus propósitos, intenciones comunicativas y estructuras.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 5), 1,
'Escucha y comprende mensajes orales informativos, argumentativos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 5), 2,
'Distingue las intenciones comunicativas del hablante.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 5), 3,
'Identifica las ideas principales y secundarias en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 5), 4,
'Evalúa la coherencia y pertinencia del mensaje escuchado.');

-- DBA 6: Comprende textos escritos de diferentes tipos y reconoce estructura, propósito comunicativo e intención del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 6,
'Comprende textos escritos de diferentes tipos y reconoce estructura, propósito comunicativo e intención del autor',
'Comprende textos escritos de diferentes tipos y reconoce su estructura, propósito comunicativo y la intención del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 6), 1,
'Identifica las ideas principales y secundarias de los textos que lee.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 6), 2,
'Reconoce la estructura de los textos narrativos, expositivos, descriptivos y argumentativos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 6), 3,
'Establece inferencias a partir de la información explícita e implícita.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 6), 4,
'Explica el propósito y la intención comunicativa del texto.');

-- DBA 7: Produce textos orales coherentes y adecuados al contexto comunicativo y a la intención del hablante
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 7,
'Produce textos orales coherentes y adecuados al contexto comunicativo y a la intención del hablante',
'Produce textos orales coherentes y adecuados al contexto comunicativo y a la intención del hablante.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 7), 1,
'Expone ideas y argumentos de manera organizada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 7), 2,
'Usa recursos expresivos como la entonación, el ritmo y el lenguaje corporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 7), 3,
'Participa activamente en debates, exposiciones y discusiones respetando las reglas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa y al público.');

-- DBA 8: Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 9, 8,
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica',
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 8), 1,
'Planifica sus escritos teniendo en cuenta el propósito, el destinatario y el tipo de texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 8), 2,
'Organiza las ideas en párrafos con unidad temática.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 8), 3,
'Emplea conectores y signos de puntuación adecuados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 9 AND numero_dba = 8), 4,
'Revisa y corrige sus textos para mejorar su estructura y claridad.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 7°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 7° grado (id_grado = 10)

-- DBA 1: Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 1, 
'Reconoce los medios de comunicación masiva y sus características como posibilidad para informarse, participar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación masiva y sus características como una posibilidad para informarse, participar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica los medios de comunicación y sus funciones principales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 1), 2,
'Diferencia los tipos de mensajes (informativos, publicitarios, de opinión).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 1), 3,
'Analiza el propósito y la intención comunicativa de los mensajes difundidos por los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 1), 4,
'Reflexiona sobre la influencia de los medios en la construcción de valores, creencias y opiniones.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 2), 1,
'Identifica los elementos de la comunicación no verbal en diferentes situaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 2), 2,
'Explica cómo los gestos, las posturas y los movimientos complementan el mensaje oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 2), 3,
'Emplea la comunicación no verbal para reforzar sus intervenciones orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos y posturas de otros interlocutores.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística y cultural que permite comprender el mundo, disfrutar de la lectura y desarrollar sensibilidad estética
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 3,
'Reconoce los textos literarios como forma de expresión artística y cultural que permite comprender el mundo, disfrutar de la lectura y desarrollar sensibilidad estética',
'Reconoce los textos literarios como una forma de expresión artística y cultural que le permite comprender el mundo, disfrutar de la lectura y desarrollar su sensibilidad estética.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 3), 1,
'Lee y analiza textos literarios de diferentes géneros y contextos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 3), 2,
'Identifica las características que distinguen los textos literarios de otros tipos de textos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 3), 3,
'Explica los valores estéticos, éticos y culturales presentes en los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 3), 4,
'Expresa interpretaciones y opiniones personales frente a las obras leídas.');

-- DBA 4: Interpreta textos literarios a partir del análisis de elementos estructurales, semánticos y estilísticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 4,
'Interpreta textos literarios a partir del análisis de elementos estructurales, semánticos y estilísticos',
'Interpreta textos literarios a partir del análisis de sus elementos estructurales, semánticos y estilísticos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 4), 1,
'Identifica los personajes, los ambientes y las acciones que configuran la trama del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 4), 2,
'Reconoce los recursos literarios y su función dentro del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 4), 3,
'Analiza la relación entre el contenido, la forma y la intención estética del autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 4), 4,
'Formula interpretaciones sustentadas en evidencias del texto.');

-- DBA 5: Comprende mensajes orales de distinta índole e identifica propósitos, intenciones y argumentos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 5,
'Comprende mensajes orales de distinta índole e identifica propósitos, intenciones y argumentos',
'Comprende mensajes orales de distinta índole e identifica sus propósitos, intenciones y argumentos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 5), 1,
'Escucha atentamente mensajes orales informativos, argumentativos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 5), 2,
'Distingue las intenciones comunicativas del emisor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 5), 3,
'Identifica los argumentos y las ideas principales en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 5), 4,
'Evalúa la coherencia, pertinencia y efectividad de los mensajes escuchados.');

-- DBA 6: Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo e intención del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 6,
'Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo e intención del autor',
'Comprende textos escritos de diferente tipo y complejidad, reconociendo su estructura, propósito comunicativo y la intención del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 6), 1,
'Reconoce la organización textual y los recursos lingüísticos empleados por el autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 6), 2,
'Identifica el propósito comunicativo y la intención del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 6), 3,
'Establece relaciones entre las ideas explícitas e implícitas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 6), 4,
'Formula inferencias y conclusiones sustentadas en la información leída.');

-- DBA 7: Produce textos orales coherentes y argumentados, adecuados al contexto comunicativo y a la intención del hablante
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 7,
'Produce textos orales coherentes y argumentados, adecuados al contexto comunicativo y a la intención del hablante',
'Produce textos orales coherentes y argumentados, adecuados al contexto comunicativo y a la intención del hablante.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 7), 1,
'Expone ideas y argumentos de manera lógica y estructurada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 7), 2,
'Usa recursos expresivos (entonación, pausas, gestos) para fortalecer su comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 7), 3,
'Participa en debates, mesas redondas y exposiciones respetando las normas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 7), 4,
'Ajusta su discurso según el público y la situación comunicativa.');

-- DBA 8: Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 10, 8,
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica',
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección gramatical y ortográfica.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 8), 1,
'Planifica sus textos teniendo en cuenta el propósito y el destinatario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 8), 2,
'Desarrolla ideas de manera ordenada y clara en párrafos articulados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 8), 3,
'Emplea conectores, signos de puntuación y recursos de cohesión adecuados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 10 AND numero_dba = 8), 4,
'Revisa, corrige y mejora sus escritos para garantizar claridad y corrección.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 8°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 8° grado (id_grado = 11)

-- DBA 1: Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 1, 
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 1), 1,
'Identifica las características de los medios de comunicación masiva y las nuevas tecnologías de la información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 1), 2,
'Diferencia los tipos de mensajes (informativos, publicitarios, de opinión y de entretenimiento).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 1), 3,
'Analiza la intención y los recursos persuasivos utilizados en los mensajes de los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 1), 4,
'Reflexiona sobre el papel de los medios en la construcción de la identidad cultural y social.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 2), 1,
'Identifica y analiza los recursos de la comunicación no verbal en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 2), 2,
'Explica cómo los gestos, posturas y movimientos complementan o sustituyen la comunicación oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 2), 3,
'Emplea adecuadamente los elementos de la comunicación no verbal en exposiciones y presentaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos, posturas y movimientos en distintas situaciones.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender diferentes visiones del mundo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 3,
'Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender diferentes visiones del mundo',
'Reconoce los textos literarios como una forma de expresión artística, cultural y social que le permite comprender diferentes visiones del mundo.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 3), 1,
'Lee, interpreta y comenta textos literarios de diversos géneros y contextos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 3), 2,
'Identifica los recursos literarios y su función dentro de las obras leídas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 3), 3,
'Analiza las relaciones entre el contenido, la forma y el contexto de producción del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 3), 4,
'Expresa interpretaciones y valoraciones personales sustentadas en evidencias textuales.');

-- DBA 4: Interpreta textos literarios a partir del análisis de estructuras narrativas, poéticas o dramáticas y recursos expresivos del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 4,
'Interpreta textos literarios a partir del análisis de estructuras narrativas, poéticas o dramáticas y recursos expresivos del autor',
'Interpreta textos literarios a partir del análisis de sus estructuras narrativas, poéticas o dramáticas y de los recursos expresivos empleados por el autor.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 4), 1,
'Identifica los elementos estructurales y formales de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 4), 2,
'Reconoce los recursos estilísticos y figuras literarias que construyen el sentido del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 4), 3,
'Explica cómo el lenguaje contribuye a la creación de efectos expresivos y estéticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 4), 4,
'Formula interpretaciones argumentadas sobre el significado global del texto.');

-- DBA 5: Comprende mensajes orales de distinta índole e identifica propósito, estructura e intencionalidad comunicativa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 5,
'Comprende mensajes orales de distinta índole e identifica propósito, estructura e intencionalidad comunicativa',
'Comprende mensajes orales de distinta índole e identifica su propósito, estructura e intencionalidad comunicativa.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 5), 1,
'Escucha, analiza y evalúa mensajes orales informativos, argumentativos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 5), 2,
'Reconoce las intenciones comunicativas del emisor y los recursos que utiliza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 5), 3,
'Identifica los argumentos y las ideas principales en discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 5), 4,
'Valora la coherencia, pertinencia y efectividad del mensaje oral en función de su propósito.');

-- DBA 6: Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo y estrategias discursivas del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 6,
'Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo y estrategias discursivas del autor',
'Comprende textos escritos de diferente tipo y complejidad, reconociendo su estructura, propósito comunicativo y las estrategias discursivas del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 6), 1,
'Identifica las características estructurales y lingüísticas de los textos narrativos, expositivos y argumentativos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 6), 2,
'Reconoce las ideas explícitas e implícitas en el texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 6), 3,
'Explica el propósito comunicativo del autor y los recursos que utiliza para lograrlo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 6), 4,
'Formula inferencias, conclusiones y opiniones críticas sobre lo leído.');

-- DBA 7: Produce textos orales argumentativos, expositivos y expresivos con coherencia y adecuación al contexto comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 7,
'Produce textos orales argumentativos, expositivos y expresivos con coherencia y adecuación al contexto comunicativo',
'Produce textos orales argumentativos, expositivos y expresivos con coherencia y adecuación al contexto comunicativo.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 7), 1,
'Expone ideas y argumentos de manera ordenada y lógica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 7), 2,
'Utiliza recursos verbales y no verbales para fortalecer la efectividad del mensaje.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 7), 3,
'Participa activamente en discusiones, exposiciones y debates respetando las normas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa, al público y al contexto.');

-- DBA 8: Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 11, 8,
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical',
'Escribe textos narrativos, descriptivos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 8), 1,
'Planifica sus escritos de acuerdo con el propósito, el público y el tipo de texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 8), 2,
'Desarrolla ideas de manera clara, organizada y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 8), 3,
'Utiliza conectores y recursos lingüísticos que den cohesión al texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 11 AND numero_dba = 8), 4,
'Revisa, corrige y ajusta sus textos para mejorar su calidad comunicativa.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 9°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 9° grado (id_grado = 12)

-- DBA 1: Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 1, 
'Reconoce los medios de comunicación y sus características como posibilidad para informarse, interactuar y acceder a manifestaciones culturales',
'Reconoce los medios de comunicación y sus características como una posibilidad para informarse, interactuar y acceder a diferentes manifestaciones culturales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 1), 1,
'Identifica las características de los medios de comunicación masiva y de las nuevas tecnologías de la información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 1), 2,
'Diferencia los tipos de mensajes (informativos, publicitarios, de opinión y de entretenimiento).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 1), 3,
'Analiza la intención comunicativa, los recursos persuasivos y los efectos de los mensajes de los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 1), 4,
'Reflexiona críticamente sobre el papel de los medios en la construcción de la realidad social y cultural.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 2), 1,
'Identifica y analiza los elementos de la comunicación no verbal en distintos contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 2), 2,
'Explica cómo los gestos, posturas y movimientos complementan, contradicen o reemplazan la comunicación oral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 2), 3,
'Emplea conscientemente los recursos no verbales en la expresión oral y escrita.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos, posturas y movimientos en diferentes situaciones sociales.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender la realidad y construir identidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 3,
'Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender la realidad y construir identidad',
'Reconoce los textos literarios como una forma de expresión artística, cultural y social que le permite comprender la realidad y construir identidad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 3), 1,
'Lee, interpreta y comenta textos literarios de diversos géneros, épocas y contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 3), 2,
'Analiza los elementos estructurales, temáticos y estilísticos de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 3), 3,
'Explica los valores estéticos, éticos y culturales presentes en las obras leídas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 3), 4,
'Formula juicios críticos y valoraciones personales sustentadas en evidencias textuales.');

-- DBA 4: Interpreta textos literarios a partir del análisis de estructura, estilo, temática, contexto y recursos expresivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 4,
'Interpreta textos literarios a partir del análisis de estructura, estilo, temática, contexto y recursos expresivos',
'Interpreta textos literarios a partir del análisis de su estructura, estilo, temática, contexto y recursos expresivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 4), 1,
'Identifica los recursos literarios que construyen el sentido del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 4), 2,
'Analiza la estructura narrativa, poética o dramática del texto literario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 4), 3,
'Explica la relación entre la forma y el contenido en la obra leída.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 4), 4,
'Formula interpretaciones y valoraciones críticas fundamentadas en el texto.');

-- DBA 5: Comprende mensajes orales de distinta índole, identificando propósito, estructura, argumentos e intención comunicativa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 5,
'Comprende mensajes orales de distinta índole, identificando propósito, estructura, argumentos e intención comunicativa',
'Comprende mensajes orales de distinta índole, identificando su propósito, estructura, argumentos e intención comunicativa.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 5), 1,
'Escucha, analiza y evalúa mensajes orales informativos, argumentativos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 5), 2,
'Reconoce la intención comunicativa del emisor y los recursos lingüísticos que utiliza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 5), 3,
'Identifica los argumentos, ideas principales y secundarias en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 5), 4,
'Valora la pertinencia, coherencia y efectividad del mensaje escuchado.');

-- DBA 6: Comprende textos escritos de diversa índole y complejidad, reconociendo estructura, propósito, intención comunicativa y estrategias discursivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 6,
'Comprende textos escritos de diversa índole y complejidad, reconociendo estructura, propósito, intención comunicativa y estrategias discursivas',
'Comprende textos escritos de diversa índole y complejidad, reconociendo su estructura, propósito, intención comunicativa y estrategias discursivas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 6), 1,
'Identifica las características formales y lingüísticas de diferentes tipos de texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 6), 2,
'Explica el propósito comunicativo del autor y los recursos empleados para lograrlo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 6), 3,
'Establece inferencias y conclusiones a partir de la información explícita e implícita.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 6), 4,
'Formula valoraciones críticas sustentadas en evidencias textuales.');

-- DBA 7: Produce textos orales expositivos y argumentativos con coherencia, cohesión y adecuación al contexto comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 7,
'Produce textos orales expositivos y argumentativos con coherencia, cohesión y adecuación al contexto comunicativo',
'Produce textos orales expositivos y argumentativos con coherencia, cohesión y adecuación al contexto comunicativo.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 7), 1,
'Expone ideas y argumentos de manera estructurada y lógica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 7), 2,
'Utiliza recursos expresivos verbales y no verbales para fortalecer el mensaje.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 7), 3,
'Participa activamente en debates, mesas redondas y presentaciones orales respetando las normas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa, al público y al contexto.');

-- DBA 8: Escribe textos narrativos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 12, 8,
'Escribe textos narrativos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical',
'Escribe textos narrativos, expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 8), 1,
'Planifica sus textos teniendo en cuenta el propósito comunicativo y el destinatario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 8), 2,
'Desarrolla ideas en párrafos articulados mediante conectores adecuados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 8), 3,
'Revisa, corrige y mejora sus escritos con base en la retroalimentación recibida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 12 AND numero_dba = 8), 4,
'Utiliza adecuadamente los signos de puntuación y respeta las normas gramaticales del idioma.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 10°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 10° grado (id_grado = 13)

-- DBA 1: Reconoce los medios de comunicación y nuevas tecnologías como posibilidad para informarse, interactuar y participar en la construcción de la realidad social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 1, 
'Reconoce los medios de comunicación y nuevas tecnologías como posibilidad para informarse, interactuar y participar en la construcción de la realidad social',
'Reconoce los medios de comunicación y las nuevas tecnologías de la información como una posibilidad para informarse, interactuar y participar en la construcción de la realidad social.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 1), 1,
'Identifica los diferentes medios de comunicación masiva y los compara con las nuevas tecnologías digitales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 1), 2,
'Analiza los propósitos, las intenciones y los efectos de los mensajes transmitidos por los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 1), 3,
'Reflexiona críticamente sobre la influencia de los medios en la formación de la opinión pública.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 1), 4,
'Evalúa la credibilidad de las fuentes y la veracidad de la información difundida en distintos medios.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo y construcción de sentido
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo y construcción de sentido',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo y de la construcción de sentido.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 2), 1,
'Analiza los recursos de la comunicación no verbal en diferentes situaciones comunicativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 2), 2,
'Explica cómo los gestos, posturas y movimientos contribuyen a la interpretación del mensaje.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 2), 3,
'Utiliza conscientemente los elementos de la comunicación no verbal en exposiciones, debates y presentaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos y posturas de los interlocutores en diferentes contextos.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender el mundo y su propia realidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 3,
'Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender el mundo y su propia realidad',
'Reconoce los textos literarios como una forma de expresión artística, cultural y social que le permite comprender el mundo y su propia realidad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 3), 1,
'Lee, interpreta y comenta textos literarios de diferentes épocas, géneros y contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 3), 2,
'Analiza los elementos estructurales, temáticos y estilísticos de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 3), 3,
'Explica los valores estéticos, éticos y culturales que transmiten las obras leídas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 3), 4,
'Formula juicios críticos y valoraciones sustentadas en evidencias textuales.');

-- DBA 4: Interpreta textos literarios a partir del análisis de estructura, estilo, temática y contexto de producción
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 4,
'Interpreta textos literarios a partir del análisis de estructura, estilo, temática y contexto de producción',
'Interpreta textos literarios a partir del análisis de su estructura, estilo, temática y contexto de producción.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 4), 1,
'Reconoce los recursos literarios y figuras retóricas que construyen el sentido del texto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 4), 2,
'Analiza la estructura y el lenguaje de los textos narrativos, poéticos o dramáticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 4), 3,
'Explica la relación entre el contenido, la forma y la intención del autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 4), 4,
'Argumenta interpretaciones sustentadas en evidencias textuales.');

-- DBA 5: Comprende mensajes orales de distinta índole, identificando propósito, estructura, argumentos e intención comunicativa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 5,
'Comprende mensajes orales de distinta índole, identificando propósito, estructura, argumentos e intención comunicativa',
'Comprende mensajes orales de distinta índole, identificando su propósito, estructura, argumentos e intención comunicativa.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 5), 1,
'Escucha, analiza y evalúa discursos orales informativos, persuasivos y expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 5), 2,
'Reconoce las intenciones comunicativas del hablante y los recursos empleados para lograr sus fines.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 5), 3,
'Identifica los argumentos y las ideas principales en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 5), 4,
'Evalúa la coherencia, pertinencia y efectividad de los mensajes escuchados.');

-- DBA 6: Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo, intención y estrategias discursivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 6,
'Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo, intención y estrategias discursivas',
'Comprende textos escritos de diferente tipo y complejidad, reconociendo su estructura, propósito comunicativo, intención y estrategias discursivas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 6), 1,
'Identifica las características formales y lingüísticas de los textos leídos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 6), 2,
'Explica el propósito comunicativo y los recursos utilizados por el autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 6), 3,
'Establece relaciones entre las ideas del texto y los conocimientos previos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 6), 4,
'Formula inferencias, conclusiones y valoraciones críticas fundamentadas en el texto.');

-- DBA 7: Produce textos orales argumentativos y expositivos con coherencia, cohesión y adecuación al contexto comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 7,
'Produce textos orales argumentativos y expositivos con coherencia, cohesión y adecuación al contexto comunicativo',
'Produce textos orales argumentativos y expositivos con coherencia, cohesión y adecuación al contexto comunicativo.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 7), 1,
'Expone y argumenta ideas con claridad, orden y fundamento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 7), 2,
'Emplea recursos verbales y no verbales para reforzar la efectividad del mensaje.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 7), 3,
'Participa en debates, foros y exposiciones respetando las normas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa y al público destinatario.');

-- DBA 8: Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 13, 8,
'Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical',
'Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 8), 1,
'Planifica sus textos considerando el propósito, el público y el tipo de discurso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 8), 2,
'Organiza ideas en párrafos articulados mediante conectores adecuados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 8), 3,
'Revisa y corrige sus escritos con base en criterios de coherencia y corrección lingüística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 13 AND numero_dba = 8), 4,
'Utiliza apropiadamente los signos de puntuación y respeta las normas gramaticales del idioma.');

-- =============================================
-- INSERTAR DATOS: LENGUAJE GRADO 11°
-- =============================================

-- Lenguaje (id_asignatura = 1) y 11° grado (id_grado = 14)

-- DBA 1: Reconoce los medios de comunicación y nuevas tecnologías como posibilidad para informarse, interactuar, participar y construir conocimiento
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 1, 
'Reconoce los medios de comunicación y nuevas tecnologías como posibilidad para informarse, interactuar, participar y construir conocimiento',
'Reconoce los medios de comunicación y las nuevas tecnologías de la información como una posibilidad para informarse, interactuar, participar y construir conocimiento.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 1), 1,
'Identifica las características de los diferentes medios de comunicación masiva y de las nuevas tecnologías.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 1), 2,
'Analiza los propósitos, intenciones y efectos de los mensajes que circulan en los medios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 1), 3,
'Reflexiona críticamente sobre el papel de los medios en la formación de la opinión pública y en la construcción de la realidad social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 1), 4,
'Evalúa la credibilidad, pertinencia y veracidad de la información difundida a través de distintos medios.');

-- DBA 2: Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo y construcción de sentido
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 2,
'Reconoce la importancia de gestos, posturas, movimientos corporales y señales visuales como parte del proceso comunicativo y construcción de sentido',
'Reconoce la importancia de los gestos, las posturas, los movimientos corporales y las señales visuales como parte del proceso comunicativo y de la construcción de sentido.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 2), 1,
'Analiza la función de los gestos, las posturas y los movimientos en la comunicación oral y no verbal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 2), 2,
'Explica cómo la comunicación no verbal contribuye a la interpretación de los mensajes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 2), 3,
'Utiliza adecuadamente los recursos de la comunicación no verbal en presentaciones y debates.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 2), 4,
'Interpreta la intención comunicativa de los gestos, posturas y movimientos en distintos contextos sociales.');

-- DBA 3: Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender el mundo y desarrollar pensamiento crítico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 3,
'Reconoce los textos literarios como forma de expresión artística, cultural y social que permite comprender el mundo y desarrollar pensamiento crítico',
'Reconoce los textos literarios como una forma de expresión artística, cultural y social que le permite comprender el mundo y desarrollar pensamiento crítico.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 3), 1,
'Lee, interpreta y comenta textos literarios de diferentes géneros, épocas y contextos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 3), 2,
'Analiza los recursos formales, temáticos y estilísticos de los textos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 3), 3,
'Explica los valores estéticos, éticos y culturales presentes en las obras literarias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 3), 4,
'Formula juicios críticos sustentados en evidencias textuales y contextuales.');

-- DBA 4: Interpreta textos literarios a partir del análisis de estructura, estilo, temática, contexto de producción y recursos expresivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 4,
'Interpreta textos literarios a partir del análisis de estructura, estilo, temática, contexto de producción y recursos expresivos',
'Interpreta textos literarios a partir del análisis de su estructura, estilo, temática, contexto de producción y recursos expresivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 4), 1,
'Reconoce los elementos estructurales y formales del texto literario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 4), 2,
'Analiza la relación entre el contenido, la forma y el propósito del autor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 4), 3,
'Explica el sentido global de la obra a partir del uso de los recursos literarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 4), 4,
'Argumenta interpretaciones y valoraciones sustentadas en el texto y en su contexto histórico y social.');

-- DBA 5: Comprende mensajes orales de diversa índole, identificando propósito, estructura, argumentos e intención comunicativa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 5,
'Comprende mensajes orales de diversa índole, identificando propósito, estructura, argumentos e intención comunicativa',
'Comprende mensajes orales de diversa índole, identificando su propósito, estructura, argumentos e intención comunicativa.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 5), 1,
'Escucha, analiza y evalúa discursos orales de carácter informativo, argumentativo y persuasivo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 5), 2,
'Reconoce las intenciones comunicativas del hablante y los recursos empleados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 5), 3,
'Identifica los argumentos y las ideas principales y secundarias en los discursos orales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 5), 4,
'Evalúa la pertinencia, coherencia y efectividad de los mensajes escuchados.');

-- DBA 6: Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo, intención y estrategias discursivas del autor
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 6,
'Comprende textos escritos de diferente tipo y complejidad, reconociendo estructura, propósito comunicativo, intención y estrategias discursivas del autor',
'Comprende textos escritos de diferente tipo y complejidad, reconociendo su estructura, propósito comunicativo, intención y estrategias discursivas del autor.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 6), 1,
'Identifica las características formales y lingüísticas de los textos leídos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 6), 2,
'Explica el propósito comunicativo del autor y los recursos utilizados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 6), 3,
'Establece inferencias y conclusiones a partir de la información explícita e implícita.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 6), 4,
'Formula valoraciones críticas sustentadas en evidencias textuales y contextuales.');

-- DBA 7: Produce textos orales argumentativos, expositivos y expresivos con coherencia, cohesión y adecuación al contexto comunicativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 7,
'Produce textos orales argumentativos, expositivos y expresivos con coherencia, cohesión y adecuación al contexto comunicativo',
'Produce textos orales argumentativos, expositivos y expresivos con coherencia, cohesión y adecuación al contexto comunicativo.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 7), 1,
'Expone y argumenta ideas de manera clara, organizada y fundamentada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 7), 2,
'Utiliza recursos verbales y no verbales que fortalezcan su discurso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 7), 3,
'Participa en debates, foros, paneles y exposiciones respetando las normas del diálogo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 7), 4,
'Ajusta su discurso a la intención comunicativa, al público y al contexto.');

-- DBA 8: Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(1, 14, 8,
'Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical',
'Escribe textos expositivos y argumentativos con coherencia, cohesión y corrección ortográfica y gramatical.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 8), 1,
'Planifica y estructura sus textos teniendo en cuenta el propósito y el destinatario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 8), 2,
'Desarrolla ideas con claridad y lógica en párrafos articulados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 8), 3,
'Usa conectores, signos de puntuación y normas gramaticales adecuadamente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 1 AND id_grado = 14 AND numero_dba = 8), 4,
'Revisa, corrige y ajusta sus textos para garantizar precisión, coherencia y estilo.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 1°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 1° grado (id_grado = 4)

-- DBA 1: Se ubica en el espacio que habita teniendo como referencia su propio cuerpo y los puntos cardinales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 1, 
'Se ubica en el espacio que habita teniendo como referencia su propio cuerpo y los puntos cardinales',
'Se ubica en el espacio que habita teniendo como referencia su propio cuerpo y los puntos cardinales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 1), 1,
'Relaciona su izquierda-derecha, adelante-atrás con los puntos cardinales, al ubicar, en representaciones gráficas de la escuela, aquellos lugares como rectoría, cafetería, patio de recreo, coordinación y sala de profesores, entre otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 1), 2,
'Dibuja las instituciones sociales de carácter deportivo, educativo, religioso y político, existentes en su barrio, vereda o lugar donde vive.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 1), 3,
'Localiza en representaciones gráficas o dibujos de su barrio, vereda o lugar donde vive, algunos referentes (tienda, iglesia, parque, escuela) teniendo en cuenta los puntos cardinales y conoce los acontecimientos que se dan en estos lugares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 1), 4,
'Describe verbalmente el recorrido que realiza entre su casa y la institución educativa donde estudia, señalando aquellos lugares que considera representativos o muy conocidos en su comunidad y el porqué de su importancia.');

-- DBA 2: Describe las características del paisaje geográfico del barrio, vereda o lugar donde vive, sus componentes y formas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 2,
'Describe las características del paisaje geográfico del barrio, vereda o lugar donde vive, sus componentes y formas',
'Describe las características del paisaje geográfico del barrio, vereda o lugar donde vive, sus componentes y formas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 2), 1,
'Reconoce las diferentes formas de relieve en su entorno geográfico o lugar donde vive, por ejemplo: costas, islas, montañas, valles, llanuras y/o mesetas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 2), 2,
'Diferencia los estados del tiempo atmosférico de acuerdo con las sensaciones de calor y frío manifiestas en su cuerpo y con base en los momentos de lluvia y sequía que se dan en el lugar donde vive.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 2), 3,
'Identifica aquellas obras de infraestructura que se han realizado en su comunidad y expresa las ventajas que estas traen.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 2), 4,
'Representa de diferentes maneras, aquellos problemas ambientales que afectan el entorno de la comunidad en el contexto del barrio, vereda o lugar donde vive.');

-- DBA 3: Describe el tiempo personal y se sitúa en secuencias de eventos propios y sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 3,
'Describe el tiempo personal y se sitúa en secuencias de eventos propios y sociales',
'Describe el tiempo personal y se sitúa en secuencias de eventos propios y sociales.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 3), 1,
'Nombra ordenadamente los días de la semana y los meses del año.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 3), 2,
'Diferencia el ayer, el hoy y el mañana desde las actividades cotidianas que realiza y la duración de estas en horas y minutos mediante la lectura del reloj.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 3), 3,
'Identifica los miembros de su familia y verbaliza quiénes nacieron antes o después de él.');

-- DBA 4: Reconoce la noción de cambio a partir de las transformaciones que ha vivido en los últimos años a nivel personal, de su familia y del entorno barrial, veredal o del lugar donde vive
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 4,
'Reconoce la noción de cambio a partir de las transformaciones que ha vivido en los últimos años a nivel personal, de su familia y del entorno barrial, veredal o del lugar donde vive',
'Reconoce la noción de cambio a partir de las transformaciones que ha vivido en los últimos años a nivel personal, de su familia y del entorno barrial, veredal o del lugar donde vive.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 4), 1,
'Relata los principales acontecimientos sociales ocurridos en el aula de clase, por ejemplo, el inicio de la vida escolar, la celebración del día de los niños, las izadas de bandera o la celebración de cumpleaños, entre otros, diferenciando el antes y el ahora.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 4), 2,
'Señala las transformaciones recientes observadas en el entorno físico de su comunidad y el para qué se realizaron.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 4), 3,
'Describe aquellas organizaciones sociales a las que pertenece en su comunidad: familia, colegio y vecindario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 4), 4,
'Plantea preguntas acerca de sucesos destacados que han tenido lugar en su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 4), 5,
'Recuerda las fechas de los cumpleaños de sus padres, hermanos, amigos y compañeros de clase más cercanos, diferenciando las edades entre ellos.');

-- DBA 5: Reconoce su individualidad y su pertenencia a los diferentes grupos sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 5,
'Reconoce su individualidad y su pertenencia a los diferentes grupos sociales',
'Reconoce su individualidad y su pertenencia a los diferentes grupos sociales.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 5), 1,
'Expresa algunas características físicas y emocionales que lo hacen un ser único.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 5), 2,
'Compara similitudes y diferencias entre sus gustos, costumbres y formas de comunicarse, con los demás integrantes del salón de clase.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 5), 3,
'Reconoce de sí mismo, de sus compañeros y de sus familiares aquellas cualidades que le ayudan a estar mejor entre los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 5), 4,
'Reconoce las costumbres y tradiciones culturales de su comunidad mediante los relatos de los abuelos y personas mayores del barrio, vereda o lugar donde vive.');

-- DBA 6: Comprende cambios en las formas de habitar de los grupos humanos, desde el reconocimiento de los tipos de vivienda que se encuentran en el contexto de su barrio, vereda o lugar donde vive
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 6,
'Comprende cambios en las formas de habitar de los grupos humanos, desde el reconocimiento de los tipos de vivienda que se encuentran en el contexto de su barrio, vereda o lugar donde vive',
'Comprende cambios en las formas de habitar de los grupos humanos, desde el reconocimiento de los tipos de vivienda que se encuentran en el contexto de su barrio, vereda o lugar donde vive.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 6), 1,
'Señala los lugares de procedencia de su familia y comprende cómo llegaron a su vivienda actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 6), 2,
'Nombra los materiales utilizados en la construcción de la casa donde vive y la distribución de las habitaciones que hay en ella.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 6), 3,
'Identifica las viviendas que se destacan en su comunidad, que son patrimonio hoy y que deben conservarse.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 6), 4,
'Reconoce el valor de la vivienda como el espacio donde tiene lugar su hogar y donde recibe seguridad y cuidado de su familia.');

-- DBA 7: Participa en la construcción de acuerdos básicos sobre normas para el logro de metas comunes en su contexto cercano (compañeros y familia) y se compromete con su cumplimiento
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 7,
'Participa en la construcción de acuerdos básicos sobre normas para el logro de metas comunes en su contexto cercano (compañeros y familia) y se compromete con su cumplimiento',
'Participa en la construcción de acuerdos básicos sobre normas para el logro de metas comunes en su contexto cercano (compañeros y familia) y se compromete con su cumplimiento.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 7), 1,
'Presenta sus ideas, intereses y sentimientos frente a las normas establecidas en la familia, en el salón de clase y otros espacios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 7), 2,
'Expresa sus opiniones y colabora activamente en la construcción de los acuerdos grupales para la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 7), 3,
'Plantea alternativas de solución frente a situaciones conflictivas en su familia y salón de clase.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 7), 4,
'Reconoce la importancia del trabajo en equipo para el logro de las metas comunes.');

-- DBA 8: Establece relaciones de convivencia desde el reconocimiento y el respeto de sí mismo y de los demás
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 4, 8,
'Establece relaciones de convivencia desde el reconocimiento y el respeto de sí mismo y de los demás',
'Establece relaciones de convivencia desde el reconocimiento y el respeto de sí mismo y de los demás.');

-- Evidencias para DBA 8
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 8), 1,
'Expresa el valor de sí mismo y de cada uno de los integrantes de la clase, explicando aquello que los diferencia y los identifica: el género, la procedencia, la edad, las ideas y creencias, entre otras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 8), 2,
'Expresa aquello que lo hace igual a los demás en la institución, desde el conocimiento y el respeto a los deberes y derechos establecidos en el Manual de Convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 8), 3,
'Identifica situaciones de maltrato que se dan en su entorno consigo mismo y/o con otras personas y sabe a quiénes acudir para pedir ayuda y protección.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 4 AND numero_dba = 8), 4,
'Participa de acciones que fomentan la sana convivencia en el entorno familiar y escolar.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 2°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 2° grado (id_grado = 5)

-- DBA 1: Se ubica espacialmente en diferentes lugares a partir de la identificación de referentes naturales y construidos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 1, 
'Se ubica espacialmente en diferentes lugares a partir de la identificación de referentes naturales y construidos',
'Se ubica espacialmente en diferentes lugares a partir de la identificación de referentes naturales y construidos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 1), 1,
'Describe las características del espacio geográfico local, los principales puntos de referencia y los lugares significativos para su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 1), 2,
'Dibuja el barrio, la vereda o el entorno donde vive y ubica los lugares que considera importantes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 1), 3,
'Utiliza los puntos cardinales para orientarse y ubicar lugares en su entorno cercano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 1), 4,
'Explica cómo los espacios naturales y construidos son transformados por las personas para su uso y beneficio.');

-- DBA 2: Reconoce los componentes naturales y construidos del paisaje y las formas en que las personas se relacionan con ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 2,
'Reconoce los componentes naturales y construidos del paisaje y las formas en que las personas se relacionan con ellos',
'Reconoce los componentes naturales y construidos del paisaje y las formas en que las personas se relacionan con ellos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 2), 1,
'Identifica elementos naturales (ríos, montañas, valles, árboles, animales) y elementos construidos (vías, casas, puentes, cultivos) del paisaje de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 2), 2,
'Compara diferentes paisajes naturales y construidos a partir de imágenes, descripciones o visitas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 2), 3,
'Explica cómo las personas modifican el entorno para satisfacer sus necesidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 2), 4,
'Propone acciones para cuidar el ambiente y conservar los recursos naturales de su comunidad.');

-- DBA 3: Reconoce las nociones básicas de tiempo y las utiliza para ordenar acontecimientos personales, familiares y sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 3,
'Reconoce las nociones básicas de tiempo y las utiliza para ordenar acontecimientos personales, familiares y sociales',
'Reconoce las nociones básicas de tiempo y las utiliza para ordenar acontecimientos personales, familiares y sociales.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 3), 1,
'Diferencia pasado, presente y futuro en su vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 3), 2,
'Ordena cronológicamente hechos significativos de su vida y de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 3), 3,
'Relata historias personales y familiares en secuencia temporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 3), 4,
'Comprende la duración de eventos utilizando medidas convencionales del tiempo (día, semana, mes, año).');

-- DBA 4: Reconoce los cambios y permanencias en su entorno social y familiar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 4,
'Reconoce los cambios y permanencias en su entorno social y familiar',
'Reconoce los cambios y permanencias en su entorno social y familiar.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica transformaciones en su familia, escuela y comunidad a lo largo del tiempo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 4), 2,
'Compara costumbres, oficios y tradiciones del pasado con las del presente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 4), 3,
'Reconoce elementos de su entorno que se mantienen en el tiempo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 4), 4,
'Explica cómo los cambios sociales afectan la vida cotidiana de las personas.');

-- DBA 5: Reconoce las instituciones sociales, las normas y los acuerdos como elementos que regulan la convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 5,
'Reconoce las instituciones sociales, las normas y los acuerdos como elementos que regulan la convivencia',
'Reconoce las instituciones sociales, las normas y los acuerdos como elementos que regulan la convivencia.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 5), 1,
'Identifica las instituciones presentes en su comunidad (familia, escuela, alcaldía, iglesia, hospital, etc.) y su función.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 5), 2,
'Explica la importancia de las normas para la convivencia en la familia, la escuela y la comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 5), 3,
'Participa en la construcción de acuerdos de convivencia en su grupo escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 5), 4,
'Cumple y promueve el respeto por las normas acordadas en los diferentes contextos.');

-- DBA 6: Comprende la importancia de pertenecer a diferentes grupos sociales y participa activamente en ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 6,
'Comprende la importancia de pertenecer a diferentes grupos sociales y participa activamente en ellos',
'Comprende la importancia de pertenecer a diferentes grupos sociales y participa activamente en ellos.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 6), 1,
'Identifica los grupos a los que pertenece (familia, amigos, escuela, barrio, etc.) y su función.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 6), 2,
'Describe las normas y roles que se establecen en los grupos a los que pertenece.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 6), 3,
'Participa en actividades colectivas que promueven la solidaridad y el trabajo en equipo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 6), 4,
'Explica la importancia del respeto, la cooperación y la responsabilidad dentro de los grupos sociales.');

-- DBA 7: Reconoce la diversidad cultural de su entorno y valora las manifestaciones propias y las de los otros
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 5, 7,
'Reconoce la diversidad cultural de su entorno y valora las manifestaciones propias y las de los otros',
'Reconoce la diversidad cultural de su entorno y valora las manifestaciones propias y las de los otros.');

-- Evidencias para DBA 7
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 7), 1,
'Identifica costumbres, tradiciones, celebraciones y prácticas culturales de su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 7), 2,
'Reconoce la existencia de diferentes grupos culturales en su entorno local o regional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 7), 3,
'Valora las manifestaciones culturales propias y las de otras comunidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 5 AND numero_dba = 7), 4,
'Participa en actividades escolares o comunitarias que promueven el respeto por la diversidad.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 3°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 3° grado (id_grado = 6)

-- DBA 1: Se orienta espacialmente en diferentes lugares a partir de la observación, el uso de puntos de referencia y la lectura de representaciones gráficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 1, 
'Se orienta espacialmente en diferentes lugares a partir de la observación, el uso de puntos de referencia y la lectura de representaciones gráficas',
'Se orienta espacialmente en diferentes lugares a partir de la observación, el uso de puntos de referencia y la lectura de representaciones gráficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 1), 1,
'Describe los elementos naturales y construidos que le permiten ubicarse en su entorno local y regional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 1), 2,
'Utiliza los puntos cardinales y otros referentes espaciales para orientarse en mapas, croquis o planos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 1), 3,
'Interpreta representaciones gráficas sencillas de espacios conocidos (mapas, planos, fotografías aéreas).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 1), 4,
'Explica cómo las personas transforman los espacios naturales en espacios construidos para su beneficio.');

-- DBA 2: Reconoce los diferentes tipos de paisajes y la relación entre sus componentes naturales, sociales y culturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 2,
'Reconoce los diferentes tipos de paisajes y la relación entre sus componentes naturales, sociales y culturales',
'Reconoce los diferentes tipos de paisajes y la relación entre sus componentes naturales, sociales y culturales.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 2), 1,
'Identifica elementos naturales (ríos, montañas, valles, climas, flora y fauna) y sociales (construcciones, cultivos, vías, poblaciones) que conforman los paisajes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 2), 2,
'Compara paisajes rurales y urbanos de su entorno local, regional y nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 2), 3,
'Explica cómo las actividades humanas influyen en los paisajes y sus transformaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 2), 4,
'Propone acciones para conservar y proteger los recursos naturales.');

-- DBA 3: Utiliza las nociones de tiempo histórico para reconocer cambios y continuidades en la vida de las personas, las familias y las comunidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 3,
'Utiliza las nociones de tiempo histórico para reconocer cambios y continuidades en la vida de las personas, las familias y las comunidades',
'Utiliza las nociones de tiempo histórico para reconocer cambios y continuidades en la vida de las personas, las familias y las comunidades.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 3), 1,
'Diferencia pasado, presente y futuro en su vida personal y en la de su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 3), 2,
'Ordena cronológicamente hechos significativos de la historia familiar, local y nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 3), 3,
'Identifica causas y consecuencias de los cambios ocurridos en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 3), 4,
'Reconoce elementos que se mantienen en el tiempo dentro de su comunidad.');

-- DBA 4: Reconoce los grupos sociales, las instituciones y las normas como elementos que regulan la convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 4,
'Reconoce los grupos sociales, las instituciones y las normas como elementos que regulan la convivencia',
'Reconoce los grupos sociales, las instituciones y las normas como elementos que regulan la convivencia.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 4), 1,
'Identifica los grupos e instituciones presentes en su entorno y sus funciones (familia, escuela, gobierno local, etc.).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 4), 2,
'Explica la importancia de las normas y los acuerdos para la convivencia pacífica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 4), 3,
'Participa en la elaboración y cumplimiento de acuerdos en su grupo escolar y comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 4), 4,
'Promueve el respeto, la cooperación y la solidaridad en las relaciones cotidianas.');

-- DBA 5: Reconoce la diversidad cultural y valora las manifestaciones propias y las de los otros grupos sociales de su entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 5,
'Reconoce la diversidad cultural y valora las manifestaciones propias y las de los otros grupos sociales de su entorno',
'Reconoce la diversidad cultural y valora las manifestaciones propias y las de los otros grupos sociales de su entorno.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 5), 1,
'Identifica costumbres, tradiciones, celebraciones y manifestaciones culturales propias de su región y de otras del país.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 5), 2,
'Reconoce la existencia de diferentes grupos étnicos y culturales en Colombia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 5), 3,
'Valora la importancia del respeto por las diferencias culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 5), 4,
'Participa en actividades que promueven la convivencia intercultural.');

-- DBA 6: Comprende que las personas establecen relaciones económicas para satisfacer sus necesidades básicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 6, 6,
'Comprende que las personas establecen relaciones económicas para satisfacer sus necesidades básicas',
'Comprende que las personas establecen relaciones económicas para satisfacer sus necesidades básicas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 6), 1,
'Identifica los bienes y servicios que las personas producen, distribuyen y consumen en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 6), 2,
'Reconoce la importancia del trabajo en la satisfacción de las necesidades humanas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 6), 3,
'Explica las diferencias entre necesidades y deseos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 6 AND numero_dba = 6), 4,
'Participa en actividades escolares que promueven el ahorro, la cooperación y el uso responsable de los recursos.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 4°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 4° grado (id_grado = 7)

-- DBA 1: Se orienta en el espacio local, regional y nacional a partir de la lectura e interpretación de diferentes representaciones geográficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 1, 
'Se orienta en el espacio local, regional y nacional a partir de la lectura e interpretación de diferentes representaciones geográficas',
'Se orienta en el espacio local, regional y nacional a partir de la lectura e interpretación de diferentes representaciones geográficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 1), 1,
'Identifica los elementos naturales y construidos que conforman su entorno local, regional y nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 1), 2,
'Utiliza mapas, planos y croquis para ubicar lugares, regiones y límites.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 1), 3,
'Emplea los puntos cardinales, la escala y los símbolos convencionales en la lectura de mapas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 1), 4,
'Explica cómo las actividades humanas transforman los espacios geográficos.');

-- DBA 2: Reconoce las características de los paisajes naturales y culturales de Colombia y las relaciones entre ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 2,
'Reconoce las características de los paisajes naturales y culturales de Colombia y las relaciones entre ellos',
'Reconoce las características de los paisajes naturales y culturales de Colombia y las relaciones entre ellos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 2), 1,
'Identifica los principales tipos de paisajes naturales del país (montañas, llanuras, selvas, costas, desiertos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 2), 2,
'Describe las características de los paisajes rurales y urbanos de su región.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 2), 3,
'Analiza cómo las condiciones naturales influyen en las formas de vida y las actividades económicas de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 2), 4,
'Propone acciones para conservar y proteger los recursos naturales y culturales del país.');

-- DBA 3: Comprende el tiempo histórico como construcción social que permite reconocer cambios y permanencias en la vida de las personas y las comunidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 3,
'Comprende el tiempo histórico como construcción social que permite reconocer cambios y permanencias en la vida de las personas y las comunidades',
'Comprende el tiempo histórico como una construcción social que permite reconocer cambios y permanencias en la vida de las personas y las comunidades.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 3), 1,
'Distingue pasado, presente y futuro en los procesos históricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 3), 2,
'Ordena cronológicamente hechos relevantes de la historia local, regional y nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 3), 3,
'Reconoce causas y consecuencias de los cambios ocurridos en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 3), 4,
'Identifica elementos que se han mantenido a lo largo del tiempo en su comunidad y en el país.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en los diferentes contextos sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en los diferentes contextos sociales',
'Reconoce las instituciones, normas y valores que regulan la convivencia en los diferentes contextos sociales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 4), 1,
'Identifica las principales instituciones sociales y políticas presentes en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 4), 2,
'Explica la función de las normas y los valores en la convivencia familiar, escolar y comunitaria.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 4), 3,
'Participa en la elaboración y cumplimiento de acuerdos para la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 4), 4,
'Promueve el respeto, la responsabilidad y la solidaridad en las relaciones sociales.');

-- DBA 5: Reconoce la diversidad cultural del país y valora las manifestaciones propias y las de otros grupos sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 5,
'Reconoce la diversidad cultural del país y valora las manifestaciones propias y las de otros grupos sociales',
'Reconoce la diversidad cultural del país y valora las manifestaciones propias y las de otros grupos sociales.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 5), 1,
'Identifica las costumbres, tradiciones, lenguas y expresiones culturales de los diferentes grupos étnicos y regiones del país.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 5), 2,
'Explica la importancia del respeto y la valoración de la diversidad cultural como elemento de identidad nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 5), 3,
'Participa en actividades escolares y comunitarias que promueven la interculturalidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 5), 4,
'Reconoce la influencia de las diferentes culturas en la conformación de la sociedad colombiana.');

-- DBA 6: Comprende la relación entre las actividades económicas y el uso de los recursos naturales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 7, 6,
'Comprende la relación entre las actividades económicas y el uso de los recursos naturales',
'Comprende la relación entre las actividades económicas y el uso de los recursos naturales.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 6), 1,
'Identifica los principales recursos naturales de su región y del país.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 6), 2,
'Reconoce las actividades económicas predominantes en su entorno local y regional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 6), 3,
'Explica cómo el uso inadecuado de los recursos naturales genera problemas ambientales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 7 AND numero_dba = 6), 4,
'Propone acciones para el uso responsable y sostenible de los recursos.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 5°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 5° grado (id_grado = 8)

-- DBA 1: Se orienta espacialmente en el territorio nacional y en el continente americano mediante la lectura e interpretación de diferentes representaciones geográficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 1, 
'Se orienta espacialmente en el territorio nacional y en el continente americano mediante la lectura e interpretación de diferentes representaciones geográficas',
'Se orienta espacialmente en el territorio nacional y en el continente americano mediante la lectura e interpretación de diferentes representaciones geográficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica los elementos naturales y construidos del territorio colombiano y americano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 1), 2,
'Localiza en mapas políticos y físicos los límites, regiones, países y capitales del continente americano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 1), 3,
'Interpreta mapas utilizando escalas, coordenadas y símbolos convencionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 1), 4,
'Explica cómo las actividades humanas influyen en la transformación del espacio geográfico.');

-- DBA 2: Reconoce las características de los paisajes naturales y culturales del continente americano y las relaciones que existen entre ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 2,
'Reconoce las características de los paisajes naturales y culturales del continente americano y las relaciones que existen entre ellos',
'Reconoce las características de los paisajes naturales y culturales del continente americano y las relaciones que existen entre ellos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 2), 1,
'Identifica los principales tipos de paisajes naturales y culturales del continente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 2), 2,
'Compara las características físicas, climáticas y culturales de diferentes regiones de América.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 2), 3,
'Explica cómo los factores naturales influyen en las formas de vida y en las actividades económicas de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 2), 4,
'Propone acciones para conservar los recursos naturales y valorar la diversidad cultural del continente.');

-- DBA 3: Comprende el tiempo histórico como construcción social que permite reconocer los procesos de cambio y permanencia en la historia de Colombia y de América
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 3,
'Comprende el tiempo histórico como construcción social que permite reconocer los procesos de cambio y permanencia en la historia de Colombia y de América',
'Comprende el tiempo histórico como una construcción social que permite reconocer los procesos de cambio y permanencia en la historia de Colombia y de América.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 3), 1,
'Diferencia pasado, presente y futuro en los procesos históricos nacionales y continentales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 3), 2,
'Ordena cronológicamente hechos relevantes de la historia de Colombia y América.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 3), 3,
'Reconoce las causas y consecuencias de los principales procesos históricos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 3), 4,
'Identifica elementos que se han mantenido a lo largo del tiempo en la vida social y cultural.');

-- DBA 4: Reconoce la importancia de las instituciones, normas y valores democráticos en la organización política y en la convivencia social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 4,
'Reconoce la importancia de las instituciones, normas y valores democráticos en la organización política y en la convivencia social',
'Reconoce la importancia de las instituciones, normas y valores democráticos en la organización política y en la convivencia social.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 4), 1,
'Identifica las principales instituciones del Estado colombiano y sus funciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 4), 2,
'Explica la importancia de las normas y los valores democráticos en la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 4), 3,
'Participa en la elaboración y cumplimiento de acuerdos para la convivencia y la participación ciudadana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 4), 4,
'Valora el respeto, la responsabilidad y la solidaridad como principios fundamentales de la democracia.');

-- DBA 5: Reconoce la diversidad cultural de América y valora las manifestaciones propias y las de los otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 5,
'Reconoce la diversidad cultural de América y valora las manifestaciones propias y las de los otros pueblos',
'Reconoce la diversidad cultural de América y valora las manifestaciones propias y las de los otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 5), 1,
'Identifica las costumbres, tradiciones y expresiones culturales de los pueblos americanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 5), 2,
'Explica la importancia del respeto y la valoración de la diversidad cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 5), 3,
'Participa en actividades que promueven la convivencia intercultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 5), 4,
'Reconoce la influencia de los diferentes pueblos en la construcción de las identidades americanas.');

-- DBA 6: Comprende la relación entre las actividades económicas, el uso de los recursos naturales y el desarrollo sostenible
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 8, 6,
'Comprende la relación entre las actividades económicas, el uso de los recursos naturales y el desarrollo sostenible',
'Comprende la relación entre las actividades económicas, el uso de los recursos naturales y el desarrollo sostenible.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 6), 1,
'Identifica las principales actividades económicas de su región, del país y del continente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 6), 2,
'Explica cómo el uso de los recursos naturales se relaciona con el desarrollo económico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 6), 3,
'Reconoce las consecuencias del uso inadecuado de los recursos sobre el ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 8 AND numero_dba = 6), 4,
'Propone acciones para el aprovechamiento responsable de los recursos naturales.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 6°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 6° grado (id_grado = 9)

-- DBA 1: Se orienta en el espacio local, regional, nacional y continental a partir de la lectura e interpretación de representaciones geográficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 1, 
'Se orienta en el espacio local, regional, nacional y continental a partir de la lectura e interpretación de representaciones geográficas',
'Se orienta en el espacio local, regional, nacional y continental a partir de la lectura e interpretación de representaciones geográficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica los elementos naturales y construidos de los diferentes espacios geográficos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 1), 2,
'Utiliza mapas físicos y políticos para ubicar regiones, países, ríos, montañas y océanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 1), 3,
'Emplea las coordenadas geográficas, la escala y los símbolos cartográficos en la lectura de mapas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 1), 4,
'Explica cómo las características naturales del territorio influyen en la organización social y económica.');

-- DBA 2: Reconoce las características de los paisajes naturales y culturales del mundo antiguo y las relaciones entre ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 2,
'Reconoce las características de los paisajes naturales y culturales del mundo antiguo y las relaciones entre ellos',
'Reconoce las características de los paisajes naturales y culturales del mundo antiguo y las relaciones entre ellos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 2), 1,
'Describe los principales paisajes naturales donde se desarrollaron las primeras civilizaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 2), 2,
'Explica cómo las condiciones geográficas influyeron en el surgimiento y desarrollo de las civilizaciones antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 2), 3,
'Identifica las transformaciones del paisaje ocasionadas por la acción humana en diferentes épocas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 2), 4,
'Valora la importancia de conservar el patrimonio natural y cultural heredado de las civilizaciones antiguas.');

-- DBA 3: Comprende el tiempo histórico como construcción social que permite reconocer los procesos de cambio y permanencia en la historia de las civilizaciones antiguas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 3,
'Comprende el tiempo histórico como construcción social que permite reconocer los procesos de cambio y permanencia en la historia de las civilizaciones antiguas',
'Comprende el tiempo histórico como una construcción social que permite reconocer los procesos de cambio y permanencia en la historia de las civilizaciones antiguas.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 3), 1,
'Distingue los diferentes periodos de la historia y sus características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 3), 2,
'Ordena cronológicamente hechos y procesos relevantes de la antigüedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 3), 3,
'Reconoce las causas y consecuencias de los principales acontecimientos históricos de las civilizaciones antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 3), 4,
'Identifica elementos culturales, políticos, sociales y económicos que se mantienen en el tiempo.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades antiguas y actuales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades antiguas y actuales',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades antiguas y actuales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 4), 1,
'Identifica las instituciones políticas, sociales y religiosas de las civilizaciones antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 4), 2,
'Compara las formas de organización social y política del pasado con las del presente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 4), 3,
'Explica la importancia de las normas y los valores en la regulación de la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 4), 4,
'Promueve la convivencia basada en el respeto, la justicia y la responsabilidad.');

-- DBA 5: Reconoce la diversidad cultural del mundo antiguo y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 5,
'Reconoce la diversidad cultural del mundo antiguo y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo antiguo y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 5), 1,
'Identifica las principales expresiones culturales y artísticas de las civilizaciones antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 5), 2,
'Explica cómo el intercambio cultural contribuyó al desarrollo de las sociedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 5), 3,
'Valora la herencia cultural de los pueblos antiguos en la vida actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 5), 4,
'Promueve el respeto por la diversidad cultural y las diferencias entre los pueblos.');

-- DBA 6: Comprende la relación entre las actividades económicas y el aprovechamiento de los recursos naturales en las civilizaciones antiguas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 9, 6,
'Comprende la relación entre las actividades económicas y el aprovechamiento de los recursos naturales en las civilizaciones antiguas',
'Comprende la relación entre las actividades económicas y el aprovechamiento de los recursos naturales en las civilizaciones antiguas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 6), 1,
'Identifica las principales actividades económicas desarrolladas en las civilizaciones antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 6), 2,
'Explica cómo las condiciones naturales influyeron en la economía de las sociedades antiguas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 6), 3,
'Reconoce las consecuencias del uso intensivo de los recursos sobre el ambiente y la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 9 AND numero_dba = 6), 4,
'Propone acciones para el uso responsable de los recursos naturales en el contexto actual.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 7°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 7° grado (id_grado = 10)

-- DBA 1: Se orienta en el espacio geográfico mundial mediante la lectura e interpretación de diferentes representaciones cartográficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 1,
'Se orienta en el espacio geográfico mundial mediante la lectura e interpretación de diferentes representaciones cartográficas',
'Se orienta en el espacio geográfico mundial mediante la lectura e interpretación de diferentes representaciones cartográficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica los continentes, océanos, países y regiones del planeta en diferentes tipos de mapas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 1), 2,
'Utiliza coordenadas geográficas, escalas y símbolos convencionales en la lectura e interpretación de mapas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 1), 3,
'Explica cómo las características físicas del planeta influyen en las formas de vida y en la distribución de la población.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 1), 4,
'Analiza los efectos de la acción humana en la transformación del espacio geográfico mundial.');

-- DBA 2: Reconoce las características físicas, sociales, políticas y culturales de los continentes y las relaciones que existen entre ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 2,
'Reconoce las características físicas, sociales, políticas y culturales de los continentes y las relaciones que existen entre ellos',
'Reconoce las características físicas, sociales, políticas y culturales de los continentes y las relaciones que existen entre ellos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 2), 1,
'Describe las principales características naturales y humanas de los continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 2), 2,
'Compara las condiciones geográficas, económicas y culturales entre distintas regiones del mundo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 2), 3,
'Explica cómo las relaciones comerciales, tecnológicas y culturales generan interdependencia entre los países.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 2), 4,
'Valora la importancia de la cooperación y el respeto entre las naciones del mundo.');

-- DBA 3: Comprende los procesos de cambio y continuidad que caracterizan la Edad Media y la Edad Moderna en Europa y América
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 3,
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Media y la Edad Moderna en Europa y América',
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Media y la Edad Moderna en Europa y América.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 3), 1,
'Identifica los principales hechos y procesos de la Edad Media y la Edad Moderna.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 3), 2,
'Explica las causas y consecuencias de transformaciones como el feudalismo, el renacimiento y la expansión europea.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 3), 3,
'Analiza los contactos culturales y sus efectos entre Europa, África y América a partir del siglo XV.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 3), 4,
'Reconoce los aportes de estas épocas a la configuración del mundo actual.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades medievales y modernas, y las compara con las actuales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades medievales y modernas, y las compara con las actuales',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades medievales y modernas, y las compara con las actuales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 4), 1,
'Identifica las instituciones políticas, sociales y religiosas de las sociedades medievales y modernas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 4), 2,
'Compara las formas de gobierno y organización social de esas épocas con las actuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 4), 3,
'Explica la importancia de las normas y valores en la regulación de la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 4), 4,
'Promueve la convivencia basada en el respeto, la justicia y la responsabilidad.');

-- DBA 5: Reconoce la diversidad cultural del mundo medieval y moderno y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 5,
'Reconoce la diversidad cultural del mundo medieval y moderno y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo medieval y moderno y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 5), 1,
'Identifica expresiones culturales, artísticas y científicas del mundo medieval y moderno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 5), 2,
'Explica cómo los intercambios culturales transformaron las sociedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 5), 3,
'Valora los aportes de diferentes culturas a la humanidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 5), 4,
'Promueve el respeto por la diversidad cultural y religiosa.');

-- DBA 6: Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo de las sociedades medievales y modernas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 10, 6,
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo de las sociedades medievales y modernas',
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo de las sociedades medievales y modernas.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 6), 1,
'Identifica las principales actividades económicas en la Edad Media y la Edad Moderna.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 6), 2,
'Explica cómo el comercio, la agricultura y la industria transformaron las relaciones sociales y políticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 6), 3,
'Analiza las consecuencias de la expansión europea sobre las economías y poblaciones americanas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 10 AND numero_dba = 6), 4,
'Propone acciones para un desarrollo económico sostenible y equitativo en el contexto actual.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 8°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 8° grado (id_grado = 11)

-- DBA 1: Se orienta en el espacio geográfico mundial a partir del análisis de representaciones cartográficas, estadísticas y gráficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 1,
'Se orienta en el espacio geográfico mundial a partir del análisis de representaciones cartográficas, estadísticas y gráficas',
'Se orienta en el espacio geográfico mundial a partir del análisis de representaciones cartográficas, estadísticas y gráficas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 1), 1,
'Localiza los continentes, océanos, países y regiones en diferentes representaciones del planeta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 1), 2,
'Interpreta mapas, gráficos y estadísticas sobre población, recursos naturales y actividades económicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 1), 3,
'Explica cómo los factores naturales y humanos influyen en la organización del espacio mundial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 1), 4,
'Analiza las transformaciones del territorio ocasionadas por el desarrollo urbano, industrial y tecnológico.');

-- DBA 2: Reconoce las características físicas, sociales, políticas, económicas y culturales de los continentes y las relaciones entre ellos en la actualidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 2,
'Reconoce las características físicas, sociales, políticas, económicas y culturales de los continentes y las relaciones entre ellos en la actualidad',
'Reconoce las características físicas, sociales, políticas, económicas y culturales de los continentes y las relaciones entre ellos en la actualidad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 2), 1,
'Describe los principales rasgos geográficos, demográficos y culturales de los continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 2), 2,
'Compara las condiciones naturales, económicas y sociales de diferentes regiones del mundo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 2), 3,
'Explica las relaciones económicas, tecnológicas y culturales entre los países.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 2), 4,
'Valora la importancia de la cooperación internacional y la interdependencia global.');

-- DBA 3: Comprende los procesos de cambio y continuidad que caracterizan la Edad Moderna y la Edad Contemporánea en Europa y América
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 3,
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Moderna y la Edad Contemporánea en Europa y América',
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Moderna y la Edad Contemporánea en Europa y América.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 3), 1,
'Identifica los principales hechos históricos que marcan la transición de la Edad Moderna a la Edad Contemporánea.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 3), 2,
'Explica las causas y consecuencias de procesos como la Ilustración, las revoluciones políticas y la independencia de América.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 3), 3,
'Analiza el impacto de las transformaciones económicas, sociales y culturales de los siglos XVIII y XIX.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 3), 4,
'Reconoce la influencia de estos procesos en la configuración del mundo actual.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades modernas y contemporáneas, y las compara con las actuales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades modernas y contemporáneas, y las compara con las actuales',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades modernas y contemporáneas, y las compara con las actuales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 4), 1,
'Identifica las instituciones políticas, sociales y económicas de las sociedades modernas y contemporáneas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 4), 2,
'Compara las formas de organización política y social del pasado con las actuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 4), 3,
'Explica la importancia de los valores democráticos y de los derechos humanos en la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 4), 4,
'Promueve la convivencia basada en el respeto, la justicia y la participación ciudadana.');

-- DBA 5: Reconoce la diversidad cultural del mundo moderno y contemporáneo, y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 5,
'Reconoce la diversidad cultural del mundo moderno y contemporáneo, y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo moderno y contemporáneo, y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 5), 1,
'Identifica las expresiones culturales, artísticas, científicas y tecnológicas de los siglos XVIII al XXI.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 5), 2,
'Explica cómo los procesos históricos han transformado las identidades culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 5), 3,
'Valora los aportes de las diferentes culturas al desarrollo de la humanidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 5), 4,
'Promueve el respeto por la diversidad cultural y la igualdad entre los pueblos.');

-- DBA 6: Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 11, 6,
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual',
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 6), 1,
'Identifica las principales actividades económicas a nivel mundial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 6), 2,
'Explica cómo la globalización y el uso de los recursos naturales afectan el desarrollo sostenible.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 6), 3,
'Analiza las consecuencias sociales y ambientales del modelo económico actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 11 AND numero_dba = 6), 4,
'Propone acciones para el aprovechamiento responsable de los recursos y la equidad social.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 9°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 9° grado (id_grado = 12)

-- DBA 1: Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 1,
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas',
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 1), 1,
'Localiza los principales continentes, océanos, países y regiones en mapas y sistemas de información geográfica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 1), 2,
'Interpreta mapas temáticos, gráficos y estadísticas sobre población, economía y medio ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 1), 3,
'Explica las relaciones entre factores naturales, sociales y económicos en la organización del espacio mundial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 1), 4,
'Analiza los efectos de la globalización en la transformación del territorio y en la interdependencia entre las naciones.');

-- DBA 2: Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre los países
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 2,
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre los países',
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre los países.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 2), 1,
'Describe las principales características geográficas, demográficas y culturales de los continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 2), 2,
'Compara los niveles de desarrollo y las condiciones de vida entre distintas regiones del mundo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 2), 3,
'Explica las causas y consecuencias de los procesos de globalización, migración y desigualdad económica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 2), 4,
'Valora la importancia de la cooperación internacional y el respeto por los derechos humanos.');

-- DBA 3: Comprende los procesos de cambio y continuidad que caracterizan la Edad Contemporánea desde el siglo XIX hasta la actualidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 3,
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Contemporánea desde el siglo XIX hasta la actualidad',
'Comprende los procesos de cambio y continuidad que caracterizan la Edad Contemporánea desde el siglo XIX hasta la actualidad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 3), 1,
'Identifica los principales hechos y procesos históricos del siglo XIX al XXI.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 3), 2,
'Explica las causas y consecuencias de las revoluciones industriales, las guerras mundiales y los movimientos sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 3), 3,
'Analiza los cambios políticos, económicos y culturales generados por estos procesos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 3), 4,
'Reconoce la influencia de la historia contemporánea en la configuración del mundo actual.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y las compara con las del pasado
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y las compara con las del pasado',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y las compara con las del pasado.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 4), 1,
'Identifica las instituciones políticas, sociales y económicas del mundo contemporáneo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 4), 2,
'Explica la importancia de los valores democráticos, los derechos humanos y la participación ciudadana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 4), 3,
'Compara las formas de gobierno y los sistemas políticos en diferentes países.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 4), 4,
'Promueve la convivencia basada en el respeto, la justicia, la equidad y la solidaridad.');

-- DBA 5: Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 5,
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 5), 1,
'Identifica las principales manifestaciones culturales y artísticas contemporáneas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 5), 2,
'Explica cómo los procesos de comunicación y globalización influyen en las culturas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 5), 3,
'Valora la diversidad cultural como elemento de identidad y enriquecimiento social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 5), 4,
'Promueve el respeto y la tolerancia hacia las diferentes formas de vida y pensamiento.');

-- DBA 6: Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 12, 6,
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo',
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 6), 1,
'Identifica los principales sectores económicos y su impacto en el ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 6), 2,
'Explica cómo la economía global influye en la distribución de los recursos naturales y el bienestar social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 6), 3,
'Analiza las problemáticas ambientales derivadas del modelo económico actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 12 AND numero_dba = 6), 4,
'Propone alternativas de desarrollo sostenible y equitativo en su entorno.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 10°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 10° grado (id_grado = 13)

-- DBA 1: Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 1,
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas',
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 1), 1,
'Localiza los continentes, océanos, países, regiones y ciudades principales en diferentes tipos de mapas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 1), 2,
'Interpreta mapas temáticos, climáticos, económicos y demográficos del mundo contemporáneo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 1), 3,
'Explica las relaciones entre los factores naturales y humanos en la organización del espacio geográfico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 1), 4,
'Analiza los efectos de la globalización sobre el territorio y los recursos naturales.');

-- DBA 2: Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo actual y las relaciones entre las naciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 2,
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo actual y las relaciones entre las naciones',
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo actual y las relaciones entre las naciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 2), 1,
'Describe las principales características geográficas, demográficas y culturales de los continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 2), 2,
'Compara las condiciones económicas y sociales de los países desarrollados y en desarrollo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 2), 3,
'Explica las causas y consecuencias de los procesos de integración y cooperación internacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 2), 4,
'Valora la importancia del respeto a los derechos humanos y de la paz entre las naciones.');

-- DBA 3: Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea, desde el siglo XIX hasta el siglo XXI
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 3,
'Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea, desde el siglo XIX hasta el siglo XXI',
'Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea, desde el siglo XIX hasta el siglo XXI.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 3), 1,
'Identifica los hechos y procesos históricos que marcaron la historia contemporánea mundial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 3), 2,
'Explica las causas y consecuencias de los movimientos políticos, sociales y económicos del siglo XIX al XXI.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 3), 3,
'Analiza los cambios generados por las revoluciones industriales, las guerras mundiales y los procesos de independencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 3), 4,
'Reconoce la influencia de estos procesos en la configuración de las sociedades actuales.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 4), 1,
'Identifica las instituciones políticas, sociales y económicas que rigen la vida en las sociedades modernas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 4), 2,
'Explica la importancia de los valores democráticos, los derechos humanos y la participación ciudadana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 4), 3,
'Compara diferentes sistemas políticos y económicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 4), 4,
'Promueve la convivencia basada en el respeto, la equidad, la justicia y la solidaridad.');

-- DBA 5: Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 5,
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 5), 1,
'Identifica las principales manifestaciones culturales, artísticas y tecnológicas contemporáneas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 5), 2,
'Explica cómo los procesos de globalización influyen en las identidades culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 5), 3,
'Valora la diversidad cultural como fuente de aprendizaje y enriquecimiento social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 5), 4,
'Promueve el respeto, la tolerancia y la equidad entre las diferentes culturas.');

-- DBA 6: Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 13, 6,
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual',
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo actual.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 6), 1,
'Identifica los principales sectores económicos y su relación con el uso de los recursos naturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 6), 2,
'Explica las consecuencias ambientales, sociales y económicas del modelo de desarrollo actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 6), 3,
'Analiza la distribución desigual de los recursos y la riqueza entre las naciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 13 AND numero_dba = 6), 4,
'Propone alternativas de desarrollo sostenible basadas en la equidad y la responsabilidad ambiental.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS SOCIALES GRADO 11°
-- =============================================

-- Ciencias Sociales (id_asignatura = 3) y 11° grado (id_grado = 14)

-- DBA 1: Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 1,
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas',
'Se orienta en el espacio geográfico mundial mediante el análisis de representaciones cartográficas, estadísticas y tecnológicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 1), 1,
'Localiza los principales continentes, océanos, países y regiones del planeta en mapas, gráficos y sistemas de información geográfica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 1), 2,
'Interpreta mapas temáticos, climáticos, económicos y políticos del mundo actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 1), 3,
'Explica las relaciones entre factores naturales, sociales y económicos en la organización del territorio mundial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 1), 4,
'Analiza las transformaciones del espacio geográfico generadas por la globalización y el desarrollo tecnológico.');

-- DBA 2: Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre las naciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 2,
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre las naciones',
'Reconoce las características físicas, sociales, políticas, económicas y culturales del mundo contemporáneo y las relaciones entre las naciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 2), 1,
'Describe los principales rasgos geográficos, demográficos, económicos y culturales de los continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 2), 2,
'Compara los niveles de desarrollo entre países y regiones del mundo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 2), 3,
'Explica los procesos de integración, cooperación y conflicto entre las naciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 2), 4,
'Valora la importancia del respeto a los derechos humanos y la paz como principios universales.');

-- DBA 3: Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea y su influencia en la configuración del mundo actual
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 3,
'Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea y su influencia en la configuración del mundo actual',
'Comprende los procesos de cambio y continuidad que caracterizan la historia contemporánea y su influencia en la configuración del mundo actual.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 3), 1,
'Identifica los hechos y procesos históricos que marcaron el siglo XX y XXI.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 3), 2,
'Explica las causas y consecuencias de los conflictos bélicos, los movimientos sociales y las transformaciones políticas recientes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 3), 3,
'Analiza los cambios generados por la globalización, el desarrollo científico y tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 3), 4,
'Reconoce la incidencia de los procesos históricos en la sociedad colombiana y mundial actual.');

-- DBA 4: Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y promueven la democracia y los derechos humanos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 4,
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y promueven la democracia y los derechos humanos',
'Reconoce las instituciones, normas y valores que regulan la convivencia en las sociedades contemporáneas y promueven la democracia y los derechos humanos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 4), 1,
'Identifica las principales instituciones políticas y sociales que sustentan el Estado democrático.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 4), 2,
'Explica el papel de la Constitución, las leyes y los organismos internacionales en la defensa de los derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 4), 3,
'Analiza problemáticas relacionadas con la justicia, la equidad y la participación ciudadana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 4), 4,
'Promueve la convivencia democrática basada en el respeto, la tolerancia y la responsabilidad social.');

-- DBA 5: Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 5,
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos',
'Reconoce la diversidad cultural del mundo contemporáneo y valora las manifestaciones propias y las de otros pueblos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 5), 1,
'Identifica las principales manifestaciones culturales, artísticas y tecnológicas del mundo actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 5), 2,
'Explica cómo los procesos de comunicación global influyen en las identidades culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 5), 3,
'Valora la diversidad cultural como fundamento de la convivencia y el diálogo intercultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 5), 4,
'Promueve el respeto por las diferencias culturales, étnicas y religiosas.');

-- DBA 6: Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(3, 14, 6,
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo',
'Comprende las relaciones entre las actividades económicas, los recursos naturales y el desarrollo sostenible en el mundo contemporáneo.');

-- Evidencias para DBA 6
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 6), 1,
'Identifica los sectores económicos y sus implicaciones en el uso de los recursos naturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 6), 2,
'Explica los impactos del modelo de desarrollo actual sobre el ambiente y la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 6), 3,
'Analiza las desigualdades económicas y sociales derivadas de la globalización.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 3 AND id_grado = 14 AND numero_dba = 6), 4,
'Propone estrategias de desarrollo sostenible que promuevan la equidad y la preservación ambiental.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 1°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 1° grado (id_grado = 4)

-- DBA 1: Comprende que los sentidos le permiten percibir algunas características de los objetos que nos rodean
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 4, 1,
'Comprende que los sentidos le permiten percibir algunas características de los objetos que nos rodean',
'Comprende que los sentidos le permiten percibir algunas características de los objetos que nos rodean (temperatura, sabor, sonidos, olor, color, texturas y formas).');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 1), 1,
'Describe y caracteriza, utilizando el sentido apropiado, sonidos, sabores, olores, colores, texturas y formas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 1), 2,
'Compara y describe cambios en las temperaturas (más caliente, similar, menos caliente) utilizando el tacto en diversos objetos (con diferente color) sometidos a fuentes de calor como el sol.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 1), 3,
'Describe y caracteriza, utilizando la vista, diferentes tipos de luz (color, intensidad y fuente).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 1), 4,
'Usa instrumentos como la lupa para realizar observaciones de objetos pequeños y representarlos mediante dibujos.');

-- DBA 2: Comprende que existe una gran variedad de materiales y que éstos se utilizan para distintos fines, según sus características
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 4, 2,
'Comprende que existe una gran variedad de materiales y que éstos se utilizan para distintos fines, según sus características',
'Comprende que existe una gran variedad de materiales y que éstos se utilizan para distintos fines, según sus características (longitud, dureza, flexibilidad, permeabilidad al agua, solubilidad, ductilidad, maleabilidad, color, sabor, textura).');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 2), 1,
'Clasifica materiales de uso cotidiano a partir de características que percibe con los sentidos, incluyendo materiales sólidos como madera, plástico, vidrio, metal, roca y líquidos como opacos, incoloros, transparentes, así como algunas propiedades (flexibilidad, dureza, permeabilidad al agua, color, sabor y textura).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 2), 2,
'Predice cuáles podrían ser los posibles usos de un material (por ejemplo, la goma), de acuerdo con sus características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 2), 3,
'Selecciona qué materiales utilizaría para fabricar un objeto dada cierta necesidad (por ejemplo, un paraguas que evite el paso del agua).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 2), 4,
'Utiliza instrumentos no convencionales (sus manos, palos, cuerdas, vasos, jarras) para medir y clasificar materiales según su tamaño.');

-- DBA 3: Comprende que los seres vivos (plantas y animales) tienen características comunes y los diferencia de los objetos inertes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 4, 3,
'Comprende que los seres vivos (plantas y animales) tienen características comunes y los diferencia de los objetos inertes',
'Comprende que los seres vivos (plantas y animales) tienen características comunes (se alimentan, respiran, tienen un ciclo de vida, responden al entorno) y los diferencia de los objetos inertes.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 3), 1,
'Clasifica seres vivos (plantas y animales) de su entorno, según sus características observables (tamaño, cubierta corporal, cantidad y tipo de miembros, forma de raíz, tallo, hojas, flores y frutos) y los diferencia de los objetos inertes, a partir de criterios que tienen que ver con las características básicas de los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 3), 2,
'Compara características y partes de plantas y animales, utilizando instrumentos simples como la lupa para realizar observaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 3), 3,
'Describe las partes de las plantas (raíz, tallo, hojas, flores y frutos), así como las de animales de su entorno, según características observables (tamaño, cubierta corporal, cantidad y tipo de miembros).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 3), 4,
'Propone acciones de cuidado a plantas y animales, teniendo en cuenta características como tipo de alimentación, ciclos de vida y relación con el entorno.');

-- DBA 4: Comprende que su cuerpo experimenta constantes cambios a lo largo del tiempo y reconoce características similares y diferentes a las de sus padres y compañeros
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 4, 4,
'Comprende que su cuerpo experimenta constantes cambios a lo largo del tiempo y reconoce características similares y diferentes a las de sus padres y compañeros',
'Comprende que su cuerpo experimenta constantes cambios a lo largo del tiempo y reconoce a partir de su comparación que tiene características similares y diferentes a las de sus padres y compañeros.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 4), 1,
'Registra cambios físicos ocurridos en su cuerpo durante el crecimiento, tales como peso, talla, longitud de brazos, piernas, pies y manos, así como algunas características que no varían como el color de ojos, piel y cabello.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 4), 2,
'Describe su cuerpo y predice los cambios que se producirán en un futuro, a partir de los ejercicios de comparación que realiza entre un niño y un adulto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 4), 3,
'Describe y registra similitudes y diferencias físicas que observa entre niños y niñas de su grado, reconociéndose y reconociendo al otro.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 4 AND numero_dba = 4), 4,
'Establece relaciones hereditarias a partir de las características físicas de sus padres, describiendo diferencias y similitudes.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 2°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 2° grado (id_grado = 5)

-- DBA 1: Comprende que los sentidos le permiten percibir y describir las características de los objetos y materiales que lo rodean y los cambios que se presentan en ellos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 5, 1,
'Comprende que los sentidos le permiten percibir y describir las características de los objetos y materiales que lo rodean y los cambios que se presentan en ellos',
'Comprende que los sentidos le permiten percibir y describir las características de los objetos y materiales que lo rodean y los cambios que se presentan en ellos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 1), 1,
'Describe las características (color, textura, sabor, olor, temperatura, forma, tamaño) de los objetos y materiales de su entorno, utilizando los sentidos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 1), 2,
'Compara materiales y objetos según sus características observables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 1), 3,
'Identifica cambios en los materiales y objetos de su entorno cuando se calientan, enfrían, mezclan o disuelven.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 1), 4,
'Clasifica los materiales según los cambios que presentan (reversibles o irreversibles).');

-- DBA 2: Comprende que los seres vivos se relacionan entre sí y con el entorno para satisfacer sus necesidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 5, 2,
'Comprende que los seres vivos se relacionan entre sí y con el entorno para satisfacer sus necesidades',
'Comprende que los seres vivos se relacionan entre sí y con el entorno para satisfacer sus necesidades.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 2), 1,
'Reconoce las relaciones entre los seres vivos (alimentación, refugio, protección, reproducción).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 2), 2,
'Describe cómo las plantas, los animales y las personas dependen del entorno para vivir.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 2), 3,
'Identifica los elementos del entorno natural que permiten la vida (aire, agua, suelo, luz, temperatura).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 2), 4,
'Propone acciones para cuidar y conservar los recursos naturales.');

-- DBA 3: Reconoce las partes del cuerpo humano, sus funciones y su relación con el cuidado de la salud
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 5, 3,
'Reconoce las partes del cuerpo humano, sus funciones y su relación con el cuidado de la salud',
'Reconoce las partes del cuerpo humano, sus funciones y su relación con el cuidado de la salud.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 3), 1,
'Identifica y nombra las principales partes del cuerpo humano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 3), 2,
'Explica la función de los órganos de los sistemas digestivo, respiratorio, circulatorio, óseo y muscular.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 3), 3,
'Relaciona hábitos de higiene, alimentación y ejercicio con el cuidado del cuerpo y la prevención de enfermedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 3), 4,
'Propone acciones para mantener su cuerpo sano y prevenir accidentes.');

-- DBA 4: Comprende que los seres vivos tienen ciclos de vida y que las plantas y los animales presentan etapas de desarrollo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 5, 4,
'Comprende que los seres vivos tienen ciclos de vida y que las plantas y los animales presentan etapas de desarrollo',
'Comprende que los seres vivos tienen ciclos de vida y que las plantas y los animales presentan etapas de desarrollo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica las etapas del ciclo de vida de diferentes seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 4), 2,
'Compara el ciclo de vida de plantas, animales y personas, reconociendo semejanzas y diferencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 4), 3,
'Describe los cambios que experimentan los seres vivos durante su desarrollo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 4), 4,
'Explica la importancia del cuidado de los seres vivos durante sus distintas etapas de vida.');

-- DBA 5: Reconoce la importancia del agua, el aire y el suelo como recursos naturales fundamentales para la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 5, 5,
'Reconoce la importancia del agua, el aire y el suelo como recursos naturales fundamentales para la vida',
'Reconoce la importancia del agua, el aire y el suelo como recursos naturales fundamentales para la vida.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 5), 1,
'Identifica la presencia del agua, el aire y el suelo en su entorno y sus principales usos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 5), 2,
'Explica la importancia del agua, el aire y el suelo para la vida de plantas, animales y personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 5), 3,
'Describe algunas causas de contaminación del agua, el aire y el suelo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 5 AND numero_dba = 5), 4,
'Propone acciones para su cuidado y conservación.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 3°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 3° grado (id_grado = 6)

-- DBA 1: Comprende que los materiales tienen propiedades que determinan sus usos y las transformaciones que pueden experimentar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 6, 1,
'Comprende que los materiales tienen propiedades que determinan sus usos y las transformaciones que pueden experimentar',
'Comprende que los materiales tienen propiedades que determinan sus usos y las transformaciones que pueden experimentar.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 1), 1,
'Identifica propiedades de los materiales como dureza, flexibilidad, transparencia, textura, color, permeabilidad y conductividad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 1), 2,
'Clasifica materiales de acuerdo con sus propiedades observables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 1), 3,
'Explica cómo las propiedades de los materiales determinan sus posibles usos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 1), 4,
'Reconoce los cambios físicos y químicos que experimentan los materiales al ser sometidos a diferentes condiciones.');

-- DBA 2: Comprende que los seres vivos se interrelacionan entre sí y con el medio en el que viven
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 6, 2,
'Comprende que los seres vivos se interrelacionan entre sí y con el medio en el que viven',
'Comprende que los seres vivos se interrelacionan entre sí y con el medio en el que viven.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 2), 1,
'Identifica los componentes de un ecosistema (seres vivos y elementos no vivos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 2), 2,
'Describe las relaciones entre los seres vivos (alimentación, competencia, cooperación, refugio).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 2), 3,
'Reconoce la importancia de la luz, el agua, el aire, el suelo y la temperatura para la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 2), 4,
'Propone acciones para el cuidado y conservación de los ecosistemas.');

-- DBA 3: Comprende la función de los órganos y sistemas del cuerpo humano y la importancia de mantener hábitos saludables
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 6, 3,
'Comprende la función de los órganos y sistemas del cuerpo humano y la importancia de mantener hábitos saludables',
'Comprende la función de los órganos y sistemas del cuerpo humano y la importancia de mantener hábitos saludables.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 3), 1,
'Identifica los principales órganos de los sistemas digestivo, respiratorio, circulatorio, excretor y nervioso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 3), 2,
'Explica las funciones básicas de cada sistema en el mantenimiento de la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 3), 3,
'Relaciona hábitos de higiene, alimentación y ejercicio con el buen funcionamiento del cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y accidentes.');

-- DBA 4: Reconoce que los seres vivos se reproducen y presentan ciclos de vida característicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 6, 4,
'Reconoce que los seres vivos se reproducen y presentan ciclos de vida característicos',
'Reconoce que los seres vivos se reproducen y presentan ciclos de vida característicos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 4), 1,
'Identifica las etapas del ciclo de vida de plantas, animales y seres humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 4), 2,
'Describe los cambios que ocurren durante el crecimiento y desarrollo de los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 4), 3,
'Explica la importancia de la reproducción para la continuidad de las especies.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 4), 4,
'Propone acciones para el cuidado de los seres vivos en sus diferentes etapas.');

-- DBA 5: Reconoce la importancia del agua, el aire, el suelo y la energía solar como recursos naturales esenciales para la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 6, 5,
'Reconoce la importancia del agua, el aire, el suelo y la energía solar como recursos naturales esenciales para la vida',
'Reconoce la importancia del agua, el aire, el suelo y la energía solar como recursos naturales esenciales para la vida.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 5), 1,
'Identifica los recursos naturales presentes en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 5), 2,
'Explica la función del agua, el aire, el suelo y la energía solar en los procesos vitales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 5), 3,
'Describe algunas formas de contaminación y sus efectos sobre el ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 6 AND numero_dba = 5), 4,
'Propone acciones para el uso racional y la conservación de los recursos naturales.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 4°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 4° grado (id_grado = 7)

-- DBA 1: Comprende que la materia está conformada por materiales con diferentes propiedades y que puede sufrir transformaciones físicas y químicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 7, 1,
'Comprende que la materia está conformada por materiales con diferentes propiedades y que puede sufrir transformaciones físicas y químicas',
'Comprende que la materia está conformada por materiales con diferentes propiedades y que puede sufrir transformaciones físicas y químicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 1), 1,
'Identifica propiedades de los materiales (masa, volumen, densidad, temperatura de fusión y ebullición, conductividad).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 1), 2,
'Clasifica materiales según sus propiedades y estados físicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 1), 3,
'Describe transformaciones físicas y químicas observadas en materiales cotidianos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 1), 4,
'Explica cómo los cambios de la materia están relacionados con el uso de la energía.');

-- DBA 2: Comprende las relaciones que existen entre los seres vivos y su entorno, y reconoce la importancia de los ecosistemas para la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 7, 2,
'Comprende las relaciones que existen entre los seres vivos y su entorno, y reconoce la importancia de los ecosistemas para la vida',
'Comprende las relaciones que existen entre los seres vivos y su entorno, y reconoce la importancia de los ecosistemas para la vida.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 2), 1,
'Identifica los componentes bióticos y abióticos de un ecosistema.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 2), 2,
'Explica las relaciones de alimentación, competencia y cooperación entre los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 2), 3,
'Describe los efectos de la intervención humana en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 2), 4,
'Propone acciones para conservar y proteger los ecosistemas.');

-- DBA 3: Comprende la estructura y función de los órganos y sistemas del cuerpo humano y la importancia de su cuidado
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 7, 3,
'Comprende la estructura y función de los órganos y sistemas del cuerpo humano y la importancia de su cuidado',
'Comprende la estructura y función de los órganos y sistemas del cuerpo humano y la importancia de su cuidado.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas digestivo, respiratorio, circulatorio, excretor, nervioso y locomotor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 3), 2,
'Explica cómo interactúan los sistemas para mantener la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 3), 3,
'Relaciona hábitos de higiene, alimentación, ejercicio y descanso con la salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover estilos de vida saludables.');

-- DBA 4: Reconoce que los seres vivos se reproducen y que la herencia biológica permite la transmisión de características de una generación a otra
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 7, 4,
'Reconoce que los seres vivos se reproducen y que la herencia biológica permite la transmisión de características de una generación a otra',
'Reconoce que los seres vivos se reproducen y que la herencia biológica permite la transmisión de características de una generación a otra.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 4), 1,
'Describe las etapas del ciclo de vida de plantas, animales y seres humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 4), 2,
'Explica cómo las características de los seres vivos se transmiten de padres a hijos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 4), 3,
'Identifica semejanzas y diferencias entre individuos de la misma especie.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 4), 4,
'Propone acciones para el cuidado y conservación de las especies.');

-- DBA 5: Comprende que el agua, el aire, el suelo y la energía solar son recursos naturales esenciales para la vida y el equilibrio ambiental
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 7, 5,
'Comprende que el agua, el aire, el suelo y la energía solar son recursos naturales esenciales para la vida y el equilibrio ambiental',
'Comprende que el agua, el aire, el suelo y la energía solar son recursos naturales esenciales para la vida y el equilibrio ambiental.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 5), 1,
'Identifica los recursos naturales y sus usos en la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 5), 2,
'Explica los procesos naturales del ciclo del agua y la fotosíntesis.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 5), 3,
'Reconoce las causas y consecuencias de la contaminación ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 7 AND numero_dba = 5), 4,
'Propone acciones para el uso racional y la conservación de los recursos naturales.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 5°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 5° grado (id_grado = 8)

-- DBA 1: Comprende que la materia está formada por materiales con propiedades específicas y que puede sufrir transformaciones físicas y químicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 8, 1,
'Comprende que la materia está formada por materiales con propiedades específicas y que puede sufrir transformaciones físicas y químicas',
'Comprende que la materia está formada por materiales con propiedades específicas y que puede sufrir transformaciones físicas y químicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica las propiedades de los materiales (masa, volumen, densidad, temperatura de fusión y ebullición, conductividad, solubilidad).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 1), 2,
'Clasifica los materiales según sus propiedades y estados físicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 1), 3,
'Describe cambios físicos y químicos observados en materiales cotidianos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 1), 4,
'Explica cómo los cambios de la materia implican intercambio o transformación de energía.');

-- DBA 2: Comprende las relaciones entre los seres vivos y su entorno, y explica la importancia de los ecosistemas para el equilibrio de la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 8, 2,
'Comprende las relaciones entre los seres vivos y su entorno, y explica la importancia de los ecosistemas para el equilibrio de la vida',
'Comprende las relaciones entre los seres vivos y su entorno, y explica la importancia de los ecosistemas para el equilibrio de la vida.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 2), 1,
'Identifica los componentes bióticos y abióticos de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 2), 2,
'Explica las relaciones de alimentación, competencia, cooperación y adaptación entre los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 2), 3,
'Analiza los efectos de la intervención humana sobre los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 2), 4,
'Propone acciones para conservar los recursos naturales y mantener el equilibrio ecológico.');

-- DBA 3: Comprende la estructura y el funcionamiento del cuerpo humano y la importancia de mantener hábitos de vida saludables
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 8, 3,
'Comprende la estructura y el funcionamiento del cuerpo humano y la importancia de mantener hábitos de vida saludables',
'Comprende la estructura y el funcionamiento del cuerpo humano y la importancia de mantener hábitos de vida saludables.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas digestivo, respiratorio, circulatorio, excretor, nervioso, endocrino y locomotor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 3), 2,
'Explica la interrelación entre los sistemas del cuerpo humano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 3), 3,
'Relaciona hábitos de higiene, alimentación, ejercicio y descanso con el buen funcionamiento del cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover la salud individual y colectiva.');

-- DBA 4: Comprende que los seres vivos se reproducen y transmiten características de una generación a otra
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 8, 4,
'Comprende que los seres vivos se reproducen y transmiten características de una generación a otra',
'Comprende que los seres vivos se reproducen y transmiten características de una generación a otra.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 4), 1,
'Describe las etapas del ciclo de vida de las plantas, los animales y los seres humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 4), 2,
'Explica cómo se transmiten las características hereditarias entre los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 4), 3,
'Reconoce la importancia de la reproducción para la continuidad de las especies.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 4), 4,
'Promueve el respeto y la conservación de la diversidad biológica.');

-- DBA 5: Reconoce la importancia de los recursos naturales y de las fuentes de energía para el mantenimiento de la vida y el desarrollo sostenible
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 8, 5,
'Reconoce la importancia de los recursos naturales y de las fuentes de energía para el mantenimiento de la vida y el desarrollo sostenible',
'Reconoce la importancia de los recursos naturales y de las fuentes de energía para el mantenimiento de la vida y el desarrollo sostenible.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 5), 1,
'Identifica las principales fuentes de energía renovables y no renovables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 5), 2,
'Explica cómo se transforman y utilizan las diferentes formas de energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 5), 3,
'Analiza los efectos del uso inadecuado de los recursos naturales y las fuentes de energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 8 AND numero_dba = 5), 4,
'Propone alternativas para el aprovechamiento racional y sostenible de los recursos naturales.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 6°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 6° grado (id_grado = 9)

-- DBA 1: Comprende que la materia está constituida por partículas y que sus propiedades y transformaciones dependen de su composición
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 9, 1,
'Comprende que la materia está constituida por partículas y que sus propiedades y transformaciones dependen de su composición',
'Comprende que la materia está constituida por partículas y que sus propiedades y transformaciones dependen de su composición.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica las propiedades físicas y químicas de los materiales y sustancias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 1), 2,
'Reconoce los estados de la materia y los cambios que ocurren entre ellos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 1), 3,
'Explica que la materia está conformada por partículas que se mueven y se organizan de diferentes maneras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 1), 4,
'Relaciona las propiedades y transformaciones de la materia con su composición y estructura.');

-- DBA 2: Comprende las relaciones entre los seres vivos y su entorno, y explica la organización de los ecosistemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 9, 2,
'Comprende las relaciones entre los seres vivos y su entorno, y explica la organización de los ecosistemas',
'Comprende las relaciones entre los seres vivos y su entorno, y explica la organización de los ecosistemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 2), 1,
'Identifica los componentes bióticos y abióticos de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 2), 2,
'Explica las relaciones de alimentación, competencia, cooperación y simbiosis entre los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 2), 3,
'Analiza las cadenas y redes tróficas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 2), 4,
'Propone acciones para conservar los ecosistemas y proteger la biodiversidad.');

-- DBA 3: Comprende la estructura y función del cuerpo humano y su relación con la salud y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 9, 3,
'Comprende la estructura y función del cuerpo humano y su relación con la salud y la calidad de vida',
'Comprende la estructura y función del cuerpo humano y su relación con la salud y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas del cuerpo humano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 3), 2,
'Explica cómo interactúan los sistemas para mantener el equilibrio corporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 3), 3,
'Relaciona los hábitos saludables con el buen funcionamiento del cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover la salud integral.');

-- DBA 4: Comprende que los seres vivos se reproducen y transmiten características hereditarias
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 9, 4,
'Comprende que los seres vivos se reproducen y transmiten características hereditarias',
'Comprende que los seres vivos se reproducen y transmiten características hereditarias.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 4), 1,
'Explica los procesos de reproducción en plantas y animales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 4), 2,
'Reconoce las etapas del ciclo de vida de los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 4), 3,
'Describe cómo se transmiten las características hereditarias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 4), 4,
'Valora la importancia de la reproducción para la continuidad de las especies.');

-- DBA 5: Reconoce que la energía está presente en los fenómenos naturales y que puede transformarse de unas formas a otras
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 9, 5,
'Reconoce que la energía está presente en los fenómenos naturales y que puede transformarse de unas formas a otras',
'Reconoce que la energía está presente en los fenómenos naturales y que puede transformarse de unas formas a otras.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 5), 1,
'Identifica diferentes tipos y fuentes de energía (solar, térmica, eléctrica, química, mecánica).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 5), 2,
'Describe ejemplos de transformación de la energía en fenómenos naturales y tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 5), 3,
'Explica cómo se conserva y se transforma la energía en distintos procesos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 9 AND numero_dba = 5), 4,
'Promueve el uso responsable de la energía en su entorno.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 7°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 7° grado (id_grado = 10)

-- DBA 1: Comprende que la materia está constituida por átomos y moléculas, y que sus propiedades y transformaciones dependen de su estructura
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 10, 1,
'Comprende que la materia está constituida por átomos y moléculas, y que sus propiedades y transformaciones dependen de su estructura',
'Comprende que la materia está constituida por átomos y moléculas, y que sus propiedades y transformaciones dependen de su estructura.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica que la materia está formada por partículas llamadas átomos y moléculas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 1), 2,
'Reconoce los elementos y compuestos como diferentes tipos de sustancias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 1), 3,
'Describe las propiedades y transformaciones de la materia según su estructura.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 1), 4,
'Explica cómo las interacciones entre las partículas determinan los cambios físicos y químicos.');

-- DBA 2: Comprende las relaciones entre los seres vivos y su entorno, y explica la dinámica de los ecosistemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 10, 2,
'Comprende las relaciones entre los seres vivos y su entorno, y explica la dinámica de los ecosistemas',
'Comprende las relaciones entre los seres vivos y su entorno, y explica la dinámica de los ecosistemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 2), 1,
'Identifica los componentes y niveles de organización de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 2), 2,
'Explica las relaciones de flujo de energía y de materia entre los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 2), 3,
'Analiza los efectos de la acción humana sobre el equilibrio de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 2), 4,
'Propone acciones para el uso sostenible de los recursos naturales.');

-- DBA 3: Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y el bienestar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 10, 3,
'Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y el bienestar',
'Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y el bienestar.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas nervioso, endocrino, circulatorio, respiratorio, digestivo y excretor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 3), 2,
'Explica las interacciones entre los sistemas del cuerpo humano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 3), 3,
'Relaciona los hábitos de vida saludable con el funcionamiento del cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover el bienestar físico y mental.');

-- DBA 4: Comprende que los seres vivos se reproducen y transmiten características hereditarias a su descendencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 10, 4,
'Comprende que los seres vivos se reproducen y transmiten características hereditarias a su descendencia',
'Comprende que los seres vivos se reproducen y transmiten características hereditarias a su descendencia.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 4), 1,
'Explica los procesos de reproducción sexual y asexual en plantas y animales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 4), 2,
'Reconoce la importancia de la reproducción en la continuidad de la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 4), 3,
'Describe cómo las características se heredan de una generación a otra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 4), 4,
'Valora la diversidad genética y su importancia para la adaptación de las especies.');

-- DBA 5: Reconoce la energía como causa de los cambios que ocurren en la naturaleza y la vida cotidiana
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 10, 5,
'Reconoce la energía como causa de los cambios que ocurren en la naturaleza y la vida cotidiana',
'Reconoce la energía como causa de los cambios que ocurren en la naturaleza y la vida cotidiana.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 5), 1,
'Identifica diferentes formas de energía y sus transformaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 5), 2,
'Explica cómo la energía interviene en fenómenos físicos, biológicos y químicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 5), 3,
'Describe la conservación de la energía en procesos naturales y tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 10 AND numero_dba = 5), 4,
'Promueve el uso eficiente y responsable de la energía.');

-- =============================================
-- INSERTAR DATOS: CIENCIAS NATURALES GRADO 8°
-- =============================================

-- Ciencias Naturales (id_asignatura = 4) y 8° grado (id_grado = 11)

-- DBA 1: Comprende que la materia está constituida por átomos y moléculas y que las interacciones entre ellas explican las transformaciones químicas y físicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 11, 1,
'Comprende que la materia está constituida por átomos y moléculas y que las interacciones entre ellas explican las transformaciones químicas y físicas',
'Comprende que la materia está constituida por átomos y moléculas y que las interacciones entre ellas explican las transformaciones químicas y físicas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 1), 1,
'Identifica las partículas fundamentales de la materia y sus características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 1), 2,
'Reconoce las diferencias entre cambios físicos y químicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 1), 3,
'Explica cómo las interacciones entre átomos y moléculas producen nuevas sustancias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 1), 4,
'Describe ejemplos cotidianos de transformaciones químicas y físicas.');

-- DBA 2: Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan el equilibrio de los ecosistemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 11, 2,
'Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan el equilibrio de los ecosistemas',
'Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan el equilibrio de los ecosistemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 2), 1,
'Describe las relaciones entre los organismos y su ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 2), 2,
'Explica los flujos de energía y los ciclos de materia en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 2), 3,
'Analiza los factores que afectan el equilibrio de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 2), 4,
'Propone acciones para la conservación y el manejo sostenible de los recursos naturales.');

-- DBA 3: Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 11, 3,
'Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y la calidad de vida',
'Comprende la estructura y función de los sistemas del cuerpo humano y su relación con la salud y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas nervioso, endocrino, inmunológico y reproductor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 3), 2,
'Explica las interacciones entre los sistemas del cuerpo humano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 3), 3,
'Relaciona los hábitos de vida saludable con el buen funcionamiento del organismo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover el bienestar físico y emocional.');

-- DBA 4: Comprende los procesos de herencia y variabilidad en los seres vivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 11, 4,
'Comprende los procesos de herencia y variabilidad en los seres vivos',
'Comprende los procesos de herencia y variabilidad en los seres vivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 4), 1,
'Reconoce la célula como unidad estructural y funcional de los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 4), 2,
'Explica cómo se transmiten las características hereditarias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 4), 3,
'Identifica la importancia de la variabilidad genética en la evolución de las especies.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 4), 4,
'Valora la diversidad biológica como resultado de la herencia y la adaptación.');

-- DBA 5: Comprende la energía y su papel en los fenómenos naturales y tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 11, 5,
'Comprende la energía y su papel en los fenómenos naturales y tecnológicos',
'Comprende la energía y su papel en los fenómenos naturales y tecnológicos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 5), 1,
'Identifica diferentes formas de energía y su transformación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 5), 2,
'Explica cómo la energía se transfiere en los sistemas físicos, biológicos y químicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 5), 3,
'Analiza situaciones cotidianas en las que se evidencia la conservación de la energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 11 AND numero_dba = 5), 4,
'Propone acciones para el uso racional de la energía y la protección del ambiente.');

-- Ciencias Naturales (id_asignatura = 4) y 9° grado (id_grado = 12)

-- DBA 1: Estructura atómica y molecular de la materia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 12, 1,
'Estructura atómica y molecular de la materia',
'Comprende que la materia está constituida por átomos y moléculas, y que sus propiedades y transformaciones se explican a partir de su estructura y composición.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 1), 1,
'Identifica las partículas subatómicas y sus propiedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 1), 2,
'Explica cómo se forman los enlaces químicos y las moléculas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 1), 3,
'Diferencia mezclas y compuestos según su composición.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 1), 4,
'Analiza transformaciones químicas a partir de la conservación de la materia y la energía.');

-- DBA 2: Relaciones ecológicas y equilibrio ambiental
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 12, 2,
'Relaciones ecológicas y equilibrio ambiental',
'Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan el equilibrio ecológico.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 2), 1,
'Identifica los factores bióticos y abióticos que influyen en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 2), 2,
'Explica los flujos de energía y los ciclos biogeoquímicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 2), 3,
'Analiza las causas y consecuencias del deterioro ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 2), 4,
'Propone estrategias para el manejo sostenible de los ecosistemas.');

-- DBA 3: Sistemas corporales integrados y homeostasis
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 12, 3,
'Sistemas corporales integrados y homeostasis',
'Comprende la estructura, función y regulación de los sistemas del cuerpo humano y su relación con la salud.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 3), 1,
'Identifica los órganos y funciones de los sistemas nervioso, endocrino, inmunológico y reproductor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 3), 2,
'Explica cómo interactúan los sistemas para mantener la homeostasis.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 3), 3,
'Relaciona hábitos saludables con el funcionamiento del organismo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover la salud física y mental.');

-- DBA 4: Herencia, variabilidad y procesos evolutivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 12, 4,
'Herencia, variabilidad y procesos evolutivos',
'Comprende los procesos de herencia, variabilidad y evolución en los seres vivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 4), 1,
'Explica cómo se transmite la información genética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 4), 2,
'Identifica los mecanismos que generan variabilidad genética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 4), 3,
'Analiza evidencias de la evolución de los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 4), 4,
'Valora la diversidad biológica como resultado de la evolución.');

-- DBA 5: Energía y transformaciones en fenómenos naturales-tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 12, 5,
'Energía y transformaciones en fenómenos naturales-tecnológicos',
'Comprende la energía, sus transformaciones y su relación con los fenómenos naturales y tecnológicos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 5), 1,
'Reconoce diferentes formas de energía y sus transformaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 5), 2,
'Explica las leyes de conservación de la energía en procesos físicos, químicos y biológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 5), 3,
'Analiza los efectos del uso de la energía en el ambiente y la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 12 AND numero_dba = 5), 4,
'Propone alternativas para el aprovechamiento sostenible de las fuentes de energía.');

-- Ciencias Naturales (id_asignatura = 4) y 10° grado (id_grado = 13)

-- DBA 1: Transformaciones materia-energía con interacciones particulares
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 13, 1,
'Transformaciones materia-energía con interacciones particulares',
'Comprende que la materia está constituida por átomos y moléculas, y explica sus transformaciones a partir de la interacción entre partículas y energía.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 1), 1,
'Identifica las partículas subatómicas y su función en la estructura de la materia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 1), 2,
'Explica los tipos de enlaces químicos y la formación de compuestos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 1), 3,
'Analiza transformaciones químicas aplicando el principio de conservación de la materia y la energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 1), 4,
'Reconoce la importancia de la energía en los cambios físicos y químicos de la materia.');

-- DBA 2: Regulación ecosistémica y conservación de recursos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 13, 2,
'Regulación ecosistémica y conservación de recursos',
'Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan los ecosistemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 2), 1,
'Identifica las relaciones tróficas y los ciclos biogeoquímicos en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 2), 2,
'Explica la influencia de los factores bióticos y abióticos en la dinámica de los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 2), 3,
'Analiza el impacto de la acción humana sobre el ambiente y la biodiversidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 2), 4,
'Propone estrategias para la conservación y el uso sostenible de los recursos naturales.');

-- DBA 3: Organización corporal y homeostasis integral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 13, 3,
'Organización corporal y homeostasis integral',
'Comprende la estructura y función del cuerpo humano y los mecanismos que regulan su equilibrio interno.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 3), 1,
'Explica la organización y función de los sistemas nervioso, endocrino, circulatorio, respiratorio, excretor y reproductor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 3), 2,
'Analiza los procesos de regulación interna y homeostasis.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 3), 3,
'Relaciona los hábitos saludables con el bienestar físico y mental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 3), 4,
'Propone acciones para prevenir enfermedades y promover una vida saludable.');

-- DBA 4: Herencia-evolución con diversidad biológica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 13, 4,
'Herencia-evolución con diversidad biológica',
'Comprende los procesos de herencia y evolución en los seres vivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 4), 1,
'Explica los mecanismos de transmisión de la información genética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 4), 2,
'Analiza la variabilidad genética y su papel en la evolución.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 4), 3,
'Reconoce evidencias de la evolución biológica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 4), 4,
'Valora la diversidad biológica como resultado de la evolución y la adaptación.');

-- DBA 5: Energía en sistemas naturales-tecnológicos con sustentabilidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 13, 5,
'Energía en sistemas naturales-tecnológicos con sustentabilidad',
'Comprende la energía y sus transformaciones en los sistemas naturales y tecnológicos.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 5), 1,
'Identifica las diferentes formas y fuentes de energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 5), 2,
'Explica las transformaciones de energía en procesos naturales y tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 5), 3,
'Analiza los impactos del uso de la energía sobre el ambiente y la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 13 AND numero_dba = 5), 4,
'Propone alternativas para el uso racional y sostenible de la energía.');

-- Ciencias Naturales (id_asignatura = 4) y 11° grado (id_grado = 14)

-- DBA 1: Transformaciones materia-energía con partículas fundamentales avanzadas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 14, 1,
'Transformaciones materia-energía con partículas fundamentales avanzadas',
'Comprende que la materia está constituida por átomos y moléculas, y explica sus transformaciones en función de las interacciones entre partículas y energía.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 1), 1,
'Identifica las partículas fundamentales y su papel en la estructura de la materia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 1), 2,
'Explica los tipos de enlaces químicos y las reacciones que implican transferencia o compartición de electrones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 1), 3,
'Analiza procesos químicos y físicos aplicando los principios de conservación de la materia y la energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 1), 4,
'Relaciona las transformaciones de la materia con fenómenos naturales y tecnológicos.');

-- DBA 2: Equilibrio ecosistémico y manejo sostenible integral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 14, 2,
'Equilibrio ecosistémico y manejo sostenible integral',
'Comprende las relaciones entre los seres vivos y su entorno, y explica los mecanismos que regulan el equilibrio de los ecosistemas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 2), 1,
'Analiza la interacción entre los factores bióticos y abióticos en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 2), 2,
'Explica los flujos de energía y los ciclos de materia en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 2), 3,
'Evalúa las consecuencias de la intervención humana en los ecosistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 2), 4,
'Propone estrategias para el manejo sostenible de los recursos naturales.');

-- DBA 3: Organización corporal-homeostasis y bienestar integral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 14, 3,
'Organización corporal-homeostasis y bienestar integral',
'Comprende la organización y funcionamiento del cuerpo humano, y explica los mecanismos de regulación interna y su relación con la salud.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 3), 1,
'Explica la función de los sistemas nervioso, endocrino, circulatorio, respiratorio, excretor y reproductor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 3), 2,
'Analiza los procesos de homeostasis y su importancia para la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 3), 3,
'Relaciona hábitos saludables con la prevención de enfermedades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 3), 4,
'Promueve acciones que favorecen el bienestar físico, mental y social.');

-- DBA 4: Herencia-evolución-diversidad como patrimonio natural
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 14, 4,
'Herencia-evolución-diversidad como patrimonio natural',
'Comprende los procesos de herencia, variabilidad y evolución, y reconoce su importancia en la diversidad biológica.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 4), 1,
'Explica los mecanismos de transmisión genética y la función del ADN.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 4), 2,
'Analiza las causas y consecuencias de la variabilidad genética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 4), 3,
'Reconoce evidencias de los procesos evolutivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 4), 4,
'Valora la diversidad biológica y su conservación como patrimonio natural.');

-- DBA 5: Energía-sostenibilidad con desarrollo tecnológico responsable
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(4, 14, 5,
'Energía-sostenibilidad con desarrollo tecnológico responsable',
'Comprende la energía y sus transformaciones en los sistemas naturales y tecnológicos, y su relación con el desarrollo sostenible.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 5), 1,
'Identifica las diferentes fuentes y formas de energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 5), 2,
'Explica las transformaciones y conservación de la energía en procesos naturales y tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 5), 3,
'Analiza el impacto del uso de la energía sobre el ambiente y la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 4 AND id_grado = 14 AND numero_dba = 5), 4,
'Propone alternativas de aprovechamiento sostenible de la energía.');

-- =============================================
-- TECNOLOGÍA E INFORMÁTICA
-- =============================================

-- Tecnología e Informática (id_asignatura = 5) y 1° grado (id_grado = 4)

-- DBA 1: Reconocimiento de objetos tecnológicos del entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 4, 1,
'Reconocimiento de objetos tecnológicos del entorno',
'Reconoce algunos objetos tecnológicos de su entorno y describe su función.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 1), 1,
'Identifica objetos tecnológicos presentes en su hogar, escuela y comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 1), 2,
'Describe la utilidad de los objetos tecnológicos que utiliza diariamente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 1), 3,
'Clasifica objetos según su uso (comunicación, transporte, recreación, alimentación).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 1), 4,
'Explica con sus palabras para qué sirve un objeto y cómo le facilita la vida.');

-- DBA 2: Uso adecuado de herramientas tecnológicas cotidianas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 4, 2,
'Uso adecuado de herramientas tecnológicas cotidianas',
'Utiliza adecuadamente objetos y herramientas tecnológicas en actividades cotidianas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 2), 1,
'Manipula con cuidado objetos tecnológicos como tijeras, reglas, lápices, juguetes, entre otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 2), 2,
'Emplea herramientas básicas digitales o dispositivos (como computador, tableta o teléfono) bajo orientación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 2), 3,
'Respeta las normas de seguridad y cuidado en el uso de herramientas y dispositivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 2), 4,
'Explica por qué es importante cuidar los objetos tecnológicos que usa.');

-- DBA 3: Identificación de objetos como satisfactores de necesidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 4, 3,
'Identificación de objetos como satisfactores de necesidades',
'Identifica que los objetos tecnológicos se elaboran para satisfacer necesidades.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 3), 1,
'Describe necesidades cotidianas y relaciona objetos que ayudan a satisfacerlas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 3), 2,
'Explica la diferencia entre objetos naturales y objetos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 3), 3,
'Comenta cómo algunas personas crean o mejoran objetos para ayudar a los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 3), 4,
'Propone ideas para mejorar objetos de su entorno inmediato.');

-- DBA 4: Importancia del trabajo colaborativo con tecnología
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 4, 4,
'Importancia del trabajo colaborativo con tecnología',
'Reconoce la importancia de trabajar en grupo para construir o utilizar objetos tecnológicos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 4), 1,
'Participa en actividades grupales de construcción sencilla (puzzles, maquetas, dibujos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 4), 2,
'Colabora con sus compañeros en el uso de materiales y herramientas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 4), 3,
'Explica por qué es importante compartir y respetar las ideas de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 4), 4,
'Demuestra actitudes de cooperación, respeto y responsabilidad al trabajar con tecnología.');

-- DBA 5: Uso de TIC como apoyo al aprendizaje
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 4, 5,
'Uso de TIC como apoyo al aprendizaje',
'Utiliza las tecnologías de la información y la comunicación (TIC) como apoyo para el aprendizaje.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 5), 1,
'Usa el computador o la tableta para dibujar, escribir o jugar con orientación docente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 5), 2,
'Reconoce los elementos básicos de un computador: pantalla, teclado y ratón.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 5), 3,
'Utiliza programas sencillos para realizar actividades escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 4 AND numero_dba = 5), 4,
'Demuestra interés y cuidado en el uso responsable de las TIC.');

-- Tecnología e Informática (id_asignatura = 5) y 2° grado (id_grado = 5)

-- DBA 1: Evolución tecnológica y satisfacción de necesidades humanas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 5, 1,
'Evolución tecnológica y satisfacción de necesidades humanas',
'Reconoce que la tecnología surge para satisfacer necesidades humanas y que evoluciona con el tiempo.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 1), 1,
'Identifica objetos tecnológicos de diferentes épocas y compara sus características.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 1), 2,
'Describe cómo algunos objetos han cambiado para facilitar las actividades humanas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 1), 3,
'Explica con ejemplos cómo la tecnología ayuda a mejorar la vida de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 1), 4,
'Reconoce que el desarrollo tecnológico responde a las necesidades y al ingenio humano.');

-- DBA 2: Uso responsable y seguro de herramientas y materiales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 5, 2,
'Uso responsable y seguro de herramientas y materiales',
'Utiliza de manera responsable y segura herramientas y materiales en actividades escolares y cotidianas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 2), 1,
'Manipula correctamente materiales y herramientas sencillas (tijeras, regla, pegante, papel, etc.).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 2), 2,
'Aplica normas de seguridad y orden al trabajar con objetos y materiales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 2), 3,
'Muestra cuidado y responsabilidad en el uso de herramientas compartidas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 2), 4,
'Explica la importancia de seguir instrucciones para evitar accidentes.');

-- DBA 3: Comprensión de objetos como sistemas con partes funcionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 5, 3,
'Comprensión de objetos como sistemas con partes funcionales',
'Comprende que los objetos tecnológicos están formados por partes que cumplen diferentes funciones.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 3), 1,
'Identifica las partes de un objeto tecnológico y su función (por ejemplo, la tapa de un esfero o las ruedas de un carro).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 3), 2,
'Describe cómo interactúan las partes de un objeto para que funcione.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 3), 3,
'Dibuja o representa un objeto tecnológico señalando sus componentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 3), 4,
'Explica cómo el daño de una parte puede afectar el funcionamiento del todo.');

-- DBA 4: Proposición de soluciones sencillas a problemas del entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 5, 4,
'Proposición de soluciones sencillas a problemas del entorno',
'Propone soluciones sencillas a problemas de su entorno mediante el uso de materiales y herramientas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica necesidades o problemas en su entorno cercano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 4), 2,
'Propone ideas creativas para solucionarlos utilizando materiales disponibles.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 4), 3,
'Construye objetos simples (carteles, maquetas, juegos, etc.) con orientación docente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 4), 4,
'Evalúa el resultado de su trabajo y comenta posibles mejoras.');

-- DBA 5: Uso responsable de TIC en actividades escolares
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 5, 5,
'Uso responsable de TIC en actividades escolares',
'Usa las tecnologías de la información y la comunicación (TIC) de manera responsable en actividades escolares.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 5), 1,
'Reconoce los dispositivos tecnológicos que sirven para comunicarse e informarse.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 5), 2,
'Utiliza el computador o la tableta para escribir, dibujar o buscar información bajo supervisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 5), 3,
'Respeta normas básicas de uso (no dañar, no eliminar archivos, cuidar los equipos).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 5 AND numero_dba = 5), 4,
'Explica por qué es importante usar correctamente las TIC para aprender.');

-- Tecnología e Informática (id_asignatura = 5) y 3° grado (id_grado = 6)

-- DBA 1: Tecnología como creación humana para satisfacer necesidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 6, 1,
'Tecnología como creación humana para satisfacer necesidades',
'Comprende que la tecnología es una creación humana orientada a satisfacer necesidades y resolver problemas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 1), 1,
'Reconoce que la tecnología es resultado del ingenio y la creatividad de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 1), 2,
'Identifica ejemplos de cómo la tecnología soluciona problemas de la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 1), 3,
'Explica con ejemplos cómo la tecnología cambia con el tiempo para responder a nuevas necesidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 1), 4,
'Propone ideas sobre cómo mejorar objetos o procesos tecnológicos de su entorno.');

-- DBA 2: Identificación de materiales, herramientas y procesos en elaboración tecnológica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 6, 2,
'Identificación de materiales, herramientas y procesos en elaboración tecnológica',
'Identifica los materiales, herramientas y procesos que intervienen en la elaboración de un objeto tecnológico.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 2), 1,
'Describe los materiales necesarios para fabricar objetos sencillos (cartón, papel, plástico, etc.).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 2), 2,
'Explica los pasos que siguen las personas para construir un objeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 2), 3,
'Distingue las herramientas que se utilizan en los procesos de construcción.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 2), 4,
'Elabora objetos sencillos aplicando un procedimiento planificado.');

-- DBA 3: Reconocimiento de objetos como sistemas simples funcionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 6, 3,
'Reconocimiento de objetos como sistemas simples funcionales',
'Reconoce que los objetos tecnológicos están conformados por sistemas simples que permiten su funcionamiento.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 3), 1,
'Identifica las partes y el funcionamiento de objetos tecnológicos de uso cotidiano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 3), 2,
'Describe la relación entre las partes de un objeto y el propósito que cumple.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 3), 3,
'Representa con dibujos o esquemas el funcionamiento de objetos simples.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 3), 4,
'Explica cómo el daño de una parte afecta el funcionamiento del sistema completo.');

-- DBA 4: Uso seguro y responsable de herramientas y materiales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 6, 4,
'Uso seguro y responsable de herramientas y materiales',
'Utiliza herramientas tecnológicas y materiales de forma segura y responsable en actividades escolares.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 4), 1,
'Usa correctamente herramientas y materiales en la elaboración de productos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 4), 2,
'Aplica normas de seguridad y limpieza al trabajar con herramientas y dispositivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 4), 3,
'Muestra responsabilidad en el uso y cuidado de los objetos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 4), 4,
'Reconoce la importancia del trabajo ordenado y colaborativo en actividades tecnológicas.');

-- DBA 5: Utilización de TIC como recurso de aprendizaje y comunicación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 6, 5,
'Utilización de TIC como recurso de aprendizaje y comunicación',
'Utiliza las tecnologías de la información y la comunicación (TIC) como recurso para el aprendizaje y la comunicación.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 5), 1,
'Utiliza dispositivos tecnológicos para escribir, dibujar o buscar información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 5), 2,
'Reconoce los elementos básicos de un computador y sus funciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 5), 3,
'Emplea programas o aplicaciones sencillas para realizar tareas escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 6 AND numero_dba = 5), 4,
'Promueve el uso responsable y ético de las TIC en su entorno escolar.');

-- Tecnología e Informática (id_asignatura = 5) y 4° grado (id_grado = 7)

-- DBA 1: Desarrollo tecnológico desde identificación de necesidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 7, 1,
'Desarrollo tecnológico desde identificación de necesidades',
'Comprende que la tecnología se desarrolla a partir de la identificación de necesidades y la búsqueda de soluciones.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 1), 1,
'Identifica necesidades de su entorno que pueden resolverse con ayuda de la tecnología.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 1), 2,
'Propone ideas creativas para solucionar problemas sencillos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 1), 3,
'Reconoce que la creación de objetos tecnológicos implica un proceso de planeación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 1), 4,
'Explica cómo la tecnología transforma el entorno para mejorar la calidad de vida.');

-- DBA 2: Descripción del proceso de diseño y construcción
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 7, 2,
'Descripción del proceso de diseño y construcción',
'Describe el proceso de diseño y construcción de objetos tecnológicos.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 2), 1,
'Explica las etapas básicas del proceso tecnológico: identificación del problema, diseño, construcción y evaluación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 2), 2,
'Representa mediante dibujos o esquemas el diseño de objetos sencillos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 2), 3,
'Selecciona materiales y herramientas apropiadas para elaborar un producto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 2), 4,
'Evalúa el resultado de su trabajo y propone mejoras.');

-- DBA 3: Comprensión de objetos como sistemas complejos interactivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 7, 3,
'Comprensión de objetos como sistemas complejos interactivos',
'Comprende que los objetos tecnológicos funcionan como sistemas compuestos por partes que interactúan entre sí.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 3), 1,
'Identifica las partes que conforman objetos o dispositivos tecnológicos de uso común.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 3), 2,
'Describe la función de cada parte dentro del sistema.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 3), 3,
'Representa mediante esquemas o diagramas la relación entre las partes de un objeto tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 3), 4,
'Explica cómo los sistemas tecnológicos cumplen una función determinada.');

-- DBA 4: Uso responsable y seguro de recursos tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 7, 4,
'Uso responsable y seguro de recursos tecnológicos',
'Utiliza herramientas, materiales y recursos tecnológicos de manera responsable y segura.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 4), 1,
'Usa correctamente las herramientas y materiales durante la construcción de objetos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 4), 2,
'Cumple normas de seguridad y orden en el trabajo tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 4), 3,
'Cuida los equipos, materiales y espacios de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 4), 4,
'Promueve actitudes de responsabilidad, cooperación y respeto en el trabajo grupal.');

-- DBA 5: Utilización de TIC para comunicación y fortalecimiento del aprendizaje
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 7, 5,
'Utilización de TIC para comunicación y fortalecimiento del aprendizaje',
'Utiliza las tecnologías de la información y la comunicación (TIC) para comunicarse y fortalecer su aprendizaje.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 5), 1,
'Usa el computador o la tableta para escribir, dibujar, buscar información y comunicar ideas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 5), 2,
'Identifica los componentes básicos de un sistema informático (hardware y software).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 5), 3,
'Emplea programas o aplicaciones para realizar actividades académicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 7 AND numero_dba = 5), 4,
'Aplica normas básicas de seguridad digital y respeto en el uso de las TIC.');

-- Tecnología e Informática (id_asignatura = 5) y 5° grado (id_grado = 8)

-- DBA 1: Tecnología como proceso transformador del entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 8, 1,
'Tecnología como proceso transformador del entorno',
'Comprende que la tecnología es un proceso mediante el cual las personas transforman el entorno para satisfacer sus necesidades.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica necesidades del entorno que se satisfacen mediante objetos o procesos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 1), 2,
'Reconoce que el desarrollo tecnológico implica creatividad y trabajo colaborativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 1), 3,
'Explica cómo la tecnología transforma los materiales para crear nuevos productos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 1), 4,
'Valora el papel de la tecnología en la mejora de la calidad de vida.');

-- DBA 2: Aplicación del proceso tecnológico en solución de problemas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 8, 2,
'Aplicación del proceso tecnológico en solución de problemas',
'Aplica el proceso tecnológico en la solución de problemas de su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 2), 1,
'Identifica un problema tecnológico de su entorno escolar o comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 2), 2,
'Propone ideas y diseña posibles soluciones utilizando materiales disponibles.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 2), 3,
'Construye un objeto o prototipo siguiendo un proceso planificado.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 2), 4,
'Evalúa la efectividad de su propuesta y propone mejoras.');

-- DBA 3: Reconocimiento de sistemas tecnológicos y componentes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 8, 3,
'Reconocimiento de sistemas tecnológicos y componentes',
'Reconoce los sistemas tecnológicos y sus componentes.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 3), 1,
'Identifica los componentes básicos de un sistema tecnológico: entrada, proceso, salida y retroalimentación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 3), 2,
'Explica cómo interactúan las partes de un sistema para cumplir una función.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 3), 3,
'Representa gráficamente sistemas tecnológicos sencillos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 3), 4,
'Analiza ejemplos de sistemas tecnológicos en su entorno cotidiano.');

-- DBA 4: Uso seguro y responsable en elaboración de objetos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 8, 4,
'Uso seguro y responsable en elaboración de objetos',
'Utiliza herramientas y materiales de forma segura y responsable en la elaboración de objetos tecnológicos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 4), 1,
'Emplea correctamente herramientas manuales y materiales diversos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 4), 2,
'Aplica normas de seguridad y cuidado durante el trabajo tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 4), 3,
'Colabora con sus compañeros en la organización del espacio de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 4), 4,
'Explica la importancia del orden, la limpieza y la precaución en las actividades tecnológicas.');

-- DBA 5: Uso de TIC como medio de expresión, comunicación y aprendizaje
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 8, 5,
'Uso de TIC como medio de expresión, comunicación y aprendizaje',
'Usa las tecnologías de la información y la comunicación (TIC) como medio de expresión, comunicación y aprendizaje.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 5), 1,
'Utiliza programas o aplicaciones para redactar, dibujar, diseñar o presentar información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 5), 2,
'Emplea el internet de forma guiada para buscar y compartir información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 5), 3,
'Reconoce la importancia del uso responsable y ético de las TIC.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 8 AND numero_dba = 5), 4,
'Aplica buenas prácticas de seguridad digital y respeto en la red.');

-- Tecnología e Informática (id_asignatura = 5) y 6° grado (id_grado = 9)

-- DBA 1: Tecnología como proceso sistemático transformador
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 9, 1,
'Tecnología como proceso sistemático transformador',
'Comprende que la tecnología es un proceso sistemático mediante el cual las personas transforman el entorno para resolver problemas o satisfacer necesidades.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica necesidades del entorno que se pueden resolver mediante el uso de la tecnología.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 1), 2,
'Explica cómo las ideas se convierten en soluciones a través del proceso tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 1), 3,
'Describe las etapas del proceso tecnológico: identificación del problema, diseño, construcción, evaluación y comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 1), 4,
'Reconoce la importancia de la creatividad, la planificación y el trabajo en equipo en el desarrollo tecnológico.');

-- DBA 2: Aplicación del proceso tecnológico para diseño y construcción de soluciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 9, 2,
'Aplicación del proceso tecnológico para diseño y construcción de soluciones',
'Aplica el proceso tecnológico para diseñar y construir soluciones a problemas de su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 2), 1,
'Identifica un problema tecnológico de su entorno escolar o comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 2), 2,
'Diseña propuestas de solución mediante bocetos o esquemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 2), 3,
'Construye objetos o prototipos aplicando conocimientos de materiales, energía y sistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 2), 4,
'Evalúa el resultado de su trabajo y plantea mejoras.');

-- DBA 3: Comprensión de sistemas tecnológicos y funcionamiento
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 9, 3,
'Comprensión de sistemas tecnológicos y funcionamiento',
'Comprende los sistemas tecnológicos y su funcionamiento.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 3), 1,
'Identifica los componentes de un sistema tecnológico (entrada, proceso, salida, control y retroalimentación).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 3), 2,
'Explica el funcionamiento de sistemas tecnológicos sencillos de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 3), 3,
'Representa mediante diagramas el flujo de información, energía o materiales en un sistema.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 3), 4,
'Reconoce cómo los sistemas tecnológicos se integran en la vida diaria.');

-- DBA 4: Uso seguro, eficiente y responsable de materiales, herramientas y recursos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 9, 4,
'Uso seguro, eficiente y responsable de materiales, herramientas y recursos',
'Utiliza materiales, herramientas y recursos tecnológicos de manera segura, eficiente y responsable.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 4), 1,
'Selecciona adecuadamente materiales y herramientas para sus proyectos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 4), 2,
'Aplica normas de seguridad, orden y mantenimiento en su trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 4), 3,
'Cuida los recursos disponibles y promueve el uso responsable de la tecnología.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 4), 4,
'Explica la importancia de la seguridad y la prevención de riesgos en actividades tecnológicas.');

-- DBA 5: Uso de TIC para procesamiento y comunicación de información
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 9, 5,
'Uso de TIC para procesamiento y comunicación de información',
'Usa las tecnologías de la información y la comunicación (TIC) para procesar y comunicar información.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 5), 1,
'Utiliza programas o aplicaciones informáticas para elaborar textos, tablas o presentaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 5), 2,
'Emplea herramientas digitales para buscar, organizar y comunicar información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 5), 3,
'Aplica normas de seguridad, respeto y ética en el uso de las TIC.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 9 AND numero_dba = 5), 4,
'Reconoce el papel de las TIC en la comunicación, la educación y la vida cotidiana.');

-- Tecnología e Informática (id_asignatura = 5) y 7° grado (id_grado = 10)

-- DBA 1: Tecnología como proceso de creación humana con conocimiento, diseño y recursos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 10, 1,
'Tecnología como proceso de creación humana con conocimiento, diseño y recursos',
'Comprende que la tecnología es un proceso de creación humana que involucra conocimiento, diseño y uso de recursos para resolver problemas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica problemas de su entorno que pueden resolverse mediante la aplicación de procesos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 1), 2,
'Explica cómo el conocimiento científico y técnico se aplica en la creación de objetos y sistemas tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 1), 3,
'Reconoce la importancia del diseño como etapa esencial en la solución de problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 1), 4,
'Valora la innovación y la creatividad como factores del desarrollo tecnológico.');

-- DBA 2: Aplicación del proceso para diseñar, construir y evaluar soluciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 10, 2,
'Aplicación del proceso para diseñar, construir y evaluar soluciones',
'Aplica el proceso tecnológico para diseñar, construir y evaluar soluciones a problemas de su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 2), 1,
'Identifica una necesidad o problema tecnológico y plantea una posible solución.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 2), 2,
'Elabora bocetos o esquemas que representen el diseño de su propuesta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 2), 3,
'Construye prototipos utilizando materiales y herramientas adecuadas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 2), 4,
'Evalúa su producto o sistema proponiendo mejoras.');

-- DBA 3: Comprensión del funcionamiento e interacción de sistemas tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 10, 3,
'Comprensión del funcionamiento e interacción de sistemas tecnológicos',
'Comprende el funcionamiento y la interacción de los sistemas tecnológicos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 3), 1,
'Identifica los componentes de un sistema tecnológico: entrada, proceso, salida y retroalimentación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 3), 2,
'Explica cómo interactúan los componentes de un sistema para cumplir una función específica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 3), 3,
'Representa gráficamente el flujo de información, energía o materiales en un sistema.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 3), 4,
'Analiza ejemplos de sistemas tecnológicos complejos en su entorno (transporte, comunicación, producción, etc.).');

-- DBA 4: Uso seguro, eficiente y responsable de materiales, herramientas y recursos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 10, 4,
'Uso seguro, eficiente y responsable de materiales, herramientas y recursos',
'Utiliza materiales, herramientas y recursos tecnológicos de manera segura, eficiente y responsable.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 4), 1,
'Selecciona materiales y herramientas adecuados para cada proyecto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 4), 2,
'Aplica normas de seguridad en el uso de herramientas manuales y eléctricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 4), 3,
'Mantiene el orden, la limpieza y el cuidado de los espacios y recursos de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 4), 4,
'Promueve el uso responsable y sostenible de los recursos tecnológicos.');

-- DBA 5: Uso de TIC para procesar, comunicar y compartir información
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 10, 5,
'Uso de TIC para procesar, comunicar y compartir información',
'Usa las tecnologías de la información y la comunicación (TIC) para procesar, comunicar y compartir información.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 5), 1,
'Utiliza software ofimático o educativo para procesar información y presentar resultados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 5), 2,
'Emplea herramientas digitales para comunicarse y trabajar colaborativamente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 5), 3,
'Aplica principios éticos, de seguridad y respeto en el uso de las TIC.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 10 AND numero_dba = 5), 4,
'Reconoce el impacto de las TIC en los ámbitos personal, educativo y social.');

-- Tecnología e Informática (id_asignatura = 5) y 8° grado (id_grado = 11)

-- DBA 1: Desarrollo tecnológico desde conocimiento científico y técnico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 11, 1,
'Desarrollo tecnológico desde conocimiento científico y técnico',
'Comprende que el desarrollo tecnológico resulta de la aplicación del conocimiento científico y técnico para resolver problemas y satisfacer necesidades.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 1), 1,
'Explica la relación entre ciencia, tecnología y sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 1), 2,
'Identifica ejemplos donde el conocimiento científico ha permitido el desarrollo de nuevas tecnologías.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 1), 3,
'Analiza cómo la tecnología transforma el entorno natural y social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 1), 4,
'Valora la importancia de la ciencia y la tecnología en el progreso de las comunidades.');

-- DBA 2: Aplicación del proceso con criterios técnicos, estéticos y funcionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 11, 2,
'Aplicación del proceso con criterios técnicos, estéticos y funcionales',
'Aplica el proceso tecnológico para diseñar, construir y evaluar soluciones a problemas del entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 2), 1,
'Identifica necesidades o problemas tecnológicos en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 2), 2,
'Diseña propuestas de solución representadas mediante bocetos o planos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 2), 3,
'Construye prototipos aplicando criterios técnicos, estéticos y funcionales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 2), 4,
'Evalúa el desempeño de su producto o sistema tecnológico y propone mejoras.');

-- DBA 3: Comprensión de estructura, funcionamiento e interacción sistémica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 11, 3,
'Comprensión de estructura, funcionamiento e interacción sistémica',
'Comprende la estructura, funcionamiento e interacción de los sistemas tecnológicos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 3), 1,
'Reconoce los componentes de un sistema tecnológico y su función.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 3), 2,
'Explica cómo los sistemas tecnológicos integran diferentes tipos de energía, información o materiales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 3), 3,
'Representa diagramas de flujo que describen el funcionamiento de sistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 3), 4,
'Analiza sistemas tecnológicos de su entorno (transporte, comunicación, energía, producción, etc.).');

-- DBA 4: Uso seguro, eficiente y sostenible de recursos tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 11, 4,
'Uso seguro, eficiente y sostenible de recursos tecnológicos',
'Utiliza materiales, herramientas y recursos tecnológicos de manera segura, eficiente y sostenible.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 4), 1,
'Selecciona materiales y herramientas apropiadas para la construcción de productos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 4), 2,
'Aplica normas de seguridad y prevención de riesgos en su trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 4), 3,
'Utiliza los recursos de manera racional para evitar el desperdicio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 4), 4,
'Promueve prácticas de cuidado ambiental y sostenibilidad en el uso de la tecnología.');

-- DBA 5: Uso de TIC para acceso, procesamiento y comunicación de información
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 11, 5,
'Uso de TIC para acceso, procesamiento y comunicación de información',
'Usa las tecnologías de la información y la comunicación (TIC) para acceder, procesar y comunicar información.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 5), 1,
'Utiliza programas o aplicaciones para elaborar documentos, presentaciones o bases de datos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 5), 2,
'Emplea herramientas digitales para recopilar, analizar y compartir información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 5), 3,
'Aplica criterios de seguridad y ética digital en el uso de las TIC.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 11 AND numero_dba = 5), 4,
'Reconoce el papel de las TIC en la educación, la economía y la sociedad actual.');

-- Tecnología e Informática (id_asignatura = 5) y 9° grado (id_grado = 12)

-- DBA 1: Tecnología como proceso social y cultural evolutivo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 12, 1,
'Tecnología como proceso social y cultural evolutivo',
'Comprende que la tecnología es un proceso social y cultural que evoluciona en función de las necesidades humanas y los avances científicos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 1), 1,
'Explica cómo la tecnología cambia a lo largo del tiempo en respuesta a las necesidades sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 1), 2,
'Analiza la relación entre los descubrimientos científicos y los desarrollos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 1), 3,
'Identifica ejemplos de innovaciones tecnológicas que han transformado la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 1), 4,
'Valora el impacto de la tecnología en el desarrollo económico, social y ambiental.');

-- DBA 2: Aplicación del proceso con principios de diseño técnico y funcional
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 12, 2,
'Aplicación del proceso con principios de diseño técnico y funcional',
'Aplica el proceso tecnológico para diseñar, construir y evaluar soluciones a problemas de su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 2), 1,
'Identifica un problema o necesidad tecnológica en su entorno escolar o comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 2), 2,
'Diseña una propuesta de solución aplicando principios de diseño técnico y funcional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 2), 3,
'Construye un prototipo o modelo aplicando procedimientos seguros y eficaces.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 2), 4,
'Evalúa el desempeño del producto o sistema y propone ajustes o mejoras.');

-- DBA 3: Comprensión de funcionamiento e interrelación de sistemas complejos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 12, 3,
'Comprensión de funcionamiento e interrelación de sistemas complejos',
'Comprende el funcionamiento e interrelación de los sistemas tecnológicos complejos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 3), 1,
'Identifica los subsistemas y componentes de un sistema tecnológico complejo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 3), 2,
'Explica la interacción entre los diferentes subsistemas (energía, información, materiales, control).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 3), 3,
'Representa gráficamente el flujo de procesos dentro de un sistema tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 3), 4,
'Analiza sistemas tecnológicos actuales (energía eléctrica, transporte, comunicación, automatización).');

-- DBA 4: Uso eficiente, seguro y sostenible de recursos tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 12, 4,
'Uso eficiente, seguro y sostenible de recursos tecnológicos',
'Utiliza materiales, herramientas y recursos tecnológicos de manera eficiente, segura y sostenible.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 4), 1,
'Selecciona materiales y herramientas adecuados al tipo de proyecto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 4), 2,
'Aplica normas de seguridad y mantenimiento preventivo en el uso de equipos y herramientas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 4), 3,
'Evalúa el impacto ambiental del uso de materiales y recursos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 4), 4,
'Promueve el uso racional y sostenible de la tecnología en su entorno.');

-- DBA 5: Uso de TIC para procesar, comunicar y generar información
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 12, 5,
'Uso de TIC para procesar, comunicar y generar información',
'Usa las tecnologías de la información y la comunicación (TIC) para procesar, comunicar y generar información.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 5), 1,
'Utiliza software ofimático, de diseño o simulación para apoyar sus proyectos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 5), 2,
'Emplea herramientas digitales colaborativas para compartir y comunicar información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 5), 3,
'Aplica principios éticos, de seguridad y respeto en entornos virtuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 12 AND numero_dba = 5), 4,
'Analiza la influencia de las TIC en los ámbitos educativo, laboral y social.');

-- Tecnología e Informática (id_asignatura = 5) y 10° grado (id_grado = 13)

-- DBA 1: Desarrollo tecnológico como proceso social ciencia-técnica-necesidades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 13, 1,
'Desarrollo tecnológico como proceso social ciencia-técnica-necesidades',
'Comprende que el desarrollo tecnológico es un proceso social en el que intervienen la ciencia, la técnica y las necesidades humanas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 1), 1,
'Explica cómo los avances científicos impulsan la creación de nuevas tecnologías.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 1), 2,
'Analiza la relación entre el desarrollo tecnológico y los cambios sociales y culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 1), 3,
'Identifica ejemplos de innovaciones que han transformado la producción, la comunicación y el transporte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 1), 4,
'Valora la importancia de la ética y la responsabilidad en el desarrollo y uso de la tecnología.');

-- DBA 2: Aplicación del proceso con criterios técnicos, estéticos y ambientales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 13, 2,
'Aplicación del proceso con criterios técnicos, estéticos y ambientales',
'Aplica el proceso tecnológico para diseñar, construir y evaluar soluciones a problemas de su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 2), 1,
'Identifica problemas tecnológicos en contextos escolares o comunitarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 2), 2,
'Diseña propuestas de solución incorporando criterios técnicos, estéticos y ambientales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 2), 3,
'Construye prototipos o modelos aplicando conocimientos de materiales, energía y sistemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 2), 4,
'Evalúa la funcionalidad, seguridad y sostenibilidad de sus proyectos tecnológicos.');

-- DBA 3: Comprensión de estructura, funcionamiento e interacción de sistemas complejos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 13, 3,
'Comprensión de estructura, funcionamiento e interacción de sistemas complejos',
'Comprende la estructura, funcionamiento e interacción de los sistemas tecnológicos complejos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 3), 1,
'Identifica los componentes y procesos de los sistemas tecnológicos complejos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 3), 2,
'Explica la interacción entre los subsistemas de energía, información, control y materiales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 3), 3,
'Representa mediante diagramas el funcionamiento de un sistema tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 3), 4,
'Analiza el impacto de los sistemas tecnológicos en la vida cotidiana y el entorno natural.');

-- DBA 4: Uso eficiente, seguro y sostenible con normas industriales y ambientales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 13, 4,
'Uso eficiente, seguro y sostenible con normas industriales y ambientales',
'Utiliza materiales, herramientas y recursos tecnológicos de manera eficiente, segura y sostenible.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 4), 1,
'Selecciona materiales y herramientas apropiadas según los requerimientos del proyecto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 4), 2,
'Aplica normas de seguridad industrial y ambiental durante la ejecución de proyectos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 4), 3,
'Evalúa los efectos del uso de materiales sobre el ambiente y la salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 4), 4,
'Propone prácticas de reciclaje, reutilización y consumo responsable en su entorno.');

-- DBA 5: Uso crítico y responsable de TIC para crear, procesar y comunicar información
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 13, 5,
'Uso crítico y responsable de TIC para crear, procesar y comunicar información',
'Usa las tecnologías de la información y la comunicación (TIC) para crear, procesar y comunicar información de manera crítica y responsable.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 5), 1,
'Utiliza programas o aplicaciones especializadas en la elaboración de proyectos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 5), 2,
'Emplea plataformas digitales para la comunicación y el trabajo colaborativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 5), 3,
'Aplica normas de seguridad y ética digital en el uso de información y redes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 13 AND numero_dba = 5), 4,
'Analiza el papel de las TIC en la innovación, la productividad y la transformación social.');

-- Tecnología e Informática (id_asignatura = 5) y 11° grado (id_grado = 14)

-- DBA 1: Desarrollo tecnológico como proceso histórico, social y cultural con avances científicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 14, 1,
'Desarrollo tecnológico como proceso histórico, social y cultural con avances científicos',
'Comprende que el desarrollo tecnológico es un proceso histórico, social y cultural, vinculado con los avances científicos y las necesidades humanas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 1), 1,
'Explica cómo los descubrimientos científicos y las demandas sociales impulsan el desarrollo tecnológico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 1), 2,
'Analiza los impactos sociales, económicos, culturales y ambientales de la tecnología.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 1), 3,
'Reconoce la evolución de los sistemas tecnológicos a lo largo de la historia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 1), 4,
'Valora la responsabilidad ética en el diseño, producción y uso de la tecnología.');

-- DBA 2: Aplicación del proceso para proyectos de innovación orientados a mejorar entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 14, 2,
'Aplicación del proceso para proyectos de innovación orientados a mejorar entorno',
'Aplica el proceso tecnológico para diseñar, desarrollar y evaluar proyectos de innovación orientados a mejorar su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 2), 1,
'Identifica problemas tecnológicos de su entorno y plantea soluciones viables e innovadoras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 2), 2,
'Diseña proyectos aplicando criterios de factibilidad, sostenibilidad y funcionalidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 2), 3,
'Construye o simula prototipos que integran conocimientos de ciencia, tecnología e ingeniería.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 2), 4,
'Evalúa los resultados de su proyecto y propone mejoras basadas en la evidencia.');

-- DBA 3: Comprensión de funcionamiento e interrelación de sistemas complejos con impacto social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 14, 3,
'Comprensión de funcionamiento e interrelación de sistemas complejos con impacto social',
'Comprende el funcionamiento e interrelación de los sistemas tecnológicos complejos y su impacto en la sociedad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 3), 1,
'Identifica los subsistemas que componen los sistemas tecnológicos complejos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 3), 2,
'Explica la relación entre los flujos de energía, materiales e información.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 3), 3,
'Analiza el papel de los sistemas tecnológicos en los procesos productivos y de comunicación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 3), 4,
'Evalúa las ventajas y riesgos de la automatización y la inteligencia artificial.');

-- DBA 4: Uso crítico, eficiente y sostenible de recursos tecnológicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 14, 4,
'Uso crítico, eficiente y sostenible de recursos tecnológicos',
'Utiliza materiales, herramientas y recursos tecnológicos de manera crítica, eficiente y sostenible.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 4), 1,
'Selecciona materiales, herramientas y tecnologías de acuerdo con criterios de eficiencia y sostenibilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 4), 2,
'Aplica normas de seguridad y gestión ambiental en la ejecución de proyectos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 4), 3,
'Evalúa el impacto ambiental del uso de recursos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 4), 4,
'Promueve el uso racional de la energía y la reducción de residuos en su entorno.');

-- DBA 5: Uso de TIC para aprendizaje, innovación y participación social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(5, 14, 5,
'Uso de TIC para aprendizaje, innovación y participación social',
'Usa las tecnologías de la información y la comunicación (TIC) para el aprendizaje, la innovación y la participación social.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 5), 1,
'Utiliza herramientas digitales para diseñar, documentar y presentar proyectos tecnológicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 5), 2,
'Emplea plataformas virtuales para la comunicación, el trabajo colaborativo y la investigación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 5), 3,
'Aplica principios éticos y de seguridad digital en la gestión de información y redes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 5 AND id_grado = 14 AND numero_dba = 5), 4,
'Valora el papel de las TIC en la construcción de ciudadanía digital y el desarrollo sostenible.');

-- =============================================
-- ÉTICA Y VALORES HUMANOS
-- =============================================

-- Ética y Valores Humanos (id_asignatura = 6) y 1° grado (id_grado = 4)

-- DBA 1: Reconocimiento como persona única y valiosa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 4, 1,
'Reconocimiento como persona única y valiosa',
'Se reconoce como persona con cualidades, capacidades y emociones que lo hacen único y valioso.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 1), 1,
'Expresa sus gustos, intereses, emociones y sentimientos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 1), 2,
'Reconoce que cada persona es diferente y tiene características propias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 1), 3,
'Manifiesta orgullo por quién es y respeto por sí mismo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 1), 4,
'Muestra actitudes de aceptación y valoración de las diferencias.');

-- DBA 2: Reconocimiento de otros como personas con derechos y deberes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 4, 2,
'Reconocimiento de otros como personas con derechos y deberes',
'Reconoce a los demás como personas con los mismos derechos y deberes.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 2), 1,
'Identifica semejanzas y diferencias entre él y sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 2), 2,
'Escucha y respeta las ideas y sentimientos de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 2), 3,
'Participa en juegos y actividades grupales demostrando empatía y cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 2), 4,
'Reconoce la importancia de tratar bien a los otros.');

-- DBA 3: Participación en vida escolar con normas de convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 4, 3,
'Participación en vida escolar con normas de convivencia',
'Participa en la vida escolar cumpliendo normas básicas de convivencia.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 3), 1,
'Conoce y respeta las normas del aula y la escuela.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 3), 2,
'Colabora en la organización y cuidado del entorno escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 3), 3,
'Participa en la elaboración de acuerdos de convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 3), 4,
'Comprende que las normas ayudan a vivir mejor con los demás.');

-- DBA 4: Identificación de conflictos con soluciones pacíficas dialogadas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 4, 4,
'Identificación de conflictos con soluciones pacíficas dialogadas',
'Identifica situaciones de conflicto y busca soluciones pacíficas con ayuda del diálogo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 4), 1,
'Reconoce emociones como la tristeza, el enojo y la alegría.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 4), 2,
'Explica con sus palabras lo que siente ante un conflicto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 4), 3,
'Escucha las opiniones de los demás para resolver diferencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 4), 4,
'Propone soluciones pacíficas a desacuerdos o problemas cotidianos.');

-- DBA 5: Actitudes de cuidado y respeto hacia demás y entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 4, 5,
'Actitudes de cuidado y respeto hacia demás y entorno',
'Demuestra actitudes de cuidado y respeto hacia los demás y hacia el entorno.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 5), 1,
'Cuida los objetos personales y los de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 5), 2,
'Evita conductas que dañen a otros o al ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 5), 3,
'Participa en acciones de limpieza y orden en el aula.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 4 AND numero_dba = 5), 4,
'Explica la importancia de cuidar a las personas, los animales y la naturaleza.');

-- Ética y Valores Humanos (id_asignatura = 6) y 2° grado (id_grado = 5)

-- DBA 1: Reconocimiento como parte de familia y comunidad escolar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 5, 1,
'Reconocimiento como parte de familia y comunidad escolar',
'Se reconoce como parte de su familia y de la comunidad escolar, comprendiendo que tiene derechos y deberes que debe cumplir en los diferentes espacios sociales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 1), 1,
'Describe su papel dentro de la familia y la escuela.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 1), 2,
'Identifica algunos de sus derechos y deberes en el hogar y en la escuela.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 1), 3,
'Participa activamente en las actividades familiares y escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 1), 4,
'Comprende la importancia de cumplir con sus responsabilidades.');

-- DBA 2: Reconocimiento y valoración de la diversidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 5, 2,
'Reconocimiento y valoración de la diversidad',
'Reconoce y valora las diferencias personales, culturales y sociales de las personas con las que interactúa, desarrollando una actitud de respeto y aceptación hacia la diversidad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 2), 1,
'Reconoce diferencias en las costumbres, tradiciones y formas de vida de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 2), 2,
'Respeta y valora las diferencias físicas, culturales y de opinión de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 2), 3,
'Participa en actividades que celebran la diversidad cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 2), 4,
'Demuestra actitudes de aceptación hacia personas de diferentes grupos sociales o culturales.');

-- DBA 3: Construcción de normas y convivencia democrática
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 5, 3,
'Construcción de normas y convivencia democrática',
'Comprende la importancia de las normas y los acuerdos para la convivencia pacífica, participando activamente en su construcción y cumplimiento en el ámbito escolar.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 3), 1,
'Participa en la construcción colectiva de normas y acuerdos de convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 3), 2,
'Cumple los acuerdos establecidos y ayuda a otros a cumplirlos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 3), 3,
'Comprende que las normas son necesarias para la convivencia armónica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 3), 4,
'Propone modificaciones a las normas cuando es necesario para mejorar la convivencia.');

-- DBA 4: Mediación y resolución de conflictos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 5, 4,
'Mediación y resolución de conflictos',
'Identifica conflictos en su entorno inmediato y propone soluciones pacíficas y respetuosas, utilizando el diálogo como herramienta fundamental para la resolución de diferencias.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica situaciones de conflicto en el aula y el recreo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 4), 2,
'Escucha atentamente las diferentes versiones de un conflicto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 4), 3,
'Propone alternativas de solución que beneficien a todas las partes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 4), 4,
'Utiliza el diálogo y la negociación para resolver diferencias.');

-- DBA 5: Cuidado y responsabilidad social y ambiental
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 5, 5,
'Cuidado y responsabilidad social y ambiental',
'Desarrolla actitudes de cuidado hacia los demás y el entorno natural y social, asumiendo responsabilidades acordes con su edad y contexto.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 5), 1,
'Participa en campañas de cuidado del medio ambiente escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 5), 2,
'Ayuda a compañeros que lo necesitan y participa en acciones solidarias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 5), 3,
'Cuida los espacios comunes y los recursos de la escuela.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 5 AND numero_dba = 5), 4,
'Explica por qué es importante cuidar el entorno y ayudar a otros.');

-- Ética y Valores Humanos (id_asignatura = 6) y 3° grado (id_grado = 6)

-- DBA 1: Reconocimiento como persona con dignidad, derechos y deberes
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 6, 1,
'Reconocimiento como persona con dignidad, derechos y deberes',
'Se reconoce como persona con dignidad, derechos y deberes, capaz de tomar decisiones y asumir las consecuencias de sus actos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 1), 1,
'Identifica sus principales derechos y deberes como niño o niña.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 1), 2,
'Toma decisiones sencillas y explica por qué las tomó.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 1), 3,
'Reconoce las consecuencias de sus decisiones y acepta su responsabilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 1), 4,
'Comprende que todas las personas tienen dignidad y merecen respeto.');

-- DBA 2: Reconocimiento y valoración de diversidad cultural, social y religiosa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 6, 2,
'Reconocimiento y valoración de diversidad cultural, social y religiosa',
'Reconoce y valora la diversidad cultural, social y religiosa de su comunidad, desarrollando actitudes de respeto y tolerancia hacia las diferencias.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 2), 1,
'Identifica diferentes culturas, religiones y formas de vida en su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 2), 2,
'Respeta las creencias y costumbres de personas de diferentes grupos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 2), 3,
'Participa en actividades que promueven el intercambio cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 2), 4,
'Demuestra actitudes de tolerancia y respeto hacia la diversidad.');

-- DBA 3: Importancia de normas y valores para convivencia armónica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 6, 3,
'Importancia de normas y valores para convivencia armónica',
'Comprende la importancia de las normas y valores para la convivencia armónica, participando activamente en su aplicación y mejoramiento.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 3), 1,
'Identifica valores como el respeto, la honestidad y la responsabilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 3), 2,
'Aplica valores en sus relaciones cotidianas con compañeros y familiares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 3), 3,
'Propone normas que favorezcan la convivencia armónica en el aula.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 3), 4,
'Explica cómo los valores contribuyen a mejorar las relaciones interpersonales.');

-- DBA 4: Identificación de conflictos aplicando diálogo como medio resolutivo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 6, 4,
'Identificación de conflictos aplicando diálogo como medio resolutivo',
'Identifica conflictos en diferentes contextos y aplica el diálogo como medio principal para encontrar soluciones pacíficas y justas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 4), 1,
'Identifica las causas de conflictos en el aula, la familia y la comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 4), 2,
'Utiliza estrategias de comunicación para expresar sus puntos de vista.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 4), 3,
'Busca soluciones que tengan en cuenta los intereses de las partes involucradas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 4), 4,
'Demuestra habilidades de escucha y comprensión en la resolución de conflictos.');

-- DBA 5: Actitudes de cuidado, responsabilidad y solidaridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 6, 5,
'Actitudes de cuidado, responsabilidad y solidaridad',
'Desarrolla actitudes de cuidado, responsabilidad y solidaridad hacia los demás y el entorno, asumiendo compromisos concretos para el bienestar común.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 5), 1,
'Participa en proyectos de mejoramiento de su entorno escolar y comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 5), 2,
'Demuestra solidaridad con compañeros que enfrentan dificultades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 5), 3,
'Asume responsabilidades en el cuidado de espacios y recursos comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 6 AND numero_dba = 5), 4,
'Propone acciones concretas para ayudar a otros y cuidar el ambiente.');

-- Ética y Valores Humanos (id_asignatura = 6) y 4° grado (id_grado = 7)

-- DBA 1: Reconocimiento como persona autónoma capaz de decisiones responsables
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 7, 1,
'Reconocimiento como persona autónoma capaz de decisiones responsables',
'Se reconoce como persona autónoma, capaz de tomar decisiones responsables en situaciones cotidianas, considerando las consecuencias de sus actos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 1), 1,
'Toma decisiones autónomas en actividades académicas y sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 1), 2,
'Analiza las posibles consecuencias antes de tomar una decisión importante.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 1), 3,
'Asume la responsabilidad de sus decisiones sin culpar a otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 1), 4,
'Demuestra creciente independencia en el manejo de sus responsabilidades.');

-- DBA 2: Reconocimiento de importancia del respeto, justicia y solidaridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 7, 2,
'Reconocimiento de importancia del respeto, justicia y solidaridad',
'Reconoce la importancia del respeto, la justicia y la solidaridad en la convivencia, aplicando estos valores en sus relaciones interpersonales.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 2), 1,
'Identifica situaciones donde se aplican o se vulneran los valores de respeto, justicia y solidaridad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 2), 2,
'Actúa con justicia al mediar en conflictos entre compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 2), 3,
'Demuestra solidaridad hacia personas que enfrentan dificultades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 2), 4,
'Respeta las diferencias de opinión y los derechos de los demás.');

-- DBA 3: Comprensión de función de normas y acuerdos en convivencia pacífica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 7, 3,
'Comprensión de función de normas y acuerdos en convivencia pacífica',
'Comprende la función de las normas y acuerdos en la construcción de una convivencia pacífica, participando activamente en su elaboración y seguimiento.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 3), 1,
'Participa en la elaboración democrática de normas para diferentes espacios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 3), 2,
'Comprende que las normas deben ser justas y beneficiar a todos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 3), 3,
'Ayuda a hacer cumplir los acuerdos establecidos de manera respetuosa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 3), 4,
'Propone modificaciones a las normas cuando no funcionan adecuadamente.');

-- DBA 4: Identificación de conflictos aplicando estrategias de diálogo y mediación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 7, 4,
'Identificación de conflictos aplicando estrategias de diálogo y mediación',
'Identifica conflictos en diferentes contextos y aplica estrategias de diálogo y mediación para encontrar soluciones constructivas y duraderas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 4), 1,
'Analiza las causas profundas de los conflictos más allá de los síntomas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 4), 2,
'Actúa como mediador imparcial en conflictos entre compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 4), 3,
'Utiliza técnicas de comunicación asertiva para expresar desacuerdos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 4), 4,
'Busca soluciones creativas que satisfagan las necesidades de las partes.');

-- DBA 5: Actitudes de cuidado, empatía y compromiso con el bienestar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 7, 5,
'Actitudes de cuidado, empatía y compromiso con el bienestar',
'Desarrolla actitudes de cuidado, empatía y compromiso con el bienestar de los demás y del entorno, participando en acciones que promuevan el bien común.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 5), 1,
'Reconoce y comprende los sentimientos y necesidades de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 5), 2,
'Participa en proyectos comunitarios que benefician a otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 5), 3,
'Asume compromisos concretos para el cuidado del medio ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 7 AND numero_dba = 5), 4,
'Demuestra constancia en el cumplimiento de sus compromisos sociales y ambientales.');

-- Ética y Valores Humanos (id_asignatura = 6) y 5° grado (id_grado = 8)

-- DBA 1: Reconocimiento como persona libre y responsable capaz de actuar según principios
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 8, 1,
'Reconocimiento como persona libre y responsable capaz de actuar según principios',
'Se reconoce como persona libre y responsable, capaz de actuar según principios y valores éticos, tomando decisiones autónomas y coherentes.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica sus valores personales y explica cómo guían sus decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 1), 2,
'Toma decisiones coherentes con sus principios éticos, aún en situaciones difíciles.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 1), 3,
'Reflexiona críticamente sobre las consecuencias de sus actos y aprende de sus errores.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 1), 4,
'Demuestra autonomía moral en sus juicios y comportamientos.');

-- DBA 2: Reconocimiento de importancia del respeto, justicia, solidaridad y tolerancia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 8, 2,
'Reconocimiento de importancia del respeto, justicia, solidaridad y tolerancia',
'Reconoce la importancia del respeto, la justicia, la solidaridad y la tolerancia en la convivencia, promoviendo estos valores en su comunidad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 2), 1,
'Promueve activamente el respeto y la tolerancia hacia la diversidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 2), 2,
'Identifica y denuncia situaciones de injusticia en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 2), 3,
'Organiza o participa en actividades solidarias para ayudar a otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 2), 4,
'Demuestra liderazgo en la promoción de valores democráticos.');

-- DBA 3: Comprensión de normas y acuerdos para convivencia democrática
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 8, 3,
'Comprensión de normas y acuerdos para convivencia democrática',
'Comprende el papel de las normas y acuerdos en la construcción de una convivencia democrática, participando activamente en procesos de toma de decisiones colectivas.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 3), 1,
'Participa en procesos democráticos de elección y toma de decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 3), 2,
'Comprende los principios básicos de la democracia y los derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 3), 3,
'Propone reformas o mejoras a las normas existentes basándose en principios de justicia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 3), 4,
'Respeta las decisiones tomadas democráticamente aunque no esté de acuerdo con ellas.');

-- DBA 4: Identificación de conflictos como oportunidades para aprender a convivir
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 8, 4,
'Identificación de conflictos como oportunidades para aprender a convivir',
'Identifica los conflictos como oportunidades para aprender a convivir mejor, aplicando estrategias avanzadas de resolución pacífica y construcción de acuerdos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 4), 1,
'Ve los conflictos como oportunidades de crecimiento y aprendizaje mutuo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 4), 2,
'Facilita procesos de reconciliación después de resolver conflictos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 4), 3,
'Utiliza estrategias de comunicación no violenta para prevenir y resolver conflictos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 4), 4,
'Construye acuerdos duraderos que fortalecen las relaciones interpersonales.');

-- DBA 5: Actitudes de cuidado, compromiso y solidaridad con personas y ambiente
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 8, 5,
'Actitudes de cuidado, compromiso y solidaridad con personas y ambiente',
'Desarrolla actitudes de cuidado, compromiso y solidaridad con las personas y el ambiente, liderando iniciativas que promuevan el desarrollo sostenible y el bienestar colectivo.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 5), 1,
'Lidera proyectos de desarrollo sostenible en su comunidad educativa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 5), 2,
'Demuestra compromiso constante con causas sociales y ambientales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 5), 3,
'Inspira a otros a participar en acciones de cuidado y responsabilidad social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 8 AND numero_dba = 5), 4,
'Evalúa críticamente el impacto de sus acciones en el bienestar de otros y del planeta.');

-- Ética y Valores Humanos (id_asignatura = 6) y 6° grado (id_grado = 9)

-- DBA 1: Reconocimiento como persona autónoma con capacidades, sentimientos y valores
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 9, 1,
'Reconocimiento como persona autónoma con capacidades, sentimientos y valores',
'Se reconoce como persona autónoma, con capacidades, sentimientos y valores que orientan sus decisiones y acciones.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica sus fortalezas, debilidades y emociones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 1), 2,
'Explica cómo sus valores influyen en sus decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 1), 3,
'Manifiesta seguridad en sí mismo y respeto hacia los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 1), 4,
'Toma decisiones personales de manera responsable.');

-- DBA 2: Importancia del respeto, empatía, justicia y solidaridad en relaciones interpersonales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 9, 2,
'Importancia del respeto, empatía, justicia y solidaridad en relaciones interpersonales',
'Reconoce la importancia del respeto, la empatía, la justicia y la solidaridad en las relaciones interpersonales.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 2), 1,
'Escucha y valora las opiniones de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 2), 2,
'Reconoce las consecuencias de sus actos sobre otras personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 2), 3,
'Participa activamente en actividades grupales de forma justa y cooperativa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 2), 4,
'Promueve el respeto y la igualdad en la convivencia diaria.');

-- DBA 3: Comprensión de normas y valores como acuerdos sociales para convivencia democrática
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 9, 3,
'Comprensión de normas y valores como acuerdos sociales para convivencia democrática',
'Comprende que las normas y valores son acuerdos sociales que orientan la convivencia democrática.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 3), 1,
'Explica el sentido y la necesidad de las normas en la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 3), 2,
'Cumple con los acuerdos y reglas en diferentes espacios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 3), 3,
'Reconoce la importancia de la justicia y la equidad en las normas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 3), 4,
'Participa en la formulación de normas para mejorar la convivencia.');

-- DBA 4: Identificación de conflictos aplicando estrategias de resolución pacífica y diálogo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 9, 4,
'Identificación de conflictos aplicando estrategias de resolución pacífica y diálogo',
'Identifica conflictos en su entorno y aplica estrategias de resolución pacífica y diálogo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 4), 1,
'Reconoce situaciones de conflicto en su vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 4), 2,
'Analiza las causas de los conflictos y sus consecuencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 4), 3,
'Propone soluciones mediante el diálogo, la mediación y la empatía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 4), 4,
'Evita la violencia y promueve la convivencia pacífica.');

-- DBA 5: Actitudes de cuidado, responsabilidad y compromiso con entorno social y ambiental
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 9, 5,
'Actitudes de cuidado, responsabilidad y compromiso con entorno social y ambiental',
'Demuestra actitudes de cuidado, responsabilidad y compromiso con su entorno social y ambiental.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 5), 1,
'Participa en actividades de protección y mejora del ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 5), 2,
'Colabora en proyectos de ayuda a la comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 5), 3,
'Reflexiona sobre las consecuencias de sus acciones en el entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 9 AND numero_dba = 5), 4,
'Propone alternativas para el bienestar común y el equilibrio ambiental.');

-- Ética y Valores Humanos (id_asignatura = 6) y 7° grado (id_grado = 10)

-- DBA 1: Reconocimiento como persona libre y responsable capaz de orientar proyecto de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 10, 1,
'Reconocimiento como persona libre y responsable capaz de orientar proyecto de vida',
'Se reconoce como persona libre, responsable y capaz de orientar su proyecto de vida conforme a valores éticos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica sus metas personales y académicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 1), 2,
'Reconoce cómo sus decisiones influyen en su desarrollo y en el de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 1), 3,
'Explica la importancia de actuar de acuerdo con principios éticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 1), 4,
'Asume compromisos coherentes con su proyecto de vida.');

-- DBA 2: Valor de la empatía, tolerancia, justicia y solidaridad en relaciones humanas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 10, 2,
'Valor de la empatía, tolerancia, justicia y solidaridad en relaciones humanas',
'Reconoce el valor de la empatía, la tolerancia, la justicia y la solidaridad en las relaciones humanas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 2), 1,
'Escucha activamente y respeta las opiniones diferentes a las suyas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 2), 2,
'Participa en actividades grupales con sentido de equidad y cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 2), 3,
'Explica cómo la empatía y la solidaridad fortalecen la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 2), 4,
'Promueve la ayuda mutua y el respeto en su comunidad educativa.');

-- DBA 3: Comprensión de normas, derechos y deberes fundamentales para convivencia democrática
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 10, 3,
'Comprensión de normas, derechos y deberes fundamentales para convivencia democrática',
'Comprende que las normas, los derechos y los deberes son fundamentales para la convivencia democrática.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 3), 1,
'Reconoce la importancia de los derechos humanos en la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 3), 2,
'Explica cómo las normas garantizan la convivencia y la justicia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 3), 3,
'Cumple con sus deberes y responsabilidades como estudiante y ciudadano.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 3), 4,
'Propone acciones para fortalecer la participación y la equidad.');

-- DBA 4: Identificación de conflictos aplicando estrategias de mediación, diálogo y consenso
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 10, 4,
'Identificación de conflictos aplicando estrategias de mediación, diálogo y consenso',
'Identifica conflictos en su entorno y aplica estrategias de mediación, diálogo y consenso para resolverlos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 4), 1,
'Analiza las causas y consecuencias de los conflictos en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 4), 2,
'Utiliza el diálogo y la escucha como herramientas de solución.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 4), 3,
'Reconoce la importancia del respeto y la empatía al resolver desacuerdos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 4), 4,
'Promueve actitudes pacíficas y de cooperación en los grupos a los que pertenece.');

-- DBA 5: Actitudes de responsabilidad, compromiso social y cuidado del ambiente
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 10, 5,
'Actitudes de responsabilidad, compromiso social y cuidado del ambiente',
'Demuestra actitudes de responsabilidad, compromiso social y cuidado del ambiente.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 5), 1,
'Participa en proyectos ambientales y sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 5), 2,
'Reflexiona sobre el impacto de sus acciones en la comunidad y la naturaleza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 5), 3,
'Propone soluciones a problemas ambientales y de convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 10 AND numero_dba = 5), 4,
'Promueve valores de respeto, equidad y solidaridad en su entorno.');

-- Ética y Valores Humanos (id_asignatura = 6) y 8° grado (id_grado = 11)

-- DBA 1: Reconocimiento como persona con identidad, autonomía y capacidad para construir proyecto de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 11, 1,
'Reconocimiento como persona con identidad, autonomía y capacidad para construir proyecto de vida',
'Se reconoce como persona con identidad, autonomía y capacidad para construir un proyecto de vida basado en principios éticos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 1), 1,
'Identifica sus intereses, habilidades y metas personales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 1), 2,
'Explica cómo sus decisiones influyen en su proyecto de vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 1), 3,
'Reconoce la importancia de la coherencia entre pensar, decir y actuar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 1), 4,
'Toma decisiones responsables acordes con sus valores.');

-- DBA 2: Importancia de empatía, justicia y solidaridad en construcción de relaciones humanas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 11, 2,
'Importancia de empatía, justicia y solidaridad en construcción de relaciones humanas',
'Reconoce la importancia de la empatía, la justicia y la solidaridad en la construcción de relaciones humanas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 2), 1,
'Analiza situaciones en las que se aplican los valores de justicia y respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 2), 2,
'Propone acciones que promueven la solidaridad y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 2), 3,
'Participa en actividades que fortalecen la convivencia escolar y social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 2), 4,
'Reconoce el valor del respeto hacia las diferencias personales y culturales.');

-- DBA 3: Comprensión de derechos humanos como principios fundamentales para vida en comunidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 11, 3,
'Comprensión de derechos humanos como principios fundamentales para vida en comunidad',
'Comprende que los derechos humanos son principios fundamentales para la vida en comunidad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 3), 1,
'Identifica los derechos humanos y su aplicación en la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 3), 2,
'Reconoce situaciones en las que se vulneran los derechos de las personas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 3), 3,
'Propone acciones para proteger y promover los derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 3), 4,
'Participa activamente en espacios de convivencia democrática.');

-- DBA 4: Análisis de conflictos proponiendo soluciones basadas en diálogo, respeto y cooperación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 11, 4,
'Análisis de conflictos proponiendo soluciones basadas en diálogo, respeto y cooperación',
'Analiza los conflictos y propone soluciones basadas en el diálogo, el respeto y la cooperación.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 4), 1,
'Reconoce las causas y consecuencias de los conflictos en distintos contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 4), 2,
'Emplea estrategias de diálogo y mediación para resolver diferencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 4), 3,
'Promueve el trabajo colaborativo en la solución de problemas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 4), 4,
'Valora la paz y la convivencia como logros colectivos.');

-- DBA 5: Compromiso ético y social con cuidado de los demás y del ambiente
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 11, 5,
'Compromiso ético y social con cuidado de los demás y del ambiente',
'Demuestra compromiso ético y social con el cuidado de los demás y del ambiente.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 5), 1,
'Participa en actividades de servicio y apoyo comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 5), 2,
'Reflexiona sobre el impacto de la acción humana en la naturaleza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 5), 3,
'Propone alternativas de consumo responsable y protección ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 11 AND numero_dba = 5), 4,
'Promueve la solidaridad, la equidad y la sostenibilidad en su entorno.');

-- Ética y Valores Humanos (id_asignatura = 6) y 9° grado (id_grado = 12)

-- DBA 1: Reconocimiento como persona autónoma capaz de orientar proyecto de vida según principios éticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 12, 1,
'Reconocimiento como persona autónoma capaz de orientar proyecto de vida según principios éticos',
'Se reconoce como persona autónoma, con capacidad para orientar su proyecto de vida de acuerdo con principios éticos y de responsabilidad social.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 1), 1,
'Identifica los valores que orientan su proyecto de vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 1), 2,
'Explica cómo sus decisiones influyen en su bienestar y en el de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 1), 3,
'Asume compromisos personales y sociales con coherencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 1), 4,
'Evalúa críticamente sus acciones y decisiones a la luz de los valores éticos.');

-- DBA 2: Importancia del respeto, equidad, justicia y solidaridad en construcción de relaciones humanas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 12, 2,
'Importancia del respeto, equidad, justicia y solidaridad en construcción de relaciones humanas',
'Reconoce la importancia del respeto, la equidad, la justicia y la solidaridad en la construcción de relaciones humanas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 2), 1,
'Analiza situaciones en las que se aplican o vulneran los valores éticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 2), 2,
'Participa en actividades que promueven la equidad, la cooperación y el respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 2), 3,
'Promueve el diálogo como herramienta para resolver conflictos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 2), 4,
'Valora la diversidad y rechaza toda forma de discriminación.');

-- DBA 3: Comprensión de importancia de derechos humanos y participación ciudadana en construcción de sociedad justa
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 12, 3,
'Comprensión de importancia de derechos humanos y participación ciudadana en construcción de sociedad justa',
'Comprende la importancia de los derechos humanos y la participación ciudadana en la construcción de una sociedad justa y democrática.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 3), 1,
'Identifica los derechos y deberes ciudadanos en contextos reales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 3), 2,
'Explica la relación entre derechos humanos, justicia y democracia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 3), 3,
'Propone acciones de participación que favorezcan la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 3), 4,
'Promueve el respeto por los derechos de los demás en su entorno escolar y comunitario.');

-- DBA 4: Análisis de conflictos personales y sociales aplicando principios éticos, diálogo y cooperación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 12, 4,
'Análisis de conflictos personales y sociales aplicando principios éticos, diálogo y cooperación',
'Analiza conflictos personales y sociales aplicando principios éticos, diálogo y cooperación.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 4), 1,
'Reconoce conflictos en los ámbitos familiar, escolar o social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 4), 2,
'Analiza las causas y consecuencias de los conflictos desde una perspectiva ética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 4), 3,
'Emplea estrategias de diálogo, negociación y mediación para resolverlos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 4), 4,
'Promueve actitudes pacíficas y solidarias frente a las diferencias.');

-- DBA 5: Compromiso ético y responsabilidad frente al ambiente y la comunidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 12, 5,
'Compromiso ético y responsabilidad frente al ambiente y la comunidad',
'Demuestra compromiso ético y responsabilidad frente al ambiente y la comunidad.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 5), 1,
'Participa en actividades de servicio social o ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 5), 2,
'Reflexiona sobre las implicaciones éticas del consumo y el uso de los recursos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 5), 3,
'Propone acciones que contribuyan al bienestar común.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 12 AND numero_dba = 5), 4,
'Promueve el respeto, la equidad y la sostenibilidad en su comunidad educativa.');

-- Ética y Valores Humanos (id_asignatura = 6) y 10° grado (id_grado = 13)

-- DBA 1: Reconocimiento como persona autónoma capaz de decisiones libres y responsables en coherencia con valores éticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 13, 1,
'Reconocimiento como persona autónoma capaz de decisiones libres y responsables en coherencia con valores éticos',
'Se reconoce como persona autónoma, capaz de tomar decisiones libres y responsables en coherencia con sus valores y principios éticos.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 1), 1,
'Identifica los valores que orientan su conducta y decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 1), 2,
'Explica la relación entre libertad, responsabilidad y ética.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 1), 3,
'Evalúa críticamente las consecuencias de sus acciones personales y sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 1), 4,
'Asume compromisos coherentes con su proyecto de vida.');

-- DBA 2: Importancia de valores universales como justicia, equidad, solidaridad y paz en convivencia humana
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 13, 2,
'Importancia de valores universales como justicia, equidad, solidaridad y paz en convivencia humana',
'Reconoce la importancia de los valores universales como la justicia, la equidad, la solidaridad y la paz en la convivencia humana.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 2), 1,
'Analiza situaciones de la vida cotidiana en las que se practican o vulneran los valores éticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 2), 2,
'Propone soluciones justas y equitativas ante conflictos o injusticias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 2), 3,
'Promueve actitudes de respeto, empatía y cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 2), 4,
'Participa en actividades que fomentan la cultura de la paz.');

-- DBA 3: Comprensión de derechos humanos y participación ciudadana fortaleciendo vida democrática
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 13, 3,
'Comprensión de derechos humanos y participación ciudadana fortaleciendo vida democrática',
'Comprende que los derechos humanos y la participación ciudadana fortalecen la vida democrática.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 3), 1,
'Identifica los derechos fundamentales y su aplicación en la vida escolar y social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 3), 2,
'Explica la importancia de la participación ciudadana en la democracia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 3), 3,
'Promueve el respeto y cumplimiento de los derechos y deberes en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 3), 4,
'Propone acciones que fortalecen la justicia y la convivencia democrática.');

-- DBA 4: Análisis de conflictos sociales desde perspectiva ética proponiendo soluciones pacíficas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 13, 4,
'Análisis de conflictos sociales desde perspectiva ética proponiendo soluciones pacíficas',
'Analiza los conflictos sociales desde una perspectiva ética y propone soluciones pacíficas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 4), 1,
'Reconoce conflictos sociales actuales y sus implicaciones éticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 4), 2,
'Explica las causas estructurales de los conflictos en la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 4), 3,
'Aplica estrategias de diálogo, mediación y concertación en situaciones de conflicto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 4), 4,
'Promueve la reconciliación, la justicia y la convivencia pacífica.');

-- DBA 5: Compromiso ético con sostenibilidad, justicia social y bien común
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 13, 5,
'Compromiso ético con sostenibilidad, justicia social y bien común',
'Demuestra compromiso ético con la sostenibilidad, la justicia social y el bien común.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 5), 1,
'Participa en proyectos que promueven la equidad, la sostenibilidad y la paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 5), 2,
'Reflexiona sobre el impacto ético de sus decisiones frente al ambiente y la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 5), 3,
'Propone acciones que favorecen el bienestar común.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 13 AND numero_dba = 5), 4,
'Promueve la corresponsabilidad y el respeto por todas las formas de vida.');

-- Ética y Valores Humanos (id_asignatura = 6) y 11° grado (id_grado = 14)

-- DBA 1: Reconocimiento como persona libre, responsable y comprometida con proyecto de vida y transformación positiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 14, 1,
'Reconocimiento como persona libre, responsable y comprometida con proyecto de vida y transformación positiva',
'Se reconoce como persona libre, responsable y comprometida con su proyecto de vida y con la transformación positiva de su entorno.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 1), 1,
'Define su proyecto de vida con base en sus valores, intereses y metas personales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 1), 2,
'Evalúa las implicaciones éticas de sus decisiones y acciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 1), 3,
'Actúa con coherencia y responsabilidad en diferentes contextos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 1), 4,
'Promueve el respeto, la solidaridad y la justicia en su comunidad.');

-- DBA 2: Importancia de valores universales y derechos humanos como fundamento de convivencia y paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 14, 2,
'Importancia de valores universales y derechos humanos como fundamento de convivencia y paz',
'Reconoce la importancia de los valores universales y los derechos humanos como fundamento de la convivencia y la paz.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 2), 1,
'Analiza problemáticas sociales desde una perspectiva ética y de derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 2), 2,
'Promueve la defensa y práctica de los derechos humanos en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 2), 3,
'Participa en iniciativas que fomentan la equidad, la paz y la justicia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 2), 4,
'Argumenta éticamente frente a situaciones de discriminación o violencia.');

-- DBA 3: Comprensión de ética orientando acciones hacia bien común y responsabilidad social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 14, 3,
'Comprensión de ética orientando acciones hacia bien común y responsabilidad social',
'Comprende que la ética orienta las acciones humanas hacia el bien común y la responsabilidad social.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 3), 1,
'Explica la relación entre ética, política y ciudadanía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 3), 2,
'Analiza dilemas éticos y plantea alternativas responsables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 3), 3,
'Reflexiona sobre el papel del ciudadano en la construcción de una sociedad justa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 3), 4,
'Promueve el compromiso social, el respeto y la cooperación en su comunidad.');

-- DBA 4: Análisis de conflictos personales, sociales y globales aplicando principios éticos, justicia y solidaridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 14, 4,
'Análisis de conflictos personales, sociales y globales aplicando principios éticos, justicia y solidaridad',
'Analiza los conflictos personales, sociales y globales aplicando principios éticos, justicia y solidaridad.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 4), 1,
'Identifica conflictos actuales en contextos locales y globales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 4), 2,
'Evalúa las causas y consecuencias éticas de los conflictos sociales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 4), 3,
'Propone alternativas de solución basadas en el diálogo y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 4), 4,
'Promueve la reconciliación, la equidad y el respeto en su entorno.');

-- DBA 5: Compromiso ético con desarrollo sostenible, justicia social y convivencia pacífica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(6, 14, 5,
'Compromiso ético con desarrollo sostenible, justicia social y convivencia pacífica',
'Demuestra compromiso ético con el desarrollo sostenible, la justicia social y la convivencia pacífica.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 5), 1,
'Participa en proyectos de servicio social o ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 5), 2,
'Reflexiona sobre la responsabilidad ética frente al uso de los recursos naturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 5), 3,
'Promueve la sostenibilidad y el respeto por la vida en todas sus formas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 6 AND id_grado = 14 AND numero_dba = 5), 4,
'Fomenta valores de paz, justicia y solidaridad en su entorno social.');

-- =============================================
-- EDUCACIÓN ARTÍSTICA
-- =============================================

-- Educación Artística (id_asignatura = 7) y 1° grado (id_grado = 4)

-- DBA 1: Exploración de materiales, sonidos, movimientos, colores y formas para expresar emociones y experiencias
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 4, 1,
'Exploración de materiales, sonidos, movimientos, colores y formas para expresar emociones y experiencias',
'Explora diferentes materiales, sonidos, movimientos, colores y formas para expresar emociones y experiencias.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 1), 1,
'Manipula libremente materiales como pinturas, crayones, plastilina, papel o instrumentos sencillos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 1), 2,
'Utiliza la voz, el cuerpo o el dibujo para comunicar ideas y sentimientos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 1), 3,
'Experimenta con sonidos, movimientos y colores en sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 1), 4,
'Disfruta el proceso creativo y comparte sus resultados con los demás.');

-- DBA 2: Reconocimiento de elementos del entorno como fuente de inspiración para creación artística
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 4, 2,
'Reconocimiento de elementos del entorno como fuente de inspiración para creación artística',
'Reconoce elementos del entorno natural, social y cultural como fuente de inspiración para la creación artística.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 2), 1,
'Observa su entorno e identifica colores, sonidos, texturas y formas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 2), 2,
'Representa mediante dibujos o movimientos elementos del ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 2), 3,
'Participa en actividades que integran el arte con la vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 2), 4,
'Explica con sus palabras qué quiso expresar en sus creaciones.');

-- DBA 3: Participación en actividades artísticas colectivas con respeto, cooperación y sentido de pertenencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 4, 3,
'Participación en actividades artísticas colectivas con respeto, cooperación y sentido de pertenencia',
'Participa en actividades artísticas colectivas demostrando respeto, cooperación y sentido de pertenencia.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 3), 1,
'Colabora con sus compañeros en juegos, canciones o representaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 3), 2,
'Escucha y respeta las ideas de los demás durante la creación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 3), 3,
'Reconoce la importancia del trabajo en grupo para realizar obras artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 3), 4,
'Muestra interés por participar en actividades culturales de la escuela.');

-- DBA 4: Reconocimiento y apreciación de manifestaciones artísticas y culturales del entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 4, 4,
'Reconocimiento y apreciación de manifestaciones artísticas y culturales del entorno',
'Reconoce y aprecia manifestaciones artísticas y culturales de su entorno.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 4), 1,
'Observa obras, canciones o danzas de su región.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 4), 2,
'Expresa lo que siente o piensa frente a manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 4), 3,
'Identifica expresiones culturales propias de su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 4), 4,
'Demuestra respeto por las manifestaciones artísticas de los demás.');

-- DBA 5: Uso del arte como medio de expresión de emociones, ideas y experiencias personales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 4, 5,
'Uso del arte como medio de expresión de emociones, ideas y experiencias personales',
'Utiliza el arte como medio para expresar emociones, ideas y experiencias personales.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 5), 1,
'Representa mediante el dibujo, la música o el movimiento sus emociones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 5), 2,
'Comunica experiencias cotidianas a través del arte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 5), 3,
'Explica el significado de sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 4 AND numero_dba = 5), 4,
'Muestra satisfacción por compartir su expresión artística.');

-- Educación Artística (id_asignatura = 7) y 2° grado (id_grado = 5)

-- DBA 1: Exploración y combinación de materiales, sonidos, colores, formas y movimientos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 5, 1,
'Exploración y combinación de materiales, sonidos, colores, formas y movimientos',
'Explora y combina materiales, sonidos, colores, formas y movimientos para representar ideas, emociones y experiencias.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 1), 1,
'Utiliza diferentes materiales y técnicas en sus creaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 1), 2,
'Experimenta con sonidos, ritmos, movimientos y colores para expresar emociones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 1), 3,
'Representa elementos de su entorno a través del dibujo, la música o el movimiento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 1), 4,
'Disfruta y comparte sus experiencias artísticas con sus compañeros.');

-- DBA 2: Reconocimiento de elementos básicos del lenguaje artístico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 5, 2,
'Reconocimiento de elementos básicos del lenguaje artístico',
'Reconoce los elementos básicos del lenguaje artístico (línea, forma, color, ritmo, sonido, movimiento).');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 2), 1,
'Identifica los elementos visuales y sonoros en obras propias y ajenas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 2), 2,
'Usa conscientemente líneas, colores, sonidos o movimientos en sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 2), 3,
'Describe los efectos que producen los diferentes elementos del lenguaje artístico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 2), 4,
'Participa en actividades que integran varios lenguajes expresivos.');

-- DBA 3: Participación en procesos de creación colectiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 5, 3,
'Participación en procesos de creación colectiva',
'Participa en procesos de creación colectiva, mostrando disposición para el trabajo en grupo.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 3), 1,
'Coopera con sus compañeros en actividades artísticas grupales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 3), 2,
'Aporta ideas y materiales para la realización de obras o presentaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 3), 3,
'Respeta las opiniones y aportes de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 3), 4,
'Reconoce el valor del trabajo en equipo en la creación artística.');

-- DBA 4: Reconocimiento y apreciación de manifestaciones artísticas regionales y nacionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 5, 4,
'Reconocimiento y apreciación de manifestaciones artísticas regionales y nacionales',
'Reconoce y aprecia manifestaciones artísticas y culturales de su región y del país.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 4), 1,
'Identifica canciones, danzas, imágenes o tradiciones culturales locales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 4), 2,
'Participa en actividades artísticas relacionadas con celebraciones culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 4), 3,
'Explica con sus palabras lo que observa o escucha en manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 4), 4,
'Demuestra respeto por las expresiones artísticas de su entorno.');

-- DBA 5: Uso del arte como medio de comunicación y expresión personal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 5, 5,
'Uso del arte como medio de comunicación y expresión personal',
'Utiliza el arte como medio de comunicación y expresión personal.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 5), 1,
'Comunica ideas o sentimientos a través de producciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 5), 2,
'Relata experiencias personales mediante el dibujo, el movimiento o la música.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 5), 3,
'Comparte con sus compañeros el sentido de sus obras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 5 AND numero_dba = 5), 4,
'Muestra seguridad y agrado al expresarse por medio del arte.');

-- Educación Artística (id_asignatura = 7) y 3° grado (id_grado = 6)

-- DBA 1: Exploración de materiales, técnicas, sonidos, movimientos y colores para expresión personal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 6, 1,
'Exploración de materiales, técnicas, sonidos, movimientos y colores para expresión personal',
'Explora materiales, técnicas, sonidos, movimientos y colores para expresar emociones, ideas y experiencias personales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 1), 1,
'Utiliza diferentes materiales y técnicas artísticas de manera creativa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 1), 2,
'Experimenta con ritmos, melodías, gestos y movimientos corporales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 1), 3,
'Expresa emociones e ideas por medio del dibujo, la música, la danza o el teatro.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 1), 4,
'Disfruta la exploración y comunica lo que siente a través del arte.');

-- DBA 2: Reconocimiento de elementos básicos del lenguaje visual, musical y corporal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 6, 2,
'Reconocimiento de elementos básicos del lenguaje visual, musical y corporal',
'Reconoce los elementos básicos del lenguaje visual, musical y corporal en producciones propias y ajenas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 2), 1,
'Identifica formas, colores, texturas, sonidos y movimientos en obras artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 2), 2,
'Describe los efectos que producen los diferentes elementos del lenguaje artístico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 2), 3,
'Aplica los elementos del lenguaje visual o sonoro en sus creaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 2), 4,
'Comenta lo que percibe y siente frente a manifestaciones artísticas.');

-- DBA 3: Participación en procesos de creación artística individual y colectiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 6, 3,
'Participación en procesos de creación artística individual y colectiva',
'Participa en procesos de creación artística individual y colectiva demostrando disposición, respeto y colaboración.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 3), 1,
'Aporta ideas y materiales en trabajos grupales de expresión artística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 3), 2,
'Respeta las opiniones y creaciones de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 3), 3,
'Colabora activamente en presentaciones, exposiciones o puestas en escena.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 3), 4,
'Reconoce la importancia del trabajo en equipo para crear arte.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas del entorno y otras regiones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 6, 4,
'Reconocimiento y valoración de manifestaciones artísticas del entorno y otras regiones',
'Reconoce y valora manifestaciones artísticas y culturales de su entorno y de otras regiones del país.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 4), 1,
'Identifica expresiones culturales locales y nacionales (danzas, músicas, artesanías, festividades).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 4), 2,
'Participa en actividades que promueven el conocimiento de las tradiciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 4), 3,
'Explica el significado cultural de algunas manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 4), 4,
'Muestra respeto por las expresiones culturales propias y ajenas.');

-- DBA 5: Uso del arte como medio de comunicación y reflexión sobre el entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 6, 5,
'Uso del arte como medio de comunicación y reflexión sobre el entorno',
'Utiliza el arte como medio de comunicación y reflexión sobre su entorno.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 5), 1,
'Representa situaciones cotidianas o ambientales a través de obras artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 5), 2,
'Explica lo que desea comunicar mediante su creación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 5), 3,
'Integra en sus obras elementos de su entorno y su cultura.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 6 AND numero_dba = 5), 4,
'Comparte sus producciones con actitud abierta y reflexiva.');

-- Educación Artística (id_asignatura = 7) y 4° grado (id_grado = 7)

-- DBA 1: Exploración, combinación y experimentación con materiales, técnicas, sonidos, movimientos y colores
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 7, 1,
'Exploración, combinación y experimentación con materiales, técnicas, sonidos, movimientos y colores',
'Explora, combina y experimenta con materiales, técnicas, sonidos, movimientos y colores para expresar ideas, emociones y experiencias.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 1), 1,
'Emplea diversas técnicas artísticas para expresar sentimientos y pensamientos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 1), 2,
'Combina colores, formas, sonidos o movimientos en producciones creativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 1), 3,
'Explica qué quiso comunicar con su obra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 1), 4,
'Demuestra gusto y seguridad al expresar su mundo interior mediante el arte.');

-- DBA 2: Reconocimiento y utilización de elementos del lenguaje visual, musical y corporal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 7, 2,
'Reconocimiento y utilización de elementos del lenguaje visual, musical y corporal',
'Reconoce y utiliza los elementos del lenguaje visual, musical y corporal en sus producciones artísticas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 2), 1,
'Identifica líneas, formas, colores, ritmo, melodía, movimiento y espacio en obras artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 2), 2,
'Usa conscientemente los elementos del lenguaje artístico en sus creaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 2), 3,
'Analiza cómo los elementos del lenguaje generan efectos expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 2), 4,
'Aplica los recursos artísticos para comunicar emociones e ideas.');

-- DBA 3: Participación en procesos de creación individual y colectiva con compromiso y colaboración
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 7, 3,
'Participación en procesos de creación individual y colectiva con compromiso y colaboración',
'Participa en procesos de creación individual y colectiva mostrando compromiso, respeto y colaboración.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 3), 1,
'Colabora en producciones grupales de arte (canciones, dramatizaciones, murales, etc.).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 3), 2,
'Escucha y valora las ideas de sus compañeros durante el proceso creativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 3), 3,
'Cumple con los compromisos adquiridos en actividades colectivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 3), 4,
'Reconoce el valor de la cooperación en la creación artística.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas de la comunidad y del país
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 7, 4,
'Reconocimiento y valoración de manifestaciones artísticas de la comunidad y del país',
'Reconoce y valora las manifestaciones artísticas y culturales de su comunidad y del país.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 4), 1,
'Identifica expresiones culturales propias de su región (danzas, músicas, artesanías, celebraciones).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 4), 2,
'Participa en actividades que promueven el reconocimiento de la cultura local y nacional.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 4), 3,
'Explica los significados culturales de las expresiones artísticas de su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 4), 4,
'Demuestra respeto y valoración por la diversidad cultural.');

-- DBA 5: Uso del arte como medio de comunicación, expresión y reflexión sobre la realidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 7, 5,
'Uso del arte como medio de comunicación, expresión y reflexión sobre la realidad',
'Utiliza el arte como medio de comunicación, expresión y reflexión sobre la realidad.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 5), 1,
'Representa hechos o situaciones sociales a través del arte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 5), 2,
'Explica el mensaje o la emoción que busca transmitir con su obra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 5), 3,
'Utiliza el arte para expresar opiniones sobre su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 7 AND numero_dba = 5), 4,
'Valora el arte como una forma de comunicación y transformación social.');

-- Educación Artística (id_asignatura = 7) y 5° grado (id_grado = 8)

-- DBA 1: Experimentación con materiales, técnicas, sonidos, movimientos y colores para expresión personal y colectiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 8, 1,
'Experimentación con materiales, técnicas, sonidos, movimientos y colores para expresión personal y colectiva',
'Experimenta con materiales, técnicas, sonidos, movimientos y colores para expresar ideas, emociones y vivencias personales o colectivas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 1), 1,
'Emplea diferentes materiales y recursos para la creación artística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 1), 2,
'Combina elementos del lenguaje visual, musical y corporal en sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 1), 3,
'Explica con sus palabras lo que desea expresar a través de su obra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 1), 4,
'Disfruta el proceso de creación individual y grupal.');

-- DBA 2: Reconocimiento y aplicación de elementos del lenguaje artístico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 8, 2,
'Reconocimiento y aplicación de elementos del lenguaje artístico',
'Reconoce y aplica los elementos del lenguaje artístico (color, forma, ritmo, textura, sonido, movimiento, espacio y tiempo) en sus producciones.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 2), 1,
'Identifica los elementos del lenguaje en producciones propias y ajenas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 2), 2,
'Usa conscientemente los recursos expresivos para comunicar emociones o ideas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 2), 3,
'Describe cómo los elementos artísticos generan distintos efectos estéticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 2), 4,
'Integra varios lenguajes artísticos en una misma creación.');

-- DBA 3: Participación activa en procesos de creación colectiva valorando el trabajo colaborativo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 8, 3,
'Participación activa en procesos de creación colectiva valorando el trabajo colaborativo',
'Participa activamente en procesos de creación colectiva, valorando el trabajo colaborativo.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 3), 1,
'Propone ideas para la elaboración de proyectos artísticos grupales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 3), 2,
'Colabora en tareas de planeación, producción y presentación de obras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 3), 3,
'Escucha y respeta las opiniones de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 3), 4,
'Reconoce la importancia de la cooperación y la corresponsabilidad en el arte.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y mundiales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 8, 4,
'Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y mundiales',
'Reconoce y valora las manifestaciones artísticas y culturales locales, nacionales y de otras regiones del mundo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 4), 1,
'Identifica diferentes expresiones artísticas y tradiciones culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 4), 2,
'Participa en actividades que promueven el conocimiento y respeto por la diversidad cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 4), 3,
'Explica el significado simbólico o social de las manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 4), 4,
'Muestra orgullo y respeto por la identidad cultural propia y la de los demás.');

-- DBA 5: Uso del arte como medio de comunicación, reflexión y transformación social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 8, 5,
'Uso del arte como medio de comunicación, reflexión y transformación social',
'Utiliza el arte como medio de comunicación, reflexión y transformación social.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 5), 1,
'Expresa opiniones o sentimientos sobre temas de interés social mediante el arte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 5), 2,
'Propone ideas creativas para mejorar su entorno a través de proyectos artísticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 5), 3,
'Explica cómo el arte puede contribuir al bienestar y la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 8 AND numero_dba = 5), 4,
'Promueve el respeto y la valoración del arte como expresión de identidad y cambio.');

-- Educación Artística (id_asignatura = 7) y 6° grado (id_grado = 9)

-- DBA 1: Exploración y experimentación con diversos materiales, técnicas y lenguajes artísticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 9, 1,
'Exploración y experimentación con diversos materiales, técnicas y lenguajes artísticos',
'Explora y experimenta con diversos materiales, técnicas y lenguajes artísticos para expresar sus ideas, emociones y percepciones del entorno.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 1), 1,
'Utiliza diferentes técnicas y recursos expresivos en la elaboración de sus obras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 1), 2,
'Aplica los elementos del lenguaje visual, musical, corporal o escénico en producciones propias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 1), 3,
'Explica las emociones e ideas que desea transmitir a través de sus creaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 1), 4,
'Disfruta el proceso de exploración y comparte sus resultados con los demás.');

-- DBA 2: Reconocimiento y aplicación de elementos del lenguaje artístico en producciones personales y colectivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 9, 2,
'Reconocimiento y aplicación de elementos del lenguaje artístico en producciones personales y colectivas',
'Reconoce los elementos del lenguaje artístico y los aplica en producciones personales y colectivas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 2), 1,
'Identifica color, forma, ritmo, sonido, textura, movimiento y espacio en obras propias y ajenas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 2), 2,
'Emplea los elementos del lenguaje artístico para comunicar intenciones estéticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 2), 3,
'Analiza cómo el uso de estos elementos influye en la percepción del espectador.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 2), 4,
'Integra distintos lenguajes artísticos en la creación de una obra.');

-- DBA 3: Participación en procesos de creación individual y colectiva con responsabilidad, compromiso y respeto
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 9, 3,
'Participación en procesos de creación individual y colectiva con responsabilidad, compromiso y respeto',
'Participa en procesos de creación individual y colectiva con responsabilidad, compromiso y respeto.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 3), 1,
'Colabora activamente en la planeación y realización de proyectos artísticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 3), 2,
'Escucha las ideas de sus compañeros y valora su trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 3), 3,
'Cumple con los compromisos asumidos dentro de las actividades artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 3), 4,
'Reconoce la importancia del trabajo colaborativo para la producción artística.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y universales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 9, 4,
'Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y universales',
'Reconoce y valora las manifestaciones artísticas y culturales locales, nacionales y universales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 4), 1,
'Identifica expresiones artísticas representativas de diferentes culturas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 4), 2,
'Participa en actividades que promueven el conocimiento del arte y la cultura.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 4), 3,
'Explica los significados culturales e históricos de las manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 4), 4,
'Muestra respeto por la diversidad cultural y el patrimonio artístico.');

-- DBA 5: Uso del arte para reflexionar sobre la realidad y promover el cambio social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 9, 5,
'Uso del arte para reflexionar sobre la realidad y promover el cambio social',
'Utiliza el arte como medio para reflexionar sobre la realidad y promover el cambio social.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 5), 1,
'Aborda temas de su entorno a través de la creación artística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 5), 2,
'Explica cómo sus obras reflejan o transforman la realidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 5), 3,
'Participa en proyectos artísticos con sentido social y comunitario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 9 AND numero_dba = 5), 4,
'Valora el arte como herramienta de comunicación, expresión y transformación.');

-- Educación Artística (id_asignatura = 7) y 7° grado (id_grado = 10)

-- DBA 1: Experimentación con diferentes materiales, técnicas, lenguajes y medios artísticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 10, 1,
'Experimentación con diferentes materiales, técnicas, lenguajes y medios artísticos',
'Experimenta con diferentes materiales, técnicas, lenguajes y medios artísticos para expresar ideas, emociones y percepciones del entorno.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 1), 1,
'Utiliza diversas técnicas y soportes para realizar creaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 1), 2,
'Explora la combinación de sonidos, imágenes, movimientos o palabras en sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 1), 3,
'Explica el significado de sus obras en relación con sus emociones o experiencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 1), 4,
'Disfruta y comparte su proceso creativo con los demás.');

-- DBA 2: Reconocimiento y aplicación de elementos del lenguaje visual, musical, corporal y escénico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 10, 2,
'Reconocimiento y aplicación de elementos del lenguaje visual, musical, corporal y escénico',
'Reconoce y aplica los elementos del lenguaje visual, musical, corporal y escénico en producciones artísticas personales y colectivas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 2), 1,
'Identifica y emplea conscientemente los elementos del lenguaje artístico en sus creaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 2), 2,
'Analiza cómo los recursos visuales, sonoros o corporales comunican sensaciones y significados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 2), 3,
'Integra distintos lenguajes en la realización de una obra artística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 2), 4,
'Comenta el uso de los elementos expresivos en producciones propias y ajenas.');

-- DBA 3: Participación activa en procesos de creación colectiva con compromiso, respeto y sentido de pertenencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 10, 3,
'Participación activa en procesos de creación colectiva con compromiso, respeto y sentido de pertenencia',
'Participa activamente en procesos de creación colectiva, demostrando compromiso, respeto y sentido de pertenencia.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 3), 1,
'Colabora en la planeación y desarrollo de proyectos artísticos grupales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 3), 2,
'Escucha y respeta las ideas de sus compañeros durante el proceso creativo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 3), 3,
'Cumple con las tareas asignadas dentro del trabajo artístico en grupo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 3), 4,
'Reconoce la importancia del trabajo colaborativo y la diversidad de aportes.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y universales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 10, 4,
'Reconocimiento y valoración de manifestaciones artísticas locales, nacionales y universales',
'Reconoce y valora las manifestaciones artísticas y culturales locales, nacionales y universales.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 4), 1,
'Identifica distintas expresiones artísticas pertenecientes a diferentes contextos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 4), 2,
'Participa en actividades que promueven el conocimiento del patrimonio cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 4), 3,
'Explica el significado social e histórico de obras o tradiciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 4), 4,
'Muestra respeto y valoración por las expresiones artísticas diversas.');

-- DBA 5: Uso del arte como medio de reflexión, comunicación y transformación social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 10, 5,
'Uso del arte como medio de reflexión, comunicación y transformación social',
'Utiliza el arte como medio de reflexión, comunicación y transformación social.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 5), 1,
'Expresa opiniones o reflexiones sobre temas sociales mediante el arte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 5), 2,
'Participa en proyectos artísticos con sentido crítico y social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 5), 3,
'Analiza cómo las manifestaciones artísticas pueden generar conciencia y cambio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 10 AND numero_dba = 5), 4,
'Valora el arte como forma de diálogo y construcción de comunidad.');

-- Educación Artística (id_asignatura = 7) y 8° grado (id_grado = 11)

-- DBA 1: Experimentación con distintos lenguajes, materiales, técnicas y recursos expresivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 11, 1,
'Experimentación con distintos lenguajes, materiales, técnicas y recursos expresivos',
'Experimenta con distintos lenguajes, materiales, técnicas y recursos expresivos para comunicar ideas, emociones y reflexiones sobre su entorno.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 1), 1,
'Utiliza conscientemente materiales y técnicas en la creación de obras artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 1), 2,
'Explora la combinación de lenguajes (visual, musical, corporal, literario o escénico) en sus producciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 1), 3,
'Explica las emociones o ideas que busca transmitir mediante su obra.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 1), 4,
'Comparte y analiza sus experiencias creativas con sus compañeros.');

-- DBA 2: Reconocimiento y empleo de elementos del lenguaje artístico con intencionalidad expresiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 11, 2,
'Reconocimiento y empleo de elementos del lenguaje artístico con intencionalidad expresiva',
'Reconoce los elementos del lenguaje artístico y los emplea en sus producciones con intencionalidad expresiva.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 2), 1,
'Identifica los elementos del lenguaje visual, musical y corporal en distintas manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 2), 2,
'Emplea los recursos expresivos del arte para comunicar ideas estéticas o conceptuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 2), 3,
'Analiza el efecto que producen los elementos del lenguaje en el espectador.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 2), 4,
'Integra diferentes lenguajes para ampliar sus posibilidades de expresión.');

-- DBA 3: Participación en procesos de creación colectiva con responsabilidad, respeto y apertura
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 11, 3,
'Participación en procesos de creación colectiva con responsabilidad, respeto y apertura',
'Participa en procesos de creación colectiva, demostrando responsabilidad, respeto y apertura hacia las ideas de los demás.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 3), 1,
'Aporta ideas, habilidades y materiales para el desarrollo de proyectos artísticos en grupo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 3), 2,
'Escucha activamente y valora los aportes de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 3), 3,
'Cumple con los compromisos adquiridos dentro del grupo de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 3), 4,
'Reconoce la importancia del diálogo, la organización y la colaboración en el arte colectivo.');

-- DBA 4: Reconocimiento y valoración de manifestaciones artísticas como expresión de identidad y diversidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 11, 4,
'Reconocimiento y valoración de manifestaciones artísticas como expresión de identidad y diversidad',
'Reconoce y valora las manifestaciones artísticas y culturales locales, nacionales y universales como expresión de identidad y diversidad.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 4), 1,
'Identifica obras, artistas o tradiciones que forman parte del patrimonio cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 4), 2,
'Participa en actividades que promueven el conocimiento y respeto por la diversidad cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 4), 3,
'Explica los significados históricos y sociales de manifestaciones artísticas relevantes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 4), 4,
'Demuestra sensibilidad y respeto frente a las diferentes formas de expresión artística.');

-- DBA 5: Uso del arte como medio de comunicación, reflexión y transformación individual y social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 11, 5,
'Uso del arte como medio de comunicación, reflexión y transformación individual y social',
'Utiliza el arte como medio de comunicación, reflexión y transformación individual y social.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 5), 1,
'Crea producciones artísticas que expresan su visión personal sobre temas sociales o ambientales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 5), 2,
'Analiza cómo el arte puede influir en la transformación del entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 5), 3,
'Participa en proyectos artísticos con sentido crítico y propositivo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 11 AND numero_dba = 5), 4,
'Promueve el arte como herramienta de diálogo, convivencia y cambio positivo.');

-- Educación Artística (id_asignatura = 7) y 9° grado (id_grado = 12)

-- DBA 1: Exploración y experimentación con múltiples lenguajes, técnicas y recursos artísticos para la expresión crítica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 12, 1,
'Exploración y experimentación con múltiples lenguajes, técnicas y recursos artísticos para la expresión crítica',
'Explora y experimenta con múltiples lenguajes, técnicas y recursos artísticos para desarrollar propuestas de expresión crítica y transformación social.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 1), 1,
'Desarrolla proyectos artísticos integrando distintos lenguajes y recursos expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 1), 2,
'Explora nuevas tecnologías y medios para ampliar sus posibilidades creativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 1), 3,
'Articula sus propuestas artísticas con posiciones críticas sobre la realidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 1), 4,
'Comparte y socializa su proceso y resultados creativos con audiencias diversas.');

-- DBA 2: Empleo consciente y crítico de elementos del lenguaje artístico para la comunicación estética
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 12, 2,
'Empleo consciente y crítico de elementos del lenguaje artístico para la comunicación estética',
'Emplea consciente y críticamente los elementos del lenguaje artístico para fortalecer sus procesos de comunicación estética.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 2), 1,
'Analiza y emplea los elementos del lenguaje artístico con propósitos específicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 2), 2,
'Crea composiciones complejas integrando múltiples elementos expresivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 2), 3,
'Evalúa el impacto comunicativo de sus decisiones estéticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 2), 4,
'Desarrolla un lenguaje artístico personal y coherente.');

-- DBA 3: Liderazgo en procesos de creación colectiva con responsabilidad, ética y construcción de ciudadanía
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 12, 3,
'Liderazgo en procesos de creación colectiva con responsabilidad, ética y construcción de ciudadanía',
'Lidera y participa en procesos de creación colectiva con responsabilidad, ética y construcción de ciudadanía.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 3), 1,
'Lidera proyectos artísticos comunitarios con visión social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 3), 2,
'Facilita procesos de participación democrática en la creación artística.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 3), 3,
'Asume responsabilidades éticas en la gestión de proyectos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 3), 4,
'Promueve el arte como espacio de construcción de ciudadanía activa.');

-- DBA 4: Análisis crítico de manifestaciones artísticas como constructoras de identidad, memoria e historia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 12, 4,
'Análisis crítico de manifestaciones artísticas como constructoras de identidad, memoria e historia',
'Analiza críticamente las manifestaciones artísticas y culturales como constructoras de identidad, memoria e historia.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 4), 1,
'Analiza la función social e histórica de las manifestaciones artísticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 4), 2,
'Identifica cómo el arte contribuye a la construcción de identidades culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 4), 3,
'Investiga sobre artistas y movimientos que han transformado la sociedad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 4), 4,
'Valora críticamente la importancia del patrimonio cultural y su preservación.');

-- DBA 5: Proyección del arte como herramienta de transformación social, convivencia y construcción de paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 12, 5,
'Proyección del arte como herramienta de transformación social, convivencia y construcción de paz',
'Proyecta el arte como herramienta de transformación social, convivencia y construcción de paz.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 5), 1,
'Diseña proyectos artísticos orientados a la transformación social positiva.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 5), 2,
'Participa en iniciativas artísticas que promueven la convivencia y la paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 5), 3,
'Evalúa el impacto social de proyectos artísticos en la comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 12 AND numero_dba = 5), 4,
'Promueve el arte como medio de resolución de conflictos y construcción de tejido social.');

-- Educación Artística (id_asignatura = 7) y 10° grado (id_grado = 13)

-- DBA 1: Investigación y experimentación avanzada con lenguajes artísticos contemporáneos y tradicionales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 13, 1,
'Investigación y experimentación avanzada con lenguajes artísticos contemporáneos y tradicionales',
'Investiga y experimenta de manera avanzada con lenguajes artísticos contemporáneos y tradicionales para desarrollar propuestas innovadoras de expresión.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 1), 1,
'Desarrolla proyectos de investigación-creación en artes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 1), 2,
'Integra técnicas tradicionales con recursos tecnológicos contemporáneos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 1), 3,
'Fundamenta teóricamente sus decisiones estéticas y conceptuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 1), 4,
'Presenta sus propuestas artísticas en espacios públicos o académicos.');

-- DBA 2: Dominio avanzado de elementos del lenguaje artístico para la creación de obras complejas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 13, 2,
'Dominio avanzado de elementos del lenguaje artístico para la creación de obras complejas',
'Demuestra dominio avanzado de los elementos del lenguaje artístico para la creación de obras complejas con alto nivel estético.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 2), 1,
'Maneja con experticia los elementos del lenguaje visual, musical, corporal y escénico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 2), 2,
'Crea obras que evidencian sofisticación técnica y conceptual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 2), 3,
'Desarrolla un estilo personal reconocible y coherente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 2), 4,
'Analiza críticamente la calidad estética de producciones propias y ajenas.');

-- DBA 3: Gestión y coordinación de proyectos artísticos colaborativos con impacto comunitario
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 13, 3,
'Gestión y coordinación de proyectos artísticos colaborativos con impacto comunitario',
'Gestiona y coordina proyectos artísticos colaborativos con impacto comunitario, demostrando liderazgo y competencias en gestión cultural.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 3), 1,
'Planifica y ejecuta proyectos artísticos con objetivos comunitarios específicos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 3), 2,
'Coordina equipos interdisciplinarios en la realización de obras colectivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 3), 3,
'Gestiona recursos técnicos, humanos y financieros para proyectos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 3), 4,
'Evalúa el impacto social y cultural de los proyectos artísticos desarrollados.');

-- DBA 4: Investigación y análisis crítico del panorama artístico contemporáneo y sus relaciones con la historia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 13, 4,
'Investigación y análisis crítico del panorama artístico contemporáneo y sus relaciones con la historia',
'Investiga y analiza críticamente el panorama artístico contemporáneo y sus relaciones con la historia del arte y la cultura.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 4), 1,
'Investiga tendencias y movimientos artísticos contemporáneos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 4), 2,
'Establece conexiones entre obras contemporáneas y tradiciones históricas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 4), 3,
'Analiza el contexto sociopolítico de las manifestaciones artísticas actuales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 4), 4,
'Produce textos críticos sobre arte y cultura contemporáneos.');

-- DBA 5: Diseño de estrategias artísticas para la transformación social, la construcción de paz y el desarrollo sostenible
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 13, 5,
'Diseño de estrategias artísticas para la transformación social, la construcción de paz y el desarrollo sostenible',
'Diseña estrategias artísticas para la transformación social, la construcción de paz y el desarrollo sostenible.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 5), 1,
'Diseña propuestas artísticas orientadas a objetivos de desarrollo sostenible.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 5), 2,
'Implementa proyectos de arte para la paz y la reconciliación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 5), 3,
'Articula el arte con movimientos sociales y organizaciones comunitarias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 13 AND numero_dba = 5), 4,
'Evalúa el potencial transformador del arte en diferentes contextos sociales.');

-- Educación Artística (id_asignatura = 7) y 11° grado (id_grado = 14)

-- DBA 1: Desarrollo de proyectos de investigación-creación con rigor académico y artístico
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 14, 1,
'Desarrollo de proyectos de investigación-creación con rigor académico y artístico',
'Desarrolla proyectos de investigación-creación que evidencian rigor académico y artístico, integrando teoría y práctica para generar conocimiento en el campo del arte.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 1), 1,
'Formula preguntas de investigación relevantes en el campo artístico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 1), 2,
'Aplica metodologías de investigación apropiadas para proyectos de creación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 1), 3,
'Integra fundamentos teóricos con experimentación práctica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 1), 4,
'Documenta y socializa sus procesos y resultados de investigación-creación.');

-- DBA 2: Experticia en el manejo de lenguajes artísticos para la creación de propuestas innovadoras
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 14, 2,
'Experticia en el manejo de lenguajes artísticos para la creación de propuestas innovadoras',
'Demuestra experticia en el manejo de múltiples lenguajes artísticos para la creación de propuestas innovadoras con identidad estética propia.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 2), 1,
'Maneja con experticia técnicas tradicionales y contemporáneas del arte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 2), 2,
'Desarrolla propuestas artísticas originales e innovadoras.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 2), 3,
'Consolida un lenguaje artístico personal reconocible.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 2), 4,
'Participa en espacios de circulación artística con propuestas de calidad profesional.');

-- DBA 3: Liderazgo de procesos culturales comunitarios con visión transformadora y sostenible
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 14, 3,
'Liderazgo de procesos culturales comunitarios con visión transformadora y sostenible',
'Lidera procesos culturales comunitarios con visión transformadora y sostenible, contribuyendo al desarrollo territorial desde las artes.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 3), 1,
'Lidera organizaciones o colectivos artísticos con visión social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 3), 2,
'Diseña programas culturales que responden a necesidades territoriales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 3), 3,
'Gestiona recursos y alianzas para la sostenibilidad de proyectos culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 3), 4,
'Forma a otros en competencias artísticas y de gestión cultural.');

-- DBA 4: Análisis crítico y propositivo del panorama cultural contemporáneo desde perspectivas locales y globales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 14, 4,
'Análisis crítico y propositivo del panorama cultural contemporáneo desde perspectivas locales y globales',
'Analiza crítica y propositivamente el panorama cultural contemporáneo desde perspectivas locales y globales, contribuyendo al debate académico y social sobre arte y cultura.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 4), 1,
'Produce análisis críticos fundamentados sobre fenómenos culturales contemporáneos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 4), 2,
'Articula perspectivas locales con dinámicas culturales globales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 4), 3,
'Propone alternativas para el fortalecimiento del sector cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 4), 4,
'Participa en espacios de debate académico y formulación de políticas culturales.');

-- DBA 5: Proyección como agente cultural de transformación social, construcción de paz y desarrollo humano integral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(7, 14, 5,
'Proyección como agente cultural de transformación social, construcción de paz y desarrollo humano integral',
'Se proyecta como agente cultural de transformación social, construcción de paz y desarrollo humano integral, contribuyendo desde las artes a la construcción de una sociedad más justa y equitativa.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 5), 1,
'Desarrolla una visión integral del arte como herramienta de transformación social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 5), 2,
'Implementa proyectos artísticos que contribuyen a la construcción de paz territorial.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 5), 3,
'Articula su práctica artística con principios de desarrollo humano sostenible.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 7 AND id_grado = 14 AND numero_dba = 5), 4,
'Inspira a otros a usar el arte como medio de construcción social y transformación positiva.');

-- =============================================
-- EDUCACIÓN FÍSICA, RECREACIÓN Y DEPORTES
-- =============================================

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 1° grado (id_grado = 4)

-- DBA 1: Reconoce su cuerpo y sus posibilidades de movimiento en diferentes espacios y situaciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 4, 1,
'Reconoce su cuerpo y sus posibilidades de movimiento en diferentes espacios y situaciones',
'Reconoce su cuerpo y sus posibilidades de movimiento en diferentes espacios y situaciones.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 1), 1,
'Identifica las partes de su cuerpo y sus funciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 1), 2,
'Realiza movimientos básicos (caminar, correr, saltar, lanzar, atrapar, girar).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 1), 3,
'Explica cómo utiliza su cuerpo para realizar distintas acciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 1), 4,
'Disfruta de la actividad física y el juego como forma de exploración corporal.');

-- DBA 2: Participa en juegos y actividades motrices individuales y colectivas demostrando respeto y cooperación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 4, 2,
'Participa en juegos y actividades motrices individuales y colectivas demostrando respeto y cooperación',
'Participa en juegos y actividades motrices individuales y colectivas demostrando respeto y cooperación.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 2), 1,
'Juega con sus compañeros respetando turnos y reglas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 2), 2,
'Colabora en actividades grupales mostrando disposición y entusiasmo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 2), 3,
'Reconoce la importancia de ayudar y compartir con los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 2), 4,
'Muestra actitudes de respeto y solidaridad durante el juego.');

-- DBA 3: Comprende la importancia del movimiento, la actividad física y el juego para el bienestar y la salud
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 4, 3,
'Comprende la importancia del movimiento, la actividad física y el juego para el bienestar y la salud',
'Comprende la importancia del movimiento, la actividad física y el juego para el bienestar y la salud.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 3), 1,
'Identifica los beneficios del movimiento y la actividad física para su cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 3), 2,
'Participa activamente en juegos y ejercicios que fortalecen su salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 3), 3,
'Explica por qué es importante moverse y cuidar su cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 3), 4,
'Adopta hábitos saludables en la escuela y el hogar.');

-- DBA 4: Desarrolla habilidades motrices básicas en contextos lúdicos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 4, 4,
'Desarrolla habilidades motrices básicas en contextos lúdicos',
'Desarrolla habilidades motrices básicas en contextos lúdicos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 4), 1,
'Coordina movimientos de desplazamiento, equilibrio y manipulación de objetos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 4), 2,
'Realiza actividades que exigen control del cuerpo y precisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 4), 3,
'Mejora su coordinación y ritmo a través del juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 4), 4,
'Disfruta del aprendizaje corporal y reconoce sus progresos.');

-- DBA 5: Demuestra actitudes de respeto por las normas, los compañeros y los espacios durante la práctica física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 4, 5,
'Demuestra actitudes de respeto por las normas, los compañeros y los espacios durante la práctica física',
'Demuestra actitudes de respeto por las normas, los compañeros y los espacios durante la práctica física.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 5), 1,
'Cumple las reglas en los juegos y actividades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 5), 2,
'Cuida los materiales y espacios deportivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 5), 3,
'Muestra cortesía y buen trato hacia los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 4 AND numero_dba = 5), 4,
'Reconoce la importancia de las normas para la convivencia.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 2° grado (id_grado = 5)

-- DBA 1: Reconoce las partes de su cuerpo y las posibilidades de movimiento en diferentes actividades
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 5, 1,
'Reconoce las partes de su cuerpo y las posibilidades de movimiento en diferentes actividades',
'Reconoce las partes de su cuerpo y las posibilidades de movimiento en diferentes actividades.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 1), 1,
'Nombra y localiza las principales partes del cuerpo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 1), 2,
'Identifica movimientos que puede realizar con cada segmento corporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 1), 3,
'Realiza actividades motrices que requieren coordinación y equilibrio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 1), 4,
'Explica la importancia de conocer su cuerpo para moverse mejor.');

-- DBA 2: Participa en juegos y actividades motrices mostrando respeto, cooperación y sentido de pertenencia al grupo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 5, 2,
'Participa en juegos y actividades motrices mostrando respeto, cooperación y sentido de pertenencia al grupo',
'Participa en juegos y actividades motrices mostrando respeto, cooperación y sentido de pertenencia al grupo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 2), 1,
'Cumple las reglas de los juegos en los que participa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 2), 2,
'Comparte materiales y espacios con sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 2), 3,
'Acepta los resultados del juego con actitud positiva.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 2), 4,
'Colabora en la organización y el desarrollo de actividades grupales.');

-- DBA 3: Comprende que la actividad física y el juego contribuyen al bienestar personal y colectivo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 5, 3,
'Comprende que la actividad física y el juego contribuyen al bienestar personal y colectivo',
'Comprende que la actividad física y el juego contribuyen al bienestar personal y colectivo.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 3), 1,
'Participa activamente en ejercicios y juegos que fortalecen su salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 3), 2,
'Explica cómo el movimiento contribuye a sentirse bien y con energía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 3), 3,
'Reconoce hábitos saludables relacionados con la actividad física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 3), 4,
'Propone actividades lúdicas para divertirse y cuidar su cuerpo.');

-- DBA 4: Desarrolla habilidades motrices básicas con control y coordinación en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 5, 4,
'Desarrolla habilidades motrices básicas con control y coordinación en diferentes contextos',
'Desarrolla habilidades motrices básicas con control y coordinación en diferentes contextos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 4), 1,
'Ejecuta acciones de locomoción, manipulación y equilibrio con precisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 4), 2,
'Coordina movimientos en actividades que implican ritmo y secuencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 4), 3,
'Participa en juegos que requieren rapidez, fuerza y agilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 4), 4,
'Mejora progresivamente su desempeño motor.');

-- DBA 5: Demuestra actitudes de respeto, responsabilidad y cuidado durante las prácticas físicas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 5, 5,
'Demuestra actitudes de respeto, responsabilidad y cuidado durante las prácticas físicas y recreativas',
'Demuestra actitudes de respeto, responsabilidad y cuidado durante las prácticas físicas y recreativas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 5), 1,
'Cuida los implementos y materiales deportivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 5), 2,
'Respeta las normas y las indicaciones del docente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 5), 3,
'Evita conductas que pongan en riesgo su seguridad o la de otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 5 AND numero_dba = 5), 4,
'Fomenta el juego limpio y la convivencia armónica.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 3° grado (id_grado = 6)

-- DBA 1: Reconoce su cuerpo, sus movimientos y las posibilidades que tiene para realizar actividades físicas, recreativas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 6, 1,
'Reconoce su cuerpo, sus movimientos y las posibilidades que tiene para realizar actividades físicas, recreativas y deportivas',
'Reconoce su cuerpo, sus movimientos y las posibilidades que tiene para realizar actividades físicas, recreativas y deportivas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 1), 1,
'Identifica las partes de su cuerpo y sus funciones en la acción motriz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 1), 2,
'Explora distintas formas de movimiento y desplazamiento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 1), 3,
'Controla su cuerpo en actividades que requieren equilibrio y coordinación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 1), 4,
'Explica la importancia de conocer y cuidar su cuerpo.');

-- DBA 2: Participa en juegos y actividades motrices aplicando normas, respeto y cooperación con los demás
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 6, 2,
'Participa en juegos y actividades motrices aplicando normas, respeto y cooperación con los demás',
'Participa en juegos y actividades motrices aplicando normas, respeto y cooperación con los demás.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 2), 1,
'Cumple con las reglas y respeta las decisiones durante los juegos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 2), 2,
'Colabora con sus compañeros para alcanzar objetivos comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 2), 3,
'Acepta con respeto los resultados del juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 2), 4,
'Muestra actitudes de solidaridad y trabajo en equipo.');

-- DBA 3: Comprende la importancia de la actividad física, la recreación y el deporte para la salud y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 6, 3,
'Comprende la importancia de la actividad física, la recreación y el deporte para la salud y la calidad de vida',
'Comprende la importancia de la actividad física, la recreación y el deporte para la salud y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 3), 1,
'Participa activamente en actividades físicas y recreativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 3), 2,
'Explica cómo la actividad física contribuye a mantener la salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 3), 3,
'Reconoce hábitos saludables como la buena alimentación, la higiene y el descanso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 3), 4,
'Promueve la práctica regular de ejercicio físico entre sus compañeros.');

-- DBA 4: Desarrolla habilidades motrices básicas con precisión, ritmo y control en diferentes situaciones
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 6, 4,
'Desarrolla habilidades motrices básicas con precisión, ritmo y control en diferentes situaciones',
'Desarrolla habilidades motrices básicas con precisión, ritmo y control en diferentes situaciones.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 4), 1,
'Ejecuta con destreza movimientos de locomoción, manipulación y equilibrio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 4), 2,
'Coordina acciones motrices combinadas en juegos y ejercicios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 4), 3,
'Ajusta sus movimientos a diferentes ritmos y espacios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 4), 4,
'Muestra avances en su desempeño motor general.');

-- DBA 5: Demuestra actitudes de respeto, responsabilidad y cuidado en la práctica de actividades físicas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 6, 5,
'Demuestra actitudes de respeto, responsabilidad y cuidado en la práctica de actividades físicas y recreativas',
'Demuestra actitudes de respeto, responsabilidad y cuidado en la práctica de actividades físicas y recreativas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 5), 1,
'Utiliza adecuadamente los materiales e implementos deportivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 5), 2,
'Cumple las normas de seguridad y convivencia durante las clases.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 5), 3,
'Cuida los espacios donde realiza actividad física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 6 AND numero_dba = 5), 4,
'Fomenta el juego limpio y el respeto por los demás.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 4° grado (id_grado = 7)

-- DBA 1: Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en actividades físicas, recreativas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 7, 1,
'Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en actividades físicas, recreativas y deportivas',
'Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en actividades físicas, recreativas y deportivas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 1), 1,
'Identifica las partes de su cuerpo y su relación con el movimiento.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 1), 2,
'Coordina desplazamientos, saltos, lanzamientos y recepciones con precisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 1), 3,
'Realiza actividades motrices que implican fuerza, velocidad y equilibrio.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 1), 4,
'Explica cómo el conocimiento de su cuerpo le ayuda a mejorar su desempeño físico.');

-- DBA 2: Participa activamente en juegos, actividades físicas y recreativas, demostrando cooperación y respeto por las normas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 7, 2,
'Participa activamente en juegos, actividades físicas y recreativas, demostrando cooperación y respeto por las normas',
'Participa activamente en juegos, actividades físicas y recreativas, demostrando cooperación y respeto por las normas.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 2), 1,
'Cumple con las reglas establecidas en los juegos y deportes escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 2), 2,
'Acepta los resultados con actitud positiva y de compañerismo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 2), 3,
'Colabora con sus compañeros para lograr objetivos comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 2), 4,
'Promueve la participación y el respeto dentro del grupo.');

-- DBA 3: Comprende la importancia del ejercicio físico, la recreación y el deporte como medio para el bienestar personal y social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 7, 3,
'Comprende la importancia del ejercicio físico, la recreación y el deporte como medio para el bienestar personal y social',
'Comprende la importancia del ejercicio físico, la recreación y el deporte como medio para el bienestar personal y social.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 3), 1,
'Explica los beneficios de la actividad física para la salud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 3), 2,
'Participa con entusiasmo en actividades deportivas y recreativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 3), 3,
'Reconoce el valor del deporte como espacio de convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 3), 4,
'Promueve hábitos de vida saludable en su entorno escolar.');

-- DBA 4: Desarrolla y mejora sus habilidades motrices en diferentes contextos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 7, 4,
'Desarrolla y mejora sus habilidades motrices en diferentes contextos',
'Desarrolla y mejora sus habilidades motrices en diferentes contextos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 4), 1,
'Ejecuta movimientos coordinados y rítmicos en juegos y ejercicios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 4), 2,
'Aplica habilidades motrices básicas en actividades deportivas y lúdicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 4), 3,
'Adapta sus movimientos a diferentes ritmos, direcciones y niveles de esfuerzo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 4), 4,
'Demuestra control y precisión en la ejecución de acciones motrices.');

-- DBA 5: Demuestra actitudes de responsabilidad, respeto, autocuidado y trabajo en equipo durante las prácticas físicas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 7, 5,
'Demuestra actitudes de responsabilidad, respeto, autocuidado y trabajo en equipo durante las prácticas físicas y deportivas',
'Demuestra actitudes de responsabilidad, respeto, autocuidado y trabajo en equipo durante las prácticas físicas y deportivas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 5), 1,
'Cuida los materiales e implementos utilizados en las clases.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 5), 2,
'Respeta las normas y cuida la integridad de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 5), 3,
'Cumple los compromisos adquiridos en el grupo de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 7 AND numero_dba = 5), 4,
'Fomenta el juego limpio y el respeto por la diversidad de capacidades.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 5° grado (id_grado = 8)

-- DBA 1: Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en diferentes situaciones lúdicas, recreativas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 8, 1,
'Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en diferentes situaciones lúdicas, recreativas y deportivas',
'Reconoce su cuerpo y sus posibilidades de movimiento, aplicando habilidades motrices en diferentes situaciones lúdicas, recreativas y deportivas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 1), 1,
'Identifica las partes de su cuerpo y su función en la acción motriz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 1), 2,
'Coordina movimientos combinados en desplazamientos, saltos, lanzamientos y recepciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 1), 3,
'Utiliza sus habilidades motrices básicas para participar en actividades deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 1), 4,
'Explica cómo el conocimiento de su cuerpo mejora su desempeño físico.');

-- DBA 2: Participa activamente en juegos, actividades recreativas y deportivas, demostrando respeto por las reglas, cooperación y solidaridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 8, 2,
'Participa activamente en juegos, actividades recreativas y deportivas, demostrando respeto por las reglas, cooperación y solidaridad',
'Participa activamente en juegos, actividades recreativas y deportivas, demostrando respeto por las reglas, cooperación y solidaridad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 2), 1,
'Respeta las normas y los acuerdos de los juegos y deportes escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 2), 2,
'Colabora con sus compañeros para lograr objetivos comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 2), 3,
'Acepta los resultados con actitud deportiva y positiva.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 2), 4,
'Promueve el trabajo en equipo y la inclusión durante las actividades.');

-- DBA 3: Comprende la importancia de la actividad física y la recreación para la salud, el bienestar y la convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 8, 3,
'Comprende la importancia de la actividad física y la recreación para la salud, el bienestar y la convivencia',
'Comprende la importancia de la actividad física y la recreación para la salud, el bienestar y la convivencia.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 3), 1,
'Explica cómo el ejercicio físico fortalece el cuerpo y la mente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 3), 2,
'Participa regularmente en actividades físicas dentro y fuera de la escuela.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 3), 3,
'Reconoce el papel de la recreación en la integración social y la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 3), 4,
'Promueve hábitos de vida saludable entre sus compañeros y familiares.');

-- DBA 4: Desarrolla habilidades motrices específicas aplicadas al juego y al deporte escolar
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 8, 4,
'Desarrolla habilidades motrices específicas aplicadas al juego y al deporte escolar',
'Desarrolla habilidades motrices específicas aplicadas al juego y al deporte escolar.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 4), 1,
'Ejecuta acciones técnicas básicas de deportes adaptados al contexto escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 4), 2,
'Coordina movimientos precisos y controlados en actividades físicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 4), 3,
'Aplica estrategias básicas en situaciones de juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 4), 4,
'Mejora su rendimiento motor mediante la práctica y la disciplina.');

-- DBA 5: Demuestra actitudes de respeto, responsabilidad y autocuidado en la práctica de la actividad física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 8, 5,
'Demuestra actitudes de respeto, responsabilidad y autocuidado en la práctica de la actividad física',
'Demuestra actitudes de respeto, responsabilidad y autocuidado en la práctica de la actividad física.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 5), 1,
'Cuida los implementos y espacios deportivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 5), 2,
'Respeta las indicaciones del docente y las normas de seguridad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 5), 3,
'Evita conductas que afecten su bienestar o el de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 8 AND numero_dba = 5), 4,
'Promueve el juego limpio, la empatía y la convivencia pacífica.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 6° grado (id_grado = 9)

-- DBA 1: Reconoce su cuerpo, sus capacidades y limitaciones, y las aplica en la ejecución de actividades físicas, recreativas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 9, 1,
'Reconoce su cuerpo, sus capacidades y limitaciones, y las aplica en la ejecución de actividades físicas, recreativas y deportivas',
'Reconoce su cuerpo, sus capacidades y limitaciones, y las aplica en la ejecución de actividades físicas, recreativas y deportivas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 1), 1,
'Identifica sus habilidades motrices y su nivel de desempeño físico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 1), 2,
'Ejecuta movimientos con control, equilibrio y coordinación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 1), 3,
'Participa en actividades físicas ajustando el esfuerzo a sus posibilidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 1), 4,
'Explica cómo conocer su cuerpo ayuda a mejorar su rendimiento y bienestar.');

-- DBA 2: Participa en actividades físicas, recreativas y deportivas con actitud de respeto, cooperación y trabajo en equipo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 9, 2,
'Participa en actividades físicas, recreativas y deportivas con actitud de respeto, cooperación y trabajo en equipo',
'Participa en actividades físicas, recreativas y deportivas con actitud de respeto, cooperación y trabajo en equipo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 2), 1,
'Cumple las normas y acuerdos establecidos en los juegos o deportes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 2), 2,
'Colabora con sus compañeros y asume responsabilidades en el grupo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 2), 3,
'Acepta los resultados con deportividad y respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 2), 4,
'Promueve la convivencia pacífica a través del juego limpio.');

-- DBA 3: Comprende la importancia del ejercicio físico, la recreación y el deporte para el desarrollo físico, mental y social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 9, 3,
'Comprende la importancia del ejercicio físico, la recreación y el deporte para el desarrollo físico, mental y social',
'Comprende la importancia del ejercicio físico, la recreación y el deporte para el desarrollo físico, mental y social.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 3), 1,
'Explica los beneficios del ejercicio regular para la salud y la calidad de vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 3), 2,
'Participa en actividades recreativas como medio de integración social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 3), 3,
'Promueve hábitos de vida saludable en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 3), 4,
'Reconoce la relación entre la actividad física, la salud y la convivencia.');

-- DBA 4: Desarrolla y aplica habilidades motrices específicas en contextos deportivos y recreativos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 9, 4,
'Desarrolla y aplica habilidades motrices específicas en contextos deportivos y recreativos',
'Desarrolla y aplica habilidades motrices específicas en contextos deportivos y recreativos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 4), 1,
'Ejecuta con precisión movimientos técnicos básicos en diferentes deportes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 4), 2,
'Coordina desplazamientos, lanzamientos y recepciones en situaciones de juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 4), 3,
'Aplica estrategias de cooperación y oposición en actividades motrices.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 4), 4,
'Mejora su capacidad física mediante la práctica y la constancia.');

-- DBA 5: Demuestra actitudes de autocuidado, responsabilidad y respeto por el entorno durante las prácticas físicas y deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 9, 5,
'Demuestra actitudes de autocuidado, responsabilidad y respeto por el entorno durante las prácticas físicas y deportivas',
'Demuestra actitudes de autocuidado, responsabilidad y respeto por el entorno durante las prácticas físicas y deportivas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 5), 1,
'Utiliza adecuadamente los materiales y espacios deportivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 5), 2,
'Cumple las normas de seguridad e higiene durante las actividades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 5), 3,
'Cuida su salud evitando el sedentarismo y los riesgos innecesarios.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 9 AND numero_dba = 5), 4,
'Fomenta el respeto y la inclusión en la práctica deportiva.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 7° grado (id_grado = 10)

-- DBA 1: Reconoce las capacidades, limitaciones y posibilidades de su cuerpo en la ejecución de actividades físicas, deportivas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 10, 1,
'Reconoce las capacidades, limitaciones y posibilidades de su cuerpo en la ejecución de actividades físicas, deportivas y recreativas',
'Reconoce las capacidades, limitaciones y posibilidades de su cuerpo en la ejecución de actividades físicas, deportivas y recreativas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 1), 1,
'Identifica sus fortalezas y aspectos por mejorar en su condición física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 1), 2,
'Controla su cuerpo en movimientos que requieren coordinación, equilibrio y precisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 1), 3,
'Participa activamente en actividades físicas adaptando su esfuerzo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 1), 4,
'Explica cómo la actividad física contribuye a su desarrollo corporal y emocional.');

-- DBA 2: Participa en actividades motrices, deportivas y recreativas con respeto, cooperación y sentido de pertenencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 10, 2,
'Participa en actividades motrices, deportivas y recreativas con respeto, cooperación y sentido de pertenencia',
'Participa en actividades motrices, deportivas y recreativas con respeto, cooperación y sentido de pertenencia.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 2), 1,
'Cumple las reglas y acuerdos en las prácticas deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 2), 2,
'Muestra compañerismo y colaboración en los equipos de trabajo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 2), 3,
'Acepta los resultados con actitud positiva y de respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 2), 4,
'Promueve el trabajo en equipo y la convivencia en el grupo.');

-- DBA 3: Comprende la relación entre la actividad física, la recreación, el deporte y la salud integral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 10, 3,
'Comprende la relación entre la actividad física, la recreación, el deporte y la salud integral',
'Comprende la relación entre la actividad física, la recreación, el deporte y la salud integral.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 3), 1,
'Explica cómo la práctica del ejercicio físico favorece la salud física y mental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 3), 2,
'Participa en actividades que fortalecen su condición física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 3), 3,
'Reconoce hábitos saludables que mejoran su bienestar general.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 3), 4,
'Propone estrategias para mantener una vida activa y equilibrada.');

-- DBA 4: Desarrolla habilidades motrices específicas y aplica fundamentos técnicos en actividades deportivas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 10, 4,
'Desarrolla habilidades motrices específicas y aplica fundamentos técnicos en actividades deportivas y recreativas',
'Desarrolla habilidades motrices específicas y aplica fundamentos técnicos en actividades deportivas y recreativas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 4), 1,
'Ejecuta con precisión movimientos técnicos básicos de uno o varios deportes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 4), 2,
'Coordina desplazamientos, lanzamientos, recepciones y movimientos combinados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 4), 3,
'Aplica tácticas básicas en situaciones de juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 4), 4,
'Evalúa su desempeño físico y propone estrategias de mejora.');

-- DBA 5: Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, los demás y el entorno en la práctica física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 10, 5,
'Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, los demás y el entorno en la práctica física',
'Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, los demás y el entorno en la práctica física.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 5), 1,
'Cuida los materiales e instalaciones deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 5), 2,
'Respeta las normas de seguridad e higiene durante las actividades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 5), 3,
'Evita conductas que puedan generar riesgos o accidentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 10 AND numero_dba = 5), 4,
'Promueve actitudes de respeto, inclusión y juego limpio.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 8° grado (id_grado = 11)

-- DBA 1: Reconoce su cuerpo, sus capacidades y limitaciones, aplicando estrategias para mejorar su desempeño físico en actividades deportivas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 11, 1,
'Reconoce su cuerpo, sus capacidades y limitaciones, aplicando estrategias para mejorar su desempeño físico en actividades deportivas y recreativas',
'Reconoce su cuerpo, sus capacidades y limitaciones, aplicando estrategias para mejorar su desempeño físico en actividades deportivas y recreativas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 1), 1,
'Evalúa sus capacidades físicas (fuerza, velocidad, flexibilidad y resistencia).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 1), 2,
'Identifica sus avances y aspectos por fortalecer en su condición corporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 1), 3,
'Participa activamente en actividades motrices con control y coordinación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 1), 4,
'Explica la importancia del entrenamiento físico para el bienestar personal.');

-- DBA 2: Participa en actividades físicas, recreativas y deportivas demostrando respeto, cooperación y sentido de pertenencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 11, 2,
'Participa en actividades físicas, recreativas y deportivas demostrando respeto, cooperación y sentido de pertenencia',
'Participa en actividades físicas, recreativas y deportivas demostrando respeto, cooperación y sentido de pertenencia.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 2), 1,
'Cumple las normas establecidas en las prácticas deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 2), 2,
'Colabora con sus compañeros en la consecución de objetivos comunes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 2), 3,
'Acepta los resultados de los juegos con actitud positiva y respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 2), 4,
'Promueve el trabajo en equipo y la solidaridad en los grupos de práctica.');

-- DBA 3: Comprende que la práctica sistemática de la actividad física contribuye al desarrollo integral, la salud y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 11, 3,
'Comprende que la práctica sistemática de la actividad física contribuye al desarrollo integral, la salud y la calidad de vida',
'Comprende que la práctica sistemática de la actividad física contribuye al desarrollo integral, la salud y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 3), 1,
'Explica los efectos del ejercicio físico sobre la salud y el bienestar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 3), 2,
'Participa regularmente en actividades que fortalecen su condición física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 3), 3,
'Reconoce la importancia de una alimentación equilibrada y hábitos saludables.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 3), 4,
'Promueve la actividad física como medio para mejorar la convivencia social.');

-- DBA 4: Desarrolla y aplica habilidades motrices específicas y fundamentos técnicos en diferentes disciplinas deportivas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 11, 4,
'Desarrolla y aplica habilidades motrices específicas y fundamentos técnicos en diferentes disciplinas deportivas',
'Desarrolla y aplica habilidades motrices específicas y fundamentos técnicos en diferentes disciplinas deportivas.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 4), 1,
'Ejecuta correctamente técnicas básicas de distintos deportes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 4), 2,
'Coordina movimientos complejos que implican precisión y ritmo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 4), 3,
'Aplica principios tácticos y estratégicos en situaciones de juego.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 4), 4,
'Evalúa su rendimiento y propone acciones para mejorarlo.');

-- DBA 5: Demuestra actitudes de respeto, autocuidado y responsabilidad frente a su salud, sus compañeros y el entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 11, 5,
'Demuestra actitudes de respeto, autocuidado y responsabilidad frente a su salud, sus compañeros y el entorno',
'Demuestra actitudes de respeto, autocuidado y responsabilidad frente a su salud, sus compañeros y el entorno.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 5), 1,
'Cumple normas de seguridad en las prácticas físicas y deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 5), 2,
'Cuida los materiales e instalaciones que utiliza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 5), 3,
'Muestra empatía y respeto hacia la diversidad de habilidades de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 11 AND numero_dba = 5), 4,
'Fomenta la cultura del juego limpio y el respeto por el adversario.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 9° grado (id_grado = 12)

-- DBA 1: Reconoce sus capacidades físicas y motrices, y aplica estrategias para mejorar su rendimiento en la práctica de actividades deportivas y recreativas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 12, 1,
'Reconoce sus capacidades físicas y motrices, y aplica estrategias para mejorar su rendimiento en la práctica de actividades deportivas y recreativas',
'Reconoce sus capacidades físicas y motrices, y aplica estrategias para mejorar su rendimiento en la práctica de actividades deportivas y recreativas.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 1), 1,
'Evalúa su nivel de condición física a partir de pruebas básicas de esfuerzo y control corporal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 1), 2,
'Identifica los factores que influyen en su desempeño físico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 1), 3,
'Participa activamente en actividades de entrenamiento y mejoramiento personal.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 1), 4,
'Explica la relación entre ejercicio, salud y rendimiento físico.');

-- DBA 2: Participa en actividades deportivas y recreativas mostrando respeto, cooperación y compromiso con el grupo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 12, 2,
'Participa en actividades deportivas y recreativas mostrando respeto, cooperación y compromiso con el grupo',
'Participa en actividades deportivas y recreativas mostrando respeto, cooperación y compromiso con el grupo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 2), 1,
'Cumple las normas y roles establecidos en las prácticas deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 2), 2,
'Aporta ideas y estrategias para el logro de metas colectivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 2), 3,
'Acepta las decisiones de los árbitros o líderes con actitud positiva.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 2), 4,
'Promueve la integración y la sana competencia.');

-- DBA 3: Comprende la importancia de la actividad física como factor determinante para la salud, la convivencia y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 12, 3,
'Comprende la importancia de la actividad física como factor determinante para la salud, la convivencia y la calidad de vida',
'Comprende la importancia de la actividad física como factor determinante para la salud, la convivencia y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 3), 1,
'Explica los beneficios del ejercicio físico en los sistemas corporales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 3), 2,
'Participa regularmente en actividades que fortalecen su salud y bienestar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 3), 3,
'Promueve hábitos saludables de higiene, alimentación y descanso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 3), 4,
'Reconoce la actividad física como espacio de inclusión y convivencia.');

-- DBA 4: Desarrolla habilidades motrices y técnicas específicas aplicadas a la práctica de deportes individuales y colectivos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 12, 4,
'Desarrolla habilidades motrices y técnicas específicas aplicadas a la práctica de deportes individuales y colectivos',
'Desarrolla habilidades motrices y técnicas específicas aplicadas a la práctica de deportes individuales y colectivos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 4), 1,
'Ejecuta fundamentos técnicos con coordinación, precisión y control.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 4), 2,
'Aplica estrategias tácticas en actividades de cooperación y oposición.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 4), 3,
'Evalúa su desempeño individual y el del equipo para mejorarlo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 4), 4,
'Muestra disciplina, perseverancia y compromiso durante la práctica.');

-- DBA 5: Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, sus compañeros y el entorno durante las prácticas físicas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 12, 5,
'Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, sus compañeros y el entorno durante las prácticas físicas',
'Demuestra responsabilidad, autocuidado y respeto hacia sí mismo, sus compañeros y el entorno durante las prácticas físicas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 5), 1,
'Cumple las normas de seguridad, higiene y convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 5), 2,
'Cuida los materiales, espacios e instalaciones deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 5), 3,
'Evita comportamientos que puedan causar daño físico o emocional a otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 12 AND numero_dba = 5), 4,
'Promueve el juego limpio y la convivencia pacífica.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 10° grado (id_grado = 13)

-- DBA 1: Reconoce sus capacidades, habilidades y limitaciones corporales, aplicando estrategias para mantener y mejorar su condición física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 13, 1,
'Reconoce sus capacidades, habilidades y limitaciones corporales, aplicando estrategias para mantener y mejorar su condición física',
'Reconoce sus capacidades, habilidades y limitaciones corporales, aplicando estrategias para mantener y mejorar su condición física.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 1), 1,
'Evalúa su condición física en relación con los componentes de la aptitud corporal (fuerza, resistencia, flexibilidad y velocidad).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 1), 2,
'Identifica hábitos que fortalecen su rendimiento y bienestar físico.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 1), 3,
'Participa en actividades de acondicionamiento físico con disciplina y constancia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 1), 4,
'Explica la importancia de la actividad física planificada para la salud.');

-- DBA 2: Participa en actividades físicas, recreativas y deportivas demostrando compromiso, cooperación y respeto por los demás
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 13, 2,
'Participa en actividades físicas, recreativas y deportivas demostrando compromiso, cooperación y respeto por los demás',
'Participa en actividades físicas, recreativas y deportivas demostrando compromiso, cooperación y respeto por los demás.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 2), 1,
'Cumple los acuerdos, normas y reglas en los deportes o juegos practicados.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 2), 2,
'Promueve la convivencia y la inclusión dentro del grupo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 2), 3,
'Asume roles de liderazgo positivo en las actividades físicas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 2), 4,
'Muestra actitudes de respeto hacia compañeros, contrincantes y docentes.');

-- DBA 3: Comprende la relación entre la actividad física, la salud, la convivencia y la calidad de vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 13, 3,
'Comprende la relación entre la actividad física, la salud, la convivencia y la calidad de vida',
'Comprende la relación entre la actividad física, la salud, la convivencia y la calidad de vida.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 3), 1,
'Analiza cómo el ejercicio físico favorece la salud integral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 3), 2,
'Explica la influencia del sedentarismo en el bienestar físico y mental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 3), 3,
'Promueve hábitos saludables en su entorno familiar y escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 3), 4,
'Relaciona la actividad física con la prevención de enfermedades y el equilibrio emocional.');

-- DBA 4: Desarrolla habilidades motrices y técnicas específicas en deportes individuales y colectivos, aplicando principios tácticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 13, 4,
'Desarrolla habilidades motrices y técnicas específicas en deportes individuales y colectivos, aplicando principios tácticos',
'Desarrolla habilidades motrices y técnicas específicas en deportes individuales y colectivos, aplicando principios tácticos.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 4), 1,
'Ejecuta técnicas deportivas con control y precisión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 4), 2,
'Aplica estrategias y principios tácticos en diferentes juegos o disciplinas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 4), 3,
'Evalúa su desempeño individual y grupal con criterios objetivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 4), 4,
'Demuestra compromiso, disciplina y cooperación en la práctica deportiva.');

-- DBA 5: Demuestra responsabilidad, autocuidado y conciencia ambiental en el desarrollo de la actividad física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 13, 5,
'Demuestra responsabilidad, autocuidado y conciencia ambiental en el desarrollo de la actividad física',
'Demuestra responsabilidad, autocuidado y conciencia ambiental en el desarrollo de la actividad física.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 5), 1,
'Cumple con las normas de seguridad e higiene en las prácticas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 5), 2,
'Cuida los espacios naturales y deportivos donde realiza actividad física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 5), 3,
'Promueve el uso responsable de los recursos durante las actividades recreativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 13 AND numero_dba = 5), 4,
'Fomenta el respeto, la equidad y el juego limpio.');

-- Educación Física, Recreación y Deportes (id_asignatura = 8) y 11° grado (id_grado = 14)

-- DBA 1: Reconoce su cuerpo como unidad biológica, psicológica y social, aplicando estrategias para conservar y mejorar su condición física
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 14, 1,
'Reconoce su cuerpo como unidad biológica, psicológica y social, aplicando estrategias para conservar y mejorar su condición física',
'Reconoce su cuerpo como unidad biológica, psicológica y social, aplicando estrategias para conservar y mejorar su condición física.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 1), 1,
'Evalúa periódicamente sus capacidades físicas (fuerza, resistencia, flexibilidad y velocidad).'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 1), 2,
'Establece metas personales de mejoramiento físico y las lleva a cabo con disciplina.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 1), 3,
'Explica la relación entre la actividad física y la salud integral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 1), 4,
'Promueve la práctica regular del ejercicio como hábito de vida saludable.');

-- DBA 2: Participa en actividades físicas, recreativas y deportivas demostrando compromiso, respeto, liderazgo y sentido de pertenencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 14, 2,
'Participa en actividades físicas, recreativas y deportivas demostrando compromiso, respeto, liderazgo y sentido de pertenencia',
'Participa en actividades físicas, recreativas y deportivas demostrando compromiso, respeto, liderazgo y sentido de pertenencia.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 2), 1,
'Cumple las normas y reglas de convivencia en las prácticas deportivas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 2), 2,
'Asume roles de liderazgo positivo dentro del grupo o equipo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 2), 3,
'Muestra respeto por la diversidad de habilidades y capacidades de los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 2), 4,
'Promueve la cooperación, la inclusión y la sana competencia.');

-- DBA 3: Comprende la importancia de la actividad física como medio para la formación integral y la construcción de ciudadanía
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 14, 3,
'Comprende la importancia de la actividad física como medio para la formación integral y la construcción de ciudadanía',
'Comprende la importancia de la actividad física como medio para la formación integral y la construcción de ciudadanía.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 3), 1,
'Explica cómo la práctica deportiva contribuye al desarrollo personal y social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 3), 2,
'Participa en proyectos que fomentan la convivencia y la participación ciudadana a través del deporte.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 3), 3,
'Reconoce el valor del juego y la recreación para la paz y la cohesión social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 3), 4,
'Promueve el deporte como herramienta de transformación comunitaria.');

-- DBA 4: Desarrolla habilidades motrices específicas aplicadas al deporte, la recreación y la actividad física como práctica permanente
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 14, 4,
'Desarrolla habilidades motrices específicas aplicadas al deporte, la recreación y la actividad física como práctica permanente',
'Desarrolla habilidades motrices específicas aplicadas al deporte, la recreación y la actividad física como práctica permanente.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 4), 1,
'Ejecuta con precisión y control técnicas de deportes individuales o colectivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 4), 2,
'Aplica estrategias y tácticas en contextos de juego o competencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 4), 3,
'Evalúa su desempeño físico y propone acciones de mejora continua.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 4), 4,
'Asume con responsabilidad el entrenamiento y la preparación física.');

-- DBA 5: Demuestra responsabilidad, autocuidado y compromiso ético con el entorno durante la práctica física y deportiva
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(8, 14, 5,
'Demuestra responsabilidad, autocuidado y compromiso ético con el entorno durante la práctica física y deportiva',
'Demuestra responsabilidad, autocuidado y compromiso ético con el entorno durante la práctica física y deportiva.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 5), 1,
'Respeta las normas de seguridad, higiene y convivencia en las actividades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 5), 2,
'Cuida los espacios y materiales deportivos, promoviendo su uso responsable.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 5), 3,
'Participa en campañas de sensibilización sobre salud y actividad física.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 8 AND id_grado = 14 AND numero_dba = 5), 4,
'Fomenta valores como el respeto, la equidad, la honestidad y el juego limpio.');

-- =============================================
-- EDUCACIÓN RELIGIOSA ESCOLAR
-- =============================================

-- Educación Religiosa Escolar (id_asignatura = 9) y 1° grado (id_grado = 4)

-- DBA 1: Reconoce que todas las personas tienen una dimensión espiritual y la capacidad de creer, amar y hacer el bien
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 4, 1,
'Reconoce que todas las personas tienen una dimensión espiritual y la capacidad de creer, amar y hacer el bien',
'Reconoce que todas las personas tienen una dimensión espiritual y la capacidad de creer, amar y hacer el bien.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 1), 1,
'Expresa con sus palabras qué significa creer y confiar en algo o en alguien.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 1), 2,
'Identifica emociones positivas como el amor, la bondad y la alegría en su vida cotidiana.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 1), 3,
'Participa en actividades que promueven el respeto y la solidaridad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 1), 4,
'Reconoce que cada persona puede expresar su fe de diferentes maneras.');

-- DBA 2: Reconoce en su entorno manifestaciones de religiosidad y espiritualidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 4, 2,
'Reconoce en su entorno manifestaciones de religiosidad y espiritualidad',
'Reconoce en su entorno manifestaciones de religiosidad y espiritualidad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 2), 1,
'Nombra símbolos, objetos o lugares relacionados con la religión y la espiritualidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 2), 2,
'Describe celebraciones religiosas que conoce en su familia o comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 2), 3,
'Explica cómo las personas expresan sus creencias a través de cantos, oraciones o gestos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 2), 4,
'Muestra respeto por las creencias y expresiones religiosas de los demás.');

-- DBA 3: Comprende que la familia y la escuela son espacios donde se cultivan valores espirituales y de convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 4, 3,
'Comprende que la familia y la escuela son espacios donde se cultivan valores espirituales y de convivencia',
'Comprende que la familia y la escuela son espacios donde se cultivan valores espirituales y de convivencia.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 3), 1,
'Participa en actividades que fortalecen la amistad, la solidaridad y el perdón.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 3), 2,
'Explica la importancia del amor, el respeto y la ayuda mutua.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 3), 3,
'Reconoce el valor de compartir con sus compañeros y familiares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 3), 4,
'Identifica ejemplos de personas que actúan con bondad y servicio.');

-- DBA 4: Reconoce que la naturaleza es un don que debe cuidar y agradecer
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 4, 4,
'Reconoce que la naturaleza es un don que debe cuidar y agradecer',
'Reconoce que la naturaleza es un don que debe cuidar y agradecer.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 4), 1,
'Explica por qué es importante cuidar los animales y las plantas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 4), 2,
'Participa en acciones de protección y respeto por el ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 4), 3,
'Manifiesta gratitud por la vida y el entorno natural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 4), 4,
'Explica cómo cuidar la creación es una forma de expresar amor y responsabilidad.');

-- DBA 5: Demuestra respeto por las diferencias religiosas y culturales en su entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 4, 5,
'Demuestra respeto por las diferencias religiosas y culturales en su entorno',
'Demuestra respeto por las diferencias religiosas y culturales en su entorno.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 5), 1,
'Escucha y acepta que existen distintas formas de expresar la fe.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 5), 2,
'Evita actitudes de burla o rechazo hacia las creencias de otros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 5), 3,
'Participa en actividades escolares que promueven el respeto por la diversidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 4 AND numero_dba = 5), 4,
'Explica que todas las religiones buscan el bien, la paz y la convivencia.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 2° grado (id_grado = 5)

-- DBA 1: Reconoce que la fe y la espiritualidad ayudan a las personas a vivir en armonía consigo mismas y con los demás
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 5, 1,
'Reconoce que la fe y la espiritualidad ayudan a las personas a vivir en armonía consigo mismas y con los demás',
'Reconoce que la fe y la espiritualidad ayudan a las personas a vivir en armonía consigo mismas y con los demás.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 1), 1,
'Explica con sus palabras qué significa tener fe o confianza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 1), 2,
'Identifica momentos en los que la oración, la reflexión o el agradecimiento le generan paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 1), 3,
'Participa en actividades que promueven el amor, la ayuda y el respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 1), 4,
'Reconoce que las creencias ayudan a las personas a convivir mejor.');

-- DBA 2: Reconoce que existen distintas religiones y formas de expresar la espiritualidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 5, 2,
'Reconoce que existen distintas religiones y formas de expresar la espiritualidad',
'Reconoce que existen distintas religiones y formas de expresar la espiritualidad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 2), 1,
'Nombra algunas religiones o tradiciones que conoce.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 2), 2,
'Identifica símbolos, celebraciones y costumbres religiosas presentes en su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 2), 3,
'Explica que las personas pueden expresar su fe de manera diferente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 2), 4,
'Muestra respeto por las manifestaciones religiosas de otras culturas.');

-- DBA 3: Comprende que la familia y la escuela son espacios donde se fortalecen valores espirituales y éticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 5, 3,
'Comprende que la familia y la escuela son espacios donde se fortalecen valores espirituales y éticos',
'Comprende que la familia y la escuela son espacios donde se fortalecen valores espirituales y éticos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 3), 1,
'Participa en actividades que promueven la solidaridad, el perdón y la generosidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 3), 2,
'Explica la importancia de actuar con respeto y bondad hacia los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 3), 3,
'Reconoce en su entorno personas que viven de acuerdo con valores espirituales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 3), 4,
'Demuestra actitudes de respeto, honestidad y cooperación.');

-- DBA 4: Reconoce la naturaleza como expresión del amor y la generosidad divina
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 5, 4,
'Reconoce la naturaleza como expresión del amor y la generosidad divina',
'Reconoce la naturaleza como expresión del amor y la generosidad divina.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 4), 1,
'Observa y describe la belleza de los elementos naturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 4), 2,
'Explica por qué es importante cuidar el agua, los animales y las plantas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 4), 3,
'Participa en acciones ecológicas escolares.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 4), 4,
'Manifiesta gratitud y respeto por la creación.');

-- DBA 5: Demuestra actitudes de respeto y convivencia frente a la diversidad religiosa y cultural
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 5, 5,
'Demuestra actitudes de respeto y convivencia frente a la diversidad religiosa y cultural',
'Demuestra actitudes de respeto y convivencia frente a la diversidad religiosa y cultural.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 5), 1,
'Escucha y valora las creencias de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 5), 2,
'Participa en actividades de integración sin excluir a nadie por sus creencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 5), 3,
'Explica que todas las religiones promueven el amor y la paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 5 AND numero_dba = 5), 4,
'Fomenta el respeto por la diversidad cultural y espiritual.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 3° grado (id_grado = 6)

-- DBA 1: Reconoce que la espiritualidad y la fe orientan las acciones humanas hacia el bien y la convivencia armónica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 6, 1,
'Reconoce que la espiritualidad y la fe orientan las acciones humanas hacia el bien y la convivencia armónica',
'Reconoce que la espiritualidad y la fe orientan las acciones humanas hacia el bien y la convivencia armónica.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 1), 1,
'Explica cómo la fe o la confianza ayudan a tomar buenas decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 1), 2,
'Describe ejemplos de personas que actúan con bondad, solidaridad y respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 1), 3,
'Participa en actividades que promueven la paz y la amistad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 1), 4,
'Identifica valores espirituales en su vida cotidiana y escolar.');

-- DBA 2: Identifica la presencia de diferentes religiones y tradiciones espirituales en su entorno
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 6, 2,
'Identifica la presencia de diferentes religiones y tradiciones espirituales en su entorno',
'Identifica la presencia de diferentes religiones y tradiciones espirituales en su entorno.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 2), 1,
'Nombra religiones o expresiones de fe conocidas en su comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 2), 2,
'Describe celebraciones o prácticas religiosas que observa en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 2), 3,
'Reconoce símbolos, templos o lugares de encuentro espiritual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 2), 4,
'Manifiesta respeto por las diferencias religiosas y culturales.');

-- DBA 3: Comprende que la familia, la escuela y la comunidad son espacios donde se construyen valores y se fortalecen vínculos espirituales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 6, 3,
'Comprende que la familia, la escuela y la comunidad son espacios donde se construyen valores y se fortalecen vínculos espirituales',
'Comprende que la familia, la escuela y la comunidad son espacios donde se construyen valores y se fortalecen vínculos espirituales.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 3), 1,
'Explica la importancia de la oración, el diálogo y la ayuda mutua en su familia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 3), 2,
'Participa en actividades escolares que promueven la convivencia y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 3), 3,
'Reconoce cómo el amor y la solidaridad fortalecen la unión familiar y escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 3), 4,
'Muestra disposición para ayudar a los demás.');

-- DBA 4: Reconoce en la naturaleza una manifestación de la presencia divina y de la responsabilidad humana frente al cuidado del mundo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 6, 4,
'Reconoce en la naturaleza una manifestación de la presencia divina y de la responsabilidad humana frente al cuidado del mundo',
'Reconoce en la naturaleza una manifestación de la presencia divina y de la responsabilidad humana frente al cuidado del mundo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 4), 1,
'Observa y valora la belleza de los elementos naturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 4), 2,
'Explica la necesidad de cuidar el ambiente como muestra de gratitud y amor.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 4), 3,
'Participa en campañas ecológicas y de protección ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 4), 4,
'Relaciona el respeto por la creación con valores espirituales.');

-- DBA 5: Demuestra respeto, tolerancia y diálogo frente a las diferentes creencias religiosas
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 6, 5,
'Demuestra respeto, tolerancia y diálogo frente a las diferentes creencias religiosas',
'Demuestra respeto, tolerancia y diálogo frente a las diferentes creencias religiosas.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 5), 1,
'Escucha con atención cuando otros expresan sus creencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 5), 2,
'Evita actitudes de burla o discriminación religiosa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 5), 3,
'Promueve la convivencia entre compañeros de diferentes tradiciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 6 AND numero_dba = 5), 4,
'Explica que todas las religiones buscan el bien común y la paz.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 4° grado (id_grado = 7)

-- DBA 1: Reconoce que la espiritualidad y la fe fortalecen la convivencia y ayudan a construir relaciones basadas en el respeto y la solidaridad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 7, 1,
'Reconoce que la espiritualidad y la fe fortalecen la convivencia y ayudan a construir relaciones basadas en el respeto y la solidaridad',
'Reconoce que la espiritualidad y la fe fortalecen la convivencia y ayudan a construir relaciones basadas en el respeto y la solidaridad.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 1), 1,
'Explica cómo la fe y los valores espirituales promueven el respeto y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 1), 2,
'Identifica ejemplos de personas que actúan con compasión y ayuda al prójimo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 1), 3,
'Participa en actividades que fomentan la paz y la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 1), 4,
'Reflexiona sobre la importancia del amor, el perdón y la amistad en la vida diaria.');

-- DBA 2: Identifica diversas religiones y tradiciones espirituales presentes en el país y en el mundo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 7, 2,
'Identifica diversas religiones y tradiciones espirituales presentes en el país y en el mundo',
'Identifica diversas religiones y tradiciones espirituales presentes en el país y en el mundo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 2), 1,
'Nombra algunas religiones del mundo y sus principales símbolos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 2), 2,
'Describe costumbres, celebraciones y lugares sagrados de distintas religiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 2), 3,
'Reconoce similitudes y diferencias entre las religiones en torno a valores universales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 2), 4,
'Muestra respeto por las expresiones religiosas y culturales de los demás.');

-- DBA 3: Comprende que la familia, la escuela y la comunidad son espacios donde se cultivan valores espirituales y éticos
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 7, 3,
'Comprende que la familia, la escuela y la comunidad son espacios donde se cultivan valores espirituales y éticos',
'Comprende que la familia, la escuela y la comunidad son espacios donde se cultivan valores espirituales y éticos.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 3), 1,
'Identifica actitudes de respeto, amor, gratitud y servicio en su entorno familiar y escolar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 3), 2,
'Participa en actividades de cooperación y ayuda mutua.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 3), 3,
'Explica cómo las acciones basadas en valores fortalecen la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 3), 4,
'Reconoce la importancia de actuar con coherencia entre lo que piensa y hace.');

-- DBA 4: Reconoce en la naturaleza una manifestación del amor y la sabiduría divina
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 7, 4,
'Reconoce en la naturaleza una manifestación del amor y la sabiduría divina',
'Reconoce en la naturaleza una manifestación del amor y la sabiduría divina.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 4), 1,
'Explica por qué el cuidado de la naturaleza es una expresión de fe y responsabilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 4), 2,
'Participa en campañas ecológicas o ambientales de su institución.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 4), 3,
'Muestra gratitud y respeto por los seres vivos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 4), 4,
'Reflexiona sobre el papel del ser humano en el cuidado de la creación.');

-- DBA 5: Promueve el respeto y el diálogo interreligioso como medio para la convivencia pacífica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 7, 5,
'Promueve el respeto y el diálogo interreligioso como medio para la convivencia pacífica',
'Promueve el respeto y el diálogo interreligioso como medio para la convivencia pacífica.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 5), 1,
'Escucha y valora las creencias de sus compañeros y otras culturas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 5), 2,
'Participa en actividades de integración y cooperación sin discriminación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 5), 3,
'Explica que todas las religiones enseñan el amor, la paz y el respeto mutuo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 7 AND numero_dba = 5), 4,
'Promueve la convivencia y el diálogo en su entorno escolar y familiar.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 5° grado (id_grado = 8)

-- DBA 1: Reconoce que la dimensión espiritual orienta las acciones humanas hacia el respeto, la solidaridad y el bien común
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 8, 1,
'Reconoce que la dimensión espiritual orienta las acciones humanas hacia el respeto, la solidaridad y el bien común',
'Reconoce que la dimensión espiritual orienta las acciones humanas hacia el respeto, la solidaridad y el bien común.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 1), 1,
'Explica cómo la espiritualidad motiva a actuar con justicia y empatía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 1), 2,
'Identifica valores como la honestidad, la tolerancia y el perdón en su entorno.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 1), 3,
'Participa en actividades que promueven la cooperación y el respeto mutuo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 1), 4,
'Reflexiona sobre la importancia de ayudar a los demás.');

-- DBA 2: Identifica las principales religiones del mundo y sus aportes a la convivencia y la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 8, 2,
'Identifica las principales religiones del mundo y sus aportes a la convivencia y la paz',
'Identifica las principales religiones del mundo y sus aportes a la convivencia y la paz.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 2), 1,
'Nombra las religiones más reconocidas y sus líderes o fundadores.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 2), 2,
'Reconoce los valores universales compartidos por las distintas tradiciones religiosas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 2), 3,
'Describe símbolos, celebraciones y lugares sagrados de diferentes religiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 2), 4,
'Manifiesta respeto por la diversidad religiosa y cultural.');

-- DBA 3: Comprende que la familia, la escuela y la sociedad son espacios donde se construye la espiritualidad y la ética
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 8, 3,
'Comprende que la familia, la escuela y la sociedad son espacios donde se construye la espiritualidad y la ética',
'Comprende que la familia, la escuela y la sociedad son espacios donde se construye la espiritualidad y la ética.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 3), 1,
'Participa en actividades escolares que promueven valores espirituales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 3), 2,
'Reconoce comportamientos éticos en su familia, escuela y comunidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 3), 3,
'Explica la relación entre fe, respeto y convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 3), 4,
'Muestra disposición para el diálogo y la ayuda solidaria.');

-- DBA 4: Reconoce la naturaleza como una expresión del amor divino y de la responsabilidad humana frente al mundo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 8, 4,
'Reconoce la naturaleza como una expresión del amor divino y de la responsabilidad humana frente al mundo',
'Reconoce la naturaleza como una expresión del amor divino y de la responsabilidad humana frente al mundo.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 4), 1,
'Explica cómo el cuidado del ambiente refleja el amor y la gratitud hacia la vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 4), 2,
'Participa en acciones que promueven el cuidado de la creación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 4), 3,
'Identifica comportamientos que afectan el equilibrio natural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 4), 4,
'Muestra compromiso en actividades ecológicas y comunitarias.');

-- DBA 5: Promueve el respeto, la convivencia y el diálogo interreligioso como caminos para la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 8, 5,
'Promueve el respeto, la convivencia y el diálogo interreligioso como caminos para la paz',
'Promueve el respeto, la convivencia y el diálogo interreligioso como caminos para la paz.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 5), 1,
'Escucha y valora las creencias de sus compañeros.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 5), 2,
'Participa en espacios de diálogo sobre diferentes religiones y culturas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 5), 3,
'Rechaza actitudes de exclusión o discriminación religiosa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 8 AND numero_dba = 5), 4,
'Promueve el respeto mutuo como valor esencial para la convivencia pacífica.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 6° grado (id_grado = 9)

-- DBA 1: Reconoce la dimensión espiritual como parte esencial de la vida humana y como fuente de sentido y orientación moral
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 9, 1,
'Reconoce la dimensión espiritual como parte esencial de la vida humana y como fuente de sentido y orientación moral',
'Reconoce la dimensión espiritual como parte esencial de la vida humana y como fuente de sentido y orientación moral.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 1), 1,
'Explica qué significa para él o ella tener espiritualidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 1), 2,
'Identifica cómo la fe o la reflexión interior le ayudan a tomar decisiones correctas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 1), 3,
'Muestra disposición al diálogo sobre temas de sentido, valores y convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 1), 4,
'Participa en actividades que fortalecen la vida espiritual y emocional.');

-- DBA 2: Identifica las principales religiones del mundo y sus enseñanzas comunes sobre la paz, la justicia y el respeto
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 9, 2,
'Identifica las principales religiones del mundo y sus enseñanzas comunes sobre la paz, la justicia y el respeto',
'Identifica las principales religiones del mundo y sus enseñanzas comunes sobre la paz, la justicia y el respeto.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 2), 1,
'Nombra religiones y tradiciones espirituales presentes en distintos continentes.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 2), 2,
'Describe sus creencias fundamentales y prácticas más representativas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 2), 3,
'Reconoce valores universales compartidos como la compasión, el perdón y el amor al prójimo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 2), 4,
'Promueve el respeto y la valoración de la diversidad religiosa.');

-- DBA 3: Comprende que la familia, la escuela y la sociedad son espacios donde se fortalecen los valores éticos y espirituales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 9, 3,
'Comprende que la familia, la escuela y la sociedad son espacios donde se fortalecen los valores éticos y espirituales',
'Comprende que la familia, la escuela y la sociedad son espacios donde se fortalecen los valores éticos y espirituales.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 3), 1,
'Identifica comportamientos que favorecen la convivencia y la armonía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 3), 2,
'Participa en actividades que promueven la cooperación y el servicio a los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 3), 3,
'Explica cómo los valores espirituales influyen en la convivencia escolar y familiar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 3), 4,
'Muestra empatía y disposición para ayudar.');

-- DBA 4: Reconoce la naturaleza como una manifestación del amor divino y la responsabilidad humana frente al planeta
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 9, 4,
'Reconoce la naturaleza como una manifestación del amor divino y la responsabilidad humana frente al planeta',
'Reconoce la naturaleza como una manifestación del amor divino y la responsabilidad humana frente al planeta.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 4), 1,
'Explica la relación entre espiritualidad y cuidado del ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 4), 2,
'Participa en proyectos ecológicos o acciones de conservación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 4), 3,
'Reconoce la creación como un regalo que debe cuidarse y protegerse.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 4), 4,
'Muestra respeto y compromiso con el entorno natural.');

-- DBA 5: Promueve el respeto, la convivencia y el diálogo interreligioso como expresión de madurez espiritual
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 9, 5,
'Promueve el respeto, la convivencia y el diálogo interreligioso como expresión de madurez espiritual',
'Promueve el respeto, la convivencia y el diálogo interreligioso como expresión de madurez espiritual.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 5), 1,
'Escucha y valora las creencias de sus compañeros y comunidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 5), 2,
'Participa en debates o reflexiones sobre la diversidad religiosa.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 5), 3,
'Argumenta por qué el respeto y el diálogo son fundamentales para la paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 9 AND numero_dba = 5), 4,
'Promueve el entendimiento mutuo como camino para la convivencia.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 7° grado (id_grado = 10)

-- DBA 1: Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para construir sentido y convivencia
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 10, 1,
'Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para construir sentido y convivencia',
'Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para construir sentido y convivencia.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 1), 1,
'Explica cómo las creencias personales influyen en su comportamiento y relaciones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 1), 2,
'Identifica valores espirituales que orientan su vida diaria.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 1), 3,
'Participa en actividades de reflexión sobre el respeto, la solidaridad y la empatía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 1), 4,
'Muestra apertura frente a distintas formas de comprender la espiritualidad.');

-- DBA 2: Identifica los orígenes, características y enseñanzas de las principales religiones del mundo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 10, 2,
'Identifica los orígenes, características y enseñanzas de las principales religiones del mundo',
'Identifica los orígenes, características y enseñanzas de las principales religiones del mundo.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 2), 1,
'Describe las creencias, símbolos y figuras representativas de varias religiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 2), 2,
'Compara prácticas y valores comunes entre diferentes tradiciones religiosas.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 2), 3,
'Reconoce la importancia de las religiones en la historia y en la construcción cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 2), 4,
'Muestra respeto hacia las expresiones de fe y culto de otras comunidades.');

-- DBA 3: Comprende que los valores espirituales fortalecen las relaciones humanas y la vida en comunidad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 10, 3,
'Comprende que los valores espirituales fortalecen las relaciones humanas y la vida en comunidad',
'Comprende que los valores espirituales fortalecen las relaciones humanas y la vida en comunidad.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 3), 1,
'Explica cómo el perdón, la honestidad y la compasión mejoran la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 3), 2,
'Participa en actividades de servicio o ayuda al prójimo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 3), 3,
'Identifica comportamientos coherentes con una vida espiritual equilibrada.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 3), 4,
'Demuestra actitudes solidarias y de cooperación en su entorno escolar.');

-- DBA 4: Reconoce la relación entre espiritualidad, ética y compromiso social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 10, 4,
'Reconoce la relación entre espiritualidad, ética y compromiso social',
'Reconoce la relación entre espiritualidad, ética y compromiso social.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 4), 1,
'Explica cómo las creencias motivan la acción social y el servicio a los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 4), 2,
'Identifica ejemplos de líderes religiosos o comunitarios que trabajan por la justicia y la paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 4), 3,
'Participa en debates o reflexiones sobre temas de actualidad con sentido ético.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 4), 4,
'Propone acciones personales para mejorar su entorno desde la fe o los valores espirituales.');

-- DBA 5: Promueve el diálogo, la tolerancia y el respeto interreligioso como base para la convivencia pacífica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 10, 5,
'Promueve el diálogo, la tolerancia y el respeto interreligioso como base para la convivencia pacífica',
'Promueve el diálogo, la tolerancia y el respeto interreligioso como base para la convivencia pacífica.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 5), 1,
'Escucha y valora puntos de vista diferentes sobre la fe y la moral.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 5), 2,
'Argumenta la importancia del respeto frente a la diversidad de creencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 5), 3,
'Participa en actividades que fomentan la paz y el entendimiento mutuo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 10 AND numero_dba = 5), 4,
'Evita actitudes de discriminación o burla hacia otras religiones o culturas.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 8° grado (id_grado = 11)

-- DBA 1: Reconoce la dimensión espiritual como parte esencial del ser humano y como fuente de sentido, esperanza y transformación personal
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 11, 1,
'Reconoce la dimensión espiritual como parte esencial del ser humano y como fuente de sentido, esperanza y transformación personal',
'Reconoce la dimensión espiritual como parte esencial del ser humano y como fuente de sentido, esperanza y transformación personal.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 1), 1,
'Explica cómo la espiritualidad ayuda a enfrentar las dificultades y fortalecer la autoestima.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 1), 2,
'Identifica momentos en los que la reflexión y la fe contribuyen a su crecimiento interior.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 1), 3,
'Participa en actividades que promueven la interioridad, el respeto y la gratitud.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 1), 4,
'Muestra apertura hacia distintas experiencias espirituales.');

-- DBA 2: Analiza el papel de las religiones en la construcción de valores éticos y sociales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 11, 2,
'Analiza el papel de las religiones en la construcción de valores éticos y sociales',
'Analiza el papel de las religiones en la construcción de valores éticos y sociales.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 2), 1,
'Identifica valores universales compartidos por las religiones, como la justicia y la compasión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 2), 2,
'Explica cómo las religiones han influido en la historia y en la vida comunitaria.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 2), 3,
'Compara actitudes y enseñanzas que promueven la paz y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 2), 4,
'Valora las religiones como fuentes de sabiduría y orientación moral.');

-- DBA 3: Comprende que la espiritualidad orienta las acciones humanas hacia el respeto, la solidaridad y el compromiso social
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 11, 3,
'Comprende que la espiritualidad orienta las acciones humanas hacia el respeto, la solidaridad y el compromiso social',
'Comprende que la espiritualidad orienta las acciones humanas hacia el respeto, la solidaridad y el compromiso social.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 3), 1,
'Explica cómo las creencias inspiran el servicio y la ayuda al prójimo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 3), 2,
'Participa en actividades de voluntariado o acciones de ayuda comunitaria.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 3), 3,
'Reconoce en su entorno ejemplos de personas que viven su fe con compromiso ético.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 3), 4,
'Muestra disposición a colaborar en iniciativas solidarias.');

-- DBA 4: Reconoce la relación entre la espiritualidad, el sentido de la vida y el cuidado de la creación
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 11, 4,
'Reconoce la relación entre la espiritualidad, el sentido de la vida y el cuidado de la creación',
'Reconoce la relación entre la espiritualidad, el sentido de la vida y el cuidado de la creación.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 4), 1,
'Analiza cómo el respeto por la naturaleza es una expresión de fe y responsabilidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 4), 2,
'Participa en proyectos ambientales y de reflexión sobre el medio ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 4), 3,
'Relaciona el equilibrio ecológico con valores espirituales y éticos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 4), 4,
'Explica cómo cuidar el planeta es una forma de amar y agradecer la vida.');

-- DBA 5: Promueve el respeto y el diálogo interreligioso como base para la convivencia y la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 11, 5,
'Promueve el respeto y el diálogo interreligioso como base para la convivencia y la paz',
'Promueve el respeto y el diálogo interreligioso como base para la convivencia y la paz.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 5), 1,
'Reconoce la diversidad religiosa como una oportunidad para aprender del otro.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 5), 2,
'Participa en debates o actividades que fomentan la tolerancia y el respeto.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 5), 3,
'Argumenta que todas las religiones buscan el bien, la justicia y la armonía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 11 AND numero_dba = 5), 4,
'Promueve el diálogo y la cooperación entre personas de diferentes creencias.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 9° grado (id_grado = 12)

-- DBA 1: Reconoce la espiritualidad como fuente de sentido, libertad interior y compromiso ético frente a la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 12, 1,
'Reconoce la espiritualidad como fuente de sentido, libertad interior y compromiso ético frente a la vida',
'Reconoce la espiritualidad como fuente de sentido, libertad interior y compromiso ético frente a la vida.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 1), 1,
'Explica cómo la fe y la reflexión personal fortalecen su identidad y sus decisiones.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 1), 2,
'Identifica valores espirituales que orientan su proyecto de vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 1), 3,
'Participa en actividades que promueven la interioridad, la paz y el respeto mutuo.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 1), 4,
'Muestra coherencia entre sus valores y sus acciones cotidianas.');

-- DBA 2: Analiza el papel de las religiones en la construcción de la cultura, la ética y la sociedad
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 12, 2,
'Analiza el papel de las religiones en la construcción de la cultura, la ética y la sociedad',
'Analiza el papel de las religiones en la construcción de la cultura, la ética y la sociedad.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 2), 1,
'Identifica el aporte de distintas religiones al arte, la moral y la convivencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 2), 2,
'Explica cómo las religiones han influido en la historia de los pueblos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 2), 3,
'Compara enseñanzas religiosas que promueven la justicia y la solidaridad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 2), 4,
'Valora el pluralismo religioso como parte de la riqueza cultural de la humanidad.');

-- DBA 3: Comprende que la espiritualidad impulsa el compromiso con la dignidad humana, la justicia y la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 12, 3,
'Comprende que la espiritualidad impulsa el compromiso con la dignidad humana, la justicia y la paz',
'Comprende que la espiritualidad impulsa el compromiso con la dignidad humana, la justicia y la paz.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 3), 1,
'Relaciona la fe y la ética con el respeto por los derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 3), 2,
'Participa en reflexiones o acciones que promueven la equidad y la cooperación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 3), 3,
'Reconoce el valor del perdón y la reconciliación en la vida social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 3), 4,
'Demuestra sensibilidad frente a las injusticias y los conflictos.');

-- DBA 4: Reconoce la responsabilidad del ser humano frente al cuidado de la creación y el equilibrio de la vida
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 12, 4,
'Reconoce la responsabilidad del ser humano frente al cuidado de la creación y el equilibrio de la vida',
'Reconoce la responsabilidad del ser humano frente al cuidado de la creación y el equilibrio de la vida.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 4), 1,
'Explica la relación entre espiritualidad, ecología y responsabilidad ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 4), 2,
'Participa en actividades ecológicas o de reflexión sobre el cuidado del planeta.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 4), 3,
'Analiza comportamientos que afectan negativamente la naturaleza.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 4), 4,
'Propone acciones de compromiso ambiental desde una perspectiva ética.');

-- DBA 5: Promueve el diálogo interreligioso y la cooperación como caminos para la convivencia y la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 12, 5,
'Promueve el diálogo interreligioso y la cooperación como caminos para la convivencia y la paz',
'Promueve el diálogo interreligioso y la cooperación como caminos para la convivencia y la paz.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 5), 1,
'Escucha con respeto las creencias de otras personas y comunidades.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 5), 2,
'Argumenta la importancia del diálogo para superar la intolerancia y la violencia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 5), 3,
'Participa en debates o proyectos que fomentan la comprensión mutua.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 12 AND numero_dba = 5), 4,
'Defiende el respeto a la diversidad religiosa como valor universal.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 10° grado (id_grado = 13)

-- DBA 1: Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para la construcción de sentido, libertad y responsabilidad ética
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 13, 1,
'Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para la construcción de sentido, libertad y responsabilidad ética',
'Reconoce la espiritualidad como dimensión fundamental del ser humano y como camino para la construcción de sentido, libertad y responsabilidad ética.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 1), 1,
'Explica cómo la espiritualidad influye en su forma de pensar, decidir y actuar.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 1), 2,
'Reflexiona sobre su proyecto de vida a partir de valores éticos y espirituales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 1), 3,
'Participa en actividades que fortalecen la interioridad, la reflexión y la empatía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 1), 4,
'Muestra coherencia entre sus convicciones y sus decisiones cotidianas.');

-- DBA 2: Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de la sociedad contemporánea
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 13, 2,
'Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de la sociedad contemporánea',
'Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de la sociedad contemporánea.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 2), 1,
'Investiga los aportes de las religiones al desarrollo de la humanidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 2), 2,
'Explica cómo las creencias religiosas han influido en procesos sociales y culturales.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 2), 3,
'Reflexiona sobre los desafíos éticos que enfrentan las religiones en el mundo actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 2), 4,
'Muestra respeto frente a la diversidad de creencias y posturas espirituales.');

-- DBA 3: Comprende que la fe y la espiritualidad son fuerzas que promueven la justicia, la paz y la dignidad humana
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 13, 3,
'Comprende que la fe y la espiritualidad son fuerzas que promueven la justicia, la paz y la dignidad humana',
'Comprende que la fe y la espiritualidad son fuerzas que promueven la justicia, la paz y la dignidad humana.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 3), 1,
'Analiza cómo las religiones y los valores espirituales contribuyen a la defensa de los derechos humanos.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 3), 2,
'Participa en proyectos o reflexiones sobre la equidad y el compromiso social.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 3), 3,
'Reconoce ejemplos de líderes religiosos o éticos que trabajan por la paz y la justicia.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 3), 4,
'Promueve acciones de solidaridad y reconciliación en su entorno.');

-- DBA 4: Reconoce el vínculo entre la espiritualidad y la responsabilidad frente al cuidado de la vida y del planeta
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 13, 4,
'Reconoce el vínculo entre la espiritualidad y la responsabilidad frente al cuidado de la vida y del planeta',
'Reconoce el vínculo entre la espiritualidad y la responsabilidad frente al cuidado de la vida y del planeta.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 4), 1,
'Explica la relación entre el respeto por la naturaleza y la experiencia espiritual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 4), 2,
'Participa en campañas de cuidado ambiental y de sensibilización ecológica.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 4), 3,
'Analiza las consecuencias del consumismo y la indiferencia frente al medio ambiente.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 4), 4,
'Promueve el compromiso personal y colectivo con la sostenibilidad.');

-- DBA 5: Promueve el diálogo interreligioso, el respeto por la diversidad y la cooperación como bases para la convivencia y la paz
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 13, 5,
'Promueve el diálogo interreligioso, el respeto por la diversidad y la cooperación como bases para la convivencia y la paz',
'Promueve el diálogo interreligioso, el respeto por la diversidad y la cooperación como bases para la convivencia y la paz.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 5), 1,
'Participa en actividades que fomentan el diálogo y el entendimiento entre creencias.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 5), 2,
'Argumenta la importancia de la tolerancia y el respeto mutuo en la sociedad plural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 5), 3,
'Rechaza actitudes discriminatorias o excluyentes basadas en la religión.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 13 AND numero_dba = 5), 4,
'Defiende la paz y la convivencia como valores universales.');

-- Educación Religiosa Escolar (id_asignatura = 9) y 11° grado (id_grado = 14)

-- DBA 1: Reconoce la espiritualidad como una experiencia personal y social que da sentido a la existencia y orienta las decisiones éticas y morales
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 14, 1,
'Reconoce la espiritualidad como una experiencia personal y social que da sentido a la existencia y orienta las decisiones éticas y morales',
'Reconoce la espiritualidad como una experiencia personal y social que da sentido a la existencia y orienta las decisiones éticas y morales.');

-- Evidencias para DBA 1
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 1), 1,
'Explica cómo la espiritualidad influye en su identidad y en su forma de relacionarse con los demás.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 1), 2,
'Reflexiona sobre la libertad, la responsabilidad y el sentido de su vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 1), 3,
'Analiza cómo las convicciones personales orientan sus decisiones y su proyecto de vida.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 1), 4,
'Muestra coherencia entre sus valores espirituales y su comportamiento cotidiano.');

-- DBA 2: Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de una sociedad justa y pacífica
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 14, 2,
'Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de una sociedad justa y pacífica',
'Analiza críticamente el papel de las religiones en la historia, la cultura y la construcción de una sociedad justa y pacífica.');

-- Evidencias para DBA 2
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 2), 1,
'Identifica los aportes y desafíos de las religiones en el mundo actual.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 2), 2,
'Explica cómo las religiones han influido en la transformación social y cultural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 2), 3,
'Reflexiona sobre el diálogo entre ciencia, ética y religión en la sociedad moderna.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 2), 4,
'Muestra apertura frente a diferentes perspectivas de fe y pensamiento.');

-- DBA 3: Comprende la relación entre espiritualidad, compromiso ético y responsabilidad social frente a los desafíos del mundo contemporáneo
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 14, 3,
'Comprende la relación entre espiritualidad, compromiso ético y responsabilidad social frente a los desafíos del mundo contemporáneo',
'Comprende la relación entre espiritualidad, compromiso ético y responsabilidad social frente a los desafíos del mundo contemporáneo.');

-- Evidencias para DBA 3
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 3), 1,
'Analiza cómo la espiritualidad impulsa acciones de justicia, equidad y paz.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 3), 2,
'Participa en proyectos sociales o escolares con sentido ético y solidario.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 3), 3,
'Reconoce el papel de los valores religiosos en la construcción de ciudadanía.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 3), 4,
'Propone soluciones pacíficas y justas frente a problemas sociales o ambientales.');

-- DBA 4: Reconoce la importancia del respeto por la vida y el cuidado del planeta como expresión de fe y compromiso espiritual
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 14, 4,
'Reconoce la importancia del respeto por la vida y el cuidado del planeta como expresión de fe y compromiso espiritual',
'Reconoce la importancia del respeto por la vida y el cuidado del planeta como expresión de fe y compromiso espiritual.');

-- Evidencias para DBA 4
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 4), 1,
'Explica la relación entre la espiritualidad y la sostenibilidad ambiental.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 4), 2,
'Participa en campañas o proyectos de defensa del ambiente y la biodiversidad.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 4), 3,
'Analiza cómo las acciones humanas afectan la armonía de la creación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 4), 4,
'Promueve el cuidado de la vida como principio universal de todas las religiones.');

-- DBA 5: Promueve el diálogo interreligioso y la construcción de paz como expresión de madurez espiritual y compromiso ciudadano
INSERT INTO derechos_basicos_aprendizaje (id_asignatura, id_grado, numero_dba, titulo, descripcion) VALUES
(9, 14, 5,
'Promueve el diálogo interreligioso y la construcción de paz como expresión de madurez espiritual y compromiso ciudadano',
'Promueve el diálogo interreligioso y la construcción de paz como expresión de madurez espiritual y compromiso ciudadano.');

-- Evidencias para DBA 5
INSERT INTO evidencias_aprendizaje (id_dba, numero_evidencia, descripcion) VALUES
((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 5), 1,
'Argumenta la importancia del respeto por las distintas creencias en una sociedad plural.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 5), 2,
'Participa en actividades que fomentan el diálogo, la cooperación y la reconciliación.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 5), 3,
'Rechaza actitudes de intolerancia, exclusión o fanatismo religioso.'),

((SELECT id_dba FROM derechos_basicos_aprendizaje WHERE id_asignatura = 9 AND id_grado = 14 AND numero_dba = 5), 4,
'Defiende la paz, la convivencia y la fraternidad como valores universales.');

-- =============================================
-- CONSULTAS ÚTILES PARA LOS DBA
-- =============================================

-- Verificar que los datos se insertaron correctamente
-- SELECT COUNT(*) as total_dba_matematicas_1ro FROM derechos_basicos_aprendizaje WHERE id_asignatura = 2 AND id_grado = 4;

-- Obtener todos los DBA de una asignatura y grado específico
-- SELECT 
--     dba.numero_dba,
--     dba.titulo,
--     dba.descripcion,
--     COUNT(ev.id_evidencia) as total_evidencias
-- FROM derechos_basicos_aprendizaje dba
-- LEFT JOIN evidencias_aprendizaje ev ON dba.id_dba = ev.id_dba
-- WHERE dba.id_asignatura = 2 AND dba.id_grado = 4 AND dba.estado = true
-- GROUP BY dba.id_dba, dba.numero_dba, dba.titulo, dba.descripcion
-- ORDER BY dba.numero_dba;

-- Obtener un DBA específico con todas sus evidencias
-- SELECT 
--     dba.numero_dba,
--     dba.titulo,
--     dba.descripcion as descripcion_dba,
--     ev.numero_evidencia,
--     ev.descripcion as descripcion_evidencia
-- FROM derechos_basicos_aprendizaje dba
-- LEFT JOIN evidencias_aprendizaje ev ON dba.id_dba = ev.id_dba
-- WHERE dba.id_asignatura = 2 AND dba.id_grado = 4 AND dba.numero_dba = 1
-- AND dba.estado = true AND (ev.estado = true OR ev.estado IS NULL)
-- ORDER BY ev.numero_evidencia;

-- Vista completa con nombres de asignatura y grado
-- SELECT 
--     a.nombre as asignatura,
--     g.nombre as grado,
--     dba.numero_dba,
--     dba.titulo,
--     dba.descripcion,
--     COUNT(ev.id_evidencia) as total_evidencias
-- FROM derechos_basicos_aprendizaje dba
-- INNER JOIN asignaturas a ON dba.id_asignatura = a.id_asignatura
-- INNER JOIN grados_piar g ON dba.id_grado = g.id_grado
-- LEFT JOIN evidencias_aprendizaje ev ON dba.id_dba = ev.id_dba AND ev.estado = true
-- WHERE dba.estado = true
-- GROUP BY a.nombre, g.nombre, dba.id_dba, dba.numero_dba, dba.titulo, dba.descripcion
-- ORDER BY a.nombre, g.orden_grado, dba.numero_dba;