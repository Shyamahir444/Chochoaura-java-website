<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Database Update | ChocoAura</title>
<style>
    body { font-family: sans-serif; padding: 50px; background: #f5d48e; }
    .card { background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    .success { color: green; }
    .error { color: red; }
</style>
</head>
<body>
<div class="card">
    <h2>Cart Table Update</h2>
    <%
    try (Connection con = DBConnection.getConnection();
         Statement stmt = con.createStatement()) {
        
        // 1. Add weight column if not exists
        try {
            stmt.executeUpdate("ALTER TABLE cart ADD COLUMN weight VARCHAR(20) DEFAULT '250g' AFTER product_id");
            out.println("<p class='success'>Column 'weight' added to cart table.</p>");
        } catch (SQLException e) {
            out.println("<p>Column 'weight' might already exist or error: " + e.getMessage() + "</p>");
        }

        // 2. Update unique index
        try {
            // Drop old unique key
            stmt.executeUpdate("ALTER TABLE cart DROP INDEX uk_cart_user_product");
            out.println("<p class='success'>Dropped old unique constraint.</p>");
        } catch (SQLException e) {
            out.println("<p>Old unique constraint not found or error: " + e.getMessage() + "</p>");
        }

        try {
            // Add new unique key including weight
            stmt.executeUpdate("ALTER TABLE cart ADD UNIQUE KEY uk_cart_user_product_weight (user_id, product_id, weight)");
            out.println("<p class='success'>Added new unique constraint (user_id, product_id, weight).</p>");
        } catch (SQLException e) {
            out.println("<p class='error'>Error adding new unique constraint: " + e.getMessage() + "</p>");
        }
        
    } catch (Exception e) {
        out.println("<p class='error'>General Error: " + e.getMessage() + "</p>");
    }
    %>
    <br>
    <a href="index.jsp">Go to Home</a>
</div>
</body>
</html>
