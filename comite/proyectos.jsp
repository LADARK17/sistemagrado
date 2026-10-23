<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardComite.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto, java.util.Collection" %>

<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String proyIdStr = request.getParameter("proyecto_id");
        String decision = request.getParameter("decision");
        String actaNum = request.getParameter("acta_numero");
        String actaFecha = request.getParameter("acta_fecha");
        String directorNombre = request.getParameter("director_nombre");
        String evaluadorNombre = request.getParameter("evaluador_nombre");
        String codirectorNombre = request.getParameter("codirector_nombre");
        String comentarios = request.getParameter("comentarios");

        if (proyIdStr != null && decision != null) {
            int id = Integer.parseInt(proyIdStr);
            Proyecto p = MockDataStore.PROYECTOS.get(id);
            if (p != null) {
                if ("Aprobado".equalsIgnoreCase(decision)) {
                    if (p.getFase() == 1) {
                        // Generar código modalidad (65 o 125)
                        String prefijo = "Tecnologico".equalsIgnoreCase(p.getTipoNivel()) ? "65" : "125";
                        p.setCodigoModalidad(prefijo + "-2026-00" + p.getId());
                        if (directorNombre != null) p.setDirectorNombre(directorNombre);
                        if (evaluadorNombre != null) p.setEvaluadorNombre(evaluadorNombre);
                        if (codirectorNombre != null && !codirectorNombre.isEmpty()) p.setCodirectorNombre(codirectorNombre);
                        p.setFase(2);
                        p.setResponsableTurno("estudiante");
                        msg = "Respuesta enviada correctamente. Proyecto aprobado en Fase 1 con código " + p.getCodigoModalidad() + " y asignación docente realizada.";
                    } else if (p.getFase() == 3) {
                        p.setFase(4);
                        p.setResponsableTurno("estudiante");
                        msg = "Respuesta enviada correctamente. Propuesta aprobada por Comité; proyecto avanza a Fase 4 (estudiante).";
                    } else if (p.getFase() == 5) {
                        p.setFase(6);
                        p.setResponsableTurno("comite");
                        msg = "Respuesta enviada correctamente. Informe avalado; proyecto avanza a Fase 6 (Cierre y Sustentación).";
                    } else if (p.getFase() == 6) {
                        p.setEstado("Finalizado");
                        p.setResponsableTurno("comite");
                        msg = "Respuesta enviada correctamente. Proyecto culminado y cerrado en estado Finalizado.";
                    }
                } else if ("Correcciones".equalsIgnoreCase(decision)) {
                    p.setResponsableTurno("estudiante");
                    msg = "Respuesta enviada correctamente. Solicitud devuelta al estudiante para correcciones.";
                } else if ("Rechazado".equalsIgnoreCase(decision)) {
                    p.setEstado("Rechazado");
                    msg = "Respuesta enviada correctamente. Proyecto marcado como Rechazado.";
                }
            }
        }
    }

    Collection<Proyecto> proyectos = MockDataStore.PROYECTOS.values();
    request.setAttribute("proyectos", proyectos);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Decisiones de Comité - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="proyectos" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-COM-01 a RF-COM-06</span>
                <h2>Decisiones del Comité de Trabajos de Grado</h2>
                <p>Evaluación y emisión de actas resolutivas en las Fases 1, 3, 5 y 6.</p>
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
                            <th>Nivel / Modalidad</th>
                            <th>Comprobante / Documentos</th>
                            <th>Decisión en Turno</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${proyectos}">
                            <tr>
                                <td>
                                    <strong>GRA-0000${p.id}</strong>
                                    <div style="font-size: 0.76rem; color: var(--text-muted); font-family: 'JetBrains Mono', monospace;">
                                        <c:out value="${p.codigoModalidad != null ? p.codigoModalidad : 'Sin código'}" />
                                    </div>
                                </td>
                                <td>
                                    <strong style="color: var(--text-primary);"><c:out value="${p.titulo}" /></strong>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">Integrantes: Juan David Pérez, Laura Marcela Gómez</div>
                                </td>
                                <td>
                                    <span class="status-chip chip-pending">Fase ${p.fase} · <c:out value="${p.responsableTurno}" /></span>
                                </td>
                                <td>
                                    <span class="badge-tag" style="margin: 0; font-size: 0.72rem;"><c:out value="${p.tipoNivel}" /></span>
                                    <div style="font-size: 0.76rem; color: var(--text-muted); margin-top: 3px;"><c:out value="${p.modalidad}" /></div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.urlSoportePago}">
                                            <a href="${p.urlSoportePago}" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Abrir soporte de pago">
                                                <span>Ver Recibo Pago &nearr;</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 0.8rem; color: var(--text-muted);">Sin soporte cargado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <!-- Botón modal para emitir decisión -->
                                    <button type="button" class="btn btn-sm btn-warning" onclick="abrirModalDecision('${p.id}', '${p.fase}', '${p.tipoNivel}')">
                                        <span>Dictaminar</span>
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

