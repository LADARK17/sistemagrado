<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardComite.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.BancoIdea, java.util.Collection" %>

<%
    Collection<BancoIdea> ideas = MockDataStore.IDEAS.values();
    request.setAttribute("ideas", ideas);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Propuestas del Banco - Comité SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="propuestas_banco" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-COM-07</span>
                <h2>Propuestas Formuladas al Banco de Ideas</h2>
                <p>Historial y conceptos emitidos sobre las líneas temáticas postuladas.</p>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Título de la Propuesta</th>
                            <th>Proponente</th>
                            <th>Línea de Investigación</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${ideas}">
                            <tr>
                                <td><strong>BAN-0000${item.id}</strong></td>
                                <td>
                                    <strong><c:out value="${item.titulo}" /></strong>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${item.descripcion}" /></div>
                                </td>
                                <td><c:out value="${item.creadoPorNombre}" /></td>
                                <td><c:out value="${item.lineaInvestigacion}" /></td>
                                <td>
                                    <span class="status-chip ${item.estado == 'DISPONIBLE' ? 'chip-approved' : 'chip-neutral'}">
                                        <c:out value="${item.estado}" />
                                    </span>
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

