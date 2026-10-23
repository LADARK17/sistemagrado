<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Evaluación de Pares (Docente Evaluador)</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Proyecto #<c:out value="${proyecto.id}" /> – <c:out value="${proyecto.faseActual}" />
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/evaluador/proyectos" class="btn btn-secondary btn-sm">Volver</a>
    </div>

    <div style="margin-bottom: 20px;">
        <h3 style="color: var(--uts-green-dark);"><c:out value="${proyecto.titulo}" /></h3>
        <p style="margin-top: 6px; color: var(--uts-text-muted);">
            <strong>Estudiante(s):</strong> <c:out value="${proyecto.estudianteNombre}" />
            <c:if test="${not empty proyecto.companeroNombre}"> y <c:out value="${proyecto.companeroNombre}" /></c:if>
        </p>
        <p style="margin-top: 4px; color: var(--uts-text-muted);">
            <strong>Docente Director:</strong> <c:out value="${proyecto.directorNombre}" />
        </p>
    </div>

    <!-- DOCUMENTO A EVALUAR -->
    <div class="uts-card" style="background: #eef7ee; border: 1px solid #c2e2c2;">
        <h4 style="color: var(--uts-green-dark); margin-bottom: 8px;">Documento Avalado por el Director:</h4>
        <c:choose>
            <c:when test="${proyecto.faseActual == 'FASE_3_PROPUESTA_2'}">
                <p style="margin-bottom: 12px; font-size: 0.92rem;">
                    <strong>Fase 3:</strong> Anteproyecto F-DC-124 (con visto bueno de Director).
                </p>
                <a href="<c:out value='${proyecto.urlAnteproyecto}' />" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
                    Abrir Anteproyecto F-DC-124 en la Nube
                </a>
            </c:when>
            <c:when test="${proyecto.faseActual == 'FASE_5_INFORME_2'}">
                <p style="margin-bottom: 12px; font-size: 0.92rem;">
                    <strong>Fase 5:</strong> Informe Final de Tesis (con visto bueno de Director).
                </p>
                <a href="<c:out value='${proyecto.urlInformeFinal}' />" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
                    Abrir Informe Final en la Nube
                </a>
            </c:when>
            <c:otherwise>
                <p style="color: var(--uts-text-muted);">El proyecto no requiere acción evaluativa de su parte en este estado.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- FORMULARIO DE EVALUACIÓN (HABILITADO SI ESTÁ EN FASE 3 O 5) -->
    <c:if test="${proyecto.estado == 'EN_EVALUACION_EVALUADOR' || proyecto.estado == 'EN_REVISION_INFORME_EVA'}">
        <div class="uts-card" style="border-top: 4px solid var(--uts-gold); margin-top: 25px;">
            <h3 style="color: var(--uts-charcoal); margin-bottom: 15px;">Concepto Final de Evaluación</h3>

            <form action="${pageContext.request.contextPath}/evaluador/guardar-evaluacion" method="POST">
                <input type="hidden" name="proyectoId" value="${proyecto.id}" />

                <div class="form-group">
                    <label for="resultadoSelect">Concepto Evaluativo:</label>
                    <select id="resultadoSelect" name="resultado" required class="form-control" onchange="verificarOpcionRechazo(this.value)">
                        <option value="Aprobado">Aprobado (Otorga visto bueno definitivo para avanzar de fase)</option>
                        <option value="Aplazado">Aplazado (Devuelve al estudiante para correcciones)</option>
                        <option value="Rechazado">Rechazado (Fin del proyecto por inviabilidad metodológica)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="observaciones">Dictamen Técnico y Observaciones Obligatorias:</label>
                    <textarea id="observaciones" name="observaciones" rows="4" required class="form-control"
                              placeholder="Indique detalladamente el concepto técnico, pertinencia o correcciones solicitadas..."></textarea>
                </div>

                <!-- SECCIÓN DE CONFIRMACIÓN SI ES RECHAZO -->
                <div id="seccionConfirmacionRechazo" style="display: none; padding: 12px; background-color: var(--uts-danger-bg); border-radius: 6px; margin-bottom: 15px;">
                    <div style="display: flex; gap: 10px; align-items: flex-start;">
                        <input type="checkbox" id="confirmacionRechazo" name="confirmacionRechazo" style="margin-top: 4px;" />
                        <label for="confirmacionRechazo" style="font-size: 0.88rem; color: #721c24;">
                            Confirmo formalmente que este anteproyecto/informe incurre en causales definitivas de rechazo.
                        </label>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/evaluador/proyectos" class="btn btn-secondary">Cancelar</a>
                    <button type="submit" class="btn btn-primary" id="btnGuardarDictamen">Registrar Evaluación</button>
                </div>
            </form>
        </div>
    </c:if>

    <!-- HISTORIAL DE CALIFICACIONES PREVIAS -->
    <h4 style="margin-top: 30px; margin-bottom: 12px; color: var(--uts-charcoal);">Historial de Evaluaciones y Dictámenes</h4>
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Fase</th>
                    <th>Calificador</th>
                    <th>Concepto</th>
                    <th>Observaciones</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty calificaciones}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--uts-text-muted); padding: 15px;">
                                No hay conceptos previos registrados.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${calificaciones}">
                            <tr>
                                <td><c:out value="${c.fase}" /></td>
                                <td><c:out value="${c.calificadorNombre}" /></td>
                                <td><strong><c:out value="${c.resultado}" /></strong></td>
                                <td><c:out value="${c.observaciones}" /></td>
                                <td><fmt:formatDate value="${c.fechaCalificacion}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script>
function verificarOpcionRechazo(val) {
    var seccion = document.getElementById("seccionConfirmacionRechazo");
    var check = document.getElementById("confirmacionRechazo");
    var btn = document.getElementById("btnGuardarDictamen");

    if (val === "Rechazado") {
        seccion.style.display = "block";
        check.required = true;
        btn.className = "btn btn-danger";
        btn.innerText = "Confirmar Rechazo";
    } else {
        seccion.style.display = "none";
        check.required = false;
        check.checked = false;
        btn.className = "btn btn-primary";
        btn.innerText = "Registrar Evaluación";
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
