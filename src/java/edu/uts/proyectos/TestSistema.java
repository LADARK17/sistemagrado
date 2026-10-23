package edu.uts.proyectos;

import edu.uts.proyectos.config.ConexionDB;
import edu.uts.proyectos.dao.UsuarioDAO;
import edu.uts.proyectos.model.Usuario;
import edu.uts.proyectos.util.PasswordUtil;
import java.sql.Connection;

/**
 * Clase utilitaria para verificar la conectividad con Supabase y validar
 * el cifrado criptográfico de contraseñas de los 5 roles.
 */
public class TestSistema {
    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println(" SISTEMA DE TRABAJOS DE GRADO - UTS (VERIFICACIÓN EN CONSOLA)");
        System.out.println("==========================================================");

        // 1. Probar hash de contraseña
        String passwordPlana = "Uts2026*";
        String hashGenerado = PasswordUtil.hashPassword(passwordPlana);
        System.out.println("1. Prueba de Criptografía SHA-256:");
        System.out.println("   Contraseña plana : " + passwordPlana);
        System.out.println("   Hash generado    : " + hashGenerado);
        System.out.println("   Verificación OK  : " + PasswordUtil.verificarPassword(passwordPlana, hashGenerado));

        // 2. Probar conexión con Supabase (JDBC)
        System.out.println("\n2. Prueba de Conexión JDBC con Supabase:");
        try (Connection con = ConexionDB.getConnection()) {
            System.out.println("   ¡Conexión exitosa con Supabase PostgreSQL!");
            System.out.println("   Catálogo: " + con.getCatalog());
            
            UsuarioDAO udao = new UsuarioDAO();
            Usuario u = udao.autenticar("admin@correo.uts.edu.co", "Uts2026*");
            if (u != null) {
                System.out.println("   Usuario autenticado: " + u.getNombreCompleto() + " (" + u.getRol() + ")");
            } else {
                System.out.println("   Aviso: Conectado a Supabase pero usuario semilla aún no insertado.");
            }
        } catch (Exception e) {
            System.out.println("   Nota de Conexión: " + e.getMessage());
            System.out.println("   (Recuerde configurar sus credenciales reales de Supabase en src/java/database.properties)");
        }
        System.out.println("==========================================================");
    }
}
