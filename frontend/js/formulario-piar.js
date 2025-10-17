// Patrón Module para el formulario PIAR
const FormularioPIAR = (function() {
    
    // Variables privadas
    let userData = null;
    let dataCache = null;
    
    // Elementos del DOM
    const enableFormBtn = document.getElementById('enableFormBtn');
    const formSections = document.getElementById('formSections');
    const studentForm = document.getElementById('studentForm');
    
    // Campos del formulario
    const fechaNacimientoInput = document.getElementById('fechaNacimiento');
    const edadInput = document.getElementById('edad');
    const numeroDocumentoInput = document.getElementById('numeroDocumento');
    const telefonoInput = document.getElementById('telefono');
    const departamentoSelect = document.getElementById('departamento');
    const municipioSelect = document.getElementById('municipio');
    
    // Radio buttons
    const afiliadoSaludRadios = document.querySelectorAll('input[name="afiliadoSalud"]');
    const asisteRehabilitacionRadios = document.querySelectorAll('input[name="asisteRehabilitacion"]');
    const tieneDiagnosticoRadios = document.querySelectorAll('input[name="tieneDiagnostico"]');
    const tieneEnfermedadActualRadios = document.querySelectorAll('input[name="tieneEnfermedadActual"]');
    const consumeMedicamentosRadios = document.querySelectorAll('input[name="consumeMedicamentos"]');
    const perteneceGrupoEtnicoRadios = document.querySelectorAll('input[name="perteneceGrupoEtnico"]');
    const ingresoSistemaEducativoRadios = document.querySelectorAll('input[name="ingresoSistemaEducativo"]');
    const jornadaRadios = document.querySelectorAll('input[name="jornada"]');
    const perteneceGrupoEtnicoMadreRadios = document.querySelectorAll('input[name="perteneceGrupoEtnicoMadre"]');
    const perteneceGrupoEtnicoPadreRadios = document.querySelectorAll('input[name="perteneceGrupoEtnicoPadre"]');
    
    // Grupos condicionales
    const epsGroup = document.getElementById('epsGroup');
    const rehabilitacionDetails = document.getElementById('rehabilitacionDetails');
    const diagnosticoGroup = document.getElementById('diagnosticoGroup');
    const enfermedadActualGroup = document.getElementById('enfermedadActualGroup');
    const medicamentosDetails = document.getElementById('medicamentosDetails');
    const grupoEtnicoGroup = document.getElementById('grupoEtnicoGroup');
    const historialEducativoDetails = document.getElementById('historialEducativoDetails');
    const historialEducativoDetails2 = document.getElementById('historialEducativoDetails2');
    const historialEducativoDetails3 = document.getElementById('historialEducativoDetails3');
    const gradoEscolarDetails = document.getElementById('gradoEscolarDetails');
    const cicloEscolarDetails = document.getElementById('cicloEscolarDetails');
    const gradoAspiranteEscolarDetails = document.getElementById('gradoAspiranteEscolarDetails');
    const cicloAspiranteDetails = document.getElementById('cicloAspiranteDetails');
    const grupoEtnicoMadreGroup = document.getElementById('grupoEtnicoMadreGroup');
    const grupoEtnicoPadreGroup = document.getElementById('grupoEtnicoPadreGroup');
    
    // Campos de validación numérica adicionales
    const numeroDocumentoMadreInput = document.getElementById('numeroDocumentoMadre');
    const telefonoMadreInput = document.getElementById('telefonoMadre');
    const telefonoEmpresaMadreInput = document.getElementById('telefonoEmpresaMadre');
    const numeroDocumentoPadreInput = document.getElementById('numeroDocumentoPadre');
    const telefonoPadreInput = document.getElementById('telefonoPadre');
    const telefonoEmpresaPadreInput = document.getElementById('telefonoEmpresaPadre');
    
    // Selects de departamento y municipio para padres
    const departamentoMadreSelect = document.getElementById('departamentoMadre');
    const municipioMadreSelect = document.getElementById('municipioMadre');
    const departamentoPadreSelect = document.getElementById('departamentoPadre');
    const municipioPadreSelect = document.getElementById('municipioPadre');
    
    // Contadores para campos dinámicos
    let compositionCounter = 1;
    let supportCounter = 1;
    const maxCompositions = 3; // 1 principal + 2 adicionales
    const maxSupports = 3; // 1 principal + 2 adicionales
    
    // Nuevos radio buttons para las secciones añadidas
    const padresVivenJuntosRadios = document.querySelectorAll('input[name="padresVivenJuntos"]');
    const enfermedadPrimerAnoRadios = document.querySelectorAll('input[name="enfermedadPrimerAno"]');
    
    // Métodos privados
    function _loadUserData() {
        // Cargar datos del localStorage (del login)
        const storedUserData = localStorage.getItem('userData');
        if (storedUserData) {
            userData = JSON.parse(storedUserData);
            _updateUserInfo();
        } else {
            // Si no hay datos, usar datos de ejemplo
            userData = {
                nombres: 'María',
                apellidos: 'González',
                codigo_usuario: 'USR-7892',
                email: 'maria.gonzalez@example.com'
            };
            _updateUserInfo();
        }
    }
    
    function _updateUserInfo() {
        // Actualizar información del usuario en la sidebar
        document.getElementById('userName').textContent = `${userData.nombres} ${userData.apellidos}`;
        document.getElementById('userCode').textContent = userData.codigo_usuario;
        document.getElementById('userEmail').textContent = userData.email;
        
        // Actualizar información de expedición
        document.getElementById('expeditionUser').textContent = `${userData.nombres} ${userData.apellidos}`;
    }
    
    function _setCurrentDate() {
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            timeZone: 'America/Bogota'
        };
        const formattedDate = now.toLocaleDateString('es-CO', options);
        document.getElementById('expeditionDate').textContent = formattedDate;
    }
    
    function _enableForm() {
        formSections.style.display = 'block';
        enableFormBtn.style.display = 'none';
        
        // Inicializar sistema de firma digital cuando el formulario es visible
        setTimeout(() => {
            _initSignatureSystem();
        }, 100);
        
        // Scroll suave hacia el formulario
        formSections.scrollIntoView({ 
            behavior: 'smooth',
            block: 'start'
        });
    }
    
    function _toggleSection(sectionHeader) {
        const isCollapsed = sectionHeader.classList.contains('collapsed');
        const sectionContent = sectionHeader.nextElementSibling;
        
        if (isCollapsed) {
            sectionHeader.classList.remove('collapsed');
            sectionContent.classList.remove('collapsed');
            sectionContent.style.display = 'block';
        } else {
            sectionHeader.classList.add('collapsed');
            sectionContent.classList.add('collapsed');
            sectionContent.style.display = 'none';
        }
    }
    
    function _calculateAge() {
        const birthDate = fechaNacimientoInput.value;
        if (!birthDate) {
            edadInput.value = '';
            return;
        }
        
        const birth = new Date(birthDate);
        const today = new Date();
        let age = today.getFullYear() - birth.getFullYear();
        const monthDifference = today.getMonth() - birth.getMonth();
        
        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < birth.getDate())) {
            age--;
        }
        
        edadInput.value = age + ' años';
    }
    
    function _validateNumericInput(input) {
        input.value = input.value.replace(/[^0-9]/g, '');
    }
    
    async function _handleAfiliadoSaludChange() {
        const selectedValue = document.querySelector('input[name="afiliadoSalud"]:checked')?.value;
        
        if (selectedValue === 'si') {
            epsGroup.style.display = 'block';
            document.getElementById('eps').required = true;
            
            try {
                // Cargar EPS dinámicamente desde la API
                const eps = await _fetchParametrizacion('eps');
                _populateSelectWithOther('eps', eps);
            } catch (error) {
                console.error('Error cargando EPS:', error);
                // Fallback con datos básicos en caso de error
                _loadDummyEpsData();
            }
        } else {
            epsGroup.style.display = 'none';
            document.getElementById('eps').required = false;
            document.getElementById('eps').value = '';
        }
    }
    
    function _handleAsisteRehabilitacionChange() {
        const selectedValue = document.querySelector('input[name="asisteRehabilitacion"]:checked')?.value;
        
        if (selectedValue === 'si') {
            rehabilitacionDetails.style.display = 'flex';
            document.getElementById('institucionRehabilitacion').required = true;
            document.getElementById('frecuenciaRehabilitacion').required = true;
        } else {
            rehabilitacionDetails.style.display = 'none';
            document.getElementById('institucionRehabilitacion').required = false;
            document.getElementById('frecuenciaRehabilitacion').required = false;
            document.getElementById('institucionRehabilitacion').value = '';
            document.getElementById('frecuenciaRehabilitacion').value = '';
        }
    }

    function _handleTieneDiagnosticoChange() {
        const selectedValue = document.querySelector('input[name="tieneDiagnostico"]:checked')?.value;
        
        if (selectedValue === 'si') {
            diagnosticoGroup.style.display = 'block';
            document.getElementById('diagnostico').required = true;
        } else {
            diagnosticoGroup.style.display = 'none';
            document.getElementById('diagnostico').required = false;
            document.getElementById('diagnostico').value = '';
        }
    }

    function _handleTieneEnfermedadActualChange() {
        const selectedValue = document.querySelector('input[name="tieneEnfermedadActual"]:checked')?.value;
        
        if (selectedValue === 'si') {
            enfermedadActualGroup.style.display = 'block';
            document.getElementById('enfermedadActual').required = true;
        } else {
            enfermedadActualGroup.style.display = 'none';
            document.getElementById('enfermedadActual').required = false;
            document.getElementById('enfermedadActual').value = '';
        }
    }

    function _handleConsumeMedicamentosChange() {
        const selectedValue = document.querySelector('input[name="consumeMedicamentos"]:checked')?.value;
        
        if (selectedValue === 'si') {
            medicamentosDetails.style.display = 'flex';
            document.getElementById('frecuenciaMedicamentos').required = true;
            document.getElementById('horarioMedicamentos').required = true;
        } else {
            medicamentosDetails.style.display = 'none';
            document.getElementById('frecuenciaMedicamentos').required = false;
            document.getElementById('horarioMedicamentos').required = false;
            document.getElementById('frecuenciaMedicamentos').value = '';
            document.getElementById('horarioMedicamentos').value = '';
        }
    }

    function _handlePerteneceGrupoEtnicoChange() {
        const selectedValue = document.querySelector('input[name="perteneceGrupoEtnico"]:checked')?.value;
        
        if (selectedValue === 'si') {
            grupoEtnicoGroup.style.display = 'block';
            document.getElementById('grupoEtnico').required = true;
        } else {
            grupoEtnicoGroup.style.display = 'none';
            document.getElementById('grupoEtnico').required = false;
            document.getElementById('grupoEtnico').value = '';
        }
    }

    function _handleIngresoSistemaEducativoChange() {
        const selectedValue = document.querySelector('input[name="ingresoSistemaEducativo"]:checked')?.value;
        
        if (selectedValue === 'si') {
            historialEducativoDetails.style.display = 'flex';
            historialEducativoDetails2.style.display = 'flex';
            historialEducativoDetails3.style.display = 'flex';
            document.getElementById('establecimientoEducativo').required = true;
            
            // Llamar a la función de jornada para mostrar los campos correctos
            _handleJornadaChange();
        } else {
            historialEducativoDetails.style.display = 'none';
            historialEducativoDetails2.style.display = 'none';
            historialEducativoDetails3.style.display = 'none';
            gradoEscolarDetails.style.display = 'none';
            cicloEscolarDetails.style.display = 'none';
            gradoAspiranteEscolarDetails.style.display = 'none';
            cicloAspiranteDetails.style.display = 'none';
            
            // Limpiar campos y remover requerimientos
            document.getElementById('establecimientoEducativo').required = false;
            document.getElementById('ultimoGradoEscolar').required = false;
            document.getElementById('ultimoCicloEscolar').required = false;
            document.getElementById('gradoEscolarAspirante').required = false;
            document.getElementById('cicloEscolarAspirante').required = false;
            
            document.getElementById('establecimientoEducativo').value = '';
            document.getElementById('motivoRetiro').value = '';
            document.getElementById('ultimoGradoEscolar').value = '';
            document.getElementById('ultimoCicloEscolar').value = '';
            document.getElementById('gradoEscolarAspirante').value = '';
            document.getElementById('cicloEscolarAspirante').value = '';
            
            // Limpiar selección de jornada
            jornadaRadios.forEach(radio => radio.checked = false);
        }
    }

    function _handleJornadaChange() {
        const selectedValue = document.querySelector('input[name="jornada"]:checked')?.value;
        
        // Ocultar todos los campos condicionales inicialmente
        gradoEscolarDetails.style.display = 'none';
        cicloEscolarDetails.style.display = 'none';
        gradoAspiranteEscolarDetails.style.display = 'none';
        cicloAspiranteDetails.style.display = 'none';
        
        // Limpiar valores de campos
        document.getElementById('ultimoGradoEscolar').value = '';
        document.getElementById('ultimoCicloEscolar').value = '';
        document.getElementById('gradoEscolarAspirante').value = '';
        document.getElementById('cicloEscolarAspirante').value = '';
        
        // Remover requerimientos
        document.getElementById('ultimoGradoEscolar').required = false;
        document.getElementById('ultimoCicloEscolar').required = false;
        document.getElementById('gradoEscolarAspirante').required = false;
        document.getElementById('cicloEscolarAspirante').required = false;
        
        if (selectedValue === 'manana' || selectedValue === 'tarde') {
            // Mostrar campos para grado escolar (Pre-Jardín a 11°)
            gradoEscolarDetails.style.display = 'flex';
            gradoAspiranteEscolarDetails.style.display = 'flex';
            document.getElementById('ultimoGradoEscolar').required = true;
            document.getElementById('gradoEscolarAspirante').required = true;
        } else if (selectedValue === 'nocturna' || selectedValue === 'sabatino') {
            // Mostrar campos para ciclo escolar (2° a 6°)
            cicloEscolarDetails.style.display = 'flex';
            cicloAspiranteDetails.style.display = 'flex';
            document.getElementById('ultimoCicloEscolar').required = true;
            document.getElementById('cicloEscolarAspirante').required = true;
        }
    }

    function _handlePerteneceGrupoEtnicoMadreChange() {
        const selectedValue = document.querySelector('input[name="perteneceGrupoEtnicoMadre"]:checked')?.value;
        const grupoEtnicoMadreGroup = document.getElementById('grupoEtnicoMadreGroup');
        const grupoEtnicoMadreOtroGroup = document.getElementById('grupoEtnicoMadreOtroGroup');
        
        console.log('_handlePerteneceGrupoEtnicoMadreChange ejecutado:', selectedValue);
        console.log('grupoEtnicoMadreGroup encontrado:', !!grupoEtnicoMadreGroup);
        
        if (selectedValue === 'si') {
            if (grupoEtnicoMadreGroup) {
                grupoEtnicoMadreGroup.style.display = 'block';
                console.log('Mostrando select grupo étnico madre');
            }
        } else {
            if (grupoEtnicoMadreGroup) {
                grupoEtnicoMadreGroup.style.display = 'none';
                console.log('Ocultando select grupo étnico madre');
            }
            if (grupoEtnicoMadreOtroGroup) {
                grupoEtnicoMadreOtroGroup.style.display = 'none';
                console.log('Ocultando campo otro grupo étnico madre');
            }
            const selectMadre = document.getElementById('grupoEtnicoMadre');
            const inputMadre = document.getElementById('grupoEtnicoMadreOtro');
            if (selectMadre) selectMadre.value = '';
            if (inputMadre) inputMadre.value = '';
        }
    }

    function _handlePerteneceGrupoEtnicoPadreChange() {
        const selectedValue = document.querySelector('input[name="perteneceGrupoEtnicoPadre"]:checked')?.value;
        const grupoEtnicoPadreGroup = document.getElementById('grupoEtnicoPadreGroup');
        const grupoEtnicoPadreOtroGroup = document.getElementById('grupoEtnicoPadreOtroGroup');
        
        console.log('_handlePerteneceGrupoEtnicoPadreChange ejecutado:', selectedValue);
        console.log('grupoEtnicoPadreGroup encontrado:', !!grupoEtnicoPadreGroup);
        
        if (selectedValue === 'si') {
            if (grupoEtnicoPadreGroup) {
                grupoEtnicoPadreGroup.style.display = 'block';
                console.log('Mostrando select grupo étnico padre');
            }
        } else {
            if (grupoEtnicoPadreGroup) {
                grupoEtnicoPadreGroup.style.display = 'none';
                console.log('Ocultando select grupo étnico padre');
            }
            if (grupoEtnicoPadreOtroGroup) {
                grupoEtnicoPadreOtroGroup.style.display = 'none';
                console.log('Ocultando campo otro grupo étnico padre');
            }
            const selectPadre = document.getElementById('grupoEtnicoPadre');
            const inputPadre = document.getElementById('grupoEtnicoPadreOtro');
            if (selectPadre) selectPadre.value = '';
            if (inputPadre) inputPadre.value = '';
        }
    }

    async function _handleDepartamentoMadreChange() {
        const departamentoId = departamentoMadreSelect.value;
        
        if (!departamentoId) {
            municipioMadreSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
            return;
        }
        
        try {
            // Cargar municipios del departamento seleccionado
            municipioMadreSelect.innerHTML = '<option value="">Cargando municipios...</option>';
            
            const response = await fetch(`http://localhost:3000/api/departamentos/${departamentoId}/municipios`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (!result.success || !result.data) {
                throw new Error('Error en la respuesta de la API');
            }
            
            municipioMadreSelect.innerHTML = '<option value="">Seleccione...</option>';
            result.data.forEach(municipio => {
                const option = document.createElement('option');
                option.value = municipio.id_municipio;
                option.textContent = municipio.descripcion;
                municipioMadreSelect.appendChild(option);
            });
            
        } catch (error) {
            console.error('Error cargando municipios para madre:', error);
            municipioMadreSelect.innerHTML = '<option value="">Error cargando municipios</option>';
        }
    }

    async function _handleDepartamentoPadreChange() {
        const departamentoId = departamentoPadreSelect.value;
        
        if (!departamentoId) {
            municipioPadreSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
            return;
        }
        
        try {
            // Cargar municipios del departamento seleccionado
            municipioPadreSelect.innerHTML = '<option value="">Cargando municipios...</option>';
            
            const response = await fetch(`http://localhost:3000/api/departamentos/${departamentoId}/municipios`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (!result.success || !result.data) {
                throw new Error('Error en la respuesta de la API');
            }
            
            municipioPadreSelect.innerHTML = '<option value="">Seleccione...</option>';
            result.data.forEach(municipio => {
                const option = document.createElement('option');
                option.value = municipio.id_municipio;
                option.textContent = municipio.descripcion;
                municipioPadreSelect.appendChild(option);
            });
            
        } catch (error) {
            console.error('Error cargando municipios para padre:', error);
            municipioPadreSelect.innerHTML = '<option value="">Error cargando municipios</option>';
        }
    }

    // Funciones para campos dinámicos
    function addCompositionInfo() {
        if (compositionCounter >= maxCompositions) {
            alert('Solo se pueden agregar máximo 2 personas adicionales');
            return;
        }
        
        compositionCounter++;
        const container = document.getElementById('additionalCompositions');
        
        const newComposition = document.createElement('div');
        newComposition.className = 'composition-group';
        newComposition.id = `compositionGroup${compositionCounter}`;
        
        newComposition.innerHTML = `
            <div style="margin: 20px 0; padding: 15px; background: rgba(79, 134, 247, 0.05); border-radius: 8px;">
                <h4 style="margin: 0 0 15px 0; color: var(--primary-color);">Persona ${compositionCounter}</h4>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="conQuienVive${compositionCounter}">¿Con quién vive el estudiante?</label>
                        <select id="conQuienVive${compositionCounter}" name="conQuienVive${compositionCounter}">
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                    <div class="form-group" id="otroConQuienVive${compositionCounter}Group" style="display: none;">
                        <label for="otroConQuienVive${compositionCounter}">¿Con quién?</label>
                        <input type="text" id="otroConQuienVive${compositionCounter}" name="otroConQuienVive${compositionCounter}" maxlength="100" placeholder="Especifique con quién vive">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="nombrePersona${compositionCounter}">Nombre completo:</label>
                        <input type="text" id="nombrePersona${compositionCounter}" name="nombrePersona${compositionCounter}" maxlength="150">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="relacionEstudiante${compositionCounter}">Relación con el estudiante:</label>
                        <select id="relacionEstudiante${compositionCounter}" name="relacionEstudiante${compositionCounter}">
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                    <div class="form-group" id="otroRelacionEstudiante${compositionCounter}Group" style="display: none;">
                        <label for="otroRelacionEstudiante${compositionCounter}">¿Con quién?</label>
                        <input type="text" id="otroRelacionEstudiante${compositionCounter}" name="otroRelacionEstudiante${compositionCounter}" maxlength="100" placeholder="Especifique la relación">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="generoPersona${compositionCounter}">Género:</label>
                        <select id="generoPersona${compositionCounter}" name="generoPersona${compositionCounter}">
                            <option value="">Seleccione...</option>
                            <option value="masculino">Masculino</option>
                            <option value="femenino">Femenino</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="edadPersona${compositionCounter}">Edad:</label>
                        <select id="edadPersona${compositionCounter}" name="edadPersona${compositionCounter}">
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="ocupacionPersona${compositionCounter}">Ocupación:</label>
                        <select id="ocupacionPersona${compositionCounter}" name="ocupacionPersona${compositionCounter}">
                            <option value="">Seleccione...</option>
                            <option value="empleado">Empleado</option>
                            <option value="independiente">Trabajador Independiente</option>
                            <option value="desempleado">Desempleado</option>
                            <option value="estudiante">Estudiante</option>
                            <option value="pensionado">Pensionado</option>
                            <option value="hogar">Labores del hogar</option>
                            <option value="otro">Otro</option>
                        </select>
                    </div>
                </div>
                
                <button type="button" class="btn-secondary" onclick="removeComposition(${compositionCounter})" 
                        style="margin-top: 10px; background: #f56565; color: white;">
                    <i class="fas fa-trash"></i> Eliminar
                </button>
            </div>
        `;
        
        container.appendChild(newComposition);
        
        // Generar opciones de edad para el nuevo select
        const selectEdad = document.getElementById(`edadPersona${compositionCounter}`);
        for (let i = 1; i <= 120; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = i + ' años';
            selectEdad.appendChild(option);
        }
        
        // Poblar selects con datos de la API o datos dummy
        const relacionesData = dataCache?.relacionesEstudiante || [
            { id: 1, nombre: 'Madre' },
            { id: 2, nombre: 'Padre' },
            { id: 3, nombre: 'Abuelo/a' },
            { id: 4, nombre: 'Hermano/a' },
            { id: 5, nombre: 'Tío/a' },
            { id: 6, nombre: 'Primo/a' },
            { id: 7, nombre: 'Amigo/a de la familia' },
            { id: 8, nombre: 'Vecino/a' }
        ];
        
        _populateSelectWithOther(`conQuienVive${compositionCounter}`, relacionesData);
        _populateSelectWithOther(`relacionEstudiante${compositionCounter}`, relacionesData);
        
        // Configurar event listeners para campos condicionales
        const conQuienViveSelect = document.getElementById(`conQuienVive${compositionCounter}`);
        if (conQuienViveSelect) {
            conQuienViveSelect.addEventListener('change', () => 
                _handleSelectWithOther(`conQuienVive${compositionCounter}`, `otroConQuienVive${compositionCounter}Group`));
        }
        
        const relacionEstudianteSelect = document.getElementById(`relacionEstudiante${compositionCounter}`);
        if (relacionEstudianteSelect) {
            relacionEstudianteSelect.addEventListener('change', () => 
                _handleSelectWithOther(`relacionEstudiante${compositionCounter}`, `otroRelacionEstudiante${compositionCounter}Group`));
        }
        
        // Ocultar botón si se alcanza el máximo
        if (compositionCounter >= maxCompositions) {
            document.getElementById('addCompositionBtn').style.display = 'none';
        }
    }

    function removeComposition(id) {
        const element = document.getElementById(`compositionGroup${id}`);
        if (element) {
            element.remove();
            compositionCounter--;
            // Mostrar botón nuevamente
            document.getElementById('addCompositionBtn').style.display = 'inline-flex';
        }
    }

    function addSupportInfo() {
        if (supportCounter >= maxSupports) {
            alert('Solo se pueden agregar máximo 2 personas adicionales');
            return;
        }
        
        supportCounter++;
        const container = document.getElementById('additionalSupports');
        
        const newSupport = document.createElement('div');
        newSupport.className = 'support-group';
        newSupport.id = `supportGroup${supportCounter}`;
        
        newSupport.innerHTML = `
            <div style="margin: 20px 0; padding: 15px; background: rgba(79, 134, 247, 0.05); border-radius: 8px;">
                <h4 style="margin: 0 0 15px 0; color: var(--primary-color);">Persona de apoyo ${supportCounter}</h4>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="nombreApoyo${supportCounter}">Nombre completo:</label>
                        <input type="text" id="nombreApoyo${supportCounter}" name="nombreApoyo${supportCounter}" maxlength="150">
                    </div>
                    <div class="form-group">
                        <label for="relacionApoyo${supportCounter}">Relación con el estudiante:</label>
                        <select id="relacionApoyo${supportCounter}" name="relacionApoyo${supportCounter}">
                            <option value="">Seleccione...</option>
                        </select>
                        <div class="form-group" id="otroRelacionApoyo${supportCounter}Group" style="display: none; margin-top: 10px;">
                            <label for="otroRelacionApoyo${supportCounter}">¿Cuál?</label>
                            <input type="text" id="otroRelacionApoyo${supportCounter}" name="otroRelacionApoyo${supportCounter}" maxlength="100">
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="generoApoyo${supportCounter}">Género:</label>
                        <select id="generoApoyo${supportCounter}" name="generoApoyo${supportCounter}">
                            <option value="">Seleccione...</option>
                            <option value="masculino">Masculino</option>
                            <option value="femenino">Femenino</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="edadApoyo${supportCounter}">Edad:</label>
                        <select id="edadApoyo${supportCounter}" name="edadApoyo${supportCounter}">
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="ocupacionApoyo${supportCounter}">Ocupación:</label>
                        <select id="ocupacionApoyo${supportCounter}" name="ocupacionApoyo${supportCounter}">
                            <option value="">Seleccione...</option>
                            <option value="empleado">Empleado</option>
                            <option value="independiente">Trabajador Independiente</option>
                            <option value="desempleado">Desempleado</option>
                            <option value="estudiante">Estudiante</option>
                            <option value="pensionado">Pensionado</option>
                            <option value="hogar">Labores del hogar</option>
                            <option value="otro">Otro</option>
                        </select>
                    </div>
                </div>
                
                <button type="button" class="btn-secondary" onclick="removeSupportInfo(${supportCounter})" 
                        style="margin-top: 10px; background: #f56565; color: white;">
                    <i class="fas fa-trash"></i> Eliminar
                </button>
            </div>
        `;
        
        container.appendChild(newSupport);
        
        // Generar opciones de edad para el nuevo select
        const selectEdad = document.getElementById(`edadApoyo${supportCounter}`);
        for (let i = 1; i <= 120; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = i + ' años';
            selectEdad.appendChild(option);
        }
        
        // Poblar select de relación con datos de la API o datos dummy
        const relacionesData = dataCache?.relacionesEstudiante || [
            { id: 1, nombre: 'Madre' },
            { id: 2, nombre: 'Padre' },
            { id: 3, nombre: 'Abuelo/a' },
            { id: 4, nombre: 'Hermano/a' },
            { id: 5, nombre: 'Tío/a' },
            { id: 6, nombre: 'Primo/a' },
            { id: 7, nombre: 'Amigo/a de la familia' },
            { id: 8, nombre: 'Vecino/a' }
        ];
        
        _populateSelectWithOther(`relacionApoyo${supportCounter}`, relacionesData);
        
        // Configurar event listener para campo condicional
        const relacionApoyoSelect = document.getElementById(`relacionApoyo${supportCounter}`);
        if (relacionApoyoSelect) {
            relacionApoyoSelect.addEventListener('change', () => 
                _handleSelectWithOther(`relacionApoyo${supportCounter}`, `otroRelacionApoyo${supportCounter}Group`));
        }
        
        // Ocultar botón si se alcanza el máximo
        if (supportCounter >= maxSupports) {
            document.getElementById('addSupportBtn').style.display = 'none';
        }
    }

    function removeSupportInfo(id) {
        const element = document.getElementById(`supportGroup${id}`);
        if (element) {
            element.remove();
            supportCounter--;
            // Mostrar botón nuevamente
            document.getElementById('addSupportBtn').style.display = 'inline-flex';
        }
    }

    // Funciones para campos condicionales adicionales
    function _handlePadresVivenJuntosChange() {
        const selectedValue = document.querySelector('input[name="padresVivenJuntos"]:checked')?.value;
        const tipoUnionGroup = document.getElementById('tipoUnionGroup');
        const tiempoSeparacionGroup = document.getElementById('tiempoSeparacionGroup');
        
        if (selectedValue === 'si') {
            tipoUnionGroup.style.display = 'block';
            tiempoSeparacionGroup.style.display = 'none';
            document.getElementById('tiempoSeparacion').value = '';
        } else if (selectedValue === 'no') {
            tipoUnionGroup.style.display = 'none';
            tiempoSeparacionGroup.style.display = 'block';
            document.getElementById('tipoUnion').value = '';
        } else {
            tipoUnionGroup.style.display = 'none';
            tiempoSeparacionGroup.style.display = 'none';
        }
    }

    function _handleEnfermedadPrimerAnoChange() {
        const selectedValue = document.querySelector('input[name="enfermedadPrimerAno"]:checked')?.value;
        const cualEnfermedadGroup = document.getElementById('cualEnfermedadGroup');
        
        if (selectedValue === 'si') {
            cualEnfermedadGroup.style.display = 'block';
        } else {
            cualEnfermedadGroup.style.display = 'none';
            document.getElementById('cualEnfermedad').value = '';
        }
    }

    // Funciones para manejar campos con "Otro" opcional
    function _handleSelectWithOther(selectId, groupId) {
        const select = document.getElementById(selectId);
        const group = document.getElementById(groupId);
        
        if (select && group) {
            // Verificar si se seleccionó "Otro" (puede ser por valor de texto o ID numérico)
            const selectedValue = select.value.toLowerCase();
            const selectedText = select.options[select.selectedIndex]?.text?.toLowerCase() || '';
            
            if (selectedValue === 'otro' || selectedValue === 'otros' || selectedValue === '9' || 
                selectedText.includes('otro')) {
                group.style.display = 'block';
            } else {
                group.style.display = 'none';
                const input = group.querySelector('input');
                if (input) input.value = '';
            }
        }
    }

    function _handleAlimentacionChange() {
        const selectedValue = document.getElementById('alimentacionPrimerAno').value;
        const mesesLactanciaGroup = document.getElementById('mesesLactanciaGroup');
        
        if (selectedValue === 'lactancia_exclusiva') {
            mesesLactanciaGroup.style.display = 'block';
        } else {
            mesesLactanciaGroup.style.display = 'none';
            document.getElementById('mesesLactancia').value = '';
        }
    }

    function _handleDificultadesMotorChange() {
        const selectedValue = document.querySelector('input[name="dificultadesMotor"]:checked')?.value;
        const etapaGroup = document.getElementById('etapaMotorGroup');
        
        if (selectedValue === 'si') {
            etapaGroup.style.display = 'block';
        } else {
            etapaGroup.style.display = 'none';
            document.getElementById('etapaMotor').value = '';
        }
    }

    // Funciones para nuevos campos del Anexo 1

    function _handleCheckboxOtroChange(checkboxId, groupId) {
        const checkbox = document.getElementById(checkboxId);
        const group = document.getElementById(groupId);
        
        if (checkbox && group) {
            if (checkbox.checked) {
                group.style.display = 'block';
            } else {
                group.style.display = 'none';
                const input = group.querySelector('input');
                if (input) input.value = '';
            }
        }
    }

    function _handleDificultadesEscolaridadChange() {
        const selectedValue = document.querySelector('input[name="dificultadesEscolaridad"]:checked')?.value;
        const cualesGroup = document.getElementById('cualesDificultadesGroup');
        
        if (selectedValue === 'si') {
            cualesGroup.style.display = 'block';
        } else {
            cualesGroup.style.display = 'none';
            document.getElementById('cualesDificultades').value = '';
            // También ocultar el grupo "otro" si estaba visible
            const otroGroup = document.getElementById('otroCualesDificultadesGroup');
            if (otroGroup) {
                otroGroup.style.display = 'none';
                const input = otroGroup.querySelector('input');
                if (input) input.value = '';
            }
        }
    }

    function _handleInformoEstudianteChange() {
        const selectedValue = document.querySelector('input[name="informoEstudiante"]:checked')?.value;
        const quienInformoGroup = document.getElementById('quienInformoEstudianteGroup');
        const comoAsumioGroup = document.getElementById('comoAsumioEstudianteGroup');
        
        if (selectedValue === 'si') {
            quienInformoGroup.style.display = 'block';
            comoAsumioGroup.style.display = 'block';
        } else {
            quienInformoGroup.style.display = 'none';
            comoAsumioGroup.style.display = 'none';
            document.getElementById('quienInformoEstudiante').value = '';
            // Limpiar radio buttons de cómo asumió
            const radioButtons = document.querySelectorAll('input[name="comoAsumioEstudiante"]');
            radioButtons.forEach(radio => radio.checked = false);
        }
    }

    function _handleContinuanTerapiasChange() {
        const selectedValue = document.querySelector('input[name="continuanTerapias"]:checked')?.value;
        const porqueDetuvoGroup = document.getElementById('porqueDetuvoTerapiasGroup');
        
        if (selectedValue === 'no') {
            porqueDetuvoGroup.style.display = 'block';
        } else {
            porqueDetuvoGroup.style.display = 'none';
            document.getElementById('porqueDetuvoTerapias').value = '';
            // También ocultar el grupo "otro" si estaba visible
            const otroGroup = document.getElementById('otroPorqueDetuvoTerapiasGroup');
            if (otroGroup) {
                otroGroup.style.display = 'none';
                const input = otroGroup.querySelector('input');
                if (input) input.value = '';
            }
        }
    }
    
    async function _loadSelectData() {
        try {
            // Cargar tipos de documento para el estudiante, madre y padre
            const tiposDocumento = await _fetchParametrizacion('tipos-documento');
            _populateSelect('tipoDocumento', tiposDocumento);
            _populateSelect('tipoDocumentoMadre', tiposDocumento);
            _populateSelect('tipoDocumentoPadre', tiposDocumento);
            
            // Cargar géneros
            const generos = await _fetchParametrizacion('generos');
            _populateSelect('genero', generos);
            _populateSelect('generoPersona1', generos);
            
            // Cargar barrios
            const barrios = await _fetchParametrizacion('barrios');
            _populateSelect('barrio', barrios);
            
            // Cargar EPS
            const eps = await _fetchParametrizacion('eps');
            _populateSelectWithOther('eps', eps);
            
            // Cargar instituciones de rehabilitación
            const instituciones = await _fetchParametrizacion('instituciones-rehabilitacion');
            _populateSelect('institucionRehabilitacion', instituciones);
            
            // Cargar frecuencias de rehabilitación
            const frecuencias = await _fetchParametrizacion('frecuencias-rehabilitacion');
            _populateSelect('frecuenciaRehabilitacion', frecuencias);
            
            // Cargar frecuencias de medicamentos
            const frecuenciasMedicamentos = await _fetchParametrizacion('frecuencias-medicamentos');
            _populateSelect('frecuenciaMedicamentos', frecuenciasMedicamentos);
            
            // Cargar horarios de medicamentos
            const horariosMedicamentos = await _fetchParametrizacion('horarios-medicamentos');
            _populateSelectWithOther('horarioMedicamentos', horariosMedicamentos);
            
            // Cargar categorías SIMAT
            const categoriasSIMAT = await _fetchParametrizacion('categorias-simat');
            _populateSelect('diagnostico', categoriasSIMAT);
            
            // Cargar grupos étnicos
            const gruposEtnicos = await _fetchParametrizacion('grupos-etnicos');
            console.log('Grupos étnicos cargados desde API:', gruposEtnicos);
            _populateSelect('grupoEtnico', gruposEtnicos);
            _populateSelect('grupoEtnicoMadre', gruposEtnicos);
            _populateSelect('grupoEtnicoPadre', gruposEtnicos);
            
            // Cargar departamentos
            const departamentos = await _fetchParametrizacion('departamentos');
            _populateSelect('departamento', departamentos);
            _populateSelect('departamentoMadre', departamentos);
            _populateSelect('departamentoPadre', departamentos);
            
            // Cargar colegios
            const colegios = await _fetchParametrizacion('colegios');
            _populateSelectWithOther('establecimientoEducativo', colegios);
            
            // Cargar niveles educativos
            const nivelesEducativos = await _fetchParametrizacion('niveles-educativos');
            _populateSelect('nivelEducativoMadre', nivelesEducativos);
            _populateSelect('nivelEducativoPadre', nivelesEducativos);
            
            // Cargar ingresos promedios mensuales
            const ingresosPromediosMensuales = await _fetchParametrizacion('ingresos-promedios-mensuales');
            _populateSelect('ingresosMadre', ingresosPromediosMensuales);
            _populateSelect('ingresosPadre', ingresosPromediosMensuales);
            _populateSelect('promedioIngresos', ingresosPromediosMensuales);
            
            // Cargar relaciones con el estudiante
            const relacionesEstudiante = await _fetchParametrizacion('relaciones-estudiante');
            _populateSelectWithOther('conQuienVive1', relacionesEstudiante);
            _populateSelectWithOther('relacionEstudiante1', relacionesEstudiante);
            _populateSelectWithOther('relacionApoyo1', relacionesEstudiante);
            
            // Guardar datos en cache para uso en campos dinámicos
            dataCache = {
                relacionesEstudiante: relacionesEstudiante
            };
            
        } catch (error) {
            console.error('Error cargando datos de parametrización:', error);
            // Cargar datos dummy en caso de error
            _loadDummyData();
        }
    }
    
    function _loadDummyData() {
        // Datos dummy para cuando no hay conexión a la base de datos
        const dummyData = {
            tiposDocumento: [
                { id: 1, nombre: 'Cédula de Ciudadanía' },
                { id: 2, nombre: 'Tarjeta de Identidad' },
                { id: 3, nombre: 'Registro Civil' }
            ],
            generos: [
                { id: 1, nombre: 'Masculino' },
                { id: 2, nombre: 'Femenino' },
                { id: 3, nombre: 'Otro' }
            ],
            barrios: [
                { id: 1, nombre: 'Casco Urbano' },
                { id: 2, nombre: 'Villa del Rosario' },
                { id: 3, nombre: 'Bosques de Floridablanca' }
            ],
            eps: [
                { id: 1, nombre: 'EPS SURA' },
                { id: 2, nombre: 'Nueva EPS' },
                { id: 3, nombre: 'EPS Sanitas' },
                { id: 999, nombre: 'Otro' }
            ],
            instituciones: [
                { id: 1, nombre: 'FOSCAL' },
                { id: 2, nombre: 'Centro de Rehabilitación Integral' }
            ],
            frecuencias: [
                { id: 1, nombre: 'Diaria' },
                { id: 2, nombre: 'Semanal' },
                { id: 3, nombre: 'Quincenal' }
            ],
            departamentos: [
                { id: 1, nombre: 'Santander' },
                { id: 2, nombre: 'Antioquia' },
                { id: 3, nombre: 'Cundinamarca' }
            ],
            diagnosticos: [
                { id: 1, nombre: 'TDAH' },
                { id: 2, nombre: 'Autismo' },
                { id: 3, nombre: 'Discapacidad Intelectual' },
                { id: 4, nombre: 'Discapacidad Física' }
            ],
            frecuenciasMedicamentos: [
                { id: 1, nombre: 'Una vez al día' },
                { id: 2, nombre: 'Dos veces al día' },
                { id: 3, nombre: 'Tres veces al día' },
                { id: 4, nombre: 'Cada 8 horas' }
            ],
            horariosMedicamentos: [
                { id: 1, nombre: 'Mañana' },
                { id: 2, nombre: 'Tarde' },
                { id: 3, nombre: 'Noche' },
                { id: 4, nombre: 'Mañana y Noche' }
            ],
            gruposEtnicos: [
                { id: 1, nombre: 'Indígena' },
                { id: 2, nombre: 'Negro, Mulato, Afrocolombiano o Afrodescendiente' },
                { id: 3, nombre: 'Raizal del Archipiélago de San Andrés, Providencia y Santa Catalina' },
                { id: 4, nombre: 'Palenquero de San Basilio' },
                { id: 5, nombre: 'Rrom o Gitano' },
                { id: 6, nombre: 'Ninguno de los anteriores' },
                { id: 7, nombre: 'Otro' }
            ],
            establecimientos: [
                { id: 1, nombre: 'IE San José' },
                { id: 2, nombre: 'IE La Presentación' },
                { id: 3, nombre: 'IE Técnico Industrial' },
                { id: 7, nombre: 'Otro' }
            ],
            nivelesEducativos: [
                { id: 1, nombre: 'Preescolar' },
                { id: 2, nombre: 'Básica Primaria' },
                { id: 3, nombre: 'Básica Secundaria' },
                { id: 4, nombre: 'Media Académica' },
                { id: 5, nombre: 'Técnico Laboral' },
                { id: 6, nombre: 'Tecnólogo' },
                { id: 7, nombre: 'Educación Superior - Pregrado / Profesional' },
                { id: 8, nombre: 'Especialización' },
                { id: 9, nombre: 'Maestría' },
                { id: 10, nombre: 'Doctorado' },
                { id: 11, nombre: 'Posdoctorado' },
                { id: 12, nombre: 'Ninguno' }
            ],
            ingresos: [
                { id: 1, nombre: 'Sin ingresos' },
                { id: 2, nombre: 'Menos de 1 salario mínimo' },
                { id: 3, nombre: 'De 1 a menos de 2 SMMLV' },
                { id: 4, nombre: 'De 2 a menos de 3 SMMLV' },
                { id: 5, nombre: 'De 3 a menos de 5 SMMLV' },
                { id: 6, nombre: 'Más de 5 SMMLV' }
            ],
            relacionesEstudiante: [
                { id: 1, nombre: 'Madre' },
                { id: 2, nombre: 'Padre' },
                { id: 3, nombre: 'Abuelo/a' },
                { id: 4, nombre: 'Hermano/a' },
                { id: 5, nombre: 'Tío/a' },
                { id: 6, nombre: 'Primo/a' },
                { id: 7, nombre: 'Amigo/a de la familia' },
                { id: 8, nombre: 'Vecino/a' }
            ]
        };
        
        // Cargar datos básicos del estudiante
        _populateSelect('tipoDocumento', dummyData.tiposDocumento);
        _populateSelect('genero', dummyData.generos);
        _populateSelect('barrio', dummyData.barrios);
        _populateSelectWithOther('eps', dummyData.eps);
        _populateSelect('institucionRehabilitacion', dummyData.instituciones);
        _populateSelect('frecuenciaRehabilitacion', dummyData.frecuencias);
        _populateSelect('departamento', dummyData.departamentos);
        
        // Cargar nuevos datos del estudiante
        // _populateSelect('diagnostico', dummyData.diagnosticos); // Se carga desde API
        _populateSelect('frecuenciaMedicamentos', dummyData.frecuenciasMedicamentos);
        _populateSelectWithOther('horarioMedicamentos', dummyData.horariosMedicamentos);
        _populateSelect('grupoEtnico', dummyData.gruposEtnicos); // Fallback si API falla
        _populateSelectWithOther('establecimientoEducativo', dummyData.establecimientos);
        
        // Cargar datos de la madre
        _populateSelect('tipoDocumentoMadre', dummyData.tiposDocumento);
        console.log('Cargando grupos étnicos dummy para madre:', dummyData.gruposEtnicos);
        _populateSelect('grupoEtnicoMadre', dummyData.gruposEtnicos); // Fallback si API falla
        _populateSelect('nivelEducativoMadre', dummyData.nivelesEducativos);
        _populateSelect('ingresosMadre', dummyData.ingresos);
        _populateSelect('departamentoMadre', dummyData.departamentos);
        
        // Cargar datos del padre
        _populateSelect('tipoDocumentoPadre', dummyData.tiposDocumento);
        console.log('Cargando grupos étnicos dummy para padre:', dummyData.gruposEtnicos);
        _populateSelect('grupoEtnicoPadre', dummyData.gruposEtnicos); // Fallback si API falla
        _populateSelect('nivelEducativoPadre', dummyData.nivelesEducativos);
        _populateSelect('ingresosPadre', dummyData.ingresos);
        _populateSelect('departamentoPadre', dummyData.departamentos);
        
        // Cargar ingresos de la familia
        _populateSelect('promedioIngresos', dummyData.ingresos);
        
        // Cargar relaciones con el estudiante
        _populateSelectWithOther('conQuienVive1', dummyData.relacionesEstudiante);
        _populateSelectWithOther('relacionEstudiante1', dummyData.relacionesEstudiante);
        _populateSelectWithOther('relacionApoyo1', dummyData.relacionesEstudiante);
        
        // Guardar datos dummy en cache para uso en campos dinámicos
        dataCache = {
            relacionesEstudiante: dummyData.relacionesEstudiante
        };
    }
    
    function _loadDummyEpsData() {
        // Datos dummy de EPS para cuando falla la conexión
        const dummyEps = [
            { id: 1, nombre: 'ASMETSALUD' },
            { id: 2, nombre: 'COOSALUD' },
            { id: 3, nombre: 'COOMEVA' },
            { id: 4, nombre: 'FAMISANAR' },
            { id: 5, nombre: 'NUEVA EPS' },
            { id: 6, nombre: 'SANITAS' },
            { id: 7, nombre: 'SURA' },
            { id: 999, nombre: 'Otro' } // ID consistente con la base de datos - siempre al final
        ];
        _populateSelectWithOther('eps', dummyEps);
    }
    
    async function _fetchParametrizacion(tipo) {
        try {
            const response = await fetch(`http://localhost:3000/api/${tipo}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (!result.success || !result.data) {
                throw new Error('Error en la respuesta de la API');
            }
            
            // Transformar datos para que coincidan con el formato esperado
            if (tipo === 'tipos-documento') {
                return result.data.map(item => ({
                    id: item.codigo, // Usar código como ID para tipos de documento
                    nombre: item.descripcion
                }));
            }
            
            if (tipo === 'departamentos') {
                return result.data.map(item => ({
                    id: item.id_departamento,
                    nombre: item.descripcion
                }));
            }
            
            if (tipo === 'generos') {
                return result.data.map(item => ({
                    id: item.id_genero,
                    nombre: item.descripcion
                }));
            }
            
            if (tipo === 'eps') {
                return result.data.map(item => ({
                    id: item.id_eps,
                    nombre: item.nombre
                }));
            }
            
            if (tipo === 'frecuencias-rehabilitacion') {
                return result.data.map(item => ({
                    id: item.id_frecuencia,
                    nombre: item.nombre
                }));
            }
            
            if (tipo === 'frecuencias-medicamentos') {
                return result.data.map(item => ({
                    id: item.id_frecuencia_medicamento,
                    nombre: item.nombre
                }));
            }
            
            if (tipo === 'horarios-medicamentos') {
                return result.data.map(item => ({
                    id: item.id_horario_medicamento,
                    nombre: item.nombre
                }));
            }
            
            if (tipo === 'categorias-simat') {
                return result.data.map(item => ({
                    id: item.id_categoria_simat,
                    nombre: item.nombre
                }));
            }
            
            return result.data.map(item => ({
                id: item.id,
                nombre: item.nombre || item.descripcion
            }));
        } catch (error) {
            console.error(`Error obteniendo datos de ${tipo}:`, error);
            return [];
        }
    }
    
    function _populateSelect(selectId, data) {
        const select = document.getElementById(selectId);
        if (!select) return;
        
        // Limpiar opciones existentes (excepto la primera)
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // Agregar nuevas opciones
        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item.id;
            
            // Para tipos de documento, mostrar código + descripción
            if (selectId.includes('tipoDocumento')) {
                option.textContent = `${item.id} - ${item.nombre}`;
            } else {
                option.textContent = item.nombre;
            }
            
            select.appendChild(option);
        });
    }
    
    function _populateSelectWithOther(selectId, data) {
        const select = document.getElementById(selectId);
        if (!select) return;
        
        // Limpiar opciones existentes (excepto la primera)
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // Verificar si ya existe una opción "Otro" en los datos
        const hasOtroInData = data.some(item => 
            item.nombre.toLowerCase() === 'otro' || 
            item.nombre.toLowerCase() === 'otros'
        );
        
        // Agregar opciones de datos
        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item.id;
            option.textContent = item.nombre;
            select.appendChild(option);
        });
        
        // Solo agregar opción "Otro" si no existe en los datos de la base de datos
        if (!hasOtroInData) {
            const otherOption = document.createElement('option');
            otherOption.value = 'otro';
            otherOption.textContent = 'Otro';
            select.appendChild(otherOption);
        }
    }
    
    function _handleEpsChange() {
        const epsSelect = document.getElementById('eps');
        const epsOtroGroup = document.getElementById('epsOtroGroup');
        
        if (!epsSelect || !epsOtroGroup) return;
        
        // Verificar si se seleccionó "otro" (valor temporal) o "999" (ID de la base de datos)
        if (epsSelect.value === 'otro' || epsSelect.value === '999') {
            epsOtroGroup.style.display = 'block';
            document.getElementById('epsOtro').required = true;
        } else {
            epsOtroGroup.style.display = 'none';
            document.getElementById('epsOtro').required = false;
            document.getElementById('epsOtro').value = '';
        }
    }
    
    function _handleHorarioMedicamentosChange() {
        const horarioSelect = document.getElementById('horarioMedicamentos');
        const horarioOtroGroup = document.getElementById('horarioMedicamentosOtroGroup');
        
        if (!horarioSelect || !horarioOtroGroup) return;
        
        if (horarioSelect.value === 'otro') {
            horarioOtroGroup.style.display = 'block';
            document.getElementById('horarioMedicamentosOtro').required = true;
        } else {
            horarioOtroGroup.style.display = 'none';
            document.getElementById('horarioMedicamentosOtro').required = false;
            document.getElementById('horarioMedicamentosOtro').value = '';
        }
    }
    
    function _handleEstablecimientoEducativoChange() {
        const establecimientoSelect = document.getElementById('establecimientoEducativo');
        const establecimientoOtroGroup = document.getElementById('establecimientoEducativoOtroGroup');
        
        if (!establecimientoSelect || !establecimientoOtroGroup) return;
        
        // Verificar tanto por valor como por texto
        const isOtro = establecimientoSelect.value === '7' || 
                      establecimientoSelect.value === 7 ||
                      establecimientoSelect.options[establecimientoSelect.selectedIndex]?.text === 'Otro';
        
        if (isOtro) {
            establecimientoOtroGroup.style.display = 'block';
            document.getElementById('establecimientoEducativoOtro').required = true;
        } else {
            establecimientoOtroGroup.style.display = 'none';
            document.getElementById('establecimientoEducativoOtro').required = false;
            document.getElementById('establecimientoEducativoOtro').value = '';
        }
    }
    
    function _handleGrupoEtnicoChange() {
        const grupoEtnicoSelect = document.getElementById('grupoEtnico');
        const grupoEtnicoOtroGroup = document.getElementById('grupoEtnicoOtroGroup');
        
        if (!grupoEtnicoSelect || !grupoEtnicoOtroGroup) return;
        
        // Verificar tanto por valor como por texto
        const isOtro = grupoEtnicoSelect.value === '7' || 
                      grupoEtnicoSelect.value === 7 ||
                      grupoEtnicoSelect.options[grupoEtnicoSelect.selectedIndex]?.text === 'Otro';
        
        if (isOtro) {
            grupoEtnicoOtroGroup.style.display = 'block';
            document.getElementById('grupoEtnicoOtro').required = true;
        } else {
            grupoEtnicoOtroGroup.style.display = 'none';
            document.getElementById('grupoEtnicoOtro').required = false;
            document.getElementById('grupoEtnicoOtro').value = '';
        }
    }
    
    function _handleGrupoEtnicoMadreChange() {
        const grupoEtnicoMadreSelect = document.getElementById('grupoEtnicoMadre');
        const grupoEtnicoMadreOtroGroup = document.getElementById('grupoEtnicoMadreOtroGroup');
        
        console.log('_handleGrupoEtnicoMadreChange ejecutado');
        console.log('Valor seleccionado:', grupoEtnicoMadreSelect?.value);
        console.log('Elemento grupoEtnicoMadreOtroGroup encontrado:', !!grupoEtnicoMadreOtroGroup);
        
        if (!grupoEtnicoMadreSelect || !grupoEtnicoMadreOtroGroup) return;
        
        // Verificar si se seleccionó "Otro" (por ID o por texto)
        const selectedValue = grupoEtnicoMadreSelect.value;
        const selectedText = grupoEtnicoMadreSelect.options[grupoEtnicoMadreSelect.selectedIndex]?.text?.toLowerCase() || '';
        const isOtro = selectedValue === '7' || selectedValue === 'otro' || selectedText.includes('otro');
        
        if (isOtro) {
            console.log('Mostrando campo "Indique otro" para madre');
            grupoEtnicoMadreOtroGroup.style.display = 'block';
            document.getElementById('grupoEtnicoMadreOtro').required = true;
        } else {
            console.log('Ocultando campo "Indique otro" para madre');
            grupoEtnicoMadreOtroGroup.style.display = 'none';
            document.getElementById('grupoEtnicoMadreOtro').required = false;
            document.getElementById('grupoEtnicoMadreOtro').value = '';
        }
    }
    
    function _handleGrupoEtnicoPadreChange() {
        const grupoEtnicoPadreSelect = document.getElementById('grupoEtnicoPadre');
        const grupoEtnicoPadreOtroGroup = document.getElementById('grupoEtnicoPadreOtroGroup');
        
        console.log('_handleGrupoEtnicoPadreChange ejecutado');
        console.log('Valor seleccionado:', grupoEtnicoPadreSelect?.value);
        console.log('Elemento grupoEtnicoPadreOtroGroup encontrado:', !!grupoEtnicoPadreOtroGroup);
        
        if (!grupoEtnicoPadreSelect || !grupoEtnicoPadreOtroGroup) return;
        
        // Verificar si se seleccionó "Otro" (por ID o por texto)
        const selectedValue = grupoEtnicoPadreSelect.value;
        const selectedText = grupoEtnicoPadreSelect.options[grupoEtnicoPadreSelect.selectedIndex]?.text?.toLowerCase() || '';
        const isOtro = selectedValue === '7' || selectedValue === 'otro' || selectedText.includes('otro');
        
        if (isOtro) {
            console.log('Mostrando campo "Indique otro" para padre');
            grupoEtnicoPadreOtroGroup.style.display = 'block';
            document.getElementById('grupoEtnicoPadreOtro').required = true;
        } else {
            console.log('Ocultando campo "Indique otro" para padre');
            grupoEtnicoPadreOtroGroup.style.display = 'none';
            document.getElementById('grupoEtnicoPadreOtro').required = false;
            document.getElementById('grupoEtnicoPadreOtro').value = '';
        }
    }
    
    async function _handleDepartamentoChange() {
        const departamentoId = departamentoSelect.value;
        
        if (!departamentoId) {
            municipioSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
            return;
        }
        
        try {
            // Cargar municipios del departamento seleccionado
            municipioSelect.innerHTML = '<option value="">Cargando municipios...</option>';
            
            const response = await fetch(`http://localhost:3000/api/departamentos/${departamentoId}/municipios`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (!result.success || !result.data) {
                throw new Error('Error en la respuesta de la API');
            }
            
            const municipios = result.data.map(item => ({
                id: item.id_municipio,
                nombre: item.descripcion
            }));
            
            municipioSelect.innerHTML = '<option value="">Seleccione...</option>';
            _populateSelect('municipio', municipios);
            
        } catch (error) {
            console.error('Error cargando municipios:', error);
            municipioSelect.innerHTML = '<option value="">Error cargando municipios</option>';
        }
    }
    
    function _validateForm() {
        let isValid = true;
        const requiredFields = studentForm.querySelectorAll('[required]');
        
        requiredFields.forEach(field => {
            const errorElement = document.getElementById(field.name + 'Error');
            
            if (!field.value.trim()) {
                _showFieldError(field, 'Este campo es obligatorio');
                isValid = false;
            } else {
                _hideFieldError(field);
            }
        });
        
        // Validaciones específicas
        const email = document.getElementById('email');
        if (email && email.value && !_isValidEmail(email.value)) {
            _showFieldError(email, 'Ingrese un correo electrónico válido');
            isValid = false;
        }

        // Validaciones específicas del PIAR Anexo 1
        
        // Validar documento de identidad del estudiante
        const tipoDocumento = document.getElementById('tipoDocumento');
        const numeroDocumento = document.getElementById('numeroDocumento');
        if (tipoDocumento && numeroDocumento) {
            if (tipoDocumento.value && !numeroDocumento.value.trim()) {
                _showFieldError(numeroDocumento, 'El número de documento es obligatorio');
                isValid = false;
            } else if (numeroDocumento.value.trim() && !tipoDocumento.value) {
                _showFieldError(tipoDocumento, 'El tipo de documento es obligatorio');
                isValid = false;
            }
        }

        // Validar fecha de nacimiento (no debe ser futura)
        const fechaNacimiento = document.getElementById('fechaNacimiento');
        if (fechaNacimiento && fechaNacimiento.value) {
            const fechaNac = new Date(fechaNacimiento.value);
            const hoy = new Date();
            if (fechaNac > hoy) {
                _showFieldError(fechaNacimiento, 'La fecha de nacimiento no puede ser futura');
                isValid = false;
            }
            // Validar que no sea demasiado antigua (más de 100 años)
            const hace100Anos = new Date();
            hace100Anos.setFullYear(hace100Anos.getFullYear() - 100);
            if (fechaNac < hace100Anos) {
                _showFieldError(fechaNacimiento, 'La fecha de nacimiento no puede ser anterior a 100 años');
                isValid = false;
            }
        }

        // Validar categoría SIMAT (requerida para el sistema)
        const categoriaSimat = document.getElementById('categoriaSimat');
        if (categoriaSimat && !categoriaSimat.value) {
            _showFieldError(categoriaSimat, 'La categoría SIMAT es obligatoria');
            isValid = false;
        }

        // Validar institución educativa
        const institucionEducativa = document.getElementById('institucionEducativa');
        if (institucionEducativa && !institucionEducativa.value.trim()) {
            _showFieldError(institucionEducativa, 'La institución educativa es obligatoria');
            isValid = false;
        }
        
        return isValid;
    }
    
    function _isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    function _showFieldError(field, message) {
        const formGroup = field.closest('.form-group');
        const errorElement = formGroup.querySelector('.error-message');
        
        formGroup.classList.add('error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.add('show');
        }
    }
    
    function _hideFieldError(field) {
        const formGroup = field.closest('.form-group');
        const errorElement = formGroup.querySelector('.error-message');
        
        formGroup.classList.remove('error');
        if (errorElement) {
            errorElement.classList.remove('show');
        }
    }
    
    // Función para mostrar notificaciones del PIAR
    function _showNotificationPiar(type, title, message) {
        const notificacion = document.createElement('div');
        notificacion.className = `notification-barriers ${type}`;
        
        const icon = type === 'success' ? '✅' : type === 'error' ? '⚠️' : 'ℹ️';
        
        notificacion.innerHTML = `
            <div class="notification-content">
                <i class="notification-icon">${icon}</i>
                <div class="notification-text">
                    <strong>${title}</strong><br>
                    <small>${message}</small>
                </div>
                <button class="notification-close">×</button>
            </div>
        `;
        
        document.body.appendChild(notificacion);
        
        // Auto-cerrar después de 8 segundos para éxito, 10 segundos para error
        const autoCloseTime = type === 'error' ? 10000 : 8000;
        setTimeout(() => {
            if (notificacion.parentNode) {
                notificacion.remove();
            }
        }, autoCloseTime);
        
        // Evento para cerrar manualmente
        notificacion.querySelector('.notification-close').addEventListener('click', () => {
            notificacion.remove();
        });
    }

    // Función placeholder - sin guardado en base de datos
    async function _saveFormularioPiarAnexo1(data) {
        // Simulamos una respuesta exitosa sin guardar realmente
        console.log('Datos del formulario (sin guardar):', data);
        
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve({ 
                    success: true, 
                    message: 'Formulario procesado (sin guardado en base de datos)' 
                });
            }, 500);
        });
    }

    function _handleFormSubmit(e) {
        e.preventDefault();
        
        if (_validateForm()) {
            // Mostrar mensaje de guardado
            const saveButton = document.querySelector('.btn-primary[type="submit"]');
            const originalText = saveButton.innerHTML;
            saveButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
            saveButton.disabled = true;
            
            try {
                // Recolectar datos base del formulario
                const formData = new FormData(studentForm);
                const data = Object.fromEntries(formData.entries());
                
                // Recolectar composición familiar dinámica
                const composicionFamiliar = [];
                for (let i = 1; i <= compositionCounter; i++) {
                    const conQuienVive = document.getElementById(`conQuienVive${i}`);
                    const nombrePersona = document.getElementById(`nombrePersona${i}`);
                    const relacionEstudiante = document.getElementById(`relacionEstudiante${i}`);
                    
                    if (conQuienVive && conQuienVive.value) {
                        const persona = {
                            con_quien_vive: conQuienVive.value,
                            nombre_persona: nombrePersona ? nombrePersona.value : '',
                            relacion_estudiante: relacionEstudiante ? relacionEstudiante.value : ''
                        };
                        
                        // Agregar campos "otro" si están presentes y visibles
                        const otroConQuienVive = document.getElementById(`otroConQuienVive${i}`);
                        const otroRelacionEstudiante = document.getElementById(`otroRelacionEstudiante${i}`);
                        
                        if (otroConQuienVive && otroConQuienVive.offsetParent !== null) {
                            persona.otro_con_quien_vive = otroConQuienVive.value || '';
                        }
                        if (otroRelacionEstudiante && otroRelacionEstudiante.offsetParent !== null) {
                            persona.otro_relacion_estudiante = otroRelacionEstudiante.value || '';
                        }
                        
                        composicionFamiliar.push(persona);
                    }
                }
                
                // Recolectar figuras de apoyo dinámicas
                const figurasApoyo = [];
                for (let i = 1; i <= supportCounter; i++) {
                    const nombreApoyo = document.getElementById(`nombreApoyo${i}`);
                    const relacionApoyo = document.getElementById(`relacionApoyo${i}`);
                    const generoApoyo = document.getElementById(`generoApoyo${i}`);
                    const edadApoyo = document.getElementById(`edadApoyo${i}`);
                    
                    if (nombreApoyo && nombreApoyo.value) {
                        const figura = {
                            nombre_figura: nombreApoyo.value,
                            relacion_figura: relacionApoyo ? relacionApoyo.value : '',
                            genero_figura: generoApoyo ? generoApoyo.value : '',
                            edad_figura: edadApoyo ? edadApoyo.value : ''
                        };
                        
                        // Agregar campo "otro" si está presente y visible
                        const otroRelacionApoyo = document.getElementById(`otroRelacionApoyo${i}`);
                        if (otroRelacionApoyo && otroRelacionApoyo.offsetParent !== null) {
                            figura.otro_relacion_figura = otroRelacionApoyo.value || '';
                        }
                        
                        figurasApoyo.push(figura);
                    }
                }
                
                // Agregar arrays dinámicos al objeto de datos
                data.composicionFamiliar = composicionFamiliar;
                data.figurasApoyo = figurasApoyo;
                
                console.log('Datos del formulario a enviar:', data);
                
                // Procesar datos sin guardar en base de datos
                _saveFormularioPiarAnexo1(data).then((result) => {
                    // Éxito - Mostrar notificación
                    _showNotificationPiar('success', 'Datos procesados correctamente', 'El formulario ha sido procesado. Nota: Los datos no se guardan en base de datos.');
                    
                    // Opcional: Limpiar formulario después de procesar
                    // _clearForm();
                }).catch((error) => {
                    console.error('Error al procesar:', error);
                    _showNotificationPiar('error', 'Error al procesar', error.message || 'Ha ocurrido un error inesperado al procesar el formulario.');
                }).finally(() => {
                    // Restaurar botón
                    saveButton.innerHTML = originalText;
                    saveButton.disabled = false;
                });
                
            } catch (error) {
                console.error('Error al procesar datos:', error);
                alert('Error al procesar los datos del formulario');
                
                // Restaurar botón
                saveButton.innerHTML = originalText;
                saveButton.disabled = false;
            }
        }
    }
    
    function _clearForm() {
        if (confirm('¿Está seguro de que desea limpiar todo el formulario?')) {
            studentForm.reset();
            
            // Ocultar todos los grupos condicionales
            epsGroup.style.display = 'none';
            rehabilitacionDetails.style.display = 'none';
            diagnosticoGroup.style.display = 'none';
            medicamentosDetails.style.display = 'none';
            grupoEtnicoGroup.style.display = 'none';
            
            // Ocultar campos "Otro" condicionales
            const epsOtroGroup = document.getElementById('epsOtroGroup');
            const horarioMedicamentosOtroGroup = document.getElementById('horarioMedicamentosOtroGroup');
            const grupoEtnicoOtroGroup = document.getElementById('grupoEtnicoOtroGroup');
            const grupoEtnicoMadreOtroGroup = document.getElementById('grupoEtnicoMadreOtroGroup');
            const grupoEtnicoPadreOtroGroup = document.getElementById('grupoEtnicoPadreOtroGroup');
            if (epsOtroGroup) epsOtroGroup.style.display = 'none';
            if (horarioMedicamentosOtroGroup) horarioMedicamentosOtroGroup.style.display = 'none';
            if (grupoEtnicoOtroGroup) grupoEtnicoOtroGroup.style.display = 'none';
            if (grupoEtnicoMadreOtroGroup) grupoEtnicoMadreOtroGroup.style.display = 'none';
            if (grupoEtnicoPadreOtroGroup) grupoEtnicoPadreOtroGroup.style.display = 'none';
            historialEducativoDetails.style.display = 'none';
            historialEducativoDetails2.style.display = 'none';
            historialEducativoDetails3.style.display = 'none';
            gradoEscolarDetails.style.display = 'none';
            cicloEscolarDetails.style.display = 'none';
            gradoAspiranteEscolarDetails.style.display = 'none';
            cicloAspiranteDetails.style.display = 'none';
            grupoEtnicoMadreGroup.style.display = 'none';
            grupoEtnicoPadreGroup.style.display = 'none';
            
            // Limpiar mensajes de error
            const errorMessages = studentForm.querySelectorAll('.error-message');
            errorMessages.forEach(error => error.classList.remove('show'));
            
            const formGroups = studentForm.querySelectorAll('.form-group');
            formGroups.forEach(group => group.classList.remove('error'));
            
            // Limpiar edad
            edadInput.value = '';
            
            // Resetear selects de municipios
            municipioSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
            municipioMadreSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
            municipioPadreSelect.innerHTML = '<option value="">Seleccione departamento primero...</option>';
        }
    }
    
    function _initEventListeners() {
        // Botón para habilitar formulario
        enableFormBtn.addEventListener('click', _enableForm);
        
        // Headers de sección para colapsar/expandir
        document.querySelectorAll('.section-header').forEach(header => {
            header.addEventListener('click', () => _toggleSection(header));
        });
        
        // Fecha de nacimiento para calcular edad
        fechaNacimientoInput.addEventListener('change', _calculateAge);
        
        // Validación numérica para campos del estudiante
        numeroDocumentoInput.addEventListener('input', () => _validateNumericInput(numeroDocumentoInput));
        telefonoInput.addEventListener('input', () => _validateNumericInput(telefonoInput));
        
        // Validación numérica para campos de la madre
        if (numeroDocumentoMadreInput) {
            numeroDocumentoMadreInput.addEventListener('input', () => _validateNumericInput(numeroDocumentoMadreInput));
        }
        if (telefonoMadreInput) {
            telefonoMadreInput.addEventListener('input', () => _validateNumericInput(telefonoMadreInput));
        }
        if (telefonoEmpresaMadreInput) {
            telefonoEmpresaMadreInput.addEventListener('input', () => _validateNumericInput(telefonoEmpresaMadreInput));
        }
        
        // Validación numérica para campos del padre
        if (numeroDocumentoPadreInput) {
            numeroDocumentoPadreInput.addEventListener('input', () => _validateNumericInput(numeroDocumentoPadreInput));
        }
        if (telefonoPadreInput) {
            telefonoPadreInput.addEventListener('input', () => _validateNumericInput(telefonoPadreInput));
        }
        if (telefonoEmpresaPadreInput) {
            telefonoEmpresaPadreInput.addEventListener('input', () => _validateNumericInput(telefonoEmpresaPadreInput));
        }
        
        // Radio buttons condicionales del estudiante
        afiliadoSaludRadios.forEach(radio => {
            radio.addEventListener('change', _handleAfiliadoSaludChange);
        });
        
        asisteRehabilitacionRadios.forEach(radio => {
            radio.addEventListener('change', _handleAsisteRehabilitacionChange);
        });
        
        tieneDiagnosticoRadios.forEach(radio => {
            radio.addEventListener('change', _handleTieneDiagnosticoChange);
        });
        
        tieneEnfermedadActualRadios.forEach(radio => {
            radio.addEventListener('change', _handleTieneEnfermedadActualChange);
        });
        
        consumeMedicamentosRadios.forEach(radio => {
            radio.addEventListener('change', _handleConsumeMedicamentosChange);
        });
        
        perteneceGrupoEtnicoRadios.forEach(radio => {
            radio.addEventListener('change', _handlePerteneceGrupoEtnicoChange);
        });
        
        ingresoSistemaEducativoRadios.forEach(radio => {
            radio.addEventListener('change', _handleIngresoSistemaEducativoChange);
        });
        
        jornadaRadios.forEach(radio => {
            radio.addEventListener('change', _handleJornadaChange);
        });
        
        // Select de EPS con opción "Otro"
        const epsSelect = document.getElementById('eps');
        if (epsSelect) {
            epsSelect.addEventListener('change', _handleEpsChange);
        }
        
        // Select de Horario Medicamentos con opción "Otro"
        const horarioMedicamentosSelect = document.getElementById('horarioMedicamentos');
        if (horarioMedicamentosSelect) {
            horarioMedicamentosSelect.addEventListener('change', _handleHorarioMedicamentosChange);
        }
        
        // Select de Establecimiento Educativo con opción "Otro"
        const establecimientoEducativoSelect = document.getElementById('establecimientoEducativo');
        if (establecimientoEducativoSelect) {
            establecimientoEducativoSelect.addEventListener('change', _handleEstablecimientoEducativoChange);
        }
        
        // Selects de Grupos Étnicos con opción "Otro"
        const grupoEtnicoSelect = document.getElementById('grupoEtnico');
        if (grupoEtnicoSelect) {
            console.log('Event listener agregado para grupoEtnico');
            grupoEtnicoSelect.addEventListener('change', _handleGrupoEtnicoChange);
        }
        
        const grupoEtnicoMadreSelect = document.getElementById('grupoEtnicoMadre');
        if (grupoEtnicoMadreSelect) {
            console.log('Event listener agregado para grupoEtnicoMadre');
            grupoEtnicoMadreSelect.addEventListener('change', _handleGrupoEtnicoMadreChange);
        } else {
            console.error('Element grupoEtnicoMadre no encontrado');
        }
        
        const grupoEtnicoPadreSelect = document.getElementById('grupoEtnicoPadre');
        if (grupoEtnicoPadreSelect) {
            console.log('Event listener agregado para grupoEtnicoPadre');
            grupoEtnicoPadreSelect.addEventListener('change', _handleGrupoEtnicoPadreChange);
        } else {
            console.error('Element grupoEtnicoPadre no encontrado');
        }
        
        // Radio buttons condicionales de los padres
        perteneceGrupoEtnicoMadreRadios.forEach(radio => {
            radio.addEventListener('change', _handlePerteneceGrupoEtnicoMadreChange);
        });
        
        perteneceGrupoEtnicoPadreRadios.forEach(radio => {
            radio.addEventListener('change', _handlePerteneceGrupoEtnicoPadreChange);
        });
        
        // Departamento change para estudiante y padres
        departamentoSelect.addEventListener('change', _handleDepartamentoChange);
        
        if (departamentoMadreSelect) {
            departamentoMadreSelect.addEventListener('change', _handleDepartamentoMadreChange);
        }
        
        if (departamentoPadreSelect) {
            departamentoPadreSelect.addEventListener('change', _handleDepartamentoPadreChange);
        }
        
        // Radio buttons para nuevas secciones
        padresVivenJuntosRadios.forEach(radio => {
            radio.addEventListener('change', _handlePadresVivenJuntosChange);
        });
        
        enfermedadPrimerAnoRadios.forEach(radio => {
            radio.addEventListener('change', _handleEnfermedadPrimerAnoChange);
        });
        
        // Event listeners para campos con "Otro" opcional
        const conQuienViviaPrimerosMeses = document.getElementById('conQuienViviaPrimerosMeses');
        if (conQuienViviaPrimerosMeses) {
            conQuienViviaPrimerosMeses.addEventListener('change', () => 
                _handleSelectWithOther('conQuienViviaPrimerosMeses', 'otrosConQuienViviaGroup'));
        }
        
        const dondeDormia = document.getElementById('dondeDormia');
        if (dondeDormia) {
            dondeDormia.addEventListener('change', () => 
                _handleSelectWithOther('dondeDormia', 'otroDondeDormiaGroup'));
        }
        
        // Event listener para el campo "¿Con quién vive el estudiante en la actualidad?"
        const conQuienVive1 = document.getElementById('conQuienVive1');
        if (conQuienVive1) {
            conQuienVive1.addEventListener('change', () => 
                _handleSelectWithOther('conQuienVive1', 'otroConQuienVive1Group'));
        }
        
        // Event listener para el campo "Relación con el estudiante" en composición familiar
        const relacionEstudiante1 = document.getElementById('relacionEstudiante1');
        if (relacionEstudiante1) {
            relacionEstudiante1.addEventListener('change', () => 
                _handleSelectWithOther('relacionEstudiante1', 'otroRelacionEstudiante1Group'));
        }
        
        // Event listener para el campo "Relación con el estudiante" en figuras de apoyo
        const relacionApoyo1 = document.getElementById('relacionApoyo1');
        if (relacionApoyo1) {
            relacionApoyo1.addEventListener('change', () => 
                _handleSelectWithOther('relacionApoyo1', 'otroRelacionApoyo1Group'));
        }
        
        const comoSeCalmaba = document.getElementById('comoSeCalmaba');
        if (comoSeCalmaba) {
            comoSeCalmaba.addEventListener('change', () => 
                _handleSelectWithOther('comoSeCalmaba', 'otroComoSeCalmabaGroup'));
        }
        
        const comoRegulabaSueno = document.getElementById('comoRegulabaSueno');
        if (comoRegulabaSueno) {
            comoRegulabaSueno.addEventListener('change', () => 
                _handleSelectWithOther('comoRegulabaSueno', 'otroComoRegulabaSuenoGroup'));
        }
        
        const desarrolloSocial = document.getElementById('desarrolloSocial');
        if (desarrolloSocial) {
            desarrolloSocial.addEventListener('change', () => 
                _handleSelectWithOther('desarrolloSocial', 'otroDesarrolloSocialGroup'));
        }
        
        const actividadesFamiliares = document.getElementById('actividadesFamiliares');
        if (actividadesFamiliares) {
            actividadesFamiliares.addEventListener('change', () => 
                _handleSelectWithOther('actividadesFamiliares', 'otroActividadesFamiliaresGroup'));
        }
        
        const nivelInicioEscolaridad = document.getElementById('nivelInicioEscolaridad');
        if (nivelInicioEscolaridad) {
            nivelInicioEscolaridad.addEventListener('change', () => 
                _handleSelectWithOther('nivelInicioEscolaridad', 'otroNivelInicioGroup'));
        }
        
        // Event listener para alimentación
        const alimentacionPrimerAno = document.getElementById('alimentacionPrimerAno');
        if (alimentacionPrimerAno) {
            alimentacionPrimerAno.addEventListener('change', _handleAlimentacionChange);
        }
        
        // Event listeners para radio buttons de dificultades motor
        const dificultadesMotorRadios = document.querySelectorAll('input[name="dificultadesMotor"]');
        dificultadesMotorRadios.forEach(radio => {
            radio.addEventListener('change', _handleDificultadesMotorChange);
        });

        // Event listeners para nuevos campos del Anexo 1
        
        // Experiencias significativas - checkbox "Otro"
        const experienciasSignificativasOtro = document.getElementById('experienciasSignificativasOtro');
        if (experienciasSignificativasOtro) {
            experienciasSignificativasOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('experienciasSignificativasOtro', 'otroExperienciasSignificativasGroup'));
        }

        // Aprendizajes y dificultades iniciales - selects con "Otro"
        const aprendizajesFaciles = document.getElementById('aprendizajesFaciles');
        if (aprendizajesFaciles) {
            aprendizajesFaciles.addEventListener('change', () => 
                _handleSelectWithOther('aprendizajesFaciles', 'otroAprendizajesFacilesGroup'));
        }

        const aspectosDificiles = document.getElementById('aspectosDificiles');
        if (aspectosDificiles) {
            aspectosDificiles.addEventListener('change', () => 
                _handleSelectWithOther('aspectosDificiles', 'otroAspectosDificilesGroup'));
        }

        // Dificultades evidentes - radio buttons condicionales
        const dificultadesEscolaridadRadios = document.querySelectorAll('input[name="dificultadesEscolaridad"]');
        dificultadesEscolaridadRadios.forEach(radio => {
            radio.addEventListener('change', _handleDificultadesEscolaridadChange);
        });

        const cualesDificultades = document.getElementById('cualesDificultades');
        if (cualesDificultades) {
            cualesDificultades.addEventListener('change', () => 
                _handleSelectWithOther('cualesDificultades', 'otroCualesDificultadesGroup'));
        }

        // Fortalezas observadas - select con "Otro"
        const fortalezasEvidenciadas = document.getElementById('fortalezasEvidenciadas');
        if (fortalezasEvidenciadas) {
            fortalezasEvidenciadas.addEventListener('change', () => 
                _handleSelectWithOther('fortalezasEvidenciadas', 'otroFortalezasEvidenciadasGroup'));
        }

        // Impacto en aprendizajes integrales - select con "Otro"
        const vinculacionDesarrollo = document.getElementById('vinculacionDesarrollo');
        if (vinculacionDesarrollo) {
            vinculacionDesarrollo.addEventListener('change', () => 
                _handleSelectWithOther('vinculacionDesarrollo', 'otroVinculacionDesarrolloGroup'));
        }

        // C. Familia actual - selects con "Otro"
        const conQuienViveActualmente = document.getElementById('conQuienViveActualmente');
        if (conQuienViveActualmente) {
            conQuienViveActualmente.addEventListener('change', () => 
                _handleSelectWithOther('conQuienViveActualmente', 'otroConQuienViveActualmenteGroup'));
        }

        const tipoFamiliaNuclear = document.getElementById('tipoFamiliaNuclear');
        if (tipoFamiliaNuclear) {
            tipoFamiliaNuclear.addEventListener('change', () => 
                _handleSelectWithOther('tipoFamiliaNuclear', 'otroTipoFamiliaNuclearGroup'));
        }

        const aspectosDestacadosRelaciones = document.getElementById('aspectosDestacadosRelaciones');
        if (aspectosDestacadosRelaciones) {
            aspectosDestacadosRelaciones.addEventListener('change', () => 
                _handleSelectWithOther('aspectosDestacadosRelaciones', 'otroAspectosDestacadosRelacionesGroup'));
        }

        const tratoFamiliaEstudiante = document.getElementById('tratoFamiliaEstudiante');
        if (tratoFamiliaEstudiante) {
            tratoFamiliaEstudiante.addEventListener('change', () => 
                _handleSelectWithOther('tratoFamiliaEstudiante', 'otroTratoFamiliaEstudianteGroup'));
        }

        const manejoConflictosFamilia = document.getElementById('manejoConflictosFamilia');
        if (manejoConflictosFamilia) {
            manejoConflictosFamilia.addEventListener('change', () => 
                _handleSelectWithOther('manejoConflictosFamilia', 'otroManejoConflictosFamiliaGroup'));
        }

        const reaccionEstudianteConflicto = document.getElementById('reaccionEstudianteConflicto');
        if (reaccionEstudianteConflicto) {
            reaccionEstudianteConflicto.addEventListener('change', () => 
                _handleSelectWithOther('reaccionEstudianteConflicto', 'otroReaccionEstudianteConflictoGroup'));
        }

        const factoresUnionFamiliar = document.getElementById('factoresUnionFamiliar');
        if (factoresUnionFamiliar) {
            factoresUnionFamiliar.addEventListener('change', () => 
                _handleSelectWithOther('factoresUnionFamiliar', 'otroFactoresUnionFamiliarGroup'));
        }

        // D. Diagnóstico de discapacidad - selects con "Otro"
        const origenSospechas = document.getElementById('origenSospechas');
        if (origenSospechas) {
            origenSospechas.addEventListener('change', () => 
                _handleSelectWithOther('origenSospechas', 'otroOrigenSospechasGroup'));
        }

        const quienEmitioDiagnostico = document.getElementById('quienEmitioDiagnostico');
        if (quienEmitioDiagnostico) {
            quienEmitioDiagnostico.addEventListener('change', () => 
                _handleSelectWithOther('quienEmitioDiagnostico', 'otroQuienEmitioDiagnosticoGroup'));
        }

        // Información al estudiante - radio buttons condicionales
        const informoEstudianteRadios = document.querySelectorAll('input[name="informoEstudiante"]');
        informoEstudianteRadios.forEach(radio => {
            radio.addEventListener('change', _handleInformoEstudianteChange);
        });

        // Terapias, tratamientos y apoyos - selects con "Otro"
        const terapiasTratamientos = document.getElementById('terapiasTratamientos');
        if (terapiasTratamientos) {
            terapiasTratamientos.addEventListener('change', () => 
                _handleSelectWithOther('terapiasTratamientos', 'otroTerapiasTratamientosGroup'));
        }

        // Continúan terapias - radio buttons condicionales
        const continuanTerapiasRadios = document.querySelectorAll('input[name="continuanTerapias"]');
        continuanTerapiasRadios.forEach(radio => {
            radio.addEventListener('change', _handleContinuanTerapiasChange);
        });

        const porqueDetuvoTerapias = document.getElementById('porqueDetuvoTerapias');
        if (porqueDetuvoTerapias) {
            porqueDetuvoTerapias.addEventListener('change', () => 
                _handleSelectWithOther('porqueDetuvoTerapias', 'otroPorqueDetuvoTerapiasGroup'));
        }

        // E. Vida actual del estudiante - selects con "Otro"
        const actividadesIndependiente = document.getElementById('actividadesIndependiente');
        if (actividadesIndependiente) {
            actividadesIndependiente.addEventListener('change', () => 
                _handleSelectWithOther('actividadesIndependiente', 'otroActividadesIndependienteGroup'));
        }

        const actividadesRequiereApoyo = document.getElementById('actividadesRequiereApoyo');
        if (actividadesRequiereApoyo) {
            actividadesRequiereApoyo.addEventListener('change', () => 
                _handleSelectWithOther('actividadesRequiereApoyo', 'otroActividadesRequiereApoyoGroup'));
        }

        const fortalezasObservadas = document.getElementById('fortalezasObservadas');
        if (fortalezasObservadas) {
            fortalezasObservadas.addEventListener('change', () => 
                _handleSelectWithOther('fortalezasObservadas', 'otroFortalezasObservadasGroup'));
        }

        const debilidadesObservadas = document.getElementById('debilidadesObservadas');
        if (debilidadesObservadas) {
            debilidadesObservadas.addEventListener('change', () => 
                _handleSelectWithOther('debilidadesObservadas', 'otroDebilidadesObservadasGroup'));
        }

        const caracterizaDesarrollo = document.getElementById('caracterizaDesarrollo');
        if (caracterizaDesarrollo) {
            caracterizaDesarrollo.addEventListener('change', () => 
                _handleSelectWithOther('caracterizaDesarrollo', 'otroCaracterizaDesarrolloGroup'));
        }

        const habitosDestacados = document.getElementById('habitosDestacados');
        if (habitosDestacados) {
            habitosDestacados.addEventListener('change', () => 
                _handleSelectWithOther('habitosDestacados', 'otroHabitosDestacadosGroup'));
        }

        const preferenciasVidaCotidiana = document.getElementById('preferenciasVidaCotidiana');
        if (preferenciasVidaCotidiana) {
            preferenciasVidaCotidiana.addEventListener('change', () => 
                _handleSelectWithOther('preferenciasVidaCotidiana', 'otroPreferenciasVidaCotidianaGroup'));
        }

        const interesesPersonales = document.getElementById('interesesPersonales');
        if (interesesPersonales) {
            interesesPersonales.addEventListener('change', () => 
                _handleSelectWithOther('interesesPersonales', 'otroInteresesPersonalesGroup'));
        }

        const destacaPrincipalmente = document.getElementById('destacaPrincipalmente');
        if (destacaPrincipalmente) {
            destacaPrincipalmente.addEventListener('change', () => 
                _handleSelectWithOther('destacaPrincipalmente', 'otroDestacaPrincipalmenteGroup'));
        }

        const limitacionesImportantes = document.getElementById('limitacionesImportantes');
        if (limitacionesImportantes) {
            limitacionesImportantes.addEventListener('change', () => 
                _handleSelectWithOther('limitacionesImportantes', 'otroLimitacionesImportantesGroup'));
        }

        // F. Situaciones y reacciones en la vida cotidiana - selects con "Otro"
        const situacionesAfectan = document.getElementById('situacionesAfectan');
        if (situacionesAfectan) {
            situacionesAfectan.addEventListener('change', () => 
                _handleSelectWithOther('situacionesAfectan', 'otroSituacionesAfectanGroup'));
        }

        const reaccionEstudiante = document.getElementById('reaccionEstudiante');
        if (reaccionEstudiante) {
            reaccionEstudiante.addEventListener('change', () => 
                _handleSelectWithOther('reaccionEstudiante', 'otroReaccionEstudianteGroup'));
        }

        const accionesAdultos = document.getElementById('accionesAdultos');
        if (accionesAdultos) {
            accionesAdultos.addEventListener('change', () => 
                _handleSelectWithOther('accionesAdultos', 'otroAccionesAdultosGroup'));
        }

        // G. Experiencias en establecimientos educativos - selects con "Otro"
        const fortalezasInstituciones = document.getElementById('fortalezasInstituciones');
        if (fortalezasInstituciones) {
            fortalezasInstituciones.addEventListener('change', () => 
                _handleSelectWithOther('fortalezasInstituciones', 'otroFortalezasInstitucionesGroup'));
        }

        const dificultadesInstituciones = document.getElementById('dificultadesInstituciones');
        if (dificultadesInstituciones) {
            dificultadesInstituciones.addEventListener('change', () => 
                _handleSelectWithOther('dificultadesInstituciones', 'otroDificultadesInstitucionesGroup'));
        }

        const impactoDificultades = document.getElementById('impactoDificultades');
        if (impactoDificultades) {
            impactoDificultades.addEventListener('change', () => 
                _handleSelectWithOther('impactoDificultades', 'otroImpactoDificultadesGroup'));
        }

        // H. Fortalezas a potenciar y apoyos requeridos - checkboxes "Otro"
        const fortalezasPotenciarOtro = document.getElementById('fortalezasPotenciarOtro');
        if (fortalezasPotenciarOtro) {
            fortalezasPotenciarOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('fortalezasPotenciarOtro', 'otroFortalezasPotenciarGroup'));
        }

        const tipoApoyosRequeridosOtro = document.getElementById('tipoApoyosRequeridosOtro');
        if (tipoApoyosRequeridosOtro) {
            tipoApoyosRequeridosOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('tipoApoyosRequeridosOtro', 'otroTipoApoyosRequeridosGroup'));
        }

        const quienDeberiaOfrecer = document.getElementById('quienDeberiaOfrecer');
        if (quienDeberiaOfrecer) {
            quienDeberiaOfrecer.addEventListener('change', () => 
                _handleSelectWithOther('quienDeberiaOfrecer', 'otroQuienDeberiaOfrecerGroup'));
        }

        // I. Apoyos brindados en casa - checkboxes y selects con "Otro"
        const apoyosEnCasaOtro = document.getElementById('apoyosEnCasaOtro');
        if (apoyosEnCasaOtro) {
            apoyosEnCasaOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('apoyosEnCasaOtro', 'otroApoyosEnCasaGroup'));
        }

        const quienBrindaApoyos = document.getElementById('quienBrindaApoyos');
        if (quienBrindaApoyos) {
            quienBrindaApoyos.addEventListener('change', () => 
                _handleSelectWithOther('quienBrindaApoyos', 'otroQuienBrindaApoyosGroup'));
        }

        const recomendacionesEscuela = document.getElementById('recomendacionesEscuela');
        if (recomendacionesEscuela) {
            recomendacionesEscuela.addEventListener('change', () => 
                _handleSelectWithOther('recomendacionesEscuela', 'otroRecomendacionesEscuelaGroup'));
        }

        // J. Eventos familiares y su impacto - checkboxes "Otro"
        const eventosFamiliaresOtro = document.getElementById('eventosFamiliaresOtro');
        if (eventosFamiliaresOtro) {
            eventosFamiliaresOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('eventosFamiliaresOtro', 'otroEventosFamiliaresGroup'));
        }

        const impactoEventosEstudianteOtro = document.getElementById('impactoEventosEstudianteOtro');
        if (impactoEventosEstudianteOtro) {
            impactoEventosEstudianteOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('impactoEventosEstudianteOtro', 'otroImpactoEventosEstudianteGroup'));
        }

        // K. Proyectos familiares - checkboxes "Otro" 
        const proyectosFamiliaresOtro = document.getElementById('proyectosFamiliaresOtro');
        if (proyectosFamiliaresOtro) {
            proyectosFamiliaresOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('proyectosFamiliaresOtro', 'otroProyectosFamiliaresGroup'));
        }

        // L. Redes de apoyo - checkboxes "Otro"
        const quienesApoyanFamiliaOtro = document.getElementById('quienesApoyanFamiliaOtro');
        if (quienesApoyanFamiliaOtro) {
            quienesApoyanFamiliaOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('quienesApoyanFamiliaOtro', 'otroQuienesApoyanFamiliaGroup'));
        }

        const tipoApoyoBrindanOtro = document.getElementById('tipoApoyoBrindanOtro');
        if (tipoApoyoBrindanOtro) {
            tipoApoyoBrindanOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('tipoApoyoBrindanOtro', 'otroTipoApoyoBrindanGroup'));
        }

        // M. Historia de vida - selects y checkboxes "Otro"
        const eventosImportantesVida = document.getElementById('eventosImportantesVida');
        if (eventosImportantesVida) {
            eventosImportantesVida.addEventListener('change', () => 
                _handleSelectWithOther('eventosImportantesVida', 'otroEventosImportantesVidaGroup'));
        }

        const reaccionDificultades = document.getElementById('reaccionDificultades');
        if (reaccionDificultades) {
            reaccionDificultades.addEventListener('change', () => 
                _handleSelectWithOther('reaccionDificultades', 'otroReaccionDificultadesGroup'));
        }

        const situacionesDificilesFamilia = document.getElementById('situacionesDificilesFamilia');
        if (situacionesDificilesFamilia) {
            situacionesDificilesFamilia.addEventListener('change', () => 
                _handleSelectWithOther('situacionesDificilesFamilia', 'otroSituacionesDificilesFamiliaGroup'));
        }

        const queAprendisteOtro = document.getElementById('queAprendisteOtro');
        if (queAprendisteOtro) {
            queAprendisteOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('queAprendisteOtro', 'otroQueAprendisteGroup'));
        }

        // N. Percepción escolar - checkboxes y selects "Otro"
        const apoyosRecibidosDificultadesOtro = document.getElementById('apoyosRecibidosDificultadesOtro');
        if (apoyosRecibidosDificultadesOtro) {
            apoyosRecibidosDificultadesOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('apoyosRecibidosDificultadesOtro', 'otroApoyosRecibidosDificultadesGroup'));
        }

        const apoyosGustariaRecibir = document.getElementById('apoyosGustariaRecibir');
        if (apoyosGustariaRecibir) {
            apoyosGustariaRecibir.addEventListener('change', () => 
                _handleSelectWithOther('apoyosGustariaRecibir', 'otroApoyosGustariaRecibirGroup'));
        }

        const situacionesNoRepetirOtro = document.getElementById('situacionesNoRepetirOtro');
        if (situacionesNoRepetirOtro) {
            situacionesNoRepetirOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('situacionesNoRepetirOtro', 'otroSituacionesNoRepetirGroup'));
        }

        const expectativasPersonalesOtro = document.getElementById('expectativasPersonalesOtro');
        if (expectativasPersonalesOtro) {
            expectativasPersonalesOtro.addEventListener('change', () => 
                _handleCheckboxOtroChange('expectativasPersonalesOtro', 'otroExpectativasPersonalesGroup'));
        }
        
        // Configurar validación de checkboxes requeridos
        setupCheckboxRequired('fortalezasPotenciar', 'fortalezasPotenciarError');
        setupCheckboxRequired('tipoApoyosRequeridos', 'tipoApoyosRequeridosError');
        setupCheckboxRequired('apoyosEnCasa', 'apoyosEnCasaError');
        setupCheckboxRequired('eventosFamiliares', 'eventosFamiliaresError');
        setupCheckboxRequired('impactoEventosEstudiante', 'impactoEventosEstudianteError');
        setupCheckboxRequired('proyectosFamiliares', 'proyectosFamiliaresError');
        setupCheckboxRequired('quienesApoyanFamilia', 'quienesApoyanFamiliaError');
        setupCheckboxRequired('tipoApoyoBrindan', 'tipoApoyoBrindanError');
        setupCheckboxRequired('habitosFortalecidos', 'habitosFortalecidosError');
        setupCheckboxRequired('gustosPreferencias', 'gustosPreferenciasError');
        setupCheckboxRequired('queAprendiste', 'queAprendisteError');
        setupCheckboxRequired('areasSeTeFilitan', 'areasSeTeFilltanError');
        setupCheckboxRequired('actitudAprendizajesFaciles', 'actitudAprendizajesFacilesError');
        setupCheckboxRequired('areasSeTeCanseñan', 'areasSeTeCanseñanError');
        setupCheckboxRequired('apoyosRecibidosDificultades', 'apoyosRecibidosDificultadesError');
        setupCheckboxRequired('situacionesNoRepetir', 'situacionesNoRepetirError');
        setupCheckboxRequired('expectativasPersonales', 'expectativasPersonalesError');
        
        // Funciones globales para botones dinámicos
        window.addCompositionInfo = addCompositionInfo;
        window.removeComposition = removeComposition;
        window.addSupportInfo = addSupportInfo;
        window.removeSupportInfo = removeSupportInfo;
        
        // El sistema de firma digital se inicializa cuando el formulario se hace visible
        // _initSignatureSystem(); // Movido a _enableForm()
        
        // Submit del formulario
        studentForm.addEventListener('submit', _handleFormSubmit);
        
        // Limpiar formulario
        window.clearForm = _clearForm;
        
        // Logout
        window.logout = function() {
            // Mostrar modal de confirmación
            const modal = document.getElementById('logoutModal');
            if (modal) {
                modal.style.display = 'block';
                
                // Configurar eventos del modal si no están configurados
                const confirmBtn = document.getElementById('confirmLogout');
                const cancelBtn = document.getElementById('cancelLogout');
                
                if (confirmBtn && !confirmBtn.hasAttribute('data-configured')) {
                    confirmBtn.addEventListener('click', function() {
                        localStorage.removeItem('authToken');
                        localStorage.removeItem('userData');
                        window.location.href = './login.html';
                    });
                    confirmBtn.setAttribute('data-configured', 'true');
                }
                
                if (cancelBtn && !cancelBtn.hasAttribute('data-configured')) {
                    cancelBtn.addEventListener('click', function() {
                        modal.style.display = 'none';
                    });
                    cancelBtn.setAttribute('data-configured', 'true');
                }
                
                // Cerrar modal al hacer clic fuera
                modal.addEventListener('click', function(event) {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                });
            }
        };
    }
    
    // Función auxiliar para configurar validación de checkboxes requeridos
    function setupCheckboxRequired(checkboxGroupName, errorId) {
        const checkboxes = document.querySelectorAll(`input[name="${checkboxGroupName}"]`);
        const errorElement = document.getElementById(errorId);
        
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const anyChecked = Array.from(checkboxes).some(cb => cb.checked);
                if (anyChecked && errorElement) {
                    errorElement.classList.remove('show');
                }
            });
        });
    }
    
    // Inicializar sistema de firma digital
    function _initSignatureSystem() {
        // Verificar si existe el canvas de firma
        const signatureCanvas = document.getElementById('signaturePad');
        if (signatureCanvas) {
            // Inicializar el pad de firma
            signaturePadInstance = new SignaturePad('signaturePad');
            
            // Configurar botones
            const clearBtn = document.getElementById('clearSignature');
            const saveBtn = document.getElementById('saveSignature');
            
            if (clearBtn) {
                clearBtn.addEventListener('click', () => signaturePadInstance.clear());
            }
            
            if (saveBtn) {
                saveBtn.addEventListener('click', () => signaturePadInstance.save());
            }
        }
        
        // Configurar contador de caracteres para observaciones generales
        _setupCharacterCounter('observacionesGenerales', 2000);
        
        // Validación adicional para campos de firma
        const documentoFirmante = document.getElementById('documentoFirmante');
        if (documentoFirmante) {
            documentoFirmante.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }
    }
    
    // Función para configurar contador de caracteres
    function _setupCharacterCounter(textareaId, maxLength) {
        const textarea = document.getElementById(textareaId);
        const counter = textarea ? textarea.parentElement.querySelector('.character-count') : null;
        
        if (textarea && counter) {
            textarea.addEventListener('input', function() {
                const currentLength = this.value.length;
                counter.textContent = `${currentLength}/${maxLength} caracteres`;
                
                if (currentLength > maxLength * 0.9) {
                    counter.style.color = '#e53e3e';
                } else if (currentLength > maxLength * 0.8) {
                    counter.style.color = '#dd6b20';
                } else {
                    counter.style.color = '#a0aec0';
                }
            });
            
            // Inicializar el contador
            const currentLength = textarea.value.length;
            counter.textContent = `${currentLength}/${maxLength} caracteres`;
        }
    }
    
    // Contador para materias del Anexo 3
    let materiaCounter = 1;
    const maxMaterias = 10; // Límite de materias que se pueden agregar

    // Datos de fallback solo para emergencias (cuando la API no responde)
    const fallbackData = {
        preescolar: [
            'Dimensión comunicativa',
            'Dimensión cognitiva', 
            'Dimensión corporal',
            'Dimensión socioafectiva',
            'Dimensión espiritual',
            'Dimensión ética',
            'Dimensión estética'
        ],
        basica: [
            'Lengua Castellana',
            'Inglés',
            'Matemáticas',
            'Ciencias Naturales',
            'Ciencias Sociales',
            'Educación Artística',
            'Educación Física',
            'Ética y Valores'
        ],
        media: [
            'Lengua Castellana',
            'Inglés',
            'Matemáticas',
            'Biología',
            'Física',
            'Química',
            'Ciencias Sociales',
            'Filosofía'
        ]
    };
    
    // Función para manejar el cambio de nivel educativo
    async function _handleNivelEducativoChange(event) {
        const selectElement = event.target;
        const groupId = selectElement.dataset.group;
        const selectedValue = selectElement.value;
        
        const asignaturaRow = document.getElementById(`asignaturaRow${groupId}`);
        const asignaturaSelect = document.getElementById(`asignatura${groupId}`);
        const camposAdicionales = document.getElementById(`camposAdicionales${groupId}`);
        
        if (selectedValue) {
            // Mostrar el select de asignaturas
            asignaturaRow.style.display = 'block';
            
            // Limpiar opciones
            asignaturaSelect.innerHTML = '<option value="">Cargando asignaturas...</option>';
            
            if (selectedValue === 'preescolar') {
                // Cargar dimensiones de educación inicial desde la API
                try {
                    const asignaturas = await cargarAsignaturasEducacionInicial();
                    
                    // Limpiar y llenar opciones
                    asignaturaSelect.innerHTML = '<option value="">Seleccione una dimensión</option>';
                    
                    asignaturas.forEach(asignatura => {
                        const option = document.createElement('option');
                        option.value = asignatura.id_asignatura_inicial;
                        option.textContent = asignatura.nombre;
                        asignaturaSelect.appendChild(option);
                    });
                } catch (error) {
                    console.error('Error al cargar dimensiones de educación inicial:', error);
                    // Fallback de emergencia solo si la API falla
                    asignaturaSelect.innerHTML = '<option value="">Seleccione una dimensión</option>';
                    fallbackData.preescolar.forEach(asignatura => {
                        const option = document.createElement('option');
                        option.value = asignatura.toLowerCase().replace(/\s+/g, '_');
                        option.textContent = asignatura;
                        asignaturaSelect.appendChild(option);
                    });
                }
            } else if (selectedValue === 'basica' || selectedValue === 'media') {
                // Cargar asignaturas desde la API para educación básica y media
                try {
                    const asignaturas = await cargarAsignaturas();
                    
                    // Limpiar y llenar opciones
                    asignaturaSelect.innerHTML = '<option value="">Seleccione una asignatura</option>';
                    
                    asignaturas.forEach(asignatura => {
                        const option = document.createElement('option');
                        option.value = asignatura.id_asignatura;
                        option.textContent = asignatura.nombre;
                        asignaturaSelect.appendChild(option);
                    });
                } catch (error) {
                    console.error('Error al cargar asignaturas:', error);
                    // Fallback de emergencia solo si la API falla
                    asignaturaSelect.innerHTML = '<option value="">Seleccione una asignatura</option>';
                    if (fallbackData[selectedValue]) {
                        fallbackData[selectedValue].forEach(asignatura => {
                            const option = document.createElement('option');
                            option.value = asignatura.toLowerCase().replace(/\s+/g, '_');
                            option.textContent = asignatura;
                            asignaturaSelect.appendChild(option);
                        });
                    }
                }
            } else {
                // Si no es un nivel reconocido, mostrar mensaje
                asignaturaSelect.innerHTML = '<option value="">Nivel educativo no reconocido</option>';
            }
            
            // Ocultar campos adicionales hasta que se seleccione una asignatura
            camposAdicionales.style.display = 'none';
        } else {
            // Ocultar todo si no hay selección
            asignaturaRow.style.display = 'none';
            camposAdicionales.style.display = 'none';
        }
    }

    // Función para manejar el cambio de asignatura específica
    function _handleAsignaturaChange(event) {
        const selectElement = event.target;
        const groupId = selectElement.dataset.group;
        const selectedValue = selectElement.value;
        
        const camposAdicionales = document.getElementById(`camposAdicionales${groupId}`);
        
        if (selectedValue) {
            // Mostrar los campos adicionales
            camposAdicionales.style.display = 'block';
        } else {
            // Ocultar los campos adicionales
            camposAdicionales.style.display = 'none';
        }
    }

    // Función para agregar una nueva materia
    function _addNewMateria() {
        if (materiaCounter >= maxMaterias) {
            _showNotification('Has alcanzado el límite máximo de materias.', 'warning');
            return;
        }

        materiaCounter++;
        const materiasContainer = document.getElementById('materiasContainer');
        
        const newMateriaHTML = `
            <div class="materia-group" id="materiaGroup${materiaCounter}">
                <!-- Selección de nivel educativo -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="nivelEducativo${materiaCounter}">Seleccione las asignaturas que cursará durante cada periodo académico:</label>
                        <select id="nivelEducativo${materiaCounter}" name="nivelEducativo${materiaCounter}" class="form-control nivel-educativo" data-group="${materiaCounter}" required>
                            <option value="">Seleccione una opción</option>
                            <option value="preescolar">Preescolar</option>
                            <option value="basica">Educación básica</option>
                            <option value="media">Educación media</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="button" class="btn-remove-materia" onclick="FormularioPIAR._removeMateria(${materiaCounter})">
                            <i class="fas fa-times"></i>
                            Eliminar materia
                        </button>
                    </div>
                </div>

                <!-- Selección de asignatura específica (inicialmente oculto) -->
                <div class="form-row" id="asignaturaRow${materiaCounter}" style="display: none;">
                    <div class="form-group">
                        <label for="asignatura${materiaCounter}">Seleccione la asignatura específica:</label>
                        <select id="asignatura${materiaCounter}" name="asignatura${materiaCounter}" class="form-control asignatura-especifica" data-group="${materiaCounter}">
                            <option value="">Seleccione una asignatura</option>
                        </select>
                    </div>
                </div>

                <!-- Campos adicionales (inicialmente ocultos) -->
                <div class="campos-adicionales" id="camposAdicionales${materiaCounter}" style="display: none;">
                    <!-- Derechos Básicos de Aprendizaje (DBA) -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="dba${materiaCounter}">Derechos Básicos de Aprendizaje (DBA):</label>
                            <div class="textarea-container">
                                <i class="fas fa-graduation-cap textarea-icon"></i>
                                <textarea id="dba${materiaCounter}" name="dba${materiaCounter}" class="form-control professional-textarea" rows="3" placeholder="Haz clic para establecer los Derechos Básicos de Aprendizaje fundamentales y específicos para esta asignatura..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Ajustes Particulares -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="ajustesParticulares${materiaCounter}">Ajustes Particulares:</label>
                            <div class="textarea-container">
                                <i class="fas fa-tools textarea-icon"></i>
                                <textarea id="ajustesParticulares${materiaCounter}" name="ajustesParticulares${materiaCounter}" class="form-control professional-textarea" rows="3" placeholder="Haz clic para definir ajustes específicos y personalizados que faciliten el aprendizaje del estudiante..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Evaluación de los ajustes -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="evaluacionAjustes${materiaCounter}">Evaluación de los ajustes:</label>
                            <div class="textarea-container">
                                <i class="fas fa-chart-line textarea-icon"></i>
                                <textarea id="evaluacionAjustes${materiaCounter}" name="evaluacionAjustes${materiaCounter}" class="form-control professional-textarea" rows="3" placeholder="Haz clic para establecer criterios y métodos de evaluación específicos para medir la efectividad de los ajustes implementados..."></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Separador entre materias -->
                <hr class="materia-separator">
            </div>
        `;
        
        materiasContainer.insertAdjacentHTML('beforeend', newMateriaHTML);
        
        // Agregar event listeners para el nuevo grupo
        const nuevoNivelSelect = document.getElementById(`nivelEducativo${materiaCounter}`);
        const nuevaAsignaturaSelect = document.getElementById(`asignatura${materiaCounter}`);
        
        nuevoNivelSelect.addEventListener('change', _handleNivelEducativoChange);
        nuevaAsignaturaSelect.addEventListener('change', _handleAsignaturaChange);
        
        _showNotification('Nueva materia agregada correctamente.', 'success');
    }

    // Función para eliminar una materia
    function _removeMateria(groupId) {
        const materiaGroup = document.getElementById(`materiaGroup${groupId}`);
        if (materiaGroup) {
            materiaGroup.remove();
            _showNotification('Materia eliminada correctamente.', 'success');
        }
    }

    // Función para inicializar los event listeners del Anexo 3
    function _initAnexo3EventListeners() {
        // Event listener para el botón de agregar materia
        const addMateriaBtn = document.getElementById('addMateriaBtn');
        if (addMateriaBtn) {
            addMateriaBtn.addEventListener('click', _addNewMateria);
        }

        // Event listeners para la primera materia (ya existe en el HTML)
        const nivelEducativo1 = document.getElementById('nivelEducativo1');
        const asignatura1 = document.getElementById('asignatura1');
        
        if (nivelEducativo1) {
            nivelEducativo1.addEventListener('change', _handleNivelEducativoChange);
        }
        
        if (asignatura1) {
            asignatura1.addEventListener('change', _handleAsignaturaChange);
        }
    }

    // Método público para inicializar
    function init() {
        _loadUserData();
        _setCurrentDate();
        _loadSelectData();
        _initEventListeners();
        _initAnexo3EventListeners();
        
        console.log('Formulario PIAR inicializado');
    }
    
    // API pública
    return {
        init: init,
        _removeMateria: _removeMateria
    };
})();

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', FormularioPIAR.init);

