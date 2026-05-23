<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Database connection test - ChocoAura</title>
<style>
body { font-family: Arial; padding: 20px; background: #f5d48e; }
.box { background: #1f0f0f; color: #fff; padding: 20px; border-radius: 10px; max-width: 600px; margin: 10px 0; }
.ok { color: #51cf66; }
.err { color: #ff6b6b; }
h2 { color: #f5d48e; margin-top: 0; }
pre { background: #2a1414; padding: 10px; overflow-x: auto; font-size: 12px; }
</style>
</head>
<body>
<h1>ChocoAura â€“ Database test</h1>

<%
String step1 = "";
String step2 = "";
String step3 = "";
String step4 = "";
boolean allOk = false;

try {
    // Step 1: Load driver
    ClassLoader cl = Thread.currentThread().getContextClassLoader();
    if (cl == null) cl = getClass().getClassLoader();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver", true, cl);
        step1 = "OK â€“ MySQL driver (cj) loaded.";
    } catch (ClassNotFoundException e) {
        try {
            Class.forName("com.mysql.jdbc.Driver", true, cl);
            step1 = "OK â€“ MySQL driver (legacy) loaded.";
        } catch (ClassNotFoundException e2) {
            step1 = "ERROR â€“ Driver not found. " + e.getMessage();
            throw new RuntimeException(step1);
        }
    }

    // Step 2: Connect
    String url = "jdbc:mysql://localhost:3306/chocoaura?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    String user = "root";
    String pass = "";
    Connection con = null;
    try {
        con = DriverManager.getConnection(url, user, pass);
        step2 = "OK â€“ Connected to database 'chocoaura'.";
    } catch (SQLException e) {
        if (e.getMessage() != null && e.getMessage().contains("Unknown database")) {
            step2 = "Database 'chocoaura' does not exist. Creating it... ";
            try (Connection root = DriverManager.getConnection("jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", user, pass);
                 Statement st = root.createStatement()) {
                st.executeUpdate("CREATE DATABASE IF NOT EXISTS chocoaura");
                step2 += "Created. Connecting again... ";
                con = DriverManager.getConnection(url, user, pass);
                step2 += "OK â€“ Connected.";
            }
        } else {
            step2 = "ERROR â€“ " + e.getMessage();
            throw e;
        }
    }

    if (con == null) {
        step2 = "ERROR â€“ Could not get connection.";
    } else {
        // Step 3: Check users table
        try (Statement st = con.createStatement()) {
            st.executeQuery("SELECT 1 FROM users LIMIT 1");
            step3 = "OK â€“ Table 'users' exists.";
        } catch (SQLException e) {
            step3 = "ERROR â€“ Table 'users' missing or error: " + e.getMessage() + " Run database/setup.sql in MySQL.";
        }

        // Step 4: Try a test insert (then delete) to check write
        if (step3.startsWith("OK")) {
            try {
                String testEmail = "test_check_" + System.currentTimeMillis() + "@test.com";
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO users (full_name, email, password) VALUES (?,?,?)")) {
                    ps.setString(1, "Test");
                    ps.setString(2, testEmail);
                    ps.setString(3, "test");
                    ps.executeUpdate();
                }
                try (PreparedStatement del = con.prepareStatement("DELETE FROM users WHERE email = ?")) {
                    del.setString(1, testEmail);
                    del.executeUpdate();
                }
                step4 = "OK â€“ Insert/delete test passed. Registration should work.";
                allOk = true;
            } catch (SQLException e) {
                step4 = "ERROR â€“ " + e.getMessage();
            }
        }

        con.close();
    }
} catch (Exception e) {
    if (step1.isEmpty()) step1 = "ERROR â€“ " + e.getMessage();
    e.printStackTrace();
}
%>

<div class="box">
    <h2>Step 1: Driver</h2>
    <p class="<%= step1.startsWith("OK") ? "ok" : "err" %>"><%= step1 %></p>
</div>
<div class="box">
    <h2>Step 2: Connection</h2>
    <p class="<%= step2.startsWith("OK") || step2.contains("Created") ? "ok" : "err" %>"><%= step2 %></p>
</div>
<div class="box">
    <h2>Step 3: Users table</h2>
    <p class="<%= step3.startsWith("OK") ? "ok" : "err" %>"><%= step3 %></p>
</div>
<div class="box">
    <h2>Step 4: Write test</h2>
    <p class="<%= step4.startsWith("OK") ? "ok" : "err" %>"><%= step4 %></p>
</div>

<% if (allOk) { %>
<p><strong style="color:#51cf66;">All checks passed.</strong> Try <a href="register.jsp" style="color:#f5d48e;">Register</a> again.</p>
<% } else { %>
<p><strong style="color:#ff6b6b;">Fix the first ERROR shown above</strong>, then refresh this page or try registration again.</p>
<p>If Step 2 fails: start MySQL (XAMPP/WAMP). If you use a password, set it in <code>DBConnection.java</code> (PASSWORD constant).</p>
<p>If Step 3 fails: run <code>database/setup.sql</code> in MySQL.</p>
<% } %>

<p><a href="index.jsp" style="color:#f5d48e;">Back to Home</a></p>
</body>
</html>
