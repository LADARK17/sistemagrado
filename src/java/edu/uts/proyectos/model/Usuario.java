package edu.uts.proyectos.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Entidad Usuario (SIGRADO UTS).
 * Cuatro roles de cuenta canónicos: administrador, comite, docente, estudiante.
 * Soporta asignación de múltiples roles por usuario (usuario_rol).
 */
public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;

    // 4 roles de cuenta exactos
    public static final String ROL_ADMIN = "administrador";
    public static final String ROL_COMITE = "comite";
    public static final String ROL_DOCENTE = "docente";
    public static final String ROL_ESTUDIANTE = "estudiante";

    // Compatibilidad retroactiva
    public static final String ROL_DIRECTOR = "docente";
    public static final String ROL_EVALUADOR = "docente";

    private Integer id;
    private String documento;
    private String nombres;
    private String apellidos;
    private String nombreCompleto;
    private String correo;
    private String passwordHash;
    private String telefono;
    private String programa;
    private String rol; // Rol activo en sesión
    private List<String> roles; // Lista de roles asignados
    private Boolean estadoActivo;
    private Timestamp createdAt;

    public Usuario() {
        this.estadoActivo = true;
        this.programa = "Ingeniería de Sistemas";
        this.roles = new ArrayList<>();
    }

    public Usuario(String nombreCompleto, String correo, String documento, String passwordHash, String rol) {
        this();
        this.nombreCompleto = nombreCompleto;
        this.correo = correo;
        this.documento = documento;
        this.passwordHash = passwordHash;
        this.rol = normalizarRol(rol);
        this.roles.add(this.rol);
    }

    public static String normalizarRol(String rolEntrada) {
        if (rolEntrada == null) return ROL_ESTUDIANTE;
        String r = rolEntrada.trim().toLowerCase();
        if (r.contains("admin")) return ROL_ADMIN;
        if (r.contains("comit") || r.contains("coord")) return ROL_COMITE;
        if (r.contains("docent") || r.contains("direct") || r.contains("evalua") || r.contains("codirect")) return ROL_DOCENTE;
        return ROL_ESTUDIANTE;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
        actualizarNombreCompleto();
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
        actualizarNombreCompleto();
    }

    private void actualizarNombreCompleto() {
        if (this.nombres != null && this.apellidos != null) {
            this.nombreCompleto = this.nombres + " " + this.apellidos;
        }
    }

    public String getNombreCompleto() {
        if (nombreCompleto != null) return nombreCompleto;
        if (nombres != null) return nombres + (apellidos != null ? " " + apellidos : "");
        return "";
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getPrograma() {
        return programa;
    }

    public void setPrograma(String programa) {
        this.programa = programa;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = normalizarRol(rol);
        if (this.roles == null) this.roles = new ArrayList<>();
        if (!this.roles.contains(this.rol)) {
            this.roles.add(this.rol);
        }
    }

    public List<String> getRoles() {
        if (roles == null) roles = new ArrayList<>();
        if (rol != null && !roles.contains(rol)) {
            roles.add(rol);
        }
        return roles;
    }

    public void setRoles(List<String> roles) {
        this.roles = roles;
    }

    public void agregarRol(String r) {
        String normalizado = normalizarRol(r);
        if (this.roles == null) this.roles = new ArrayList<>();
        if (!this.roles.contains(normalizado)) {
            this.roles.add(normalizado);
        }
    }

    public Boolean getEstadoActivo() {
        return estadoActivo;
    }

    public void setEstadoActivo(Boolean estadoActivo) {
        this.estadoActivo = estadoActivo;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
