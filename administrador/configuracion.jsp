<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardAdministrador.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>

<%
    String msgConfig = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        msgConfig = "Fechas del periodo 2026-2 actualizadas correctamente en el calendario del sistema.";
    }
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Calendario Académico - Administrador SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="configuracion" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-03</span>
                <h2>Configuración del Calendario Académico (Periodos)</h2>
                <p>Ventanas de tiempo para postulación de ideas, radicación y aprobación de propuestas. Solo un periodo activo a la vez.</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Periodo Activo: 2026-2</span>
            </div>
        </div>

        <% if (msgConfig != null) { %>
            <div class="alert alert-success">
                <span>✔️</span>
                <div><%= msgConfig %></div>
            </div>
        <% } %>

        <div class="uts-card" style="max-width: 800px;">
            <form action="${pageContext.request.contextPath}/administrador/configuracion.jsp" method="POST" class="uts-form">
                <div class="form-section-title">Parámetros del Periodo Académico Vigente</div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="codigo_periodo">Código del Periodo:</label>
                        <input type="text" id="codigo_periodo" name="codigo" value="2026-2" required class="form-control" style="font-weight: 700;">
                    </div>
                    <div class="form-group">
                        <label>Estado del Periodo:</label>
                        <input type="text" value="ACTIVO Y EN CURSO" disabled class="input-disabled">
                    </div>
                </div>

                <div class="form-section-title" style="margin-top: 20px;">1. Ventana del Banco de Ideas (Docentes y Estudiantes)</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="inicio_banco">Fecha de Inicio:</label>
                        <input type="date" id="inicio_banco" name="inicio_banco" value="2026-08-01" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="fin_banco">Fecha de Cierre:</label>
                        <input type="date" id="fin_banco" name="fin_banco" value="2026-09-15" required class="form-control">
                    </div>
                </div>

                <div class="form-section-title" style="margin-top: 20px;">2. Ventana de Nuevos Proyectos y Radicación (Fase 1)</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="inicio_proy">Fecha de Inicio:</label>
                        <input type="date" id="inicio_proy" name="inicio_proy" value="2026-08-15" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="fin_proy">Fecha Límite de Radicación:</label>
                        <input type="date" id="fin_proy" name="fin_proy" value="2026-10-31" required class="form-control">
                    </div>
                </div>

                <div class="form-section-title" style="margin-top: 20px;">3. Fecha Límite de Aprobación por Comité</div>
                <div class="form-group">
                    <label for="fin_aprobacion">Fecha Límite Definitiva:</label>
                    <input type="date" id="fin_aprobacion" name="fin_aprobacion" value="2026-11-20" required class="form-control">
                </div>

                <div style="margin-top: 28px; display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="submit" class="btn btn-primary">
                        <span>Actualizar Calendario</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

