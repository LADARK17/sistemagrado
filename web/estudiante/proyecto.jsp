<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guardEstudiante.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>
<%@ page import="edu.uts.proyectos.model.Proyecto, edu.uts.proyectos.model.BancoIdea, edu.uts.proyectos.model.Usuario, edu.uts.proyectos.model.HistorialVersion, edu.uts.proyectos.dao.UsuarioDAO, java.sql.Timestamp, java.util.Collection, java.util.List, java.util.ArrayList" %>

<%
    String msg = null;
    Proyecto p = MockDataStore.PROYECTOS.get(1);

    Integer miUsuarioId = (Integer) session.getAttribute("usuario_id");
    if (miUsuarioId == null) miUsuarioId = 5;

    // Obtener compañeros estudiantes disponibles para el ComboBox (RF-EST-03)
    List<Usuario> companerosDisponibles = new ArrayList<>();
    Usuario c1 = new Usuario();
    c1.setId(6);
    c1.setNombreCompleto("Laura Marcela Gómez Estudiante");
    c1.setDocumento("1098700006");
    c1.setCorreo("lgomez@correo.uts.edu.co");
    c1.setRol("estudiante");
    companerosDisponibles.add(c1);

    Usuario c2 = new Usuario();
    c2.setId(7);
    c2.setNombreCompleto("Diego Alejandro Ortiz Estudiante");
    c2.setDocumento("1098700007");
    c2.setCorreo("dortiz@correo.uts.edu.co");
    c2.setRol("estudiante");
    companerosDisponibles.add(c2);

    try {
        UsuarioDAO udao = new UsuarioDAO();
        List<Usuario> todosEst = udao.listarPorRol("estudiante");
        for (Usuario u : todosEst) {
            if (u.getId() != null && !u.getId().equals(miUsuarioId) && !"1098700006".equals(u.getDocumento()) && !"1098700007".equals(u.getDocumento())) {
                companerosDisponibles.add(u);
            }
        }
    } catch (Exception ignored) {}
    request.setAttribute("companerosDisponibles", companerosDisponibles);

    // Obtener ideas de grado disponibles en el Banco (RF-EST-01, RF-EST-02)
    Collection<BancoIdea> ideasBanco = MockDataStore.IDEAS.values();
    request.setAttribute("ideasBanco", ideasBanco);

    // Pre-cargar idea si viene desde el Banco de Ideas
    String ideaIdParam = request.getParameter("idea_id");
    BancoIdea ideaPrecargada = null;
    if (ideaIdParam != null && !ideaIdParam.trim().isEmpty()) {
        try {
            int idParsed = Integer.parseInt(ideaIdParam.trim());
            ideaPrecargada = MockDataStore.IDEAS.get(idParsed);
        } catch (Exception ignored) {}
    }
    request.setAttribute("ideaPrecargada", ideaPrecargada);

    String reqAction = request.getParameter("action");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("radicar".equalsIgnoreCase(reqAction)) {
            // RF-EST-01, RF-EST-02, RF-EST-03, RF-EST-04: Radicación Oficial
            String titulo = request.getParameter("titulo");
            String nivel = request.getParameter("tipo_nivel");
            String modalidad = request.getParameter("tipo_modalidad");
            String linea = request.getParameter("linea_investigacion");
            String objetivo = request.getParameter("objetivo_general");
            String urlPago = request.getParameter("url_pago");
            String modoEquipo = request.getParameter("modo_equipo"); // "pareja" o "individual"
            String companeroDoc = request.getParameter("companero_doc");
            String companeroNombre = request.getParameter("companero_nombre");
            String companeroIdStr = request.getParameter("companero_id");
            String selectedIdeaId = request.getParameter("idea_id");

            if (p == null) {
                p = new Proyecto();
                p.setId(1);
            }

            p.setTitulo(titulo != null && !titulo.trim().isEmpty() ? titulo.trim() : "Proyecto de Grado");
            p.setTipoNivel(nivel != null ? nivel : "Tecnologico");
            p.setModalidad(modalidad != null ? modalidad : "Desarrollo tecnologico");
            p.setLineaInvestigacion(linea != null && !linea.trim().isEmpty() ? linea.trim() : "Ingeniería de Software");
            p.setObjetivo(objetivo != null ? objetivo.trim() : "");
            p.setUrlSoportePago(urlPago != null ? urlPago.trim() : "");
            p.setUrlPago(urlPago != null ? urlPago.trim() : "");
            p.setFase(1);
            p.setFaseActual(Proyecto.FASE_1);
            p.setResponsableTurno("comite");
            p.setEstado("En curso");

            p.setEstudianteId(miUsuarioId);
            p.setEstudianteNombre((String) session.getAttribute("nombre"));
            p.setEstudianteDocumento((String) session.getAttribute("documento"));

            // Validación de equipo (RF-EST-03)
            if ("pareja".equalsIgnoreCase(modoEquipo) && companeroDoc != null && !companeroDoc.trim().isEmpty()) {
                String compCompleto = (companeroNombre != null && !companeroNombre.trim().isEmpty()) 
                    ? companeroNombre.trim() + " (Doc: " + companeroDoc.trim() + ")" 
                    : "Compañero (Doc: " + companeroDoc.trim() + ")";
                p.setCompaneroNombre(compCompleto);
                if (companeroIdStr != null && !companeroIdStr.trim().isEmpty()) {
                    try {
                        p.setCompaneroId(Integer.parseInt(companeroIdStr.trim()));
                    } catch (Exception ignored) {}
                }
            } else {
                p.setCompaneroNombre(null);
                p.setCompaneroId(null);
            }

            if (selectedIdeaId != null && !selectedIdeaId.trim().isEmpty() && !"0".equals(selectedIdeaId)) {
                try {
                    int selId = Integer.parseInt(selectedIdeaId.trim());
                    p.setIdeaBancoId(selId);
                    BancoIdea bi = MockDataStore.IDEAS.get(selId);
                    if (bi != null) {
                        bi.setEstado("ASIGNADA");
                    }
                } catch (Exception ignored) {}
            }

            Timestamp ahora = new Timestamp(System.currentTimeMillis());
            p.setFechaPago(ahora);
            p.setUpdatedAt(ahora);

            MockDataStore.PROYECTOS.put(1, p);

            // Registrar en historial de versiones (RF-EST-04, RF-EST-10)
            int newHistId = MockDataStore.nextHistorialId();
            HistorialVersion hv = new HistorialVersion(1, Proyecto.FASE_1, urlPago != null ? urlPago.trim() : "", miUsuarioId, "Comprobante de derechos pecuniarios del semestre (Google Drive).");
            hv.setId(newHistId);
            hv.setSubidoPorNombre((String) session.getAttribute("nombre"));
            hv.setFechaSubida(ahora);
            MockDataStore.HISTORIAL.add(hv);

            msg = "¡Proyecto radicado exitosamente! Tu expediente GRA-00001 ha sido formalizado en Fase 1 con soporte de pago en la nube. Se ha generado la confirmación oficial y el turno de evaluación pasó al Comité de Trabajos de Grado.";
        } else if ("entregar_fase".equalsIgnoreCase(reqAction)) {
            String urlDoc = request.getParameter("url_documento");
            String obs = request.getParameter("observaciones");
            int faseEntrega = Integer.parseInt(request.getParameter("fase_entrega"));

            if (urlDoc != null && !urlDoc.trim().isEmpty()) {
                if (faseEntrega == 2) {
                    p.setUrlAnteproyecto(urlDoc.trim());
                    p.setResponsableTurno("director");
                    msg = "¡Anteproyecto entregado exitosamente! El turno pasó a tu Director Docente.";
                } else if (faseEntrega == 4) {
                    p.setUrlInformeFinal(urlDoc.trim());
                    p.setResponsableTurno("director");
                    msg = "¡Informe de desarrollo entregado exitosamente! El turno pasó a tu Director Docente.";
                }

                int newHistId = MockDataStore.nextHistorialId();
                HistorialVersion hv = new HistorialVersion(1, "FASE_" + faseEntrega, urlDoc.trim(), miUsuarioId, obs != null ? obs : "Entrega de documento");
                hv.setId(newHistId);
                hv.setSubidoPorNombre((String) session.getAttribute("nombre"));
                hv.setFechaSubida(new Timestamp(System.currentTimeMillis()));
                MockDataStore.HISTORIAL.add(hv);
            }
        }
    }

    boolean abrirFormulario = "iniciar_radicacion".equalsIgnoreCase(reqAction) 
        || "true".equalsIgnoreCase(request.getParameter("nueva_radicacion"))
        || ideaPrecargada != null
        || (p != null && p.getFase() == 1 && "estudiante".equalsIgnoreCase(p.getResponsableTurno()));

    request.setAttribute("proyecto", p);
    request.setAttribute("msg", msg);
    request.setAttribute("abrirFormulario", abrirFormulario);
