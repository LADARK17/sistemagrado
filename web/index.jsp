<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGRADO - Sistema de Gestión de Trabajos de Grado | UTS</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
    <!-- Fuentes Oficiales -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/uts-estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="landing-page">

    <!-- Navegación Pública (Fondo Blanco) -->
    <header class="landing-nav">
        <div class="landing-container nav-flex">
            <a href="${pageContext.request.contextPath}/index.jsp" class="landing-brand">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo UTS">
                <div>
                    <div class="brand-title">SIGRADO</div>
                    <div class="brand-sub">Ingeniería de Sistemas • UTS</div>
                </div>
            </a>
            <div class="landing-actions">
                <a href="#fases" class="nav-anchor">Las 6 Fases</a>
                <a href="#calendario" class="nav-anchor">Calendario</a>
                <a href="#formatos" class="nav-anchor">Formatos</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario_id}">
                        <a href="${pageContext.request.contextPath}/inicio.jsp" class="btn btn-warning">
                            <span>Ir a Mi Panel (${sessionScope.rol_activo})</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path><polyline points="10 17 15 12 10 7"></polyline><line x1="15" y1="12" x2="3" y2="12"></line></svg>
                            <span>Ingresar al Sistema</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- HERO PRINCIPAL (Fondo Verde Institucional UTS) -->
    <section class="landing-hero">
        <div class="landing-container text-center">
            <div class="badge-tag">
                <span class="pulse-dot"></span>
                <span>Periodo Académico 2026-2 Vigente</span>
            </div>
            <h1 class="landing-h1">Sistema de Gestión y Seguimiento de Trabajos de Grado</h1>
            <p class="landing-lead">
                Plataforma institucional de las Unidades Tecnológicas de Santander para la gestión integral del ciclo de modalidad de grado en Ingeniería de Sistemas: banco de ideas, radicación con soporte de pago, acompañamiento docente y sustentación final.
            </p>
            <div class="landing-cta-group">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">
                    <span>Acceder con Correo Institucional</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                </a>
                <a href="#fases" class="btn btn-secondary">
                    <span>Conocer el Ciclo de 6 Fases</span>
                </a>
            </div>

            <!-- Atributos Institucionales -->
            <div class="hero-highlights">
                <div class="hero-highlight-item">
                    <span class="hero-highlight-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                    </span>
                    <span>Modalidad Tecnología e Ingeniería</span>
                </div>
                <div class="hero-highlight-item">
                    <span class="hero-highlight-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                    </span>
                    <span>Ciclo Estructurado de 6 Fases</span>
                </div>
                <div class="hero-highlight-item">
                    <span class="hero-highlight-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    </span>
                    <span>Trazabilidad Oficial & Turnitin</span>
                </div>
            </div>
        </div>
    </section>

    <!-- LAS 6 FASES ACADÉMICAS (Fondo Blanco) -->
    <section id="fases" class="landing-section">
        <div class="landing-container">
            <div class="section-header text-center">
                <span class="section-pill">Flujo Metodológico</span>
                <h2>Ciclo de Vida del Trabajo de Grado</h2>
                <p>Proceso estructurado en 6 fases con control de versiones por URL y emisión formal de actas.</p>
            </div>

            <div class="fases-grid">
                <!-- Fase 1 -->
                <div class="fase-card">
                    <div class="fase-number">01</div>
                    <div class="fase-badge">Fase 1 · Comité</div>
                    <h3>Idea y Pago</h3>
                    <p>El estudiante selecciona o postula su idea y adjunta la URL de comprobante de pago de derechos. El Comité decide y asigna Director y Evaluador.</p>
                    <div class="fase-meta">
                        <span><strong>Código:</strong> 65 (Tec.) o 125 (Prof.)</span>
                    </div>
                </div>

                <!-- Fase 2 -->
                <div class="fase-card">
                    <div class="fase-number">02</div>
                    <div class="fase-badge">Fase 2 · Director</div>
                    <h3>Propuesta I (Anteproyecto)</h3>
                    <p>El estudiante entrega el anteproyecto mediante enlace seguro. El Director revisa, adjunta el reporte de Turnitin y emite concepto de avance.</p>
                    <div class="fase-meta">
                        <span><strong>Requisito:</strong> URL Turnitin</span>
                    </div>
                </div>

                <!-- Fase 3 -->
                <div class="fase-card">
                    <div class="fase-number">03</div>
                    <div class="fase-badge">Fase 3 · Evaluador & Comité</div>
                    <h3>Propuesta II</h3>
                    <p>El Evaluador docente analiza la propuesta con F-DC-124 firmado. Una vez avalado, el Comité ratifica la aprobación hacia Fase 4.</p>
                    <div class="fase-meta">
                        <span><strong>Formato:</strong> F-DC-124 firmado</span>
                    </div>
                </div>

                <!-- Fase 4 -->
                <div class="fase-card">
                    <div class="fase-number">04</div>
                    <div class="fase-badge">Fase 4 · Director</div>
                    <h3>Informe I (Desarrollo)</h3>
                    <p>Entrega del informe de desarrollo de la solución tecnológica o monografía. El Director evalúa los productos y emite concepto.</p>
                    <div class="fase-meta">
                        <span><strong>Actor:</strong> Director Docente</span>
                    </div>
                </div>

                <!-- Fase 5 -->
                <div class="fase-card">
                    <div class="fase-number">05</div>
                    <div class="fase-badge">Fase 5 · Evaluador & Comité</div>
                    <h3>Informe II (Calificación)</h3>
                    <p>Evaluación final del informe con diligenciamiento del F-DC-125 y la rejilla evaluativa F-DC-129. El Comité avala para sustentación.</p>
                    <div class="fase-meta">
                        <span><strong>Formatos:</strong> F-DC-125 y F-DC-129</span>
                    </div>
                </div>

                <!-- Fase 6 -->
                <div class="fase-card">
                    <div class="fase-number">06</div>
                    <div class="fase-badge">Fase 6 · Comité</div>
                    <h3>Cierre y Sustentación</h3>
                    <p>Programación de fecha, jurados y enlace. Tras la sustentación, se registra el acta de cierre y el proyecto culmina en estado <strong>Finalizado</strong>.</p>
                    <div class="fase-meta">
                        <span><strong>Cierre:</strong> Acta de Sustentación</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CALENDARIO ACADÉMICO DEL PERIODO (Fondo Verde Institucional con Tarjeta Blanca) -->
    <section id="calendario" class="landing-section">
        <div class="landing-container">
            <div class="section-header text-center">
                <span class="section-pill">Cronograma Oficial</span>
                <h2>Calendario Académico Periodo 2026-2</h2>
                <p>Fechas límite y ventanas de postulación aprobadas por el Comité de Grado.</p>
            </div>

            <div class="calendario-table-card">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Hito / Actividad Académica</th>
                            <th>Fecha de Apertura</th>
                            <th>Fecha Límite</th>
                            <th>Estado Actual</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Propuestas al Banco de Ideas (Docentes y Estudiantes)</strong></td>
                            <td>01 de Agosto de 2026</td>
                            <td>15 de Septiembre de 2026</td>
                            <td><span class="status-chip chip-neutral">Concluida</span></td>
                        </tr>
                        <tr>
                            <td><strong>Inscripción y Radicación de Nuevos Proyectos (Fase 1)</strong></td>
                            <td>15 de Agosto de 2026</td>
                            <td>31 de Octubre de 2026</td>
                            <td><span class="status-chip chip-approved">En Curso (Abierto)</span></td>
                        </tr>
                        <tr>
                            <td><strong>Fecha Límite de Aprobación de Propuestas por Comité</strong></td>
                            <td>--</td>
                            <td>20 de Noviembre de 2026</td>
                            <td><span class="status-chip chip-pending">Próxima</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- CATÁLOGO DE FORMATOS DE GRADO (Fondo Blanco) -->
    <section id="formatos" class="landing-section">
        <div class="landing-container">
            <div class="section-header text-center">
                <span class="section-pill">Documentación Institucional</span>
                <h2>Formatos Oficiales de Trabajo de Grado</h2>
                <p>Descarga las plantillas vigentes del Sistema Integrado de Gestión UTS.</p>
            </div>

            <div class="formatos-grid">
                <div class="formato-item">
                    <div class="formato-code">F-DC-124</div>
                    <div class="formato-body">
                        <h4>Propuesta de Trabajo de Grado</h4>
                        <p>Plantilla estándar para formulación de anteproyecto, objetivos, justificación y metodología.</p>
                    </div>
                    <a href="https://docs.google.com/document/d/plantilla-fdc-124-uts" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                        <span>Ver Plantilla</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    </a>
                </div>

                <div class="formato-item">
                    <div class="formato-code">F-DC-125</div>
                    <div class="formato-body">
                        <h4>Informe Final de Trabajo de Grado</h4>
                        <p>Estructura final del proyecto con marco teórico, resultados, pruebas y conclusiones.</p>
                    </div>
                    <a href="https://docs.google.com/document/d/plantilla-fdc-125-uts" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                        <span>Ver Plantilla</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    </a>
                </div>

                <div class="formato-item">
                    <div class="formato-code">F-DC-129</div>
                    <div class="formato-body">
                        <h4>Rejilla Evaluativa para Sustentación</h4>
                        <p>Instrumento de calificación para directores y evaluadores docentes en Fase 5 y 6.</p>
                    </div>
                    <a href="https://docs.google.com/document/d/plantilla-fdc-129-uts" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                        <span>Ver Plantilla</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    </a>
                </div>

                <div class="formato-item">
                    <div class="formato-code">F-DC-130</div>
                    <div class="formato-body">
                        <h4>Acta de Sustentación de Grado</h4>
                        <p>Documento formal emitido por el jurado calificador y Comité para el cierre del proyecto.</p>
                    </div>
                    <a href="https://docs.google.com/document/d/plantilla-fdc-130-uts" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                        <span>Ver Plantilla</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- BANNER PRE-FOOTER (Fondo Verde Institucional) -->
    <section class="landing-cta-banner">
        <div class="landing-container">
            <div class="cta-banner-flex">
                <div class="cta-banner-content">
                    <h3>¿Listo para iniciar tu proceso de Grado?</h3>
                    <p>Accede con tus credenciales institucionales UTS para radicar propuestas, registrar avances o evaluar proyectos.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="cta-banner-btn">
                        <span>Ingresar a SIGRADO</span>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER PÚBLICO (Fondo Verde Oscuro Profundo UTS) -->
    <footer class="landing-footer">
        <div class="landing-container footer-flex">
            <div class="footer-info">
                <strong>Unidades Tecnológicas de Santander</strong>
                <span>Facultad de Ciencias Naturales e Ingenierías • Programa de Ingeniería de Sistemas</span>
                <small>Bucaramanga, Santander, Colombia • Periodo 2026-2</small>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm btn-warning">Ingreso Administrativo / Académico</a>
            </div>
        </div>
    </footer>

</body>
</html>
