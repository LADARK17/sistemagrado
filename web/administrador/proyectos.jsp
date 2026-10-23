<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardAdministrador.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto, java.util.Collection, edu.uts.proyectos.config.MockDataStore" %>

<%
    Collection<Proyecto> listaProyectos = MockDataStore.PROYECTOS.values();
    request.setAttribute("proyectos", listaProyectos);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Gestión Global de Proyectos - Administrador SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="proyectos" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-06 / RF-ADM-11</span>
                <h2>Gestión Integral de Proyectos de Grado</h2>
                <p>Supervisión del ciclo de vida en las 6 fases, estado y asignaciones docentes.</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Total: ${proyectos.size()} Registros</span>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Código / Expediente</th>
                            <th>Título del Proyecto</th>
                            <th>Nivel / Modalidad</th>
                            <th>Fase y Turno</th>
                            <th>Estado</th>
                            <th>Docentes Asignados</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty proyectos}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                        No hay proyectos registrados en el periodo académico vigente.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${proyectos}">
                                    <tr>
                                        <td>
                                            <strong>GRA-0000${p.id}</strong>
                                            <div style="font-size: 0.78rem; color: var(--text-muted); font-family: 'JetBrains Mono', monospace;">
                                                <c:out value="${p.codigoModalidad != null ? p.codigoModalidad : 'Pendiente código'}" />
                                            </div>
                                        </td>
                                        <td>
                                            <strong style="color: var(--text-primary);"><c:out value="${p.titulo}" /></strong>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">Línea: <c:out value="${p.lineaInvestigacion}" /></div>
                                        </td>
                                        <td>
                                            <span class="badge-tag" style="margin: 0; font-size: 0.75rem;"><c:out value="${p.tipoNivel}" /></span>
                                            <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 4px;"><c:out value="${p.modalidad}" /></div>
                                        </td>
                                        <td>
                                            <span class="status-chip chip-pending">Fase ${p.fase} · <c:out value="${p.responsableTurno}" /></span>
                                        </td>
                                        <td>
                                            <span class="status-chip ${p.estado == 'En curso' ? 'chip-approved' : 'chip-neutral'}">
                                                <c:out value="${p.estado}" />
                                            </span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.84rem;">
                                                <strong>Dir:</strong> <c:out value="${p.directorNombre != null ? p.directorNombre : 'Por asignar'}" /><br>
                                                <strong>Eval:</strong> <c:out value="${p.evaluadorNombre != null ? p.evaluadorNombre : 'Por asignar'}" />
                                            </div>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/comite/seguimiento.jsp?id=${p.id}" class="btn btn-sm btn-outline-primary" title="Ver Expediente">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                                <span>Detalle</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

