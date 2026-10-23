-- =============================================================================
-- SISTEMA DE GESTIÓN DE TRABAJOS DE GRADO (SIGRADO - UTS)
-- Script Maestro DDL y Datos Semilla para PostgreSQL (Supabase)
-- Proyecto Supabase: https://fkconaghijcwjwnrhwyi.supabase.co
-- Host Pooler: aws-1-us-west-2.pooler.supabase.com:5432
-- =============================================================================

-- 1. ROLES
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO roles (id, nombre) VALUES
    (1, 'administrador'),
    (2, 'comite'),
    (3, 'docente'),
    (4, 'estudiante')
ON CONFLICT (id) DO UPDATE SET nombre = EXCLUDED.nombre;

-- 2. USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    correo VARCHAR(120) UNIQUE NOT NULL,
    documento VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL DEFAULT 'Estudiante',
    estado_activo BOOLEAN NOT NULL DEFAULT TRUE,
    telefono VARCHAR(30),
    programa VARCHAR(100) DEFAULT 'Ingeniería de Sistemas',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. USUARIO_ROL (Soporte multi-rol para cambiar_rol / elegir_rol)
CREATE TABLE IF NOT EXISTS usuario_rol (
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    rol_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, rol_id)
);

-- 4. PERIODOS ACADÉMICOS
CREATE TABLE IF NOT EXISTS periodos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    inicio_propuestas_banco DATE,
    fin_propuestas_banco DATE,
    inicio_nuevos_proyectos DATE,
    fin_nuevos_proyectos DATE,
    fin_aprobacion_propuesta DATE,
    activo BOOLEAN DEFAULT TRUE
);

-- 5. FORMATOS OFICIALES DE GRADO
CREATE TABLE IF NOT EXISTS formatos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    url_plantilla VARCHAR(500) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- 6. BANCO DE IDEAS
CREATE TABLE IF NOT EXISTS banco_ideas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    linea_investigacion VARCHAR(120),
    estado VARCHAR(50) NOT NULL DEFAULT 'DISPONIBLE',
    creado_por INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. PROYECTOS DE GRADO
