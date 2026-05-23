<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=profile.jsp");
        return;
    }
    Integer userId = (Integer) sess.getAttribute("user_id");
    String userName = (String) sess.getAttribute("user_name");
    String userEmail = (String) sess.getAttribute("user_email");
    String address = "Not added";
    String phone = "Not added";
    String dob = "Not added";
    String profileImage = "default_user.jpg";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT address, phone, date_of_birth, profile_image FROM users WHERE id = ?")) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String a = rs.getString("address"); if (a != null && !a.isEmpty()) address = a;
            String p = rs.getString("phone");   if (p != null && !p.isEmpty()) phone = p;
            Date d = rs.getDate("date_of_birth"); if (d != null) dob = d.toString();
            String img = rs.getString("profile_image"); if (img != null && !img.isEmpty()) profileImage = img;
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile | ChocoAura</title>

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

.info{
    margin-bottom:18px;
}
.info label{
    color:#f5d48e;
    font-size:14px;
}
.info p{
    margin-top:5px;
}

.edit-btn{
    margin-top:30px;
    background:#f5d48e;
    color:#2a1414;
    border:none;
    padding:12px 30px;
    border-radius:30px;
    cursor:pointer;
}
.edit-btn:hover{
    background:#fff;
}

</style>
</head>

<body>
<jsp:include page="header.jsp"/>
    <div class="wrapper">

    <!-- SIDEBAR -->
    <div class="sidebar">

        <div class="profile-box">
            <img src="user_images/<%= profileImage %>?v=<%= System.currentTimeMillis() %>" 
                 onerror="this.src='profile.jpg'"
                 alt="Profile" style="object-fit:cover;">
            <h3><%= userName != null ? userName : "User" %></h3>
            <p>ChocoAura Customer</p>
        </div>

        <div class="menu">
            <a href="profile.jsp" class="active">
                <i class="fa-regular fa-user"></i> Personal Information
            </a>
            <a href="orders.jsp">
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
        <h2>Personal Information</h2>
        <% if ("1".equals(request.getParameter("updated"))) { %>
        <p style="color:#51cf66; margin-bottom:15px;">Profile updated successfully.</p>
        <% } %>
        <div class="info">
            <label>Name</label>
            <p><%= userName != null ? userName : "" %></p>
        </div>

        <div class="info">
            <label>Email</label>
            <p><%= userEmail != null ? userEmail : "" %></p>
        </div>

        <div class="info">
            <label>Address</label>
            <p><%= address %></p>
        </div>

        <div class="info">
            <label>Phone</label>
            <p><%= phone %></p>
        </div>

        <div class="info">
            <label>Date of Birth</label>
            <p><%= dob %></p>
        </div>

        <button class="edit-btn"
            onclick="location.href='editProfile.jsp'">
            Edit Profile
        </button>
    </div>

</div>
<jsp:include page="footer1.jsp"/>
</body>
</html>

