<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    String errorMsg = request.getParameter("error");
    if (request.getParameter("msg") != null) {
        errorMsg = request.getParameter("msg");
    }
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        if (u != null && p != null && !u.trim().isEmpty() && !p.trim().isEmpty()) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id, username FROM admins WHERE username = ? AND password = ?")) {
                ps.setString(1, u.trim());
                ps.setString(2, p.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        session.setAttribute("admin_id", rs.getInt("id"));
                        session.setAttribute("admin_username", rs.getString("username"));
                        response.sendRedirect("admin_dashboard.jsp");
                        return;
                    } else {
                        errorMsg = "Invalid admin credentials.";
                    }
                }
            } catch (Exception e) {
                errorMsg = "Database error: " + e.getMessage();
            }
        } else {
            errorMsg = "Please enter username and password.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login | ChocoAura</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { min-height: 100vh; background: #f5d48e; display: flex; align-items: center; justify-content: center; }
        .login-wrapper { width: 500px; background: #1f0f0f; border-radius: 18px; display: flex; overflow: hidden; box-shadow: 0 25px 50px rgba(0, 0, 0, 0.6); flex-direction: column; }
        .login-content { padding: 45px; color: #fff; }
        .login-content h1 { color: #f5d48e; letter-spacing: 2px; margin-bottom: 8px; text-align: center; }
        .login-content p { font-size: 14px; margin-bottom: 35px; text-align: center; color: #ccc; }
        .input-group { margin-bottom: 20px; }
        .input-group label { font-size: 14px; color: #f5d48e; display: block; margin-bottom: 6px; }
        .input-group input { width: 100%; padding: 12px 14px; border-radius: 30px; border: 1px solid #f5d48e; background: transparent; color: #fff; outline: none; }
        .input-group input::placeholder { color: #ccc; }
        .login-btn { width: 100%; padding: 12px; border-radius: 30px; border: none; background: #f5d48e; color: #2a1414; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .login-btn:hover { background: #fff; }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="login-content">
            <h1>ADMIN PORTAL</h1>
            <p>Restricted Access - Authorized Personnel Only</p>
            <form action="AdminLoginServlet" method="POST">
                <%
                   String errorMSG = request.getParameter("error");
                   if (errorMsg != null && !errorMsg.isEmpty()) {
                %>
                <div class="input-group" style="color:#ff6b6b; font-size:13px; margin-bottom:12px; text-align: center;">
                    <%= errorMsg %>
                </div>
                <% } %>
                <div class="input-group">
                    <label>Admin Username</label>
                    <input type="text" name="username" placeholder="admin@chocoaura.com" required>
                </div>
                <div class="input-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="******" required>
                </div>
                <button type="submit" class="login-btn">Secure Login</button>
            </form>
        </div>
    </div>
</body>
</html>