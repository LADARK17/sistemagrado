<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="WEB-INF/jspf/guard.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seleccionar Perfil de Acceso - SIGRADO UTS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/uts-estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="choose-role-body">

    <div class="choose-role-card">
        <div class="choose-role-header text-center">
            <div class="brand-badge-circle" style="margin: 0 auto 16px;">UTS</div>
            <h2>Seleccionar Perfil de Acceso</h2>
            <p>Hola, <strong><c:out value="${sessionScope.nombre}" /></strong>. Tu cuenta institucional tiene múltiples perfiles autorizados. Elige con cuál deseas interactuar:</p>
        </div>

        <div class="roles-selection-grid">
            <!-- Administrador -->
            <c:if test="${fn:contains(sessionScope.roles, 'administrador')}">
                <a href="${pageContext.request.contextPath}/cambiar_rol.jsp?rol=administrador" class="role-card-item">
                    <div class="role-icon-box" style="background: rgba(99, 102, 241, 0.15); color: #818cf8;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path></svg>
                    </div>
                    <div class="role-details">
                        <h3>Administrador del Sistema</h3>
                        <p>Gestión de usuarios, calendario académico, formatos, aprobación de ideas y proyectos.</p>
                        <span class="role-enter-badge">Ingresar como Administrador &rarr;</span>
                    </div>
                </a>
            </c:if>

            <!-- Comité -->
            <c:if test="${fn:contains(sessionScope.roles, 'comite')}">
                <a href="${pageContext.request.contextPath}/cambiar_rol.jsp?rol=comite" class="role-card-item">
                    <div class="role-icon-box" style="background: rgba(16, 185, 129, 0.15); color: #34d399;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                    </div>
                    <div class="role-details">
                        <h3>Comité de Trabajos de Grado</h3>
                        <p>Emisión de conceptos decisorios en fases 1, 3, 5 y 6; asignación docente y actas.</p>
                        <span class="role-enter-badge">Ingresar como Comité &rarr;</span>
                    </div>
                </a>
            </c:if>

            <!-- Docente -->
            <c:if test="${fn:contains(sessionScope.roles, 'docente')}">
                <a href="${pageContext.request.contextPath}/cambiar_rol.jsp?rol=docente" class="role-card-item">
                    <div class="role-icon-box" style="background: rgba(14, 165, 233, 0.15); color: #38bdf8;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    </div>
                    <div class="role-details">
                        <h3>Cuerpo Docente</h3>
                        <p>Postulación de ideas y gestión de proyectos asignados como Director, Evaluador o Codirector.</p>
                        <span class="role-enter-badge">Ingresar como Docente &rarr;</span>
                    </div>
                </a>
            </c:if>

            <!-- Estudiante -->
            <c:if test="${fn:contains(sessionScope.roles, 'estudiante')}">
                <a href="${pageContext.request.contextPath}/cambiar_rol.jsp?rol=estudiante" class="role-card-item">
                    <div class="role-icon-box" style="background: rgba(245, 158, 11, 0.15); color: #fbbf24;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path></svg>
                    </div>
                    <div class="role-details">
                        <h3>Estudiante</h3>
                        <p>Radicación de propuesta, entrega de anteproyecto e informe, y seguimiento de fases.</p>
                        <span class="role-enter-badge">Ingresar como Estudiante &rarr;</span>
                    </div>
                </a>
            </c:if>
        </div>

        <div class="text-center" style="margin-top: 24px;">
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-sm btn-secondary">Cerrar Sesión</a>
        </div>
    </div>

</body>
</html>
