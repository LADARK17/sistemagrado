<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<!-- HERO BANNER ADMINISTRACIÓN -->
<div class="section-hero">
    <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px;">
        <div>
            <span class="hero-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                <span>Módulo de Control de Acceso</span>
            </span>
            <h1 class="hero-title">Gestión Institucional de Usuarios</h1>
            <p class="hero-desc">
                Administración de credenciales, roles y estados de actividad para Estudiantes, Docentes y Directivos de las Unidades Tecnológicas de Santander.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/nuevo" class="btn btn-warning">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            <span>Crear Nuevo Usuario</span>
        </a>
    </div>
</div>

<div class="uts-card">
    <div class="uts-card-header" style="flex-wrap: wrap; gap: 14px;">
        <div>
            <h2>Cuentas Registradas en Plataforma</h2>
            <p style="color: var(--text-muted); font-size: 0.88rem;">
                Control de roles oficiales: Administrador, Coordinación, Director, Evaluador y Estudiante.
            </p>
        </div>
        <div style="position: relative; min-width: 300px;">
            <input type="text" id="filtroUsuarios" onkeyup="filtrarUsuarios()" class="form-control" 
                   placeholder="Buscar por nombre, documento o correo..." 
                   style="padding-left: 36px; height: 40px; font-size: 0.9rem;" />
            <svg style="position: absolute; left: 12px; top: 12px; width: 16px; height: 16px; color: #64748b;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table" id="tablaUsuarios">
            <thead>
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th>Documento</th>
                    <th>Nombre Completo</th>
                    <th>Correo Institucional</th>
                    <th>Rol Oficial</th>
                    <th>Estado</th>
                    <th style="text-align: right;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${usuarios}">
                    <tr class="fila-usuario">
                        <td><strong>#<c:out value="${u.id}" /></strong></td>
                        <td style="font-weight: 600;"><c:out value="${u.documento}" /></td>
                        <td style="font-weight: 700; color: #1e293b;"><c:out value="${u.nombreCompleto}" /></td>
                        <td style="color: var(--text-muted);"><c:out value="${u.correo}" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.rol == 'Administrador'}"><span class="badge" style="background: #fef2f2; color: #991b1b; border: 1px solid #fecaca;"><c:out value="${u.rol}" /></span></c:when>
                                <c:when test="${u.rol == 'Coordinación'}"><span class="badge" style="background: #fffbeb; color: #b45309; border: 1px solid #fde68a;"><c:out value="${u.rol}" /></span></c:when>
                                <c:when test="${u.rol == 'Director'}"><span class="badge" style="background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0;"><c:out value="${u.rol}" /></span></c:when>
                                <c:when test="${u.rol == 'Evaluador'}"><span class="badge" style="background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe;"><c:out value="${u.rol}" /></span></c:when>
                                <c:otherwise><span class="badge" style="background: #f8fafc; color: #475569; border: 1px solid #e2e8f0;"><c:out value="${u.rol}" /></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.estadoActivo}">
                                    <span style="color: #059669; font-weight: 700; font-size: 0.82rem; display: inline-flex; align-items: center; gap: 5px;">
                                        <span style="width: 7px; height: 7px; border-radius: 50%; background: #10b981;"></span>
                                        <span>Activo</span>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #dc2626; font-weight: 700; font-size: 0.82rem; display: inline-flex; align-items: center; gap: 5px;">
                                        <span style="width: 7px; height: 7px; border-radius: 50%; background: #ef4444;"></span>
                                        <span>Inactivo</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: inline-flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/admin/editar?id=${u.id}" class="btn btn-secondary btn-sm" title="Editar datos">
                                    Editar
                                </a>
                                <c:if test="${u.estadoActivo}">
                                    <a href="${pageContext.request.contextPath}/admin/inactivar?id=${u.id}" class="btn btn-warning btn-sm" onclick="return confirm('¿Desea inactivar a este usuario?');" title="Inactivar usuario">
                                        Inactivar
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/admin/eliminar?id=${u.id}" class="btn btn-danger btn-sm" onclick="return confirm('¿Desea eliminar este usuario? (Solo procederá si no tiene proyectos asociados)');" title="Eliminar usuario">
                                    Eliminar
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
function filtrarUsuarios() {
    var query = document.getElementById("filtroUsuarios").value.toLowerCase().trim();
    var filas = document.querySelectorAll(".fila-usuario");
    filas.forEach(function(fila) {
        var texto = fila.innerText.toLowerCase();
        if (texto.indexOf(query) !== -1) {
            fila.style.display = "";
        } else {
            fila.style.display = "none";
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
