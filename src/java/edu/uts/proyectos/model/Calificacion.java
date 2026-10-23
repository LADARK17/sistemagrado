package edu.uts.proyectos.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entidad Calificación para dictámenes de Director y Evaluador.
 * Resultados permitidos: Aprobado, Aplazado, Rechazado.
 */
public class Calificacion implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String RESULTADO_APROBADO = "Aprobado";
    public static final String RESULTADO_APLAZADO = "Aplazado";
    public static final String RESULTADO_RECHAZADO = "Rechazado";

    private Integer id;
    private Integer proyectoId;
    private Integer calificadorId;
    private String calificadorNombre;
    private String fase;
    private String resultado;
    private String observaciones;
    private BigDecimal notaNumerica;
    private Timestamp fechaCalificacion;

    public Calificacion() {}

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

    public Integer getCalificadorId() {
        return calificadorId;
    }

    public void setCalificadorId(Integer calificadorId) {
        this.calificadorId = calificadorId;
    }

    public String getCalificadorNombre() {
        return calificadorNombre;
    }

    public void setCalificadorNombre(String calificadorNombre) {
        this.calificadorNombre = calificadorNombre;
    }

    public String getFase() {
        return fase;
    }

    public void setFase(String fase) {
        this.fase = fase;
    }

    public String getResultado() {
        return resultado;
    }

    public void setResultado(String resultado) {
        this.resultado = resultado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public BigDecimal getNotaNumerica() {
        return notaNumerica;
    }

    public void setNotaNumerica(BigDecimal notaNumerica) {
        this.notaNumerica = notaNumerica;
    }

    public Timestamp getFechaCalificacion() {
        return fechaCalificacion;
    }

    public void setFechaCalificacion(Timestamp fechaCalificacion) {
        this.fechaCalificacion = fechaCalificacion;
    }
}