%>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Mi Proyecto de Grado - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="proyecto" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-EST-01 a RF-EST-04</span>
                <h2>Mi Proyecto de Trabajo de Grado</h2>
                <p>Expediente Institucional: <strong>GRA-0000${proyecto.id}</strong> • Periodo Académico: 2026-2</p>
            </div>
            <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                <button type="button" class="btn btn-secondary" onclick="toggleRadicacion()">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                    <span>Formulario de Radicación</span>
                </button>
                <span class="status-chip ${proyecto.estado == 'En curso' ? 'chip-approved' : 'chip-neutral'}">
                    Estado: <c:out value="${proyecto.estado}" />
                </span>
            </div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success" style="margin-bottom: 22px;">
                <span style="font-size: 1.2rem;">✔️</span>
                <div><c:out value="${msg}" /></div>
            </div>
        </c:if>

        <!-- ========================================================================= -->
        <!-- FORMULARIO DE RADICACIÓN DE TRABAJO DE GRADO (RF-EST-01, 02, 03, 04)      -->
        <!-- ========================================================================= -->
        <div id="boxFormRadicacion" class="uts-card" style="margin-bottom: 26px; border: 2px solid rgba(0, 104, 55, 0.35); background: #ffffff; box-shadow: 0 4px 14px rgba(0,0,0,0.06); display: none;">
        <c:if test="${abrirFormulario}">
            <script>document.getElementById('boxFormRadicacion').style.display = 'block';</script>
        </c:if>
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 18px; border-bottom: 1px solid #e2e8f0; padding-bottom: 14px;">
                <div>
                    <span class="badge-tag" style="background: rgba(0, 104, 55, 0.1); color: #006837; border-color: rgba(0, 104, 55, 0.25);">
                        Fase 1 · Formalización de Matrícula
                    </span>
                    <h3 style="margin: 8px 0 4px; color: #006837; font-size: 1.3rem; font-weight: 800;">
                        Formulario de Radicación de Trabajo de Grado
                    </h3>
                    <p style="margin: 0; font-size: 0.88rem; color: #475569;">
                        Inscribe tu propuesta individual o en pareja (RF-EST-03) y adjunta la URL en la nube del comprobante de derechos pecuniarios (RF-EST-04).
                    </p>
                </div>
                <button type="button" class="btn btn-sm btn-secondary" onclick="toggleRadicacion()">Cerrar</button>
            </div>

            <form action="${pageContext.request.contextPath}/estudiante/proyecto.jsp" method="POST" class="uts-form" onsubmit="return validarFormularioRadicacion();">
                <input type="hidden" name="action" value="radicar" />
                <input type="hidden" name="modo_equipo" id="modoEquipoInput" value="individual" />
                <input type="hidden" name="companero_nombre" id="companeroNombreHidden" value="" />
                <input type="hidden" name="companero_id" id="companeroIdHidden" value="" />

                <!-- SELECCIÓN DE IDEA (RF-EST-01, RF-EST-02) -->
                <div style="margin-bottom: 20px; padding: 14px 18px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;">
                    <label for="selectIdeaBanco" style="font-weight: 700; color: #0f172a; margin-bottom: 6px; display: block;">
                        💡 Selección de Propuesta de Grado (RF-EST-01, RF-EST-02):
                    </label>
                    <select id="selectIdeaBanco" name="idea_id" class="form-control" onchange="alCambiarIdea(this)" style="font-size: 0.92rem; font-weight: 600;">
                        <option value="0" data-titulo="" data-linea="Ingeniería de Software" data-desc="">
                            -- Proponer Tema Libre Propio (RF-EST-02) --
                        </option>
                        <c:forEach var="idea" items="${ideasBanco}">
                            <option value="${idea.id}" 
                                    data-titulo="<c:out value='${idea.titulo}' />" 
                                    data-linea="<c:out value='${idea.lineaInvestigacion}' />" 
                                    data-desc="<c:out value='${idea.descripcion}' />"
                                    ${ideaPrecargada != null && ideaPrecargada.id == idea.id ? 'selected' : ''}>
                                [BAN-0000${idea.id}] <c:out value="${idea.titulo}" /> (<c:out value="${idea.lineaInvestigacion}" />)
                            </option>
                        </c:forEach>
                    </select>
                    <small style="color: #64748b; display: block; margin-top: 5px;">
                        Al elegir una propuesta del Banco de Ideas UTS, el título, línea y objetivo se cargarán automáticamente.
                    </small>
                </div>

                <!-- TÍTULO DEL PROYECTO -->
                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="tituloProyecto" style="font-weight: 700;">Título Oficial de la Propuesta de Grado:</label>
                    <input type="text" id="tituloProyecto" name="titulo" required class="form-control" 
                           value="${ideaPrecargada != null ? ideaPrecargada.titulo : (proyecto != null ? proyecto.titulo : '')}" 
                           placeholder="ej. Plataforma Web para la Gestión y Monitoreo Ambiental en Bucaramanga" />
                </div>

                <!-- NIVEL, MODALIDAD Y LÍNEA -->
                <div class="form-grid" style="margin-bottom: 16px;">
                    <div class="form-group">
                        <label for="tipoNivel" style="font-weight: 700;">Nivel Académico UTS:</label>
                        <select id="tipoNivel" name="tipo_nivel" class="form-control">
                            <option value="Tecnologico" ${proyecto.tipoNivel == 'Tecnologico' ? 'selected' : ''}>Tecnología (Código inicial 65)</option>
                            <option value="Profesional" ${proyecto.tipoNivel == 'Profesional' ? 'selected' : ''}>Profesional Universitario (Código inicial 125)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tipoModalidad" style="font-weight: 700;">Modalidad de Grado:</label>
                        <select id="tipoModalidad" name="tipo_modalidad" class="form-control">
                            <option value="Desarrollo tecnologico" ${proyecto.modalidad == 'Desarrollo tecnologico' ? 'selected' : ''}>Desarrollo Tecnológico</option>
                            <option value="Investigacion" ${proyecto.modalidad == 'Investigacion' ? 'selected' : ''}>Investigación</option>
                            <option value="Emprendimiento" ${proyecto.modalidad == 'Emprendimiento' ? 'selected' : ''}>Emprendimiento</option>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="lineaInvestigacion" style="font-weight: 700;">Línea de Investigación:</label>
                    <input type="text" id="lineaInvestigacion" name="linea_investigacion" required class="form-control" 
                           value="${ideaPrecargada != null ? ideaPrecargada.lineaInvestigacion : (proyecto != null ? proyecto.lineaInvestigacion : 'Ingeniería de Software')}" />
                </div>

                <!-- OBJETIVO GENERAL Y ALCANCE -->
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="objetivoGeneral" style="font-weight: 700;">Objetivo General y Alcance Metodológico:</label>
                    <textarea id="objetivoGeneral" name="objetivo_general" rows="3" required class="form-control" 
                              placeholder="Describe el alcance técnico, solución propuesta y población beneficiaria...">${ideaPrecargada != null ? ideaPrecargada.descripcion : (proyecto != null ? proyecto.objetivo : '')}</textarea>
                </div>

                <!-- ============================================================== -->
                <!-- CONFORMACIÓN DE EQUIPO: INDIVIDUAL O EN PAREJA (RF-EST-03)      -->
                <!-- ============================================================== -->
                <div style="margin-bottom: 22px; padding: 16px 20px; background: #f0fdf4; border: 1px solid rgba(22, 163, 74, 0.3); border-radius: 10px;">
                    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
                        <div>
                            <span class="badge-tag" style="background: rgba(22, 163, 74, 0.15); color: #15803d; border-color: rgba(22, 163, 74, 0.3);">RF-EST-03</span>
                            <h4 style="margin: 4px 0 2px; color: #14532d; font-weight: 700;">Modalidad de Inscripción Estudiantil</h4>
                            <p style="margin: 0; font-size: 0.84rem; color: #166534;">
                                El estudiante líder puede inscribir el proyecto de forma individual o en pareja reglamentaria (máximo 2 estudiantes).
                            </p>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px; background: #ffffff; padding: 8px 14px; border-radius: 8px; border: 1px solid #bbf7d0;">
                            <input type="checkbox" id="checkPareja" onchange="togglePareja(this.checked)" style="width: 18px; height: 18px; accent-color: #006837; cursor: pointer;" />
                            <label for="checkPareja" style="margin: 0; font-weight: 700; color: #0f172a; cursor: pointer; font-size: 0.92rem;">
                                Inscribir en Pareja (2 Integrantes)
                            </label>
                        </div>
                    </div>

                    <!-- SECCIÓN DESPLEGABLE CON COMBOBOX PARA SEGUNDO INTEGRANTE -->
                    <div id="boxSegundoIntegrante" style="display: none; margin-top: 16px; padding-top: 14px; border-top: 1px dashed #86efac;">
                        <label for="companeroSelect" style="font-weight: 700; color: #14532d; display: block; margin-bottom: 6px;">
                            Seleccionar Segundo Integrante (ComboBox con Validación de Documento):
                        </label>
                        <select id="companeroSelect" name="companero_doc" class="form-control" onchange="alSeleccionarCompanero(this)" style="font-size: 0.92rem;">
                            <option value="">-- Seleccione estudiante por Número de Documento o Nombre --</option>
                            <% for (Usuario comp : companerosDisponibles) { %>
                                <option value="<%= comp.getDocumento() %>" 
                                        data-nombre="<%= comp.getNombreCompleto() %>" 
                                        data-id="<%= comp.getId() %>" 
                                        data-correo="<%= comp.getCorreo() %>">
                                    [Doc: <%= comp.getDocumento() %>] <%= comp.getNombreCompleto() %> — <%= comp.getCorreo() %>
                                </option>
                            <% } %>
                        </select>

                        <!-- TARJETA DE VALIDACIÓN EN TIEMPO REAL -->
                        <div id="cardCompaneroValidado" style="display: none; margin-top: 12px; background: #ffffff; border: 1px solid #22c55e; border-radius: 8px; padding: 10px 14px; font-size: 0.85rem; color: #14532d; display: flex; align-items: center; gap: 10px;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <div>
                                <strong>Estudiante Compañero Validado:</strong> <span id="spanCompNombre"></span> · 
                                <strong>C.C.:</strong> <span id="spanCompDoc" style="font-family: monospace; font-weight: 700;"></span> · 
                                <span class="status-chip chip-approved" style="padding: 2px 8px; font-size: 0.75rem;">Matrícula Activa UTS</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ============================================================== -->
                <!-- SOPORTE DE PAGO DE DERECHOS PECUNIARIOS EN LA NUBE (RF-EST-04)   -->
                <!-- ============================================================== -->
                <div style="margin-bottom: 24px; padding: 16px 20px; background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 10px;">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                        <span class="badge-tag" style="background: rgba(37, 99, 235, 0.1); color: #1d4ed8; border-color: rgba(37, 99, 235, 0.25);">RF-EST-04</span>
                        <h4 style="margin: 0; color: #0f172a; font-weight: 700;">URL Comprobante de Pago de Derechos Pecuniarios</h4>
                    </div>
                    <label for="urlPagoInput" style="font-weight: 700; color: #334155; display: block; margin-bottom: 6px;">
                        Enlace HTTPS en la Nube (Google Drive / OneDrive con permisos de lectura para el Comité):
                    </label>
                    <input type="url" id="urlPagoInput" name="url_pago" required class="form-control" 
                           value="${proyecto != null && proyecto.urlPago != null ? proyecto.urlPago : 'https://drive.google.com/file/d/1A2B3C4D_recibo_pago_uts_2026/view?usp=sharing'}" 
                           placeholder="https://drive.google.com/file/d/.../view?usp=sharing" />
                    
                    <div style="margin-top: 10px; font-size: 0.82rem; color: #475569; display: flex; align-items: flex-start; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#006837" stroke-width="2" style="flex-shrink: 0;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        <span>
                            <strong>Reglamentación UTS:</strong> Conforme al Acuerdo Institucional y la directriz de seguridad en la nube (RF-EST-04), cargue su soporte digital en Google Drive o OneDrive en modo "Cualquier persona con el enlace puede ver" y registre aquí la URL HTTPS.
                        </span>
                    </div>
                </div>

                <!-- BOTONES DE ENVÍO -->
                <div style="display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid #e2e8f0; padding-top: 16px;">
                    <button type="button" class="btn btn-secondary" onclick="toggleRadicacion()">Cancelar</button>
                    <button type="submit" class="btn btn-primary" style="padding: 12px 28px; font-weight: 700; font-size: 0.98rem;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>Formalizar Radicación y Pasar Turno a Comité</span>
                    </button>
                </div>
            </form>
        </div>

        <!-- ========================================================================= -->
        <!-- BANNER DE TURNO Y FASE ACTUAL                                             -->
        <!-- ========================================================================= -->
        <div class="uts-card" style="border-left: 5px solid #006837; background: rgba(0, 104, 55, 0.04); margin-bottom: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 14px;">
                <div>
                    <span class="badge-tag" style="background: rgba(0, 104, 55, 0.12); color: #006837; border-color: rgba(0, 104, 55, 0.25);">
                        Turno de Acción Oficial
                    </span>
                    <h3 style="margin: 6px 0 4px; color: #0f172a; font-weight: 800;">
                        Fase ${proyecto.fase} · Responsable: <span style="text-transform: capitalize; color: #006837; font-weight: 800;"><c:out value="${proyecto.responsableTurno}" /></span>
                    </h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem; margin: 0;">
                        <c:choose>
                            <c:when test="${proyecto.responsableTurno == 'estudiante'}">
                                🔔 Tienes el turno activo para radicar entregables documentales o subsanar observaciones de la fase.
                            </c:when>
                            <c:when test="${proyecto.responsableTurno == 'comite'}">
                                ⏳ Tu propuesta formalizada se encuentra en revisión con el Comité de Trabajos de Grado (Fase 1). Se emitirá dictamen con asignación de Director y Evaluador.
                            </c:when>
                            <c:otherwise>
                                ⏳ Tu solicitud se encuentra en evaluación con <span style="text-transform: capitalize; font-weight: 700;"><c:out value="${proyecto.responsableTurno}" /></span>. Recibirás notificación del dictamen.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/estudiante/seguimiento.jsp" class="btn btn-secondary">
                        <span>Ver Mapa de 6 Fases</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/estudiante/versiones.jsp" class="btn btn-primary">
                        <span>Historial de Versiones</span>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>
            </div>
        </div>

        <!-- ========================================================================= -->
        <!-- DETALLE DEL PROYECTO & DOCENTES ASIGNADOS                                  -->
        <!-- ========================================================================= -->
        <div class="form-grid">
            <div class="uts-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                    <h3 style="margin: 0; font-size: 1.15rem; color: #0f172a;">Ficha Técnica del Proyecto</h3>
                    <span class="badge-tag">Fase ${proyecto.fase}</span>
                </div>
                <div style="margin-top: 14px; font-size: 0.92rem; line-height: 1.7;">
                    <div><strong style="color: #0f172a;">Título:</strong> <c:out value="${proyecto.titulo}" /></div>
                    <div style="margin-top: 6px;">
                        <strong style="color: #0f172a;">Código Modalidad:</strong> 
                        <span style="font-family: 'JetBrains Mono', monospace; color: #006837; font-weight: 700; background: #e8f5e9; padding: 2px 8px; border-radius: 4px;">
                            <c:out value="${proyecto.codigoModalidad != null ? proyecto.codigoModalidad : 'Se genera en aprobación de Fase 1 (ej. 65 o 125)'}" />
                        </span>
                    </div>
                    <div style="margin-top: 6px;"><strong style="color: #0f172a;">Nivel / Modalidad:</strong> <c:out value="${proyecto.tipoNivel}" /> • <c:out value="${proyecto.modalidad}" /></div>
                    <div style="margin-top: 6px;"><strong style="color: #0f172a;">Línea de Investigación:</strong> <c:out value="${proyecto.lineaInvestigacion}" /></div>
                    <div style="margin-top: 6px;"><strong style="color: #0f172a;">Objetivo General:</strong> <c:out value="${proyecto.objetivo}" /></div>
                </div>
            </div>

            <!-- EQUIPO ESTUDIANTIL Y ASESORÍA DOCENTE -->
            <div class="uts-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                    <h3 style="margin: 0; font-size: 1.15rem; color: #0f172a;">Equipo y Asesoría Docente</h3>
                    <span class="badge-tag">RF-EST-03 / RF-EST-04</span>
                </div>
                <div style="margin-top: 14px; font-size: 0.92rem; line-height: 1.7;">
                    <div>
                        <strong style="color: #0f172a;">Integrante 1 (Líder):</strong> 
                        <c:out value="${proyecto.estudianteNombre != null ? proyecto.estudianteNombre : sessionScope.nombre}" /> 
                        <span style="color: #64748b; font-size: 0.85rem;">[Doc: <c:out value="${proyecto.estudianteDocumento != null ? proyecto.estudianteDocumento : sessionScope.documento}" />]</span>
                    </div>
                    
                    <div style="margin-top: 6px;">
                        <strong style="color: #0f172a;">Integrante 2:</strong> 
                        <c:choose>
                            <c:when test="${not empty proyecto.companeroNombre}">
                                <c:out value="${proyecto.companeroNombre}" /> 
                                <span class="status-chip chip-approved" style="padding: 2px 6px; font-size: 0.72rem; margin-left: 6px;">Vinculado</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #64748b; font-style: italic;">Modalidad Individual (Sin segundo integrante)</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="margin-top: 8px; padding-top: 8px; border-top: 1px solid #f1f5f9;">
                        <strong style="color: #0f172a;">Comprobante de Pago (RF-EST-04):</strong> 
                        <c:choose>
                            <c:when test="${not empty proyecto.urlPago}">
                                <a href="<c:out value='${proyecto.urlPago}' />" target="_blank" rel="noopener noreferrer" style="color: #006837; font-weight: 700; text-decoration: underline; display: inline-flex; align-items: center; gap: 4px; margin-left: 4px;">
                                    <span>Ver Soporte en Google Drive</span>
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #94a3b8;">No registrado</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="margin-top: 12px; border-top: 1px solid #e2e8f0; padding-top: 10px;">
                        <div><strong style="color: #0f172a;">Director Docente:</strong> <c:out value="${proyecto.directorNombre != null ? proyecto.directorNombre : 'Pendiente de asignación por Comité (Fase 1)'}" /></div>
                        <div style="margin-top: 6px;"><strong style="color: #0f172a;">Codirector Docente:</strong> <c:out value="${proyecto.codirectorNombre != null ? proyecto.codirectorNombre : 'Ninguno asignado'}" /></div>
                        
                        <!-- RNF-04: Evaluador anónimo para el estudiante -->
                        <div style="margin-top: 8px; color: #64748b; font-size: 0.8rem; font-style: italic; background: #f8fafc; padding: 6px 10px; border-radius: 6px; border-left: 3px solid #cbd5e1;">
                            🔒 <strong>Confidencialidad UTS (RNF-04):</strong> La identidad del Evaluador docente permanece anónima para el estudiante para garantizar la imparcialidad del dictamen.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========================================================================= -->
        <!-- FORMULARIO DE ENTREGA PARA EL ESTUDIANTE (FASE 2 O FASE 4)                 -->
        <!-- ========================================================================= -->
        <c:if test="${proyecto.responsableTurno == 'estudiante' && (proyecto.fase == 2 || proyecto.fase == 4)}">
            <div class="uts-card" style="margin-top: 24px; border-color: rgba(34, 197, 94, 0.4);">
                <h3>Radicar Entregable Documental - Fase ${proyecto.fase}</h3>
                <p style="color: var(--text-muted); font-size: 0.88rem; margin-bottom: 18px;">
                    Registra la URL pública o institucional (HTTPS) con permisos de lectura para el cuerpo docente (RF-GEN-05).
                </p>

                <form action="${pageContext.request.contextPath}/estudiante/proyecto.jsp" method="POST" class="uts-form">
                    <input type="hidden" name="action" value="entregar_fase" />
                    <input type="hidden" name="fase_entrega" value="${proyecto.fase}" />

                    <div class="form-group">
                        <label for="urlEntrega">URL del Documento en la Nube (Google Drive / OneDrive / Docs - HTTPS):</label>
                        <input type="url" id="urlEntrega" name="url_documento" required placeholder="https://docs.google.com/document/d/..." class="form-control" />
                    </div>

                    <div class="form-group" style="margin-top: 14px;">
                        <label for="obsEntrega">Notas u Observaciones para el Director:</label>
                        <textarea id="obsEntrega" name="observaciones" rows="2" placeholder="Resumen de avances o cambios atendidos respecto a la versión anterior..." class="form-control"></textarea>
                    </div>

                    <div style="margin-top: 20px; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary">
                            <span>Enviar Entregable al Director</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

    </div>
