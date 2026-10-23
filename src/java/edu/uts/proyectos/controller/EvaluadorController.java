package edu.uts.proyectos.controller;

import edu.uts.proyectos.dao.CalificacionDAO;
import edu.uts.proyectos.dao.HistorialDAO;
import edu.uts.proyectos.dao.ProyectoDAO;
import edu.uts.proyectos.model.Calificacion;
import edu.uts.proyectos.model.HistorialVersion;
import edu.uts.proyectos.model.Proyecto;
import edu.uts.proyectos.model.Usuario;
import edu.uts.proyectos.util.DateUtil;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EvaluadorController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProyectoDAO proyectoDAO = new ProyectoDAO();
    private HistorialDAO historialDAO = new HistorialDAO();
    private CalificacionDAO calificacionDAO = new CalificacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/proyectos")) {
            listarProyectos(request, response);
        } else if (path.equals("/evaluar")) {
            mostrarFormularioEvaluar(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/evaluador/proyectos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getPathInfo();
        if (path != null && path.equals("/guardar-evaluacion")) {
            guardarEvaluacion(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/evaluador/proyectos");
        }
    }

    private void listarProyectos(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer evaluadorId = (Integer) request.getSession().getAttribute("usuario_id");
        if (evaluadorId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Proyecto> proyectos = proyectoDAO.listarPorEvaluador(evaluadorId);
            for (Proyecto p : proyectos) {
                if (Proyecto.ESTADO_EN_EVALUACION_EVALUADOR.equals(p.getEstado()) || Proyecto.ESTADO_EN_REVISION_INFORME_EVA.equals(p.getEstado())) {
                    List<HistorialVersion> hist = historialDAO.listarPorProyecto(p.getId());
                    if (!hist.isEmpty()) {
                        p.setEnMoraDocente(DateUtil.estaEnMoraDocente(hist.get(0).getFechaSubida()));
                    }
                }
            }
            request.setAttribute("proyectos", proyectos);
            request.getRequestDispatcher("/WEB-INF/views/evaluador/proyectos-evaluar.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMensaje", "Error al listar proyectos para evaluar: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/evaluador/proyectos-evaluar.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioEvaluar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Proyecto p = proyectoDAO.buscarPorId(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/evaluador/proyectos?error=notfound");
                return;
            }
            List<HistorialVersion> historial = historialDAO.listarPorProyecto(id);
            List<Calificacion> calificaciones = calificacionDAO.listarPorProyecto(id);

            request.setAttribute("proyecto", p);
            request.setAttribute("historialVersiones", historial);
            request.setAttribute("calificaciones", calificaciones);
            request.getRequestDispatcher("/WEB-INF/views/evaluador/evaluar-fase.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/evaluador/proyectos?error=invalidid");
        }
    }

    private void guardarEvaluacion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Integer evaluadorId = (Integer) request.getSession().getAttribute("usuario_id");
        try {
            int proyectoId = Integer.parseInt(request.getParameter("proyectoId"));
            String resultado = request.getParameter("resultado"); // Aprobado, Aplazado, Rechazado
            String observaciones = request.getParameter("observaciones");
            String confirmacion = request.getParameter("confirmacionRechazo");

            if (Calificacion.RESULTADO_RECHAZADO.equalsIgnoreCase(resultado)) {
                if (confirmacion == null || (!confirmacion.equals("on") && !confirmacion.equals("true"))) {
                    response.sendRedirect(request.getContextPath() + "/evaluador/evaluar?id=" + proyectoId + "&error=noconfirmado");
                    return;
                }
                if (observaciones == null || observaciones.trim().length() < 30) {
                    response.sendRedirect(request.getContextPath() + "/evaluador/evaluar?id=" + proyectoId + "&error=motivo_corto");
                    return;
                }
            }

            Calificacion cal = new Calificacion();
            cal.setProyectoId(proyectoId);
            cal.setCalificadorId(evaluadorId);
            cal.setResultado(resultado);
            cal.setObservaciones(observaciones);

            calificacionDAO.calificarFase(cal, Usuario.ROL_EVALUADOR);
            response.sendRedirect(request.getContextPath() + "/evaluador/proyectos?success=evaluado");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/evaluador/proyectos?error=" + e.getMessage());
        }
    }
}
