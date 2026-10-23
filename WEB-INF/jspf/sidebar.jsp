<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="app-sidebar" id="appSidebar">
    <div class="sidebar-brand">
        <a href="${pageContext.request.contextPath}/inicio.jsp" class="brand-link" style="display: flex; align-items: center; gap: 12px; text-decoration: none;">
            <div style="background: #ffffff; padding: 5px 10px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.18); flex-shrink: 0;">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo UTS" style="height: 30px; width: auto; object-fit: contain;">
            </div>
            <div class="brand-text">
                <span class="brand-title" style="display: block; font-weight: 800; font-size: 1.15rem; color: #ffffff; letter-spacing: -0.3px;">SIGRADO</span>
                <span class="brand-sub" style="display: block; font-size: 0.72rem; color: #cbd5e1; font-weight: 500;">UTS Sistemas 2026</span>
            </div>
        </a>
    </div>

    <nav class="sidebar-nav">
        <!-- ROL: ADMINISTRADOR -->
        <c:if test="${sessionScope.rol_activo == 'administrador'}">
            <div class="nav-section-title">ADMINISTRACIÓN & COORDINACIÓN</div>
            <a href="${pageContext.request.contextPath}/administrador/proyectos.jsp" class="nav-item ${param.active == 'proyectos' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                <span>Gestión de Proyectos</span>
            </a>
            <a href="${pageContext.request.contextPath}/administrador/propuestas_banco.jsp" class="nav-item ${param.active == 'propuestas_banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                <span>Revisión Propuestas Banco</span>
            </a>
            <a href="${pageContext.request.contextPath}/administrador/banco.jsp" class="nav-item ${param.active == 'banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                <span>Catálogo Banco de Ideas</span>
            </a>
            <a href="${pageContext.request.contextPath}/administrador/configuracion.jsp" class="nav-item ${param.active == 'configuracion' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                <span>Calendario (Periodos)</span>
            </a>
            <a href="${pageContext.request.contextPath}/administrador/formatos.jsp" class="nav-item ${param.active == 'formatos' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                <span>Gestión de Formatos</span>
            </a>
        </c:if>

        <!-- ROL: COMITÉ -->
        <c:if test="${sessionScope.rol_activo == 'comite'}">
            <div class="nav-section-title">DECISIONES DE COMITÉ</div>
            <a href="${pageContext.request.contextPath}/comite/proyectos.jsp" class="nav-item ${param.active == 'proyectos' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                <span>Proyectos a Evaluar (Fases 1,3,5,6)</span>
            </a>
            <a href="${pageContext.request.contextPath}/comite/seguimiento.jsp" class="nav-item ${param.active == 'seguimiento' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                <span>Seguimiento de Fases</span>
            </a>
            <a href="${pageContext.request.contextPath}/comite/propuestas_banco.jsp" class="nav-item ${param.active == 'propuestas_banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                <span>Propuestas del Banco</span>
            </a>
            <a href="${pageContext.request.contextPath}/comite/banco.jsp" class="nav-item ${param.active == 'banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                <span>Banco de Ideas</span>
            </a>
            <a href="${pageContext.request.contextPath}/comite/usuarios.jsp" class="nav-item ${param.active == 'usuarios' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                <span>Directorio de Usuarios</span>
            </a>
        </c:if>

        <!-- ROL: DOCENTE -->
        <c:if test="${sessionScope.rol_activo == 'docente'}">
            <div class="nav-section-title">ACOMPAÑAMIENTO DOCENTE</div>
            <a href="${pageContext.request.contextPath}/docente/director.jsp" class="nav-item ${param.active == 'director' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                <span>Docente Director (Fases 2 y 4)</span>
            </a>
            <a href="${pageContext.request.contextPath}/docente/evaluador.jsp" class="nav-item ${param.active == 'evaluador' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polygon points="12 8 8 12 12 16 16 12 12 8"></polygon></svg>
                <span>Docente Evaluador (Fases 3 y 5)</span>
            </a>
            <a href="${pageContext.request.contextPath}/docente/codirector.jsp" class="nav-item ${param.active == 'codirector' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                <span>Docente Codirector</span>
            </a>
            <a href="${pageContext.request.contextPath}/docente/propuestas_banco.jsp" class="nav-item ${param.active == 'propuestas_banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                <span>Mis Propuestas de Ideas</span>
            </a>
            <a href="${pageContext.request.contextPath}/docente/banco.jsp" class="nav-item ${param.active == 'banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                <span>Banco de Ideas UTS</span>
            </a>
        </c:if>

        <!-- ROL: ESTUDIANTE -->
        <c:if test="${sessionScope.rol_activo == 'estudiante'}">
            <div class="nav-section-title">MI TRABAJO DE GRADO</div>
            <a href="${pageContext.request.contextPath}/estudiante/proyecto.jsp" class="nav-item ${param.active == 'proyecto' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path></svg>
                <span>Mi Proyecto de Grado</span>
            </a>
            <a href="${pageContext.request.contextPath}/estudiante/seguimiento.jsp" class="nav-item ${param.active == 'seguimiento' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                <span>Mapa de Fases (1 a 6)</span>
            </a>
            <a href="${pageContext.request.contextPath}/estudiante/versiones.jsp" class="nav-item ${param.active == 'versiones' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"></path></svg>
                <span>Historial de Versiones</span>
            </a>
            <a href="${pageContext.request.contextPath}/estudiante/banco.jsp" class="nav-item ${param.active == 'banco' ? 'active' : ''}">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                <span>Banco de Ideas de Grado</span>
            </a>
        </c:if>

        <!-- SECCIÓN COMÚN TRANSVERSAL (RF-ADM-12, RF-COM-08) -->
        <div class="nav-section-title">RECURSOS ACADÉMICOS</div>
        <a href="${pageContext.request.contextPath}/comun/calendario.jsp" class="nav-item ${param.active == 'calendario' ? 'active' : ''}">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
            <span>Calendario del Periodo</span>
        </a>
        <a href="${pageContext.request.contextPath}/comun/formatos.jsp" class="nav-item ${param.active == 'formatos_comun' ? 'active' : ''}">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
            <span>Formatos Institucionales</span>
        </a>
    </nav>
</aside>
