package edu.uts.proyectos.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Conexión centralizada a la base de datos Supabase (PostgreSQL).
 * Configurada con SSL obligatorio y soporte para parámetros externos o defaults.
 */
public class ConexionDB {

    // Configuración centralizada para Supabase
    private static String host = "aws-1-us-west-2.pooler.supabase.com";
    private static String port = "5432";
    private static String database = "postgres";
    private static String user = "postgres.fkconaghijcwjwnrhwyi";
    private static String password = "Oq7mDsyuVkKcO3wR";
    private static String sslMode = "require";

    static {
        try {
            // Cargar Driver PostgreSQL
            Class.forName("org.postgresql.Driver");
            
            // Intento de cargar propiedades desde database.properties si existe en classpath
            try (InputStream input = ConexionDB.class.getClassLoader().getResourceAsStream("database.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    if (prop.getProperty("db.host") != null) host = prop.getProperty("db.host");
                    if (prop.getProperty("db.port") != null) port = prop.getProperty("db.port");
                    if (prop.getProperty("db.database") != null) database = prop.getProperty("db.database");
                    if (prop.getProperty("db.user") != null) user = prop.getProperty("db.user");
                    if (prop.getProperty("db.password") != null) password = prop.getProperty("db.password");
                    if (prop.getProperty("db.sslmode") != null) sslMode = prop.getProperty("db.sslmode");
                }
            } catch (Exception ignored) {
            }
        } catch (ClassNotFoundException e) {
            System.err.println("CRÍTICO: No se encontró el driver PostgreSQL JDBC en el classpath.");
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s", host, port, database, sslMode);
        return DriverManager.getConnection(url, user, password);
    }

    public static void setConfig(String newHost, String newPort, String newDb, String newUser, String newPass, String newSsl) {
        host = newHost;
        port = newPort;
        database = newDb;
        user = newUser;
        password = newPass;
        sslMode = newSsl;
    }
}
