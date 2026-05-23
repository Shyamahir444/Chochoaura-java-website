<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password | ChocoAura</title>

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

.form-box{
    max-width:450px;
}
.form-group{
    margin-bottom:20px;
    position:relative;
}
.form-group label{
    font-size:14px;
    color:#f5d48e;
    margin-bottom:6px;
    display:block;
}
.form-group input{
    width:100%;
    padding:12px 45px 12px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
}

.toggle{
    position:absolute;
    right:16px;
    top:38px;
    color:#f5d48e;
    cursor:pointer;
}

.btn-row{
    margin-top:30px;
    display:flex;
    gap:15px;
}
.btn-cancel{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
    padding:10px 25px;
    border-radius:30px;
    cursor:pointer;
}
.btn-save{
    background:#f5d48e;
    border:none;
    color:#2a1414;
    padding:10px 30px;
    border-radius:30px;
    font-weight:600;
    cursor:pointer;
}
.btn-save:hover{
    background:#fff;
}

</style>
</head>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=changePassword.jsp");
        return;
    }
    Integer userId = (Integer) sess.getAttribute("user_id");
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
            <a href="payment.jsp">
                <i class="fa-solid fa-credit-card"></i> Payment Method
            </a>
            <a href="changePassword.jsp" class="active">
                <i class="fa-solid fa-lock"></i> Password Manager
            </a>
            <a href="logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </div>

    </div>

    <div class="content">
        <h2>Change Password</h2>
        <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
        <p style="color:#ff6b6b; margin-bottom:15px;"><%= err %></p>
        <% } %>
        <% if ("1".equals(request.getParameter("success"))) { %>
        <p style="color:#51cf66; margin-bottom:15px;">Password updated successfully.</p>
        <% } %>
        <div class="form-box">

            <form action="changePassword" method="post">

                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" name="current_password" id="currentPwd" required>
                    <i class="fa-regular fa-eye toggle"
                        onclick="togglePwd('currentPwd',this)"></i>
                </div>

                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" name="new_password" id="newPwd" required min="6">
                    <i class="fa-regular fa-eye toggle"
                        onclick="togglePwd('newPwd',this)"></i>
                </div>

                <div class="form-group">
                    <label>Confirm New Password</label>
<input type="password" name="confirm_password" id="confirmPwd" required>                    <i class="fa-regular fa-eye toggle"
                        onclick="togglePwd('confirmPwd',this)"></i>
                </div>

                <div class="btn-row">
                    <button type="reset" class="btn-cancel">
                        Cancel
                    </button>
                    <button type="submit" class="btn-save">
                        Update Password
                    </button>
                </div>

            </form>

        </div>
    </div>

</div>

<script>
function togglePwd(id,icon){
    const input=document.getElementById(id);
    if(input.type==="password"){
        input.type="text";
        icon.classList.replace("fa-eye","fa-eye-slash");
    }else{
        input.type="password";
        icon.classList.replace("fa-eye-slash","fa-eye");
    }
}
</script>
<jsp:include page="footer1.jsp"/>
</body>
</html>

