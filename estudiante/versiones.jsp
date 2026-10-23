<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardEstudiante.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.HistorialVersion, java.util.List" %>

<%
    List<HistorialVersion> historial = MockDataStore.HISTORIAL;
    request.setAttribute("historial", historial);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Historial de Versiones - Estudiante SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="versiones" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-EST-10 / RF-GEN-06</span>
                <h2>Historial y Control de Versiones Documentales</h2>
                <p>Trazabilidad inmutable de cada entrega realizada en las rondas de corrección del proyecto.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/estudiante/proyecto.jsp" class="btn btn-secondary">&larr; Volver a Mi Proyecto</a>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Versión</th>
                            <th>Fase Asociada</th>
                            <th>Enlace Documental (URL)</th>
                            <th>Radicado Por</th>
                            <th>Fecha de Registro</th>
                            <th>Notas / Observaciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty historial}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 24px; color: var(--text-muted);">
                                        No se registran versiones históricas previas.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="v" items="${historial}" varStatus="status">
                                    <tr>
                                        <td><span class="badge-tag" style="margin: 0; font-family: 'JetBrains Mono', monospace; font-weight: 800;">v${status.count}.0</span></td>
                                        <td><span class="status-chip chip-pending"><c:out value="${v.fase}" /></span></td>
                                        <td>
                                            <a href="${v.urlDocumento}" target="_blank" rel="noopener" style="color: #006837; font-weight: 600; text-decoration: underline; font-size: 0.85rem;">
                                                <span>Ver Documento en Nube &nearr;</span>
                                            </a>
                                        </td>
                                        <td><strong><c:out value="${not empty v.subidoPorNombre ? v.subidoPorNombre : 'Estudiante UTS'}" /></strong></td>
                                        <td><span style="font-size: 0.85rem; color: #475569;"><c:out value="${v.fechaSubida}" /></span></td>
                                        <td><c:out value="${not empty v.observacionesEstudiante ? v.observacionesEstudiante : v.observaciones}" /></td>
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

