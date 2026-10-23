<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Programación y Calificación de Sustentaciones</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Fase Final: Asignación de fecha, hora, enlace de sala virtual / aula física y registro de actas de sustentación.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/comite/dashboard" class="btn btn-secondary btn-sm">Volver al Tablero</a>
    </div>

    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título del Proyecto</th>
                    <th>Estudiante(s)</th>
                    <th>Estado</th>
                    <th>Detalles de Sustentación</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="haySustentaciones" value="false" />
                <c:forEach var="p" items="${proyectos}">
                    <c:if test="${p.estado == 'LISTO_PARA_SUSTENTAR' || p.estado == 'SUSTENTACION_PROGRAMADA' || p.estado == 'SUSTENTADO_PENDIENTE_CIERRE'}">
                        <c:set var="haySustentaciones" value="true" />
                        <tr>
                            <td><strong>#<c:out value="${p.id}" /></strong></td>
                            <td style="max-width: 250px;"><strong><c:out value="${p.titulo}" /></strong></td>
                            <td><c:out value="${p.estudianteNombre}" /></td>
                            <td>
                                <span class="badge badge-${p.estado}">
                                    <c:out value="${p.estado}" />
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.estado == 'SUSTENTACION_PROGRAMADA'}">
                                        <div><strong>Fecha:</strong> <fmt:formatDate value="${p.fechaSustentacion}" pattern="dd/MM/yyyy HH:mm" /></div>
                                        <div><strong>Lugar / Enlace:</strong> <c:out value="${p.lugarSustentacion}" /></div>
                                    </c:when>
                                    <c:when test="${p.estado == 'SUSTENTADO_PENDIENTE_CIERRE'}">
                                        <div><strong>Nota Obtenida:</strong> <c:out value="${p.calificacionSustentacion}" /> / 5.0</div>
                                        <div style="color: var(--uts-success); font-weight: 600;">Sustentación Aprobada</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--uts-text-muted);">Pendiente de programación</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${p.estado == 'LISTO_PARA_SUSTENTAR'}">
                                    <!-- FORMULARIO DE PROGRAMACIÓN -->
                                    <form action="${pageContext.request.contextPath}/comite/programar-sustentacion" method="POST" style="display: flex; flex-direction: column; gap: 5px;">
                                        <input type="hidden" name="proyectoId" value="${p.id}" />
                                        <input type="datetime-local" name="fechaSustentacion" required class="form-control" style="font-size: 0.8rem; padding: 4px;" />
                                        <input type="text" name="lugarSustentacion" placeholder="Auditorio o Enlace Teams" required class="form-control" style="font-size: 0.8rem; padding: 4px;" />
                                        <button type="submit" class="btn btn-primary btn-sm">Programar</button>
                                    </form>
                                </c:if>

                                <c:if test="${p.estado == 'SUSTENTACION_PROGRAMADA'}">
                                    <!-- REGISTRO DE NOTA -->
                                    <form action="${pageContext.request.contextPath}/comite/calificar-sustentacion" method="POST" style="display: flex; gap: 5px; align-items: center;">
                                        <input type="hidden" name="proyectoId" value="${p.id}" />
                                        <input type="number" step="0.1" min="0" max="5.0" name="notaSustentacion" required class="form-control" placeholder="Nota (0.0 - 5.0)" style="width: 90px; font-size: 0.85rem;" />
                                        <button type="submit" class="btn btn-warning btn-sm">Calificar</button>
                                    </form>
                                </c:if>

                                <c:if test="${p.estado == 'SUSTENTADO_PENDIENTE_CIERRE'}">
                                    <a href="${pageContext.request.contextPath}/comite/detalle-proyecto?id=${p.id}" class="btn btn-primary btn-sm">Verificar y Cerrar</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>

                <c:if test="${!haySustentaciones}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: var(--uts-text-muted); padding: 30px;">
                            No hay proyectos en proceso de sustentación actualmente.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
