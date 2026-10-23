<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guard.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Formatos Institucionales - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="formatos_comun" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-04 / RF-ADM-12</span>
                <h2>Formatos Institucionales de Grado</h2>
                <p>Plantillas oficiales del Sistema Integrado de Gestión para la elaboración de entregables.</p>
            </div>
        </div>

        <div class="formatos-grid" style="margin-top: 0;">
            <div class="formato-item">
                <div class="formato-code">F-DC-124</div>
                <div class="formato-body">
                    <h4>Propuesta de Trabajo de Grado (Fases 1, 2 y 3)</h4>
                    <p>Estructura base para la definición del problema, justificación, objetivos general y específicos, y metodología preliminar.</p>
                </div>
                <a href="https://docs.google.com/document/d/plantilla-fdc-124-uts" target="_blank" rel="noopener" class="btn btn-primary">
                    <span>Acceder a Plantilla</span>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                </a>
            </div>

            <div class="formato-item">
                <div class="formato-code">F-DC-125</div>
                <div class="formato-body">
                    <h4>Informe Final de Trabajo de Grado (Fases 4 y 5)</h4>
                    <p>Documento formal de culminación académica: desarrollo tecnológico, arquitectura, pruebas de software y conclusiones.</p>
                </div>
                <a href="https://docs.google.com/document/d/plantilla-fdc-125-uts" target="_blank" rel="noopener" class="btn btn-primary">
                    <span>Acceder a Plantilla</span>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                </a>
            </div>

            <div class="formato-item">
                <div class="formato-code">F-DC-129</div>
                <div class="formato-body">
                    <h4>Rejilla Evaluativa para Sustentación (Fase 5)</h4>
                    <p>Instrumento de rúbrica cuantitativa y cualitativa para uso exclusivo de docentes evaluadores.</p>
                </div>
                <a href="https://docs.google.com/document/d/plantilla-fdc-129-uts" target="_blank" rel="noopener" class="btn btn-primary">
                    <span>Acceder a Plantilla</span>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                </a>
            </div>

            <div class="formato-item">
                <div class="formato-code">F-DC-130</div>
                <div class="formato-body">
                    <h4>Acta de Sustentación de Grado (Fase 6)</h4>
                    <p>Formato de acta con veredicto final emitido por el jurado para el cierre formal del proyecto.</p>
                </div>
                <a href="https://docs.google.com/document/d/plantilla-fdc-130-uts" target="_blank" rel="noopener" class="btn btn-primary">
                    <span>Acceder a Plantilla</span>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

