<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardAdministrador.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>

<%
    String msgFormato = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        msgFormato = "Formato institucional guardado y publicado correctamente.";
    }
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Formatos de Grado - Administrador SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="formatos" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-04</span>
                <h2>Gestión de Formatos Institucionales de Grado</h2>
                <p>Administración del catálogo oficial de plantillas para entregables y actas evaluativas.</p>
            </div>
            <div>
                <button type="button" class="btn btn-primary" onclick="alert('Formulario de alta habilitado.')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Nuevo Formato</span>
                </button>
            </div>
        </div>

        <% if (msgFormato != null) { %>
            <div class="alert alert-success">
                <span>✔️</span>
                <div><%= msgFormato %></div>
            </div>
        <% } %>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Código Oficial</th>
                            <th>Nombre del Formato</th>
                            <th>Fases de Aplicación</th>
                            <th>URL Plantilla (Drive / Docs)</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong style="color: #006837; font-weight: 700; font-family: 'JetBrains Mono', monospace;">F-DC-124</strong></td>
                            <td><strong>Propuesta de Trabajo de Grado</strong></td>
                            <td>Fases 1, 2 y 3</td>
                            <td><a href="https://docs.google.com/document/d/plantilla-fdc-124-uts" target="_blank" rel="noopener" style="color: #006837; font-weight: 600; text-decoration: underline; font-size: 0.85rem;">Ver Plantilla Oficial &nearr;</a></td>
                            <td><span class="status-chip chip-approved">Activo</span></td>
                            <td><button class="btn btn-sm btn-secondary">Editar</button></td>
                        </tr>
                        <tr>
                            <td><strong style="color: #006837; font-weight: 700; font-family: 'JetBrains Mono', monospace;">F-DC-125</strong></td>
                            <td><strong>Informe Final de Trabajo de Grado</strong></td>
                            <td>Fases 4 y 5</td>
                            <td><a href="https://docs.google.com/document/d/plantilla-fdc-125-uts" target="_blank" rel="noopener" style="color: #006837; font-weight: 600; text-decoration: underline; font-size: 0.85rem;">Ver Plantilla Oficial &nearr;</a></td>
                            <td><span class="status-chip chip-approved">Activo</span></td>
                            <td><button class="btn btn-sm btn-secondary">Editar</button></td>
                        </tr>
                        <tr>
                            <td><strong style="color: #006837; font-weight: 700; font-family: 'JetBrains Mono', monospace;">F-DC-129</strong></td>
                            <td><strong>Rejilla Evaluativa para Sustentación</strong></td>
                            <td>Fase 5</td>
                            <td><a href="https://docs.google.com/document/d/plantilla-fdc-129-uts" target="_blank" rel="noopener" style="color: #006837; font-weight: 600; text-decoration: underline; font-size: 0.85rem;">Ver Plantilla Oficial &nearr;</a></td>
                            <td><span class="status-chip chip-approved">Activo</span></td>
                            <td><button class="btn btn-sm btn-secondary">Editar</button></td>
                        </tr>
                        <tr>
                            <td><strong style="color: #006837; font-weight: 700; font-family: 'JetBrains Mono', monospace;">F-DC-130</strong></td>
                            <td><strong>Acta de Cierre y Sustentación</strong></td>
                            <td>Fase 6</td>
                            <td><a href="https://docs.google.com/document/d/plantilla-fdc-130-uts" target="_blank" rel="noopener" style="color: #006837; font-weight: 600; text-decoration: underline; font-size: 0.85rem;">Ver Plantilla Oficial &nearr;</a></td>
                            <td><span class="status-chip chip-approved">Activo</span></td>
                            <td><button class="btn btn-sm btn-secondary">Editar</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

