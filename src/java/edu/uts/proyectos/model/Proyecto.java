package edu.uts.proyectos.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entidad Proyecto de Grado UTS.
 * Representa el ciclo completo desde Fase 1 hasta Fase Final.
 */
public class Proyecto implements Serializable {
    private static final long serialVersionUID = 1L;

    // Fases Oficiales
    public static final String FASE_1 = "FASE_1_PAGO";
    public static final String FASE_2 = "FASE_2_PROPUESTA_1";
    public static final String FASE_3 = "FASE_3_PROPUESTA_2";
    public static final String FASE_4 = "FASE_4_INFORME_1";
    public static final String FASE_5 = "FASE_5_INFORME_2";
    public static final String FASE_FINAL = "FASE_FINAL_SUSTENTACION";

    // Estados Oficiales
    public static final String ESTADO_RADICADO = "RADICADO";
    public static final String ESTADO_APROBADO_FASE_1 = "APROBADO_FASE_1";
    public static final String ESTADO_EN_EVALUACION_DIRECTOR = "EN_EVALUACION_DIRECTOR";
    public static final String ESTADO_APLAZADO_DIRECTOR = "APLAZADO_DIRECTOR";
    public static final String ESTADO_EN_EVALUACION_EVALUADOR = "EN_EVALUACION_EVALUADOR";
    public static final String ESTADO_APLAZADO_EVALUADOR = "APLAZADO_EVALUADOR";
    public static final String ESTADO_EN_DESARROLLO = "EN_DESARROLLO";
    public static final String ESTADO_EN_REVISION_INFORME_DIR = "EN_REVISION_INFORME_DIR";
    public static final String ESTADO_APLAZADO_INFORME_DIR = "APLAZADO_INFORME_DIR";
    public static final String ESTADO_EN_REVISION_INFORME_EVA = "EN_REVISION_INFORME_EVA";
    public static final String ESTADO_APLAZADO_INFORME_EVA = "APLAZADO_INFORME_EVA";
    public static final String ESTADO_LISTO_PARA_SUSTENTAR = "LISTO_PARA_SUSTENTAR";
    public static final String ESTADO_SUSTENTACION_PROGRAMADA = "SUSTENTACION_PROGRAMADA";
    public static final String ESTADO_SUSTENTADO_PENDIENTE_CIERRE = "SUSTENTADO_PENDIENTE_CIERRE";
    public static final String ESTADO_FINALIZADO_CERRADO = "FINALIZADO_CERRADO";
    public static final String ESTADO_RECHAZADO = "RECHAZADO";
    public static final String ESTADO_NO_APROBADO = "NO_APROBADO";

    private Integer id;
    private String titulo;
    private String objetivo;
    private String urlPago;
    private String urlAnteproyecto;
    private String urlInformeFinal;
    private String urlRepositorioFinal;
    private String faseActual;
    private String estado;
    private Integer estudianteId;
    private Integer companeroId;
    private Integer directorId;
    private Integer evaluadorId;
    private Integer ideaBancoId;
    private String motivoRechazo;
    private Timestamp fechaPago;
    private Timestamp fechaAprobacion;
    private Timestamp fechaLimiteFdc124;
    private Timestamp fechaLimiteVigencia;
    private Timestamp fechaSustentacion;
    private String lugarSustentacion;
    private BigDecimal calificacionSustentacion;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Campos auxiliares para la interfaz (JOINs) y vistas JSP
    private String estudianteNombre;
    private String estudianteDocumento;
    private String companeroNombre;
    private String companeroDocumento;
    private String directorNombre;
    private String evaluadorNombre;
    private long diasVigenciaRestantes;
    private long diasFdc124Restantes;
    private boolean enMoraDocente;

    private String tipoNivel = "Tecnologico";
    private String modalidad = "Desarrollo tecnologico";
    private String lineaInvestigacion = "Ingeniería de Software";
    private String codigoModalidad;
    private String codirectorNombre;
    private String responsableTurno = "comite";
    private String urlTurnitin;

    public Proyecto() {
        this.faseActual = FASE_1;
        this.estado = ESTADO_RADICADO;
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

    public String getObjetivo() {
        return objetivo;
    }

    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }

    public String getUrlPago() {
        return urlPago;
    }

    public void setUrlPago(String urlPago) {
        this.urlPago = urlPago;
    }

    public String getUrlAnteproyecto() {
        return urlAnteproyecto;
    }

    public void setUrlAnteproyecto(String urlAnteproyecto) {
        this.urlAnteproyecto = urlAnteproyecto;
    }

    public String getUrlInformeFinal() {
        return urlInformeFinal;
    }

    public void setUrlInformeFinal(String urlInformeFinal) {
        this.urlInformeFinal = urlInformeFinal;
    }

    public String getUrlRepositorioFinal() {
        return urlRepositorioFinal;
    }

    public void setUrlRepositorioFinal(String urlRepositorioFinal) {
        this.urlRepositorioFinal = urlRepositorioFinal;
    }

    public String getFaseActual() {
        return faseActual;
    }

    public void setFaseActual(String faseActual) {
        this.faseActual = faseActual;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Integer getEstudianteId() {
        return estudianteId;
    }

    public void setEstudianteId(Integer estudianteId) {
        this.estudianteId = estudianteId;
    }

    public Integer getCompaneroId() {
        return companeroId;
    }

    public void setCompaneroId(Integer companeroId) {
        this.companeroId = companeroId;
    }

    public Integer getDirectorId() {
        return directorId;
    }

    public void setDirectorId(Integer directorId) {
        this.directorId = directorId;
    }

    public Integer getEvaluadorId() {
        return evaluadorId;
    }

    public void setEvaluadorId(Integer evaluadorId) {
        this.evaluadorId = evaluadorId;
    }

    public Integer getIdeaBancoId() {
        return ideaBancoId;
    }

    public void setIdeaBancoId(Integer ideaBancoId) {
        this.ideaBancoId = ideaBancoId;
    }

    public String getMotivoRechazo() {
        return motivoRechazo;
    }

    public void setMotivoRechazo(String motivoRechazo) {
        this.motivoRechazo = motivoRechazo;
    }

    public Timestamp getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Timestamp fechaPago) {
        this.fechaPago = fechaPago;
    }

    public Timestamp getFechaAprobacion() {
        return fechaAprobacion;
    }

    public void setFechaAprobacion(Timestamp fechaAprobacion) {
        this.fechaAprobacion = fechaAprobacion;
    }

    public Timestamp getFechaLimiteFdc124() {
        return fechaLimiteFdc124;
    }

    public void setFechaLimiteFdc124(Timestamp fechaLimiteFdc124) {
        this.fechaLimiteFdc124 = fechaLimiteFdc124;
    }

    public Timestamp getFechaLimiteVigencia() {
        return fechaLimiteVigencia;
    }

    public void setFechaLimiteVigencia(Timestamp fechaLimiteVigencia) {
        this.fechaLimiteVigencia = fechaLimiteVigencia;
    }

    public Timestamp getFechaSustentacion() {
        return fechaSustentacion;
    }

    public void setFechaSustentacion(Timestamp fechaSustentacion) {
        this.fechaSustentacion = fechaSustentacion;
    }

    public String getLugarSustentacion() {
        return lugarSustentacion;
    }

    public void setLugarSustentacion(String lugarSustentacion) {
        this.lugarSustentacion = lugarSustentacion;
    }

    public BigDecimal getCalificacionSustentacion() {
        return calificacionSustentacion;
    }

