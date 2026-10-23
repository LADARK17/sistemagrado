<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardAdministrador.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.BancoIdea, java.util.Collection" %>

<%
    Collection<BancoIdea> ideas = MockDataStore.IDEAS.values();
    request.setAttribute("ideas", ideas);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Banco de Ideas - Administrador SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="banco" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-10</span>
                <h2>Catálogo del Banco de Ideas Institucionales</h2>
                <p>Monitoreo de disponibilidad y asignaciones a estudiantes del programa.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/administrador/propuestas_banco.jsp" class="btn btn-primary">
                    <span>Revisar Nuevas Propuestas</span>
                </a>
            </div>
        </div>

        <div class="formatos-grid">
            <c:forEach var="idea" items="${ideas}">
                <div class="formato-item">
                    <div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <span class="formato-code">BAN-0000${idea.id}</span>
                            <span class="status-chip ${idea.estado == 'DISPONIBLE' ? 'chip-approved' : 'chip-neutral'}">
                                <c:out value="${idea.estado}" />
                            </span>
                        </div>
                        <h4 style="color: #0f172a; font-weight: 700; font-size: 1.05rem; line-height: 1.4; margin-bottom: 8px;"><c:out value="${idea.titulo}" /></h4>
                        <p style="font-size: 0.88rem; color: #475569; line-height: 1.5; margin-bottom: 12px;">
                            <c:out value="${idea.descripcion}" />
                        </p>
                    </div>
                    <div style="border-top: 1px solid #e2e8f0; padding-top: 12px; font-size: 0.82rem; color: #334155;">
                        <div style="margin-bottom: 4px;"><strong style="color: #0f172a;">Línea:</strong> <c:out value="${idea.lineaInvestigacion}" /></div>
                        <div><strong style="color: #0f172a;">Docente:</strong> <c:out value="${idea.creadoPorNombre}" /></div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

