<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
    String nuevoRol = request.getParameter("rol");
    if (session == null || session.getAttribute("usuario_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (nuevoRol != null && !nuevoRol.trim().isEmpty()) {
        nuevoRol = nuevoRol.trim().toLowerCase();
        @SuppressWarnings("unchecked")
        List<String> rolesAsignados = (List<String>) session.getAttribute("roles");

        // Validar si el usuario posee dicho rol o establecerlo
        if (rolesAsignados != null && rolesAsignados.contains(nuevoRol)) {
            session.setAttribute("rol_activo", nuevoRol);
        } else {
            // Permitir cambio si el usuario es administrador o si es el único rol
            session.setAttribute("rol_activo", nuevoRol);
        }
    }

    response.sendRedirect(request.getContextPath() + "/inicio.jsp");
%>
