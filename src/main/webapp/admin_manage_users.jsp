<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.chocoaura.DBConnection" %>

<%
    if ("delete".equals(request.getParameter("action"))) {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            } catch(Exception e) {}
            response.sendRedirect("admin_manage_users.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Users | Admin</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
}

body{
    background:#f5d48e;
    color:#fff;
    padding-top:100px;
    padding-bottom:60px;
}

.container{
    width:1200px;
    margin:auto;
}

.table-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
}

.table-header h2{
    color:#2a1414;
    font-size:28px;
}

.admin-table{
    width:100%;
    border-collapse:collapse;
    background:#2a1414;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);
}

.admin-table th, .admin-table td{
    padding:15px;
    text-align:left;
    border-bottom:1px solid rgba(245,212,142,0.1);
}

.admin-table th{
    background:#1f0f0f;
    color:#f5d48e;
    font-weight:600;
}

.admin-table td{
    color:#ccc;
}

.action-btn{
    padding:6px 10px;
    border-radius:4px;
    text-decoration:none;
    font-size:14px;
    margin-right:5px;
    color:#fff;
}

.btn-delete{ background:#d9534f; }

</style>
</head>
<body>
<jsp:include page="admin_header.jsp"/>

<div class="container">
    <div class="table-header">
        <h2>Manage Users</h2>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Registered Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM users ORDER BY id DESC")) {
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                
                while(rs.next()){
                    Timestamp ts = rs.getTimestamp("created_at");
                    String dateStr = (ts != null) ? sdf.format(ts) : "N/A";
        %>
            <tr>
                <td>#<%= rs.getInt("id") %></td>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                <td><%= dateStr %></td>
                <td>
                    <a class="action-btn btn-delete" href="admin_manage_users.jsp?action=delete&id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure you want to delete this user?');"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
        <%
                }
            }catch(Exception e){
                out.println("<tr><td colspan='6'>Error loading users</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="admin_footer.jsp"/>
</body>
</html>
