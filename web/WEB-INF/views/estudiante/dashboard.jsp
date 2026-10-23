<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../common/header.jsp" />

<c:choose>
    <c:when test="${empty proyecto}">
        <!-- BANNER DE BIENVENIDA SIN PROYECTO RADICADO -->
        <div class="section-hero">
            <span class="hero-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                <span>Portal de Grados UTS</span>
            </span>
            <h1 class="hero-title">¡Bienvenido(a), <c:out value="${sessionScope.nombre}" />!</h1>
            <p class="hero-desc">
                Inicia formalmente tu proceso de modalidad de grado. Puedes postularte a una idea de los grupos de investigación de la UTS o radicar tu propuesta personalizada con tu comprobante de derechos pecuniarios.
            </p>
            <div style="margin-top: 24px; display: flex; gap: 14px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/estudiante/radicar" class="btn btn-warning">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Radicar Propuesta de Grado</span>
                </a>
                <a href="${pageContext.request.contextPath}/estudiante/banco-ideas" class="btn btn-secondary" style="background: rgba(255,255,255,0.9);">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                    <span>Explorar Banco de Ideas UTS</span>
                </a>
            </div>
        </div>

        <div class="uts-card" style="text-align: center; padding: 48px 30px;">
            <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--uts-green-50); color: var(--uts-green-600); display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
            </div>
            <h3 style="margin-bottom: 8px;">Aún no tienes un radicado activo</h3>
            <p style="color: var(--text-muted); max-width: 520px; margin: 0 auto 24px; font-size: 0.95rem;">
                La reglamentación de las Unidades Tecnológicas de Santander exige la validación de derechos pecuniarios (Fase 1) para habilitar el seguimiento con el Director y Evaluador.
            </p>
            <a href="${pageContext.request.contextPath}/estudiante/radicar" class="btn btn-primary">Iniciar Solicitud de Grado</a>
        </div>
    </c:when>

    <c:otherwise>
        <!-- DETERMINAR ÍNDICE DE FASE ACTUAL PARA EL STEPPER (1 a 6) -->
        <c:set var="stepIndex" value="1" />
        <c:if test="${proyecto.faseActual == 'FASE_2_PROPUESTA_1'}"><c:set var="stepIndex" value="2" /></c:if>
        <c:if test="${proyecto.faseActual == 'FASE_3_PROPUESTA_2'}"><c:set var="stepIndex" value="3" /></c:if>
        <c:if test="${proyecto.faseActual == 'FASE_4_INFORME_1'}"><c:set var="stepIndex" value="4" /></c:if>
        <c:if test="${proyecto.faseActual == 'FASE_5_INFORME_2'}"><c:set var="stepIndex" value="5" /></c:if>
        <c:if test="${proyecto.faseActual == 'FASE_FINAL' || proyecto.faseActual == 'FASE_6_SUSTENTACION'}"><c:set var="stepIndex" value="6" /></c:if>
        <c:if test="${proyecto.estado == 'FINALIZADO_CERRADO'}"><c:set var="stepIndex" value="7" /></c:if>

        <!-- HERO DEL PROYECTO EN CURSO -->
        <div class="section-hero" style="padding: 28px 34px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 14px;">
                <div>
                    <span class="hero-pill">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <span>Expediente #<c:out value="${proyecto.id}" /> • Periodo 2026-II</span>
                    </span>
                    <h1 class="hero-title" style="font-size: 1.55rem; margin-top: 4px; max-width: 820px;">
                        <c:out value="${proyecto.titulo}" />
                    </h1>
                    <p class="hero-desc" style="font-size: 0.92rem; margin-top: 6px;">
                        <strong>Objetivo:</strong> <c:out value="${proyecto.objetivo}" />
                    </p>
                </div>
                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                    <span class="badge badge-${proyecto.estado}" style="font-size: 0.85rem; padding: 7px 16px; background: #ffffff; color: #0f172a; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                        <c:out value="${proyecto.estado}" />
                    </span>
                    <c:if test="${not empty proyecto.companeroNombre}">
                        <span style="font-size: 0.78rem; color: rgba(255,255,255,0.85); background: rgba(0,0,0,0.25); padding: 4px 10px; border-radius: 12px;">
                            Pareja: <c:out value="${proyecto.companeroNombre}" />
                        </span>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- TIMELINE DE LAS 6 FASES INSTITUCIONALES UTS (STEPPER) -->
        <div class="stepper-container">
            <div class="stepper-header">
                <span class="stepper-header-title">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                    <span>Ciclo de Vida Reglamentario del Trabajo de Grado (UTS)</span>
                </span>
                <span style="font-size: 0.82rem; font-weight: 700; color: var(--uts-gold-600);">
                    Fase Actual: <c:out value="${proyecto.faseActual}" />
                </span>
            </div>

            <div class="stepper-steps-wrapper">
                <!-- PASO 1: PAGO -->
                <div class="step-node <c:choose><c:when test='${stepIndex > 1}'>completed</c:when><c:when test='${stepIndex == 1}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${stepIndex > 1}">✓</c:when>
                            <c:otherwise>1</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase 1</span>
                    <span class="step-name">Radicación & Pago</span>
                    <span class="step-actor">Comité</span>
                </div>

                <!-- PASO 2: PROPUESTA 1 -->
                <div class="step-node <c:choose><c:when test='${stepIndex > 2}'>completed</c:when><c:when test='${stepIndex == 2}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${stepIndex > 2}">✓</c:when>
                            <c:otherwise>2</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase 2</span>
                    <span class="step-name">Propuesta I (F-DC-124)</span>
                    <span class="step-actor">Director</span>
                </div>

                <!-- PASO 3: PROPUESTA 2 -->
                <div class="step-node <c:choose><c:when test='${stepIndex > 3}'>completed</c:when><c:when test='${stepIndex == 3}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${stepIndex > 3}">✓</c:when>
                            <c:otherwise>3</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase 3</span>
                    <span class="step-name">Propuesta II (F-DC-124)</span>
                    <span class="step-actor">Evaluador</span>
                </div>

                <!-- PASO 4: INFORME 1 -->
                <div class="step-node <c:choose><c:when test='${stepIndex > 4}'>completed</c:when><c:when test='${stepIndex == 4}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${stepIndex > 4}">✓</c:when>
                            <c:otherwise>4</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase 4</span>
                    <span class="step-name">Informe I (Tesis)</span>
                    <span class="step-actor">Director</span>
                </div>

                <!-- PASO 5: INFORME 2 -->
                <div class="step-node <c:choose><c:when test='${stepIndex > 5}'>completed</c:when><c:when test='${stepIndex == 5}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${stepIndex > 5}">✓</c:when>
                            <c:otherwise>5</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase 5</span>
                    <span class="step-name">Informe II (Tesis)</span>
                    <span class="step-actor">Evaluador</span>
                </div>

                <!-- PASO 6: SUSTENTACIÓN -->
                <div class="step-node <c:choose><c:when test='${stepIndex >= 6 && proyecto.estado == \"FINALIZADO_CERRADO\"}'>completed</c:when><c:when test='${stepIndex == 6}'>active</c:when></c:choose>">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${proyecto.estado == 'FINALIZADO_CERRADO'}">✓</c:when>
                            <c:otherwise>6</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="step-phase-tag">Fase Final</span>
                    <span class="step-name">Sustentación & Cierre</span>
                    <span class="step-actor">Jurado UTS</span>
                </div>
            </div>
        </div>

        <!-- CONTADORES DE TIEMPO Y PLAZOS REGLAMENTARIOS -->
        <div class="time-cards">
            <!-- VIGENCIA TOTAL -->
            <div class="metric-card">
                <h4>Vigencia Total (180 Días Calendario)</h4>
                <div class="metric-value <c:if test='${proyecto.diasVigenciaRestantes <= 20}'>danger-text</c:if>">
                    <c:choose>
                        <c:when test="${proyecto.fechaLimiteVigencia != null}">
                            <c:out value="${proyecto.diasVigenciaRestantes}" /> <span style="font-size: 1.1rem; font-weight: 600;">días restantes</span>
                        </c:when>
                        <c:otherwise>Por iniciar (Fase 1)</c:otherwise>
                    </c:choose>
                </div>
                <div class="progress-track">
                    <c:set var="pctVigencia" value="${(180 - proyecto.diasVigenciaRestantes) * 100 / 180}" />
                    <div class="progress-fill <c:if test='${proyecto.diasVigenciaRestantes <= 20}'>danger</c:if>" 
                         style="--progress: ${pctVigencia > 100 ? 100 : (pctVigencia < 5 ? 5 : pctVigencia)}%; width: var(--progress);"></div>
                </div>
                <div style="margin-top: 8px; display: flex; justify-content: space-between; font-size: 0.78rem; color: var(--text-muted);">
                    <span>Límite reglamentario:</span>
                    <strong><fmt:formatDate value="${proyecto.fechaLimiteVigencia}" pattern="dd/MM/yyyy" /></strong>
                </div>
            </div>

            <!-- ANTEPROYECTO F-DC-124 (12 SEMANAS) -->
            <div class="metric-card">
                <h4>Aprobación Anteproyecto F-DC-124 (12 Semanas)</h4>
                <div class="metric-value <c:if test='${proyecto.diasFdc124Restantes <= 10}'>danger-text</c:if>">
                    <c:choose>
                        <c:when test="${proyecto.fechaLimiteFdc124 != null}">
                            <c:out value="${proyecto.diasFdc124Restantes}" /> <span style="font-size: 1.1rem; font-weight: 600;">días restantes</span>
                        </c:when>
                        <c:otherwise>Por iniciar (Fase 1)</c:otherwise>
                    </c:choose>
                </div>
                <div class="progress-track">
                    <c:set var="pctFdc" value="${(84 - proyecto.diasFdc124Restantes) * 100 / 84}" />
                    <div class="progress-fill <c:if test='${proyecto.diasFdc124Restantes <= 10}'>danger</c:if>" 
                         style="--progress: ${pctFdc > 100 ? 100 : (pctFdc < 5 ? 5 : pctFdc)}%; width: var(--progress);"></div>
                </div>
                <div style="margin-top: 8px; display: flex; justify-content: space-between; font-size: 0.78rem; color: var(--text-muted);">
                    <span>Plazo máximo F-DC-124:</span>
                    <strong><fmt:formatDate value="${proyecto.fechaLimiteFdc124}" pattern="dd/MM/yyyy" /></strong>
                </div>
            </div>

            <!-- ESTADO ACADÉMICO -->
            <div class="metric-card">
                <h4>Estado Institucional</h4>
                <div class="metric-value" style="font-size: 1.35rem; color: var(--uts-green-600); line-height: 1.2;">
                    <c:out value="${proyecto.estado}" />
                </div>
                <div style="margin-top: 14px; font-size: 0.82rem; color: var(--text-muted); line-height: 1.4;">
                    <c:choose>
                        <c:when test="${proyecto.estado == 'RADICADO'}">
                            El Comité está validando los derechos pecuniarios y asignando Director y Evaluador.
                        </c:when>
                        <c:when test="${proyecto.estado == 'APROBADO_FASE_1'}">
                            ¡Pago aprobado! Debes cargar tu formato de anteproyecto F-DC-124.
                        </c:when>
                        <c:when test="${proyecto.estado == 'EN_EVALUACION_DIRECTOR'}">
                            Tu documento está en revisión oficial por parte del Director asignado.
                        </c:when>
                        <c:when test="${proyecto.estado == 'EN_EVALUACION_EVALUADOR'}">
                            El Director dio concepto favorable. Ahora el Evaluador revisa la propuesta.
                        </c:when>
                        <c:when test="${proyecto.estado == 'EN_DESARROLLO'}">
                            Anteproyecto legalizado formalmente. Desarrolla tu informe final.
                        </c:when>
                        <c:when test="${proyecto.estado == 'SUSTENTACION_PROGRAMADA'}">
                            Fecha de sustentación asignada por el Comité. ¡Prepárate para defender tu trabajo!
                        </c:when>
                        <c:otherwise>Seguimiento activo en plataforma institucional UTS.</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- DOCENTES ASIGNADOS -->
        <div class="mentors-grid">
            <!-- DIRECTOR -->
            <div class="mentor-card">
                <div class="mentor-avatar">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                </div>
                <div class="mentor-info">
                    <div class="mentor-role-label">Director de Trabajo de Grado</div>
                    <div class="mentor-name">
                        <c:out value="${not empty proyecto.directorNombre ? proyecto.directorNombre : 'Pendiente de Asignación por Comité'}" />
                    </div>
                    <div class="mentor-status">
                        <c:choose>
                            <c:when test="${not empty proyecto.directorNombre}">
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #22c55e;"></span>
                                <span>Docente Habilitado UTS</span>
                            </c:when>
                            <c:otherwise>
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #f59e0b;"></span>
                                <span>En proceso en Comité</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- EVALUADOR -->
            <div class="mentor-card">
                <div class="mentor-avatar" style="background: linear-gradient(135deg, #0284c7, #0369a1); border-color: #bae6fd;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect><path d="m9 14 2 2 4-4"></path></svg>
                </div>
                <div class="mentor-info">
                    <div class="mentor-role-label" style="color: #0284c7;">Evaluador / Calificador</div>
                    <div class="mentor-name">
                        <c:out value="${not empty proyecto.evaluadorNombre ? proyecto.evaluadorNombre : 'Pendiente de Asignación por Comité'}" />
                    </div>
                    <div class="mentor-status">
                        <c:choose>
                            <c:when test="${not empty proyecto.evaluadorNombre}">
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #22c55e;"></span>
                                <span>Jurado Par Institucional</span>
                            </c:when>
                            <c:otherwise>
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #f59e0b;"></span>
                                <span>En proceso en Comité</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- ALERTA SI EL TRABAJO FUE RECHAZADO -->
        <c:if test="${proyecto.estado == 'RECHAZADO'}">
            <div class="action-highlight-box danger">
                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                    </div>
                    <div>
                        <h3 style="color: #991b1b; font-size: 1.15rem; margin-bottom: 6px;">Expediente Rechazado Institucionalmente</h3>
                        <p style="color: #7f1d1d; font-size: 0.92rem; margin-bottom: 8px;">
                            <strong>Motivo reglamentario formal:</strong> <c:out value="${proyecto.motivoRechazo}" />
                        </p>
                        <span style="font-size: 0.8rem; color: #991b1b;">Este dictamen es definitivo. Para iniciar un nuevo proceso reglamentario, debe formular una nueva solicitud.</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ACCIÓN 1: CARGA DE ANTEPROYECTO TRAS APROBACIÓN DE PAGO (FASE 2) -->
        <c:if test="${proyecto.estado == 'APROBADO_FASE_1'}">
            <div class="action-highlight-box">
                <h3 style="color: var(--uts-green-700); margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                    <span>Fase 2: Carga de Anteproyecto Institucional (Formato F-DC-124)</span>
                </h3>
                <p style="font-size: 0.92rem; color: var(--text-muted); margin-bottom: 18px; line-height: 1.5;">
                    Sus derechos pecuniarios fueron validados con éxito. Cargue a continuación la URL pública o compartida de su formato oficial <strong>F-DC-124</strong> (alojado en Google Drive u OneDrive) para evaluación de su Director.
                </p>
                <form action="${pageContext.request.contextPath}/estudiante/subir-anteproyecto" method="POST" onsubmit="return validarUrlHttps(document.getElementById('urlAnteproyecto'));">
                    <input type="hidden" name="proyectoId" value="${proyecto.id}" />
                    <div class="form-group">
                        <label for="urlAnteproyecto">Enlace HTTPS del Anteproyecto F-DC-124 (Google Drive / OneDrive):</label>
                        <input type="url" id="urlAnteproyecto" name="urlAnteproyecto" required class="form-control" 
                               placeholder="https://drive.google.com/file/d/.../view?usp=sharing" />
                        <small style="color: var(--text-muted); margin-top: 4px; display: block;">
                            * Asegúrate de que el documento tenga permisos de lectura ("Cualquier persona con el enlace puede leer").
                        </small>
                    </div>
                    <div class="form-group">
                        <label for="observaciones">Observaciones Técnicas o Anexos (Opcional):</label>
                        <input type="text" id="observaciones" name="observaciones" class="form-control" 
                               placeholder="ej. Se incluyen diagramas de arquitectura en carpeta compartida" />
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>Radicar Anteproyecto para Evaluación</span>
                    </button>
                </form>
            </div>
        </c:if>

        <!-- ACCIÓN 2: CORRECCIONES TRAS APLAZAMIENTO (RN05) -->
        <c:if test="${proyecto.estado == 'APLAZADO_DIRECTOR' || proyecto.estado == 'APLAZADO_EVALUADOR' || proyecto.estado == 'APLAZADO_INFORME_DIR' || proyecto.estado == 'APLAZADO_INFORME_EVA'}">
            <div class="action-highlight-box warning">
                <h3 style="color: #92400e; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>Atención: Su documento requiere ajustes reglamentarios (Aplazado)</span>
                </h3>
                <div style="background: rgba(255, 255, 255, 0.7); border: 1px solid #fde68a; border-radius: var(--radius-md); padding: 14px 18px; margin-bottom: 16px;">
                    <strong style="color: #78350f; font-size: 0.85rem; text-transform: uppercase;">Retroalimentación del Docente:</strong>
                    <p style="margin-top: 4px; color: #451a03; font-size: 0.95rem;"><c:out value="${ultimaCalificacion.observaciones}" /></p>
                </div>
                <p style="font-size: 0.9rem; color: #92400e; margin-bottom: 16px;">
                    Realice las correcciones solicitadas en su archivo y radique el nuevo enlace de la nube a continuación:
                </p>
                <form action="${pageContext.request.contextPath}/estudiante/subir-correccion" method="POST" onsubmit="return validarUrlHttps(document.getElementById('urlCorreccion'));">
                    <input type="hidden" name="proyectoId" value="${proyecto.id}" />
                    <div class="form-group">
                        <label for="urlCorreccion">Nuevo Enlace HTTPS con Correcciones (Google Drive / OneDrive):</label>
                        <input type="url" id="urlCorreccion" name="urlCorreccion" required class="form-control" 
                               placeholder="https://drive.google.com/file/d/..." />
                    </div>
                    <div class="form-group">
                        <label for="obsCorr">Detalle de Cambios Realizados:</label>
                        <input type="text" id="obsCorr" name="observaciones" required class="form-control" 
                               placeholder="ej. Se ajustó el marco metodológico según observaciones del Director" />
                    </div>
                    <button type="submit" class="btn btn-warning">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>Radicar Versión Corregida</span>
                    </button>
                </form>
            </div>
        </c:if>

        <!-- ACCIÓN 3: CARGA DE INFORME FINAL (FASE 4) -->
        <c:if test="${proyecto.estado == 'EN_DESARROLLO'}">
            <div class="action-highlight-box">
                <h3 style="color: var(--uts-green-700); margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Fase 4: Radicación de Informe Final de Trabajo de Grado</span>
                </h3>
                <p style="font-size: 0.92rem; color: var(--text-muted); margin-bottom: 16px;">
                    ¡Su anteproyecto está legalizado y aprobado! Una vez culmine la ejecución técnica y redacción de su tesis, adjunte aquí el enlace del documento final para calificación por parte del Director.
                </p>
                <form action="${pageContext.request.contextPath}/estudiante/subir-informe" method="POST" onsubmit="return validarUrlHttps(document.getElementById('urlInforme'));">
                    <input type="hidden" name="proyectoId" value="${proyecto.id}" />
                    <div class="form-group">
                        <label for="urlInforme">URL del Informe Final Completo (Google Drive / OneDrive):</label>
                        <input type="url" id="urlInforme" name="urlInforme" required class="form-control" 
                               placeholder="https://drive.google.com/file/d/.../view?usp=sharing" />
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>Radicar Informe Final</span>
                    </button>
                </form>
            </div>
        </c:if>

        <!-- ACCIÓN 4: SUSTENTACIÓN PROGRAMADA -->
        <c:if test="${proyecto.estado == 'SUSTENTACION_PROGRAMADA'}">
            <div class="action-highlight-box" style="background: linear-gradient(135deg, #faf5ff 0%, #f3e8ff 100%); border-color: #d8b4fe; border-left-color: #9333ea;">
                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <div style="width: 46px; height: 46px; border-radius: 50%; background: #e9d5ff; color: #7e22ce; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div>
                        <h3 style="color: #6b21a8; font-size: 1.2rem; margin-bottom: 6px;">¡Sustentación Oficial Programada!</h3>
                        <p style="color: #581c87; font-size: 0.95rem; margin-bottom: 6px;">
                            <strong>Fecha y Hora:</strong> <fmt:formatDate value="${proyecto.fechaSustentacion}" pattern="dd/MM/yyyy HH:mm" />
                        </p>
                        <p style="color: #581c87; font-size: 0.95rem; margin-bottom: 6px;">
                            <strong>Lugar / Sala:</strong> <c:out value="${proyecto.lugarSustentacion}" />
                        </p>
                        <small style="color: #7e22ce;">Recuerde presentarse 15 minutos antes con documento de identidad y diapositivas preparadas.</small>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- HISTORIAL DE VERSIONES DOCUMENTALES RADICADAS (RN05 / RNF05) -->
        <div class="uts-card">
            <div class="uts-card-header">
                <div>
                    <h2>Historial de Documentos y Versiones Radicadas</h2>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">
                        Trazabilidad inmutable de versiones radicadas en la nube bajo los estándares UTS.
                    </p>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Fase Reglamentaria</th>
                            <th>Enlace Documental (Nube)</th>
                            <th>Observaciones del Estudiante</th>
                            <th>Fecha y Hora</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty historialVersiones}">
                                <tr>
                                    <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 24px;">
                                        No hay versiones adicionales registradas en el historial.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="v" items="${historialVersiones}">
                                    <tr>
                                        <td>
                                            <span class="badge" style="background: #f1f5f9; color: var(--text-heading); border: 1px solid #cbd5e1;">
                                                <c:out value="${v.fase}" />
                                            </span>
                                        </td>
                                        <td>
                                            <a href="<c:out value='${v.urlDocumento}' />" target="_blank" rel="noopener noreferrer" 
                                               class="btn btn-secondary btn-sm" style="display: inline-flex; gap: 6px; align-items: center;">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                                                <span>Ver Documento</span>
                                            </a>
                                        </td>
                                        <td style="font-size: 0.88rem; color: var(--text-heading);"><c:out value="${v.observacionesEstudiante}" /></td>
                                        <td style="font-size: 0.85rem; color: var(--text-muted);">
                                            <fmt:formatDate value="${v.fechaSubida}" pattern="dd/MM/yyyy HH:mm:ss" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </c:otherwise>
</c:choose>

<jsp:include page="../common/footer.jsp" />
