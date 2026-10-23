<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<!-- HERO BANNER INSTITUCIONAL -->
<div class="section-hero">
    <span class="hero-pill">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
        <span>Innovación & Investigación UTS</span>
    </span>
    <h1 class="hero-title">Banco Oficial de Ideas de Grado</h1>
    <p class="hero-desc">
        Catálogo de proyectos formulados por los grupos de investigación de las Unidades Tecnológicas de Santander.
        Al elegir una propuesta disponible, aseguras su pertinencia y facilitas tu radicación.
    </p>

    <div style="margin-top: 22px; display: flex; flex-wrap: wrap; gap: 12px; align-items: center;">
        <div style="position: relative; flex: 1; max-width: 440px;">
            <input type="text" id="filtroIdeas" onkeyup="filtrarIdeas()" class="form-control" 
                   placeholder="Buscar por palabra clave o línea (ej. IoT, Software, Ambiental)..."
                   style="padding-left: 40px; background: rgba(255, 255, 255, 0.95); border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15);" />
            <svg style="position: absolute; left: 14px; top: 13px; width: 18px; height: 18px; color: #64748b;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        </div>
        <a href="${pageContext.request.contextPath}/estudiante/radicar" class="btn btn-warning">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            <span>Radicar Propuesta Propia</span>
        </a>
    </div>
</div>

<!-- GRID DE IDEAS DISPONIBLES -->
<div class="idea-grid" id="gridIdeas">
    <c:choose>
        <c:when test="${empty ideas}">
            <div class="uts-card" style="grid-column: 1 / -1; text-align: center; padding: 50px;">
                <svg width="48" height="48" style="color: var(--uts-gold-500); margin-bottom: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <h3 style="margin-bottom: 6px;">No hay ideas disponibles actualmente</h3>
                <p style="color: var(--text-muted); margin-bottom: 20px;">Todas las propuestas han sido asignadas o están en proceso. Puedes radicar tu propio tema de investigación.</p>
                <a href="${pageContext.request.contextPath}/estudiante/radicar" class="btn btn-primary">Formular Propuesta Libre</a>
            </div>
        </c:when>

        <c:otherwise>
            <c:forEach var="idea" items="${ideas}">
                <div class="idea-card item-idea" data-texto="<c:out value='${idea.titulo} ${idea.lineaInvestigacion} ${idea.descripcion}' />">
                    <div>
                        <div class="idea-tag">
                            <span class="idea-tag-dot"></span>
                            <span><c:out value="${idea.lineaInvestigacion}" /></span>
                        </div>
                        <h3 class="idea-title"><c:out value="${idea.titulo}" /></h3>
                        <p class="idea-description"><c:out value="${idea.descripcion}" /></p>
                    </div>

                    <div class="idea-footer">
                        <div class="idea-author" title="Docente Proponente">
                            <div class="idea-author-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </div>
                            <span><c:out value="${idea.creadoPorNombre}" /></span>
                        </div>

                        <a href="${pageContext.request.contextPath}/estudiante/radicar?ideaId=${idea.id}" class="btn btn-primary btn-sm">
                            <span>Postularme</span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
function filtrarIdeas() {
    var query = document.getElementById("filtroIdeas").value.toLowerCase().trim();
    var cards = document.querySelectorAll(".item-idea");
    cards.forEach(function(card) {
        var texto = card.getAttribute("data-texto").toLowerCase();
        if (texto.indexOf(query) !== -1) {
            card.style.display = "flex";
        } else {
            card.style.display = "none";
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
