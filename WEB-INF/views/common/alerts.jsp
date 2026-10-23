<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty errorMensaje}">
    <div class="alert alert-danger">
        <span><strong>Error:</strong> <c:out value="${errorMensaje}" /></span>
    </div>
</c:if>

<c:if test="${param.success != null}">
    <div class="alert alert-success">
        <span><strong>Éxito:</strong> Operación ejecutada y registrada correctamente en Supabase.</span>
    </div>
</c:if>

<c:if test="${param.error != null}">
    <div class="alert alert-danger">
        <span><strong>Aviso:</strong> No fue posible completar la acción solicitada (<c:out value="${param.error}" />).</span>
    </div>
</c:if>
