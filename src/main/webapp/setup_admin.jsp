<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin DB Setup | ChocoAura</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
body { font-family: 'Poppins', sans-serif; background: #f5d48e; color: #2a1414; padding: 50px; text-align: center; }
.card { background: #fff; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 600px; margin: auto; }
.success { color: green; font-weight: bold; }
.error { color: red; font-weight: bold; }
a { color: #fff; background: #2a1414; padding: 10px 20px; text-decoration: none; border-radius: 8px; display: inline-block; margin-top: 20px; }
</style>
</head>
<body>
<div class="card">
    <h2>Admin Database Initializer</h2>
    <p>
    <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chocoaura", "root", "");
        Statement stmt = con.createStatement();
        
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS admins (" +
                           "id INT AUTO_INCREMENT PRIMARY KEY, " +
                           "username VARCHAR(50) NOT NULL UNIQUE, " +
                           "password VARCHAR(255) NOT NULL)");
                           
        stmt.executeUpdate("INSERT IGNORE INTO admins (username, password) VALUES ('admin@chocoaura.com', 'admin123')");
        
        out.println("<span class='success'>Database configuration successful! The 'admins' table was verified and default credentials created.</span><br><br>");
        out.println("<strong>Username:</strong> admin@chocoaura.com<br>");
        out.println("<strong>Password:</strong> admin123");
        
        con.close();
    } catch (Exception e) {
        out.println("<span class='error'>Error initializing database: " + e.getMessage() + "</span>");
    }
    %>
    </p>
    <a href="admin_login.jsp">Proceed to Admin Login</a>
</div>
</body>
</html>
