// Patrón Module para la gestión de paramétricas
const GestionParametricas = (function() {
    
    // Variables privadas
    let userData = null;
    let currentEditingId = null;
    let currentEditingCategoria = null;
  // ============================================================================
// GESTIÓN DE PARÁMETROS GENÉRICOS
// ============================================================================

/**
 * Cargar todos los parámetros desde las diferentes APIs
 */
async function loadParametros() {
    try {
        const tableBody = document.getElementById('parametros-table-body');
        if (!tableBody) return;
        
        // Mostrar loading
        tableBody.innerHTML = `
            <tr>
                <td colspan="6" class="loading-row">
                    <i class="fas fa-spinner fa-spin"></i> Cargando parámetros...
                </td>
            </tr>
        `;
        
        // Cargar datos de diferentes endpoints
        const endpoints = [
            { name: 'tipos-documento', url: '/api/tipos-documento' },
            // Aquí se agregarán más endpoints según se implementen:
            // { name: 'generos', url: '/api/generos' },
            // { name: 'eps', url: '/api/eps' },
            // { name: 'barrios', url: '/api/barrios' },
        ];
        
        let allParametros = [];
        
        for (const endpoint of endpoints) {
            try {
                const response = await fetch(endpoint.url);
                if (response.ok) {
                    const result = await response.json();
                    if (result.success && result.data) {
                        // Transformar datos para formato unificado
                        const parametrosTransformados = result.data.map(item => ({
                            ...item,
                            categoria: endpoint.name,
                            tipo_display: getTipoDisplayName(endpoint.name)
                        }));
                        allParametros = allParametros.concat(parametrosTransformados);
                    }
                }
            } catch (error) {
                console.warn(`Error al cargar ${endpoint.name}:`, error);
            }
        }
        
        // Guardar datos globalmente
        window.todosLosParametros = allParametros;
        renderParametrosTable();
        
        GestionParametricas.showNotification(
            `${allParametros.length} parámetros cargados exitosamente`, 
            'success'
        );
        
    } catch (error) {
        console.error('Error al cargar parámetros:', error);
        
        const tableBody = document.getElementById('parametros-table-body');
        if (tableBody) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" style="text-align: center; color: var(--error-color); padding: 30px;">
                        <i class="fas fa-exclamation-triangle"></i> Error al cargar datos: ${error.message}
                        <br><button class="btn btn-secondary" onclick="loadParametros()" style="margin-top: 10px;">
                            <i class="fas fa-retry"></i> Reintentar
                        </button>
                    </td>
                </tr>
            `;
        }
        
        GestionParametricas.showNotification(
            `Error al cargar parámetros: ${error.message}`, 
            'error'
        );
    }
}

/**
 * Obtener nombre display del tipo de parámetro
 */
function getTipoDisplayName(tipo) {
    const tipos = {
        'tipos-documento': 'Tipos de Documento',
        'generos': 'Géneros',
        'eps': 'EPS',
        'barrios': 'Barrios',
        'departamentos': 'Departamentos',
        'municipios': 'Municipios'
    };
    return tipos[tipo] || tipo;
}

/**
 * Renderizar la tabla de parámetros
 */
function renderParametrosTable() {
    const tableBody = document.getElementById('parametros-table-body');
    if (!tableBody) return;
    
    const parametros = window.todosLosParametros || [];
    
    if (parametros.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align: center; color: var(--text-secondary); padding: 30px; font-style: italic;">
                    <i class="fas fa-inbox"></i> No hay parámetros registrados
                </td>
            </tr>
        `;
        return;
    }
    
    tableBody.innerHTML = parametros.map(parametro => {
        const fechaCreacion = parametro.created_at 
            ? new Date(parametro.created_at).toLocaleDateString('es-CO')
            : 'N/A';
        
        const fechaModificacion = parametro.updated_at 
            ? new Date(parametro.updated_at).toLocaleDateString('es-CO')
            : 'N/A';
            
        const estadoBadge = parametro.activo 
            ? '<span class="status-badge active">ACTIVO</span>'
            : '<span class="status-badge inactive">INACTIVO</span>';
            
        // Crear descripción completa con categoría
        const descripcionCompleta = `[${parametro.tipo_display}] ${parametro.descripcion}`;
            
        return `
            <tr>
                <td><strong>${parametro.codigo}</strong></td>
                <td>${descripcionCompleta}</td>
                <td>${estadoBadge}</td>
                <td>${fechaCreacion}</td>
                <td>${fechaModificacion}</td>
                <td>
                    <button class="btn-icon" onclick="editParametro('${parametro.id}', '${parametro.categoria}')" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-icon" onclick="deleteParametro('${parametro.id}', '${parametro.codigo}', '${parametro.categoria}')" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

/**
 * Abrir modal para crear/editar parámetro
 */
function openParametroModal(parametroId = null, categoria = null) {
    const modal = document.getElementById('parametroModal');
    const title = document.getElementById('parametroModalTitle');
    const form = document.getElementById('parametroForm');
    
    if (!modal || !title || !form) return;
    
    // Limpiar formulario
    form.reset();
    currentEditingId = parametroId;
    currentEditingCategoria = categoria;
    
    if (parametroId && categoria) {
        // Modo edición
        title.textContent = 'Editar Parámetro';
        const parametros = window.todosLosParametros || [];
        const parametro = parametros.find(p => p.id === parametroId && p.categoria === categoria);
        
        if (parametro) {
            document.getElementById('parametroId').value = parametro.id;
            document.getElementById('parametroCategoria').value = parametro.categoria;
            document.getElementById('parametroTipo').value = parametro.categoria;
            document.getElementById('parametroCodigo').value = parametro.codigo;
            document.getElementById('parametroDescripcion').value = parametro.descripcion;
            document.getElementById('parametroActivo').value = parametro.activo ? '1' : '0';
            
            // Deshabilitar cambio de tipo en edición
            document.getElementById('parametroTipo').disabled = true;
        }
    } else {
        // Modo creación
        title.textContent = 'Agregar Parámetro';
        document.getElementById('parametroActivo').value = '1'; // Activo por defecto
        document.getElementById('parametroTipo').disabled = false;
    }
    
    modal.style.display = 'flex';
    
    // Focus en el primer campo
    setTimeout(() => {
        if (parametroId) {
            document.getElementById('parametroCodigo').focus();
        } else {
            document.getElementById('parametroTipo').focus();
        }
    }, 100);
}

/**
 * Cerrar modal de parámetro
 */
function closeParametroModal() {
    const modal = document.getElementById('parametroModal');
    if (modal) {
        modal.style.display = 'none';
        currentEditingId = null;
        currentEditingCategoria = null;
        // Rehabilitar select de tipo
        document.getElementById('parametroTipo').disabled = false;
    }
}

/**
 * Manejar envío del formulario de parámetro
 */
async function handleParametroFormSubmit(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    const parametro = {
        codigo: formData.get('codigo').trim().toUpperCase(),
        descripcion: formData.get('descripcion').trim(),
        activo: formData.get('activo') === '1'
    };
    
    const categoria = formData.get('tipo') || currentEditingCategoria;
    
    // Validaciones básicas
    if (!categoria) {
        GestionParametricas.showNotification('Debe seleccionar un tipo de parámetro', 'error');
        return;
    }
    
    if (!parametro.codigo || !parametro.descripcion) {
        GestionParametricas.showNotification('Todos los campos son obligatorios', 'error');
        return;
    }
    
    if (parametro.codigo.length > 10) {
        GestionParametricas.showNotification('El código no puede exceder 10 caracteres', 'error');
        return;
    }
    
    if (parametro.descripcion.length > 100) {
        GestionParametricas.showNotification('La descripción no puede exceder 100 caracteres', 'error');
        return;
    }
    
    try {
        const endpoint = getEndpointForCategoria(categoria);
        const method = currentEditingId ? 'PUT' : 'POST';
        const url = currentEditingId 
            ? `/api/${endpoint}/${currentEditingId}` 
            : `/api/${endpoint}`;
        
        const response = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(parametro)
        });
        
        const result = await response.json();
        
        if (result.success) {
            const action = currentEditingId ? 'actualizado' : 'creado';
            const tipoNombre = getTipoDisplayName(categoria);
            GestionParametricas.showNotification(
                `${tipoNombre} ${action} exitosamente`, 
                'success'
            );
            
            closeParametroModal();
            loadParametros(); // Recargar la tabla
        } else {
            throw new Error(result.message || `Error al ${currentEditingId ? 'actualizar' : 'crear'} parámetro`);
        }
        
    } catch (error) {
        console.error('Error en handleParametroFormSubmit:', error);
        GestionParametricas.showNotification(
            `Error: ${error.message}`, 
            'error'
        );
    }
}

/**
 * Editar parámetro
 */
function editParametro(parametroId, categoria) {
    openParametroModal(parametroId, categoria);
}

/**
 * Eliminar tipo de documento
 */
function deleteTipoDocumento(tipoId, tipoCodigo) {
    const modal = document.getElementById('deleteTipoDocumentoModal');
    const nombreElement = document.getElementById('deleteDocumentoNombre');
    
    if (!modal || !nombreElement) return;
    
    nombreElement.textContent = tipoCodigo;
    modal.style.display = 'flex';
    
    // Guardar ID para confirmación
    modal.dataset.tipoId = tipoId;
    modal.dataset.tipoCodigo = tipoCodigo;
}





/**
 * Refrescar parámetros
 */
function refreshParametros() {
    GestionParametricas.showNotification('Actualizando parámetros...', 'info');
    loadParametros();
}

/**
 * Manejar cambio de tipo de parámetro en el modal
 */
function handleParametroTipoChange() {
    const tipoSelect = document.getElementById('parametroTipo');
    const codigoInput = document.getElementById('parametroCodigo');
    const descripcionInput = document.getElementById('parametroDescripcion');
    
    if (tipoSelect.value) {
        // Limpiar campos cuando cambia el tipo
        codigoInput.value = '';
        descripcionInput.value = '';
        
        // Actualizar placeholder según el tipo
        const placeholders = {
            'tipos_documento': { codigo: 'CC, TI, RC', descripcion: 'Cédula de Ciudadanía' },
            'generos': { codigo: 'M, F', descripcion: 'Masculino, Femenino' },
            'eps': { codigo: 'SURA', descripcion: 'EPS SURA' },
            'barrios': { codigo: 'CASCO', descripcion: 'Casco Urbano' },
            'departamentos': { codigo: '68', descripcion: 'Santander' },
            'municipios': { codigo: '68001', descripcion: 'Bucaramanga' }
        };
        
        const placeholder = placeholders[tipoSelect.value];
        if (placeholder) {
            codigoInput.placeholder = placeholder.codigo;
            descripcionInput.placeholder = placeholder.descripcion;
        }
    }
}

/**
 * Eliminar parámetro
 */
function deleteParametro(parametroId, parametroCodigo, categoria) {
    const modal = document.getElementById('deleteParametroModal');
    const nombreElement = document.getElementById('deleteParametroNombre');
    
    if (!modal || !nombreElement) return;
    
    nombreElement.textContent = parametroCodigo;
    modal.style.display = 'flex';
    
    // Guardar datos para confirmación
    modal.dataset.parametroId = parametroId;
    modal.dataset.parametroCodigo = parametroCodigo;
    modal.dataset.parametroCategoria = categoria;
}

/**
 * Cerrar modal de confirmación de eliminación
 */
function closeDeleteParametroModal() {
    const modal = document.getElementById('deleteParametroModal');
    if (modal) {
        modal.style.display = 'none';
        delete modal.dataset.parametroId;
        delete modal.dataset.parametroCodigo;
        delete modal.dataset.parametroCategoria;
    }
}

/**
 * Confirmar eliminación de parámetro
 */
async function confirmDeleteParametro() {
    const modal = document.getElementById('deleteParametroModal');
    if (!modal) return;
    
    const parametroId = modal.dataset.parametroId;
    const parametroCodigo = modal.dataset.parametroCodigo;
    const categoria = modal.dataset.parametroCategoria;
    
    if (!parametroId || !categoria) return;
    
    try {
        // Determinar el endpoint según la categoría
        const endpoint = getEndpointForCategoria(categoria);
        const response = await fetch(`/api/${endpoint}/${parametroId}`, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            GestionParametricas.showNotification(
                `Parámetro "${parametroCodigo}" eliminado exitosamente`, 
                'success'
            );
            
            closeDeleteParametroModal();
            loadParametros(); // Recargar la tabla
        } else {
            throw new Error(result.message || 'Error al eliminar parámetro');
        }
        
    } catch (error) {
        console.error('Error al eliminar parámetro:', error);
        GestionParametricas.showNotification(
            `Error al eliminar: ${error.message}`, 
            'error'
        );
    }
}

/**
 * Obtener endpoint según la categoría
 */
function getEndpointForCategoria(categoria) {
    const endpoints = {
        'tipos_documento': 'tipos-documento',
        'generos': 'generos',
        'eps': 'eps',
        'barrios': 'barrios',
        'departamentos': 'departamentos',
        'municipios': 'municipios'
    };
    return endpoints[categoria] || categoria;
}

// ============================================================================
// FUNCIONES GLOBALES PARA COMPATIBILIDAD (mantener las existentes)
// ============================================================================

function editParameter(paramId) {
    GestionParametricas.showNotification(`Editando parámetro: ${paramId}`, 'info');
    // Implementar edición de parámetro
}

function deleteParameter(paramId) {
    if (confirm(`¿Está seguro de eliminar el parámetro ${paramId}?`)) {
        GestionParametricas.showNotification(`Parámetro ${paramId} eliminado`, 'success');
        // Implementar eliminación
    }
}

// ============================================================================
// ELEMENTOS DEL DOM
// ============================================================================
const sidebar = document.getElementById('sidebar');
const toggleSidebarBtn = document.getElementById('toggleSidebar');
const sidebarOverlay = document.getElementById('sidebarOverlay');
const content = document.getElementById('content');
    
    // Elementos de pestañas
    const tabButtons = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    // Funciones privadas
    function initializeEventListeners() {
        // Toggle sidebar en móviles
        if (toggleSidebarBtn) {
            toggleSidebarBtn.addEventListener('click', toggleSidebar);
        }
        
        // Cerrar sidebar al hacer click en overlay
        if (sidebarOverlay) {
            sidebarOverlay.addEventListener('click', closeSidebar);
        }
        
        // Responsive - cerrar sidebar al redimensionar
        window.addEventListener('resize', handleResize);
        
        // Configurar navegación por pestañas
        setupTabNavigation();
        
        // Los datos del usuario son manejados por dashboard.js
        
        console.log('Gestión de Paramétricas inicializada correctamente');
    }
    
    function toggleSidebar() {
        if (sidebar) {
            sidebar.classList.toggle('active');
            sidebarOverlay.classList.toggle('active');
            document.body.classList.toggle('sidebar-open');
        }
    }
    
    function closeSidebar() {
        if (sidebar) {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
            document.body.classList.remove('sidebar-open');
        }
    }
    
    function handleResize() {
        if (window.innerWidth > 768) {
            closeSidebar();
        }
    }
    
    function setupTabNavigation() {
        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const targetTab = this.getAttribute('data-tab');
                switchTab(targetTab);
            });
        });
    }
    
    function switchTab(tabName) {
        // Remover clase active de todos los botones y contenidos
        tabButtons.forEach(btn => btn.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));
        
        // Activar el botón y contenido seleccionado
        const activeButton = document.querySelector(`[data-tab="${tabName}"]`);
        const activeContent = document.getElementById(`${tabName}-tab`);
        
        if (activeButton && activeContent) {
            activeButton.classList.add('active');
            activeContent.classList.add('active');
            
            // Cargar datos específicos según la pestaña
            if (tabName === 'parametros') {
                loadParametros();
            }
        }
    }
    
    // Las funciones de carga de usuario han sido eliminadas
    // Dashboard.js ahora maneja toda la información del usuario
    
    function showNotification(message, type = 'info') {
        // Función para mostrar notificaciones al usuario
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        // Auto-ocultar después de 3 segundos
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 3000);
    }
    
    function validateForm(formData) {
        // Función para validar formularios de paramétricas
        const errors = [];
        
        // Validaciones específicas según sea necesario
        if (!formData.nombre || formData.nombre.trim() === '') {
            errors.push('El nombre es requerido');
        }
        
        return errors;
    }
    
    function sanitizeInput(input) {
        // Función para sanitizar entradas del usuario
        return input.replace(/[<>]/g, '');
    }
    
    // Funciones para manejo de datos (preparadas para futuras implementaciones)
    function loadParametricas() {
        // Cargar datos de paramétricas desde el servidor
        console.log('Cargando datos de paramétricas...');
        // Implementar llamada API aquí
    }
    
    function saveParametrica(data) {
        // Guardar datos de paramétrica
        console.log('Guardando paramétrica:', data);
        // Implementar llamada API aquí
        showNotification('Paramétrica guardada correctamente', 'success');
    }
    
    function deleteParametrica(id) {
        // Eliminar paramétrica
        console.log('Eliminando paramétrica:', id);
        // Implementar llamada API aquí
        showNotification('Paramétrica eliminada correctamente', 'success');
    }
    
    // API pública del módulo
    return {
        init: initializeEventListeners,
        loadParametricas: loadParametricas,
        saveParametrica: saveParametrica,
        deleteParametrica: deleteParametrica,
        showNotification: showNotification,
        validateForm: validateForm,
        sanitizeInput: sanitizeInput,
        switchTab: switchTab
    };
    
})();

// La función logout ahora es manejada por dashboard.js con el modal personalizado

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    GestionParametricas.init();
});

// Manejar errores globales
window.addEventListener('error', function(e) {
    console.error('Error en Gestión de Paramétricas:', e);
    GestionParametricas.showNotification('Ha ocurrido un error inesperado', 'error');
});

// Exportar para uso global si es necesario
window.GestionParametricas = GestionParametricas;

// Funciones globales para botones de acción
// === FUNCIONES PARA USUARIOS ===
function openUserModal() {
    GestionParametricas.showNotification('Abriendo modal de usuario...', 'info');
    // Implementar modal de usuario
}

function editUser(userId) {
    GestionParametricas.showNotification(`Editando usuario: ${userId}`, 'info');
    // Implementar edición de usuario
}

function deleteUser(userId) {
    if (confirm(`¿Está seguro de eliminar el usuario ${userId}?`)) {
        GestionParametricas.showNotification(`Usuario ${userId} eliminado`, 'success');
        // Implementar eliminación de usuario
    }
}

function refreshUsers() {
    GestionParametricas.showNotification('Actualizando usuarios...', 'info');
    // Implementar refresh de usuarios
}

function exportUsers() {
    GestionParametricas.showNotification('Exportando usuarios...', 'info');
    // Implementar exportación de usuarios
}

// === FUNCIONES PARA PERFILES ===
function openProfileModal() {
    GestionParametricas.showNotification('Abriendo modal de perfil...', 'info');
    // Implementar modal de perfil
}

function editProfile(profileId) {
    GestionParametricas.showNotification(`Editando perfil: ${profileId}`, 'info');
    // Implementar edición de perfil
}

function deleteProfile(profileId) {
    if (confirm(`¿Está seguro de eliminar el perfil ${profileId}?`)) {
        GestionParametricas.showNotification(`Perfil ${profileId} eliminado`, 'success');
        // Implementar eliminación de perfil
    }
}

function refreshProfiles() {
    GestionParametricas.showNotification('Actualizando perfiles...', 'info');
    // Implementar refresh de perfiles
}

// === FUNCIONES PARA CONTROL DE ACCESO ===
function savePermissions() {
    const selectedProfile = document.getElementById('profile-selector').value;
    if (!selectedProfile) {
        GestionParametricas.showNotification('Seleccione un perfil primero', 'error');
        return;
    }
    
    const permissions = [];
    document.querySelectorAll('input[name="permission"]:checked').forEach(checkbox => {
        permissions.push(checkbox.value);
    });
    
    GestionParametricas.showNotification(`Permisos guardados para perfil ${selectedProfile}`, 'success');
    // Implementar guardado de permisos
}

// === FUNCIONES PARA PARÁMETROS ===
function openParameterModal() {
    GestionParametricas.showNotification('Abriendo modal de parámetro...', 'info');
    // Implementar modal de parámetro
}

function editParameter(paramId) {
    GestionParametricas.showNotification(`Editando parámetro: ${paramId}`, 'info');
    // Implementar edición de parámetro
}

function deleteParameter(paramId) {
    if (confirm(`¿Está seguro de eliminar el parámetro ${paramId}?`)) {
        GestionParametricas.showNotification(`Parámetro ${paramId} eliminado`, 'success');
        // Implementar eliminación de parámetro
    }
}