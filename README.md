# SIGRADO - Sistema de Gestión de Trabajos de Grado (UTS)

Plataforma web institucional para la administración, radicación y seguimiento integral de las 6 fases del ciclo de modalidad de trabajo de grado en el programa de **Ingeniería de Sistemas** de las **Unidades Tecnológicas de Santander (UTS)**.

---

## 🏛️ Identidad y Contexto Institucional
- **Institución:** Unidades Tecnológicas de Santander (UTS)
- **Programa:** Ingeniería de Sistemas
- **Periodo Académico:** 2026-2 (Vigente)
- **Sistema:** SIGRADO v2026.10

---

## 🚀 Características Principales

1. **Ciclo Estructurado en 6 Fases (RNF-01 a RF-GEN-07):**
   - **Fase 1 · Idea y Pago:** Banco de ideas, postulación individual o en pareja con validación de documento de identidad (RF-EST-03) y registro del comprobante de derechos pecuniarios en la nube (Google Drive) (RF-EST-04). Asignación de Director y Evaluador por el Comité.
   - **Fase 2 · Propuesta I (Anteproyecto):** Radicación del documento y reporte Turnitin por el estudiante. Revisión y emisión de concepto por el Director.
   - **Fase 3 · Propuesta II:** Evaluación independiente con dictamen oficial F-DC-124 por el Evaluador y ratificación del Comité.
   - **Fase 4 · Informe I (Desarrollo):** Avances periódicos del desarrollo tecnológico o monografía evaluados por el Director docente.
   - **Fase 5 · Informe II (Calificación):** Calificación final con diligenciamiento del formato oficial F-DC-125 y rejilla evaluativa F-DC-129.
   - **Fase 6 · Cierre y Sustentación:** Programación de fecha, jurados y enlace de sustentación. Acta de sustentación y cierre formal del expediente.

2. **Roles de Usuario Soportados:**
   - 🎓 **Estudiante:** Consulta del Banco de Ideas, radicación de proyecto, consulta de expediente y radicación de entregables en nube.
   - 👨‍🏫 **Director:** Acompañamiento, evaluación de avances y conceptos de fase.
   - ⚖️ **Evaluador:** Revisión ciega/imparcial de propuestas y calificación formal (RNF-04).
   - 🏛️ **Comité de Trabajos de Grado:** Gestión de calendario, aprobación de banco de ideas, asignación de docentes y ratificación de actas.
   - ⚙️ **Administrador del Sistema:** Supervisión global, usuarios y catálogo de formatos.

3. **Arquitectura y Tecnologías:**
   - **Backend:** Java EE / Servlets / JSTL (Java 8 / Java 17).
   - **Frontend:** JSP, CSS3 con diseño responsivo UTS (paleta institucional verde y blanco), JavaScript modular nativo.
   - **Seguridad:** Encriptación bcrypt para credenciales y filtros de sesión (`AuthFilter`).
   - **Base de Datos:** PostgreSQL con soporte de MockDataStore en memoria para entornos de desarrollo y pruebas locales.

---

## 🛠️ Instalación y Puesta en Marcha

1. Clonar o ubicar el proyecto dentro de la carpeta `webapps` de Apache Tomcat:
   ```bash
   git clone https://github.com/LADARK17/sistemagrado.git
   ```
2. Iniciar el servidor Apache Tomcat (versión 9 o 10 con compatibilidad javax.servlet).
3. Acceder en el navegador web a:
   ```text
   http://localhost:8080/Sistema-proyectos/
   ```

---

## 📄 Formatos Institucionales Integrados
- `F-DC-124`: Formato de Evaluación de Propuesta de Trabajo de Grado.
- `F-DC-125`: Formato de Evaluación de Informe Final de Trabajo de Grado.
- `F-DC-129`: Rejilla de Calificación Cualitativa y Cuantitativa.

---
© 2026 Unidades Tecnológicas de Santander · Programa de Ingeniería de Sistemas
