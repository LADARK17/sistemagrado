<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardComite.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto" %>

<%
    String idStr = request.getParameter("id");
    int id = 1;
    if (idStr != null) {
        try { id = Integer.parseInt(idStr); } catch (Exception ignored) {}
    }
    Proyecto p = MockDataStore.PROYECTOS.get(id);
    if (p == null && !MockDataStore.PROYECTOS.isEmpty()) {
        p = MockDataStore.PROYECTOS.values().iterator().next();
    }
    request.setAttribute("proyecto", p);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Seguimiento de Fases - Comité SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="seguimiento" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-GEN-10 / RF-COM-07</span>
                <h2>Mapa de Fases y Trazabilidad del Proyecto</h2>
                <p>Expediente #GRA-0000${proyecto.id} • Modalidad: <strong><c:out value="${proyecto.codigoModalidad != null ? proyecto.codigoModalidad : 'Pendiente'}" /></strong></p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/comite/proyectos.jsp" class="btn btn-secondary">&larr; Volver a Proyectos</a>
            </div>
        </div>

        <!-- MAPA DE LAS 6 FASES (RF-GEN-10) -->
        <div class="uts-card" style="margin-bottom: 24px;">
            <div style="font-weight: 700; margin-bottom: 16px; font-size: 1rem;">Estado del Flujo por Fases (Resaltado en Verde la Fase Alcanzada):</div>
            <div class="stepper-horizontal" style="display: flex; justify-content: space-between; position: relative; gap: 8px; flex-wrap: wrap;">
                <div class="step-item ${proyecto.fase >= 1 ? 'step-completed' : ''} ${proyecto.fase == 1 ? 'step-current' : ''}">
                    <div class="step-dot">1</div>
                    <div class="step-text">
                        <span class="step-title">Fase 1</span>
                        <span class="step-desc">Idea y Pago</span>
                    </div>
                </div>
                <div class="step-item ${proyecto.fase >= 2 ? 'step-completed' : ''} ${proyecto.fase == 2 ? 'step-current' : ''}">
                    <div class="step-dot">2</div>
                    <div class="step-text">
                        <span class="step-title">Fase 2</span>
                        <span class="step-desc">Propuesta I (Director)</span>
                    </div>
                </div>
                <div class="step-item ${proyecto.fase >= 3 ? 'step-completed' : ''} ${proyecto.fase == 3 ? 'step-current' : ''}">
                    <div class="step-dot">3</div>
                    <div class="step-text">
                        <span class="step-title">Fase 3</span>
                        <span class="step-desc">Propuesta II (Evaluador)</span>
                    </div>
                </div>
                <div class="step-item ${proyecto.fase >= 4 ? 'step-completed' : ''} ${proyecto.fase == 4 ? 'step-current' : ''}">
                    <div class="step-dot">4</div>
                    <div class="step-text">
                        <span class="step-title">Fase 4</span>
                        <span class="step-desc">Informe I (Director)</span>
                    </div>
                </div>
                <div class="step-item ${proyecto.fase >= 5 ? 'step-completed' : ''} ${proyecto.fase == 5 ? 'step-current' : ''}">
                    <div class="step-dot">5</div>
                    <div class="step-text">
                        <span class="step-title">Fase 5</span>
                        <span class="step-desc">Informe II (Evaluador)</span>
                    </div>
                </div>
                <div class="step-item ${proyecto.fase >= 6 ? 'step-completed' : ''} ${proyecto.fase == 6 ? 'step-current' : ''}">
                    <div class="step-dot">6</div>
                    <div class="step-text">
                        <span class="step-title">Fase 6</span>
                        <span class="step-desc">Sustentación</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- DETALLE DEL PROYECTO (RF-GEN-12) -->
        <div class="form-grid">
            <div class="uts-card">
                <h3>Información General de la Propuesta</h3>
                <div style="margin-top: 14px; font-size: 0.9rem; line-height: 1.6;">
                    <div><strong>Título:</strong> <c:out value="${proyecto.titulo}" /></div>
                    <div style="margin-top: 6px;"><strong>Objetivo:</strong> <c:out value="${proyecto.objetivo}" /></div>
                    <div style="margin-top: 6px;"><strong>Línea de Investigación:</strong> <c:out value="${proyecto.lineaInvestigacion}" /></div>
                    <div style="margin-top: 6px;"><strong>Nivel / Modalidad:</strong> <c:out value="${proyecto.tipoNivel}" /> • <c:out value="${proyecto.modalidad}" /></div>
                </div>
            </div>

            <div class="uts-card">
                <h3>Integrantes y Docentes Asignados</h3>
                <div style="margin-top: 14px; font-size: 0.9rem; line-height: 1.6;">
                    <div><strong>Estudiante Principal:</strong> Juan David Pérez (1098700005)</div>
                    <div style="margin-top: 6px;"><strong>Segundo Integrante:</strong> Laura Marcela Gómez (1098700006)</div>
                    <div style="margin-top: 10px; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 8px;">
                        <strong>Director Docente:</strong> <c:out value="${proyecto.directorNombre != null ? proyecto.directorNombre : 'Por asignar'}" /><br>
                        <strong>Evaluador Docente:</strong> <c:out value="${proyecto.evaluadorNombre != null ? proyecto.evaluadorNombre : 'Por asignar'}" /><br>
                        <strong>Codirector:</strong> <c:out value="${proyecto.codirectorNombre != null ? proyecto.codirectorNombre : 'Ninguno'}" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

