<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
            </div><!-- FIN UTS-CONTAINER -->
        </main><!-- FIN UTS-MAIN-CONTENT -->

        <footer class="uts-footer">
            <p>&copy; 2026 Unidades Tecnológicas de Santander (UTS) – Sistema Oficial de Gestión de Trabajos de Grado</p>
            <p style="font-size: 0.78rem; color: var(--text-muted); margin-top: 3px;">
                Desarrollado bajo arquitectura MVC Java (JSP / JSTL / Supabase PostgreSQL)
            </p>
        </footer>
    </div><!-- FIN MAIN-WRAPPER -->
</div><!-- FIN APP-LAYOUT -->

<!-- MODAL DE SEGURIDAD PARA RECHAZOS (RN06) -->
<div id="modalRechazo" class="modal-overlay">
    <div class="modal-box">
        <h3>Confirmación de Rechazo Institucional</h3>
        <p style="font-size: 0.9rem; color: #475569; margin-bottom: 18px;">
            Esta acción es definitiva y finaliza el ciclo académico del expediente. Debe fundamentar el motivo reglamentario.
        </p>
        <form id="formRechazo" method="POST" onsubmit="return validarFormularioRechazo();">
            <input type="hidden" id="modalProyectoId" name="proyectoId" value="" />
            
            <div class="form-group">
                <label for="motivoRechazo">Justificación Detallada (Mínimo 30 caracteres):</label>
                <textarea id="motivoRechazo" name="motivoRechazo" rows="4" class="form-control" required
                          placeholder="Especifique la causa reglamentaria o inviabilidad metodológica que motiva el rechazo..."></textarea>
            </div>

            <div class="form-group" style="display: flex; gap: 10px; align-items: flex-start;">
                <input type="checkbox" id="confirmacionRechazo" name="confirmacionRechazo" required style="margin-top: 4px;" />
                <label for="confirmacionRechazo" style="font-size: 0.86rem; font-weight: normal; color: #991b1b;">
                    Confirmo que he verificado la documentación y que este dictamen es definitivo e irreversible para este radicado.
                </label>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="cerrarModalRechazo();">Cancelar</button>
                <button type="submit" class="btn btn-danger">Confirmar Rechazo Definitivo</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