<!-- Modal de Dictamen del Comité (RF-COM-01, 02, 03) -->
<div id="modalDecision" class="modal-backdrop" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div class="modal-box" style="background: #0f172a; border: 1px solid rgba(255,255,255,0.12); border-radius: 20px; padding: 32px; width: 100%; max-width: 620px; color: #ffffff; box-shadow: 0 25px 50px rgba(0,0,0,0.6);">
        <h3 id="modalTitle" style="margin-bottom: 8px;">Emisión de Concepto de Comité</h3>
        <p style="color: var(--text-muted); font-size: 0.88rem; margin-bottom: 20px;">Diligencia los datos del acta resolutiva y la asignación docente.</p>
        
        <form action="${pageContext.request.contextPath}/comite/proyectos.jsp" method="POST" id="formDecisionComite">
            <input type="hidden" id="modalProyId" name="proyecto_id" value="" />
            
            <div class="form-grid">
                <div class="form-group">
                    <label for="decisionSel">Decisión:</label>
                    <select id="decisionSel" name="decision" class="form-control" onchange="toggleCamposFase1(this.value)">
                        <option value="Aprobado">Aprobado</option>
                        <option value="Correcciones">Correcciones (Aplazado)</option>
                        <option value="Rechazado">Rechazado</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="actaNum">Número de Acta:</label>
                    <input type="text" id="actaNum" name="acta_numero" required placeholder="Ej. ACTA-COM-2026-042" class="form-control" />
                </div>
            </div>

            <div class="form-group" style="margin-top: 14px;">
                <label for="actaFecha">Fecha de Acta:</label>
                <input type="date" id="actaFecha" name="acta_fecha" required value="2026-10-16" class="form-control" />
            </div>

            <!-- Campos exclusivos de Aprobación en Fase 1 (RF-COM-02) -->
            <div id="seccionAsignacionFase1" style="margin-top: 18px; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 16px;">
                <div style="font-weight: 700; font-size: 0.9rem; color: #facc15; margin-bottom: 12px;">Asignación Docente y Modalidad (Fase 1)</div>
                <div class="form-group">
                    <label>Código Oficial Generado:</label>
                    <input type="text" id="codigoGeneradoPreview" disabled class="input-disabled" value="Generado automáticamente (65 o 125)" />
                </div>
                <div class="form-grid" style="margin-top: 10px;">
                    <div class="form-group">
                        <label for="dirNombre">Director Docente (*):</label>
                        <input type="text" id="dirNombre" name="director_nombre" value="Mg. Fernando Gómez Docente" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label for="evalNombre">Evaluador Docente (*):</label>
                        <input type="text" id="evalNombre" name="evaluador_nombre" value="Dra. Patricia Silva Docente" class="form-control" />
                    </div>
                </div>
                <div class="form-group" style="margin-top: 10px;">
                    <label for="codirNombre">Codirector Docente (Opcional):</label>
                    <input type="text" id="codirNombre" name="codirector_nombre" placeholder="Nombre completo del codirector (opcional)" class="form-control" />
                </div>
            </div>

            <div class="form-group" style="margin-top: 16px;">
                <label for="comentariosDec">Comentarios y Observaciones del Comité:</label>
                <textarea id="comentariosDec" name="comentarios" rows="3" class="form-control" placeholder="Escribe las observaciones que se notificarán a los integrantes..."></textarea>
            </div>

            <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px;">
                <button type="button" class="btn btn-secondary" onclick="cerrarModalDecision()">Cancelar</button>
                <button type="submit" class="btn btn-primary">Registrar Dictamen</button>
            </div>
        </form>
    </div>
</div>

<script>
var currentFase = 1;
function abrirModalDecision(proyId, fase, nivel) {
    currentFase = fase;
    document.getElementById('modalProyId').value = proyId;
    document.getElementById('modalTitle').innerText = 'Emisión de Concepto de Comité - Fase ' + fase;
    var prefijo = (nivel === 'Tecnologico') ? '65' : '125';
    document.getElementById('codigoGeneradoPreview').value = prefijo + '-2026-00' + proyId + ' (Generado automáticamente)';
    
    var secF1 = document.getElementById('seccionAsignacionFase1');
    if (fase === 1) {
        secF1.style.display = 'block';
    } else {
        secF1.style.display = 'none';
    }

    var modal = document.getElementById('modalDecision');
    modal.style.display = 'flex';
}

function cerrarModalDecision() {
    document.getElementById('modalDecision').style.display = 'none';
}

function toggleCamposFase1(decision) {
    var secF1 = document.getElementById('seccionAsignacionFase1');
    if (currentFase === 1 && decision === 'Aprobado') {
        secF1.style.display = 'block';
    } else {
        secF1.style.display = 'none';
    }
}
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

