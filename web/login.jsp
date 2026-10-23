<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | SIGRADO - Trabajos de Grado UTS</title>
    <!-- Favicon Oficial UTS -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
    
    <!-- Fuentes Oficiales Modernas -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/uts-estilos.css">

    <style>
        :root {
            --uts-green-deep: #03140c;
            --uts-green-dark: #062415;
            --uts-green-card: #092f1c;
            --uts-green-primary: #006837;
            --uts-green-accent: #10b981;
            --uts-gold: #f59e0b;
            --uts-gold-hover: #d97706;
            --uts-gold-glow: rgba(245, 158, 11, 0.35);
            --uts-green-glow: rgba(16, 185, 129, 0.28);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body.login-page-body {
            min-height: 100vh;
            background: radial-gradient(circle at 15% 20%, #08331e 0%, #04160d 50%, #020c07 100%);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
            position: relative;
            overflow-x: hidden;
        }

        /* Ambient Glow & Grid Matrix */
        .ambient-glow-1 {
            position: fixed;
            top: -120px;
            left: -100px;
            width: 520px;
            height: 520px;
            border-radius: 50%;
            background: radial-gradient(circle, var(--uts-green-glow) 0%, transparent 70%);
            filter: blur(60px);
            pointer-events: none;
            z-index: 1;
            animation: pulseGlow 10s ease-in-out infinite alternate;
        }

        .ambient-glow-2 {
            position: fixed;
            bottom: -150px;
            right: -100px;
            width: 580px;
            height: 580px;
            border-radius: 50%;
            background: radial-gradient(circle, var(--uts-gold-glow) 0%, transparent 70%);
            filter: blur(70px);
            pointer-events: none;
            z-index: 1;
            animation: pulseGlow 12s ease-in-out infinite alternate-reverse;
        }

        .grid-matrix-bg {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(rgba(255, 255, 255, 0.06) 1px, transparent 1px),
                radial-gradient(rgba(16, 185, 129, 0.05) 1px, transparent 1px);
            background-size: 32px 32px;
            background-position: 0 0, 16px 16px;
            pointer-events: none;
            z-index: 1;
        }

        @keyframes pulseGlow {
            0% { transform: scale(1) translate(0, 0); opacity: 0.7; }
            100% { transform: scale(1.15) translate(30px, 20px); opacity: 1; }
        }

        /* Main Split Container */
        .login-master-container {
            width: 100%;
            max-width: 1080px;
            background: rgba(6, 26, 16, 0.65);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 
                0 30px 60px -15px rgba(0, 0, 0, 0.7),
                0 0 0 1px rgba(255, 255, 255, 0.05),
                0 0 80px -20px rgba(0, 104, 55, 0.35);
            border-radius: 28px;
            display: grid;
            grid-template-columns: 1.15fr 1fr;
            overflow: hidden;
            position: relative;
            z-index: 10;
        }

        /* LEFT SIDE: Hero Showcase Panel */
        .showcase-panel {
            padding: 48px 42px;
            background: linear-gradient(145deg, rgba(7, 34, 21, 0.9) 0%, rgba(3, 18, 10, 0.95) 100%);
            border-right: 1px solid rgba(255, 255, 255, 0.07);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }

        .showcase-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at top left, rgba(16, 185, 129, 0.15), transparent 60%);
            pointer-events: none;
        }

        .brand-badge-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 28px;
        }

        .uts-logo-emblem {
            width: 52px;
            height: 52px;
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Outfit', sans-serif;
            font-weight: 900;
            font-size: 1.35rem;
            color: #03140c;
            box-shadow: 0 10px 25px -5px rgba(245, 158, 11, 0.5), inset 0 2px 4px rgba(255, 255, 255, 0.4);
            letter-spacing: 0.5px;
            flex-shrink: 0;
        }

        .brand-meta-name {
            font-family: 'Outfit', sans-serif;
            font-size: 1.45rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
            line-height: 1.1;
        }

        .brand-meta-sub {
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--uts-green-accent);
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .hero-title-group {
            margin-bottom: 30px;
        }

        .hero-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(16, 185, 129, 0.12);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
            padding: 5px 14px;
            border-radius: 30px;
            font-size: 0.76rem;
            font-weight: 700;
            letter-spacing: 0.4px;
            margin-bottom: 16px;
        }

        .hero-badge-pill .pulse-indicator {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #10b981;
            box-shadow: 0 0 10px #10b981;
            animation: pulseDot 2s infinite;
        }

        @keyframes pulseDot {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.4); opacity: 0.5; }
        }

        .hero-main-heading {
            font-family: 'Outfit', sans-serif;
            font-size: 2.15rem;
            font-weight: 800;
            line-height: 1.18;
            color: #ffffff;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .hero-main-heading span {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-description {
            font-size: 0.92rem;
            line-height: 1.55;
            color: #94a3b8;
            font-weight: 400;
        }

        /* Feature cards inside showcase */
        .features-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 28px;
        }

        .feature-card-item {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 14px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            transition: all 0.25s ease;
        }

        .feature-card-item:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(16, 185, 129, 0.3);
            transform: translateX(4px);
        }

        .feature-icon-box {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .feature-icon-box.green {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .feature-icon-box.gold {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .feature-icon-box.blue {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .feature-card-title {
            font-size: 0.86rem;
            font-weight: 700;
            color: #f1f5f9;
            margin-bottom: 2px;
        }

        .feature-card-desc {
            font-size: 0.75rem;
            color: #94a3b8;
            line-height: 1.35;
        }

        .showcase-footer {
            font-size: 0.74rem;
            color: #64748b;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 18px;
            border-top: 1px solid rgba(255, 255, 255, 0.06);
        }

        /* RIGHT SIDE: Authentication Form Panel */
        .auth-panel {
            padding: 44px 38px;
            background: #ffffff;
            color: #0f172a;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }

        .auth-top-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #64748b;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.2s;
            padding: 6px 10px;
            border-radius: 8px;
        }

        .back-link:hover {
            color: var(--uts-green-primary);
            background: #f1f5f9;
            transform: translateX(-2px);
        }

        .security-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 700;
        }

        .auth-header {
            margin-bottom: 22px;
        }

        .auth-header h2 {
            font-family: 'Outfit', sans-serif;
            font-size: 1.75rem;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }

        .auth-header p {
            color: #64748b;
            font-size: 0.88rem;
        }

        /* Inputs and Form */
        .form-group-modern {
            margin-bottom: 18px;
            position: relative;
        }

        .form-label-modern {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.82rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 7px;
        }

        .input-icon-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon-wrap svg.field-icon {
            position: absolute;
            left: 14px;
            color: #94a3b8;
            pointer-events: none;
            transition: color 0.2s;
        }

        .form-input-modern {
            width: 100%;
            height: 48px;
            padding: 0 42px 0 44px;
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 0.92rem;
            font-family: inherit;
            color: #0f172a;
            transition: all 0.25s ease;
        }

        .form-input-modern:focus {
            outline: none;
            background: #ffffff;
            border-color: #059669;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.15);
        }

        .form-input-modern:focus + svg.field-icon,
        .input-icon-wrap:focus-within svg.field-icon {
            color: #059669;
        }

        /* Password toggle button */
        .toggle-password-btn {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            color: #94a3b8;
            cursor: pointer;
            padding: 6px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }

        .toggle-password-btn:hover {
            color: #334155;
            background: #e2e8f0;
        }

        /* Action Row */
        .form-action-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
            font-size: 0.82rem;
        }

        .remember-checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #475569;
            cursor: pointer;
            font-weight: 500;
        }

        .remember-checkbox-label input {
            accent-color: #006837;
            width: 16px;
            height: 16px;
            border-radius: 4px;
            cursor: pointer;
        }

        .forgot-link {
            color: #006837;
            text-decoration: none;
            font-weight: 700;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: #059669;
            text-decoration: underline;
        }

        /* Primary Button */
        .btn-submit-modern {
            width: 100%;
            height: 50px;
            background: linear-gradient(135deg, #006837 0%, #008f4c 100%);
            color: #ffffff;
            border: none;
            border-radius: 12px;
            font-family: inherit;
            font-size: 0.98rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
            box-shadow: 0 10px 20px -5px rgba(0, 104, 55, 0.45);
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }

        .btn-submit-modern::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 50%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
            transition: 0.6s;
        }

        .btn-submit-modern:hover {
            background: linear-gradient(135deg, #005a30 0%, #007a41 100%);
            transform: translateY(-2px);
            box-shadow: 0 14px 26px -6px rgba(0, 104, 55, 0.55);
        }

        .btn-submit-modern:hover::after {
            left: 120%;
        }

        .btn-submit-modern:active {
            transform: translateY(1px);
            box-shadow: 0 6px 14px -3px rgba(0, 104, 55, 0.4);
        }

        /* Quick Roles (Demo) */
        .demo-roles-panel {
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid #f1f5f9;
        }

        .demo-roles-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .demo-roles-title {
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .demo-roles-pwd-hint {
            font-size: 0.72rem;
            font-weight: 600;
            color: #64748b;
            background: #f8fafc;
            padding: 3px 8px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }

        .roles-chips-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 7px;
        }

        .role-chip {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 9px;
            padding: 7px 8px;
            cursor: pointer;
            text-align: left;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .role-chip:hover, .role-chip.active {
            background: #ecfdf5;
            border-color: #34d399;
            transform: translateY(-1.5px);
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.15);
        }

        .role-avatar-circle {
            width: 24px;
            height: 24px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.68rem;
            font-weight: 800;
            flex-shrink: 0;
        }

        .role-chip:nth-child(1) .role-avatar-circle { background: #dbeafe; color: #1d4ed8; }
        .role-chip:nth-child(2) .role-avatar-circle { background: #fef3c7; color: #b45309; }
        .role-chip:nth-child(3) .role-avatar-circle { background: #e0e7ff; color: #4338ca; }
        .role-chip:nth-child(4) .role-avatar-circle { background: #fae8ff; color: #86198f; }
        .role-chip:nth-child(5) .role-avatar-circle { background: #dcfce7; color: #15803d; }

        .role-chip-text {
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .role-chip-name {
            font-size: 0.74rem;
            font-weight: 700;
            color: #1e293b;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .role-chip-sub {
            font-size: 0.65rem;
            color: #64748b;
            white-space: nowrap;
        }

        /* Responsive Breakpoints */
        @media (max-width: 960px) {
            .login-master-container {
                grid-template-columns: 1fr;
                max-width: 520px;
            }

            .showcase-panel {
                display: none;
            }

            .auth-panel {
                padding: 38px 28px;
            }

            .roles-chips-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .auth-mobile-logo {
                display: block !important;
            }
        }
    </style>
</head>
<body class="login-page-body">
    <!-- Efectos Ambientales de Fondo -->
    <div class="ambient-glow-1"></div>
    <div class="ambient-glow-2"></div>
    <div class="grid-matrix-bg"></div>

    <!-- Contenedor Maestro Split-Screen -->
    <main class="login-master-container" role="main">
        
        <!-- PANEL IZQUIERDO: Escaparate Institucional (Hero Showcase) -->
        <section class="showcase-panel">
            <div>
                <!-- Logotipo e Identidad Institucional -->
                <div class="brand-badge-header">
                    <div style="background: #ffffff; padding: 6px 14px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; box-shadow: 0 4px 14px rgba(0,0,0,0.25); flex-shrink: 0;">
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo UTS" style="height: 42px; width: auto; object-fit: contain;">
                    </div>
                    <div>
                        <div class="brand-meta-name">SIGRADO</div>
                        <div class="brand-meta-sub">Ingeniería de Sistemas · UTS</div>
                    </div>
                </div>

                <!-- Grupo de Titular y Periodo -->
                <div class="hero-title-group">
                    <div class="hero-badge-pill">
                        <span class="pulse-indicator"></span>
                        <span>Periodo Académico 2026-2 Activo</span>
                    </div>
                    <h1 class="hero-main-heading">
                        Gestión Integral de <span>Trabajos de Grado</span>
                    </h1>
                    <p class="hero-description">
                        Plataforma oficial de las Unidades Tecnológicas de Santander para la administración, radicación y seguimiento continuo de proyectos de grado.
                    </p>
                </div>

                <!-- Tarjetas de Capacidades del Sistema -->
                <div class="features-list">
                    <div class="feature-card-item">
                        <div class="feature-icon-box green">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                        <div>
                            <div class="feature-card-title">Seguimiento en 6 Fases</div>
                            <div class="feature-card-desc">Trazabilidad desde el Banco de Ideas hasta la Sustentación Final y Acta.</div>
                        </div>
                    </div>

                    <div class="feature-card-item">
                        <div class="feature-icon-box gold">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        </div>
                        <div>
                            <div class="feature-card-title">Cero Papel & Turnitin</div>
                            <div class="feature-card-desc">Historial de versiones F-DC-124 / F-DC-125 con verificación antiplagio digital.</div>
                        </div>
                    </div>

                    <div class="feature-card-item">
                        <div class="feature-icon-box blue">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </div>
                        <div>
                            <div class="feature-card-title">Flujo Colegiado y Evaluadores</div>
                            <div class="feature-card-desc">Integración fluida para Comité, Directores, Evaluadores y Estudiantes.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="showcase-footer">
                <span>Unidades Tecnológicas de Santander</span>
                <span>Bucaramanga, Colombia</span>
            </div>
        </section>

        <!-- PANEL DERECHO: Formulario de Autenticación -->
        <section class="auth-panel">
            <div>
                <!-- Navegación Superior del Formulario -->
                <div class="auth-top-nav">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        <span>Portal UTS</span>
                    </a>
                    <div class="security-badge-pill">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        <span>Cifrado SSL</span>
                    </div>
                </div>

                <!-- Encabezado de Bienvenida -->
                <div class="auth-header">
                    <div class="auth-mobile-logo" style="display: none; margin-bottom: 16px; text-align: center;">
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo UTS" style="height: 48px; width: auto; object-fit: contain;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/logo.png';">
                    </div>
                    <h2>Iniciar Sesión</h2>
                    <p>Ingresa con tu correo institucional o número de documento</p>
                </div>

                <!-- MENSAJES DE ESTADO Y ALERTAS -->
                <c:if test="${not empty errorMensaje}">
                    <div class="alert alert-danger" style="margin-bottom: 18px; padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; display: flex; align-items: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span><c:out value="${errorMensaje}" /></span>
                    </div>
                </c:if>

                <c:if test="${param.logout == 'true'}">
                    <div class="alert alert-info" style="margin-bottom: 18px; padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; display: flex; align-items: center; gap: 8px; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <span>Has cerrado sesión de forma segura. ¡Hasta pronto!</span>
                    </div>
                </c:if>

                <c:if test="${param.error == 'unauthorized'}">
                    <div class="alert alert-warning" style="margin-bottom: 18px; padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; display: flex; align-items: center; gap: 8px; background: #fffbeb; color: #92400e; border: 1px solid #fde68a;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                        <span>Acceso restringido: No posees privilegios para ingresar a esa sección.</span>
                    </div>
                </c:if>

                <c:if test="${param.error == 'unauthenticated'}">
                    <div class="alert alert-warning" style="margin-bottom: 18px; padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; display: flex; align-items: center; gap: 8px; background: #fffbeb; color: #92400e; border: 1px solid #fde68a;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span>Por favor inicia sesión para acceder a tu panel de grado.</span>
                    </div>
                </c:if>

                <!-- FORMULARIO DE ACCESO -->
                <form action="${pageContext.request.contextPath}/auth" method="POST" id="formLogin">
                    <!-- Campo: Identificador -->
                    <div class="form-group-modern">
                        <label class="form-label-modern" for="identificador">
                            <span>Correo Institucional o Documento</span>
                        </label>
                        <div class="input-icon-wrap">
                            <svg class="field-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                            <input type="text" id="identificador" name="identificador" required class="form-input-modern"
                                   placeholder="ej. jperez@correo.uts.edu.co" autocomplete="username" />
                        </div>
                    </div>

                    <!-- Campo: Contraseña -->
                    <div class="form-group-modern">
                        <label class="form-label-modern" for="password">
                            <span>Contraseña Institucional</span>
                        </label>
                        <div class="input-icon-wrap">
                            <svg class="field-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            <input type="password" id="password" name="password" required class="form-input-modern"
                                   placeholder="••••••••" autocomplete="current-password" />
                            <button type="button" class="toggle-password-btn" id="btnTogglePassword" title="Mostrar u ocultar contraseña">
                                <svg id="iconEye" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                <svg id="iconEyeOff" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                            </button>
                        </div>
                    </div>

                    <!-- Fila de Recordar y Formatos -->
                    <div class="form-action-row">
                        <label class="remember-checkbox-label">
                            <input type="checkbox" id="chkRecordar" name="recordar">
                            <span>Recordar sesión</span>
                        </label>
                        <a href="${pageContext.request.contextPath}/comun/formatos.jsp" class="forgot-link">Ver Formatos</a>
                    </div>

                    <!-- Botón Principal de Envío -->
                    <button type="submit" class="btn-submit-modern" id="btnSubmitLogin">
                        <span>Ingresar a SIGRADO</span>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </button>
                </form>

                <!-- PANEL DE ACCESO RÁPIDO DE PRUEBA (5 ROLES REGLAMENTARIOS) -->
                <div class="demo-roles-panel">
                    <div class="demo-roles-header">
                        <div class="demo-roles-title">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                            <span>Acceso Rápido (Demo)</span>
                        </div>
                        <div class="demo-roles-pwd-hint">
                            Clave: <strong>Uts2026*</strong>
                        </div>
                    </div>

                    <div class="roles-chips-grid">
                        <!-- 1. Estudiante -->
                        <div class="role-chip" onclick="rellenar('jperez@correo.uts.edu.co', 'Uts2026*', this)">
                            <div class="role-avatar-circle">ES</div>
                            <div class="role-chip-text">
                                <span class="role-chip-name">Estudiante</span>
                                <span class="role-chip-sub">J. Pérez</span>
                            </div>
                        </div>

                        <!-- 2. Director -->
                        <div class="role-chip" onclick="rellenar('fgomez@correo.uts.edu.co', 'Uts2026*', this)">
                            <div class="role-avatar-circle">DI</div>
                            <div class="role-chip-text">
                                <span class="role-chip-name">Director</span>
                                <span class="role-chip-sub">F. Gómez</span>
                            </div>
                        </div>

                        <!-- 3. Evaluador -->
                        <div class="role-chip" onclick="rellenar('psilva@correo.uts.edu.co', 'Uts2026*', this)">
                            <div class="role-avatar-circle">EV</div>
                            <div class="role-chip-text">
                                <span class="role-chip-name">Evaluador</span>
                                <span class="role-chip-sub">P. Silva</span>
                            </div>
                        </div>

                        <!-- 4. Comité -->
                        <div class="role-chip" onclick="rellenar('comite@correo.uts.edu.co', 'Uts2026*', this)">
                            <div class="role-avatar-circle">CO</div>
                            <div class="role-chip-text">
                                <span class="role-chip-name">Comité</span>
                                <span class="role-chip-sub">M. Lucía</span>
                            </div>
                        </div>

                        <!-- 5. Administrador -->
                        <div class="role-chip" onclick="rellenar('admin@correo.uts.edu.co', 'Uts2026*', this)" style="grid-column: span 2;">
                            <div class="role-avatar-circle">AD</div>
                            <div class="role-chip-text">
                                <span class="role-chip-name">Administrador del Sistema</span>
                                <span class="role-chip-sub">C. Morales (Admin + Docente)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pie de Seguridad -->
            <div style="margin-top: 24px; text-align: center; font-size: 0.72rem; color: #94a3b8;">
                <span>© 2026 Unidades Tecnológicas de Santander · Conexión Segura</span>
            </div>
        </section>
    </main>

    <!-- Interactividad Frontend -->
    <script>
        // Alternar Visibilidad de la Contraseña
        const btnTogglePassword = document.getElementById('btnTogglePassword');
        const inputPassword = document.getElementById('password');
        const iconEye = document.getElementById('iconEye');
        const iconEyeOff = document.getElementById('iconEyeOff');

        if (btnTogglePassword && inputPassword) {
            btnTogglePassword.addEventListener('click', function() {
                const isPassword = inputPassword.type === 'password';
                inputPassword.type = isPassword ? 'text' : 'password';
                iconEye.style.display = isPassword ? 'none' : 'block';
                iconEyeOff.style.display = isPassword ? 'block' : 'none';
            });
        }

        // Rellenar Credenciales de Prueba
        function rellenar(usuario, pass, element) {
            const inputUser = document.getElementById('identificador');
            const inputPass = document.getElementById('password');
            
            inputUser.value = usuario;
            inputPass.value = pass;

            // Highlight temporal
            inputUser.style.borderColor = '#059669';
            inputPass.style.borderColor = '#059669';
            inputUser.style.backgroundColor = '#ecfdf5';
            inputPass.style.backgroundColor = '#ecfdf5';

            // Marcar chip activo
            document.querySelectorAll('.role-chip').forEach(c => c.classList.remove('active'));
            if (element) element.classList.add('active');

            setTimeout(() => {
                inputUser.style.borderColor = '#e2e8f0';
                inputPass.style.borderColor = '#e2e8f0';
                inputUser.style.backgroundColor = '#f8fafc';
                inputPass.style.backgroundColor = '#f8fafc';
            }, 800);
        }
    </script>
</body>
</html>
