<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card" style="max-width: 650px; margin: 0 auto;">
    <div class="uts-card-header">
        <h3>
            <c:choose>
                <c:when test="${esNuevo}">Registrar Nuevo Usuario</c:when>
                <c:otherwise>Editar Usuario #<c:out value="${usuario.id}" /></c:otherwise>
            </c:choose>
        </h3>
        <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary btn-sm">Volver</a>
    </div>

    <form action="${pageContext.request.contextPath}/admin/guardar" method="POST">
        <input type="hidden" name="id" value="<c:out value='${usuario.id}' />" />

        <div class="form-group">
            <label for="nombreCompleto">Nombre Completo:</label>
            <input type="text" id="nombreCompleto" name="nombreCompleto" required class="form-control"
                   value="<c:out value='${usuario.nombreCompleto}' />" placeholder="ej. Mg. Juan Carlos Pérez" />
        </div>

        <div class="form-group">
            <label for="documento">Número de Documento de Identidad:</label>
            <input type="text" id="documento" name="documento" required class="form-control"
                   value="<c:out value='${usuario.documento}' />" placeholder="ej. 1098700123" />
        </div>

        <div class="form-group">
            <label for="correo">Correo Electrónico Institucional:</label>
            <input type="email" id="correo" name="correo" required class="form-control"
                   value="<c:out value='${usuario.correo}' />" placeholder="usuario@correo.uts.edu.co" />
        </div>

        <div class="form-group">
            <label for="rol">Rol Institucional (Exactamente 5 permitidos):</label>
            <select id="rol" name="rol" required class="form-control">
                <option value="Estudiante" <c:if test="${usuario.rol == 'Estudiante'}">selected</c:if>>Estudiante</option>
                <option value="Director" <c:if test="${usuario.rol == 'Director'}">selected</c:if>>Director</option>
                <option value="Evaluador" <c:if test="${usuario.rol == 'Evaluador'}">selected</c:if>>Evaluador</option>
                <option value="Coordinación" <c:if test="${usuario.rol == 'Coordinación'}">selected</c:if>>Coordinación / Comité</option>
                <option value="Administrador" <c:if test="${usuario.rol == 'Administrador'}">selected</c:if>>Administrador</option>
            </select>
        </div>

        <div class="form-group">
            <label for="password">
                <c:choose>
                    <c:when test="${esNuevo}">Contraseña Inicial (Mínimo 8 caracteres):</c:when>
                    <c:otherwise>Nueva Contraseña (dejar en blanco para mantener la actual):</c:otherwise>
                </c:choose>
            </label>
            <input type="password" id="password" name="password" class="form-control" 
                   <c:if test="${esNuevo}">required</c:if> placeholder="••••••••" />
        </div>

        <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
            <input type="checkbox" id="estadoActivo" name="estadoActivo" 
                   <c:if test="${usuario.estadoActivo == null || usuario.estadoActivo}">checked</c:if> />
            <label for="estadoActivo" style="margin-bottom: 0;">Usuario Activo para iniciar sesión</label>
        </div>

        <div style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px;">
            <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">Cancelar</a>
            <button type="submit" class="btn btn-primary">Guardar Usuario</button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />
