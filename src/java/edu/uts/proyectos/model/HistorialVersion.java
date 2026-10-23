package edu.uts.proyectos.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Entidad Historial de Versiones.
 * Mantiene la trazabilidad inmutable de todas las URLs radicadas y corregidas.
 */
public class HistorialVersion implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer proyectoId;
    private String fase;
    private String urlDocumento;
    private Integer subidoPor;
    private String subidoPorNombre;
    private String observacionesEstudiante;
    private Timestamp fechaSubida;

    public HistorialVersion() {}

    public HistorialVersion(Integer proyectoId, String fase, String urlDocumento, Integer subidoPor, String observacionesEstudiante) {
        this.proyectoId = proyectoId;
        this.fase = fase;
        this.urlDocumento = urlDocumento;
        this.subidoPor = subidoPor;
        this.observacionesEstudiante = observacionesEstudiante;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProyectoId() {
        return proyectoId;
    }

    public void setProyectoId(Integer proyectoId) {
        this.proyectoId = proyectoId;
    }

    public String getFase() {
        return fase;
    }

    public void setFase(String fase) {
        this.fase = fase;
    }

    public String getUrlDocumento() {
        return urlDocumento;
    }

    public void setUrlDocumento(String urlDocumento) {
        this.urlDocumento = urlDocumento;
    }

    public Integer getSubidoPor() {
        return subidoPor;
    }

    public void setSubidoPor(Integer subidoPor) {
        this.subidoPor = subidoPor;
    }

    public String getSubidoPorNombre() {
        return subidoPorNombre;
    }

    public void setSubidoPorNombre(String subidoPorNombre) {
        this.subidoPorNombre = subidoPorNombre;
    }

    public String getObservacionesEstudiante() {
        return observacionesEstudiante;
    }

    public void setObservacionesEstudiante(String observacionesEstudiante) {
        this.observacionesEstudiante = observacionesEstudiante;
    }

    public Timestamp getFechaSubida() {
        return fechaSubida;
    }

    public void setFechaSubida(Timestamp fechaSubida) {
        this.fechaSubida = fechaSubida;
    }

    public String getObservaciones() {
        return observacionesEstudiante;
    }

    public void setObservaciones(String observaciones) {
        this.observacionesEstudiante = observaciones;
    }
}