    public void setCalificacionSustentacion(BigDecimal calificacionSustentacion) {
        this.calificacionSustentacion = calificacionSustentacion;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getEstudianteNombre() {
        return estudianteNombre;
    }

    public void setEstudianteNombre(String estudianteNombre) {
        this.estudianteNombre = estudianteNombre;
    }

    public String getEstudianteDocumento() {
        return estudianteDocumento;
    }

    public void setEstudianteDocumento(String estudianteDocumento) {
        this.estudianteDocumento = estudianteDocumento;
    }

    public String getCompaneroNombre() {
        return companeroNombre;
    }

    public void setCompaneroNombre(String companeroNombre) {
        this.companeroNombre = companeroNombre;
    }

    public String getCompaneroDocumento() {
        return companeroDocumento;
    }

    public void setCompaneroDocumento(String companeroDocumento) {
        this.companeroDocumento = companeroDocumento;
    }

    public String getDirectorNombre() {
        return directorNombre;
    }

    public void setDirectorNombre(String directorNombre) {
        this.directorNombre = directorNombre;
    }

    public String getEvaluadorNombre() {
        return evaluadorNombre;
    }

    public void setEvaluadorNombre(String evaluadorNombre) {
        this.evaluadorNombre = evaluadorNombre;
    }

    public long getDiasVigenciaRestantes() {
        return diasVigenciaRestantes;
    }

    public void setDiasVigenciaRestantes(long diasVigenciaRestantes) {
        this.diasVigenciaRestantes = diasVigenciaRestantes;
    }

    public long getDiasFdc124Restantes() {
        return diasFdc124Restantes;
    }

    public void setDiasFdc124Restantes(long diasFdc124Restantes) {
        this.diasFdc124Restantes = diasFdc124Restantes;
    }

    public boolean isEnMoraDocente() {
        return enMoraDocente;
    }

    public void setEnMoraDocente(boolean enMoraDocente) {
        this.enMoraDocente = enMoraDocente;
    }

    public int getFase() {
        if (faseActual == null) return 1;
        if (faseActual.startsWith("FASE_1")) return 1;
        if (faseActual.startsWith("FASE_2")) return 2;
        if (faseActual.startsWith("FASE_3")) return 3;
        if (faseActual.startsWith("FASE_4")) return 4;
        if (faseActual.startsWith("FASE_5")) return 5;
        if (faseActual.startsWith("FASE_FINAL") || faseActual.startsWith("FASE_6")) return 6;
        try {
            return Integer.parseInt(faseActual.replaceAll("\\D+", ""));
        } catch (Exception e) {
            return 1;
        }
    }

    public void setFase(int fase) {
        switch (fase) {
            case 1: this.faseActual = FASE_1; break;
            case 2: this.faseActual = FASE_2; break;
            case 3: this.faseActual = FASE_3; break;
            case 4: this.faseActual = FASE_4; break;
            case 5: this.faseActual = FASE_5; break;
            case 6: this.faseActual = FASE_FINAL; break;
            default: this.faseActual = "FASE_" + fase; break;
        }
    }

    public String getResponsableTurno() {
        if (responsableTurno != null) return responsableTurno;
        int f = getFase();
        if (f == 1 || f == 6) return "comite";
        if (f == 2 || f == 4) return "director";
        if (f == 3 || f == 5) return "evaluador";
        return "estudiante";
    }

    public void setResponsableTurno(String responsableTurno) {
        this.responsableTurno = responsableTurno;
    }

    public String getUrlTurnitin() {
        return urlTurnitin;
    }

    public void setUrlTurnitin(String urlTurnitin) {
        this.urlTurnitin = urlTurnitin;
    }

    public String getCodigoModalidad() {
        if (codigoModalidad != null) return codigoModalidad;
        String prefijo = "Tecnologico".equalsIgnoreCase(getTipoNivel()) ? "65" : "125";
        return prefijo + "-2026-00" + (id != null ? id : 1);
    }

    public void setCodigoModalidad(String codigoModalidad) {
        this.codigoModalidad = codigoModalidad;
    }

    public String getCodirectorNombre() {
        return codirectorNombre;
    }

    public void setCodirectorNombre(String codirectorNombre) {
        this.codirectorNombre = codirectorNombre;
    }

    public String getTipoNivel() {
        return tipoNivel;
    }

    public void setTipoNivel(String tipoNivel) {
        this.tipoNivel = tipoNivel;
    }

    public String getModalidad() {
        return modalidad;
    }

    public void setModalidad(String modalidad) {
        this.modalidad = modalidad;
    }

    public String getLineaInvestigacion() {
        return lineaInvestigacion;
    }

    public void setLineaInvestigacion(String lineaInvestigacion) {
        this.lineaInvestigacion = lineaInvestigacion;
    }

    public String getUrlSoportePago() {
        return urlPago;
    }

    public void setUrlSoportePago(String urlSoportePago) {
        this.urlPago = urlSoportePago;
    }
}
