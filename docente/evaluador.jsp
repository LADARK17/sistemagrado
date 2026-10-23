<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardDocente.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto, java.util.Collection" %>

<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String proyIdStr = request.getParameter("proyecto_id");
        String decision = request.getParameter("decision");
        String urlPropuestaFirmada = request.getParameter("propuesta_firmada_url");
        String urlInformeFirmado = request.getParameter("informe_firmado_url");
        String urlRejillaFirmada = request.getParameter("rejilla_firmada_url");
        String comentarios = request.getParameter("comentarios");

        if (proyIdStr != null && decision != null) {
            int id = Integer.parseInt(proyIdStr);
            Proyecto p = MockDataStore.PROYECTOS.get(id);
            if (p != null) {
                if ("Aprobado".equalsIgnoreCase(decision)) {
                    if (p.getFase() == 3) {
                        // RF-EVA-02: Pasa al Comité en Fase 3
                        p.setResponsableTurno("comite");
                        msg = "Respuesta enviada correctamente. Propuesta evaluada con F-DC-124 firmado; trasladada a concepto del Comité.";
                    } else if (p.getFase() == 5) {
                        // RF-EVA-03: Pasa al Comité en Fase 5
                        p.setResponsableTurno("comite");
                        msg = "Respuesta enviada correctamente. Informe evaluado con F-DC-125 y F-DC-129 firmados; trasladado a concepto del Comité.";
                    }
                } else if ("Correcciones".equalsIgnoreCase(decision)) {
                    // Si hay correcciones, vuelve al estudiante (Fase 2 o 4)
                    if (p.getFase() == 3) p.setFase(2);
                    if (p.getFase() == 5) p.setFase(4);
                    p.setResponsableTurno("estudiante");
                    msg = "Respuesta enviada correctamente. Se requieren correcciones; expediente devuelto al estudiante.";
                } else if ("Rechazado".equalsIgnoreCase(decision)) {
                    p.setEstado("Rechazado");
                    msg = "Respuesta enviada correctamente. Proyecto rechazado.";
                }
            }
        }
    }

    Collection<Proyecto> proyectos = MockDataStore.PROYECTOS.values();
    request.setAttribute("proyectos", proyectos);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Docente Evaluador - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="evaluador" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-EVA-01 a RF-EVA-04</span>
                <h2>Proyectos Asignados para Evaluación (Docente Evaluador)</h2>
                <p>Dictamen riguroso en Fase 3 (Propuesta II con F-DC-124) y Fase 5 (Informe II con F-DC-125 y F-DC-129).</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Rol Activo: Docente Evaluador</span>
            </div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success">
                <span>✔️</span>
                <div><c:out value="${msg}" /></div>
            </div>
        </c:if>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Expediente</th>
                            <th>Proyecto</th>
                            <th>Fase y Turno</th>
                            <th>Antecedentes / Turnitin</th>
                            <th>Acción Evaluador</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${proyectos}">
                            <tr>
                                <td>
                                    <strong>GRA-0000${p.id}</strong>
                                    <div style="font-size: 0.78rem; color: #006837; font-weight: 700; font-family: 'JetBrains Mono', monospace;"><c:out value="${p.codigoModalidad}" /></div>
                                </td>
                                <td>
                                    <strong><c:out value="${p.titulo}" /></strong>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${p.lineaInvestigacion}" /></div>
                                </td>
                                <td>
                                    <span class="status-chip ${p.responsableTurno == 'evaluador' ? 'chip-pending' : 'chip-neutral'}">
                                        Fase ${p.fase} · <c:out value="${p.responsableTurno}" />
                                    </span>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem;">
                                        <a href="https://drive.google.com/anteproyecto-uts.pdf" target="_blank" rel="noopener" style="color: #38bdf8;">Propuesta F-DC-124 &nearr;</a><br>
                                        <a href="https://drive.google.com/turnitin.pdf" target="_blank" rel="noopener" style="color: #10b981;">Reporte Turnitin &nearr;</a>
                                    </div>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-warning" onclick="abrirModalEvaluador(${p.id}, ${p.fase})">
                                        <span>Calificar Fase</span>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Modal Calificación Evaluador (RF-EVA-02, RF-EVA-03) -->
