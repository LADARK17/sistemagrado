<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card">
    <div class="uts-card-header">
        <div>
            <h2>Revisión y Dictamen Metodológico (Director)</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Proyecto #<c:out value="${proyecto.id}" /> – <c:out value="${proyecto.faseActual}" />
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/director/proyectos" class="btn btn-secondary btn-sm">Volver</a>
    </div>

    <div style="margin-bottom: 20px;">
        <h3 style="color: var(--uts-green-dark);"><c:out value="${proyecto.titulo}" /></h3>
        <p style="margin-top: 6px; color: var(--uts-text-muted);">
            <strong>Estudiante(s):</strong> <c:out value="${proyecto.estudianteNombre}" />
            <c:if test="${not empty proyecto.companeroNombre}"> y <c:out value="${proyecto.companeroNombre}" /></c:if>
        </p>
        <p style="margin-top: 4px; color: var(--uts-text-muted);">
            <strong>Objetivo General:</strong> <c:out value="${proyecto.objetivo}" />
        </p>
    </div>

    <!-- DOCUMENTO A REVISAR -->
    <div class="uts-card" style="background: #eef7ee; border: 1px solid #c2e2c2;">
        <h4 style="color: var(--uts-green-dark); margin-bottom: 8px;">Enlace del Documento Radicado por el Estudiante:</h4>
        <c:choose>
            <c:when test="${proyecto.faseActual == 'FASE_2_PROPUESTA_1'}">
                <p style="margin-bottom: 12px; font-size: 0.92rem;">
                    <strong>Documento:</strong> Anteproyecto de Grado (Formato UTS F-DC-124)
                </p>
                <a href="<c:out value='${proyecto.urlAnteproyecto}' />" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
                    Abrir Anteproyecto F-DC-124 en la Nube
                </a>
            </c:when>
            <c:when test="${proyecto.faseActual == 'FASE_4_INFORME_1'}">
                <p style="margin-bottom: 12px; font-size: 0.92rem;">
                    <strong>Documento:</strong> Informe Final de Trabajo de Grado (Tesis)
                </p>
                <a href="<c:out value='${proyecto.urlInformeFinal}' />" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
                    Abrir Informe Final en la Nube
                </a>
            </c:when>
            <c:otherwise>
                <p style="color: var(--uts-text-muted);">El proyecto no se encuentra en una fase que requiera calificación directa de su parte en este momento.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- FORMULARIO DE CALIFICACIÓN (SOLO SI ESTÁ EN EVALUACIÓN POR DIRECTOR) -->
    <c:if test="${proyecto.estado == 'EN_EVALUACION_DIRECTOR' || proyecto.estado == 'EN_REVISION_INFORME_DIR'}">
        <div class="uts-card" style="border-top: 4px solid var(--uts-gold); margin-top: 25px;">
            <h3 style="color: var(--uts-charcoal); margin-bottom: 15px;">Emitir Dictamen Docente</h3>

            <form action="${pageContext.request.contextPath}/director/guardar-calificacion" method="POST" id="formCalificarDirector">
                <input type="hidden" name="proyectoId" value="${proyecto.id}" />

                <div class="form-group">
                    <label for="resultadoSelect">Concepto Evaluativo:</label>
                    <select id="resultadoSelect" name="resultado" required class="form-control" onchange="verificarOpcionRechazo(this.value)">
                        <option value="Aprobado">Aprobado (Avala y remite al Evaluador)</option>
                        <option value="Aplazado">Aplazado (Devuelve al estudiante para correcciones requeridas)</option>
                        <option value="Rechazado">Rechazado (Finaliza el proyecto con justificación reglamentaria)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="observaciones">Observaciones de Retroalimentación Obligatorias:</label>
                    <textarea id="observaciones" name="observaciones" rows="4" required class="form-control"
                              placeholder="Escriba los comentarios metodológicos, puntos a corregir o aval de calidad..."></textarea>
                </div>

                <!-- SECCIÓN DE CONFIRMACIÓN SI ES RECHAZO (INICIALMENTE OCULTA) -->
                <div id="seccionConfirmacionRechazo" style="display: none; padding: 12px; background-color: var(--uts-danger-bg); border-radius: 6px; margin-bottom: 15px;">
                    <div style="display: flex; gap: 10px; align-items: flex-start;">
                        <input type="checkbox" id="confirmacionRechazo" name="confirmacionRechazo" style="margin-top: 4px;" />
                        <label for="confirmacionRechazo" style="font-size: 0.88rem; color: #721c24;">
                            Confirmo formalmente que este proyecto es inviable o incurre en falta reglamentaria y acepto el cierre definitivo del expediente.
                        </label>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/director/proyectos" class="btn btn-secondary">Cancelar</a>
                    <button type="submit" class="btn btn-primary" id="btnGuardarDictamen">Registrar Dictamen</button>
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
                                <td>
                                    <strong><c:out value="${c.resultado}" /></strong>
                                </td>
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
        btn.innerText = "Registrar Dictamen";
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
