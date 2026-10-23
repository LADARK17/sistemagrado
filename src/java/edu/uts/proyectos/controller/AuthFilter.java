package edu.uts.proyectos.controller;

import edu.uts.proyectos.model.Usuario;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Filtro de seguridad para interceptar accesos y forzar segregación estricta de roles.
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String path = uri.substring(ctx.length());

        // Recursos públicos: login, css, js, imagenes
        if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/") 
                || path.startsWith("/img/") || path.startsWith("/images/")
                || path.equals("/login.jsp") || path.equals("/login") || path.equals("/index.jsp") 
                || path.equals("/inicio.jsp") || path.equals("/auth") || path.equals("/error.jsp")
                || path.equals("/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(ctx + "/login.jsp?error=unauthenticated");
            return;
        }

        String rol = (String) session.getAttribute("rol_activo");
        if (rol == null) {
            rol = (String) session.getAttribute("rol");
        }

        if ((path.startsWith("/admin/") || path.startsWith("/administrador/")) && !Usuario.ROL_ADMIN.equalsIgnoreCase(rol)) {
            response.sendRedirect(ctx + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/comite/") && !Usuario.ROL_COMITE.equalsIgnoreCase(rol) && !Usuario.ROL_ADMIN.equalsIgnoreCase(rol)) {
            response.sendRedirect(ctx + "/login.jsp?error=unauthorized");
            return;
        }
        if ((path.startsWith("/director/") || path.startsWith("/evaluador/") || path.startsWith("/docente/")) 
                && !Usuario.ROL_DOCENTE.equalsIgnoreCase(rol) && !Usuario.ROL_ADMIN.equalsIgnoreCase(rol)) {
            response.sendRedirect(ctx + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/estudiante/") && !Usuario.ROL_ESTUDIANTE.equalsIgnoreCase(rol)) {
            response.sendRedirect(ctx + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
