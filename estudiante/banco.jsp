<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardEstudiante.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.BancoIdea, java.util.Collection" %>

<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("elegir".equalsIgnoreCase(action)) {
            String ideaIdStr = request.getParameter("idea_id");
            if (ideaIdStr != null) {
                int id = Integer.parseInt(ideaIdStr);
                BancoIdea bi = MockDataStore.IDEAS.get(id);
                if (bi != null) {
                    bi.setEstado("ASIGNADA");
                    response.sendRedirect(request.getContextPath() + "/estudiante/proyecto.jsp?action=iniciar_radicacion&idea_id=" + id);
                    return;
                }
            }
        } else if ("proponer".equalsIgnoreCase(action)) {
            String titulo = request.getParameter("titulo");
            String linea = request.getParameter("linea");
            String desc = request.getParameter("descripcion");
            if (titulo != null && !titulo.trim().isEmpty()) {
                int newId = MockDataStore.nextIdeaId();
                BancoIdea bi = new BancoIdea();
                bi.setId(newId);
                bi.setTitulo(titulo.trim());
                bi.setLineaInvestigacion(linea != null && !linea.trim().isEmpty() ? linea.trim() : "Ingeniería de Software");
                bi.setDescripcion(desc != null ? desc.trim() : "");
                bi.setEstado("DISPONIBLE");
                bi.setCreadoPor((Integer) session.getAttribute("usuario_id"));
                bi.setCreadoPorNombre((String) session.getAttribute("nombre"));
                MockDataStore.IDEAS.put(newId, bi);
                response.sendRedirect(request.getContextPath() + "/estudiante/proyecto.jsp?action=iniciar_radicacion&idea_id=" + newId + "&propia=true");
                return;
            }
        }
    }

    Collection<BancoIdea> ideas = MockDataStore.IDEAS.values();
    request.setAttribute("ideas", ideas);
    request.setAttribute("msg", msg);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Banco de Ideas - Estudiante SIGRADO" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="banco" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-EST-01 / RF-EST-02</span>
                <h2>Banco de Ideas de Grado UTS</h2>
                <p>Selecciona una propuesta aprobada por grupos de investigación o formula y radica tu iniciativa propia.</p>
            </div>
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/estudiante/proyecto.jsp?action=iniciar_radicacion" class="btn btn-secondary" style="text-decoration: none;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    <span>Formulario de Radicación</span>
                </a>
                <button type="button" class="btn btn-primary" onclick="toggleFormPropia()">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Proponer Idea Propia</span>
                </button>
            </div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success">
                <span>✔️</span>
                <div><c:out value="${msg}" /></div>
            </div>
        </c:if>

        <!-- Formulario Desplegable para Idea Propia (RF-EST-02) -->
        <div id="formIdeaPropiaBox" class="uts-card" style="display: none; margin-bottom: 24px; border-color: rgba(34, 197, 94, 0.4);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                <h3 style="margin: 0; color: #006837; font-weight: 700;">Formular Idea Propia de Grado (RF-EST-02)</h3>
                <span class="badge-tag">Iniciativa Estudiantil</span>
            </div>
            <p style="font-size: 0.88rem; color: #475569; margin-bottom: 18px;">
                Define tu tema de investigación independiente. Al registrarlo, serás redirigido inmediatamente al formulario de radicación oficial (Fase 1).
            </p>
            <form action="${pageContext.request.contextPath}/estudiante/banco.jsp" method="POST" class="uts-form">
                <input type="hidden" name="action" value="proponer" />

                <div class="form-group">
                    <label for="tituloPropia">Título de la Idea Propia:</label>
                    <input type="text" id="tituloPropia" name="titulo" required placeholder="Ej. Aplicación Móvil con IA para Diagnóstico Temprano en Cultivos Santandereanos" class="form-control" />
                </div>

                <div class="form-grid" style="margin-top: 14px;">
                    <div class="form-group">
                        <label for="lineaPropia">Línea de Investigación:</label>
                        <input type="text" id="lineaPropia" name="linea" required placeholder="Ej. Inteligencia Artificial / Software" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label for="modalidadPropia">Modalidad:</label>
                        <select id="modalidadPropia" name="modalidad" class="form-control">
                            <option value="Desarrollo tecnologico">Desarrollo Tecnológico</option>
                            <option value="Investigacion">Investigación</option>
                            <option value="Emprendimiento">Emprendimiento</option>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="descPropia">Descripción y Justificación:</label>
                    <textarea id="descPropia" name="descripcion" rows="3" required placeholder="Describe la problemática a resolver, justificación y alcance tecnológico propuesto..." class="form-control"></textarea>
                </div>

                <div style="margin-top: 18px; display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn btn-secondary" onclick="toggleFormPropia()">Cancelar</button>
                    <button type="submit" class="btn btn-primary">
                        <span>Registrar y Proceder a Radicación</span>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </button>
                </div>
            </form>
        </div>

        <!-- Catálogo de Ideas Disponibles (RF-EST-01) -->
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
                    <div>
                        <div style="border-top: 1px solid #e2e8f0; padding-top: 10px; margin-bottom: 14px; font-size: 0.82rem; color: #334155;">
                            <div style="margin-bottom: 4px;"><strong style="color: #0f172a;">Línea:</strong> <c:out value="${idea.lineaInvestigacion}" /></div>
                            <div><strong style="color: #0f172a;">Docente Proponente:</strong> <c:out value="${idea.creadoPorNombre}" /></div>
                        </div>

                        <c:choose>
                            <c:when test="${idea.estado == 'DISPONIBLE'}">
                                <a href="${pageContext.request.contextPath}/estudiante/proyecto.jsp?action=iniciar_radicacion&idea_id=${idea.id}" class="btn btn-sm btn-primary" style="width: 100%; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 6px;">
                                    <span>Seleccionar y Radicar (Fase 1)</span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" disabled class="btn btn-sm btn-secondary" style="width: 100%; opacity: 0.6;">
                                    <span>No disponible (Asignada)</span>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<script>
function toggleFormPropia() {
    var box = document.getElementById('formIdeaPropiaBox');
    if (box.style.display === 'none') {
        box.style.display = 'block';
        window.scrollTo({ top: box.offsetTop - 80, behavior: 'smooth' });
    } else {
        box.style.display = 'none';
    }
}
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />
