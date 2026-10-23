package edu.uts.proyectos.controller;

import edu.uts.proyectos.dao.UsuarioDAO;
import edu.uts.proyectos.model.Usuario;
import edu.uts.proyectos.util.PasswordUtil;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/usuarios")) {
            listarUsuarios(request, response);
        } else if (path.equals("/nuevo")) {
            mostrarFormularioNuevo(request, response);
        } else if (path.equals("/editar")) {
            mostrarFormularioEditar(request, response);
        } else if (path.equals("/inactivar")) {
            inactivarUsuario(request, response);
        } else if (path.equals("/eliminar")) {
            eliminarUsuario(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getPathInfo();
        if (path != null && path.equals("/guardar")) {
            guardarUsuario(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            request.setAttribute("usuarios", usuarios);
            request.getRequestDispatcher("/WEB-INF/views/admin/usuarios-lista.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al listar usuarios: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/usuarios-lista.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("usuario", new Usuario());
        request.setAttribute("esNuevo", true);
        request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario usuario = usuarioDAO.buscarPorId(id);
            if (usuario == null) {
                response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=notfound");
                return;
            }
            request.setAttribute("usuario", usuario);
            request.setAttribute("esNuevo", false);
            request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=invalidid");
        }
    }

    private void guardarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String nombre = request.getParameter("nombreCompleto");
        String correo = request.getParameter("correo");
        String documento = request.getParameter("documento");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        String estadoStr = request.getParameter("estadoActivo");

        boolean esNuevo = (idStr == null || idStr.trim().isEmpty() || "0".equals(idStr));
        Integer id = esNuevo ? null : Integer.parseInt(idStr);

        try {
            // Validar unicidad
            if (usuarioDAO.existeCorreo(correo, id)) {
                request.setAttribute("errorMensaje", "El correo institucional ya se encuentra registrado.");
                Usuario u = new Usuario(nombre, correo, documento, null, rol);
                u.setId(id);
                request.setAttribute("usuario", u);
                request.setAttribute("esNuevo", esNuevo);
                request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
                return;
            }

            if (usuarioDAO.existeDocumento(documento, id)) {
                request.setAttribute("errorMensaje", "El número de documento ya se encuentra registrado.");
                Usuario u = new Usuario(nombre, correo, documento, null, rol);
                u.setId(id);
                request.setAttribute("usuario", u);
                request.setAttribute("esNuevo", esNuevo);
                request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
                return;
            }

            Usuario u = new Usuario();
            u.setId(id);
            u.setNombreCompleto(nombre);
            u.setCorreo(correo);
            u.setDocumento(documento);
            u.setRol(rol);
            u.setEstadoActivo(estadoStr != null && (estadoStr.equals("on") || estadoStr.equals("true") || estadoStr.equals("1")));

            if (esNuevo) {
                if (password == null || password.trim().length() < 8) {
                    request.setAttribute("errorMensaje", "La contraseña debe tener mínimo 8 caracteres.");
                    request.setAttribute("usuario", u);
                    request.setAttribute("esNuevo", true);
                    request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
                    return;
                }
                u.setPasswordHash(PasswordUtil.hashPassword(password));
                usuarioDAO.insertar(u);
            } else {
                boolean cambiarClave = (password != null && !password.trim().isEmpty());
                if (cambiarClave) {
                    if (password.trim().length() < 8) {
                        request.setAttribute("errorMensaje", "La nueva contraseña debe tener mínimo 8 caracteres.");
                        request.setAttribute("usuario", u);
                        request.setAttribute("esNuevo", false);
                        request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
                        return;
                    }
                    u.setPasswordHash(PasswordUtil.hashPassword(password));
                }
                usuarioDAO.actualizar(u, cambiarClave);
            }

            response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=guardado");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error en base de datos: " + e.getMessage());
            Usuario u = new Usuario(nombre, correo, documento, null, rol);
            u.setId(id);
            request.setAttribute("usuario", u);
            request.setAttribute("esNuevo", esNuevo);
            request.getRequestDispatcher("/WEB-INF/views/admin/usuario-form.jsp").forward(request, response);
        }
    }

    private void inactivarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            usuarioDAO.inactivar(id);
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=inactivado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=inactivar");
        }
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean eliminado = usuarioDAO.eliminar(id);
            if (eliminado) {
                response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=eliminado");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=hasprojects");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=db");
        }
    }
}
