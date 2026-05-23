<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<!DOCTYPE html>
<html>
<head><title>Debug Cart Table</title></head>
<body style="background:#f5d48e; padding:40px; font-family:sans-serif;">
    <h2>Raw Cart Table Contents</h2>
    <table style="border:1px solid black; background:#fff; border-collapse:collapse;">
        <thead>
            <tr>
                <th>id</th>
                <th>user_id</th>
                <th>product_id</th>
                <th>weight</th>
                <th>quantity</th>
                <th>added_at</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection con = DBConnection.getConnection();
                     Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM cart")) {
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getInt("product_id") %></td>
                <td><%= rs.getString("weight") %></td>
                <td><%= rs.getInt("quantity") %></td>
                <td><%= rs.getTimestamp("added_at") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
            %>
            <tr><td colspan="6" style="color:red;">Error: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
        </tbody>
    </table>
    <br>
    <a href="index.jsp">Back Home</a>
</body>
</html>
