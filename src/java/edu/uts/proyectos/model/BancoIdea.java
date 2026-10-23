package edu.uts.proyectos.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Entidad Banco de Ideas de Grado UTS.
 * Estados: DISPONIBLE, ASIGNADA, INACTIVA.
 */
public class BancoIdea implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String ESTADO_DISPONIBLE = "DISPONIBLE";
    public static final String ESTADO_ASIGNADA = "ASIGNADA";
    public static final String ESTADO_INACTIVA = "INACTIVA";

    private Integer id;
    private String titulo;
    private String descripcion;
    private String lineaInvestigacion;
    private String estado;
    private Integer creadoPor;
    private String creadoPorNombre;
    private Timestamp createdAt;

    public BancoIdea() {
        this.estado = ESTADO_DISPONIBLE;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getLineaInvestigacion() {
        return lineaInvestigacion;
    }

    public void setLineaInvestigacion(String lineaInvestigacion) {
        this.lineaInvestigacion = lineaInvestigacion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Integer getCreadoPor() {
        return creadoPor;
    }

    public void setCreadoPor(Integer creadoPor) {
        this.creadoPor = creadoPor;
    }

    public String getCreadoPorNombre() {
        return creadoPorNombre;
    }

    public void setCreadoPorNombre(String creadoPorNombre) {
        this.creadoPorNombre = creadoPorNombre;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
