<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aviso del Sistema - SIGRADO UTS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/uts-estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="choose-role-body">

    <div class="choose-role-card text-center" style="max-width: 580px;">
        <div style="width: 64px; height: 64px; border-radius: 50%; background: rgba(239, 68, 68, 0.15); color: #ef4444; display: flex; align-items: center; justify-content: center; margin: 0 auto 18px;">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        </div>
        
        <h2>Acceso Restringido o Error</h2>
        <p style="color: var(--text-muted); margin: 12px 0 24px; font-size: 0.95rem;">
            <c:choose>
                <c:when test="${not empty param.msg}">
                    <c:out value="${param.msg}" />
                </c:when>
                <c:otherwise>
                    No tienes los privilegios suficientes para acceder a este recurso o la acción solicitada no es válida para tu rol activo.
                </c:otherwise>
            </c:choose>
        </p>

        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/inicio.jsp" class="btn btn-primary">Ir a Mi Panel Principal</a>
            <a href="${pageContext.request.contextPath}/elegir_rol.jsp" class="btn btn-secondary">Cambiar de Perfil</a>
        </div>
    </div>

</body>
</html>
