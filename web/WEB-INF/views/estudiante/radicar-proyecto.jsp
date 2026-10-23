<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div style="max-width: 860px; margin: 0 auto;">
    <!-- HERO HEADER DE RADICACIÓN -->
    <div class="section-hero" style="padding: 26px 32px; margin-bottom: 22px;">
        <span class="hero-pill">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
            <span>Fase 1: Formalización de Matrícula</span>
        </span>
        <h1 class="hero-title" style="font-size: 1.6rem;">Radicación de Trabajo de Grado</h1>
        <p class="hero-desc" style="font-size: 0.92rem;">
            Formalice su propuesta investigativa adjuntando el comprobante de derechos pecuniarios y vinculando opcionalmente a su compañero de fórmula reglamentario.
        </p>
    </div>

    <div class="uts-card">
        <form action="${pageContext.request.contextPath}/estudiante/guardar-radicacion" method="POST" onsubmit="return validarRadicacion();">
            
            <!-- SECCIÓN 1: MODALIDAD Y TEMA -->
            <div style="margin-bottom: 24px; padding-bottom: 18px; border-bottom: 1px solid #f1f5f9;">
                <h3 style="font-size: 1.15rem; color: var(--uts-green-700); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: var(--uts-green-50); color: var(--uts-green-700); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">1</span>
                    <span>Definición del Tema de Investigación</span>
                </h3>

                <!-- SELECCIÓN DE IDEA DEL BANCO (OPCIONAL) -->
                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="ideaBancoId" style="font-weight: 700;">Postulación a Idea del Banco UTS (Opcional):</label>
                    <select id="ideaBancoId" name="ideaBancoId" class="form-control" onchange="completarDatosIdea(this)" style="font-size: 0.92rem;">
                        <option value="0" data-titulo="" data-desc="">-- Proponer Tema Libre Propio --</option>
                        <c:forEach var="idea" items="${ideas}">
                            <option value="${idea.id}" data-titulo="<c:out value='${idea.titulo}' />" data-desc="<c:out value='${idea.descripcion}' />">
                                [<c:out value="${idea.lineaInvestigacion}" />] <c:out value="${idea.titulo}" />
                            </option>
                        </c:forEach>
                    </select>
                    <small style="color: var(--text-muted); display: block; margin-top: 4px;">
                        Al elegir una idea del Banco, el título y alcance se auto-completarán con la propuesta oficial.
                    </small>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="titulo" style="font-weight: 700;">Título de la Propuesta de Grado:</label>
                    <input type="text" id="titulo" name="titulo" required class="form-control" 
                           placeholder="ej. Desarrollo de una plataforma web para la gestión ambiental en Bucaramanga" />
                </div>

                <div class="form-group">
                    <label for="objetivo" style="font-weight: 700;">Objetivo General y Alcance:</label>
                    <textarea id="objetivo" name="objetivo" rows="3" required class="form-control"
                              placeholder="Indique el propósito central del trabajo de grado, alcance metodológico y población beneficiada..."></textarea>
                </div>
            </div>

            <!-- SECCIÓN 2: DERECHOS PECUNIARIOS -->
            <div style="margin-bottom: 24px; padding-bottom: 18px; border-bottom: 1px solid #f1f5f9;">
                <h3 style="font-size: 1.15rem; color: var(--uts-green-700); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: var(--uts-green-50); color: var(--uts-green-700); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">2</span>
                    <span>Comprobante de Derechos Pecuniarios (Fase 1)</span>
                </h3>

                <div class="form-group">
                    <label for="urlPago" style="font-weight: 700;">Enlace HTTPS del Recibo Digitalizado (Google Drive / OneDrive):</label>
                    <input type="url" id="urlPago" name="urlPago" required class="form-control"
                           placeholder="https://drive.google.com/file/d/.../view?usp=sharing" />
                    
                    <div style="margin-top: 8px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 14px; font-size: 0.8rem; color: #475569; display: flex; gap: 8px; align-items: flex-start;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--uts-green-600); flex-shrink: 0;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        <span>
                            <strong>Reglamentación UTS:</strong> Por políticas institucionales de almacenamiento, no se admiten cargas de archivos binarios al servidor. Aloje su recibo o PDF en Google Drive o OneDrive y asegúrese de que el enlace sea accesible para lectura por el Comité.
                        </span>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 3: CONFORMACIÓN DE EQUIPO (RN02) -->
            <div style="margin-bottom: 26px;">
                <h3 style="font-size: 1.15rem; color: var(--uts-green-700); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: var(--uts-green-50); color: var(--uts-green-700); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">3</span>
                    <span>Conformación del Equipo Estudiantil (Máx. 2 Integrantes)</span>
                </h3>

                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 16px 20px;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <input type="checkbox" id="checkPareja" onchange="toggleCompanero(this.checked)" style="width: 18px; height: 18px; accent-color: var(--uts-green-600);" />
                        <label for="checkPareja" style="margin-bottom: 0; font-weight: 700; color: #0f172a; cursor: pointer;">
                            Realizaré el trabajo de grado en Pareja (Vincular compañero de fórmula)
                        </label>
                    </div>

                    <div id="seccionCompanero" style="display: none; margin-top: 16px; padding-top: 14px; border-top: 1px solid #e2e8f0;">
                        <label for="companeroId" style="font-weight: 700; font-size: 0.88rem;">Seleccione a su Compañero(a):</label>
                        <select id="companeroId" name="companeroId" class="form-control" style="margin-top: 6px;">
                            <option value="0">-- Seleccione el estudiante por documento o nombre --</option>
                            <c:forEach var="c" items="${companeros}">
                                <option value="${c.id}">
                                    [Doc: <c:out value="${c.documento}" />] <c:out value="${c.nombreCompleto}" />
                                </option>
                            </c:forEach>
                        </select>
                        <small style="color: var(--text-muted); display: block; margin-top: 6px;">
                            Solo se muestran estudiantes activos en plataforma que no cuentan actualmente con otro radicado de grado.
                        </small>
                    </div>
                </div>
            </div>

            <!-- BOTONES DE ACCIÓN -->
            <div style="display: flex; justify-content: flex-end; gap: 12px; padding-top: 14px; border-top: 1px solid #f1f5f9;">
                <a href="${pageContext.request.contextPath}/estudiante/dashboard" class="btn btn-secondary">
                    Cancelar
                </a>
                <button type="submit" class="btn btn-primary" style="padding: 11px 26px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Formalizar y Radicar Propuesta</span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function completarDatosIdea(select) {
    var option = select.options[select.selectedIndex];
    var titulo = option.getAttribute("data-titulo");
    var desc = option.getAttribute("data-desc");

    if (titulo) {
        document.getElementById("titulo").value = titulo;
    }
    if (desc) {
        document.getElementById("objetivo").value = desc;
    }
}

function toggleCompanero(activado) {
    var sec = document.getElementById("seccionCompanero");
    var comp = document.getElementById("companeroId");
    sec.style.display = activado ? "block" : "none";
    if (!activado) {
        comp.value = "0";
    }
}

function validarRadicacion() {
    var url = document.getElementById("urlPago").value.trim();
    if (!url.toLowerCase().startsWith("https://")) {
        alert("La URL del comprobante de pago debe ser un enlace seguro que comience con 'https://'");
        return false;
    }
    var check = document.getElementById("checkPareja").checked;
    var comp = document.getElementById("companeroId").value;
    if (check && (comp === "0" || comp === "")) {
        alert("Debe seleccionar al compañero de fórmula de la lista o desmarcar la casilla de trabajo en pareja.");
        return false;
    }
    return true;
}

// Auto-selección por parámetro GET ideaId
window.addEventListener("DOMContentLoaded", function() {
    var urlParams = new URLSearchParams(window.location.search);
    var ideaId = urlParams.get('ideaId');
    if (ideaId) {
        var select = document.getElementById("ideaBancoId");
        if (select) {
            select.value = ideaId;
            completarDatosIdea(select);
        }
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
