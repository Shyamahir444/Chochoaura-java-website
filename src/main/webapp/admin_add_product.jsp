<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String err = request.getParameter("err");
    if (err == null) err = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product | Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
*{ margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body{ background:#f5d48e; color:#fff; padding-top:100px; padding-bottom:60px; }
.container{ width:800px; margin:auto; background:#1f0f0f; padding:40px; border-radius:18px; box-shadow:0 25px 50px rgba(0,0,0,0.5); }
h2{ color:#f5d48e; margin-bottom:25px; text-align:center; }
.form-group{ margin-bottom:20px; }
label{ display:block; color:#f5d48e; margin-bottom:8px; font-size:14px; }
input, select, textarea{ width:100%; padding:12px 15px; border-radius:30px; border:1px solid #f5d48e; background:transparent; color:#fff; outline:none; }
textarea{ height:100px; border-radius:15px; resize:none; }
.btn-save{ width:100%; padding:14px; border-radius:30px; border:none; background:#f5d48e; color:#2a1414; font-weight:600; cursor:pointer; margin-top:20px; }
.btn-back{ display:block; text-align:center; margin-top:20px; color:#ccc; text-decoration:none; font-size:14px; }
</style>
</head>
<body>
<jsp:include page="admin_header.jsp"/>
<div class="container">
    <h2>Add New Product</h2>
    <% if(!err.isEmpty()){ %><p style="color:#ff6b6b; margin-bottom:15px;"><%= err %></p><% } %>
    <form action="AddProductServlet" method="POST" enctype="multipart/form-data">
        <div class="form-group">
            <label>Product Name</label>
            <input type="text" name="name" required>
        </div>
        <div class="form-group">
            <label>Category</label>
            <select name="category">
                <%
                    try (Connection con = DBConnection.getConnection();
                         Statement st = con.createStatement();
                         ResultSet rs = st.executeQuery("SELECT name FROM categories ORDER BY name")) {
                        while(rs.next()){
                            out.print("<option value='"+rs.getString("name")+"'>"+rs.getString("name")+"</option>");
                        }
                    } catch(Exception e){}
                %>
            </select>
        </div>
        <div class="form-group">
            <label>Price (₹)</label>
            <input type="number" name="price" step="0.01" required>
        </div>
        <div class="form-group">
            <label>Product Image</label>
            <input type="file" name="image" accept="image/*">
        </div>
        <div class="form-group">
            <label>Description</label>
            <textarea name="description"></textarea>
        </div>
        <button type="submit" class="btn-save">Add Product</button>
        <a href="admin_manage_products.jsp" class="btn-back">Cancel and Go Back</a>
    </form>
</div>
<jsp:include page="admin_footer.jsp"/>
</body>
</html>
