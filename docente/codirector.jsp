<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardDocente.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto, java.util.Collection" %>

<%
    Collection<Proyecto> proyectos = MockDataStore.PROYECTOS.values();
    request.setAttribute("proyectos", proyectos);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Docente Codirector - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="codirector" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-DOC-03</span>
                <h2>Proyectos con Asignación de Codirector</h2>
                <p>Seguimiento y co-orientación académica de proyectos de grado en curso.</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Rol: Docente Codirector</span>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Expediente</th>
                            <th>Proyecto</th>
                            <th>Fase Actual</th>
                            <th>Director Principal</th>
                            <th>Turno Actual</th>
                            <th>Trazabilidad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${proyectos}">
                            <tr>
                                <td><strong>GRA-0000${p.id}</strong></td>
                                <td><strong style="color: var(--text-primary);"><c:out value="${p.titulo}" /></strong></td>
                                <td><span class="status-chip chip-pending">Fase ${p.fase}</span></td>
                                <td><c:out value="${p.directorNombre}" /></td>
                                <td><c:out value="${p.responsableTurno}" /></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/comite/seguimiento.jsp?id=${p.id}" class="btn btn-sm btn-outline-primary">Ver Expediente</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

