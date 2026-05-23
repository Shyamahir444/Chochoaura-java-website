<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Method | ChocoAura</title>

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

.payment-grid{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:20px;
}

.payment-card{
    background:#2a1414;
    border-radius:16px;
    padding:22px;
    border:1px solid rgba(245,212,142,0.3);
}

.card-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:15px;
}
.card-type{
    display:flex;
    align-items:center;
    gap:10px;
    color:#f5d48e;
    font-weight:600;
}
.card-number{
    color:#ccc;
    font-size:14px;
}

.default-tag{
    font-size:12px;
    background:#f5d48e;
    color:#2a1414;
    padding:4px 10px;
    border-radius:20px;
}

.card-actions{
    margin-top:15px;
    display:flex;
    gap:10px;
}
.btn{
    padding:7px 16px;
    border-radius:25px;
    font-size:13px;
    cursor:pointer;
    border:none;
}
.btn-remove{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
}
.btn-set{
    background:#f5d48e;
    color:#2a1414;
}

.add-payment{
    margin-top:30px;
    background:#f5d48e;
    color:#2a1414;
    border:none;
    padding:12px 30px;
    border-radius:30px;
    font-weight:600;
    cursor:pointer;
}

</style>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=payment.jsp");
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
            <a href="orders.jsp">
                <i class="fa-solid fa-box"></i> My Orders
            </a>
            <a href="address.jsp">
                <i class="fa-solid fa-location-dot"></i> Manage Address
            </a>
            <a href="payment.jsp" class="active">
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
        <h2>Payment Method</h2>
        <% if ("1".equals(request.getParameter("added"))) { %>
        <p style="color:#51cf66; margin-bottom:15px;">Payment method added.</p>
        <% } %>
        <% if ("1".equals(request.getParameter("deleted"))) { %>
        <p style="color:#51cf66; margin-bottom:15px;">Payment method removed.</p>
        <% } %>
        <div class="payment-grid">

            <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id, card_holder, card_last_four, card_type, is_default FROM payment_methods WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String holder = rs.getString("card_holder");
                    String last4 = rs.getString("card_last_four");
                    String ctype = rs.getString("card_type");
                    int isDef = rs.getInt("is_default");
                    String icon = "fa-cc-visa";
                    if (ctype != null && ctype.toLowerCase().contains("master")) icon = "fa-cc-mastercard";
            %>
            <div class="payment-card">
                <div class="card-header">
                    <div class="card-type">
                        <i class="fa-brands <%= icon %>"></i> <%= ctype != null ? ctype : "Card" %>
                    </div>
                    <% if (isDef == 1) { %><span class="default-tag">Default</span><% } %>
                </div>
                <div class="card-number">
                    **** **** **** <%= last4 != null ? last4 : "****" %>
                </div>
                <div class="card-actions">
                    <a href="deletePayment?id=<%= id %>" class="btn btn-remove" onclick="return confirm('Remove this card?');">Remove</a>
                </div>
            </div>
            <%
                }
            } catch (Exception e) { e.printStackTrace(); }
            %>

        </div>

         <button class="add-payment" onclick="location.href='addPaymentMethod.jsp'">
             + Add New Payment Method
         </button>
    </div>

</div>
<jsp:include page="footer1.jsp"/>
</body>
</html>

