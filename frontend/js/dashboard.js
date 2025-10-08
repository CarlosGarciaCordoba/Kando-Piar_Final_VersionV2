// Patrón Module para organizar el código JavaScript del Dashboard
const DashboardModule = (function() {
    
    // Variables privadas
    let isMobile = false;
    
    // Elementos del DOM
    const sidebar = document.getElementById('sidebar');
    const toggleSidebar = document.getElementById('toggleSidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const content = document.getElementById('content');
    
    // Métodos privados
    function _checkIfMobile() {
        return window.matchMedia('(max-width: 992px)').matches;
    }
    
    function _openMobileMenu() {
        sidebar.classList.add('mobile-open');
        sidebarOverlay.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevenir scroll del body
    }
    
    function _closeMobileMenu() {
        sidebar.classList.remove('mobile-open');
        sidebarOverlay.classList.remove('active');
        document.body.style.overflow = ''; // Restaurar scroll del body
    }
    
    function _toggleMobileMenu(event) {
        event.stopPropagation();
        
        if (sidebar.classList.contains('mobile-open')) {
            _closeMobileMenu();
        } else {
            _openMobileMenu();
        }
    }
    
    function _handleOverlayClick() {
        _closeMobileMenu();
    }
    
    function _handleDocumentClick(event) {
        if (sidebar.classList.contains('mobile-open') && 
            !sidebar.contains(event.target) && 
            !toggleSidebar.contains(event.target)) {
            _closeMobileMenu();
        }
    }
    
    function _handleSidebarClick(event) {
        event.stopPropagation();
    }
    
    function _handleWindowResize() {
        const currentIsMobile = _checkIfMobile();
        
        // Recargar cuando cambie entre modo móvil y escritorio
        // para simplificar el manejo de estados
        if (currentIsMobile !== isMobile) {
            window.location.reload();
        }
    }
    
    function _initMobileMenu() {
        if (isMobile) {
            // Agregar event listeners para móvil
            toggleSidebar.addEventListener('click', _toggleMobileMenu);
            sidebarOverlay.addEventListener('click', _handleOverlayClick);
            document.addEventListener('click', _handleDocumentClick);
            sidebar.addEventListener('click', _handleSidebarClick);
        } else {
            // En desktop, asegurarse de que el menú esté siempre visible
            sidebar.style.transform = 'translateX(0)';
        }
    }
    
    function _initEventListeners() {
        // Manejar redimensionamiento de ventana
        window.addEventListener('resize', _handleWindowResize);
        
        // Manejar botón de logout
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', _handleLogout);
        }
        
        // Manejar botones del modal de logout
        const confirmLogoutBtn = document.getElementById('confirmLogout');
        if (confirmLogoutBtn) {
            confirmLogoutBtn.addEventListener('click', _confirmLogout);
        }
        
        const cancelLogoutBtn = document.getElementById('cancelLogout');
        if (cancelLogoutBtn) {
            cancelLogoutBtn.addEventListener('click', _cancelLogout);
        }
        
        // Cerrar modal al hacer clic fuera de él
        const logoutModal = document.getElementById('logoutModal');
        if (logoutModal) {
            logoutModal.addEventListener('click', function(event) {
                if (event.target === logoutModal) {
                    _cancelLogout();
                }
            });
        }
    }
    
    function _handleLogout() {
        // Mostrar modal de confirmación
        const modal = document.getElementById('logoutModal');
        if (modal) {
            modal.style.display = 'block';
        }
    }
    
    function _confirmLogout() {
        // Limpiar datos del localStorage
        localStorage.removeItem('authToken');
        localStorage.removeItem('userData');
        
        // Redirigir al login
        window.location.href = './login.html';
    }
    
    function _cancelLogout() {
        // Ocultar modal
        const modal = document.getElementById('logoutModal');
        if (modal) {
            modal.style.display = 'none';
        }
    }
    
    // Método público para cargar datos del usuario
    function _loadUserData() {
        const storedUserData = localStorage.getItem('userData');
        let userData;
        if (storedUserData) {
            userData = JSON.parse(storedUserData);
        } else {
            userData = {
                nombres: 'Usuario',
                apellidos: '',
                codigo_usuario: '',
                email: '',
                genero: ''
            };
        }
        // Actualizar datos en el sidebar
        const userName = document.querySelector('.user-name');
        const userCode = document.getElementById('userCode');
        const userEmail = document.getElementById('userEmail');
        if (userName) userName.textContent = `${userData.nombres} ${userData.apellidos}`;
        if (userCode) userCode.textContent = userData.codigo_usuario;
        if (userEmail) userEmail.textContent = userData.email;

        // Actualizar texto de bienvenida
        const welcomeTitle = document.querySelector('.welcome-card h1');
        if (welcomeTitle) {
            let saludo = 'Bienvenido';
            if (userData.genero) {
                if (userData.genero.toLowerCase().startsWith('f')) {
                    saludo = 'Bienvenida';
                }
            }
            welcomeTitle.textContent = `${saludo}, ${userData.nombres}`;
        }
    }
    
    // Método público para inicializar el módulo
    function init() {
        // Verificar si estamos en modo móvil
        isMobile = _checkIfMobile();
        
        // Inicializar funcionalidad del menú
        _initMobileMenu();
        
        // Inicializar otros event listeners
        _initEventListeners();

        // Cargar datos del usuario
        _loadUserData();
        
        console.log('Dashboard module initialized');
        console.log('Mobile mode:', isMobile);
    }
    
    // API pública
    return {
        init: init
    };
})();

// Inicializar el módulo cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', DashboardModule.init);
