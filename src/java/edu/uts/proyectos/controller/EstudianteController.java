package edu.uts.proyectos.controller;

import edu.uts.proyectos.dao.BancoIdeaDAO;
import edu.uts.proyectos.dao.CalificacionDAO;
import edu.uts.proyectos.dao.HistorialDAO;
import edu.uts.proyectos.dao.ProyectoDAO;
import edu.uts.proyectos.dao.UsuarioDAO;
import edu.uts.proyectos.model.BancoIdea;
import edu.uts.proyectos.model.Calificacion;
import edu.uts.proyectos.model.HistorialVersion;
import edu.uts.proyectos.model.Proyecto;
import edu.uts.proyectos.model.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EstudianteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProyectoDAO proyectoDAO = new ProyectoDAO();
    private BancoIdeaDAO bancoIdeaDAO = new BancoIdeaDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private HistorialDAO historialDAO = new HistorialDAO();
    private CalificacionDAO calificacionDAO = new CalificacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            mostrarDashboard(request, response);
        } else if (path.equals("/radicar")) {
            mostrarFormularioRadicar(request, response);
        } else if (path.equals("/banco-ideas")) {
            mostrarBancoIdeas(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getPathInfo();

        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
            return;
        }

        if (path.equals("/guardar-radicacion")) {
            guardarRadicacion(request, response);
        } else if (path.equals("/subir-anteproyecto")) {
            subirAnteproyecto(request, response);
        } else if (path.equals("/subir-correccion")) {
            subirCorreccion(request, response);
        } else if (path.equals("/subir-informe")) {
            subirInforme(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        if (estudianteId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Proyecto proyecto = proyectoDAO.buscarActivoPorEstudiante(estudianteId);
            if (proyecto != null) {
                List<HistorialVersion> historial = historialDAO.listarPorProyecto(proyecto.getId());
                Calificacion ultimaCal = calificacionDAO.obtenerUltimaPorProyecto(proyecto.getId());
                request.setAttribute("proyecto", proyecto);
                request.setAttribute("historialVersiones", historial);
                request.setAttribute("ultimaCalificacion", ultimaCal);
            }
            request.getRequestDispatcher("/WEB-INF/views/estudiante/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al cargar información: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/estudiante/dashboard.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioRadicar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        try {
            if (usuarioDAO.estudianteTieneProyectoActivo(estudianteId)) {
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=ya_tiene_proyecto");
                return;
            }

            List<BancoIdea> ideas = bancoIdeaDAO.listarDisponibles();
            List<Usuario> companeros = usuarioDAO.listarEstudiantesDisponibles(estudianteId);

            request.setAttribute("ideas", ideas);
            request.setAttribute("companeros", companeros);
            request.getRequestDispatcher("/WEB-INF/views/estudiante/radicar-proyecto.jsp").forward(request, response);
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=" + e.getMessage());
        }
    }

    private void mostrarBancoIdeas(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<BancoIdea> ideas = bancoIdeaDAO.listarDisponibles();
            request.setAttribute("ideas", ideas);
            request.getRequestDispatcher("/WEB-INF/views/estudiante/banco-ideas-ver.jsp").forward(request, response);
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=" + e.getMessage());
        }
    }

    private void guardarRadicacion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        String titulo = request.getParameter("titulo");
        String objetivo = request.getParameter("objetivo");
        String urlPago = request.getParameter("urlPago");
        String companeroIdStr = request.getParameter("companeroId");
        String ideaBancoIdStr = request.getParameter("ideaBancoId");

        // Validar URL HTTPS
        if (urlPago == null || !urlPago.toLowerCase().startsWith("https://")) {
            response.sendRedirect(request.getContextPath() + "/estudiante/radicar?error=url_invalida");
            return;
        }

        Proyecto p = new Proyecto();
        p.setTitulo(titulo);
        p.setObjetivo(objetivo);
        p.setUrlPago(urlPago);
        p.setEstudianteId(estudianteId);

        if (companeroIdStr != null && !companeroIdStr.trim().isEmpty() && !companeroIdStr.equals("0")) {
            p.setCompaneroId(Integer.parseInt(companeroIdStr));
        }

        if (ideaBancoIdStr != null && !ideaBancoIdStr.trim().isEmpty() && !ideaBancoIdStr.equals("0")) {
            p.setIdeaBancoId(Integer.parseInt(ideaBancoIdStr));
        }

        try {
            proyectoDAO.radicarProyecto(p);
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?success=radicado");
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/radicar?error=" + e.getMessage());
        }
    }

    private void subirAnteproyecto(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String url = request.getParameter("urlAnteproyecto");
            String obs = request.getParameter("observaciones");

            if (url == null || !url.toLowerCase().startsWith("https://")) {
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=url_invalida");
                return;
            }

            proyectoDAO.actualizarUrlAnteproyecto(proyectoId, url, estudianteId, obs);
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?success=anteproyecto_cargado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=" + e.getMessage());
        }
    }

    private void subirCorreccion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String url = request.getParameter("urlCorreccion");
            String obs = request.getParameter("observaciones");

            if (url == null || !url.toLowerCase().startsWith("https://")) {
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=url_invalida");
                return;
            }

            Proyecto p = proyectoDAO.buscarPorId(proyectoId);
            if (p != null) {
                if (Proyecto.ESTADO_APLAZADO_DIRECTOR.equals(p.getEstado()) || Proyecto.ESTADO_APLAZADO_EVALUADOR.equals(p.getEstado())) {
                    proyectoDAO.actualizarUrlAnteproyecto(proyectoId, url, estudianteId, "Versión corregida de Anteproyecto: " + (obs != null ? obs : ""));
                } else if (Proyecto.ESTADO_APLAZADO_INFORME_DIR.equals(p.getEstado()) || Proyecto.ESTADO_APLAZADO_INFORME_EVA.equals(p.getEstado())) {
                    proyectoDAO.actualizarUrlInforme(proyectoId, url, estudianteId, "Versión corregida de Informe Final: " + (obs != null ? obs : ""));
                }
            }
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?success=correccion_enviada");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=" + e.getMessage());
        }
    }

    private void subirInforme(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Integer estudianteId = (Integer) request.getSession().getAttribute("usuario_id");
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String url = request.getParameter("urlInforme");
            String obs = request.getParameter("observaciones");

            if (url == null || !url.toLowerCase().startsWith("https://")) {
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=url_invalida");
                return;
            }

            proyectoDAO.actualizarUrlInforme(proyectoId, url, estudianteId, obs);
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?success=informe_cargado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard?error=" + e.getMessage());
        }
    }
}
