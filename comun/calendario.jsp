<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jspf/guard.jspf" %>
<%@ include file="../WEB-INF/jspf/conexion.jspf" %>

<jsp:include page="../WEB-INF/jspf/header.jsp">
    <jsp:param name="titulo" value="Calendario Académico - SIGRADO UTS" />
</jsp:include>
<jsp:include page="../WEB-INF/jspf/sidebar.jsp">
    <jsp:param name="active" value="calendario" />
</jsp:include>

<main class="app-main-content">
    <jsp:include page="../WEB-INF/jspf/topbar.jsp" />

    <div class="content-body">
        <div class="page-title-row">
            <div>
                <span class="badge-tag">RF-ADM-12 / RF-COM-08 / RF-GEN-11</span>
                <h2>Calendario Académico de Trabajos de Grado</h2>
                <p>Periodo Oficial: <strong>2026-2 (Vigente)</strong> • Fechas límite y ventanas de postulación.</p>
            </div>
            <div>
                <span class="status-chip chip-approved">Periodo Activo</span>
            </div>
        </div>

        <div class="uts-card">
            <div class="table-container">
                <table class="uts-table">
                    <thead>
                        <tr>
                            <th>Fase / Hito Académico</th>
                            <th>Apertura de Ventana</th>
                            <th>Cierre / Límite</th>
                            <th>Estado</th>
                            <th>Restricciones Operativas</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong>Banco de Ideas de Grado</strong>
                                <div style="font-size: 0.8rem; color: var(--text-muted);">Postulación de líneas temáticas por docentes y estudiantes</div>
                            </td>
                            <td>01 de Agosto de 2026</td>
                            <td>15 de Septiembre de 2026</td>
                            <td><span class="status-chip chip-neutral">Concluida</span></td>
                            <td>Solo consulta de catálogo</td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Inscripción y Radicación de Propuestas (Fase 1)</strong>
                                <div style="font-size: 0.8rem; color: var(--text-muted);">Vinculación de soporte de pago y selección de modalidad</div>
                            </td>
                            <td>15 de Agosto de 2026</td>
                            <td>31 de Octubre de 2026</td>
                            <td><span class="status-chip chip-approved">Habilitada</span></td>
                            <td>Permite radicación individual o en pareja</td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Aprobación de Propuestas por Comité de Grado</strong>
                                <div style="font-size: 0.8rem; color: var(--text-muted);">Asignación docente de Director y Evaluador</div>
                            </td>
                            <td>--</td>
                            <td>20 de Noviembre de 2026</td>
                            <td><span class="status-chip chip-pending">Próxima</span></td>
                            <td>Generación de código 65 o 125</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="uts-card" style="margin-top: 24px; background: rgba(22, 163, 74, 0.05); border-color: rgba(22, 163, 74, 0.2);">
            <div style="display: flex; gap: 16px; align-items: flex-start;">
                <div style="color: var(--uts-green-600); font-size: 1.5rem;">ℹ️</div>
                <div>
                    <h4 style="margin-bottom: 6px; color: var(--uts-green-700);">Regla del Calendario (RNF-07)</h4>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin: 0; line-height: 1.5;">
                        Las acciones de radicación de nuevos proyectos e inscripción a ideas del banco respetan estrictamente las fechas límite configuradas por el Administrador. Fuera de las fechas hábiles, el sistema pasa a modo de solo lectura para nuevas iniciativas.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../WEB-INF/jspf/footer.jsp" />

