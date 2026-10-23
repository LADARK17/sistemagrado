<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="uts-card" style="max-width: 650px; margin: 0 auto;">
    <div class="uts-card-header">
        <div>
            <h2>Carga de Versión Corregida</h2>
            <p style="color: var(--uts-text-muted); font-size: 0.9rem;">
                Subsanación de observaciones tras concepto de Aplazado.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/estudiante/dashboard" class="btn btn-secondary btn-sm">Volver</a>
    </div>

    <form action="${pageContext.request.contextPath}/estudiante/subir-correccion" method="POST" onsubmit="return validarUrlHttps(document.getElementById('urlCorreccion'));">
        <input type="hidden" name="proyectoId" value="${param.proyectoId}" />

        <div class="form-group">
            <label for="urlCorreccion">Nueva URL del Documento en la Nube (Google Drive / OneDrive):</label>
            <input type="url" id="urlCorreccion" name="urlCorreccion" required class="form-control"
                   placeholder="https://drive.google.com/file/d/.../view?usp=sharing" />
            <small style="color: var(--uts-text-muted);">
                Verifique que el enlace cuente con permisos de lectura activos para que los docentes puedan evaluarlo.
            </small>
        </div>

        <div class="form-group">
            <label for="observaciones">Resumen de Ajustes Realizados:</label>
            <textarea id="observaciones" name="observaciones" rows="4" required class="form-control"
                      placeholder="Explique punto por punto cómo se atendieron las sugerencias del dictamen anterior..."></textarea>
        </div>

        <div style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px;">
            <a href="${pageContext.request.contextPath}/estudiante/dashboard" class="btn btn-secondary">Cancelar</a>
            <button type="submit" class="btn btn-warning">Enviar Corrección a Evaluación</button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />
