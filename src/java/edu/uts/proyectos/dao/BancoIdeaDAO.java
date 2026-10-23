package edu.uts.proyectos.dao;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.config.MockDataStore;
import edu.uts.proyectos.model.BancoIdea;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BancoIdeaDAO {

    public List<BancoIdea> listarTodas() throws SQLException {
        try {
            List<BancoIdea> lista = new ArrayList<>();
            String sql = "SELECT b.id, b.titulo, b.descripcion, b.linea_investigacion, b.estado, b.creado_por, b.created_at, "
                       + "u.nombre_completo AS creador_nombre "
                       + "FROM banco_ideas b "
                       + "JOIN usuarios u ON b.creado_por = u.id "
                       + "ORDER BY b.id DESC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BancoIdea idea = new BancoIdea();
                    idea.setId(rs.getInt("id"));
                    idea.setTitulo(rs.getString("titulo"));
                    idea.setDescripcion(rs.getString("descripcion"));
                    idea.setLineaInvestigacion(rs.getString("linea_investigacion"));
                    idea.setEstado(rs.getString("estado"));
                    idea.setCreadoPor(rs.getInt("creado_por"));
                    idea.setCreadoPorNombre(rs.getString("creador_nombre"));
                    idea.setCreatedAt(rs.getTimestamp("created_at"));
                    lista.add(idea);
                }
            }
            return lista;
        } catch (Exception ex) {
            List<BancoIdea> lista = new ArrayList<>(MockDataStore.IDEAS.values());
            lista.sort((a, b) -> b.getId().compareTo(a.getId()));
            return lista;
        }
    }

    public List<BancoIdea> listarDisponibles() throws SQLException {
        try {
            List<BancoIdea> lista = new ArrayList<>();
            String sql = "SELECT b.id, b.titulo, b.descripcion, b.linea_investigacion, b.estado, b.creado_por, b.created_at, "
                       + "u.nombre_completo AS creador_nombre "
                       + "FROM banco_ideas b "
                       + "JOIN usuarios u ON b.creado_por = u.id "
                       + "WHERE b.estado = 'DISPONIBLE' "
                       + "ORDER BY b.titulo ASC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BancoIdea idea = new BancoIdea();
                    idea.setId(rs.getInt("id"));
                    idea.setTitulo(rs.getString("titulo"));
                    idea.setDescripcion(rs.getString("descripcion"));
                    idea.setLineaInvestigacion(rs.getString("linea_investigacion"));
                    idea.setEstado(rs.getString("estado"));
                    idea.setCreadoPor(rs.getInt("creado_por"));
                    idea.setCreadoPorNombre(rs.getString("creador_nombre"));
                    idea.setCreatedAt(rs.getTimestamp("created_at"));
                    lista.add(idea);
                }
            }
            return lista;
        } catch (Exception ex) {
            List<BancoIdea> lista = new ArrayList<>();
            for (BancoIdea b : MockDataStore.IDEAS.values()) {
                if (BancoIdea.ESTADO_DISPONIBLE.equals(b.getEstado())) {
                    lista.add(b);
                }
            }
            lista.sort((a, b) -> a.getTitulo().compareTo(b.getTitulo()));
            return lista;
        }
    }

    public BancoIdea buscarPorId(int id) throws SQLException {
        try {
            String sql = "SELECT b.id, b.titulo, b.descripcion, b.linea_investigacion, b.estado, b.creado_por, b.created_at, "
                       + "u.nombre_completo AS creador_nombre "
                       + "FROM banco_ideas b "
                       + "JOIN usuarios u ON b.creado_por = u.id "
                       + "WHERE b.id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        BancoIdea idea = new BancoIdea();
                        idea.setId(rs.getInt("id"));
                        idea.setTitulo(rs.getString("titulo"));
                        idea.setDescripcion(rs.getString("descripcion"));
                        idea.setLineaInvestigacion(rs.getString("linea_investigacion"));
                        idea.setEstado(rs.getString("estado"));
                        idea.setCreadoPor(rs.getInt("creado_por"));
                        idea.setCreadoPorNombre(rs.getString("creador_nombre"));
                        idea.setCreatedAt(rs.getTimestamp("created_at"));
                        return idea;
                    }
                }
            }
        } catch (Exception ex) {
            return MockDataStore.IDEAS.get(id);
        }
        return null;
    }

    public boolean insertar(BancoIdea idea) throws SQLException {
        try {
            String sql = "INSERT INTO banco_ideas (titulo, descripcion, linea_investigacion, estado, creado_por) "
                       + "VALUES (?, ?, ?, 'DISPONIBLE', ?)";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, idea.getTitulo().trim());
                ps.setString(2, idea.getDescripcion().trim());
                ps.setString(3, idea.getLineaInvestigacion().trim());
                ps.setInt(4, idea.getCreadoPor());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            int newId = MockDataStore.nextIdeaId();
            idea.setId(newId);
            idea.setEstado(BancoIdea.ESTADO_DISPONIBLE);
            idea.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            var u = MockDataStore.USUARIOS.get(idea.getCreadoPor());
            if (u != null) idea.setCreadoPorNombre(u.getNombreCompleto());
            MockDataStore.IDEAS.put(newId, idea);
            return true;
        }
    }

    public boolean actualizar(BancoIdea idea) throws SQLException {
        try {
            String sql = "UPDATE banco_ideas SET titulo = ?, descripcion = ?, linea_investigacion = ?, estado = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, idea.getTitulo().trim());
                ps.setString(2, idea.getDescripcion().trim());
                ps.setString(3, idea.getLineaInvestigacion().trim());
                ps.setString(4, idea.getEstado());
                ps.setInt(5, idea.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            BancoIdea exist = MockDataStore.IDEAS.get(idea.getId());
            if (exist != null) {
                exist.setTitulo(idea.getTitulo());
                exist.setDescripcion(idea.getDescripcion());
                exist.setLineaInvestigacion(idea.getLineaInvestigacion());
                exist.setEstado(idea.getEstado());
                return true;
            }
        }
        return false;
    }

    public boolean cambiarEstado(int id, String nuevoEstado) throws SQLException {
        try {
            String sql = "UPDATE banco_ideas SET estado = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nuevoEstado);
                ps.setInt(2, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            BancoIdea exist = MockDataStore.IDEAS.get(id);
            if (exist != null) {
                exist.setEstado(nuevoEstado);
                return true;
            }
        }
        return false;
    }
}
