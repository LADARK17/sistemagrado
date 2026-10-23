package edu.uts.proyectos.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utilidad criptográfica para almacenamiento seguro de contraseñas.
 * Prohíbe texto plano mediante hash SHA-256 determinista y soporte BCrypt opcional.
 */
public class PasswordUtil {

    /**
     * Genera un hash SHA-256 seguro a partir de una contraseña en texto plano.
     */
    public static String hashPassword(String password) {
        if (password == null) {
            throw new IllegalArgumentException("La contraseña no puede ser nula");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error fatal: algoritmo SHA-256 no disponible", e);
        }
    }

    /**
     * Verifica una contraseña en texto plano contra el hash almacenado en base de datos.
     */
    public static boolean verificarPassword(String passwordIngresada, String hashAlmacenado) {
        if (passwordIngresada == null || hashAlmacenado == null) {
            return false;
        }

        // Si el hash almacenado es BCrypt ($2a$ / $2b$ / $2y$)
        if (hashAlmacenado.startsWith("$2a$") || hashAlmacenado.startsWith("$2b$") || hashAlmacenado.startsWith("$2y$")) {
            try {
                return org.mindrot.jbcrypt.BCrypt.checkpw(passwordIngresada, hashAlmacenado);
            } catch (Throwable t) {
                // En caso de que no cargue BCrypt, continuar a SHA
            }
        }

        // Validación estándar con SHA-256
        String hashCalculado = hashPassword(passwordIngresada);
        return hashCalculado.equalsIgnoreCase(hashAlmacenado);
    }
}
