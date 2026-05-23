<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    String action = request.getParameter("action");
    String msg = "";
    String err = "";

    if ("add".equals(action)) {
        String catName = request.getParameter("categoryName");
        if (catName != null && !catName.trim().isEmpty()) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("INSERT INTO categories (name) VALUES (?)")) {
                ps.setString(1, catName.trim());
                ps.executeUpdate();
                msg = "Category added successfully!";
            } catch (Exception e) { err = "Error adding category: " + e.getMessage(); }
        }
    } else if ("edit".equals(action)) {
        String idStr = request.getParameter("id");
        String catName = request.getParameter("categoryName");
        if (idStr != null && catName != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("UPDATE categories SET name = ? WHERE id = ?")) {
                ps.setString(1, catName.trim());
                ps.setInt(2, Integer.parseInt(idStr));
                ps.executeUpdate();
                msg = "Category updated successfully!";
            } catch (Exception e) { err = "Error updating category: " + e.getMessage(); }
        }
    } else if ("delete".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM categories WHERE id = ?")) {
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                msg = "Category deleted successfully!";
            } catch (Exception e) { err = "Error deleting category: " + e.getMessage(); }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Categories | Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
*{ margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body{ background:#f5d48e; color:#fff; padding-top:100px; padding-bottom:60px; }
.container{ width:1200px; margin:auto; }
.header-row{ display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
.header-row h2{ color:#2a1414; font-size:28px; }
.alert-msg{ padding:10px 15px; border-radius:8px; margin-bottom:15px; font-size:14px; text-align:center; }
.success{ background:#28a745; color:#fff; }
.error{ background:#dc3545; color:#fff; }
.admin-table{ width:100%; border-collapse:collapse; background:#2a1414; border-radius:12px; overflow:hidden; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
.admin-table th, .admin-table td{ padding:15px; text-align:left; border-bottom:1px solid rgba(245,212,142,0.1); }
.admin-table th{ background:#1f0f0f; color:#f5d48e; }
.admin-table td{ color:#ccc; }
.action-btn{ padding:6px 12px; border-radius:4px; text-decoration:none; font-size:14px; color:#fff; border:none; cursor:pointer; margin-right:5px; }
.btn-edit{ background:#e6a022; }
.btn-delete{ background:#d9534f; }
.form-box{ background:#1f0f0f; padding:20px; border-radius:12px; margin-bottom:25px; border:1px solid rgba(245,212,142,0.3); }
.form-box h3{ color:#f5d48e; margin-bottom:15px; font-size:18px; }
.form-row{ display:flex; gap:10px; }
.form-row input{ flex:1; padding:10px 15px; border-radius:8px; border:1px solid #f5d48e; background:transparent; color:#fff; }
.btn-save{ background:#f5d48e; color:#2a1414; border:none; padding:10px 25px; border-radius:8px; font-weight:600; cursor:pointer; }
</style>
</head>
<body>
<jsp:include page="admin_header.jsp"/>
<div class="container">
    <% if(!msg.isEmpty()){ %><div class="alert-msg success"><%= msg %></div><% } %>
    <% if(!err.isEmpty()){ %><div class="alert-msg error"><%= err %></div><% } %>

    <div class="form-box" id="categoryForm">
        <h3 id="formTitle">Add New Category</h3>
        <form action="admin_manage_categories.jsp" method="POST">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="id" id="categoryId">
            <div class="form-row">
                <input type="text" name="categoryName" id="categoryName" placeholder="Enter Category Name" required>
                <button type="submit" class="btn-save" id="saveBtn">Add Category</button>
                <button type="button" class="btn-save" style="background:#666; color:#fff; display:none;" id="cancelBtn" onclick="resetForm()">Cancel</button>
            </div>
        </form>
    </div>

    <div class="header-row">
        <h2>Manage Categories</h2>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Category Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM categories ORDER BY id ASC")) {
                while(rs.next()){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
        %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td>
                    <button class="action-btn btn-edit" onclick="editCategory(<%= id %>, '<%= name.replace("'", "\\'") %>')"><i class="fa-solid fa-pen"></i></button>
                    <a class="action-btn btn-delete" href="admin_manage_categories.jsp?action=delete&id=<%= id %>" onclick="return confirm('Delete this category?');"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
        <%
                }
            } catch(Exception e){ out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>"); }
        %>
        </tbody>
    </table>
</div>
<script>
function editCategory(id, name) {
    document.getElementById('formTitle').innerText = "Edit Category";
    document.getElementById('formAction').value = "edit";
    document.getElementById('categoryId').value = id;
    document.getElementById('categoryName').value = name;
    document.getElementById('saveBtn').innerText = "Update Category";
    document.getElementById('cancelBtn').style.display = "block";
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
function resetForm() {
    document.getElementById('formTitle').innerText = "Add New Category";
    document.getElementById('formAction').value = "add";
    document.getElementById('categoryId').value = "";
    document.getElementById('categoryName').value = "";
    document.getElementById('saveBtn').innerText = "Add Category";
    document.getElementById('cancelBtn').style.display = "none";
}
</script>
<jsp:include page="admin_footer.jsp"/>
</body>
</html>
