<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
    if (session == null || session.getAttribute("usuario_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String rolActivo = (String) session.getAttribute("rol_activo");

    if (rolActivo == null || rolActivo.trim().isEmpty()) {
        @SuppressWarnings("unchecked")
        List<String> roles = (List<String>) session.getAttribute("roles");
        if (roles != null && roles.size() > 1) {
            response.sendRedirect(request.getContextPath() + "/elegir_rol.jsp");
            return;
        } else if (roles != null && roles.size() == 1) {
            rolActivo = roles.get(0);
            session.setAttribute("rol_activo", rolActivo);
        } else {
            rolActivo = "estudiante";
            session.setAttribute("rol_activo", rolActivo);
        }
    }

    rolActivo = rolActivo.toLowerCase();

    switch (rolActivo) {
        case "administrador":
            response.sendRedirect(request.getContextPath() + "/administrador/proyectos.jsp");
            break;
        case "comite":
            response.sendRedirect(request.getContextPath() + "/comite/proyectos.jsp");
            break;
        case "docente":
            response.sendRedirect(request.getContextPath() + "/docente/director.jsp");
            break;
        case "estudiante":
        default:
            response.sendRedirect(request.getContextPath() + "/estudiante/proyecto.jsp");
            break;
    }
%>
