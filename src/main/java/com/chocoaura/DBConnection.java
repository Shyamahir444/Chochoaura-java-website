package com.chocoaura;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    private static final String BASE_URL = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/chocoaura?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    /** Set your MySQL root password here if you have one */
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        if (cl == null) {
			cl = DBConnection.class.getClassLoader();
		}
        try {
            Class.forName("com.mysql.cj.jdbc.Driver", true, cl);
        } catch (ClassNotFoundException e) {
            try {
                Class.forName("com.mysql.jdbc.Driver", true, cl);
            } catch (ClassNotFoundException e2) {
                throw new SQLException(
                    "MySQL driver not found. Put mysql-connector-j-8.0.33.jar (or similar) inside project folder: src/main/webapp/WEB-INF/lib . Then Eclipse: Project -> Clean, restart Tomcat. The JAR must be INSIDE the project so it deploys.",
                    e);
            }
        }

        Connection con = null;
        try {
            con = DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("Unknown database")) {
                try (Connection rootCon = DriverManager.getConnection(BASE_URL, USER, PASSWORD);
                     Statement st = rootCon.createStatement()) {
                    st.executeUpdate("CREATE DATABASE IF NOT EXISTS chocoaura");
                }
                con = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            } else {
                throw e;
            }
        }
        if (con == null) {
            throw new SQLException("Failed to get database connection.");
        }
        ensureUsersTableExists(con);
        ensureAdminsTableExists(con);
        ensureCategoriesTableExists(con);
        ensureProductsTableExists(con);
        ensureOtherTablesExist(con);
        return con;
    }

    private static void ensureUsersTableExists(Connection con) {
        String sql = "CREATE TABLE IF NOT EXISTS users ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "full_name VARCHAR(100) NOT NULL,"
                + "email VARCHAR(100) NOT NULL UNIQUE,"
                + "password VARCHAR(255) NOT NULL,"
                + "address VARCHAR(255) DEFAULT NULL,"
                + "phone VARCHAR(20) DEFAULT NULL,"
                + "date_of_birth DATE DEFAULT NULL,"
                + "profile_image VARCHAR(255) DEFAULT 'default_user.jpg',"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                + ")";
        try (Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) { /* ignore */ }
    }

    private static void ensureAdminsTableExists(Connection con) {
        try (Statement st = con.createStatement()) {
            st.executeUpdate("CREATE TABLE IF NOT EXISTS admins ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "username VARCHAR(50) NOT NULL UNIQUE, "
                    + "password VARCHAR(255) NOT NULL)");
            st.executeUpdate("INSERT IGNORE INTO admins (username, password) VALUES ('admin@chocoaura.com', 'admin123')");
        } catch (SQLException e) { /* ignore */ }
    }

    private static void ensureProductsTableExists(Connection con) {
        try (Statement st = con.createStatement()) {
            st.executeUpdate("CREATE TABLE IF NOT EXISTS products ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "name VARCHAR(150) NOT NULL,"
                    + "description TEXT,"
                    + "price DECIMAL(10,2) NOT NULL,"
                    + "image VARCHAR(255) DEFAULT NULL,"
                    + "category VARCHAR(50) DEFAULT 'Chocolates',"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            
            // Self-healing: Ensure category column exists (in case table was created with old schema)
            try {
                st.executeUpdate("ALTER TABLE products ADD COLUMN IF NOT EXISTS category VARCHAR(50) DEFAULT 'Chocolates' AFTER image");
            } catch (SQLException e) {}

            st.executeUpdate("INSERT IGNORE INTO products (id,name,description,price,image,category) VALUES "
                    + "(1,'Golden Lens Truffle','Premium truffle chocolates. Smooth, rich and elegant.',350,'product1.jpg','Premium Chocolates'),"
                    + "(2,'Macro Mocha Bites','Deep mocha flavored chocolates.',420,'product2.jpg','Dark Chocolates'),"
                    + "(3,'Studio Swirl Bonbons','Beautifully swirled bonbons with silky chocolate core.',399,'product3.jpg','Truffle Chocolates'),"
                    + "(4,'Rose Tint Click Box','Romantic rose-infused chocolates in premium gift box.',499,'product4.jpg','Gift Hampers'),"
                    + "(5,'Soft Focus Cup Truffles','Cup-shaped truffles, smooth melt-in-mouth.',450,'product5.jpg','Truffle Chocolates')");
        } catch (SQLException e) { /* ignore */ }
    }

    private static void ensureOtherTablesExist(Connection con) {
        try (Statement st = con.createStatement()) {
            st.executeUpdate("CREATE TABLE IF NOT EXISTS contact (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100), email VARCHAR(100), subject VARCHAR(200), message TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            
            // Cart with weight support
            st.executeUpdate("CREATE TABLE IF NOT EXISTS cart ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "user_id INT NOT NULL, "
                    + "product_id INT NOT NULL, "
                    + "weight VARCHAR(20) DEFAULT '250g', "
                    + "quantity INT DEFAULT 1, "
                    + "added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "UNIQUE KEY uk_cart_user_product_weight (user_id, product_id, weight))");
            
            st.executeUpdate("CREATE TABLE IF NOT EXISTS wishlist (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uk_wish_user_product (user_id, product_id))");
            st.executeUpdate("CREATE TABLE IF NOT EXISTS addresses (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, full_name VARCHAR(100), mobile VARCHAR(20), address_line VARCHAR(255), city VARCHAR(80), state VARCHAR(80), pincode VARCHAR(15), address_type VARCHAR(20) DEFAULT 'Home', is_default TINYINT DEFAULT 0, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            st.executeUpdate("CREATE TABLE IF NOT EXISTS payment_methods (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, card_holder VARCHAR(100), card_last_four VARCHAR(4), card_type VARCHAR(20), expiry_month VARCHAR(2), expiry_year VARCHAR(4), is_default TINYINT DEFAULT 0, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            st.executeUpdate("CREATE TABLE IF NOT EXISTS orders (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, address_id INT, payment_method_id INT, order_number VARCHAR(30), total_amount DECIMAL(12,2), status VARCHAR(30) DEFAULT 'Placed', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            st.executeUpdate("CREATE TABLE IF NOT EXISTS order_items (id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL, product_name VARCHAR(150), quantity INT, price DECIMAL(10,2))");
        } catch (SQLException e) { /* ignore */ }
    }

    private static void ensureCategoriesTableExists(Connection con) {
        String sql = "CREATE TABLE IF NOT EXISTS categories ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "name VARCHAR(50) NOT NULL UNIQUE"
                + ")";
        try (Statement st = con.createStatement()) {
            st.executeUpdate(sql);
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM categories");
            if (rs.next() && rs.getInt(1) == 0) {
                st.executeUpdate("INSERT INTO categories (name) VALUES "
                        + "('Dark Chocolates'), ('Milk Chocolates'), ('White Chocolates'), "
                        + "('Truffle Chocolates'), ('Assorted Boxes'), ('Gift Hampers'), ('Premium Chocolates')");
            }
        } catch (SQLException e) { /* ignore */ }
    }
}

