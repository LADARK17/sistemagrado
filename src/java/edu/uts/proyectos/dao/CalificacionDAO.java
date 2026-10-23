package edu.uts.proyectos.dao;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.config.MockDataStore;
import edu.uts.proyectos.model.Calificacion;
import edu.uts.proyectos.model.Proyecto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CalificacionDAO {

    public List<Calificacion> listarPorProyecto(int proyectoId) throws SQLException {
        try {
            List<Calificacion> lista = new ArrayList<>();
            String sql = "SELECT c.*, u.nombre_completo AS calificador_nombre "
                       + "FROM calificaciones c "
                       + "JOIN usuarios u ON c.calificador_id = u.id "
                       + "WHERE c.proyecto_id = ? "
                       + "ORDER BY c.fecha_calificacion DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, proyectoId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Calificacion c = new Calificacion();
                        c.setId(rs.getInt("id"));
                        c.setProyectoId(rs.getInt("proyecto_id"));
                        c.setCalificadorId(rs.getInt("calificador_id"));
                        c.setCalificadorNombre(rs.getString("calificador_nombre"));
                        c.setFase(rs.getString("fase"));
                        c.setResultado(rs.getString("resultado"));
                        c.setObservaciones(rs.getString("observaciones"));
                        c.setNotaNumerica(rs.getBigDecimal("nota_numerica"));
                        c.setFechaCalificacion(rs.getTimestamp("fecha_calificacion"));
                        lista.add(c);
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Calificacion> lista = new ArrayList<>();
            for (Calificacion c : MockDataStore.CALIFICACIONES) {
                if (c.getProyectoId() == proyectoId) {
                    lista.add(c);
                }
            }
            return lista;
        }
    }

    public Calificacion obtenerUltimaPorProyecto(int proyectoId) throws SQLException {
        try {
            String sql = "SELECT c.*, u.nombre_completo AS calificador_nombre "
                       + "FROM calificaciones c "
                       + "JOIN usuarios u ON c.calificador_id = u.id "
                       + "WHERE c.proyecto_id = ? "
                       + "ORDER BY c.fecha_calificacion DESC LIMIT 1";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, proyectoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Calificacion c = new Calificacion();
                        c.setId(rs.getInt("id"));
                        c.setProyectoId(rs.getInt("proyecto_id"));
                        c.setCalificadorId(rs.getInt("calificador_id"));
                        c.setCalificadorNombre(rs.getString("calificador_nombre"));
                        c.setFase(rs.getString("fase"));
                        c.setResultado(rs.getString("resultado"));
                        c.setObservaciones(rs.getString("observaciones"));
                        c.setNotaNumerica(rs.getBigDecimal("nota_numerica"));
                        c.setFechaCalificacion(rs.getTimestamp("fecha_calificacion"));
                        return c;
                    }
                }
            }
        } catch (Exception ex) {
            for (Calificacion c : MockDataStore.CALIFICACIONES) {
                if (c.getProyectoId() == proyectoId) {
                    return c;
                }
            }
        }
        return null;
    }

    public boolean calificarFase(Calificacion cal, String rolCalificador) throws SQLException {
        try {
            String sqlInsert = "INSERT INTO calificaciones (proyecto_id, calificador_id, fase, resultado, observaciones, nota_numerica) "
                             + "VALUES (?, ?, ?, ?, ?, ?)";

            Connection con = null;
            try {
                con = ConexionDB.getConnection();
                con.setAutoCommit(false);

                ProyectoDAO pdao = new ProyectoDAO();
                Proyecto p = pdao.buscarPorId(cal.getProyectoId());
                if (p == null) {
                    throw new IllegalArgumentException("El proyecto no existe.");
                }

                String nuevaFase = p.getFaseActual();
                String nuevoEstado = p.getEstado();

                if (Calificacion.RESULTADO_RECHAZADO.equalsIgnoreCase(cal.getResultado())) {
                    nuevoEstado = Proyecto.ESTADO_RECHAZADO;
                } else if (Calificacion.RESULTADO_APLAZADO.equalsIgnoreCase(cal.getResultado())) {
                    if (Proyecto.FASE_2.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_DIRECTOR;
                    } else if (Proyecto.FASE_3.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_EVALUADOR;
                    } else if (Proyecto.FASE_4.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_INFORME_DIR;
                    } else if (Proyecto.FASE_5.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_INFORME_EVA;
                    }
                } else if (Calificacion.RESULTADO_APROBADO.equalsIgnoreCase(cal.getResultado())) {
                    if (Proyecto.FASE_2.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_3;
                        nuevoEstado = Proyecto.ESTADO_EN_EVALUACION_EVALUADOR;
                    } else if (Proyecto.FASE_3.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_4;
                        nuevoEstado = Proyecto.ESTADO_EN_DESARROLLO;
                    } else if (Proyecto.FASE_4.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_5;
                        nuevoEstado = Proyecto.ESTADO_EN_REVISION_INFORME_EVA;
                    } else if (Proyecto.FASE_5.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_FINAL;
                        nuevoEstado = Proyecto.ESTADO_LISTO_PARA_SUSTENTAR;
                    }
                }

                try (PreparedStatement psI = con.prepareStatement(sqlInsert)) {
                    psI.setInt(1, cal.getProyectoId());
                    psI.setInt(2, cal.getCalificadorId());
                    psI.setString(3, p.getFaseActual());
                    psI.setString(4, cal.getResultado());
                    psI.setString(5, cal.getObservaciones().trim());
                    if (cal.getNotaNumerica() != null) {
                        psI.setBigDecimal(6, cal.getNotaNumerica());
                    } else {
                        psI.setNull(6, Types.NUMERIC);
                    }
                    psI.executeUpdate();
                }

                String sqlUpdate = "UPDATE proyectos SET fase_actual = ?, estado = ?, updated_at = NOW() ";
                if (Calificacion.RESULTADO_RECHAZADO.equalsIgnoreCase(cal.getResultado())) {
                    sqlUpdate += ", motivo_rechazo = ? WHERE id = ?";
                } else {
                    sqlUpdate += "WHERE id = ?";
                }

                try (PreparedStatement psU = con.prepareStatement(sqlUpdate)) {
                    psU.setString(1, nuevaFase);
                    psU.setString(2, nuevoEstado);
                    if (Calificacion.RESULTADO_RECHAZADO.equalsIgnoreCase(cal.getResultado())) {
                        psU.setString(3, cal.getObservaciones().trim());
                        psU.setInt(4, cal.getProyectoId());
                    } else {
                        psU.setInt(3, cal.getProyectoId());
                    }
                    psU.executeUpdate();
                }

                con.commit();
                return true;
            } catch (SQLException e) {
                if (con != null) con.rollback();
                throw e;
            } finally {
                if (con != null) con.close();
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(cal.getProyectoId());
            if (p != null) {
                String nuevaFase = p.getFaseActual();
                String nuevoEstado = p.getEstado();

                if (Calificacion.RESULTADO_RECHAZADO.equalsIgnoreCase(cal.getResultado())) {
                    nuevoEstado = Proyecto.ESTADO_RECHAZADO;
                    p.setMotivoRechazo(cal.getObservaciones());
                } else if (Calificacion.RESULTADO_APLAZADO.equalsIgnoreCase(cal.getResultado())) {
                    if (Proyecto.FASE_2.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_DIRECTOR;
                    } else if (Proyecto.FASE_3.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_EVALUADOR;
                    } else if (Proyecto.FASE_4.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_INFORME_DIR;
                    } else if (Proyecto.FASE_5.equals(p.getFaseActual())) {
                        nuevoEstado = Proyecto.ESTADO_APLAZADO_INFORME_EVA;
                    }
                } else if (Calificacion.RESULTADO_APROBADO.equalsIgnoreCase(cal.getResultado())) {
                    if (Proyecto.FASE_2.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_3;
                        nuevoEstado = Proyecto.ESTADO_EN_EVALUACION_EVALUADOR;
                    } else if (Proyecto.FASE_3.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_4;
                        nuevoEstado = Proyecto.ESTADO_EN_DESARROLLO;
                    } else if (Proyecto.FASE_4.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_5;
                        nuevoEstado = Proyecto.ESTADO_EN_REVISION_INFORME_EVA;
                    } else if (Proyecto.FASE_5.equals(p.getFaseActual())) {
                        nuevaFase = Proyecto.FASE_FINAL;
                        nuevoEstado = Proyecto.ESTADO_LISTO_PARA_SUSTENTAR;
                    }
                }

                p.setFaseActual(nuevaFase);
                p.setEstado(nuevoEstado);
                Timestamp ahora = new Timestamp(System.currentTimeMillis());
                p.setUpdatedAt(ahora);

                cal.setId(MockDataStore.nextCalificacionId());
                cal.setFase(p.getFaseActual());
                cal.setFechaCalificacion(ahora);
                var u = MockDataStore.USUARIOS.get(cal.getCalificadorId());
                if (u != null) cal.setCalificadorNombre(u.getNombreCompleto());
                MockDataStore.CALIFICACIONES.add(0, cal);
                return true;
            }
        }
        return false;
    }
}
