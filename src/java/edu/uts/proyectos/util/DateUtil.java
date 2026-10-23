package edu.uts.proyectos.util;

import java.sql.Timestamp;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

/**
 * Utilidad de cálculo de plazos y reglas de tiempo:
 * - Vigencia total del proyecto: 180 días calendario.
 * - Legalización y aprobación de anteproyecto F-DC-124: 12 semanas (84 días).
 * - Emisión de concepto docente (Director y Evaluador): 5 días hábiles.
 */
public class DateUtil {

    public static final int VIGENCIA_MAXIMA_DIAS = 180;
    public static final int PLAZO_FDC124_SEMANAS = 12;
    public static final int DIAS_HABILES_DOCENTE = 5;

    /**
     * Calcula los días calendario restantes respecto a una fecha límite.
     */
    public static long calcularDiasRestantes(Timestamp fechaLimite) {
        if (fechaLimite == null) return 0;
        LocalDate hoy = LocalDate.now();
        LocalDate limite = fechaLimite.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        return ChronoUnit.DAYS.between(hoy, limite);
    }

    /**
     * Calcula si una tarea docente supera los 5 días hábiles desde la fecha de subida.
     */
    public static boolean estaEnMoraDocente(Timestamp fechaSubidaDocumento) {
        if (fechaSubidaDocumento == null) return false;
        LocalDate fechaInicio = fechaSubidaDocumento.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate hoy = LocalDate.now();

        int diasHabiles = 0;
        LocalDate actual = fechaInicio.plusDays(1);
        while (!actual.isAfter(hoy)) {
            DayOfWeek dow = actual.getDayOfWeek();
            if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY) {
                diasHabiles++;
            }
            actual = actual.plusDays(1);
        }
        return diasHabiles > DIAS_HABILES_DOCENTE;
    }

    /**
     * Genera la fecha límite de vigencia de 180 días calendario a partir de la fecha de aprobación.
     */
    public static Timestamp calcularFechaLimiteVigencia(Timestamp fechaAprobacion) {
        if (fechaAprobacion == null) return null;
        LocalDate local = fechaAprobacion.toInstant().atZone(ZoneId.systemDefault()).toLocalDate().plusDays(VIGENCIA_MAXIMA_DIAS);
        return Timestamp.valueOf(local.atStartOfDay());
    }

    /**
     * Genera la fecha límite de 12 semanas para el formato F-DC-124.
     */
    public static Timestamp calcularFechaLimiteFdc124(Timestamp fechaAprobacion) {
        if (fechaAprobacion == null) return null;
        LocalDate local = fechaAprobacion.toInstant().atZone(ZoneId.systemDefault()).toLocalDate().plusWeeks(PLAZO_FDC124_SEMANAS);
        return Timestamp.valueOf(local.atStartOfDay());
    }
}
