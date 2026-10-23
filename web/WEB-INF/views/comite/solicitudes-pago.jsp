<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Solicitudes de Fase 1 – Validación de Pagos y Propuestas</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Revisión del comprobante bancario, pertinencia del tema y asignación obligatoria de Director y Evaluador.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/comite/dashboard" class="btn btn-secondary btn-sm">Volver al Tablero</a>
    </div>

    <c:if test="${param.error == 'mismodocente'}">
        <div class="alert alert-danger">
            <span><strong>Regla RN03 violada:</strong> El docente Director y el Evaluador no pueden ser la misma persona.</span>
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título / Objetivos</th>
                    <th>Estudiante(s)</th>
                    <th>Recibo de Pago</th>
                    <th>Asignación Docente y Aprobación</th>
                    <th>Rechazo</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="hayPendientes" value="false" />
                <c:forEach var="p" items="${proyectos}">
                    <c:if test="${p.estado == 'RADICADO'}">
                        <c:set var="hayPendientes" value="true" />
                        <tr>
                            <td><strong>#<c:out value="${p.id}" /></strong></td>
                            <td style="max-width: 280px;">
                                <strong><c:out value="${p.titulo}" /></strong>
                                <p style="font-size: 0.85rem; color: var(--uts-text-muted); margin-top: 4px;">
                                    <c:out value="${p.objetivo}" />
                                </p>
                            </td>
                            <td>
                                <div><strong><c:out value="${p.estudianteNombre}" /></strong></div>
                                <c:if test="${not empty p.companeroNombre}">
                                    <small style="color: var(--uts-text-muted);">Compañero: <c:out value="${p.companeroNombre}" /></small>
                                </c:if>
                            </td>
                            <td>
                                <a href="<c:out value='${p.urlPago}' />" target="_blank" rel="noopener noreferrer" class="btn btn-secondary btn-sm">
                                    Ver Recibo (Nube)
                                </a>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/comite/aprobar-fase1" method="POST" style="display: flex; flex-direction: column; gap: 6px;">
                                    <input type="hidden" name="proyectoId" value="${p.id}" />
                                    
                                    <select name="directorId" required class="form-control" style="font-size: 0.85rem; padding: 4px 8px;">
                                        <option value="">-- Seleccionar Director --</option>
                                        <c:forEach var="d" items="${directores}">
                                            <option value="${d.id}"><c:out value="${d.nombreCompleto}" /></option>
                                        </c:forEach>
                                    </select>

                                    <select name="evaluadorId" required class="form-control" style="font-size: 0.85rem; padding: 4px 8px;">
                                        <option value="">-- Seleccionar Evaluador --</option>
                                        <c:forEach var="e" items="${evaluadores}">
                                            <option value="${e.id}"><c:out value="${e.nombreCompleto}" /></option>
                                        </c:forEach>
                                    </select>

                                    <button type="submit" class="btn btn-primary btn-sm">Aprobar Propuesta</button>
                                </form>
                            </td>
                            <td>
                                <button type="button" class="btn btn-danger btn-sm" 
                                        onclick="abrirModalRechazo('${p.id}', '${pageContext.request.contextPath}/comite/rechazar-fase1');">
                                    Rechazar
                                </button>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>

                <c:if test="${!hayPendientes}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: var(--uts-text-muted); padding: 35px;">
                            No hay propuestas pendientes de aprobación en Fase 1.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
