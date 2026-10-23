package edu.uts.proyectos.controller;

import edu.uts.proyectos.dao.BancoIdeaDAO;
import edu.uts.proyectos.dao.HistorialDAO;
import edu.uts.proyectos.dao.ProyectoDAO;
import edu.uts.proyectos.dao.UsuarioDAO;
import edu.uts.proyectos.model.BancoIdea;
import edu.uts.proyectos.model.HistorialVersion;
import edu.uts.proyectos.model.Proyecto;
import edu.uts.proyectos.model.Usuario;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ComiteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProyectoDAO proyectoDAO = new ProyectoDAO();
    private BancoIdeaDAO bancoIdeaDAO = new BancoIdeaDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private HistorialDAO historialDAO = new HistorialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            mostrarDashboard(request, response);
        } else if (path.equals("/banco-ideas")) {
            listarBancoIdeas(request, response);
        } else if (path.equals("/solicitudes-pago")) {
            listarSolicitudesPago(request, response);
        } else if (path.equals("/sustentaciones")) {
            listarSustentaciones(request, response);
        } else if (path.equals("/detalle-proyecto")) {
            mostrarDetalleProyecto(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/comite/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getPathInfo();

        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/comite/dashboard");
            return;
        }

        if (path.equals("/banco-ideas/guardar")) {
            guardarIdea(request, response);
        } else if (path.equals("/aprobar-fase1")) {
            aprobarFase1(request, response);
        } else if (path.equals("/rechazar-fase1")) {
            rechazarFase1(request, response);
        } else if (path.equals("/programar-sustentacion")) {
            programarSustentacion(request, response);
        } else if (path.equals("/calificar-sustentacion")) {
            calificarSustentacion(request, response);
        } else if (path.equals("/decretar-cierre")) {
            decretarCierre(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/comite/dashboard");
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Proyecto> proyectos = proyectoDAO.listarTodos();
            request.setAttribute("proyectos", proyectos);
            request.getRequestDispatcher("/WEB-INF/views/comite/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al cargar dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/comite/dashboard.jsp").forward(request, response);
        }
    }

    private void listarBancoIdeas(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<BancoIdea> ideas = bancoIdeaDAO.listarTodas();
            request.setAttribute("ideas", ideas);
            request.getRequestDispatcher("/WEB-INF/views/comite/banco-ideas.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al listar ideas: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/comite/banco-ideas.jsp").forward(request, response);
        }
    }

    private void guardarIdea(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String linea = request.getParameter("lineaInvestigacion");
        Integer usuarioId = (Integer) request.getSession().getAttribute("usuario_id");

        BancoIdea idea = new BancoIdea();
        idea.setTitulo(titulo);
        idea.setDescripcion(descripcion);
        idea.setLineaInvestigacion(linea);
        idea.setCreadoPor(usuarioId != null ? usuarioId : 1);

        try {
            bancoIdeaDAO.insertar(idea);
            response.sendRedirect(request.getContextPath() + "/comite/banco-ideas?success=creada");
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/comite/banco-ideas?error=" + e.getMessage());
        }
    }

    private void listarSolicitudesPago(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Proyecto> proyectos = proyectoDAO.listarTodos();
            List<Usuario> directores = usuarioDAO.listarPorRol(Usuario.ROL_DIRECTOR);
            List<Usuario> evaluadores = usuarioDAO.listarPorRol(Usuario.ROL_EVALUADOR);

            request.setAttribute("proyectos", proyectos);
            request.setAttribute("directores", directores);
            request.setAttribute("evaluadores", evaluadores);
            request.getRequestDispatcher("/WEB-INF/views/comite/solicitudes-pago.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al cargar solicitudes: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/comite/solicitudes-pago.jsp").forward(request, response);
        }
    }

    private void aprobarFase1(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            int directorId = Integer.parseInt(request.getParameter("directorId"));
            int evaluadorId = Integer.parseInt(request.getParameter("evaluadorId"));

            if (directorId == evaluadorId) {
                response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?error=mismodocente");
                return;
            }

            proyectoDAO.aprobarFase1(proyectoId, directorId, evaluadorId);
            response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?success=aprobado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?error=" + e.getMessage());
        }
    }

    private void rechazarFase1(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String motivo = request.getParameter("motivoRechazo");
            String confirmacion = request.getParameter("confirmacionRechazo");

            if (confirmacion == null || (!confirmacion.equals("on") && !confirmacion.equals("true"))) {
                response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?error=noconfirmado");
                return;
            }

            proyectoDAO.rechazarProyecto(proyectoId, motivo);
            response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?success=rechazado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/solicitudes-pago?error=" + e.getMessage());
        }
    }

    private void listarSustentaciones(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Proyecto> proyectos = proyectoDAO.listarTodos();
            request.setAttribute("proyectos", proyectos);
            request.getRequestDispatcher("/WEB-INF/views/comite/sustentaciones.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al cargar sustentaciones: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/comite/sustentaciones.jsp").forward(request, response);
        }
    }

    private void programarSustentacion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String fechaStr = request.getParameter("fechaSustentacion"); // Formato YYYY-MM-DDTHH:MM
            String lugar = request.getParameter("lugarSustentacion");

            String timestampStr = fechaStr.replace("T", " ") + ":00";
            Timestamp ts = Timestamp.valueOf(timestampStr);

            proyectoDAO.programarSustentacion(proyectoId, ts, lugar);
            response.sendRedirect(request.getContextPath() + "/comite/sustentaciones?success=programada");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/sustentaciones?error=" + e.getMessage());
        }
    }

    private void calificarSustentacion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            BigDecimal nota = new BigDecimal(request.getParameter("notaSustentacion"));

            proyectoDAO.registrarNotaSustentacion(proyectoId, nota);
            response.sendRedirect(request.getContextPath() + "/comite/sustentaciones?success=calificada");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/sustentaciones?error=" + e.getMessage());
        }
    }

    private void mostrarDetalleProyecto(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Proyecto p = proyectoDAO.buscarPorId(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/comite/dashboard?error=notfound");
                return;
            }
            List<HistorialVersion> historial = historialDAO.listarPorProyecto(id);
            request.setAttribute("proyecto", p);
            request.setAttribute("historialVersiones", historial);
            request.getRequestDispatcher("/WEB-INF/views/comite/detalle-proyecto.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/dashboard?error=invalidid");
        }
    }

    private void decretarCierre(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String urlRepositorio = request.getParameter("urlRepositorio");

            proyectoDAO.cerrarProyecto(proyectoId, urlRepositorio);
            response.sendRedirect(request.getContextPath() + "/comite/detalle-proyecto?id=" + proyectoId + "&success=cerrado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comite/dashboard?error=" + e.getMessage());
        }
    }
}
