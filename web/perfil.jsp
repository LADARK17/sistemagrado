<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="WEB-INF/jspf/guard.jspf" %>
<%@ include file="WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.util.PasswordUtil, edu.uts.proyectos.model.Usuario, java.sql.Connection, java.sql.PreparedStatement" %>

<%
    String mensajeExito = null;
    String mensajeError = null;
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String telefono = request.getParameter("telefono");
        String passActual = request.getParameter("password_actual");
        String passNueva = request.getParameter("password_nueva");
        String passConfirm = request.getParameter("password_confirm");

        if (telefono != null) {
            telefono = telefono.trim();
        }

        boolean cambiarPass = (passNueva != null && !passNueva.trim().isEmpty());

        if (cambiarPass) {
            if (passNueva.length() < 8) {
                mensajeError = "La nueva contraseña debe tener al menos 8 caracteres.";
            } else if (!passNueva.equals(passConfirm)) {
                mensajeError = "La nueva contraseña y la confirmación no coinciden.";
            }
        }

        if (mensajeError == null) {
            // Actualizar en BD o MockDataStore
            Connection conn = null;
            try {
                conn = ConexionDB.getConnection();
            } catch (Exception ignored) {}
            if (conn != null) {
                try {
                    if (cambiarPass) {
                        String nuevoHash = PasswordUtil.hashPassword(passNueva);
                        PreparedStatement ps = conn.prepareStatement("UPDATE usuarios SET telefono = ?, password_hash = ? WHERE id = ?");
                        ps.setString(1, telefono);
                        ps.setString(2, nuevoHash);
                        ps.setInt(3, usuarioId);
                        ps.executeUpdate();
                        ps.close();
                    } else {
                        PreparedStatement ps = conn.prepareStatement("UPDATE usuarios SET telefono = ? WHERE id = ?");
                        ps.setString(1, telefono);
                        ps.setInt(2, usuarioId);
                        ps.executeUpdate();
                        ps.close();
                    }
                    mensajeExito = "Perfil actualizado exitosamente.";
                } catch (Exception e) {
                    mensajeError = "Error al actualizar perfil en base de datos: " + e.getMessage();
                }
            } else {
                // MockDataStore
                Usuario u = MockDataStore.USUARIOS.get(usuarioId);
                if (u != null) {
                    if (telefono != null) u.setTelefono(telefono);
                    if (cambiarPass) u.setPasswordHash(PasswordUtil.hashPassword(passNueva));
                    mensajeExito = "Perfil actualizado exitosamente (Modo Demostración).";
                }
            }
        }
    }
%>

<jsp:include page="WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Mi Perfil Institucional - SIGRADO UTS" />
</jsp:include>
<jsp:include page="WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="perfil" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-GEN-04</span>
                <h2>Mi Perfil Institucional</h2>
                <p>Gestiona tus datos de contacto y credenciales de acceso a la plataforma.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/inicio.jsp" class="btn btn-secondary">&larr; Volver a Mi Panel</a>
            </div>
        </div>

        <% if (mensajeExito != null) { %>
            <div class="alert alert-success">
                <span>✔️</span>
                <div><%= mensajeExito %></div>
            </div>
        <% } %>

        <% if (mensajeError != null) { %>
            <div class="alert alert-danger">
                <span>⚠️</span>
                <div><%= mensajeError %></div>
            </div>
        <% } %>

        <div class="uts-card" style="max-width: 720px; margin: 0 auto;">
            <form action="${pageContext.request.contextPath}/perfil.jsp" method="POST" class="uts-form">
                
                <div class="form-section-title">Datos Personales y Académicos (Solo Lectura)</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Nombre Completo:</label>
                        <input type="text" value="<c:out value='${sessionScope.nombre}' />" disabled class="input-disabled">
                    </div>
                    <div class="form-group">
                        <label>Rol Activo en Sesión:</label>
                        <input type="text" value="<c:out value='${sessionScope.rol_activo}' />" disabled class="input-disabled">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Correo Electrónico Institucional:</label>
                        <input type="text" value="<c:out value='${sessionScope.correo}' />" disabled class="input-disabled">
                        <small style="color: var(--text-muted); font-size: 0.8rem;">El correo institucional no es editable.</small>
                    </div>
                    <div class="form-group">
                        <label>Número de Documento:</label>
                        <input type="text" value="<c:out value='${sessionScope.documento != null ? sessionScope.documento : \"Registrado\"}' />" disabled class="input-disabled">
                        <small style="color: var(--text-muted); font-size: 0.8rem;">El número de identificación no es editable.</small>
                    </div>
                </div>

                <div class="form-section-title" style="margin-top: 24px;">Información de Contacto y Seguridad (Editable)</div>
                <div class="form-group">
                    <label for="telefono">Teléfono / Celular de Contacto:</label>
                    <input type="tel" id="telefono" name="telefono" value="<c:out value='${sessionScope.telefono != null ? sessionScope.telefono : \"3157000000\"}' />" placeholder="Ej. 3157000000" class="form-control">
                </div>

                <div class="form-grid" style="margin-top: 16px;">
                    <div class="form-group">
                        <label for="password_nueva">Nueva Contraseña (Opcional):</label>
                        <input type="password" id="password_nueva" name="password_nueva" placeholder="Mínimo 8 caracteres" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="password_confirm">Confirmar Nueva Contraseña:</label>
                        <input type="password" id="password_confirm" name="password_confirm" placeholder="Repite la contraseña" class="form-control">
                    </div>
                </div>

                <div style="margin-top: 28px; display: flex; justify-content: flex-end; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/inicio.jsp" class="btn btn-secondary">Cancelar</a>
                    <button type="submit" class="btn btn-primary">
                        <span>Guardar Cambios</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="WEB-INF/jspf/footer.jsp" />