// Funciones globales para Anexo 2
function limpiarAnexo2() {
    const anexo2Form = document.getElementById('anexo2Form');
    if (anexo2Form) {
        anexo2Form.reset();
        // También limpiar las firmas
        clearAllSignatures();
        console.log('Formulario Anexo 2 limpiado (incluyendo firmas)');
    }
}

function guardarAnexo2() {
    const anexo2Form = document.getElementById('anexo2Form');
    if (anexo2Form) {
        const formData = new FormData(anexo2Form);
        const data = {};
        
        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }
        
        // Recopilar datos de firmas
        const firmas = {
            participantes: [],
            docentes: []
        };
        
        // Recopilar participantes generales
        for (let i = 1; i <= generalSignatureCounter; i++) {
            const nombreInput = document.getElementById(`nombreParticipante${i}`);
            const cargoInput = document.getElementById(`cargoParticipante${i}`);
            
            if (nombreInput && cargoInput && nombreInput.value.trim()) {
                firmas.participantes.push({
                    nombre: nombreInput.value.trim(),
                    cargo: cargoInput.value.trim()
                });
            }
        }
        
        // Recopilar docentes
        for (let i = 1; i <= teacherSignatureCounter; i++) {
            const nombreInput = document.getElementById(`nombreDocente${i}`);
            const asignaturaInput = document.getElementById(`asignaturaDocente${i}`);
            
            if (nombreInput && asignaturaInput && nombreInput.value.trim()) {
                firmas.docentes.push({
                    nombre: nombreInput.value.trim(),
                    asignatura: asignaturaInput.value.trim()
                });
            }
        }
        
        // Agregar firmas a los datos
        data.firmas = firmas;
        
        console.log('Datos del Anexo 2 a guardar (incluyendo firmas):', data);
        
        // Aquí se puede implementar la lógica para enviar los datos al servidor
        // Por ahora solo mostramos un mensaje de confirmación
        alert('Anexo 2 guardado exitosamente (incluyendo firmas)');
    }
}

// Función global para logout (usada en formulario-piar.html)
function logout() {
    // Mostrar modal de confirmación
    const modal = document.getElementById('logoutModal');
    if (modal) {
        modal.style.display = 'block';
        
        // Configurar eventos del modal si no están configurados
        const confirmBtn = document.getElementById('confirmLogout');
        const cancelBtn = document.getElementById('cancelLogout');
        
        if (confirmBtn && !confirmBtn.hasAttribute('data-configured-global')) {
            confirmBtn.addEventListener('click', function() {
                localStorage.removeItem('authToken');
                localStorage.removeItem('userData');
                window.location.href = './login.html';
            });
            confirmBtn.setAttribute('data-configured-global', 'true');
        }
        
        if (cancelBtn && !cancelBtn.hasAttribute('data-configured-global')) {
            cancelBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
            cancelBtn.setAttribute('data-configured-global', 'true');
        }
        
        // Cerrar modal al hacer clic fuera
        modal.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
}

// Sistema de Firma Digital
class SignaturePad {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        this.ctx = this.canvas.getContext('2d');
        this.isDrawing = false;
        this.hasSignature = false;
        
        this.setupCanvas();
        this.bindEvents();
        this.setCurrentDate();
    }
    
    setupCanvas() {
        // Obtener las dimensiones del canvas
        const canvasWidth = this.canvas.width;
        const canvasHeight = this.canvas.height;
        
        // Configurar estilos de dibujo
        this.ctx.lineCap = 'round';
        this.ctx.lineJoin = 'round';
        this.ctx.strokeStyle = '#2d3748';
        this.ctx.lineWidth = 2;
        
        // Fondo blanco para el canvas
        this.ctx.fillStyle = '#ffffff';
        this.ctx.fillRect(0, 0, canvasWidth, canvasHeight);
        
        // Restaurar color para el dibujo
        this.ctx.fillStyle = '#2d3748';
        
        console.log('Canvas configurado:', canvasWidth, 'x', canvasHeight);
    }
    
    bindEvents() {
        // Eventos de mouse
        this.canvas.addEventListener('mousedown', (e) => this.startDrawing(e));
        this.canvas.addEventListener('mousemove', (e) => this.draw(e));
        this.canvas.addEventListener('mouseup', () => this.stopDrawing());
        this.canvas.addEventListener('mouseout', () => this.stopDrawing());
        
        // Eventos táctiles para dispositivos móviles
        this.canvas.addEventListener('touchstart', (e) => {
            e.preventDefault();
            const touch = e.touches[0];
            const mouseEvent = new MouseEvent('mousedown', {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            this.canvas.dispatchEvent(mouseEvent);
        });
        
        this.canvas.addEventListener('touchmove', (e) => {
            e.preventDefault();
            const touch = e.touches[0];
            const mouseEvent = new MouseEvent('mousemove', {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            this.canvas.dispatchEvent(mouseEvent);
        });
        
        this.canvas.addEventListener('touchend', (e) => {
            e.preventDefault();
            const mouseEvent = new MouseEvent('mouseup', {});
            this.canvas.dispatchEvent(mouseEvent);
        });
    }
    
    getMousePos(e) {
        const rect = this.canvas.getBoundingClientRect();
        const scaleX = this.canvas.width / rect.width;
        const scaleY = this.canvas.height / rect.height;
        
        return {
            x: (e.clientX - rect.left) * scaleX,
            y: (e.clientY - rect.top) * scaleY
        };
    }
    
    startDrawing(e) {
        this.isDrawing = true;
        const pos = this.getMousePos(e);
        this.ctx.beginPath();
        this.ctx.moveTo(pos.x, pos.y);
        console.log('Iniciando dibujo en:', pos.x, pos.y);
    }
    
    draw(e) {
        if (!this.isDrawing) return;
        
        const pos = this.getMousePos(e);
        this.ctx.lineTo(pos.x, pos.y);
        this.ctx.stroke();
        this.hasSignature = true;
        console.log('Dibujando en:', pos.x, pos.y);
    }
    
    stopDrawing() {
        if (this.isDrawing) {
            this.isDrawing = false;
            this.ctx.beginPath();
        }
    }
    
    clear() {
        const canvasWidth = this.canvas.width;
        const canvasHeight = this.canvas.height;
        
        this.ctx.clearRect(0, 0, canvasWidth, canvasHeight);
        this.ctx.fillStyle = '#ffffff';
        this.ctx.fillRect(0, 0, canvasWidth, canvasHeight);
        this.ctx.fillStyle = '#2d3748';
        this.hasSignature = false;
        
        // Limpiar datos guardados
        const signatureDataInput = document.getElementById('signatureData');
        if (signatureDataInput) {
            signatureDataInput.value = '';
        }
        
        this.updateStatus('info', '<i class="fas fa-info-circle"></i> Dibuje su firma en el área anterior');
        console.log('Canvas limpiado');
    }
    
    save() {
        if (!this.hasSignature) {
            this.updateStatus('warning', '<i class="fas fa-exclamation-triangle"></i> Por favor, dibuje su firma antes de guardar');
            return false;
        }
        
        try {
            const dataURL = this.canvas.toDataURL('image/png');
            const signatureDataInput = document.getElementById('signatureData');
            
            if (signatureDataInput) {
                signatureDataInput.value = dataURL;
                this.updateStatus('success', '<i class="fas fa-check-circle"></i> Firma guardada correctamente');
                return true;
            }
            
            throw new Error('No se pudo encontrar el campo de datos de firma');
        } catch (error) {
            console.error('Error al guardar la firma:', error);
            this.updateStatus('error', '<i class="fas fa-times-circle"></i> Error al guardar la firma');
            return false;
        }
    }
    
    updateStatus(type, message) {
        const statusElement = document.getElementById('signatureStatus');
        if (statusElement) {
            statusElement.className = `signature-status ${type}`;
            statusElement.innerHTML = message;
        }
    }
    
    setCurrentDate() {
        const fechaFirmaInput = document.getElementById('fechaFirma');
        if (fechaFirmaInput) {
            const today = new Date();
            const formattedDate = today.toISOString().split('T')[0];
            fechaFirmaInput.value = formattedDate;
        }
    }
}

// Variable global para el sistema de firma
let signaturePadInstance = null;

// =============================================
// MÓDULO DE ANÁLISIS CON GEMINI IA
// =============================================

const GeminiAnalysis = (function() {
    const API_BASE_URL = 'http://localhost:3000/api';
    
    // Mapeo de preguntas por categorías para las funciones cognitivas
    const FUNCIONES_COGNITIVAS_MAPPING = {
        'Percepción': [
            {
                name: 'percepcion',
                pregunta: 'Puede discriminar: forma, color, tamaño, figura, fondo, e información auditiva y visual.'
            }
        ],
        'Atención': [
            {
                name: 'atencion_descanso',
                pregunta: 'El estudiante reporta sentirse descansado y haber dormido bien.'
            },
            {
                name: 'atencion_actividades',
                pregunta: 'Desarrolla actividades de inicio a fin.'
            },
            {
                name: 'atencion_concentracion',
                pregunta: 'Se concentra en las actividades que está realizando.'
            },
            {
                name: 'atencion_instrucciones',
                pregunta: 'Sigue instrucciones de 2 ó 3 pasos.'
            },
            {
                name: 'atencion_selectiva',
                pregunta: 'Puede concentrarse en algunos estímulos ignorando otros.'
            },
            {
                name: 'atencion_cambio',
                pregunta: 'Cambia fácilmente su atención de una actividad a otra.'
            },
            {
                name: 'atencion_tiempo',
                pregunta: 'Mantiene la atención por períodos de tiempo apropiados para su edad.'
            },
            {
                name: 'atencion_distractores',
                pregunta: 'Se distrae con estímulos irrelevantes (auditivos, visuales, etc.).'
            },
            {
                name: 'atencion_sostenida',
                pregunta: 'Mantiene la atención sostenida ante tareas repetitivas.'
            },
            {
                name: 'atencion_multiple',
                pregunta: 'Puede realizar dos tareas mentales al mismo tiempo.'
            }
        ],
        'Memoria': [
            {
                name: 'memoria_secuencias',
                pregunta: 'Recuerda secuencias de 3 a 5 elementos.'
            },
            {
                name: 'memoria_instrucciones',
                pregunta: 'Recuerda instrucciones dadas hace algunos minutos.'
            },
            {
                name: 'memoria_hechos',
                pregunta: 'Recuerda hechos después de haberlos escuchado.'
            },
            {
                name: 'memoria_tareas',
                pregunta: 'Recuerda qué debe hacer sin que se lo recuerden.'
            },
            {
                name: 'memoria_narraciones',
                pregunta: 'Recuerda lo esencial de narraciones, historias o programas de TV.'
            },
            {
                name: 'memoria_detalles',
                pregunta: 'Recuerda detalles de lugares que ha visitado.'
            },
            {
                name: 'memoria_nombres',
                pregunta: 'Recuerda nombres de personas que conoce.'
            },
            {
                name: 'memoria_ubicacion',
                pregunta: 'Recuerda dónde pone las cosas.'
            }
        ],
        'Procesos de Razonamiento': [
            {
                name: 'razonamiento_hipotesis',
                pregunta: 'Es hábil para plantear hipótesis o explicaciones frente a fenómenos en clase.'
            },
            {
                name: 'razonamiento_predicciones',
                pregunta: 'Hace predicciones sobre lo que puede suceder.'
            },
            {
                name: 'razonamiento_relaciones',
                pregunta: 'Establece relaciones de causa y efecto.'
            },
            {
                name: 'razonamiento_problemas',
                pregunta: 'Resuelve problemas cotidianos de manera autónoma.'
            },
            {
                name: 'razonamiento_analogias',
                pregunta: 'Entiende y utiliza analogías.'
            },
            {
                name: 'razonamiento_critico',
                pregunta: 'Demuestra pensamiento crítico frente a situaciones del entorno.'
            },
            {
                name: 'razonamiento_logico',
                pregunta: 'Maneja conceptos de lógica (si... entonces, todos, algunos, ninguno).'
            },
            {
                name: 'razonamiento_abstraccion',
                pregunta: 'Entiende conceptos abstractos apropiados para su edad.'
            },
            {
                name: 'razonamiento_clasificacion',
                pregunta: 'Clasifica objetos por atributos o categorías.'
            },
            {
                name: 'razonamiento_patrones',
                pregunta: 'Identifica patrones en secuencias numéricas, de formas o de colores.'
            }
        ]
    };

    // Mapeo para las nuevas secciones
    const SECCIONES_MAPPING = {
        'Procesos de Razonamiento': {
            endpoint: 'analizar-procesos-razonamiento',
            textareaId: 'observacionesRazonamiento',
            buttonId: 'analizarRazonamiento',
            preguntas: [
                {
                    name: 'razonamiento_hipotesis',
                    pregunta: 'Es hábil para plantear hipótesis o explicaciones frente a fenómenos en clase.'
                },
                {
                    name: 'razonamiento_predicciones',
                    pregunta: 'Hace predicciones sobre lo que puede suceder.'
                },
                {
                    name: 'razonamiento_relaciones',
                    pregunta: 'Establece relaciones de causa y efecto.'
                },
                {
                    name: 'razonamiento_problemas',
                    pregunta: 'Resuelve problemas cotidianos de manera autónoma.'
                },
                {
                    name: 'razonamiento_analogias',
                    pregunta: 'Entiende y utiliza analogías.'
                },
                {
                    name: 'razonamiento_critico',
                    pregunta: 'Demuestra pensamiento crítico frente a situaciones del entorno.'
                },
                {
                    name: 'razonamiento_logico',
                    pregunta: 'Maneja conceptos de lógica (si... entonces, todos, algunos, ninguno).'
                },
                {
                    name: 'razonamiento_abstraccion',
                    pregunta: 'Entiende conceptos abstractos apropiados para su edad.'
                },
                {
                    name: 'razonamiento_clasificacion',
                    pregunta: 'Clasifica objetos por atributos o categorías.'
                },
                {
                    name: 'razonamiento_patrones',
                    pregunta: 'Identifica patrones en secuencias numéricas, de formas o de colores.'
                }
            ]
        },
        'Competencias Lectoras y Escriturales': {
            endpoint: 'analizar-competencias-lectoras',
            textareaId: 'observacionesCompetenciasLectoras',
            buttonId: 'analizarCompetenciasLectoras',
            preguntas: [
                { name: 'lectura_fluidez', pregunta: 'Lee con fluidez, respetando signos de puntuación y entonación adecuada.' },
                { name: 'textos_simples_idea_principal', pregunta: 'En textos poco complejos: Identifica idea principal.' },
                { name: 'textos_simples_ideas_secundarias', pregunta: 'En textos poco complejos: Identifica ideas secundarias.' },
                { name: 'textos_simples_inferencias', pregunta: 'En textos poco complejos: Realiza inferencias.' },
                { name: 'textos_complejos_idea_principal', pregunta: 'En textos complejos: Identifica idea principal.' },
                { name: 'textos_complejos_ideas_secundarias', pregunta: 'En textos complejos: Identifica ideas secundarias.' },
                { name: 'textos_complejos_inferencias', pregunta: 'En textos complejos: Realiza inferencias.' },
                { name: 'esquemas_diagramas', pregunta: 'Hace esquemas o diagramas con conceptos fundamentales y sus relaciones.' },
                { name: 'escritura_precision', pregunta: 'Escribe sin omitir letras o sílabas, no confunde palabras ni letras.' },
                { name: 'escritura_redaccion', pregunta: 'Escribe con buena redacción.' },
                { name: 'escritura_ortografia', pregunta: 'Escribe con buena ortografía.' },
                { name: 'escritos_argumento_claro', pregunta: 'En sus escritos: Presenta un argumento claro.' },
                { name: 'escritos_conocimientos_previos', pregunta: 'En sus escritos: Usa conocimientos previos de manera adecuada.' },
                { name: 'escritos_nueva_informacion', pregunta: 'En sus escritos: Incorpora nueva información relevante.' },
                { name: 'escritos_claridad_mensaje', pregunta: 'En sus escritos: Es claro en su mensaje.' },
                { name: 'escritos_cierre_conclusion', pregunta: 'En sus escritos: Hace un cierre o conclusión.' },
                { name: 'escritos_mejora_texto', pregunta: 'En sus escritos: Identifica errores y sabe mejorar el texto.' },
                { name: 'antes_escribir_planifica', pregunta: 'Antes de escribir: Planifica cómo lo va a escribir.' },
                { name: 'antes_escribir_claridad_parrafos', pregunta: 'Antes de escribir: Tiene claridad sobre qué compartirá y qué tratará en cada párrafo.' }
            ]
        },
        'Habilidades Numéricas': {
            endpoint: 'analizar-habilidades-numericas',
            textareaId: 'observacionesHabilidadesNumericas',
            buttonId: 'analizarHabilidadesNumericas',
            preguntas: [
                { name: 'numericas_secuencia', pregunta: 'Sigue secuencia numérica.' },
                { name: 'numericas_suma_simple', pregunta: 'Realiza suma simple.' },
                { name: 'numericas_resta_simple', pregunta: 'Realiza resta simple.' },
                { name: 'numericas_multiplicacion', pregunta: 'Multiplica por uno, dos o más cifras.' },
                { name: 'numericas_division', pregunta: 'Divide por una, dos o más cifras.' },
                { name: 'numericas_problemas_grado', pregunta: 'Resuelve situaciones problema acorde a las competencias del grado.' }
            ]
        },
        'Funciones Ejecutivas': {
            endpoint: 'analizar-funciones-ejecutivas',
            textareaId: 'observacionesFuncionesEjecutivas',
            buttonId: 'analizarFuncionesEjecutivas',
            preguntas: [
                { name: 'ejecutivas_planifica', pregunta: 'Planifica las acciones para alcanzar un objetivo.' },
                { name: 'ejecutivas_organiza_materiales', pregunta: 'Organiza los materiales que necesita.' },
                { name: 'ejecutivas_controla_emociones', pregunta: 'Controla las emociones cuando algo no sale como espera.' },
                { name: 'ejecutivas_autorregula', pregunta: 'Se autorregula durante la realización de tareas.' },
                { name: 'ejecutivas_adaptabilidad', pregunta: 'Se acomoda a diferentes posibilidades si la preferida no se puede implementar.' },
                { name: 'ejecutivas_monitoreo_ajuste', pregunta: 'Monitorea y ajusta sus acciones cuando no alcanza la meta propuesta.' }
            ]
        },
        'Dimensión Comunicativa': {
            endpoint: 'analizar-dimension-comunicativa',
            textareaId: 'observacionesDimensionComunicativa',
            buttonId: 'analizarDimensionComunicativa',
            preguntas: [
                { name: 'comunicativa_comunicacion_medios', pregunta: 'Se comunica oralmente o con otros medios (lengua de señas, tableros de apoyo, etc.).' },
                { name: 'comunicativa_sigue_conversaciones', pregunta: 'Sigue el hilo de las conversaciones.' },
                { name: 'comunicativa_expresa_ideas', pregunta: 'Expresa sus ideas con frases correctas.' },
                { name: 'comunicativa_busca_entendimiento', pregunta: 'Busca hacerse entender en lo que requiere o necesita.' },
                { name: 'comunicativa_describe_experiencias', pregunta: 'Describe acontecimientos familiares o experiencias cotidianas.' },
                { name: 'comunicativa_escucha_responde', pregunta: 'Escucha y responde de forma interesada cuando otros le hablan.' },
                { name: 'comunicativa_interpreta_dobles_sentidos', pregunta: 'Interpreta dobles sentidos y refranes (ej.: "no des papaya", "eres un sapo").' },
                { name: 'comunicativa_sentido_humor', pregunta: 'Tiene sentido del humor apropiado a su edad.' },
                { name: 'comunicativa_reciprocidad', pregunta: 'Es recíproco en conversaciones (espera turno, reconoce cambios de tema, usa gestos adecuados).' },
                { name: 'comunicativa_estilo_formal', pregunta: 'Si su estilo es extraño, puede ser demasiado formal o con vocabulario rebuscado.' },
                { name: 'comunicativa_tono_voz', pregunta: 'Emplea un tono de voz ajustado a lo que dice.' },
                { name: 'comunicativa_sistema_tradicional', pregunta: 'Utiliza un sistema de comunicación tradicional.' }
            ]
        },
        'Dimensión Corporal': {
            endpoint: 'analizar-dimension-corporal',
            textareaId: 'observacionesDimensionCorporal',
            buttonId: 'analizarDimensionCorporal',
            preguntas: [
                { name: 'corporal_desplazamiento_caminar', pregunta: 'DESPLAZAMIENTO: Caminar' },
                { name: 'corporal_desplazamiento_correr', pregunta: 'DESPLAZAMIENTO: Correr' },
                { name: 'corporal_desplazamiento_saltar', pregunta: 'DESPLAZAMIENTO: Saltar' },
                { name: 'corporal_coordinacion_manual', pregunta: 'COORDINACIÓN MANUAL: Movimientos simultáneos, alternos y disociados' },
                { name: 'corporal_manejo_espacio', pregunta: 'MANEJO DEL ESPACIO: Posición en el espacio, relaciones espaciales, calidad de escritura, manejo del renglón' }
            ]
        },
        'Dimensión Socioafectiva': {
            endpoint: 'analizar-dimension-socioafectiva',
            textareaId: 'observacionesDimensionSocioafectiva',
            buttonId: 'analizarDimensionSocioafectiva',
            preguntas: [
                { name: 'socioafectiva_valoracion_si_mismo', pregunta: 'PROCESOS DE SOCIALIZACIÓN: Valoración de sí mismo' },
                { name: 'socioafectiva_toma_decisiones', pregunta: 'PROCESOS DE SOCIALIZACIÓN: Toma de decisiones' },
                { name: 'socioafectiva_autoestima', pregunta: 'PROCESOS DE SOCIALIZACIÓN: Autoestima' },
                { name: 'socioafectiva_expresion_sentimientos', pregunta: 'PROCESOS DE SOCIALIZACIÓN: Expresión de sentimientos' },
                { name: 'socioafectiva_respeto_norma', pregunta: 'PROCESOS DE SOCIALIZACIÓN: Respeto por la norma' }
            ]
        },
        'Entornos del Estudiante': {
            endpoint: 'analizar-entornos-estudiante',
            textareaId: 'observacionesEntornos',
            buttonId: 'analizarEntornosEstudiante',
            preguntas: [
                { name: 'entorno_caracteristicas_familiares', pregunta: 'CARACTERÍSTICAS FAMILIARES: Dinámica familiar, acompañamiento de la familia' },
                { name: 'entorno_relacion_estudiante_estudiante', pregunta: 'EN EL AULA - Clima del aula: Relación estudiante – estudiante' },
                { name: 'entorno_relacion_estudiante_maestro', pregunta: 'EN EL AULA - Clima del aula: Relación estudiante – maestro' },
                { name: 'entorno_disposicion_espacios', pregunta: 'EN EL AULA - Ambiente físico: Disposición de los espacios' },
                { name: 'entorno_accesibilidad', pregunta: 'EN EL AULA - Ambiente físico: Accesibilidad' },
                { name: 'entorno_ubicacion_estudiante', pregunta: 'EN EL AULA: Ubicación del estudiante en el aula' }
            ]
        }
    };

    function recopilarRespuestas() {
        const funcionesCognitivas = [];
        
        // Recorrer todas las categorías y sus preguntas
        Object.keys(FUNCIONES_COGNITIVAS_MAPPING).forEach(categoria => {
            FUNCIONES_COGNITIVAS_MAPPING[categoria].forEach(item => {
                const elementos = document.querySelectorAll(`input[name="${item.name}"]:checked`);
                if (elementos.length > 0) {
                    const valor = elementos[0].value;
                    const respuestaTexto = obtenerTextoRespuesta(valor);
                    
                    funcionesCognitivas.push({
                        categoria: categoria,
                        pregunta: item.pregunta,
                        respuesta: respuestaTexto,
                        valor: valor
                    });
                }
            });
        });
        
        return funcionesCognitivas;
    }

    function recopilarRespuestasSeccion(nombreSeccion) {
        const seccion = SECCIONES_MAPPING[nombreSeccion];
        if (!seccion) return [];

        const respuestas = [];
        
        seccion.preguntas.forEach(item => {
            const elementos = document.querySelectorAll(`input[name="${item.name}"]:checked`);
            if (elementos.length > 0) {
                const valor = elementos[0].value;
                const respuestaTexto = obtenerTextoRespuesta(valor);
                
                respuestas.push({
                    categoria: nombreSeccion,
                    pregunta: item.pregunta,
                    respuesta: respuestaTexto,
                    valor: valor
                });
            }
        });
        
        return respuestas;
    }

    function obtenerTextoRespuesta(valor) {
        const mapeoRespuestas = {
            '1': 'Nunca (1)',
            '2': 'Algunas veces (2)', 
            '3': 'Frecuentemente (3)',
            '4': 'Siempre (4)'
        };
        return mapeoRespuestas[valor] || `Valor: ${valor}`;
    }

    function validarRespuestasCompletas() {
        const totalPreguntas = Object.values(FUNCIONES_COGNITIVAS_MAPPING)
            .reduce((sum, categoria) => sum + categoria.length, 0);
        
        const respuestasCompletas = recopilarRespuestas();
        
        return {
            completas: respuestasCompletas.length === totalPreguntas,
            respondidas: respuestasCompletas.length,
            total: totalPreguntas,
            porcentaje: Math.round((respuestasCompletas.length / totalPreguntas) * 100)
        };
    }

    function mostrarEstadoCarga(mensaje) {
        const textarea = document.getElementById('observacionesCognitivas');
        const boton = document.getElementById('analizarConIA');
        
        if (textarea) {
            textarea.value = mensaje;
            textarea.style.background = '#f8f9fa';
            textarea.style.color = '#6c757d';
        }
        
        if (boton) {
            boton.disabled = true;
            boton.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i>Generando resumen...';
        }
    }

    function restaurarEstadoNormal() {
        const textarea = document.getElementById('observacionesCognitivas');
        const boton = document.getElementById('analizarConIA');
        
        if (textarea) {
            textarea.style.background = '';
            textarea.style.color = '';
        }
        
        if (boton) {
            boton.disabled = false;
            boton.innerHTML = '<i class="fas fa-brain" style="margin-right: 8px;"></i>Generar Resumen Profesional';
        }
    }

    async function analizarSeccionGenerica(nombreSeccion) {
        try {
            const seccion = SECCIONES_MAPPING[nombreSeccion];
            if (!seccion) {
                throw new Error(`Sección '${nombreSeccion}' no encontrada`);
            }

            // Validar que hay respuestas
            const respuestas = recopilarRespuestasSeccion(nombreSeccion);
            const validacion = validarRespuestasSeccion(nombreSeccion);
            
            if (validacion.respondidas === 0) {
                alert(`⚠️ No hay respuestas seleccionadas.\n\nPor favor, complete al menos algunas preguntas de ${nombreSeccion} antes de solicitar el análisis.`);
                return;
            }

            if (!validacion.completas) {
                const continuar = confirm(
                    `📊 Análisis Parcial Disponible\n\n` +
                    `Se han respondido ${validacion.respondidas} de ${validacion.total} preguntas (${validacion.porcentaje}%).\n\n` +
                    `¿Desea continuar con el análisis basado en las respuestas actuales?\n\n` +
                    `Nota: Para un análisis más completo, se recomienda responder todas las preguntas.`
                );
                
                if (!continuar) return;
            }

            // Mostrar estado de carga
            mostrarEstadoCargaSeccion(seccion.textareaId, seccion.buttonId, 
                `📋 Generando resumen profesional...\n\nAnalizando ${respuestas.length} respuestas para crear un resumen completo y preciso.\n\nEsto puede tomar unos segundos...`);

            // Llamar a la API
            const response = await fetch(`${API_BASE_URL}/gemini/analizar-funciones-cognitivas`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    funcionesCognitivas: respuestas
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Error en la respuesta del servidor');
            }

            if (data.success) {
                // Mostrar el análisis en el textarea correspondiente
                const textarea = document.getElementById(seccion.textareaId);
                if (textarea) {
                    const analisisLimpio = `${data.data.analisis}\n\n────────────────────────────\nFecha de resumen: ${new Date().toLocaleString('es-CO')}\nRespuestas evaluadas: ${respuestas.length}\nPalabras generadas: ${data.data.palabrasGeneradas || 'N/A'}`;
                    
                    textarea.value = analisisLimpio;
                    
                    // Animar el textarea para llamar la atención
                    textarea.style.border = '2px solid #28a745';
                    setTimeout(() => {
                        textarea.style.border = '';
                    }, 3000);
                }

                // Mostrar notificación de éxito
                alert(`✅ ¡Resumen completado exitosamente!\n\nSe ha generado un resumen profesional completo y preciso de ${nombreSeccion} basado en las respuestas seleccionadas.\n\nPuede revisar y editar el contenido según sea necesario.`);
                
            } else {
                throw new Error(data.message || 'Error desconocido');
            }

        } catch (error) {
            console.error(`Error en análisis de ${nombreSeccion}:`, error);
            
            let mensajeError = `❌ Error al generar el análisis de ${nombreSeccion}:\n\n`;
            
            if (error.message.includes('API key')) {
                mensajeError += '🔑 La API key de Gemini no está configurada correctamente.\n\nContacte al administrador del sistema.';
            } else if (error.message.includes('QUOTA_EXCEEDED')) {
                mensajeError += '📊 Se ha excedido la cuota de la API de Gemini.\n\nIntente nuevamente más tarde.';
            } else if (error.message.includes('Failed to fetch')) {
                mensajeError += '🌐 Error de conexión con el servidor.\n\nVerifique su conexión a internet y que el servidor esté funcionando.';
            } else {
                mensajeError += error.message;
            }
            
            const seccion = SECCIONES_MAPPING[nombreSeccion];
            if (seccion) {
                const textarea = document.getElementById(seccion.textareaId);
                if (textarea) {
                    textarea.value = mensajeError + '\n\nPuede escribir sus observaciones manualmente mientras se resuelve el problema.';
                }
            }
            
            alert(mensajeError);
            
        } finally {
            // Restaurar estado normal del botón
            restaurarEstadoNormalSeccion(buttonId);
        }
    }

    async function analizarConGemini() {
        try {
            // Validar que hay respuestas
            const validacion = validarRespuestasCompletas();
            
            if (validacion.respondidas === 0) {
                alert('⚠️ No hay respuestas seleccionadas.\n\nPor favor, complete al menos algunas preguntas de las Funciones Cognitivas Básicas antes de solicitar el análisis.');
                return;
            }

            if (!validacion.completas) {
                const continuar = confirm(
                    `📊 Análisis Parcial Disponible\n\n` +
                    `Se han respondido ${validacion.respondidas} de ${validacion.total} preguntas (${validacion.porcentaje}%).\n\n` +
                    `¿Desea continuar con el análisis basado en las respuestas actuales?\n\n` +
                    `Nota: Para un análisis más completo, se recomienda responder todas las preguntas.`
                );
                
                if (!continuar) return;
            }

            // Recopilar datos
            const funcionesCognitivas = recopilarRespuestas();
            
            // Mostrar estado de carga
            mostrarEstadoCarga(`📋 Generando resumen profesional...\n\nAnalizando ${funcionesCognitivas.length} respuestas para crear un resumen completo y preciso.\n\nEsto puede tomar unos segundos...`);

            // Llamar a la API
            const response = await fetch(`${API_BASE_URL}/gemini/analizar-funciones-cognitivas`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    funcionesCognitivas: funcionesCognitivas
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Error en la respuesta del servidor');
            }

            if (data.success) {
                // Mostrar el análisis en el textarea sin referencias a IA
                const textarea = document.getElementById('observacionesCognitivas');
                if (textarea) {
                    // Resumen limpio sin mencionar Gemini
                    const analisisLimpio = `${data.data.analisis}\n\n────────────────────────────\nFecha de resumen: ${new Date().toLocaleString('es-CO')}\nRespuestas evaluadas: ${funcionesCognitivas.length}\nPalabras generadas: ${data.data.palabrasGeneradas || 'N/A'}`;
                    
                    textarea.value = analisisLimpio;
                    
                    // Animar el textarea para llamar la atención
                    textarea.style.border = '2px solid #28a745';
                    setTimeout(() => {
                        textarea.style.border = '';
                    }, 3000);
                }

                // Mostrar notificación de éxito sin mencionar IA
                alert('✅ ¡Resumen completado exitosamente!\n\nSe ha generado un resumen profesional completo y preciso basado en las respuestas seleccionadas.\n\nPuede revisar y editar el contenido según sea necesario.');
                
            } else {
                throw new Error(data.message || 'Error desconocido');
            }

        } catch (error) {
            console.error('Error en análisis con Gemini:', error);
            
            let mensajeError = '❌ Error al generar el análisis:\n\n';
            
            if (error.message.includes('API key')) {
                mensajeError += '🔑 La API key de Gemini no está configurada correctamente.\n\nContacte al administrador del sistema.';
            } else if (error.message.includes('QUOTA_EXCEEDED')) {
                mensajeError += '📊 Se ha excedido la cuota de la API de Gemini.\n\nIntente nuevamente más tarde.';
            } else if (error.message.includes('Failed to fetch')) {
                mensajeError += '🌐 Error de conexión con el servidor.\n\nVerifique su conexión a internet y que el servidor esté funcionando.';
            } else {
                mensajeError += error.message;
            }
            
            const textarea = document.getElementById('observacionesCognitivas');
            if (textarea) {
                textarea.value = mensajeError + '\n\nPuede escribir sus observaciones manualmente mientras se resuelve el problema.';
            }
            
            alert(mensajeError);
            
        } finally {
            // Restaurar estado normal del botón
            restaurarEstadoNormal();
        }
    }

    function validarRespuestasSeccion(nombreSeccion) {
        const seccion = SECCIONES_MAPPING[nombreSeccion];
        if (!seccion) return { completas: false, respondidas: 0, total: 0, porcentaje: 0 };

        const totalPreguntas = seccion.preguntas.length;
        const respuestasCompletas = recopilarRespuestasSeccion(nombreSeccion);
        
        return {
            completas: respuestasCompletas.length === totalPreguntas,
            respondidas: respuestasCompletas.length,
            total: totalPreguntas,
            porcentaje: Math.round((respuestasCompletas.length / totalPreguntas) * 100)
        };
    }

    function mostrarEstadoCargaSeccion(textareaId, buttonId, mensaje) {
        const textarea = document.getElementById(textareaId);
        const boton = document.getElementById(buttonId);
        
        if (textarea) {
            textarea.value = mensaje;
            textarea.style.background = '#f8f9fa';
            textarea.style.color = '#6c757d';
        }
        
        if (boton) {
            boton.disabled = true;
            boton.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i>Generando resumen...';
        }
    }

    function restaurarEstadoNormalSeccion(buttonId) {
        const boton = document.getElementById(buttonId);
        
        if (boton) {
            boton.disabled = false;
            boton.innerHTML = '<i class="fas fa-brain" style="margin-right: 8px;"></i>Generar Resumen Profesional';
        }
    }

    async function analizarSeccionGenerica(nombreSeccion, textareaId, buttonId) {
        try {
            // Validar que hay respuestas
            const validacion = validarRespuestasSeccion(nombreSeccion);
            
            if (validacion.respondidas === 0) {
                alert(`⚠️ No hay respuestas seleccionadas.\n\nPor favor, complete al menos algunas preguntas de ${nombreSeccion} antes de solicitar el análisis.`);
                return;
            }

            if (!validacion.completas) {
                const continuar = confirm(
                    `📊 Análisis Parcial Disponible\n\n` +
                    `Se han respondido ${validacion.respondidas} de ${validacion.total} preguntas (${validacion.porcentaje}%).\n\n` +
                    `¿Desea continuar con el análisis basado en las respuestas actuales?\n\n` +
                    `Nota: Para un análisis más completo, se recomienda responder todas las preguntas.`
                );
                
                if (!continuar) return;
            }

            // Recopilar datos de la sección
            const respuestasSeccion = recopilarRespuestasSeccion(nombreSeccion);
            
            // Mostrar estado de carga
            mostrarEstadoCargaSeccion(textareaId, buttonId, 
                `📋 Generando resumen profesional...\n\nAnalizando ${respuestasSeccion.length} respuestas de ${nombreSeccion} para crear un resumen completo y preciso.\n\nEsto puede tomar unos segundos...`);

            // Llamar a la API - reutilizar el endpoint existente
            const response = await fetch(`${API_BASE_URL}/gemini/analizar-funciones-cognitivas`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    funcionesCognitivas: respuestasSeccion,
                    seccion: nombreSeccion
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Error en la respuesta del servidor');
            }

            if (data.success) {
                // Mostrar el análisis en el textarea específico
                const textarea = document.getElementById(textareaId);
                if (textarea) {
                    // Resumen limpio sin mencionar Gemini
                    const analisisLimpio = `${data.data.analisis}\n\n────────────────────────────\nFecha de resumen: ${new Date().toLocaleString('es-CO')}\nRespuestas evaluadas: ${respuestasSeccion.length}\nPalabras generadas: ${data.data.palabrasGeneradas || 'N/A'}`;
                    
                    textarea.value = analisisLimpio;
                    
                    // Animar el textarea para llamar la atención
                    textarea.style.border = '2px solid #28a745';
                    setTimeout(() => {
                        textarea.style.border = '';
                    }, 3000);
                }

                // Mostrar notificación de éxito sin mencionar IA
                alert(`✅ ¡Resumen de ${nombreSeccion} completado exitosamente!\n\nSe ha generado un resumen profesional completo y preciso basado en las respuestas seleccionadas.\n\nPuede revisar y editar el contenido según sea necesario.`);
                
            } else {
                throw new Error(data.message || 'Error desconocido');
            }

        } catch (error) {
            console.error(`Error en análisis de ${nombreSeccion}:`, error);
            
            let mensajeError = '❌ Error al generar el análisis:\n\n';
            
            if (error.message.includes('API key')) {
                mensajeError += '🔑 La API key de Gemini no está configurada correctamente.\n\nContacte al administrador del sistema.';
            } else if (error.message.includes('QUOTA_EXCEEDED')) {
                mensajeError += '📊 Se ha excedido la cuota de la API de Gemini.\n\nIntente nuevamente más tarde.';
            } else if (error.message.includes('Failed to fetch')) {
                mensajeError += '🌐 Error de conexión con el servidor.\n\nVerifique su conexión a internet y que el servidor esté funcionando.';
            } else {
                mensajeError += error.message;
            }
            
            const textarea = document.getElementById(textareaId);
            if (textarea) {
                textarea.value = mensajeError + '\n\nPuede escribir sus observaciones manualmente mientras se resuelve el problema.';
            }
            
            alert(mensajeError);
            
        } finally {
            // Restaurar estado normal del botón
            restaurarEstadoNormalSeccion(buttonId);
        }
    }

    async function analizarConGemini() {
        try {
            // Validar que hay respuestas
            const validacion = validarRespuestasCompletas();
            
            if (validacion.respondidas === 0) {
                alert('⚠️ No hay respuestas seleccionadas.\n\nPor favor, complete al menos algunas preguntas de las Funciones Cognitivas Básicas antes de solicitar el análisis.');
                return;
            }

            if (!validacion.completas) {
                const continuar = confirm(
                    `📊 Análisis Parcial Disponible\n\n` +
                    `Se han respondido ${validacion.respondidas} de ${validacion.total} preguntas (${validacion.porcentaje}%).\n\n` +
                    `¿Desea continuar con el análisis basado en las respuestas actuales?\n\n` +
                    `Nota: Para un análisis más completo, se recomienda responder todas las preguntas.`
                );
                
                if (!continuar) return;
            }

            // Recopilar datos
            const funcionesCognitivas = recopilarRespuestas();
            
            // Mostrar estado de carga
            mostrarEstadoCarga(`📋 Generando resumen profesional...\n\nAnalizando ${funcionesCognitivas.length} respuestas para crear un resumen completo y preciso.\n\nEsto puede tomar unos segundos...`);

            // Llamar a la API
            const response = await fetch(`${API_BASE_URL}/gemini/analizar-funciones-cognitivas`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    funcionesCognitivas: funcionesCognitivas
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Error en la respuesta del servidor');
            }

            if (data.success) {
                // Mostrar el análisis en el textarea sin referencias a IA
                const textarea = document.getElementById('observacionesCognitivas');
                if (textarea) {
                    // Resumen limpio sin mencionar Gemini
                    const analisisLimpio = `${data.data.analisis}\n\n────────────────────────────\nFecha de resumen: ${new Date().toLocaleString('es-CO')}\nRespuestas evaluadas: ${funcionesCognitivas.length}\nPalabras generadas: ${data.data.palabrasGeneradas || 'N/A'}`;
                    
                    textarea.value = analisisLimpio;
                    
                    // Animar el textarea para llamar la atención
                    textarea.style.border = '2px solid #28a745';
                    setTimeout(() => {
                        textarea.style.border = '';
                    }, 3000);
                }

                // Mostrar notificación de éxito sin mencionar IA
                alert('✅ ¡Resumen completado exitosamente!\n\nSe ha generado un resumen profesional completo y preciso basado en las respuestas seleccionadas.\n\nPuede revisar y editar el contenido según sea necesario.');
                
            } else {
                throw new Error(data.message || 'Error desconocido');
            }

        } catch (error) {
            console.error('Error en análisis con Gemini:', error);
            
            let mensajeError = '❌ Error al generar el análisis:\n\n';
            
            if (error.message.includes('API key')) {
                mensajeError += '🔑 La API key de Gemini no está configurada correctamente.\n\nContacte al administrador del sistema.';
            } else if (error.message.includes('QUOTA_EXCEEDED')) {
                mensajeError += '📊 Se ha excedido la cuota de la API de Gemini.\n\nIntente nuevamente más tarde.';
            } else if (error.message.includes('Failed to fetch')) {
                mensajeError += '🌐 Error de conexión con el servidor.\n\nVerifique su conexión a internet y que el servidor esté funcionando.';
            } else {
                mensajeError += error.message;
            }
            
            const textarea = document.getElementById('observacionesCognitivas');
            if (textarea) {
                textarea.value = mensajeError + '\n\nPuede escribir sus observaciones manualmente mientras se resuelve el problema.';
            }
            
            alert(mensajeError);
            
        } finally {
            // Restaurar estado normal del botón
            restaurarEstadoNormal();
        }
    }

    // Funciones públicas
    return {
        inicializar: function() {
            // Botón principal de funciones cognitivas
            const boton = document.getElementById('analizarConIA');
            if (boton) {
                boton.addEventListener('click', analizarConGemini);
                console.log('✅ Módulo de análisis Gemini inicializado para Funciones Cognitivas');
            } else {
                console.warn('⚠️ No se encontró el botón de análisis con IA para Funciones Cognitivas');
            }
            
            // Botones para las nuevas secciones
            const secciones = {
                'Procesos de Razonamiento': { button: 'analizarRazonamiento', textarea: 'observacionesRazonamiento' },
                'Competencias Lectoras y Escriturales': { button: 'analizarCompetenciasLectoras', textarea: 'observacionesCompetenciasLectoras' },
                'Habilidades Numéricas': { button: 'analizarHabilidadesNumericas', textarea: 'observacionesHabilidadesNumericas' },
                'Funciones Ejecutivas': { button: 'analizarFuncionesEjecutivas', textarea: 'observacionesFuncionesEjecutivas' },
                'Dimensión Comunicativa': { button: 'analizarDimensionComunicativa', textarea: 'observacionesDimensionComunicativa' },
                'Dimensión Corporal': { button: 'analizarDimensionCorporal', textarea: 'observacionesDimensionCorporal' },
                'Dimensión Socioafectiva': { button: 'analizarDimensionSocioafectiva', textarea: 'observacionesDimensionSocioafectiva' },
                'Entornos del Estudiante': { button: 'analizarEntornosEstudiante', textarea: 'observacionesEntornos' }
            };
            
            Object.entries(secciones).forEach(([nombreSeccion, config]) => {
                const botonSeccion = document.getElementById(config.button);
                if (botonSeccion) {
                    botonSeccion.addEventListener('click', () => {
                        analizarSeccionGenerica(nombreSeccion, config.textarea, config.button);
                    });
                    console.log(`✅ Event listener agregado para ${nombreSeccion}`);
                } else {
                    console.warn(`⚠️ No se encontró el botón ${config.button} para ${nombreSeccion}`);
                }
            });
        },
        
        verificarConfiguracion: async function() {
            try {
                const response = await fetch(`${API_BASE_URL}/gemini/verificar-configuracion`);
                const data = await response.json();
                console.log('Estado de Gemini:', data);
                return data;
            } catch (error) {
                console.error('Error verificando Gemini:', error);
                return { configured: false, error: error.message };
            }
        }
    };
})();

// Variables para el manejo de áreas dinámicas
let contadorAreas = 1;

// Función para agregar nuevas áreas de evaluación
async function agregarNuevaArea() {
    contadorAreas++;
    
    const tbody = document.getElementById('areasTableBody');
    if (!tbody) {
        console.error('No se encontró el tbody de la tabla de áreas');
        return;
    }
    
    const nuevaFila = document.createElement('tr');
    nuevaFila.className = 'area-row';
    nuevaFila.innerHTML = `
        <td>
            <select name="area${contadorAreas}" id="area${contadorAreas}" class="form-control area-select">
                <option value="">Cargando asignaturas...</option>
            </select>
        </td>
        <td>
            <textarea name="fortalezas${contadorAreas}" id="fortalezas${contadorAreas}" rows="4" 
                    placeholder="Describa las fortalezas observadas en esta área..."
                    class="form-control area-textarea"></textarea>
        </td>
        <td>
            <textarea name="debilidades${contadorAreas}" id="debilidades${contadorAreas}" rows="4" 
                    placeholder="Describa las debilidades o áreas por mejorar..."
                    class="form-control area-textarea"></textarea>
        </td>
        <td>
            <textarea name="recomendaciones${contadorAreas}" id="recomendaciones${contadorAreas}" rows="4" 
                    placeholder="Escriba las recomendaciones para mejorar..."
                    class="form-control area-textarea"></textarea>
        </td>
    `;
    
    tbody.appendChild(nuevaFila);
    
    // Poblar el select con las asignaturas
    const nuevoSelect = document.getElementById(`area${contadorAreas}`);
    if (nuevoSelect) {
        await poblarSelectAsignaturas(nuevoSelect);
    }
    
    // Desplazarse suavemente hacia la nueva fila
    nuevaFila.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'center' 
    });
    
    // Enfocar el select de la nueva fila después de un pequeño delay
    setTimeout(() => {
        if (nuevoSelect) {
            nuevoSelect.focus();
        }
    }, 300);
}

// Función para obtener todas las áreas evaluadas (útil para el guardado)
function obtenerAreasEvaluadas() {
    const areas = [];
    const filas = document.querySelectorAll('.area-row');
    
    filas.forEach((fila, index) => {
        const numeroArea = index + 1;
        const areaSelect = document.getElementById(`area${numeroArea}`);
        const fortalezasTextarea = document.getElementById(`fortalezas${numeroArea}`);
        const debilidadesTextarea = document.getElementById(`debilidades${numeroArea}`);
        const recomendacionesTextarea = document.getElementById(`recomendaciones${numeroArea}`);
        
        if (areaSelect && fortalezasTextarea && debilidadesTextarea && recomendacionesTextarea) {
            const area = areaSelect.value;
            const fortalezas = fortalezasTextarea.value.trim();
            const debilidades = debilidadesTextarea.value.trim();
            const recomendaciones = recomendacionesTextarea.value.trim();
            
            // Solo agregar si hay al menos un campo completado
            if (area || fortalezas || debilidades || recomendaciones) {
                areas.push({
                    area,
                    fortalezas,
                    debilidades,
                    recomendaciones
                });
            }
        }
    });
    
    return areas;
}

// Función para validar las áreas antes del guardado
function validarAreas() {
    const areas = obtenerAreasEvaluadas();
    const errores = [];
    
    areas.forEach((area, index) => {
        if (area.area && (!area.fortalezas || !area.debilidades || !area.recomendaciones)) {
            errores.push(`Área ${index + 1}: Si selecciona un área, complete todos los campos.`);
        }
    });
    
    return {
        valido: errores.length === 0,
        errores
    };
}

// Variables para cache de asignaturas y DBA
let asignaturasCache = null;
let asignaturasEducacionInicialCache = null;
let dbaCache = {}; // Cache para DBA por asignatura-grado

// Función para cargar asignaturas desde la API
async function cargarAsignaturas() {
    try {
        // Si ya tenemos las asignaturas en cache, las retornamos
        if (asignaturasCache) {
            return asignaturasCache;
        }
        
        const response = await fetch('http://localhost:3000/api/asignaturas');
        const data = await response.json();
        
        if (data.success) {
            asignaturasCache = data.data;
            return asignaturasCache;
        } else {
            console.error('Error al cargar asignaturas:', data.message);
            return [];
        }
    } catch (error) {
        console.error('Error al conectar con la API de asignaturas:', error);
        // Devolver asignaturas por defecto en caso de error
        return [
            { id_asignatura: 1, nombre: 'Lengua Castellana' },
            { id_asignatura: 2, nombre: 'Matemáticas' },
            { id_asignatura: 3, nombre: 'Ciencias Naturales' },
            { id_asignatura: 4, nombre: 'Ciencias Sociales' },
            { id_asignatura: 5, nombre: 'Educación Artística' },
            { id_asignatura: 6, nombre: 'Educación Física, Recreación y Deporte' },
            { id_asignatura: 7, nombre: 'Educación Religiosa o Ética y Valores' },
            { id_asignatura: 8, nombre: 'Filosofía' },
            { id_asignatura: 9, nombre: 'Química' },
            { id_asignatura: 10, nombre: 'Física' }
        ];
    }
}

// Función para cargar asignaturas de educación inicial desde la API
async function cargarAsignaturasEducacionInicial() {
    try {
        // Si ya tenemos las dimensiones en cache, las retornamos
        if (asignaturasEducacionInicialCache) {
            return asignaturasEducacionInicialCache;
        }
        
        const response = await fetch('http://localhost:3000/api/asignaturas-educacion-inicial');
        const data = await response.json();
        
        if (data.success) {
            asignaturasEducacionInicialCache = data.data;
            return asignaturasEducacionInicialCache;
        } else {
            console.error('Error al cargar dimensiones de educación inicial:', data.message);
            return [];
        }
    } catch (error) {
        console.error('Error al conectar con la API de educación inicial:', error);
        // Devolver dimensiones por defecto en caso de error
        return [
            { id_asignatura_inicial: 1, nombre: 'Dimensión comunicativa' },
            { id_asignatura_inicial: 2, nombre: 'Dimensión cognitiva' },
            { id_asignatura_inicial: 3, nombre: 'Dimensión corporal' },
            { id_asignatura_inicial: 4, nombre: 'Dimensión socioafectiva' },
            { id_asignatura_inicial: 5, nombre: 'Dimensión espiritual' },
            { id_asignatura_inicial: 6, nombre: 'Dimensión ética' },
            { id_asignatura_inicial: 7, nombre: 'Dimensión estética' }
        ];
    }
}

// =============================================
// FUNCIONES PARA DERECHOS BÁSICOS DE APRENDIZAJE (DBA)
// =============================================

// Función para cargar DBA por asignatura y grado
async function cargarDba(idAsignatura, idGrado) {
    try {
        const cacheKey = `${idAsignatura}-${idGrado}`;
        
        // Si ya tenemos los DBA en cache, los retornamos
        if (dbaCache[cacheKey]) {
            return dbaCache[cacheKey];
        }
        
        const response = await fetch(`http://localhost:3000/api/dba/asignatura/${idAsignatura}/grado/${idGrado}`);
        const data = await response.json();
        
        if (data.success) {
            dbaCache[cacheKey] = data.data;
            return data.data;
        } else {
            console.error('Error al cargar DBA:', data.message);
            return null;
        }
    } catch (error) {
        console.error('Error al conectar con la API de DBA:', error);
        return null;
    }
}

// Función para obtener DBA con evidencias completas
async function cargarDbaConEvidencias(idDba) {
    try {
        const response = await fetch(`http://localhost:3000/api/dba/${idDba}/evidencias`);
        const data = await response.json();
        
        if (data.success) {
            return data.data;
        } else {
            console.error('Error al cargar DBA con evidencias:', data.message);
            return null;
        }
    } catch (error) {
        console.error('Error al conectar con la API de DBA:', error);
        return null;
    }
}

// Función para buscar DBA por término
async function buscarDba(termino) {
    try {
        if (!termino || termino.trim().length < 3) {
            return [];
        }
        
        const response = await fetch(`http://localhost:3000/api/dba/buscar?q=${encodeURIComponent(termino.trim())}`);
        const data = await response.json();
        
        if (data.success) {
            return data.data;
        } else {
            console.error('Error al buscar DBA:', data.message);
            return [];
        }
    } catch (error) {
        console.error('Error al conectar con la API de búsqueda de DBA:', error);
        return [];
    }
}

// Función para obtener asignaturas y grados que tienen DBA disponibles
async function cargarAsignaturasGradosConDba() {
    try {
        const response = await fetch('http://localhost:3000/api/dba/asignaturas-grados');
        const data = await response.json();
        
        if (data.success) {
            return data.data;
        } else {
            console.error('Error al cargar asignaturas y grados con DBA:', data.message);
            return [];
        }
    } catch (error) {
        console.error('Error al conectar con la API de asignaturas-grados DBA:', error);
        return [];
    }
}

// Función para poblar un select con asignaturas
async function poblarSelectAsignaturas(selectElement) {
    try {
        const asignaturas = await cargarAsignaturas();
        
        // Limpiar el select
        selectElement.innerHTML = '<option value="">Seleccione un área</option>';
        
        // Agregar cada asignatura como opción
        asignaturas.forEach(asignatura => {
            const option = document.createElement('option');
            option.value = asignatura.id_asignatura;
            option.textContent = asignatura.nombre;
            selectElement.appendChild(option);
        });
        
    } catch (error) {
        console.error('Error al poblar select de asignaturas:', error);
        selectElement.innerHTML = '<option value="">Error al cargar asignaturas</option>';
    }
}

// Función para inicializar todos los selects de asignaturas
async function inicializarSelectsAsignaturas() {
    try {
        // Cargar el select inicial
        const selectInicial = document.getElementById('area1');
        if (selectInicial) {
            await poblarSelectAsignaturas(selectInicial);
        }
        
        // También cargar cualquier select adicional que ya exista
        const todosLosSelects = document.querySelectorAll('.area-select');
        for (const select of todosLosSelects) {
            if (select.id !== 'area1') {
                await poblarSelectAsignaturas(select);
            }
        }
    } catch (error) {
        console.error('Error al inicializar selects de asignaturas:', error);
    }
}

// Función para obtener el análisis de barreras (útil para el guardado)
function obtenerAnalisisBarreras() {
    const barreras = {
        actitudinales: document.getElementById('barrerasActitudinales')?.value?.trim() || '',
        arquitectonicas: document.getElementById('barrerasArquitectonicas')?.value?.trim() || '',
        informacion: document.getElementById('barrerasInformacion')?.value?.trim() || '',
        organizativas: document.getElementById('barrerasOrganizativas')?.value?.trim() || '',
        metodologicas: document.getElementById('barrerasMetodologicas')?.value?.trim() || '',
        pedagogicas: document.getElementById('barrerasPedagogicas')?.value?.trim() || ''
    };
    
    return barreras;
}

// Función para validar el análisis de barreras
function validarAnalisisBarreras() {
    const barreras = obtenerAnalisisBarreras();
    const errores = [];
    
    // Verificar que al menos una barrera esté completada
    const tieneAlgunaBarrera = Object.values(barreras).some(barrera => barrera.length > 0);
    
    if (!tieneAlgunaBarrera) {
        errores.push('Debe completar al menos una barrera en el análisis.');
    }
    
    // Validar longitud mínima para barreras completadas
    Object.entries(barreras).forEach(([tipo, contenido]) => {
        if (contenido.length > 0 && contenido.length < 10) {
            const nombres = {
                actitudinales: 'Barreras Actitudinales',
                arquitectonicas: 'Barreras Arquitectónicas',
                informacion: 'Barreras de Acceso a Información',
                organizativas: 'Barreras Organizativas',
                metodologicas: 'Barreras Metodológicas',
                pedagogicas: 'Barreras Pedagógicas'
            };
            errores.push(`${nombres[tipo]}: Debe proporcionar una descripción más detallada (mínimo 10 caracteres).`);
        }
    });
    
    return {
        valido: errores.length === 0,
        errores,
        barreras
    };
}

// Función para limpiar el análisis de barreras
function limpiarAnalisisBarreras() {
    document.getElementById('barrerasActitudinales').value = '';
    document.getElementById('barrerasArquitectonicas').value = '';
    document.getElementById('barrerasInformacion').value = '';
    document.getElementById('barrerasOrganizativas').value = '';
    document.getElementById('barrerasMetodologicas').value = '';
    document.getElementById('barrerasPedagogicas').value = '';
}

// Función para contar caracteres y mostrar estadísticas (opcional)
function inicializarContadoresBarreras() {
    const textareas = [
        'barrerasActitudinales',
        'barrerasArquitectonicas', 
        'barrerasInformacion',
        'barrerasOrganizativas',
        'barrerasMetodologicas',
        'barrerasPedagogicas'
    ];
    
    textareas.forEach(id => {
        const textarea = document.getElementById(id);
        if (textarea) {
            // Agregar evento para mostrar contador de caracteres si se desea
            textarea.addEventListener('input', function() {
                // Opcional: mostrar contador de caracteres
                const count = this.value.length;
                // console.log(`${id}: ${count} caracteres`);
            });
        }
    });
}

// Plantillas de barreras por categoría SIMAT
const plantillasBarreras = {
    'discapacidad_intelectual': {
        actitudinales: `Situación observable:
- Algunos docentes y compañeros asumen que el estudiante "no puede aprender" o "no entiende", lo que genera subvaloración de sus capacidades.
- Se evidencia sobreprotección o, por el contrario, exclusión en actividades grupales.
- No siempre se promueven actitudes de respeto, empatía ni colaboración hacia él.

Impacto:
- Baja autoestima y desmotivación.
- Pérdida de confianza en sí mismo y dependencia excesiva del adulto.
- Disminución en la participación y socialización con el grupo.`,

        arquitectonicas: `Situación observable:
- Aula con ruido, desorden visual o disposición del mobiliario que impide moverse libremente.
- Falta de señalización o apoyos visuales en los espacios.
- Ambientes poco estructurados para favorecer la atención.

Impacto:
- Distracción constante, desregulación sensorial y desorientación.
- Dificultad para mantener la atención y organización personal.
- Pérdida de tiempo efectivo de aprendizaje.`,

        informacion: `Situación observable:
- Se usa lenguaje abstracto o técnico, sin verificar la comprensión.
- Las instrucciones son extensas y sin apoyo visual.
- No se utilizan pictogramas, lenguaje sencillo ni mediaciones gráficas o gestuales.

Impacto:
- El estudiante no entiende con claridad lo que debe hacer.
- Limita su expresión oral y escrita.
- Se reduce la interacción con docentes y compañeros.`,

        organizativas: `Situación observable:
- Un solo docente atiende simultáneamente a 40 estudiantes, entre ellos uno o más con discapacidad.
- No se dispone de tiempo suficiente para aplicar estrategias individualizadas ni realizar seguimiento personalizado.
- El docente debe dividir su atención, priorizando el control del grupo sobre el acompañamiento pedagógico.
- Falta de políticas institucionales claras de inclusión.
- Escasa articulación entre docentes, orientadores y profesionales de apoyo.
- PIAR desactualizado o desconocido por parte del equipo docente.
- No se planifican reuniones de seguimiento o acompañamiento.

Impacto:
- Descoordinación en las estrategias pedagógicas.
- Falta de coherencia en los apoyos ofrecidos.
- Menor efectividad en los procesos de inclusión.
- Recibe menor tiempo de interacción directa y orientación individual.
- Se dificulta la aplicación de apoyos y ajustes razonables en clase.
- Aumentan las posibilidades de desregulación emocional o desconexión del proceso.
- El progreso académico y social se ve afectado por falta de retroalimentación o acompañamiento cercano.`,

        metodologicas: `Situación observable:
- Se aplican métodos uniformes centrados en la exposición oral, sin adaptación a los ritmos ni estilos de aprendizaje del estudiante.
- Falta de uso de estrategias activas, experienciales y concretas.
- No se incluyen apoyos visuales, juegos, experimentos o actividades manipulativas.
- Las prácticas pedagógicas no contemplan la diversidad ni los ritmos individuales de aprendizaje.
- No se diseñan experiencias significativas, contextualizadas ni funcionales para la vida diaria.
- El docente no utiliza mediaciones pedagógicas variadas (juego, dramatización, proyectos, aprendizaje basado en retos).
- No se promueve el aprendizaje cooperativo ni la tutoría entre pares.

Impacto:
- Dificultad para comprender y retener información.
- Escasa participación y baja atención en clase.
- Frustración ante tareas repetitivas o abstractas.
- El estudiante se mantiene pasivo frente al aprendizaje.
- Baja comprensión y retención de conceptos.
- Desvinculación afectiva y cognitiva del proceso educativo.
- Dificultad para desarrollar habilidades adaptativas y funcionales.`,
        
        pedagogicas: `Situación observable:
- Las prácticas pedagógicas no contemplan la diversidad ni los ritmos individuales de aprendizaje.
- No se diseñan experiencias significativas, contextualizadas ni funcionales para la vida diaria.
- El docente no utiliza mediaciones pedagógicas variadas (juego, dramatización, proyectos, aprendizaje basado en retos).
- No se promueve el aprendizaje cooperativo ni la tutoría entre pares.

Impacto:
- El estudiante se mantiene pasivo frente al aprendizaje.
- Baja comprensión y retención de conceptos.
- Desvinculación afectiva y cognitiva del proceso educativo.
- Dificultad para desarrollar habilidades adaptativas y funcionales.`
    },
    
    'discapacidad_fisica': {
        actitudinales: `Situación observable:
- Algunos docentes y compañeros consideran que el estudiante es "frágil" o "incapaz" de participar en actividades.
- Se evidencia sobreprotección que limita su autonomía e independencia.
- Actitudes de lástima o pena en lugar de reconocimiento de sus capacidades.

Impacto:
- Limitación en el desarrollo de la autonomía personal.
- Baja autoestima y percepción negativa de sus capacidades.
- Exclusión de actividades por consideraciones erróneas sobre sus limitaciones.`,

        arquitectonicas: `Situación observable:
- Barreras físicas como escalones, pasillos estrechos, puertas pesadas o mobiliario inadecuado.
- Falta de rampas, barandas o espacios accesibles.
- Ubicación inadecuada de recursos y materiales didácticos.

Impacto:
- Imposibilidad de acceder a ciertos espacios o recursos.
- Dependencia de otros para movilizarse.
- Limitación en la participación de actividades académicas y recreativas.`,

        informacion: `Situación observable:
- Falta de formatos accesibles para información escrita (tamaño de letra, contraste).
- No se proporcionan ayudas técnicas para el acceso a la información.
- Ausencia de alternativas comunicativas adaptadas a sus necesidades.

Impacto:
- Dificultad para acceder a contenidos académicos.
- Limitación en la expresión y comunicación de ideas.
- Exclusión de procesos de evaluación no adaptados.`,

        organizativas: `Situación observable:
- Falta de coordinación entre docentes y profesionales de apoyo.
- No se contemplan tiempos adicionales para desplazamientos.
- Ausencia de protocolos de emergencia adaptados.
- Horarios rígidos que no consideran necesidades específicas.

Impacto:
- Fatiga excesiva por esfuerzos adicionales.
- Pérdida de tiempo académico por desplazamientos.
- Riesgo en situaciones de emergencia.`,

        metodologicas: `Situación observable:
- Metodologías que requieren habilidades motoras específicas sin alternativas.
- Falta de adaptaciones en materiales y recursos didácticos.
- No se utilizan tecnologías de apoyo disponibles.
- Evaluaciones que no consideran las limitaciones físicas.

Impacto:
- Impossibilidad de demostrar conocimientos adquiridos.
- Frustración ante tareas inadaptadas.
- Desventaja en procesos de evaluación.`,
        
        pedagogicas: `Situación observable:
- Planificación de clases que no considera la diversidad motriz del estudiante.
- Falta de actividades alternativas para participación sin esfuerzo físico excesivo.
- No se promueve la autonomía ni la autoeficacia del estudiante.
- Ausencia de trabajo colaborativo que fomente la inclusión.

Impacto:
- Participación limitada en experiencias de aprendizaje.
- Dificultad para construir sentido de pertenencia y competencia.
- Desvinculación del proceso educativo por falta de adecuación.`
    },

    'discapacidad_sensorial_auditiva': {
        actitudinales: `Situación observable:
- Se asume que el estudiante no puede participar en actividades orales o musicales.
- Falta de paciencia para esperar interpretación o comunicación alternativa.
- Actitudes de exclusión en conversaciones grupales.

Impacto:
- Aislamiento social y comunicativo.
- Baja participación en actividades académicas y sociales.
- Desarrollo limitado de habilidades comunicativas.`,

        arquitectonicas: `Situación observable:
- Espacios con mala acústica, ruido excesivo o reverberación.
- Falta de sistemas de amplificación sonora.
- Iluminación inadecuada que dificulta la lectura labial.

Impacto:
- Dificultad para percibir información auditiva.
- Fatiga por esfuerzo adicional en la comunicación.
- Limitación en la participación de actividades grupales.`,

        informacion: `Situación observable:
- Falta de interpretación en lengua de señas.
- Ausencia de subtítulos en materiales audiovisuales.
- No se utilizan recursos visuales como apoyo a la información oral.

Impacto:
- Pérdida de información académica importante.
- Exclusión de contenidos multimedia.
- Limitación en el acceso a explicaciones orales.`,

        organizativas: `Situación observable:
- No se cuenta con intérprete de lengua de señas.
- Falta de capacitación docente en comunicación alternativa.
- Ausencia de protocolos de comunicación adaptados.

Impacto:
- Barrera comunicativa constante.
- Dependencia de terceros para la comunicación.
- Limitación en la autonomía comunicativa.`,

        metodologicas: `Situación observable:
- Predominio de metodologías orales sin apoyo visual.
- Falta de estrategias pedagógicas visuales y táctiles.
- No se aprovechan las fortalezas visuales del estudiante.

Impacto:
- Dificultad para acceder a los contenidos académicos.
- Limitación en el desarrollo de competencias comunicativas.
- Desaprovechamiento del potencial de aprendizaje visual.`,
        
        pedagogicas: `Situación observable:
- Proceso de enseñanza basado únicamente en la oralidad sin considerar el canal visual.
- Falta de experiencias significativas que potencien la comunicación visual.
- Escaso uso de metodologías colaborativas adaptadas a la comunidad sorda.

Impacto:
- Desconexión entre la enseñanza y la forma de acceso al conocimiento del estudiante.
- Dificultad para consolidar aprendizajes duraderos.
- Baja participación y desmotivación escolar.`
    },

    'discapacidad_sensorial_visual': {
        actitudinales: `Situación observable:
- Se subestiman las capacidades del estudiante para realizar actividades académicas.
- Actitudes de sobreprotección que limitan la exploración y autonomía.
- Falta de confianza en las habilidades del estudiante.

Impacto:
- Limitación en el desarrollo de la independencia.
- Baja autoestima y autoconfianza.
- Restricción en las oportunidades de aprendizaje.`,

        arquitectonicas: `Situación observable:
- Obstáculos en los espacios de tránsito (mobiliario, objetos).
- Falta de señalización táctil o auditiva.
- Iluminación inadecuada para estudiantes con baja visión.

Impacto:
- Riesgo de accidentes y lesiones.
- Dificultad para la orientación y movilidad.
- Dependencia de otros para el desplazamiento.`,

        informacion: `Situación observable:
- Falta de materiales en braille o formatos accesibles.
- Ausencia de descripciones de imágenes y gráficos.
- No se utilizan tecnologías de apoyo como lectores de pantalla.

Impacto:
- Exclusión de contenidos visuales importantes.
- Limitación en el acceso a información escrita.
- Desventaja en procesos de evaluación.`,

        organizativas: `Situación observable:
- Falta de recursos técnicos y tecnológicos adaptados.
- Ausencia de capacitación docente en estrategias para discapacidad visual.
- No se contempla tiempo adicional para procesamiento de información.

Impacto:
- Limitación en el acceso a recursos académicos.
- Fatiga por esfuerzo adicional en el procesamiento.
- Desventaja competitiva frente a otros estudiantes.`,

        metodologicas: `Situación observable:
- Predominio de metodologías visuales sin alternativas táctiles o auditivas.
- Falta de adaptación de materiales didácticos.
- No se aprovechan los canales sensoriales disponibles.

Impacto:
- Dificultad para acceder a los contenidos curriculares.
- Limitación en el desarrollo de competencias académicas.
- Exclusión de actividades prácticas y experimentales.`,
        
        pedagogicas: `Situación observable:
- Falta de diversificación de estrategias didácticas con apoyos auditivos o táctiles.
- No se promueven actividades de exploración sensorial y desarrollo de autonomía.
- Explicaciones limitadas sin lenguaje descriptivo detallado.

Impacto:
- Aprendizaje superficial o memorístico.
- Limitada comprensión de conceptos visuales o espaciales.
- Escasa motivación y dependencia permanente del docente.`
    }
};

// Función para detectar y llenar automáticamente las barreras desde la API
async function llenarBarrerasAutomaticas(categoriaSeleccionada) {
    if (!categoriaSeleccionada) {
        return;
    }

    try {
        // Mapear nombres de categorías a IDs
        const categoriasMap = {
            'discapacidad_intelectual': 1,
            'discapacidad_auditiva': 2,
            'discapacidad_visual': 3,
            'discapacidad_fisica': 4
        };

        const idCategoria = categoriasMap[categoriaSeleccionada];
        if (!idCategoria) {
            console.warn('Categoría no encontrada:', categoriaSeleccionada);
            return;
        }

        // Realizar llamada a la API
        const response = await fetch(`/api/plantillas-barreras/categoria/${idCategoria}`);
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }

        const data = await response.json();
        if (!data.success || !data.data) {
            throw new Error('Formato de respuesta inválido');
        }

        const plantilla = data.data.barreras;
        
        // Mapear tipos de barreras a campos del formulario
        const camposMap = {
            'Actitudinales': 'barrerasActitudinales',
            'Arquitectónicas': 'barrerasArquitectonicas',
            'Información': 'barrerasInformacion',
            'Organizativas': 'barrerasOrganizativas',
            'Metodológicas': 'barrerasMetodologicas',
            'Pedagógicas': 'barrerasPedagogicas'
        };

        // Llenar cada campo de barrera
        Object.entries(camposMap).forEach(([tipoBarrera, campoId]) => {
            const campo = document.getElementById(campoId);
            if (campo && plantilla[tipoBarrera] && plantilla[tipoBarrera].length > 0) {
                // Concatenar todas las descripciones del tipo de barrera
                const contenido = plantilla[tipoBarrera]
                    .map(barrera => barrera.descripcion)
                    .join('\n\n');
                
                campo.value = contenido;
                
                // Agregar una pequeña animación visual para indicar que se llenó
                campo.style.backgroundColor = 'rgba(79, 134, 247, 0.1)';
                setTimeout(() => {
                    campo.style.backgroundColor = '';
                }, 2000);
            }
        });

        // Mostrar notificación al usuario
        mostrarNotificacionBarreras(data.data.categoria || categoriaSeleccionada);

    } catch (error) {
        console.error('Error al cargar plantillas de barreras:', error);
        
        // Mostrar notificación de error al usuario
        const notificacion = document.createElement('div');
        notificacion.className = 'notification-barriers error';
        notificacion.innerHTML = `
            <div class="notification-content">
                <i class="notification-icon">⚠️</i>
                <div class="notification-text">
                    <strong>Error</strong><br>
                    No se pudieron cargar las plantillas de barreras automáticamente.
                </div>
                <button class="notification-close">×</button>
            </div>
        `;
        
        document.body.appendChild(notificacion);
        
        // Auto-cerrar después de 5 segundos
        setTimeout(() => {
            if (notificacion.parentNode) {
                notificacion.remove();
            }
        }, 5000);
        
        // Evento para cerrar manualmente
        notificacion.querySelector('.notification-close').addEventListener('click', () => {
            notificacion.remove();
        });
    }
}

// Función para mostrar notificación
function mostrarNotificacionBarreras(categoria) {
    const nombreCategoria = categoria.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
    
    // Crear elemento de notificación
    const notificacion = document.createElement('div');
    notificacion.className = 'notification-barriers';
    notificacion.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-check-circle"></i>
            <div class="notification-text">
                <strong>¡Barreras cargadas automáticamente!</strong>
                <br>
                <small>Categoría: ${nombreCategoria}</small>
            </div>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    document.body.appendChild(notificacion);
    
    // Auto-remove después de 8 segundos
    setTimeout(() => {
        if (notificacion.parentElement) {
            notificacion.remove();
        }
    }, 8000);
    
    // Scroll suave hacia la sección de barreras
    setTimeout(() => {
        const seccionBarreras = document.querySelector('.barriers-analysis-section');
        if (seccionBarreras) {
            seccionBarreras.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'center' 
            });
        }
    }, 1000);
}

