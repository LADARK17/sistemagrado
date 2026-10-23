package edu.uts.proyectos.dao;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.config.MockDataStore;
import edu.uts.proyectos.model.Usuario;
import edu.uts.proyectos.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario autenticar(String identificador, String password) throws SQLException {
        try {
            String sql = "SELECT id, nombre_completo, correo, documento, password_hash, rol, estado_activo, created_at "
                       + "FROM usuarios WHERE (correo = ? OR documento = ?) AND estado_activo = TRUE";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, identificador.trim());
                ps.setString(2, identificador.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String hashAlmacenado = rs.getString("password_hash");
                        if (PasswordUtil.verificarPassword(password, hashAlmacenado)) {
                            Usuario u = new Usuario();
                            u.setId(rs.getInt("id"));
                            u.setNombreCompleto(rs.getString("nombre_completo"));
                            u.setCorreo(rs.getString("correo"));
                            u.setDocumento(rs.getString("documento"));
                            u.setPasswordHash(hashAlmacenado);
                            u.setRol(rs.getString("rol"));
                            u.setEstadoActivo(rs.getBoolean("estado_activo"));
                            u.setCreatedAt(rs.getTimestamp("created_at"));
                            return u;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            // Fallback transparente a MockDataStore
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if ((u.getCorreo().equalsIgnoreCase(identificador.trim()) || u.getDocumento().equals(identificador.trim()))
                        && (u.getEstadoActivo() == null || u.getEstadoActivo())) {
                    if (PasswordUtil.verificarPassword(password, u.getPasswordHash())) {
                        return u;
                    }
                }
            }
        }
        return null;
    }

    public List<Usuario> listarTodos() throws SQLException {
        try {
            List<Usuario> lista = new ArrayList<>();
            String sql = "SELECT id, nombre_completo, correo, documento, rol, estado_activo, created_at "
                       + "FROM usuarios ORDER BY id ASC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNombreCompleto(rs.getString("nombre_completo"));
                    u.setCorreo(rs.getString("correo"));
                    u.setDocumento(rs.getString("documento"));
                    u.setRol(rs.getString("rol"));
                    u.setEstadoActivo(rs.getBoolean("estado_activo"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    lista.add(u);
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Usuario> lista = new ArrayList<>(MockDataStore.USUARIOS.values());
            lista.sort((a, b) -> a.getId().compareTo(b.getId()));
            return lista;
        }
    }

    public Usuario buscarPorId(int id) throws SQLException {
        try {
            String sql = "SELECT id, nombre_completo, correo, documento, rol, estado_activo, created_at "
                       + "FROM usuarios WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Usuario u = new Usuario();
                        u.setId(rs.getInt("id"));
                        u.setNombreCompleto(rs.getString("nombre_completo"));
                        u.setCorreo(rs.getString("correo"));
                        u.setDocumento(rs.getString("documento"));
                        u.setRol(rs.getString("rol"));
                        u.setEstadoActivo(rs.getBoolean("estado_activo"));
                        u.setCreatedAt(rs.getTimestamp("created_at"));
                        return u;
                    }
                }
            }
        } catch (Exception ex) {
            return MockDataStore.USUARIOS.get(id);
        }
        return null;
    }

    public Usuario buscarPorDocumento(String documento) throws SQLException {
        try {
            String sql = "SELECT id, nombre_completo, correo, documento, rol, estado_activo, created_at "
                       + "FROM usuarios WHERE documento = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, documento.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Usuario u = new Usuario();
                        u.setId(rs.getInt("id"));
                        u.setNombreCompleto(rs.getString("nombre_completo"));
                        u.setCorreo(rs.getString("correo"));
                        u.setDocumento(rs.getString("documento"));
                        u.setRol(rs.getString("rol"));
                        u.setEstadoActivo(rs.getBoolean("estado_activo"));
                        u.setCreatedAt(rs.getTimestamp("created_at"));
                        return u;
                    }
                }
            }
        } catch (Exception ex) {
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if (u.getDocumento().equals(documento.trim())) return u;
            }
        }
        return null;
    }

    public boolean existeCorreo(String correo, Integer excluirId) throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ?" + (excluirId != null ? " AND id <> ?" : "");
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, correo.trim());
                if (excluirId != null) ps.setInt(2, excluirId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt(1) > 0;
                }
            }
        } catch (Exception ex) {
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if (excluirId != null && u.getId().equals(excluirId)) continue;
                if (u.getCorreo().equalsIgnoreCase(correo.trim())) return true;
            }
        }
        return false;
    }

    public boolean existeDocumento(String documento, Integer excluirId) throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM usuarios WHERE documento = ?" + (excluirId != null ? " AND id <> ?" : "");
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, documento.trim());
                if (excluirId != null) ps.setInt(2, excluirId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt(1) > 0;
                }
            }
        } catch (Exception ex) {
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if (excluirId != null && u.getId().equals(excluirId)) continue;
                if (u.getDocumento().equals(documento.trim())) return true;
            }
        }
        return false;
    }

    public boolean insertar(Usuario u) throws SQLException {
        try {
            String sql = "INSERT INTO usuarios (nombre_completo, correo, documento, password_hash, rol, estado_activo) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, u.getNombreCompleto().trim());
                ps.setString(2, u.getCorreo().trim());
                ps.setString(3, u.getDocumento().trim());
                ps.setString(4, u.getPasswordHash());
                ps.setString(5, u.getRol());
                ps.setBoolean(6, u.getEstadoActivo() != null ? u.getEstadoActivo() : true);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            int newId = MockDataStore.nextUsuarioId();
            u.setId(newId);
            u.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            MockDataStore.USUARIOS.put(newId, u);
            return true;
        }
    }

    public boolean actualizar(Usuario u, boolean actualizarPassword) throws SQLException {
        try {
            String sql = actualizarPassword
                       ? "UPDATE usuarios SET nombre_completo = ?, correo = ?, documento = ?, password_hash = ?, rol = ?, estado_activo = ? WHERE id = ?"
                       : "UPDATE usuarios SET nombre_completo = ?, correo = ?, documento = ?, rol = ?, estado_activo = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                ps.setString(idx++, u.getNombreCompleto().trim());
                ps.setString(idx++, u.getCorreo().trim());
                ps.setString(idx++, u.getDocumento().trim());
                if (actualizarPassword) {
                    ps.setString(idx++, u.getPasswordHash());
                }
                ps.setString(idx++, u.getRol());
                ps.setBoolean(idx++, u.getEstadoActivo());
                ps.setInt(idx, u.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Usuario exist = MockDataStore.USUARIOS.get(u.getId());
            if (exist != null) {
                exist.setNombreCompleto(u.getNombreCompleto());
                exist.setCorreo(u.getCorreo());
                exist.setDocumento(u.getDocumento());
                exist.setRol(u.getRol());
                exist.setEstadoActivo(u.getEstadoActivo());
                if (actualizarPassword) exist.setPasswordHash(u.getPasswordHash());
                return true;
            }
        }
        return false;
    }

    public boolean inactivar(int id) throws SQLException {
        try {
            String sql = "UPDATE usuarios SET estado_activo = FALSE WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            Usuario u = MockDataStore.USUARIOS.get(id);
            if (u != null) {
                u.setEstadoActivo(false);
                return true;
            }
        }
        return false;
    }

    public boolean tieneProyectosAsociados(int usuarioId) throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM proyectos WHERE estudiante_id = ? OR companero_id = ? OR director_id = ? OR evaluador_id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, usuarioId);
                ps.setInt(2, usuarioId);
                ps.setInt(3, usuarioId);
                ps.setInt(4, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt(1) > 0;
                }
            }
        } catch (Exception ex) {
            for (var p : MockDataStore.PROYECTOS.values()) {
                if ((p.getEstudianteId() != null && p.getEstudianteId() == usuarioId)
                        || (p.getCompaneroId() != null && p.getCompaneroId() == usuarioId)
                        || (p.getDirectorId() != null && p.getDirectorId() == usuarioId)
                        || (p.getEvaluadorId() != null && p.getEvaluadorId() == usuarioId)) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean eliminar(int id) throws SQLException {
        if (tieneProyectosAsociados(id)) {
            return false;
        }
        try {
            String sql = "DELETE FROM usuarios WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            return MockDataStore.USUARIOS.remove(id) != null;
        }
    }

    public List<Usuario> listarPorRol(String rol) throws SQLException {
        try {
            List<Usuario> lista = new ArrayList<>();
            String sql = "SELECT id, nombre_completo, correo, documento, rol, estado_activo, created_at "
                       + "FROM usuarios WHERE rol = ? AND estado_activo = TRUE ORDER BY nombre_completo ASC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, rol);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Usuario u = new Usuario();
                        u.setId(rs.getInt("id"));
                        u.setNombreCompleto(rs.getString("nombre_completo"));
                        u.setCorreo(rs.getString("correo"));
                        u.setDocumento(rs.getString("documento"));
                        u.setRol(rs.getString("rol"));
                        u.setEstadoActivo(rs.getBoolean("estado_activo"));
                        lista.add(u);
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Usuario> lista = new ArrayList<>();
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if (rol.equalsIgnoreCase(u.getRol()) && (u.getEstadoActivo() == null || u.getEstadoActivo())) {
                    lista.add(u);
                }
            }
            lista.sort((a, b) -> a.getNombreCompleto().compareTo(b.getNombreCompleto()));
            return lista;
        }
    }

    public boolean estudianteTieneProyectoActivo(int estudianteId) throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM proyectos WHERE (estudiante_id = ? OR companero_id = ?) "
                       + "AND estado NOT IN ('RECHAZADO', 'NO_APROBADO', 'FINALIZADO_CERRADO')";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, estudianteId);
                ps.setInt(2, estudianteId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt(1) > 0;
                }
            }
        } catch (Exception ex) {
            for (var p : MockDataStore.PROYECTOS.values()) {
                if (((p.getEstudianteId() != null && p.getEstudianteId() == estudianteId)
                        || (p.getCompaneroId() != null && p.getCompaneroId() == estudianteId))
                        && !p.getEstado().equals("RECHAZADO")
                        && !p.getEstado().equals("NO_APROBADO")
                        && !p.getEstado().equals("FINALIZADO_CERRADO")) {
                    return true;
                }
            }
        }
        return false;
    }

    public List<Usuario> listarEstudiantesDisponibles(Integer excluirEstudianteId) throws SQLException {
        try {
            List<Usuario> lista = new ArrayList<>();
            String sql = "SELECT u.id, u.nombre_completo, u.documento, u.correo "
                       + "FROM usuarios u WHERE u.rol = 'Estudiante' AND u.estado_activo = TRUE "
                       + (excluirEstudianteId != null ? "AND u.id <> ? " : "")
                       + "AND u.id NOT IN ( "
                       + "    SELECT estudiante_id FROM proyectos WHERE estado NOT IN ('RECHAZADO', 'NO_APROBADO', 'FINALIZADO_CERRADO') "
                       + "    UNION "
                       + "    SELECT companero_id FROM proyectos WHERE companero_id IS NOT NULL AND estado NOT IN ('RECHAZADO', 'NO_APROBADO', 'FINALIZADO_CERRADO') "
                       + ") ORDER BY u.nombre_completo ASC";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                if (excluirEstudianteId != null) {
                    ps.setInt(1, excluirEstudianteId);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Usuario u = new Usuario();
                        u.setId(rs.getInt("id"));
                        u.setNombreCompleto(rs.getString("nombre_completo"));
                        u.setDocumento(rs.getString("documento"));
                        u.setCorreo(rs.getString("correo"));
                        lista.add(u);
                    }
                }
            }
            return lista;
        } catch (Exception ex) {
            List<Usuario> lista = new ArrayList<>();
            for (Usuario u : MockDataStore.USUARIOS.values()) {
                if (!Usuario.ROL_ESTUDIANTE.equalsIgnoreCase(u.getRol())) continue;
                if (excluirEstudianteId != null && u.getId().equals(excluirEstudianteId)) continue;
                if (!estudianteTieneProyectoActivo(u.getId())) {
                    lista.add(u);
                }
            }
            lista.sort((a, b) -> a.getNombreCompleto().compareTo(b.getNombreCompleto()));
            return lista;
        }
    }
}
