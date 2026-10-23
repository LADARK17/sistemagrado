package edu.uts.proyectos.config;

import edu.uts.proyectos.model.*;
import edu.uts.proyectos.util.DateUtil;
import edu.uts.proyectos.util.PasswordUtil;
import java.sql.Timestamp;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Almacén en memoria de respaldo para modo Demostración / Standalone.
 * Se activa automáticamente cuando Supabase aún no tiene credenciales configuradas
 * o se encuentra fuera de línea, garantizando una experiencia 100% interactiva en navegador.
 */
public class MockDataStore {

    public static final Map<Integer, Usuario> USUARIOS = new ConcurrentHashMap<>();
    public static final Map<Integer, BancoIdea> IDEAS = new ConcurrentHashMap<>();
    public static final Map<Integer, Proyecto> PROYECTOS = new ConcurrentHashMap<>();
    public static final List<HistorialVersion> HISTORIAL = Collections.synchronizedList(new ArrayList<>());
    public static final List<Calificacion> CALIFICACIONES = Collections.synchronizedList(new ArrayList<>());

    private static final AtomicInteger ID_USUARIO = new AtomicInteger(7);
    private static final AtomicInteger ID_IDEA = new AtomicInteger(3);
    private static final AtomicInteger ID_PROYECTO = new AtomicInteger(1);
    private static final AtomicInteger ID_HISTORIAL = new AtomicInteger(2);
    private static final AtomicInteger ID_CALIFICACION = new AtomicInteger(0);

    static {
        inicializarDatosSeed();
    }

