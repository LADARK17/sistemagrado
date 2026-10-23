<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<!-- HERO BANNER COORDINACIÓN -->
<div class="section-hero">
    <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px;">
        <div>
            <span class="hero-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                <span>Gestión Académica Institucional</span>
            </span>
            <h1 class="hero-title">Comité de Trabajos de Grado</h1>
            <p class="hero-desc">
                Monitoreo general del ciclo de vida de los proyectos de grado, asignación docente y control reglamentario de plazos de vigencia (180 días).
            </p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/comite/solicitudes-pago" class="btn btn-warning">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                <span>Validar Pagos (Fase 1)</span>
            </a>
            <a href="${pageContext.request.contextPath}/comite/banco-ideas" class="btn btn-secondary" style="background: rgba(255,255,255,0.95);">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                <span>Banco de Ideas</span>
            </a>
        </div>
    </div>
</div>

<!-- TARJETA PRINCIPAL CON TABLA DE EXPEDIENTES -->
<div class="uts-card">
    <div class="uts-card-header" style="flex-wrap: wrap; gap: 16px;">
        <div>
            <h2>Expedientes de Grado en Trámite</h2>
            <p style="color: var(--text-muted); font-size: 0.88rem;">
                Listado consolidado de radicaciones con estado de vigencia y asignaciones.
            </p>
        </div>
        <div style="position: relative; min-width: 320px;">
            <input type="text" id="filtroProyectos" onkeyup="filtrarTabla()" class="form-control" 
                   placeholder="Buscar por estudiante, título o estado..." 
                   style="padding-left: 38px; height: 42px; font-size: 0.9rem;" />
            <svg style="position: absolute; left: 12px; top: 12px; width: 17px; height: 17px; color: #64748b;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        </div>
    </div>

    <!-- RESUMEN DE PROYECTOS -->
    <div class="table-responsive">
        <table class="table" id="tablaProyectos">
            <thead>
                <tr>
                    <th style="width: 70px;">Radicado</th>
                    <th>Título del Proyecto</th>
                    <th>Estudiante(s)</th>
                    <th>Fase Actual</th>
                    <th>Estado Oficial</th>
                    <th>Vigencia (180 Días)</th>
                    <th>Docentes Asignados</th>
                    <th style="text-align: right;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty proyectos}">
                        <tr>
                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                No hay proyectos radicados en el sistema actualmente.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${proyectos}">
                            <tr class="fila-proyecto">
                                <td>
                                    <span style="font-weight: 800; font-size: 0.88rem; color: var(--uts-green-700);">
                                        #<c:out value="${p.id}" />
                                    </span>
                                </td>
                                <td style="max-width: 260px;">
                                    <strong style="color: var(--text-heading); display: block; line-height: 1.35;">
                                        <c:out value="${p.titulo}" />
                                    </strong>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: #1e293b;"><c:out value="${p.estudianteNombre}" /></div>
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
                                    <c:choose>
                                        <c:when test="${p.fechaLimiteVigencia != null}">
                                            <div class="<c:if test='${p.diasVigenciaRestantes <= 20}'>danger-text</c:if>" style="font-weight: 800; font-size: 0.95rem;">
                                                <c:out value="${p.diasVigenciaRestantes}" /> días
                                            </div>
                                            <div style="font-size: 0.72rem; color: var(--text-muted);">
                                                Fin: <fmt:formatDate value="${p.fechaLimiteVigencia}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-muted); font-size: 0.82rem;">Trámite Fase 1</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size: 0.82rem;">
                                    <div><strong>Dir:</strong> <c:out value="${not empty p.directorNombre ? p.directorNombre : 'Por Asignar'}" /></div>
                                    <div style="margin-top: 2px;"><strong>Eval:</strong> <c:out value="${not empty p.evaluadorNombre ? p.evaluadorNombre : 'Por Asignar'}" /></div>
                                </td>
                                <td style="text-align: right;">
                                    <a href="${pageContext.request.contextPath}/comite/detalle-proyecto?id=${p.id}" class="btn btn-secondary btn-sm" style="font-weight: 600;">
                                        <span>Expediente</span>
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script>
function filtrarTabla() {
    var query = document.getElementById("filtroProyectos").value.toLowerCase().trim();
    var filas = document.querySelectorAll(".fila-proyecto");
    filas.forEach(function(fila) {
        var texto = fila.innerText.toLowerCase();
        if (texto.indexOf(query) !== -1) {
            fila.style.display = "";
        } else {
            fila.style.display = "none";
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
