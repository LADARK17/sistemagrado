/**
 * SIGRADO UTS - Script Principal de Interactividad Frontend
 * Octubre de 2026
 */

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar tooltips y validaciones de URLs
    var urlInputs = document.querySelectorAll('input[type="url"], input[name*="url"], input[name*="Url"]');
    urlInputs.forEach(function(input) {
        input.addEventListener('blur', function() {
            var val = this.value.trim();
            if (val && !val.startsWith('https://')) {
                mostrarNotificacion('warning', 'Aviso: Los documentos deben registrarse con protocolo seguro HTTPS.');
            }
        });
    });
});

// Alternar menú lateral en dispositivos móviles
function toggleSidebar() {
    var sidebar = document.getElementById('appSidebar');
    if (sidebar) {
        sidebar.classList.toggle('open');
    }
}

// Alerta flotante estandarizada (RF-GEN-09)
function mostrarNotificacion(tipo, mensaje) {
    var toast = document.createElement('div');
    toast.className = 'sigrado-toast toast-' + (tipo || 'info');
    toast.innerHTML = '<span>' + (tipo === 'success' ? '✔️' : '⚠️') + '</span> <span>' + mensaje + '</span>';
    document.body.appendChild(toast);

    setTimeout(function() {
        toast.classList.add('visible');
    }, 50);

    setTimeout(function() {
        toast.classList.remove('visible');
        setTimeout(function() {
            if (toast.parentNode) toast.parentNode.removeChild(toast);
        }, 300);
    }, 4000);
}

// Confirmación previa de envío de respuesta de evaluación
function confirmarEnvioRespuesta(event, rol, fase) {
    var estado = document.querySelector('select[name="estado"], input[name="estado"]:checked');
    var estadoVal = estado ? estado.value : 'la decisión';
    var confirmMsg = "¿Confirma el envío de la evaluación con estado '" + estadoVal + "' en la Fase " + fase + "?\n\nEl turno pasará automáticamente al siguiente actor según las reglas académicas.";
    
    if (!confirm(confirmMsg)) {
        event.preventDefault();
        return false;
    }
    return true;
}
