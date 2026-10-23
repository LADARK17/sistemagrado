package edu.uts.proyectos.dao;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.config.MockDataStore;
import edu.uts.proyectos.model.HistorialVersion;
import edu.uts.proyectos.model.Proyecto;
import edu.uts.proyectos.util.DateUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProyectoDAO {

    public boolean radicarProyecto(Proyecto p) throws SQLException {
        try {
            String sql = "INSERT INTO proyectos (titulo, objetivo, url_pago, estudiante_id, companero_id, idea_banco_id, fase_actual, estado) "
                       + "VALUES (?, ?, ?, ?, ?, ?, 'FASE_1_PAGO', 'RADICADO') RETURNING id";
            String sqlHistorial = "INSERT INTO historial_versiones (proyecto_id, fase, url_documento, subido_por, observaciones_estudiante) "
                                + "VALUES (?, 'FASE_1_PAGO', ?, ?, 'Radicación inicial de propuesta y pago de derechos pecuniarios.')";

            Connection con = null;
            try {
                con = ConexionDB.getConnection();
                con.setAutoCommit(false);

                int proyectoId = 0;
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, p.getTitulo().trim());
                    ps.setString(2, p.getObjetivo().trim());
                    ps.setString(3, p.getUrlPago().trim());
                    ps.setInt(4, p.getEstudianteId());
                    if (p.getCompaneroId() != null && p.getCompaneroId() > 0) {
                        ps.setInt(5, p.getCompaneroId());
                    } else {
                        ps.setNull(5, Types.INTEGER);
                    }
                    if (p.getIdeaBancoId() != null && p.getIdeaBancoId() > 0) {
                        ps.setInt(6, p.getIdeaBancoId());
                    } else {
                        ps.setNull(6, Types.INTEGER);
                    }

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            proyectoId = rs.getInt(1);
                        }
                    }
                }

                try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                    psH.setInt(1, proyectoId);
                    psH.setString(2, p.getUrlPago().trim());
                    psH.setInt(3, p.getEstudianteId());
                    psH.executeUpdate();
                }

                if (p.getIdeaBancoId() != null && p.getIdeaBancoId() > 0) {
                    String sqlIdea = "UPDATE banco_ideas SET estado = 'ASIGNADA' WHERE id = ?";
                    try (PreparedStatement psI = con.prepareStatement(sqlIdea)) {
                        psI.setInt(1, p.getIdeaBancoId());
                        psI.executeUpdate();
                    }
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
            // Fallback a MockDataStore
            int newId = MockDataStore.nextProyectoId();
            p.setId(newId);
            p.setFaseActual(Proyecto.FASE_1);
            p.setEstado(Proyecto.ESTADO_RADICADO);
            Timestamp ahora = new Timestamp(System.currentTimeMillis());
            p.setFechaPago(ahora);
            p.setCreatedAt(ahora);
            p.setUpdatedAt(ahora);

            var uEst = MockDataStore.USUARIOS.get(p.getEstudianteId());
            if (uEst != null) {
                p.setEstudianteNombre(uEst.getNombreCompleto());
                p.setEstudianteDocumento(uEst.getDocumento());
            }
            if (p.getCompaneroId() != null) {
                var uComp = MockDataStore.USUARIOS.get(p.getCompaneroId());
                if (uComp != null) p.setCompaneroNombre(uComp.getNombreCompleto());
            }

            MockDataStore.PROYECTOS.put(newId, p);

            HistorialVersion hv = new HistorialVersion(newId, Proyecto.FASE_1, p.getUrlPago(), p.getEstudianteId(), "Radicación inicial de propuesta y pago.");
            hv.setId(MockDataStore.nextHistorialId());
            if (uEst != null) hv.setSubidoPorNombre(uEst.getNombreCompleto());
            hv.setFechaSubida(ahora);
            MockDataStore.HISTORIAL.add(0, hv);

            if (p.getIdeaBancoId() != null) {
                var idea = MockDataStore.IDEAS.get(p.getIdeaBancoId());
                if (idea != null) idea.setEstado("ASIGNADA");
            }
            return true;
        }
    }

    private Proyecto mapearProyecto(ResultSet rs) throws SQLException {
        Proyecto p = new Proyecto();
        p.setId(rs.getInt("id"));
        p.setTitulo(rs.getString("titulo"));
        p.setObjetivo(rs.getString("objetivo"));
        p.setUrlPago(rs.getString("url_pago"));
        p.setUrlAnteproyecto(rs.getString("url_anteproyecto"));
        p.setUrlInformeFinal(rs.getString("url_informe_final"));
        p.setUrlRepositorioFinal(rs.getString("url_repositorio_final"));
        p.setFaseActual(rs.getString("fase_actual"));
        p.setEstado(rs.getString("estado"));
        p.setEstudianteId(rs.getInt("estudiante_id"));

        int compId = rs.getInt("companero_id");
        p.setCompaneroId(rs.wasNull() ? null : compId);

        int dirId = rs.getInt("director_id");
        p.setDirectorId(rs.wasNull() ? null : dirId);

        int evalId = rs.getInt("evaluador_id");
        p.setEvaluadorId(rs.wasNull() ? null : evalId);

        int ideaId = rs.getInt("idea_banco_id");
        p.setIdeaBancoId(rs.wasNull() ? null : ideaId);

        p.setMotivoRechazo(rs.getString("motivo_rechazo"));
        p.setFechaPago(rs.getTimestamp("fecha_pago"));
        p.setFechaAprobacion(rs.getTimestamp("fecha_aprobacion"));
        p.setFechaLimiteFdc124(rs.getTimestamp("fecha_limite_fdc124"));
        p.setFechaLimiteVigencia(rs.getTimestamp("fecha_limite_vigencia"));
        p.setFechaSustentacion(rs.getTimestamp("fecha_sustentacion"));
        p.setLugarSustentacion(rs.getString("lugar_sustentacion"));
        p.setCalificacionSustentacion(rs.getBigDecimal("calificacion_sustentacion"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));

        p.setEstudianteNombre(rs.getString("estudiante_nombre"));
        p.setEstudianteDocumento(rs.getString("estudiante_documento"));
        p.setCompaneroNombre(rs.getString("companero_nombre"));
        p.setDirectorNombre(rs.getString("director_nombre"));
        p.setEvaluadorNombre(rs.getString("evaluador_nombre"));

        if (p.getFechaLimiteVigencia() != null) {
            p.setDiasVigenciaRestantes(DateUtil.calcularDiasRestantes(p.getFechaLimiteVigencia()));
        }
        if (p.getFechaLimiteFdc124() != null) {
            p.setDiasFdc124Restantes(DateUtil.calcularDiasRestantes(p.getFechaLimiteFdc124()));
        }

        return p;
    }

    private String getBaseQuery() {
        return "SELECT p.*, "
             + "u_est.nombre_completo AS estudiante_nombre, u_est.documento AS estudiante_documento, "
             + "u_comp.nombre_completo AS companero_nombre, "
             + "u_dir.nombre_completo AS director_nombre, "
             + "u_eval.nombre_completo AS evaluador_nombre "
             + "FROM proyectos p "
             + "JOIN usuarios u_est ON p.estudiante_id = u_est.id "
             + "LEFT JOIN usuarios u_comp ON p.companero_id = u_comp.id "
             + "LEFT JOIN usuarios u_dir ON p.director_id = u_dir.id "
             + "LEFT JOIN usuarios u_eval ON p.evaluador_id = u_eval.id ";
    }

    public Proyecto buscarPorId(int id) throws SQLException {
        try {
            String sql = getBaseQuery() + "WHERE p.id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapearProyecto(rs);
                    }
                }
            }
        } catch (Exception ex) {
            return MockDataStore.PROYECTOS.get(id);
        }
        return null;
    }

    public Proyecto buscarActivoPorEstudiante(int estudianteId) throws SQLException {
        try {
            String sql = getBaseQuery() + "WHERE (p.estudiante_id = ? OR p.companero_id = ?) "
                       + "ORDER BY p.id DESC LIMIT 1";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, estudianteId);
                ps.setInt(2, estudianteId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapearProyecto(rs);
                    }
                }
            }
        } catch (Exception ex) {
            for (Proyecto p : MockDataStore.PROYECTOS.values()) {
                if ((p.getEstudianteId() != null && p.getEstudianteId() == estudianteId)
                        || (p.getCompaneroId() != null && p.getCompaneroId() == estudianteId)) {
                    return p;
                }
            }
        }
        return null;
    }

    public List<Proyecto> listarTodos() throws SQLException {
        try {
            List<Proyecto> lista = new ArrayList<>();
            String sql = getBaseQuery() + "ORDER BY p.id DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearProyecto(rs));
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Proyecto> lista = new ArrayList<>(MockDataStore.PROYECTOS.values());
            lista.sort((a, b) -> b.getId().compareTo(a.getId()));
            return lista;
        }
    }

    public List<Proyecto> listarPorDirector(int directorId) throws SQLException {
        try {
            List<Proyecto> lista = new ArrayList<>();
            String sql = getBaseQuery() + "WHERE p.director_id = ? ORDER BY p.id DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, directorId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        lista.add(mapearProyecto(rs));
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Proyecto> lista = new ArrayList<>();
            for (Proyecto p : MockDataStore.PROYECTOS.values()) {
                if (p.getDirectorId() != null && p.getDirectorId() == directorId) {
                    lista.add(p);
                }
            }
            lista.sort((a, b) -> b.getId().compareTo(a.getId()));
            return lista;
        }
    }

    public List<Proyecto> listarPorEvaluador(int evaluadorId) throws SQLException {
        try {
            List<Proyecto> lista = new ArrayList<>();
            String sql = getBaseQuery() + "WHERE p.evaluador_id = ? ORDER BY p.id DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, evaluadorId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        lista.add(mapearProyecto(rs));
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Proyecto> lista = new ArrayList<>();
            for (Proyecto p : MockDataStore.PROYECTOS.values()) {
                if (p.getEvaluadorId() != null && p.getEvaluadorId() == evaluadorId) {
                    lista.add(p);
                }
            }
            lista.sort((a, b) -> b.getId().compareTo(a.getId()));
            return lista;
        }
    }

    public boolean aprobarFase1(int proyectoId, int directorId, int evaluadorId) throws SQLException {
        if (directorId == evaluadorId) {
            throw new IllegalArgumentException("RN03: El docente Director y el Evaluador deben ser personas distintas.");
        }
        Timestamp ahora = new Timestamp(System.currentTimeMillis());
        Timestamp limiteFdc124 = DateUtil.calcularFechaLimiteFdc124(ahora);
        Timestamp limiteVigencia = DateUtil.calcularFechaLimiteVigencia(ahora);

        try {
            String sql = "UPDATE proyectos SET director_id = ?, evaluador_id = ?, "
                       + "fase_actual = 'FASE_2_PROPUESTA_1', estado = 'APROBADO_FASE_1', "
                       + "fecha_aprobacion = ?, fecha_limite_fdc124 = ?, fecha_limite_vigencia = ?, updated_at = ? "
                       + "WHERE id = ? AND estado = 'RADICADO'";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, directorId);
                ps.setInt(2, evaluadorId);
                ps.setTimestamp(3, ahora);
                ps.setTimestamp(4, limiteFdc124);
                ps.setTimestamp(5, limiteVigencia);
                ps.setTimestamp(6, ahora);
                ps.setInt(7, proyectoId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setDirectorId(directorId);
                p.setEvaluadorId(evaluadorId);
                p.setFaseActual(Proyecto.FASE_2);
                p.setEstado(Proyecto.ESTADO_APROBADO_FASE_1);
                p.setFechaAprobacion(ahora);
                p.setFechaLimiteFdc124(limiteFdc124);
                p.setFechaLimiteVigencia(limiteVigencia);
                p.setUpdatedAt(ahora);

                var uDir = MockDataStore.USUARIOS.get(directorId);
                var uEval = MockDataStore.USUARIOS.get(evaluadorId);
                if (uDir != null) p.setDirectorNombre(uDir.getNombreCompleto());
                if (uEval != null) p.setEvaluadorNombre(uEval.getNombreCompleto());

                p.setDiasVigenciaRestantes(DateUtil.calcularDiasRestantes(limiteVigencia));
                p.setDiasFdc124Restantes(DateUtil.calcularDiasRestantes(limiteFdc124));
                return true;
            }
        }
        return false;
    }

    public boolean rechazarProyecto(int proyectoId, String motivo) throws SQLException {
        if (motivo == null || motivo.trim().length() < 30) {
            throw new IllegalArgumentException("RN06: El motivo de rechazo debe contener al menos 30 caracteres explicativos.");
        }
        try {
            String sql = "UPDATE proyectos SET estado = 'RECHAZADO', motivo_rechazo = ?, updated_at = NOW() WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, motivo.trim());
                ps.setInt(2, proyectoId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setEstado(Proyecto.ESTADO_RECHAZADO);
                p.setMotivoRechazo(motivo.trim());
                p.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                return true;
            }
        }
        return false;
    }

    public boolean actualizarUrlAnteproyecto(int proyectoId, String url, int subidoPor, String observaciones) throws SQLException {
        try {
            String sql = "UPDATE proyectos SET url_anteproyecto = ?, estado = 'EN_EVALUACION_DIRECTOR', updated_at = NOW() WHERE id = ?";
            String sqlHistorial = "INSERT INTO historial_versiones (proyecto_id, fase, url_documento, subido_por, observaciones_estudiante) "
                                + "VALUES (?, 'FASE_2_PROPUESTA_1', ?, ?, ?)";
            Connection con = null;
            try {
                con = ConexionDB.getConnection();
                con.setAutoCommit(false);

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, url.trim());
                    ps.setInt(2, proyectoId);
                    ps.executeUpdate();
                }

                try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                    psH.setInt(1, proyectoId);
                    psH.setString(2, url.trim());
                    psH.setInt(3, subidoPor);
                    psH.setString(4, observaciones != null ? observaciones.trim() : "Actualización de Anteproyecto F-DC-124");
                    psH.executeUpdate();
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
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setUrlAnteproyecto(url.trim());
                p.setEstado(Proyecto.ESTADO_EN_EVALUACION_DIRECTOR);
                Timestamp ahora = new Timestamp(System.currentTimeMillis());
                p.setUpdatedAt(ahora);

                HistorialVersion hv = new HistorialVersion(proyectoId, Proyecto.FASE_2, url.trim(), subidoPor, observaciones != null ? observaciones : "Actualización F-DC-124");
                hv.setId(MockDataStore.nextHistorialId());
                var u = MockDataStore.USUARIOS.get(subidoPor);
                if (u != null) hv.setSubidoPorNombre(u.getNombreCompleto());
                hv.setFechaSubida(ahora);
                MockDataStore.HISTORIAL.add(0, hv);
                return true;
            }
        }
        return false;
    }

    public boolean actualizarUrlInforme(int proyectoId, String url, int subidoPor, String observaciones) throws SQLException {
        try {
            String sql = "UPDATE proyectos SET url_informe_final = ?, estado = 'EN_REVISION_INFORME_DIR', updated_at = NOW() WHERE id = ?";
            String sqlHistorial = "INSERT INTO historial_versiones (proyecto_id, fase, url_documento, subido_por, observaciones_estudiante) "
                                + "VALUES (?, 'FASE_4_INFORME_1', ?, ?, ?)";
            Connection con = null;
            try {
                con = ConexionDB.getConnection();
                con.setAutoCommit(false);

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, url.trim());
                    ps.setInt(2, proyectoId);
                    ps.executeUpdate();
                }

                try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                    psH.setInt(1, proyectoId);
                    psH.setString(2, url.trim());
                    psH.setInt(3, subidoPor);
                    psH.setString(4, observaciones != null ? observaciones.trim() : "Actualización de Informe Final de Trabajo de Grado");
                    psH.executeUpdate();
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
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setUrlInformeFinal(url.trim());
                p.setEstado(Proyecto.ESTADO_EN_REVISION_INFORME_DIR);
                Timestamp ahora = new Timestamp(System.currentTimeMillis());
                p.setUpdatedAt(ahora);

                HistorialVersion hv = new HistorialVersion(proyectoId, Proyecto.FASE_4, url.trim(), subidoPor, observaciones != null ? observaciones : "Carga de Informe Final");
                hv.setId(MockDataStore.nextHistorialId());
                var u = MockDataStore.USUARIOS.get(subidoPor);
                if (u != null) hv.setSubidoPorNombre(u.getNombreCompleto());
                hv.setFechaSubida(ahora);
                MockDataStore.HISTORIAL.add(0, hv);
                return true;
            }
        }
        return false;
    }

    public boolean programarSustentacion(int proyectoId, Timestamp fecha, String lugar) throws SQLException {
        try {
            String sql = "UPDATE proyectos SET fase_actual = 'FASE_FINAL_SUSTENTACION', estado = 'SUSTENTACION_PROGRAMADA', "
                       + "fecha_sustentacion = ?, lugar_sustentacion = ?, updated_at = NOW() WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setTimestamp(1, fecha);
                ps.setString(2, lugar.trim());
                ps.setInt(3, proyectoId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setFaseActual(Proyecto.FASE_FINAL);
                p.setEstado(Proyecto.ESTADO_SUSTENTACION_PROGRAMADA);
                p.setFechaSustentacion(fecha);
                p.setLugarSustentacion(lugar.trim());
                p.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                return true;
            }
        }
        return false;
    }

    public boolean registrarNotaSustentacion(int proyectoId, BigDecimal nota) throws SQLException {
        String nuevoEstado = (nota.compareTo(new BigDecimal("3.0")) >= 0 || nota.compareTo(new BigDecimal("70.0")) >= 0)
                           ? "SUSTENTADO_PENDIENTE_CIERRE" : "NO_APROBADO";
        try {
            String sql = "UPDATE proyectos SET calificacion_sustentacion = ?, estado = ?, updated_at = NOW() WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setBigDecimal(1, nota);
                ps.setString(2, nuevoEstado);
                ps.setInt(3, proyectoId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setCalificacionSustentacion(nota);
                p.setEstado(nuevoEstado);
                p.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                return true;
            }
        }
        return false;
    }

    public boolean decretarCierre(int proyectoId, String urlRepositorio) throws SQLException {
        try {
            String sql = "UPDATE proyectos SET url_repositorio_final = ?, estado = 'FINALIZADO_CERRADO', updated_at = NOW() "
                       + "WHERE id = ? AND estado = 'SUSTENTADO_PENDIENTE_CIERRE'";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, urlRepositorio.trim());
                ps.setInt(2, proyectoId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Proyecto p = MockDataStore.PROYECTOS.get(proyectoId);
            if (p != null) {
                p.setUrlRepositorioFinal(urlRepositorio.trim());
                p.setEstado(Proyecto.ESTADO_FINALIZADO_CERRADO);
                p.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                return true;
            }
        }
        return false;
    }

    public boolean cerrarProyecto(int proyectoId, String urlRepositorio) throws SQLException {
        return decretarCierre(proyectoId, urlRepositorio);
    }
}