</main>

<script>
function toggleRadicacion() {
    var box = document.getElementById('boxFormRadicacion');
    if (box.style.display === 'none' || box.style.display === '') {
        box.style.display = 'block';
        box.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
        box.style.display = 'none';
    }
}

function alCambiarIdea(select) {
    var option = select.options[select.selectedIndex];
    var titulo = option.getAttribute("data-titulo");
    var linea = option.getAttribute("data-linea");
    var desc = option.getAttribute("data-desc");

    if (titulo && titulo.trim() !== "") {
        document.getElementById("tituloProyecto").value = titulo;
    }
    if (linea && linea.trim() !== "") {
        document.getElementById("lineaInvestigacion").value = linea;
    }
    if (desc && desc.trim() !== "") {
        document.getElementById("objetivoGeneral").value = desc;
    }
}

function togglePareja(activado) {
    var box = document.getElementById("boxSegundoIntegrante");
    var modoInput = document.getElementById("modoEquipoInput");
    var compSelect = document.getElementById("companeroSelect");
    var valCard = document.getElementById("cardCompaneroValidado");

    if (activado) {
        box.style.display = "block";
        modoInput.value = "pareja";
        alSeleccionarCompanero(compSelect);
    } else {
        box.style.display = "none";
        modoInput.value = "individual";
        compSelect.value = "";
        document.getElementById("companeroNombreHidden").value = "";
        document.getElementById("companeroIdHidden").value = "";
        if (valCard) valCard.style.display = "none";
    }
}

