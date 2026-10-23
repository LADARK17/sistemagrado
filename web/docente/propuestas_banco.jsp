<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardDocente.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.BancoIdea, java.util.Collection" %>

<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String titulo = request.getParameter("titulo");
        String modalidad = request.getParameter("tipo_modalidad");
        String nivel = request.getParameter("tipo_nivel");
        String linea = request.getParameter("linea_investigacion");
        String objetivo = request.getParameter("objetivo_general");
        String desc = request.getParameter("descripcion");

        if (titulo != null && objetivo != null) {
            int newId = MockDataStore.nextIdeaId();
            BancoIdea bi = new BancoIdea();
            bi.setId(newId);
            bi.setTitulo(titulo.trim());
            bi.setLineaInvestigacion(linea != null ? linea.trim() : "Ingeniería de Software");
            bi.setDescripcion(desc != null ? desc.trim() : objetivo.trim());
            bi.setEstado("Pendiente");
            bi.setCreadoPor((Integer) session.getAttribute("usuario_id"));
            bi.setCreadoPorNombre((String) session.getAttribute("nombre"));
            MockDataStore.IDEAS.put(newId, bi);
            msg = "¡Propuesta de idea enviada exitosamente al Administrador para su revisión!";
        }
    }

    Collection<BancoIdea> ideas = MockDataStore.IDEAS.values();
    request.setAttribute("ideas", ideas);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Mis Propuestas de Ideas - Docente SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="propuestas_banco" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-DOC-01 / RF-DOC-02</span>
                <h2>Mis Propuestas al Banco de Ideas</h2>
                <p>Postula nuevas líneas de investigación y proyectos para que sean elegidos por estudiantes.</p>
            </div>
            <div>
                <button type="button" class="btn btn-primary" onclick="toggleFormPropuesta()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Nueva Propuesta</span>
                </button>
            </div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success">
                <span>✔️</span>
                <div><c:out value="${msg}" /></div>
            </div>
        </c:if>

        <!-- Formulario Desplegable para Nueva Propuesta -->
        <div id="formNuevaPropuestaBox" class="uts-card" style="display: none; margin-bottom: 24px; border-color: rgba(34, 197, 94, 0.4);">
            <h3 style="margin-bottom: 16px;">Formular Nueva Idea de Grado (Periodo 2026-2)</h3>
            <form action="${pageContext.request.contextPath}/docente/propuestas_banco.jsp" method="POST" class="uts-form">
                <div class="form-group">
                    <label for="tituloIdea">Título de la Idea de Grado (*):</label>
                    <input type="text" id="tituloIdea" name="titulo" required placeholder="Ej. Sistema IoT para Optimización Energética..." class="form-control" />
                </div>

                <div class="form-grid" style="margin-top: 14px;">
                    <div class="form-group">
                        <label for="modalidadIdea">Modalidad de Grado:</label>
                        <select id="modalidadIdea" name="tipo_modalidad" class="form-control" required>
                            <option value="Desarrollo tecnologico">Desarrollo Tecnológico</option>
                            <option value="Investigacion">Investigación</option>
                            <option value="Emprendimiento">Emprendimiento</option>
                            <option value="Otro">Otro</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="nivelIdea">Nivel Académico:</label>
                        <select id="nivelIdea" name="tipo_nivel" class="form-control" required>
                            <option value="Tecnologico">Tecnológico (Código 65)</option>
                            <option value="Profesional">Profesional (Código 125)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="lineaIdea">Línea de Investigación:</label>
                    <input type="text" id="lineaIdea" name="linea_investigacion" required placeholder="Ej. Telecomunicaciones e IoT / Ingeniería de Software" class="form-control" />
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="objIdea">Objetivo General (*):</label>
                    <textarea id="objIdea" name="objetivo_general" rows="2" required placeholder="Describe el alcance y objetivo principal que abordarán los estudiantes..." class="form-control"></textarea>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="descIdea">Descripción y Tecnologías Sugeridas:</label>
                    <textarea id="descIdea" name="descripcion" rows="3" placeholder="Requerimientos tecnológicos, plataformas, sensores, microservicios..." class="form-control"></textarea>
                </div>

                <div style="margin-top: 20px; display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn btn-secondary" onclick="toggleFormPropuesta()">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Radicar Idea al Banco</button>
                </div>
            </form>
        </div>

        <!-- Listado de Ideas del Docente -->
        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Título de la Idea</th>
                            <th>Línea de Investigación</th>
                            <th>Estado Actual</th>
                            <th>Disponibilidad</th>
                            <th>Observación de Revisión</th>
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
                                <td><c:out value="${item.lineaInvestigacion}" /></td>
                                <td>
                                    <span class="status-chip ${item.estado == 'DISPONIBLE' || item.estado == 'Aprobada' ? 'chip-approved' : 'chip-pending'}">
                                        <c:out value="${item.estado}" />
                                    </span>
                                </td>
                                <td>
                                    <span style="font-size: 0.82rem; color: #10b981;">Disponible para Estudiantes</span>
                                </td>
                                <td>
                                    <span style="font-size: 0.8rem; color: var(--text-muted);">Revisión conforme por el Administrador.</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script>
function toggleFormPropuesta() {
    var box = document.getElementById('formNuevaPropuestaBox');
    if (box.style.display === 'none') {
        box.style.display = 'block';
        window.scrollTo({ top: box.offsetTop - 80, behavior: 'smooth' });
    } else {
        box.style.display = 'none';
    }
}
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