// Función auxiliar para mostrar indicador de carga con animación sorpresa
function mostrarIndicadorCarga() {
    // Crear el overlay con efecto de confeti
    const overlay = document.createElement('div');
    overlay.id = 'barreras-loading-overlay';
    overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        z-index: 10000;
        font-family: Arial, sans-serif;
    `;
    
    // Crear el contenedor principal
    const contenedor = document.createElement('div');
    contenedor.style.cssText = `
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 40px;
        border-radius: 20px;
        text-align: center;
        box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        max-width: 400px;
        position: relative;
        overflow: hidden;
    `;
    
    // Añadir el efecto de brillo
    const brillo = document.createElement('div');
    brillo.style.cssText = `
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.2) 50%, transparent 70%);
        animation: brillo 2s infinite;
    `;
    
    // Añadir estilos de animación
    const style = document.createElement('style');
    style.textContent = `
        @keyframes brillo {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .confeti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #ffd700;
            animation: confeti 3s infinite;
        }
        @keyframes confeti {
            0% { transform: translateY(-100vh) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
    
    // Spinner elegante
    const spinner = document.createElement('div');
    spinner.style.cssText = `
        width: 60px;
        height: 60px;
        border: 4px solid rgba(255,255,255,0.3);
        border-top: 4px solid white;
        border-radius: 50%;
        margin: 0 auto 20px;
        animation: rotate 1s linear infinite;
    `;
    
    // Texto
    const texto = document.createElement('h3');
    texto.textContent = '🎯 Cargando Barreras Mágicas...';
    texto.style.cssText = `
        color: white;
        margin: 0 0 10px 0;
        font-size: 24px;
        animation: pulse 2s infinite;
    `;
    
    const subtexto = document.createElement('p');
    subtexto.textContent = 'Analizando la categoría SIMAT seleccionada';
    subtexto.style.cssText = `
        color: rgba(255,255,255,0.8);
        margin: 0;
        font-size: 16px;
    `;
    
    // Añadir confeti
    for (let i = 0; i < 20; i++) {
        const confeti = document.createElement('div');
        confeti.className = 'confeti';
        confeti.style.left = Math.random() * 100 + '%';
        confeti.style.animationDelay = Math.random() * 3 + 's';
        confeti.style.backgroundColor = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7'][Math.floor(Math.random() * 5)];
        overlay.appendChild(confeti);
    }
    
    contenedor.appendChild(brillo);
    contenedor.appendChild(spinner);
    contenedor.appendChild(texto);
    contenedor.appendChild(subtexto);
    overlay.appendChild(contenedor);
    document.body.appendChild(overlay);
    
    return overlay;
}

// Función auxiliar para ocultar indicador de carga
function ocultarIndicadorCarga() {
    const overlay = document.getElementById('barreras-loading-overlay');
    if (overlay) {
        overlay.style.animation = 'fadeOut 0.5s ease-out';
        setTimeout(() => {
            overlay.remove();
        }, 500);
    }
}

// Función para cargar barreras desde el backend
async function cargarBarrerasDesdeBackend(categoriaId) {
    try {
        const response = await fetch(`http://localhost:3000/api/barreras/categoria/${categoriaId}`);
        
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        
        const data = await response.json();
        
        if (!data.success) {
            throw new Error(data.message || 'Error al obtener barreras');
        }
        
        return data.data;
    } catch (error) {
        console.error('Error al cargar barreras desde backend:', error);
        throw error;
    }
}

// Función para llenar barreras desde datos del backend
function llenarBarrerasDesdeBackend(barrerasData) {
    console.log('🎯 Llenando barreras desde backend:', barrerasData);
    
    // Mapear los campos del backend a los campos del formulario
    const mapeoIdsFormulario = {
        'actitudinales': 'barrerasActitudinales',
        'arquitectonicas': 'barrerasArquitectonicas',
        'de_acceso_a_informacion_y_comunicaciones': 'barrerasInformacion',
        'organizativas': 'barrerasOrganizativas',
        'metodologicas': 'barrerasMetodologicas',
        'pedagogicas': 'barrerasPedagogicas'
    };
    
    // Llenar cada campo con los datos correspondientes
    Object.entries(mapeoIdsFormulario).forEach(([tipoBackend, idFormulario]) => {
        const elemento = document.getElementById(idFormulario);
        const barreraData = barrerasData.barreras[tipoBackend];
        
        if (elemento && barreraData) {
            const contenido = `SITUACIÓN OBSERVABLE:
${barreraData.situacion_observable}

IMPACTO:
${barreraData.impacto}

AJUSTES Y ESTRATEGIAS:
${barreraData.ajustes_estrategias}`;
            
            elemento.value = contenido;
            
            // Efecto visual de llenado
            elemento.style.background = 'linear-gradient(90deg, #e8f5e8, transparent)';
            elemento.style.transition = 'background 2s ease-out';
            
            setTimeout(() => {
                elemento.style.background = '';
            }, 2000);
        }
    });
}

// Función para mostrar notificación de éxito
function mostrarNotificacionExito(categoriaData) {
    const notificacion = document.createElement('div');
    notificacion.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #4CAF50, #45a049);
        color: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(76, 175, 80, 0.3);
        z-index: 10001;
        max-width: 350px;
        font-family: Arial, sans-serif;
        animation: slideInRight 0.5s ease-out;
    `;
    
    // Añadir animación CSS
    if (!document.getElementById('notification-styles')) {
        const style = document.createElement('style');
        style.id = 'notification-styles';
        style.textContent = `
            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutRight {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }
    
    notificacion.innerHTML = `
        <div style="display: flex; align-items: center; margin-bottom: 10px;">
            <span style="font-size: 24px; margin-right: 10px;">🎉</span>
            <strong style="font-size: 18px;">¡Barreras Cargadas Exitosamente!</strong>
        </div>
        <p style="margin: 5px 0; font-size: 14px;">
            📋 Categoría: <strong>${categoriaData.categoria_nombre}</strong>
        </p>
        <p style="margin: 5px 0; font-size: 14px;">
            🔢 Total de barreras: <strong>${categoriaData.total_barreras}</strong>
        </p>
        <p style="margin: 10px 0 0 0; font-size: 12px; opacity: 0.9;">
            Los campos de análisis de barreras en el Anexo 2 han sido actualizados automáticamente.
        </p>
    `;
    
    document.body.appendChild(notificacion);
    
    // Auto-eliminar después de 5 segundos
    setTimeout(() => {
        notificacion.style.animation = 'slideOutRight 0.5s ease-out';
        setTimeout(() => {
            notificacion.remove();
        }, 500);
    }, 5000);
    
    // Permitir cerrar haciendo clic
    notificacion.addEventListener('click', () => {
        notificacion.style.animation = 'slideOutRight 0.5s ease-out';
        setTimeout(() => {
            notificacion.remove();
        }, 500);
    });
}

// Función para inicializar el sistema de barreras automáticas
function inicializarBarrerasAutomaticas() {
    // Buscar el select de diagnóstico SIMAT en el Anexo 1
    const diagnosticoSelect = document.getElementById('diagnostico');
    
    if (diagnosticoSelect) {
        diagnosticoSelect.addEventListener('change', async function() {
            const categoriaId = this.value;
            const textoSeleccionado = this.options[this.selectedIndex].text;
            
            if (categoriaId && categoriaId !== '') {
                // Mostrar indicador de carga con animación sorpresa
                const indicadorCarga = mostrarIndicadorCarga();
                
                try {
                    // Cargar barreras desde el backend
                    const barrerasData = await cargarBarrerasDesdeBackend(categoriaId);
                    
                    // Simular un pequeño delay para mostrar la animación
                    await new Promise(resolve => setTimeout(resolve, 2000));
                    
                    // Ocultar indicador de carga
                    ocultarIndicadorCarga();
                    
                    // Llenar los campos con las barreras obtenidas
                    llenarBarrerasDesdeBackend(barrerasData);
                    
                    // Mostrar notificación de éxito
                    mostrarNotificacionExito(barrerasData);
                    
                    console.log('✅ Barreras cargadas exitosamente:', barrerasData);
                    
                } catch (error) {
                    // Ocultar indicador de carga en caso de error
                    ocultarIndicadorCarga();
                    
                    console.error('❌ Error al cargar barreras:', error);
                    
                    // Mostrar notificación de error
                    alert(`❌ Error al cargar las barreras para "${textoSeleccionado}".\n\n` +
                          `Por favor, verifica que el servidor esté funcionando y que existan barreras ` +
                          `definidas para esta categoría SIMAT.\n\n` +
                          `Error técnico: ${error.message}`);
                }
            }
        });
        
        console.log('✅ Sistema de barreras automáticas inicializado correctamente');
    } else {
        console.warn('⚠️ No se encontró el select de diagnóstico SIMAT');
        
        // Intentar nuevamente después de un momento (por si el DOM no está completamente cargado)
        setTimeout(() => {
            const diagnosticoSelectRetry = document.getElementById('diagnostico');
            if (diagnosticoSelectRetry) {
                diagnosticoSelectRetry.addEventListener('change', async function() {
                    const categoriaId = this.value;
                    const textoSeleccionado = this.options[this.selectedIndex].text;
                    
                    if (categoriaId && categoriaId !== '') {
                        // Mostrar indicador de carga con animación sorpresa
                        const indicadorCarga = mostrarIndicadorCarga();
                        
                        try {
                            // Cargar barreras desde el backend
                            const barrerasData = await cargarBarrerasDesdeBackend(categoriaId);
                            
                            // Simular un pequeño delay para mostrar la animación
                            await new Promise(resolve => setTimeout(resolve, 2000));
                            
                            // Ocultar indicador de carga
                            ocultarIndicadorCarga();
                            
                            // Llenar los campos con las barreras obtenidas
                            llenarBarrerasDesdeBackend(barrerasData);
                            
                            // Mostrar notificación de éxito
                            mostrarNotificacionExito(barrerasData);
                            
                            console.log('✅ Barreras cargadas exitosamente (segundo intento):', barrerasData);
                            
                        } catch (error) {
                            // Ocultar indicador de carga en caso de error
                            ocultarIndicadorCarga();
                            
                            console.error('❌ Error al cargar barreras (segundo intento):', error);
                            
                            // Mostrar notificación de error
                            alert(`❌ Error al cargar las barreras para "${textoSeleccionado}".\n\n` +
                                  `Por favor, verifica que el servidor esté funcionando y que existan barreras ` +
                                  `definidas para esta categoría SIMAT.\n\n` +
                                  `Error técnico: ${error.message}`);
                        }
                    }
                });
                console.log('✅ Sistema de barreras automáticas inicializado (segundo intento)');
            }
        }, 3000);
    }
}

// Inicializar el módulo cuando se carga la página
document.addEventListener('DOMContentLoaded', function() {
    // Esperar un poco para asegurar que todo el DOM esté listo
    setTimeout(() => {
        GeminiAnalysis.inicializar();
        
        // Inicializar los selects de asignaturas
        inicializarSelectsAsignaturas().catch(error => {
            console.error('Error al inicializar selects de asignaturas:', error);
        });
        
        // Inicializar contadores de barreras
        inicializarContadoresBarreras();
        
        // Inicializar sistema de barreras automáticas
        inicializarBarrerasAutomaticas();
        
        // Verificar configuración en desarrollo
        if (window.location.hostname === 'localhost') {
            GeminiAnalysis.verificarConfiguracion().then(estado => {
                if (!estado.configured) {
                    console.warn('⚠️ Gemini AI no está configurado correctamente:', estado.error);
                } else {
                    console.log('✅ Gemini AI configurado correctamente');
                }
            });
        }
    }, 1000);
});

// =============================================
// FUNCIONES PARA MANEJO DE FIRMAS
// =============================================

let generalSignatureCounter = 1;
let teacherSignatureCounter = 1;

// Función para agregar participante general
function addGeneralSignature() {
    generalSignatureCounter++;
    const container = document.getElementById('generalSignaturesContainer');
    
    const signatureRow = document.createElement('div');
    signatureRow.className = 'signature-row';
    signatureRow.id = `generalSignature${generalSignatureCounter}`;
    
    signatureRow.innerHTML = `
        <div class="form-row">
            <div class="form-group">
                <label for="nombreParticipante${generalSignatureCounter}">Nombre:</label>
                <input type="text" id="nombreParticipante${generalSignatureCounter}" 
                       name="nombreParticipante${generalSignatureCounter}" 
                       class="form-control" placeholder="Ingrese el nombre completo">
            </div>
            <div class="form-group">
                <label for="cargoParticipante${generalSignatureCounter}">Cargo:</label>
                <input type="text" id="cargoParticipante${generalSignatureCounter}" 
                       name="cargoParticipante${generalSignatureCounter}" 
                       class="form-control" placeholder="Ingrese el cargo">
            </div>
        </div>
        <button type="button" class="btn-remove-signature" onclick="removeGeneralSignature(${generalSignatureCounter})">
            <i class="fas fa-trash"></i> Eliminar
        </button>
    `;
    
    container.appendChild(signatureRow);
}

// Función para eliminar participante general
function removeGeneralSignature(id) {
    const signatureRow = document.getElementById(`generalSignature${id}`);
    if (signatureRow && generalSignatureCounter > 1) {
        signatureRow.remove();
    }
}

// Función para agregar docente
function addTeacherSignature() {
    teacherSignatureCounter++;
    const container = document.getElementById('teacherSignaturesContainer');
    
    const signatureRow = document.createElement('div');
    signatureRow.className = 'teacher-signature-row';
    signatureRow.id = `teacherSignature${teacherSignatureCounter}`;
    
    signatureRow.innerHTML = `
        <div class="form-row">
            <div class="form-group">
                <label for="nombreDocente${teacherSignatureCounter}">Nombre:</label>
                <input type="text" id="nombreDocente${teacherSignatureCounter}" 
                       name="nombreDocente${teacherSignatureCounter}" 
                       class="form-control" placeholder="Ingrese el nombre del docente">
            </div>
            <div class="form-group">
                <label for="asignaturaDocente${teacherSignatureCounter}">Asignatura:</label>
                <input type="text" id="asignaturaDocente${teacherSignatureCounter}" 
                       name="asignaturaDocente${teacherSignatureCounter}" 
                       class="form-control" placeholder="Ingrese la asignatura">
            </div>
        </div>
        <button type="button" class="btn-remove-signature" onclick="removeTeacherSignature(${teacherSignatureCounter})">
            <i class="fas fa-trash"></i> Eliminar
        </button>
    `;
    
    container.appendChild(signatureRow);
}

// Función para eliminar docente
function removeTeacherSignature(id) {
    const signatureRow = document.getElementById(`teacherSignature${id}`);
    if (signatureRow && teacherSignatureCounter > 1) {
        signatureRow.remove();
    }
}

// Función para limpiar todas las firmas (usar en limpiarAnexo2)
function clearAllSignatures() {
    // Limpiar participantes generales
    const generalContainer = document.getElementById('generalSignaturesContainer');
    if (generalContainer) {
        generalContainer.innerHTML = `
            <div class="signature-row" id="generalSignature1">
                <div class="form-row">
                    <div class="form-group">
                        <label for="nombreParticipante1">Nombre:</label>
                        <input type="text" id="nombreParticipante1" name="nombreParticipante1" 
                               class="form-control" placeholder="Ingrese el nombre completo">
                    </div>
                    <div class="form-group">
                        <label for="cargoParticipante1">Cargo:</label>
                        <input type="text" id="cargoParticipante1" name="cargoParticipante1" 
                               class="form-control" placeholder="Ingrese el cargo">
                    </div>
                </div>
            </div>
        `;
    }
    
    // Limpiar docentes
    const teacherContainer = document.getElementById('teacherSignaturesContainer');
    if (teacherContainer) {
        teacherContainer.innerHTML = `
            <div class="teacher-signature-row" id="teacherSignature1">
                <div class="form-row">
                    <div class="form-group">
                        <label for="nombreDocente1">Nombre:</label>
                        <input type="text" id="nombreDocente1" name="nombreDocente1" 
                               class="form-control" placeholder="Ingrese el nombre del docente">
                    </div>
                    <div class="form-group">
                        <label for="asignaturaDocente1">Asignatura:</label>
                        <input type="text" id="asignaturaDocente1" name="asignaturaDocente1" 
                               class="form-control" placeholder="Ingrese la asignatura">
                    </div>
                </div>
            </div>
        `;
    }
    
    // Resetear contadores
    generalSignatureCounter = 1;
    teacherSignatureCounter = 1;
}