    public static void inicializarDatosSeed() {
        USUARIOS.clear();
        IDEAS.clear();
        PROYECTOS.clear();
        HISTORIAL.clear();
        CALIFICACIONES.clear();

        String hash = PasswordUtil.hashPassword("Uts2026*");

        // 1. Usuarios con los 4 roles canónicos (administrador, comite, docente, estudiante)
        // Usuario 1: Administrador Y Docente (Multi-rol)
        Usuario admin = agregarUsuario(1, "Ing. Carlos Morales Admin", "admin@correo.uts.edu.co", "1098700001", hash, Usuario.ROL_ADMIN);
        admin.agregarRol(Usuario.ROL_DOCENTE);

        // Usuario 2: Comité
        agregarUsuario(2, "Dra. Marta Lucía Coordinadora", "comite@correo.uts.edu.co", "1098700002", hash, Usuario.ROL_COMITE);

        // Usuario 3 y 4: Docentes (Asignables como Director, Evaluador, Codirector)
        agregarUsuario(3, "Mg. Fernando Gómez Docente", "fgomez@correo.uts.edu.co", "1098700003", hash, Usuario.ROL_DOCENTE);
        agregarUsuario(4, "Dra. Patricia Silva Docente", "psilva@correo.uts.edu.co", "1098700004", hash, Usuario.ROL_DOCENTE);

        // Usuarios 5, 6, 7: Estudiantes
        agregarUsuario(5, "Juan David Pérez Estudiante", "jperez@correo.uts.edu.co", "1098700005", hash, Usuario.ROL_ESTUDIANTE);
        agregarUsuario(6, "Laura Marcela Gómez Estudiante", "lgomez@correo.uts.edu.co", "1098700006", hash, Usuario.ROL_ESTUDIANTE);
        agregarUsuario(7, "Diego Alejandro Ortiz Estudiante", "dortiz@correo.uts.edu.co", "1098700007", hash, Usuario.ROL_ESTUDIANTE);

        // 2. Banco de Ideas
        agregarIdea(1, "Sistema IoT para Monitoreo de Calidad de Aire en Laboratorios UTS",
                "Desarrollo de nodo sensor ESP32 para telemetría ambiental en tiempo real en laboratorios de química y electrónica.",
                "Telecomunicaciones e IoT", BancoIdea.ESTADO_DISPONIBLE, 2, "Dra. Marta Lucía Coordinadora");

        agregarIdea(2, "Optimización de Rutas de Recolección de Residuos Electrónicos en Bucaramanga",
                "Algoritmo heurístico aplicado a la logística inversa de RAEE en el área metropolitana de Bucaramanga.",
                "Logística y Gestión Ambiental", BancoIdea.ESTADO_DISPONIBLE, 2, "Dra. Marta Lucía Coordinadora");

        agregarIdea(3, "Plataforma Web de Gestión de Egresados del Programa de Sistemas",
                "Módulo de seguimiento y vinculación laboral para graduados de las Unidades Tecnológicas de Santander.",
                "Ingeniería de Software", BancoIdea.ESTADO_ASIGNADA, 2, "Dra. Marta Lucía Coordinadora");

        // 3. Proyecto Semilla en Fase 2 (Propuesta I - Evaluación de Director)
        Timestamp ahora = new Timestamp(System.currentTimeMillis());
        Proyecto p = new Proyecto();
        p.setId(1);
        p.setTitulo("Plataforma Web de Gestión de Egresados del Programa de Sistemas");
        p.setObjetivo("Diseñar e implementar un sistema web institucional para el seguimiento y oportunidades laborales de egresados UTS.");
        p.setUrlPago("https://drive.google.com/file/d/1A2B3C4D_recibo_pago_uts/view");
        p.setUrlAnteproyecto("https://drive.google.com/file/d/1E5F6G7H_anteproyecto_fdc124/view");
        p.setFaseActual(Proyecto.FASE_2);
        p.setEstado(Proyecto.ESTADO_EN_EVALUACION_DIRECTOR);
        p.setEstudianteId(5);
        p.setCompaneroId(6);
        p.setDirectorId(3);
        p.setEvaluadorId(4);
        p.setIdeaBancoId(3);
        p.setFechaPago(ahora);
        p.setFechaAprobacion(ahora);
        p.setFechaLimiteFdc124(DateUtil.calcularFechaLimiteFdc124(ahora));
        p.setFechaLimiteVigencia(DateUtil.calcularFechaLimiteVigencia(ahora));
        p.setCreatedAt(ahora);
        p.setUpdatedAt(ahora);

        p.setEstudianteNombre("Juan David Pérez Estudiante");
        p.setEstudianteDocumento("1098700005");
        p.setCompaneroNombre("Laura Marcela Gómez Compañera");
        p.setDirectorNombre("Mg. Fernando Gómez Director");
        p.setEvaluadorNombre("Dra. Patricia Silva Evaluadora");
        p.setDiasVigenciaRestantes(DateUtil.calcularDiasRestantes(p.getFechaLimiteVigencia()));
        p.setDiasFdc124Restantes(DateUtil.calcularDiasRestantes(p.getFechaLimiteFdc124()));

        PROYECTOS.put(1, p);

        // 4. Historial Inicial
        HistorialVersion h1 = new HistorialVersion(1, Proyecto.FASE_1, p.getUrlPago(), 5, "Radicación inicial de propuesta y pago.");
        h1.setId(1);
        h1.setSubidoPorNombre("Juan David Pérez Estudiante");
        h1.setFechaSubida(ahora);
        HISTORIAL.add(h1);

        HistorialVersion h2 = new HistorialVersion(1, Proyecto.FASE_2, p.getUrlAnteproyecto(), 5, "Carga de formato institucional F-DC-124.");
        h2.setId(2);
        h2.setSubidoPorNombre("Juan David Pérez Estudiante");
        h2.setFechaSubida(ahora);
        HISTORIAL.add(h2);
    }

    private static Usuario agregarUsuario(int id, String nombre, String correo, String doc, String hash, String rol) {
        Usuario u = new Usuario();
        u.setId(id);
        u.setNombreCompleto(nombre);
        u.setCorreo(correo);
        u.setDocumento(doc);
        u.setPasswordHash(hash);
        u.setRol(rol);
        u.setEstadoActivo(true);
        u.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        USUARIOS.put(id, u);
        return u;
    }

    private static void agregarIdea(int id, String titulo, String desc, String linea, String estado, int creadoPor, String creadoPorNombre) {
        BancoIdea b = new BancoIdea();
        b.setId(id);
        b.setTitulo(titulo);
        b.setDescripcion(desc);
        b.setLineaInvestigacion(linea);
        b.setEstado(estado);
        b.setCreadoPor(creadoPor);
        b.setCreadoPorNombre(creadoPorNombre);
        b.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        IDEAS.put(id, b);
    }

    public static int nextUsuarioId() { return ID_USUARIO.incrementAndGet(); }
    public static int nextIdeaId() { return ID_IDEA.incrementAndGet(); }
    public static int nextProyectoId() { return ID_PROYECTO.incrementAndGet(); }
    public static int nextHistorialId() { return ID_HISTORIAL.incrementAndGet(); }
    public static int nextCalificacionId() { return ID_CALIFICACION.incrementAndGet(); }
}
