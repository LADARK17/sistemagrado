<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<!-- HERO BANNER DIRECTOR -->
<div class="section-hero">
    <span class="hero-pill">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><polyline points="9 11 12 14 22 4"></polyline></svg>
        <span>Dirección Metodológica UTS</span>
    </span>
    <h1 class="hero-title">Proyectos de Grado a su Cargo</h1>
    <p class="hero-desc">
        Acompañamiento, revisión técnica y emisión de conceptos para Anteproyecto (Fase 2, Formato F-DC-124) e Informe Final de Tesis (Fase 4).
    </p>
    <div style="margin-top: 14px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.85); display: flex; align-items: center; gap: 8px;">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
        <span><strong>Reglamentación UTS:</strong> El Director dispone de un plazo máximo de <strong>5 días hábiles</strong> para emitir su calificación tras la radicación del estudiante.</span>
    </div>
</div>

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Listado de Trabajos de Grado Asignados</h2>
            <p style="color: var(--text-muted); font-size: 0.88rem;">
                Consulte las versiones radicadas por los estudiantes y formalice las calificaciones institucionales.
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
                    <th>Fase en Curso</th>
                    <th>Estado de Trámite</th>
                    <th>Indicador Reglamentario</th>
                    <th style="text-align: right;">Acción</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty proyectos}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                No tiene proyectos de grado asignados como Director actualmente.
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
                                <td style="max-width: 280px;">
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
                                    <c:if test="${!p.enMoraDocente && (p.estado == 'EN_EVALUACION_DIRECTOR' || p.estado == 'EN_REVISION_INFORME_DIR')}">
                                        <span class="badge badge-EN_EVALUACION_DIRECTOR">Pendiente su calificación</span>
                                    </c:if>
                                    <c:if test="${p.estado != 'EN_EVALUACION_DIRECTOR' && p.estado != 'EN_REVISION_INFORME_DIR' && !p.enMoraDocente}">
                                        <span style="color: var(--text-muted); font-size: 0.82rem;">Al día</span>
                                    </c:if>
                                </td>
                                <td style="text-align: right;">
                                    <c:choose>
                                        <c:when test="${p.estado == 'EN_EVALUACION_DIRECTOR' || p.estado == 'EN_REVISION_INFORME_DIR'}">
                                            <a href="${pageContext.request.contextPath}/director/calificar?id=${p.id}" class="btn btn-warning btn-sm">
                                                <span>Calificar Documento</span>
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/director/calificar?id=${p.id}" class="btn btn-secondary btn-sm">
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
