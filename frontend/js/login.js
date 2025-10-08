// Patrón Module para organizar el código JavaScript
const LoginModule = (function() {
    // Configuración de la API
    const API_BASE_URL = 'http://localhost:3000/api';
    
    // Elementos del DOM
    const mainLogin = document.getElementById('mainLogin');
    const loginForm = document.getElementById('loginForm');
    const recoveryForm = document.getElementById('recoveryForm');
    const recoveryButton = document.getElementById('recoveryButton');
    const recoveryModal = document.getElementById('recoveryModal');
    const closeRecoveryModal = document.getElementById('closeRecoveryModal');
    const successModal = document.getElementById('successModal');
    const successMessage = document.getElementById('successMessage');
    const modalCloseButton = document.getElementById('modalCloseButton');
    
    const inputs = {
        userCode: document.getElementById('user-code'),
        password: document.getElementById('password'),
        institution: document.getElementById('institution'),
        recoveryUser: document.getElementById('recovery-user'),
        recoveryEmail: document.getElementById('recovery-email'),
        recoveryInstitution: document.getElementById('recovery-institution')
    };
    
    // Grupos de entrada para validación
    const inputGroups = {
        userCode: inputs.userCode.parentElement.parentElement,
        password: inputs.password.parentElement.parentElement,
        institution: inputs.institution.parentElement.parentElement,
        recoveryUser: inputs.recoveryUser.parentElement.parentElement,
        recoveryEmail: inputs.recoveryEmail.parentElement.parentElement,
        recoveryInstitution: inputs.recoveryInstitution.parentElement.parentElement
    };
    
    // Mensajes de validación
    const validationMessages = {
        userCode: document.getElementById('user-code-validation'),
        password: document.getElementById('password-validation'),
        institution: document.getElementById('institution-validation'),
        recoveryUser: document.getElementById('recovery-user-validation'),
        recoveryEmail: document.getElementById('recovery-email-validation'),
        recoveryInstitution: document.getElementById('recovery-institution-validation')
    };
    
    // Métodos privados
    function _validateField(fieldName, value) {
        switch(fieldName) {
            case 'userCode':
            case 'recoveryUser':
                if (!value.trim()) return 'El código de usuario es obligatorio';
                return null;
                
            case 'password':
                if (!value) return 'La contraseña es obligatoria';
                return null;
                
            case 'institution':
            case 'recoveryInstitution':
                if (!value.trim()) return 'El código de institución es obligatorio';
                return null;
                
            case 'recoveryEmail':
                if (!value.trim()) return 'El correo electrónico es obligatorio';
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return 'Ingresa un correo electrónico válido';
                return null;
                
            default:
                return null;
        }
    }
    
    // Función para hacer login con el backend
    async function _authenticateUser(userCode, password, institution) {
        try {
            const response = await fetch('http://localhost:3000/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    userCode: userCode,
                    password: password,
                    institution: institution
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Error en el servidor');
            }

            return data;
        } catch (error) {
            if (error.message.includes('fetch')) {
                throw new Error('No se pudo conectar con el servidor. Verifica que esté funcionando.');
            }
            throw error;
        }
    }
    
    function _showError(fieldName, message) {
        inputGroups[fieldName].classList.remove('success');
        inputGroups[fieldName].classList.add('error');
        validationMessages[fieldName].textContent = message;
    }
    
    function _showSuccess(fieldName) {
        inputGroups[fieldName].classList.remove('error');
        inputGroups[fieldName].classList.add('success');
        validationMessages[fieldName].textContent = '';
    }
    
    function _validateForm(formType) {
        let isValid = true;
        let fieldsToValidate = [];
        
        if (formType === 'login') {
            fieldsToValidate = ['userCode', 'password', 'institution'];
        } else if (formType === 'recovery') {
            fieldsToValidate = ['recoveryUser', 'recoveryEmail', 'recoveryInstitution'];
        }
        
        for (const fieldName of fieldsToValidate) {
            const error = _validateField(fieldName, inputs[fieldName].value);
            
            if (error) {
                _showError(fieldName, error);
                isValid = false;
            } else {
                _showSuccess(fieldName);
            }
        }
        
        return isValid;
    }
    
    function _showRecoveryModal() {
        recoveryModal.classList.add('active');
    }
    
    function _hideRecoveryModal() {
        recoveryModal.classList.remove('active');
        // Resetear formulario
        recoveryForm.reset();
        // Limpiar mensajes de validación
        for (const fieldName of ['recoveryUser', 'recoveryEmail', 'recoveryInstitution']) {
            _showSuccess(fieldName);
        }
    }
    
    function _showSuccessModal(message) {
        successMessage.textContent = message;
        successModal.classList.add('active');
        
        // Cerrar automáticamente después de 3 segundos para login exitoso
        if (message.includes('Inicio de sesión exitoso')) {
            setTimeout(() => {
                _hideSuccessModal();
                // Aquí iría la redirección real
            }, 3000);
        }
    }
    
    function _hideSuccessModal() {
        successModal.classList.remove('active');
    }
    
    function _handleLoginSubmit(e) {
        e.preventDefault();
        
        if (_validateForm('login')) {
            _performLogin();
        }
    }
    
    async function _performLogin() {
        const submitButton = document.querySelector('.btn-primary');
        const originalText = submitButton.innerHTML;
        
        // Cambiar el botón a estado de carga
        submitButton.disabled = true;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Iniciando sesión...';
        
        try {
            const userCode = inputs.userCode.value.trim();
            const password = inputs.password.value;
            const institution = inputs.institution.value.trim();
            
            // Intentar autenticar con el backend
            const authResult = await _authenticateUser(userCode, password, institution);
            
            // Si llegamos aquí, la autenticación fue exitosa
            localStorage.setItem('authToken', authResult.token);
            localStorage.setItem('userData', JSON.stringify(authResult.user));
            
            _showSuccessModal('Inicio de sesión exitoso. Redirigiendo al sistema...');
            
            // Redirigir después de 2 segundos
            setTimeout(() => {
                window.location.href = './dashboard.html';
            }, 2000);
            
        } catch (error) {
            // Mostrar error específico según el tipo
            let errorMessage = 'Código de usuario, contraseña o código de institución incorrectos';
            
            if (error.message.includes('servidor')) {
                errorMessage = error.message;
            }
            
            _showError('userCode', errorMessage);
            
        } finally {
            // Restaurar el botón
            submitButton.disabled = false;
            submitButton.innerHTML = originalText;
        }
    }
    
    async function _handleRecoverySubmit(e) {
        e.preventDefault();
        
        if (_validateForm('recovery')) {
            const submitButton = recoveryForm.querySelector('button[type="submit"]');
            const originalText = submitButton.innerHTML;
            
            // Cambiar el botón a estado de carga
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...';
            
            try {
                const email = inputs.recoveryEmail.value.trim();
                
                const response = await fetch(`${API_BASE_URL}/auth/recover-password`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email })
                });
                
                const result = await response.json();
                
                if (result.success) {
                    _hideRecoveryModal();
                    _showSuccessModal('Se ha enviado el instructivo para recuperar tu contraseña al correo electrónico proporcionado.');
                } else {
                    _showError('recoveryEmail', result.message || 'Error al enviar el correo de recuperación');
                }
                
            } catch (error) {
                _showError('recoveryEmail', 'Error de conexión. Intente nuevamente.');
            } finally {
                // Restaurar el botón
                submitButton.disabled = false;
                submitButton.innerHTML = originalText;
            }
        }
    }
    
    function _initEventListeners() {
        loginForm.addEventListener('submit', _handleLoginSubmit);
        recoveryForm.addEventListener('submit', _handleRecoverySubmit);
        recoveryButton.addEventListener('click', function(e) {
            e.preventDefault();
            _showRecoveryModal();
        });
        closeRecoveryModal.addEventListener('click', _hideRecoveryModal);
        modalCloseButton.addEventListener('click', _hideSuccessModal);
        
        // Cerrar modal al hacer clic fuera del contenido
        recoveryModal.addEventListener('click', function(e) {
            if (e.target === recoveryModal) {
                _hideRecoveryModal();
            }
        });
        
        successModal.addEventListener('click', function(e) {
            if (e.target === successModal) {
                _hideSuccessModal();
            }
        });
        
        // Validación en tiempo real para formulario de login
        for (const fieldName of ['userCode', 'password', 'institution']) {
            inputs[fieldName].addEventListener('blur', () => {
                const error = _validateField(fieldName, inputs[fieldName].value);
                if (error) {
                    _showError(fieldName, error);
                } else {
                    _showSuccess(fieldName);
                }
            });
            
            inputs[fieldName].addEventListener('input', () => {
                if (inputGroups[fieldName].classList.contains('error')) {
                    const error = _validateField(fieldName, inputs[fieldName].value);
                    if (!error) {
                        _showSuccess(fieldName);
                    }
                }
            });
        }
        
        // Validación en tiempo real para formulario de recuperación
        for (const fieldName of ['recoveryUser', 'recoveryEmail', 'recoveryInstitution']) {
            inputs[fieldName].addEventListener('blur', () => {
                const error = _validateField(fieldName, inputs[fieldName].value);
                if (error) {
                    _showError(fieldName, error);
                } else {
                    _showSuccess(fieldName);
                }
            });
            
            inputs[fieldName].addEventListener('input', () => {
                if (inputGroups[fieldName].classList.contains('error')) {
                    const error = _validateField(fieldName, inputs[fieldName].value);
                    if (!error) {
                        _showSuccess(fieldName);
                    }
                }
            });
        }
    }
    
    // Métodos públicos
    return {
        init: function() {
            _initEventListeners();
            console.log('Login module initialized');
        }
    };
})();

// Inicializar el módulo cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', LoginModule.init);
