package edu.uts.proyectos.dao;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.config.MockDataStore;
import edu.uts.proyectos.model.HistorialVersion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialDAO {

    public List<HistorialVersion> listarPorProyecto(int proyectoId) throws SQLException {
        try {
            List<HistorialVersion> lista = new ArrayList<>();
            String sql = "SELECT h.*, u.nombre_completo AS subido_por_nombre "
                       + "FROM historial_versiones h "
                       + "JOIN usuarios u ON h.subido_por = u.id "
                       + "WHERE h.proyecto_id = ? "
                       + "ORDER BY h.fecha_subida DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, proyectoId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        HistorialVersion h = new HistorialVersion();
                        h.setId(rs.getInt("id"));
                        h.setProyectoId(rs.getInt("proyecto_id"));
                        h.setFase(rs.getString("fase"));
                        h.setUrlDocumento(rs.getString("url_documento"));
                        h.setSubidoPor(rs.getInt("subido_por"));
                        h.setSubidoPorNombre(rs.getString("subido_por_nombre"));
                        h.setObservacionesEstudiante(rs.getString("observaciones_estudiante"));
                        h.setFechaSubida(rs.getTimestamp("fecha_subida"));
                        lista.add(h);
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<HistorialVersion> lista = new ArrayList<>();
            for (HistorialVersion h : MockDataStore.HISTORIAL) {
                if (h.getProyectoId() == proyectoId) {
                    lista.add(h);
                }
            }
            return lista;
        }
    }

    public boolean insertar(HistorialVersion h) throws SQLException {
        try {
            String sql = "INSERT INTO historial_versiones (proyecto_id, fase, url_documento, subido_por, observaciones_estudiante) "
                       + "VALUES (?, ?, ?, ?, ?)";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, h.getProyectoId());
                ps.setString(2, h.getFase());
                ps.setString(3, h.getUrlDocumento());
                ps.setInt(4, h.getSubidoPor());
                ps.setString(5, h.getObservacionesEstudiante());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            int newId = MockDataStore.nextHistorialId();
            h.setId(newId);
            h.setFechaSubida(new Timestamp(System.currentTimeMillis()));
            var u = MockDataStore.USUARIOS.get(h.getSubidoPor());
            if (u != null) h.setSubidoPorNombre(u.getNombreCompleto());
            MockDataStore.HISTORIAL.add(0, h);
            return true;
        }
    }
}
