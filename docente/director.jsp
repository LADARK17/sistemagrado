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
        String turnitinUrl = request.getParameter("turnitin_url");
        String comentarios = request.getParameter("comentarios");

        if (proyIdStr != null && decision != null) {
            int id = Integer.parseInt(proyIdStr);
            Proyecto p = MockDataStore.PROYECTOS.get(id);
            if (p != null) {
                if ("Aprobado".equalsIgnoreCase(decision)) {
                    if (p.getFase() == 2) {
                        // RF-DIR-03: Pasa automáticamente a Fase 3 (turno del Evaluador)
                        p.setFase(3);
                        p.setResponsableTurno("evaluador");
                        if (turnitinUrl != null) p.setUrlTurnitin(turnitinUrl);
                        msg = "Respuesta enviada correctamente. Anteproyecto avalado con Turnitin; avanza automáticamente a Fase 3 (Evaluador).";
                    } else if (p.getFase() == 4) {
                        // RF-DIR-04: Pasa a Fase 5 (Evaluador)
                        p.setFase(5);
                        p.setResponsableTurno("evaluador");
                        msg = "Respuesta enviada correctamente. Informe de avance aprobado; avanza a Fase 5 (Evaluador).";
                    }
                } else if ("Correcciones".equalsIgnoreCase(decision)) {
                    p.setResponsableTurno("estudiante");
                    msg = "Respuesta enviada correctamente. Solicitud devuelta al estudiante con observaciones.";
                } else if ("Rechazado".equalsIgnoreCase(decision)) {
                    p.setEstado("Rechazado");
                    msg = "Respuesta enviada correctamente. Proyecto marcado como No aprobado / Rechazado.";
                }
            }
        }
    }

    Collection<Proyecto> proyectos = MockDataStore.PROYECTOS.values();
    request.setAttribute("proyectos", proyectos);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Docente Director - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="director" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-DIR-01 a RF-DIR-05</span>
                <h2>Proyectos Dirigidos (Docente Director)</h2>
                <p>Acompañamiento y dictamen de entregables en Fase 2 (Anteproyecto) y Fase 4 (Informe de Desarrollo).</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Rol Activo: Docente Director</span>
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
                            <th>Entregable del Estudiante</th>
                            <th>Reporte Turnitin</th>
                            <th>Acción Evaluativa</th>
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
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">Estudiantes: Juan David Pérez, Laura Marcela Gómez</div>
                                </td>
                                <td>
                                    <span class="status-chip ${p.responsableTurno == 'director' ? 'chip-pending' : 'chip-neutral'}">
                                        Fase ${p.fase} · <c:out value="${p.responsableTurno}" />
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.urlAnteproyecto}">
                                            <a href="${p.urlAnteproyecto}" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                                                <span>Ver Documento (F-DC-124) &nearr;</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 0.82rem; color: var(--text-muted);">Pendiente de entrega</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.urlTurnitin}">
                                            <a href="${p.urlTurnitin}" target="_blank" rel="noopener" style="color: #10b981; font-size: 0.82rem;">Turnitin Adjunto &nearr;</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 0.82rem; color: var(--text-muted);">Por cargar en evaluación</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-warning" onclick="abrirModalDirector(${p.id}, ${p.fase})">
                                        <span>Evaluar Fase</span>
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

<!-- Modal Evaluación Director (RF-DIR-02, RF-DIR-04) -->
<div id="modalDirector" class="modal-backdrop" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div class="modal-box" style="background: #0f172a; border: 1px solid rgba(255,255,255,0.12); border-radius: 20px; padding: 32px; width: 100%; max-width: 600px; color: #ffffff;">
        <h3 id="modalDirTitle" style="margin-bottom: 8px;">Evaluación de Docente Director</h3>
        <p style="color: var(--text-muted); font-size: 0.88rem; margin-bottom: 20px;">Diligencia el concepto académico y la URL del informe de similitud Turnitin.</p>

        <form action="${pageContext.request.contextPath}/docente/director.jsp" method="POST" onsubmit="return confirmarEnvioRespuesta(event, 'director', currentDirFase);">
            <input type="hidden" id="modalDirProyId" name="proyecto_id" value="" />

            <div class="form-group">
                <label for="dirDecision">Decisión del Director:</label>
                <select id="dirDecision" name="decision" class="form-control" required>
                    <option value="Aprobado">Aprobado (Avanza a siguiente fase)</option>
                    <option value="Correcciones">Correcciones (Vuelve al estudiante)</option>
                    <option value="Rechazado">No aprobado / Rechazado</option>
                </select>
            </div>

            <div class="form-group" style="margin-top: 14px;">
                <label for="dirTurnitin">URL Reporte Antiplagio Turnitin (HTTPS obligatorio - RF-DIR-02):</label>
                <input type="url" id="dirTurnitin" name="turnitin_url" placeholder="https://drive.google.com/turnitin-report.pdf" class="form-control" />
            </div>

            <div class="form-group" style="margin-top: 14px;">
                <label for="dirComentarios">Observaciones y Retroalimentación:</label>
                <textarea id="dirComentarios" name="comentarios" rows="3" class="form-control" placeholder="Escribe las recomendaciones de mejora para el estudiante..."></textarea>
            </div>

            <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px;">
                <button type="button" class="btn btn-secondary" onclick="cerrarModalDirector()">Cancelar</button>
                <button type="submit" class="btn btn-primary">Enviar Respuesta</button>
            </div>
        </form>
    </div>
</div>

<script>
var currentDirFase = 2;
function abrirModalDirector(proyId, fase) {
    currentDirFase = fase;
    document.getElementById('modalDirProyId').value = proyId;
    document.getElementById('modalDirTitle').innerText = 'Evaluación de Docente Director - Fase ' + fase;
    document.getElementById('modalDirector').style.display = 'flex';
}
function cerrarModalDirector() {
    document.getElementById('modalDirector').style.display = 'none';
}
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />
