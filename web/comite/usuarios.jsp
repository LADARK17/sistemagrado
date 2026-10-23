<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardComite.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Usuario, java.util.Collection" %>

<%
    Collection<Usuario> usuarios = MockDataStore.USUARIOS.values();
    request.setAttribute("usuarios", usuarios);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Directorio de Usuarios - Comité SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="usuarios" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-COM-07</span>
                <h2>Directorio de Usuarios Académicos</h2>
                <p>Consulta de docentes disponibles para asignación y estudiantes activos en el sistema.</p>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Documento</th>
                            <th>Nombre Completo</th>
                            <th>Correo Institucional</th>
                            <th>Roles Asignados</th>
                            <th>Programa</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${usuarios}">
                            <tr>
                                <td><strong><c:out value="${u.documento}" /></strong></td>
                                <td><c:out value="${u.nombreCompleto}" /></td>
                                <td><a href="mailto:${u.correo}" style="color: #38bdf8;"><c:out value="${u.correo}" /></a></td>
                                <td>
                                    <c:forEach var="r" items="${u.roles}">
                                        <span class="status-chip chip-approved" style="margin-right: 4px;"><c:out value="${r}" /></span>
                                    </c:forEach>
                                </td>
                                <td><c:out value="${u.programa}" /></td>
                                <td><span class="status-chip chip-approved">Activo</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

