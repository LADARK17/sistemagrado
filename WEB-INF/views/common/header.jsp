<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Trabajos de Grado - UTS</title>
    <!-- Favicon Oficial UTS -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/uts-estilos.css">
    <script src="${pageContext.request.contextPath}/assets/js/validaciones.js"></script>
</head>
<body>
<div class="app-layout">
    <!-- BARRA LATERAL (SIDEBAR INSTITUCIONAL UTS) -->
    <aside class="uts-sidebar">
        <a href="${pageContext.request.contextPath}/auth" class="sidebar-brand" style="display: flex; align-items: center; gap: 12px; text-decoration: none;">
            <div style="background: #ffffff; padding: 5px 10px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.18); flex-shrink: 0;">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo UTS" style="height: 30px; width: auto; object-fit: contain;">
            </div>
            <div class="brand-info">
                <span class="brand-title">Grados UTS</span>
                <span class="brand-subtitle">Gestión y Seguimiento</span>
            </div>
        </a>

        <!-- PERFIL DE USUARIO EN SIDEBAR -->
        <c:if test="${not empty sessionScope.nombre}">
            <div class="sidebar-user">
                <div class="user-avatar-circle">
                    <c:out value="${fn:substring(sessionScope.nombre, 0, 1)}" />
                </div>
                <div class="user-details">
                    <div class="user-name" title="<c:out value='${sessionScope.nombre}' />">
                        <c:out value="${sessionScope.nombre}" />
                    </div>
                    <span class="user-role-badge">
                        <c:out value="${sessionScope.rol}" />
                    </span>
                </div>
            </div>
        </c:if>

        <!-- MENÚ DE NAVEGACIÓN LATERAL POR ROL -->
        <nav class="sidebar-nav">
            <div class="nav-section-title">Menú Principal</div>

            <c:choose>
                <%-- ROL: ADMINISTRADOR --%>
                <c:when test="${sessionScope.rol == 'Administrador'}">
                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="nav-item-link active">
                        <svg class="nav-icon" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        <span class="nav-item-text">Gestión de Usuarios</span>
                    </a>
                </c:when>

                <%-- ROL: COORDINACIÓN / COMITÉ --%>
                <c:when test="${sessionScope.rol == 'Coordinación'}">
                    <a href="${pageContext.request.contextPath}/comite/dashboard" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                        <span class="nav-item-text">Tablero General</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/comite/solicitudes-pago" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <span class="nav-item-text">Fase 1 (Pagos)</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/comite/banco-ideas" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                        <span class="nav-item-text">Banco de Ideas</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/comite/sustentaciones" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        <span class="nav-item-text">Sustentaciones</span>
                    </a>
                </c:when>

                <%-- ROL: DIRECTOR --%>
                <c:when test="${sessionScope.rol == 'Director'}">
                    <a href="${pageContext.request.contextPath}/director/proyectos" class="nav-item-link active">
                        <svg class="nav-icon" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><polyline points="9 11 12 14 22 4"></polyline></svg>
                        <span class="nav-item-text">Proyectos a Cargo</span>
                    </a>
                </c:when>

                <%-- ROL: EVALUADOR --%>
                <c:when test="${sessionScope.rol == 'Evaluador'}">
                    <a href="${pageContext.request.contextPath}/evaluador/proyectos" class="nav-item-link active">
                        <svg class="nav-icon" viewBox="0 0 24 24"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect><path d="m9 14 2 2 4-4"></path></svg>
                        <span class="nav-item-text">Proyectos a Evaluar</span>
                    </a>
                </c:when>

                <%-- ROL: ESTUDIANTE --%>
                <c:when test="${sessionScope.rol == 'Estudiante'}">
                    <a href="${pageContext.request.contextPath}/estudiante/dashboard" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                        <span class="nav-item-text">Mi Proyecto</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/estudiante/radicar" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                        <span class="nav-item-text">Radicar Propuesta</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/estudiante/banco-ideas" class="nav-item-link">
                        <svg class="nav-icon" viewBox="0 0 24 24"><line x1="9" y1="18" x2="15" y2="18"></line><line x1="10" y1="22" x2="14" y2="22"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                        <span class="nav-item-text">Banco de Ideas</span>
                    </a>
                </c:when>
            </c:choose>
        </nav>

        <!-- FOOTER DEL SIDEBAR CON BOTÓN DE LOGOUT -->
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-sidebar-logout">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                <span>Cerrar Sesión</span>
            </a>
        </div>
    </aside>

    <!-- WRAPPER DE CONTENIDO PRINCIPAL -->
    <div class="main-wrapper">
        <!-- TOPBAR SUPERIOR -->
        <header class="uts-topbar">
            <div class="topbar-left">
                <span class="topbar-page-title">
                    <c:choose>
                        <c:when test="${sessionScope.rol == 'Administrador'}">Panel de Administración</c:when>
                        <c:when test="${sessionScope.rol == 'Coordinación'}">Comité de Trabajos de Grado</c:when>
                        <c:when test="${sessionScope.rol == 'Director'}">Dirección de Trabajos de Grado</c:when>
                        <c:when test="${sessionScope.rol == 'Evaluador'}">Evaluación de Trabajos de Grado</c:when>
                        <c:when test="${sessionScope.rol == 'Estudiante'}">Portal Estudiantil de Grados</c:when>
                        <c:otherwise>Sistema de Trabajos de Grado</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="topbar-right">
                <span class="period-badge">Periodo Académico 2026-II</span>
            </div>
        </header>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="uts-main-content">
            <div class="uts-container">
                <jsp:include page="alerts.jsp" />
