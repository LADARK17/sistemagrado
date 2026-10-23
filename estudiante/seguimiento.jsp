<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardEstudiante.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto" %>

<%
    Proyecto p = MockDataStore.PROYECTOS.get(1);
    request.setAttribute("proyecto", p);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Mapa de Fases - Estudiante SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="seguimiento" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-EST-05 / RF-GEN-10</span>
                <h2>Mapa de Fases y Progreso Académico</h2>
                <p>Seguimiento continuo de tu trabajo de grado en las 6 etapas del reglamento UTS.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/estudiante/proyecto.jsp" class="btn btn-secondary">&larr; Volver a Mi Proyecto</a>
            </div>
        </div>

        <!-- STEPPER DE 6 FASES INTERACTIVO -->
        <div class="uts-card" style="margin-bottom: 24px;">
            <div style="font-weight: 700; margin-bottom: 16px; font-size: 1rem;">Flujo de Fases (Fase Alcanzada Resaltada en Verde):</div>
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

        <!-- ENTREGABLES POR FASE CON ICONO OJO (RF-GEN-10) -->
        <div class="uts-card">
            <h3>Entregables Registrados en el Expediente</h3>
            <div class="table-container" style="margin-top: 14px;">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Fase</th>
                            <th>Entregable / Documento</th>
                            <th>Formato Oficial</th>
                            <th>Estado de Revisión</th>
                            <th>Inspeccionar (Ojo)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="status-chip chip-approved">Fase 1</span></td>
                            <td>Comprobante de Pago Derechos Pecuniarios</td>
                            <td>Recibo Bancario UTS</td>
                            <td><span class="status-chip chip-approved">Validado por Comité</span></td>
                            <td>
                                <a href="https://drive.google.com/recibo-pago-uts-2026.pdf" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Ver Documento">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="status-chip ${proyecto.fase > 2 ? 'chip-approved' : (proyecto.fase == 2 ? 'chip-pending' : 'chip-neutral')}">Fase 2</span></td>
                            <td>Anteproyecto de Grado (Propuesta I)</td>
                            <td>F-DC-124</td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.fase > 2}">
                                        <span class="status-chip chip-approved">Aprobado y Avalado</span>
                                    </c:when>
                                    <c:when test="${not empty proyecto.urlAnteproyecto}">
                                        <span class="status-chip chip-pending">En Revisión con Director</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-chip chip-neutral">Pendiente de Carga</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty proyecto.urlAnteproyecto}">
                                        <a href="${proyecto.urlAnteproyecto}" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Ver Documento">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="status-chip ${proyecto.fase > 4 ? 'chip-approved' : (proyecto.fase == 4 ? 'chip-pending' : 'chip-neutral')}">Fase 4</span></td>
                            <td>Informe de Desarrollo Tecnológico</td>
                            <td>F-DC-125</td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.fase > 4}">
                                        <span class="status-chip chip-approved">Aprobado por Director</span>
                                    </c:when>
                                    <c:when test="${not empty proyecto.urlInformeFinal}">
                                        <span class="status-chip chip-pending">En Evaluación de Director</span>
                                    </c:when>
                                    <c:when test="${proyecto.fase == 4}">
                                        <span class="status-chip chip-pending">Turno de Entrega Activo</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-chip chip-neutral">Bloqueado (Fases previas)</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty proyecto.urlInformeFinal}">
                                        <a href="${proyecto.urlInformeFinal}" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Ver Documento">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="status-chip ${proyecto.fase > 5 ? 'chip-approved' : (proyecto.fase == 5 ? 'chip-pending' : 'chip-neutral')}">Fase 5</span></td>
                            <td>Rejilla y Dictamen Evaluativo</td>
                            <td>F-DC-129</td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.fase >= 6}">
                                        <span class="status-chip chip-approved">Concepto Favorable Comité</span>
                                    </c:when>
                                    <c:when test="${proyecto.fase == 5}">
                                        <span class="status-chip chip-pending">En Evaluación por Jurado</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-chip chip-neutral">Pendiente de Fase 4</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.fase >= 6}">
                                        <a href="https://drive.google.com/fdc-129-rejilla-aprobada.pdf" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Ver Rejilla">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="status-chip ${proyecto.estado == 'Finalizado' ? 'chip-approved' : (proyecto.fase == 6 ? 'chip-pending' : 'chip-neutral')}">Fase 6</span></td>
                            <td>Acta de Cierre y Sustentación</td>
                            <td>F-DC-130</td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.estado == 'Finalizado'}">
                                        <span class="status-chip chip-approved">Grado Culminado</span>
                                    </c:when>
                                    <c:when test="${proyecto.fase == 6}">
                                        <span class="status-chip chip-pending">Sustentación Programada</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-chip chip-neutral">Fase Final</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${proyecto.fase >= 6}">
                                        <a href="https://docs.google.com/document/d/plantilla-fdc-130-uts" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary" title="Ver Acta">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

