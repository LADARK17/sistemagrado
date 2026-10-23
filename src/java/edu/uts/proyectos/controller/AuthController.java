package edu.uts.proyectos.controller;

import edu.uts.proyectos.dao.UsuarioDAO;
import edu.uts.proyectos.model.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Controlador de Autenticación y Gestión de Sesión (RF-GEN-02, RF-GEN-03).
 * Soporta los 4 roles canónicos y redirección multi-rol.
 */
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "login";

        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp?logout=true");
            return;
        }

        // Si ya está autenticado, redirigir según su rol activo
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario_id") != null) {
            String rolActivo = (String) session.getAttribute("rol_activo");
            if (rolActivo == null) {
                Usuario u = (Usuario) session.getAttribute("usuario");
                if (u != null) rolActivo = u.getRol();
            }
            redirigirSegunRol(rolActivo, request, response);
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String identificador = request.getParameter("identificador");
        String password = request.getParameter("password");

        if (identificador == null || identificador.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMensaje", "Debe ingresar su correo institucional o documento y su contraseña.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            Usuario usuario = usuarioDAO.autenticar(identificador, password);
            if (usuario != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("usuario_id", usuario.getId());
                session.setAttribute("nombre", usuario.getNombreCompleto());
                session.setAttribute("correo", usuario.getCorreo());
                session.setAttribute("documento", usuario.getDocumento());
                session.setAttribute("telefono", usuario.getTelefono());

                List<String> roles = usuario.getRoles();
                session.setAttribute("roles", roles);

                // Multi-rol (RF-GEN-03): si el usuario tiene más de un rol, presentar selector de perfil
                if (roles != null && roles.size() > 1) {
                    session.setAttribute("rol_activo", roles.get(0));
                    response.sendRedirect(request.getContextPath() + "/elegir_rol.jsp");
                    return;
                }

                String rolActivo = (roles != null && !roles.isEmpty()) ? roles.get(0) : usuario.getRol();
                session.setAttribute("rol_activo", rolActivo);
                session.setAttribute("rol", rolActivo);

                redirigirSegunRol(rolActivo, request, response);
            } else {
                request.setAttribute("errorMensaje", "Credenciales incorrectas o usuario inactivo. Verifique sus datos.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error en el servicio de autenticación: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void redirigirSegunRol(String rol, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ctx = request.getContextPath();
        if (rol == null) {
            response.sendRedirect(ctx + "/inicio.jsp");
            return;
        }

        String r = rol.toLowerCase().trim();
        switch (r) {
            case "administrador":
                response.sendRedirect(ctx + "/administrador/proyectos.jsp");
                break;
            case "comite":
                response.sendRedirect(ctx + "/comite/proyectos.jsp");
                break;
            case "docente":
                response.sendRedirect(ctx + "/docente/director.jsp");
                break;
            case "estudiante":
            default:
                response.sendRedirect(ctx + "/estudiante/proyecto.jsp");
                break;
        }
    }
}
