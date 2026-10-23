<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<header class="app-topbar">
    <div class="topbar-left">
        <button class="mobile-toggle" onclick="toggleSidebar()" aria-label="Abrir Menú">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
        </button>
        <div class="topbar-periodo">
            <span class="periodo-indicator"></span>
            <span class="periodo-label">Periodo Académico: <strong>2026-2 (Vigente)</strong></span>
        </div>
    </div>
    <div class="topbar-right">
        <!-- Selector Rápido Multi-Rol (RF-GEN-03) -->
        <c:if test="${not empty sessionScope.roles && fn:length(sessionScope.roles) > 1}">
            <div class="multi-rol-selector">
                <a href="${pageContext.request.contextPath}/elegir_rol.jsp" class="btn btn-sm btn-outline-warning" title="Cambiar perfil activo">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <span>Cambiar Rol</span>
                </a>
            </div>
        </c:if>

        <!-- Datos del Usuario Activo -->
        <div class="user-profile-menu">
            <div class="user-avatar-circle">
                <c:out value="${fn:substring(sessionScope.nombre != null ? sessionScope.nombre : 'U', 0, 1)}" />
            </div>
            <div class="user-info-text">
                <span class="user-name"><c:out value="${sessionScope.nombre != null ? sessionScope.nombre : 'Usuario UTS'}" /></span>
                <span class="user-role-badge badge-role-${sessionScope.rol_activo}">
                    <c:out value="${sessionScope.rol_activo != null ? sessionScope.rol_activo : 'Estudiante'}" />
                </span>
            </div>
            <a href="${pageContext.request.contextPath}/perfil.jsp" class="topbar-btn" title="Mi Perfil">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            </a>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="topbar-btn btn-logout" title="Cerrar Sesión">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
            </a>
        </div>
    </div>
</header>
