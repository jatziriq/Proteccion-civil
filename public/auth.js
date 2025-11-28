// public/js/auth.js
// Sistema de autenticación y protección de rutas

const AUTH_CONFIG = {
    publicPages: [
        'index.html',
        'login.html',
        'novedades.html',
        'brigadas.html',
        'cursos.html',
        'contacto.html',
        'buscar-brigadistas.html'
    ],
    roleAccess: {
        'admin': ['admin-dashboard.html', 'gestion-usuarios.html', 'reportes-admin.html', 'configuracion.html'],
        'tecnico': ['tecnico-dashboard.html', 'gestion-emergencias.html', 'mantenimiento.html'],
        'brigadista': ['brigadista-dashboard.html', 'mi-perfil.html', 'mis-cursos.html'],
        'capacitador': ['capacitador-dashboard.html', 'gestion-cursos.html', 'inscripciones.html'],
        'usuario': []
    },
    dashboards: {
        'admin': 'admin-dashboard.html',
        'tecnico': 'tecnico-dashboard.html',
        'brigadista': 'brigadista-dashboard.html',
        'capacitador': 'capacitador-dashboard.html',
        'usuario': 'index.html'
    }
};

// Obtener usuario actual
function getCurrentUser() {
    const userStr = localStorage.getItem('user');
    const token = localStorage.getItem('token');
    
    if (!userStr || !token) return null;
    
    try {
        return JSON.parse(userStr);
    } catch (e) {
        return null;
    }
}

// Verificar si el usuario está autenticado
function isAuthenticated() {
    return !!getCurrentUser();
}

// Verificar si tiene acceso a una página
function canAccessPage(pageName) {
    const user = getCurrentUser();
    
    // Si no está autenticado, solo puede acceder a páginas públicas
    if (!user) {
        return AUTH_CONFIG.publicPages.includes(pageName);
    }
    
    // Páginas públicas siempre accesibles
    if (AUTH_CONFIG.publicPages.includes(pageName)) {
        return true;
    }
    
    // Verificar si el rol tiene acceso a esta página
    const rolePages = AUTH_CONFIG.roleAccess[user.rol] || [];
    return rolePages.includes(pageName);
}

// Redirigir según el rol
function redirectToDashboard() {
    const user = getCurrentUser();
    if (!user) {
        window.location.href = 'login.html';
        return;
    }
    
    const dashboard = AUTH_CONFIG.dashboards[user.rol] || 'index.html';
    window.location.href = dashboard;
}

// Proteger página actual
function protectPage(allowedRoles = []) {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    const user = getCurrentUser();
    
    // Si no está autenticado y no es página pública
    if (!user && !AUTH_CONFIG.publicPages.includes(currentPage)) {
        alert('Debes iniciar sesión para acceder a esta página');
        window.location.href = 'login.html';
        return false;
    }
    
    // Si está autenticado, verificar permisos
    if (user && allowedRoles.length > 0) {
        if (!allowedRoles.includes(user.rol)) {
            alert('No tienes permisos para acceder a esta página');
            redirectToDashboard();
            return false;
        }
    }
    
    // Si no puede acceder a la página
    if (!canAccessPage(currentPage)) {
        alert('No tienes permisos para acceder a esta página');
        redirectToDashboard();
        return false;
    }
    
    return true;
}

// Cerrar sesión
function logout() {
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    window.location.href = 'index.html';
}

// Actualizar UI según usuario
function updateNavbar() {
    const user = getCurrentUser();
    const loginBtn = document.querySelector('a[href="login.html"]');
    
    if (user && loginBtn) {
        loginBtn.textContent = user.nombre;
        loginBtn.href = AUTH_CONFIG.dashboards[user.rol];
        
        // Agregar botón de cerrar sesión
        const logoutBtn = document.createElement('button');
        logoutBtn.textContent = 'Cerrar Sesión';
        logoutBtn.className = 'ml-4 px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-full shadow transition';
        logoutBtn.onclick = logout;
        loginBtn.parentNode.appendChild(logoutBtn);
    }
}

// Hacer solicitud autenticada
async function authenticatedFetch(url, options = {}) {
    const token = localStorage.getItem('token');
    
    if (!token) {
        throw new Error('No autenticado');
    }
    
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        ...options.headers
    };
    
    const response = await fetch(url, {
        ...options,
        headers
    });
    
    if (response.status === 401 || response.status === 403) {
        alert('Sesión expirada. Por favor inicia sesión nuevamente.');
        logout();
        throw new Error('No autorizado');
    }
    
    return response;
}

// Inicializar protección en carga de página
document.addEventListener('DOMContentLoaded', () => {
    updateNavbar();
});

// Exportar funciones
window.Auth = {
    getCurrentUser,
    isAuthenticated,
    canAccessPage,
    redirectToDashboard,
    protectPage,
    logout,
    updateNavbar,
    authenticatedFetch
};