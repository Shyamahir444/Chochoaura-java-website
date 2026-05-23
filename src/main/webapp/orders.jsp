<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body{
    background:#f5d48e;
    font-family:Poppins;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;
}

.wrapper{
    width:1100px;
    background:#1f0f0f;
    border-radius:18px;
    display:flex;
    overflow:hidden;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
    margin-bottom:50px;
}

.sidebar{
    width:300px;
    background:#2a1414;
    padding:30px;
}

.profile-box{
    text-align:center;
    margin-bottom:30px;
}
.profile-box img{
    width:110px;
    border-radius:50%;
}
.profile-box h3{
    color:#f5d48e;
    margin-top:12px;
}
.profile-box p{
    color:#ccc;
    font-size:13px;
}

.menu a{
    display:flex;
    align-items:center;
    gap:12px;
    padding:12px 18px;
    margin-bottom:12px;
    border-radius:30px;
    text-decoration:none;
    color:#fff;
    transition:0.3s;
}
.menu a i{
    color:#f5d48e;
}
.menu a.active,
.menu a:hover{
    background:#f5d48e;
    color:#2a1414;
}
.menu a.active i,
.menu a:hover i{
    color:#2a1414;
}

.content{
    flex:1;
    padding:40px;
    color:#fff;
}
.content h2{
    color:#f5d48e;
    margin-bottom:25px;
}

.order-card{
    background:#2a1414;
    border-radius:16px;
    padding:22px;
    margin-bottom:20px;
    border:1px solid rgba(245,212,142,0.3);
}

.order-header{
    display:flex;
    justify-content:space-between;
    margin-bottom:15px;
}
.order-id{
    color:#f5d48e;
    font-weight:600;
}
.order-status{
    font-size:13px;
    padding:6px 14px;
    border-radius:20px;
    background:#f5d48e;
    color:#2a1414;
    font-weight:600;
}

.order-body{
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:15px;
}
.order-info p{
    font-size:14px;
    margin-bottom:4px;
}
.order-info span{
    color:#ccc;
    font-size:13px;
}

.order-actions{
    display:flex;
    gap:10px;
}
.btn{
    padding:8px 18px;
    border-radius:25px;
    font-size:13px;
    cursor:pointer;
    border:none;
}
.btn-view{
    background:#f5d48e;
    color:#2a1414;
}
.btn-cancel{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
}

</style>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=orders.jsp");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
    String uName = (String) sess.getAttribute("user_name");
    if (uName == null) uName = "User";
    String profileImage = (String) sess.getAttribute("user_image");
    if (profileImage == null || profileImage.isEmpty()) {
        try (Connection conImg = DBConnection.getConnection();
             PreparedStatement psImg = conImg.prepareStatement("SELECT profile_image FROM users WHERE id = ?")) {
            psImg.setInt(1, userId);
            ResultSet rsImg = psImg.executeQuery();
            if (rsImg.next()) {
                profileImage = rsImg.getString("profile_image");
                if (profileImage != null && !profileImage.isEmpty()) sess.setAttribute("user_image", profileImage);
            }
        } catch (Exception e) {}
    }
    if (profileImage == null || profileImage.isEmpty()) profileImage = "default_user.jpg";
%>
</head>

<body>
<jsp:include page="header.jsp"/>
<div class="wrapper">

    <div class="sidebar">

        <div class="profile-box">
            <img src="user_images/<%= profileImage %>?v=<%= System.currentTimeMillis() %>" 
                 onerror="this.src='profile.jpg'" 
                 alt="Profile" style="width:110px; height:110px; border-radius:50%; object-fit:cover;">
            <h3><%= uName %></h3>
            <p>ChocoAura Customer</p>
        </div>

        <div class="menu">
            <a href="profile.jsp">
                <i class="fa-regular fa-user"></i> Personal Information
            </a>
            <a href="orders.jsp" class="active">
                <i class="fa-solid fa-box"></i> My Orders
            </a>
            <a href="address.jsp">
                <i class="fa-solid fa-location-dot"></i> Manage Address
            </a>
            <a href="payment.jsp">
                <i class="fa-solid fa-credit-card"></i> Payment Method
            </a>
            <a href="changePassword.jsp">
                <i class="fa-solid fa-lock"></i> Password Manager
            </a>
            <a href="logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </div>

    </div>

    <div class="content">
        <h2>My Orders</h2>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT id, order_number, total_amount, status, created_at FROM orders WHERE user_id = ? ORDER BY created_at DESC")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
            while (rs.next()) {
                String orderNum = rs.getString("order_number");
                double total = rs.getDouble("total_amount");
                String status = rs.getString("status");
                java.util.Date created = rs.getTimestamp("created_at");
                String dateStr = created != null ? sdf.format(created) : "";
        %>
        <div class="order-card">
            <div class="order-header">
                <div class="order-id">Order #<%= orderNum %></div>
                <div class="order-status"><%= status != null ? status : "Placed" %></div>
            </div>
            <div class="order-body">
                <div class="order-info">
                    <p>Order Date: <%= dateStr %></p>
                    <span>Total: ₹<%= String.format("%.0f", total) %></span>
                </div>
            </div>
        </div>
        <%
            }
        } catch (Exception e) { e.printStackTrace(); }
        %>

    </div>

</div>
<jsp:include page="footer1.jsp"/>
</body>
</html>