<div id="modalEvaluador" class="modal-backdrop" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div class="modal-box" style="background: #0f172a; border: 1px solid rgba(255,255,255,0.12); border-radius: 20px; padding: 32px; width: 100%; max-width: 620px; color: #ffffff;">
        <h3 id="modalEvaTitle" style="margin-bottom: 8px;">Concepto de Docente Evaluador</h3>
        <p style="color: var(--text-muted); font-size: 0.88rem; margin-bottom: 20px;">Ingresa tu veredicto y adjunta las URLs de los formatos oficiales firmados.</p>

        <form action="${pageContext.request.contextPath}/docente/evaluador.jsp" method="POST" onsubmit="return confirmarEnvioRespuesta(event, 'evaluador', currentEvaFase);">
            <input type="hidden" id="modalEvaProyId" name="proyecto_id" value="" />

            <div class="form-group">
                <label for="evaDecision">Veredicto Evaluativo:</label>
                <select id="evaDecision" name="decision" class="form-control" required>
                    <option value="Aprobado">Aprobado (Traslada turno al Comité)</option>
                    <option value="Correcciones">Correcciones (Devuelve al estudiante)</option>
                    <option value="Rechazado">Rechazado</option>
                </select>
            </div>

            <!-- Fase 3: F-DC-124 Firmado -->
            <div id="secEvaFase3" class="form-group" style="margin-top: 14px;">
                <label for="urlFdc124">URL Propuesta Firmada F-DC-124 (HTTPS obligatorio - RF-EVA-02):</label>
                <input type="url" id="urlFdc124" name="propuesta_firmada_url" placeholder="https://drive.google.com/fdc-124-firmado.pdf" class="form-control" />
            </div>

            <!-- Fase 5: F-DC-125 e F-DC-129 Firmados -->
            <div id="secEvaFase5" style="display: none; margin-top: 14px;">
                <div class="form-group">
                    <label for="urlFdc125">URL Informe Firmado F-DC-125 (RF-EVA-03):</label>
                    <input type="url" id="urlFdc125" name="informe_firmado_url" placeholder="https://drive.google.com/fdc-125-firmado.pdf" class="form-control" />
                </div>
                <div class="form-group" style="margin-top: 12px;">
                    <label for="urlFdc129">URL Rejilla Evaluativa Firmada F-DC-129 (RF-EVA-03):</label>
                    <input type="url" id="urlFdc129" name="rejilla_firmada_url" placeholder="https://drive.google.com/fdc-129-firmado.pdf" class="form-control" />
                </div>
            </div>

            <div class="form-group" style="margin-top: 14px;">
                <label for="evaComentarios">Observaciones y Rúbrica Evaluativa:</label>
                <textarea id="evaComentarios" name="comentarios" rows="3" class="form-control" placeholder="Escribe el dictamen técnico para el Comité y el estudiante..."></textarea>
            </div>

            <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px;">
                <button type="button" class="btn btn-secondary" onclick="cerrarModalEvaluador()">Cancelar</button>
                <button type="submit" class="btn btn-primary">Registrar Dictamen</button>
            </div>
        </form>
    </div>
</div>

<script>
var currentEvaFase = 3;
function abrirModalEvaluador(proyId, fase) {
    currentEvaFase = fase;
    document.getElementById('modalEvaProyId').value = proyId;
    document.getElementById('modalEvaTitle').innerText = 'Concepto de Evaluador - Fase ' + fase;

    var sec3 = document.getElementById('secEvaFase3');
    var sec5 = document.getElementById('secEvaFase5');
    if (fase === 5) {
        sec3.style.display = 'none';
        sec5.style.display = 'block';
    } else {
        sec3.style.display = 'block';
        sec5.style.display = 'none';
    }

    document.getElementById('modalEvaluador').style.display = 'flex';
}
function cerrarModalEvaluador() {
    document.getElementById('modalEvaluador').style.display = 'none';
}
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

