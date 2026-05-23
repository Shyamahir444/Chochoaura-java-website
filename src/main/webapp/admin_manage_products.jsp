<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.chocoaura.DBConnection" %>

<%
    if ("delete".equals(request.getParameter("action"))) {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM products WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            } catch(Exception e) { e.printStackTrace(); }
            response.sendRedirect("admin_manage_products.jsp");
            return;
        }
    }
%>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Products | Admin</title>

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

.btn-add{
    background:#2a1414;
    color:#f5d48e;
    padding:10px 20px;
    border-radius:8px;
    text-decoration:none;
    font-weight:600;
    border:1px solid rgba(245,212,142,0.3);
    transition: 0.3s;
}

.btn-add:hover{
    background:#1f0f0f;
    color:#fff;
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

.admin-table img{
    width: 60px;
    height: 60px;
    object-fit:cover;
    border-radius:8px;
}

.action-btn{
    padding:6px 10px;
    border-radius:4px;
    text-decoration:none;
    font-size:14px;
    margin-right:5px;
    color:#fff;
}

.btn-edit{ background:#e6a022; }
.btn-delete{ background:#d9534f; }

.alert-msg{ padding:10px 15px; border-radius:8px; margin-bottom:15px; font-size:14px; text-align:center; background:#28a745; color:#fff; }
</style>
</head>
<body>
<jsp:include page="admin_header.jsp"/>

<div class="container">
    <% if(request.getParameter("msg") != null){ %><div class="alert-msg">Product <%= request.getParameter("msg") %> Successfully!</div><% } %>
    <div class="table-header">
        <h2>Manage Products</h2>
        <a href="admin_add_product.jsp" class="btn-add"><i class="fa-solid fa-plus"></i> Add Product</a>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM products ORDER BY id DESC")) {
                
                while(rs.next()){
        %>
            <tr>
                <td><img src="<%= rs.getString("image") %>" alt="Product"></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("category") %></td>
                <td>₹<%= String.format("%.2f", rs.getDouble("price")) %></td>
                <td>
                    <a class="action-btn btn-edit" href="admin_edit_product.jsp?id=<%= rs.getInt("id") %>"><i class="fa-solid fa-pen"></i></a>
                    <a class="action-btn btn-delete" href="admin_manage_products.jsp?action=delete&id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure you want to delete this product?');"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
        <%
                }
            }catch(Exception e){
                e.printStackTrace();
                out.println("<tr><td colspan='5'>Error loading products</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="admin_footer.jsp"/>
</body>
</html>