CREATE TABLE IF NOT EXISTS proyectos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    objetivo TEXT NOT NULL,
    url_pago VARCHAR(500),
    url_anteproyecto VARCHAR(500),
    url_informe_final VARCHAR(500),
    url_repositorio_final VARCHAR(500),
    fase_actual VARCHAR(50) NOT NULL DEFAULT 'FASE_1',
    estado VARCHAR(50) NOT NULL DEFAULT 'EN_EVALUACION_COMITE',
    estudiante_id INT NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    companero_id INT REFERENCES usuarios(id) ON DELETE SET NULL,
    director_id INT REFERENCES usuarios(id) ON DELETE SET NULL,
    evaluador_id INT REFERENCES usuarios(id) ON DELETE SET NULL,
    idea_banco_id INT REFERENCES banco_ideas(id) ON DELETE SET NULL,
    motivo_rechazo TEXT,
    fecha_pago TIMESTAMP,
    fecha_aprobacion TIMESTAMP,
    fecha_limite_fdc124 TIMESTAMP,
    fecha_limite_vigencia TIMESTAMP,
    fecha_sustentacion TIMESTAMP,
    lugar_sustentacion VARCHAR(255),
    calificacion_sustentacion NUMERIC(4,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. HISTORIAL DE VERSIONES Y ENTREGABLES
CREATE TABLE IF NOT EXISTS historial_versiones (
    id SERIAL PRIMARY KEY,
    proyecto_id INT NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
    fase VARCHAR(50) NOT NULL,
    url_documento VARCHAR(500) NOT NULL,
    subido_por INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    observaciones_estudiante TEXT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. CALIFICACIONES Y CONCEPTOS DE EVALUADORES/DIRECTOR/COMITÉ
CREATE TABLE IF NOT EXISTS calificaciones (
    id SERIAL PRIMARY KEY,
    proyecto_id INT NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
    calificador_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fase VARCHAR(50) NOT NULL,
    resultado VARCHAR(50) NOT NULL,
    observaciones TEXT,
    nota_numerica NUMERIC(4,2),
    fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. SUSTENTACIONES FINALES
CREATE TABLE IF NOT EXISTS sustentaciones (
    id SERIAL PRIMARY KEY,
    proyecto_id INT UNIQUE NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
    fecha_hora TIMESTAMP NOT NULL,
    lugar_enlace VARCHAR(255) NOT NULL,
    resultado VARCHAR(50),
    acta_numero VARCHAR(50),
    registrado_por INT REFERENCES usuarios(id)
);

-- =============================================================================
-- DATOS SEMILLA (SEED DATA)
-- =============================================================================

-- Periodo Académico Activo
INSERT INTO periodos (id, codigo, inicio_propuestas_banco, fin_propuestas_banco, inicio_nuevos_proyectos, fin_nuevos_proyectos, fin_aprobacion_propuesta, activo)
VALUES (1, '2026-2', '2026-08-01', '2026-09-15', '2026-08-15', '2026-10-15', '2026-10-30', TRUE)
ON CONFLICT (id) DO UPDATE SET codigo = EXCLUDED.codigo, activo = EXCLUDED.activo;

-- Catálogo de Formatos Oficiales UTS
INSERT INTO formatos (id, codigo, nombre, url_plantilla, activo) VALUES
(1, 'F-DC-124', 'Propuesta de Trabajo de Grado', 'https://uts.edu.co/formatos/F-DC-124_Propuesta_Trabajo_Grado.docx', TRUE),
(2, 'F-DC-125', 'Informe Final de Trabajo de Grado', 'https://uts.edu.co/formatos/F-DC-125_Informe_Final_Grado.docx', TRUE),
(3, 'F-DC-129', 'Rejilla de Evaluación de Informe Final', 'https://uts.edu.co/formatos/F-DC-129_Rejilla_Evaluacion.xlsx', TRUE),
(4, 'F-DC-130', 'Acta de Sustentación de Trabajo de Grado', 'https://uts.edu.co/formatos/F-DC-130_Acta_Sustentacion.docx', TRUE)
ON CONFLICT (id) DO UPDATE SET codigo = EXCLUDED.codigo, url_plantilla = EXCLUDED.url_plantilla;

-- Usuarios de Prueba (Contraseña institucional: Uts2026*)
-- Hash SHA-256: d52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92
INSERT INTO usuarios (id, nombre_completo, correo, documento, password_hash, rol, estado_activo, telefono, programa) VALUES
(1, 'Ing. Carlos Morales Admin', 'admin@correo.uts.edu.co', '1098700001', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Administrador', TRUE, '3151234567', 'Ingeniería de Sistemas'),
(2, 'Dra. Marta Lucía Coordinadora', 'comite@correo.uts.edu.co', '1098700002', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Comite', TRUE, '3162345678', 'Ingeniería de Sistemas'),
(3, 'Mg. Fernando Gómez Docente', 'fgomez@correo.uts.edu.co', '1098700003', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Docente', TRUE, '3173456789', 'Ingeniería de Sistemas'),
(4, 'Dra. Patricia Silva Docente', 'psilva@correo.uts.edu.co', '1098700004', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Docente', TRUE, '3184567890', 'Ingeniería de Sistemas'),
(5, 'Juan David Pérez Estudiante', 'jperez@correo.uts.edu.co', '1098700005', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Estudiante', TRUE, '3195678901', 'Ingeniería de Sistemas'),
(6, 'Laura Marcela Gómez Estudiante', 'lgomez@correo.uts.edu.co', '1098700006', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Estudiante', TRUE, '3106789012', 'Ingeniería de Sistemas'),
(7, 'Diego Alejandro Ortiz Estudiante', 'dortiz@correo.uts.edu.co', '1098700007', 'd52f4d641d5ffbd7e250a1d45c05021aeedb67a7b37bab724677bdc216423f92', 'Estudiante', TRUE, '3117890123', 'Ingeniería de Sistemas')
ON CONFLICT (id) DO UPDATE SET nombre_completo = EXCLUDED.nombre_completo, correo = EXCLUDED.correo;

-- Asignación de Roles Múltiples (usuario_rol)
INSERT INTO usuario_rol (usuario_id, rol_id) VALUES
(1, 1), -- Admin: Administrador
(1, 3), -- Admin: además Docente
(2, 2), -- Marta: Comité
(3, 3), -- Fernando: Docente
(4, 3), -- Patricia: Docente
(5, 4), -- Juan David: Estudiante
(6, 4), -- Laura: Estudiante
(7, 4)  -- Diego: Estudiante
ON CONFLICT (usuario_id, rol_id) DO NOTHING;

-- Banco de Ideas Semilla
INSERT INTO banco_ideas (id, titulo, descripcion, linea_investigacion, estado, creado_por, created_at) VALUES
(1, 'Sistema IoT para Monitoreo de Calidad de Aire en Laboratorios UTS', 'Desarrollo de nodo sensor ESP32 para telemetría ambiental en tiempo real en laboratorios de química y electrónica.', 'Telecomunicaciones e IoT', 'DISPONIBLE', 2, CURRENT_TIMESTAMP),
(2, 'Optimización de Rutas de Recolección de Residuos Electrónicos en Bucaramanga', 'Algoritmo heurístico aplicado a la logística inversa de RAEE en el área metropolitana de Bucaramanga.', 'Logística y Gestión Ambiental', 'DISPONIBLE', 2, CURRENT_TIMESTAMP),
(3, 'Plataforma Web de Gestión de Egresados del Programa de Sistemas', 'Módulo de seguimiento y vinculación laboral para graduados de las Unidades Tecnológicas de Santander.', 'Ingeniería de Software', 'ASIGNADA', 2, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET titulo = EXCLUDED.titulo, estado = EXCLUDED.estado;

-- Proyecto Semilla en Fase 2 (En evaluación de anteproyecto)
INSERT INTO proyectos (id, titulo, objetivo, url_pago, url_anteproyecto, fase_actual, estado, estudiante_id, companero_id, director_id, evaluador_id, idea_banco_id, fecha_pago, fecha_aprobacion, fecha_limite_fdc124, fecha_limite_vigencia, created_at, updated_at) VALUES
(1, 'Plataforma Web de Gestión de Egresados del Programa de Sistemas', 'Diseñar e implementar un sistema web institucional para el seguimiento y oportunidades laborales de egresados UTS.', 'https://drive.google.com/file/d/1A2B3C4D_recibo_pago_uts/view', 'https://drive.google.com/file/d/1E5F6G7H_anteproyecto_fdc124/view', 'FASE_2', 'EN_EVALUACION_DIRECTOR', 5, 6, 3, 4, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', CURRENT_TIMESTAMP + INTERVAL '180 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET titulo = EXCLUDED.titulo, fase_actual = EXCLUDED.fase_actual, estado = EXCLUDED.estado;

-- Historial Inicial
INSERT INTO historial_versiones (id, proyecto_id, fase, url_documento, subido_por, observaciones_estudiante, fecha_subida) VALUES
(1, 1, 'FASE_1', 'https://drive.google.com/file/d/1A2B3C4D_recibo_pago_uts/view', 5, 'Radicación inicial de propuesta y pago.', CURRENT_TIMESTAMP - INTERVAL '5 days'),
(2, 1, 'FASE_2', 'https://drive.google.com/file/d/1E5F6G7H_anteproyecto_fdc124/view', 5, 'Carga de formato institucional F-DC-124.', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET url_documento = EXCLUDED.url_documento;

-- Sincronizar secuencias
SELECT setval('roles_id_seq', (SELECT COALESCE(MAX(id), 1) FROM roles));
SELECT setval('usuarios_id_seq', (SELECT COALESCE(MAX(id), 1) FROM usuarios));
SELECT setval('periodos_id_seq', (SELECT COALESCE(MAX(id), 1) FROM periodos));
SELECT setval('formatos_id_seq', (SELECT COALESCE(MAX(id), 1) FROM formatos));
SELECT setval('banco_ideas_id_seq', (SELECT COALESCE(MAX(id), 1) FROM banco_ideas));
SELECT setval('proyectos_id_seq', (SELECT COALESCE(MAX(id), 1) FROM proyectos));
SELECT setval('historial_versiones_id_seq', (SELECT COALESCE(MAX(id), 1) FROM historial_versiones));
