/**
 * Validaciones en cliente para el Sistema de Trabajos de Grado UTS
 */

function validarUrlHttps(inputElement) {
    var val = inputElement.value.trim();
    if (!val.toLowerCase().startsWith("https://")) {
        alert("Atención: Por política de seguridad institucional, la URL debe iniciar con 'https://' (Google Drive / OneDrive).");
        inputElement.focus();
        return false;
    }
    return true;
}

function abrirModalRechazo(proyectoId, formAction) {
    var modal = document.getElementById("modalRechazo");
    if (modal) {
        document.getElementById("modalProyectoId").value = proyectoId;
        document.getElementById("formRechazo").action = formAction;
        modal.style.display = "flex";
    }
}

function cerrarModalRechazo() {
    var modal = document.getElementById("modalRechazo");
    if (modal) {
        modal.style.display = "none";
    }
}

function validarFormularioRechazo() {
    var motivo = document.getElementById("motivoRechazo").value.trim();
    var check = document.getElementById("confirmacionRechazo").checked;

    if (motivo.length < 30) {
        alert("Regla Institucional: El motivo de rechazo debe contener al menos 30 caracteres justificativos.");
        return false;
    }
    if (!check) {
        alert("Debe confirmar expresamente que comprende la irreversibilidad de este rechazo.");
        return false;
    }
    return true;
}
