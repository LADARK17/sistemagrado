<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardAdministrador.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.BancoIdea, java.util.Collection" %>

<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String ideaIdStr = request.getParameter("idea_id");
        String nuevoEstado = request.getParameter("decision");
        String obs = request.getParameter("observaciones");

        if (ideaIdStr != null && nuevoEstado != null) {
            int id = Integer.parseInt(ideaIdStr);
            BancoIdea idea = MockDataStore.IDEAS.get(id);
            if (idea != null) {
                idea.setEstado(nuevoEstado);
                msg = "Propuesta #" + id + " actualizada a estado: " + nuevoEstado + " exitosamente.";
            }
        }
    }

    Collection<BancoIdea> ideas = MockDataStore.IDEAS.values();
    request.setAttribute("ideas", ideas);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Revisión Propuestas del Banco - Administrador SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="propuestas_banco" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-07 / RF-ADM-08 / RF-ADM-09</span>
                <h2>Revisión de Propuestas al Banco de Ideas</h2>
                <p>Aprobación y retroalimentación de ideas formuladas por docentes y estudiantes.</p>
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
                            <th>Código</th>
                            <th>Título de la Idea</th>
                            <th>Origen y Proponente</th>
                            <th>Línea / Nivel</th>
                            <th>Comprobante de Pago</th>
                            <th>Estado</th>
                            <th>Decisión Administrador</th>
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
                                <td>
                                    <span class="status-chip chip-neutral"><c:out value="${item.creadoPorNombre}" /></span>
                                    <div style="font-size: 0.76rem; color: var(--text-muted); margin-top: 4px;">Docente Investigador</div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem;"><c:out value="${item.lineaInvestigacion}" /></div>
                                </td>
                                <td>
                                    <!-- RF-ADM-08 / RF-ADM-09 -->
                                    <span style="font-size: 0.82rem; color: #10b981;">No requiere (Docente)</span>
                                </td>
                                <td>
                                    <span class="status-chip ${item.estado == 'DISPONIBLE' || item.estado == 'Aprobada' ? 'chip-approved' : 'chip-pending'}">
                                        <c:out value="${item.estado}" />
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/administrador/propuestas_banco.jsp" method="POST" style="display: flex; gap: 6px; align-items: center;">
                                        <input type="hidden" name="idea_id" value="${item.id}" />
                                        <select name="decision" class="form-control" style="height: 34px; padding: 2px 8px; font-size: 0.82rem; width: auto;">
                                            <option value="Aprobada">Aprobar</option>
                                            <option value="Correcciones">Correcciones</option>
                                            <option value="Rechazada">Rechazar</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary">Aplicar</button>
                                    </form>
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

