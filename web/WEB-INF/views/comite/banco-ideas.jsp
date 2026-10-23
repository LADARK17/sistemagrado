<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Banco de Ideas de Grado UTS</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Propuestas temáticas orientadas a las líneas de investigación institucionales.
            </p>
        </div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('formNuevaIdea').style.display='block';">+ Proponer Nueva Idea</button>
    </div>

    <!-- FORMULARIO DESPLEGABLE NUEVA IDEA -->
    <div id="formNuevaIdea" class="uts-card" style="display: none; background: #fafbfc; border-left: 5px solid var(--uts-green-primary);">
        <h4 style="margin-bottom: 15px; color: var(--uts-green-dark);">Registrar Nueva Idea para Estudiantes</h4>
        <form action="${pageContext.request.contextPath}/comite/banco-ideas/guardar" method="POST">
            <div class="form-group">
                <label for="titulo">Título de la Idea:</label>
                <input type="text" id="titulo" name="titulo" required class="form-control" placeholder="ej. Sistema IoT para telemetría de paneles solares" />
            </div>

            <div class="form-group">
                <label for="lineaInvestigacion">Línea de Investigación:</label>
                <input type="text" id="lineaInvestigacion" name="lineaInvestigacion" required class="form-control" placeholder="ej. Energías Renovables y Domótica" />
            </div>

            <div class="form-group">
                <label for="descripcion">Descripción y Alcance:</label>
                <textarea id="descripcion" name="descripcion" rows="3" required class="form-control" placeholder="Describa el problema, objetivo y requerimientos básicos..."></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('formNuevaIdea').style.display='none';">Cancelar</button>
                <button type="submit" class="btn btn-primary">Publicar Idea</button>
            </div>
        </form>
    </div>

    <!-- LISTADO DE IDEAS -->
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Línea de Investigación</th>
                    <th>Descripción</th>
                    <th>Estado</th>
                    <th>Propuesto Por</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty ideas}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--uts-text-muted); padding: 25px;">
                                No hay ideas registradas en el banco.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="idea" items="${ideas}">
                            <tr>
                                <td><strong><c:out value="${idea.id}" /></strong></td>
                                <td><strong><c:out value="${idea.titulo}" /></strong></td>
                                <td><c:out value="${idea.lineaInvestigacion}" /></td>
                                <td style="max-width: 300px; font-size: 0.88rem;"><c:out value="${idea.descripcion}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${idea.estado == 'DISPONIBLE'}">
                                            <span class="badge" style="background-color: var(--uts-success); color: #fff;">DISPONIBLE</span>
                                        </c:when>
                                        <c:when test="${idea.estado == 'ASIGNADA'}">
                                            <span class="badge" style="background-color: var(--uts-gold); color: #000;">ASIGNADA</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge" style="background-color: #6c757d; color: #fff;">INACTIVA</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${idea.creadoPorNombre}" /></td>
                                <td><fmt:formatDate value="${idea.createdAt}" pattern="dd/MM/yyyy" /></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
