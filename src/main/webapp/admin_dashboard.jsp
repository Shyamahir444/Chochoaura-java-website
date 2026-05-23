<%@page import="com.chocoaura.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | ChocoAura</title>

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
    padding-top:80px;
    padding-bottom:60px; /* Space for footer */
}

.container{
    width:1200px;
    margin:auto;
}

.hero{
    margin-top:60px;
    background:#1f0f0f;
    padding:40px 60px;
    border-radius:26px;
    text-align: center;
}

.hero h1{
    font-size:42px;
    color:#f5d48e;
    line-height:1.2;
}

.hero p{
    color:#ccc;
    margin:15px 0 25px;
    font-size: 16px;
}

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    margin-top:40px;
}

.stats div{
    background:#2a1414;
    padding:30px 20px;
    border-radius:18px;
    text-align:center;
    border:1px solid rgba(245,212,142,0.3);
    transition: transform 0.3s ease;
}

.stats div:hover{
    transform: translateY(-5px);
    border-color: #f5d48e;
}

.stats i{
    font-size: 32px;
    color:#f5d48e;
    margin-bottom: 15px;
}

.stats strong{
    display:block;
    font-size:32px;
    color:#fff;
}

.stats span{
    color:#ccc;
    font-size:16px;
    font-weight: 500;
}

.section{
    margin-top:60px;
}

.section h2{
    color:#2a1414;
    font-size:28px;
    margin-bottom:20px;
}

.card{
    background:#2a1414;
    padding:30px;
    border-radius:22px;
    border:1px solid rgba(245,212,142,0.3);
    color: #fff;
}

.card a{
    color:#f5d48e;
    text-decoration: none;
    font-weight: 500;
}

.card a:hover{
    text-decoration: underline;
}

.quick-links{
    display:flex;
    gap:20px;
    flex-wrap: wrap;
}

.quick-links a{
    background:#1f0f0f;
    padding:15px 25px;
    border-radius:12px;
    color:#f5d48e;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:10px;
    border:1px solid rgba(245,212,142,0.3);
    transition: 0.3s;
}

.quick-links a:hover{
    background:#f5d48e;
    color:#2a1414;
}
</style>
</head>

<body>
<jsp:include page="admin_header.jsp"/>

<div class="container">

<section class="hero">
    <h1>Welcome Admin 👋</h1>
    <p>Get a quick overview of ChocoAura's performance and manage your store.</p>
</section>

<%
    int totalUsers = 0;
    int totalProducts = 0;
    int totalOrders = 0;
    double totalRevenue = 0.0;
    
    try (Connection con = DBConnection.getConnection();
         Statement stmt = con.createStatement()) {
        
        try (ResultSet rs = stmt.executeQuery("SELECT count(*) FROM users")) {
            if(rs.next()) totalUsers = rs.getInt(1);
        }
        
        try (ResultSet rs = stmt.executeQuery("SELECT count(*) FROM products")) {
            if(rs.next()) totalProducts = rs.getInt(1);
        }
        
        try (ResultSet rs = stmt.executeQuery("SELECT count(*) FROM orders")) {
            if(rs.next()) totalOrders = rs.getInt(1);
        }
        
        try (ResultSet rs = stmt.executeQuery("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'Cancelled'")) {
            if(rs.next()) totalRevenue = rs.getDouble(1);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="stats">
    <div>
        <i class="fa-solid fa-users"></i>
        <strong><%= totalUsers %></strong>
        <span>Registered Users</span>
    </div>
    <div>
        <i class="fa-solid fa-box-open"></i>
        <strong><%= totalProducts %></strong>
        <span>Products Available</span>
    </div>
    <div>
        <i class="fa-solid fa-cart-shopping"></i>
        <strong><%= totalOrders %></strong>
        <span>Total Orders</span>
    </div>
    <div>
        <i class="fa-solid fa-indian-rupee-sign"></i>
        <strong><%= String.format("%.2f", totalRevenue) %></strong>
        <span>Total Revenue (₹)</span>
    </div>
</div>

<section class="section">
    <h2>Quick Actions</h2>
    <div class="quick-links">
        <a href="admin_manage_products.jsp"><i class="fa-solid fa-plus"></i> Add New Product</a>
        <a href="admin_manage_orders.jsp"><i class="fa-solid fa-truck-fast"></i> View Recent Orders</a>
        <a href="admin_manage_users.jsp"><i class="fa-solid fa-user-pen"></i> Manage Customers</a>
    </div>
</section>

</div>

<jsp:include page="admin_footer.jsp"/>

</body>
</html>