function alSeleccionarCompanero(select) {
    var valCard = document.getElementById("cardCompaneroValidado");
    var nomHidden = document.getElementById("companeroNombreHidden");
    var idHidden = document.getElementById("companeroIdHidden");

    if (!select || select.value === "") {
        nomHidden.value = "";
        idHidden.value = "";
        if (valCard) valCard.style.display = "none";
        return;
    }

    var opt = select.options[select.selectedIndex];
    var nombre = opt.getAttribute("data-nombre");
    var id = opt.getAttribute("data-id");
    var doc = select.value;

    nomHidden.value = nombre || "";
    idHidden.value = id || "";

    if (valCard) {
        valCard.style.display = "flex";
        document.getElementById("spanCompNombre").textContent = nombre || "Estudiante UTS";
        document.getElementById("spanCompDoc").textContent = doc || "";
    }
}

function validarFormularioRadicacion() {
    var urlPago = document.getElementById("urlPagoInput").value.trim();
    if (!urlPago.toLowerCase().startsWith("https://")) {
        alert("La URL del comprobante de derechos pecuniarios debe ser un enlace seguro que comience con 'https://' (Google Drive / OneDrive).");
        document.getElementById("urlPagoInput").focus();
        return false;
    }

    var checkPareja = document.getElementById("checkPareja").checked;
    if (checkPareja) {
        var compSelect = document.getElementById("companeroSelect");
        if (!compSelect.value || compSelect.value.trim() === "") {
            alert("Has seleccionado la modalidad en pareja. Por favor selecciona a tu compañero en el ComboBox para validar su documento.");
            compSelect.focus();
            return false;
        }
    }

    return true;
}

// Inicialización al cargar la página
window.addEventListener("DOMContentLoaded", function() {
    var compInicial = "${proyecto.companeroNombre}";
    if (compInicial && compInicial.trim() !== "") {
        var check = document.getElementById("checkPareja");
        if (check) {
            check.checked = true;
            togglePareja(true);
        }
    }

    var autoAbrir = "${abrirFormulario}" === "true";
    if (autoAbrir) {
        var box = document.getElementById('boxFormRadicacion');
        if (box) {
            box.style.display = 'block';
            setTimeout(function() {
                box.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }, 200);
        }
    }
});
</script>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />
