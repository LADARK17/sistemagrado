<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Expediente del Proyecto #<c:out value="${proyecto.id}" /></h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Trazabilidad completa, documentos en la nube y dictamen institucional.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/comite/dashboard" class="btn btn-secondary btn-sm">Volver</a>
    </div>

    <div style="margin-bottom: 20px;">
        <h3 style="color: var(--uts-green-dark);"><c:out value="${proyecto.titulo}" /></h3>
        <p style="margin-top: 6px; color: var(--uts-text-muted); font-size: 0.95rem;">
            <strong>Objetivo:</strong> <c:out value="${proyecto.objetivo}" />
        </p>
    </div>

    <!-- METRICAS DE PLAZOS -->
    <div class="time-cards">
        <div class="metric-card">
            <h4>Fase Actual</h4>
            <div class="metric-value" style="font-size: 1.15rem; color: var(--uts-info);">
                <c:out value="${proyecto.faseActual}" />
            </div>
            <span class="badge badge-${proyecto.estado}" style="margin-top: 8px;">
                <c:out value="${proyecto.estado}" />
            </span>
        </div>

        <div class="metric-card">
            <h4>Vigencia (180 Días Calendario)</h4>
            <div class="metric-value <c:if test='${proyecto.diasVigenciaRestantes <= 20}'>danger-text</c:if>">
                <c:out value="${proyecto.diasVigenciaRestantes}" /> días
            </div>
            <small style="color: var(--uts-text-muted);">
                Límite: <fmt:formatDate value="${proyecto.fechaLimiteVigencia}" pattern="dd/MM/yyyy" />
            </small>
        </div>

        <div class="metric-card">
            <h4>Legalización F-DC-124 (12 Semanas)</h4>
            <div class="metric-value">
                <c:out value="${proyecto.diasFdc124Restantes}" /> días
            </div>
            <small style="color: var(--uts-text-muted);">
                Límite: <fmt:formatDate value="${proyecto.fechaLimiteFdc124}" pattern="dd/MM/yyyy" />
            </small>
        </div>
    </div>

    <!-- INFORMACIÓN DE PARTICIPANTES -->
    <div class="uts-card" style="background: #fafbfc; margin: 20px 0;">
        <h4 style="color: var(--uts-charcoal); margin-bottom: 12px;">Comité y Estudiantes Asignados</h4>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; font-size: 0.9rem;">
            <div>
                <strong>Estudiante Principal:</strong><br>
                <c:out value="${proyecto.estudianteNombre}" /> (Doc: <c:out value="${proyecto.estudianteDocumento}" />)
            </div>
            <div>
                <strong>Compañero Vinculado:</strong><br>
                <c:out value="${not empty proyecto.companeroNombre ? proyecto.companeroNombre : 'Modalidad Individual'}" />
            </div>
            <div>
                <strong>Docente Director:</strong><br>
                <c:out value="${not empty proyecto.directorNombre ? proyecto.directorNombre : 'Pendiente'}" />
            </div>
            <div>
                <strong>Docente Evaluador:</strong><br>
                <c:out value="${not empty proyecto.evaluadorNombre ? proyecto.evaluadorNombre : 'Pendiente'}" />
            </div>
        </div>
    </div>

    <!-- ACCIÓN DE CIERRE DEFINITIVO POR COMITÉ -->
    <c:if test="${proyecto.estado == 'SUSTENTADO_PENDIENTE_CIERRE'}">
        <div class="alert alert-success" style="flex-direction: column; align-items: flex-start; gap: 10px;">
            <h4>¡Sustentación aprobada con nota: <c:out value="${proyecto.calificacionSustentacion}" /> / 5.0!</h4>
            <p style="font-size: 0.9rem;">
                Para finalizar el proyecto, verifique que los requisitos offline estén cumplidos y digite la URL del repositorio institucional UTS.
            </p>
            <form action="${pageContext.request.contextPath}/comite/decretar-cierre" method="POST" style="width: 100%; display: flex; gap: 10px; margin-top: 5px;">
                <input type="hidden" name="proyectoId" value="${proyecto.id}" />
                <input type="url" name="urlRepositorio" required class="form-control" placeholder="https://repositorio.uts.edu.co/handle/..." />
                <button type="submit" class="btn btn-primary" onclick="return confirm('¿Decretar cierre exitoso y definitivo de este trabajo de grado?');">
                    Decretar Cierre Definitivo
                </button>
            </form>
        </div>
    </c:if>

    <c:if test="${proyecto.estado == 'FINALIZADO_CERRADO'}">
        <div class="alert alert-success">
            <div>
                <strong>PROYECTO CERRADO Y FINALIZADO CON ÉXITO</strong><br>
                <span>Repositorio Institucional: </span>
                <a href="<c:out value='${proyecto.urlRepositorioFinal}' />" target="_blank" rel="noopener noreferrer" style="color: #155724; font-weight: bold; text-decoration: underline;">
                    <c:out value="${proyecto.urlRepositorioFinal}" />
                </a>
            </div>
        </div>
    </c:if>

    <!-- HISTORIAL DE DOCUMENTOS -->
    <h4 style="margin-top: 25px; margin-bottom: 12px; color: var(--uts-green-dark);">Historial de Documentos y Correcciones en la Nube</h4>
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Fase</th>
                    <th>Documento en la Nube</th>
                    <th>Subido Por</th>
                    <th>Observaciones del Estudiante</th>
                    <th>Fecha y Hora</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty historialVersiones}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--uts-text-muted); padding: 20px;">
                                No se registran versiones cargadas.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="h" items="${historialVersiones}">
                            <tr>
                                <td><c:out value="${h.fase}" /></td>
                                <td>
                                    <a href="<c:out value='${h.urlDocumento}' />" target="_blank" rel="noopener noreferrer" class="btn btn-secondary btn-sm">
                                        Abrir Documento
                                    </a>
                                </td>
                                <td><c:out value="${h.subidoPorNombre}" /></td>
                                <td style="font-size: 0.88rem;"><c:out value="${h.observacionesEstudiante}" /></td>
                                <td><fmt:formatDate value="${h.fechaSubida}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
