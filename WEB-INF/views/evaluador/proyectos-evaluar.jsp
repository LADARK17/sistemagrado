<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<!-- HERO BANNER EVALUADOR -->
<div class="section-hero">
    <span class="hero-pill">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect><path d="m9 14 2 2 4-4"></path></svg>
        <span>Evaluación de Pares Académicos</span>
    </span>
    <h1 class="hero-title">Proyectos de Grado a Evaluar</h1>
    <p class="hero-desc">
        Revisión rigurosa de Anteproyecto (Fase 3, con aval previo del Director) y Calificación de Informe Final (Fase 5) para habilitar la sustentación pública.
    </p>
    <div style="margin-top: 14px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.85); display: flex; align-items: center; gap: 8px;">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
        <span><strong>Reglamentación UTS:</strong> El Evaluador dispone de <strong>5 días hábiles</strong> tras el aval del Director para registrar su calificación aprobatoria, de aplazamiento o de rechazo.</span>
    </div>
</div>

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Expedientes para Dictamen de Evaluación</h2>
            <p style="color: var(--text-muted); font-size: 0.88rem;">
                Consulte las versiones radicadas por los estudiantes y el concepto previo emitido por el Director.
            </p>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 70px;">Radicado</th>
                    <th>Título del Proyecto</th>
                    <th>Estudiante(s)</th>
                    <th>Director de Grado</th>
                    <th>Fase en Curso</th>
                    <th>Estado de Trámite</th>
                    <th>Alerta</th>
                    <th style="text-align: right;">Acción</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty proyectos}">
                        <tr>
                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                No tiene proyectos asignados como Evaluador en este momento.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${proyectos}">
                            <tr>
                                <td>
                                    <strong style="color: var(--uts-green-700); font-size: 0.9rem;">
                                        #<c:out value="${p.id}" />
                                    </strong>
                                </td>
                                <td style="max-width: 260px;">
                                    <strong style="color: var(--text-heading); display: block; line-height: 1.35;">
                                        <c:out value="${p.titulo}" />
                                    </strong>
                                </td>
                                <td>
                                    <div style="font-weight: 600;"><c:out value="${p.estudianteNombre}" /></div>
                                    <c:if test="${not empty p.companeroNombre}">
                                        <div style="font-size: 0.78rem; color: var(--uts-gold-600); font-weight: 600;">
                                            + <c:out value="${p.companeroNombre}" />
                                        </div>
                                    </c:if>
                                </td>
                                <td style="font-size: 0.88rem; color: #334155;">
                                    <c:out value="${p.directorNombre}" />
                                </td>
                                <td>
                                    <span style="font-size: 0.8rem; font-weight: 700; color: #475569; background: #f1f5f9; padding: 3px 8px; border-radius: 6px;">
                                        <c:out value="${p.faseActual}" />
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-${p.estado}">
                                        <c:out value="${p.estado}" />
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${p.enMoraDocente}">
                                        <span class="badge badge-mora">¡Mora (+5 Días Hábiles)!</span>
                                    </c:if>
                                    <c:if test="${!p.enMoraDocente && (p.estado == 'EN_EVALUACION_EVALUADOR' || p.estado == 'EN_REVISION_INFORME_EVA')}">
                                        <span class="badge badge-EN_EVALUACION_EVALUADOR">Pendiente su dictamen</span>
                                    </c:if>
                                    <c:if test="${p.estado != 'EN_EVALUACION_EVALUADOR' && p.estado != 'EN_REVISION_INFORME_EVA' && !p.enMoraDocente}">
                                        <span style="color: var(--text-muted); font-size: 0.82rem;">Al día</span>
                                    </c:if>
                                </td>
                                <td style="text-align: right;">
                                    <c:choose>
                                        <c:when test="${p.estado == 'EN_EVALUACION_EVALUADOR' || p.estado == 'EN_REVISION_INFORME_EVA'}">
                                            <a href="${pageContext.request.contextPath}/evaluador/evaluar?id=${p.id}" class="btn btn-warning btn-sm">
                                                <span>Evaluar Documento</span>
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/evaluador/evaluar?id=${p.id}" class="btn btn-secondary btn-sm">
                                                <span>Ver Expediente</span>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
