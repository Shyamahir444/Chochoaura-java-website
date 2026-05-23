<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    boolean showPage = true;
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj != null) {
        sessionObj.invalidate();
    }
    response.sendRedirect("index.jsp");
    showPage = false;
%><% if (showPage) { %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body{
    background:#f5d48e;
    font-family:Poppins;
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
}

/* CARD */
.logout-card{
    background:#1f0f0f;
    width:550px;
    padding:40px;
    border-radius:18px;
    text-align:center;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
    margin-bottom:50px;
}

.logout-icon{
    width:90px;
    height:90px;
    border-radius:50%;
    background:#f5d48e;
    color:#2a1414;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:34px;
    margin:0 auto 20px;
}

.logout-card h2{
    color:#f5d48e;
    margin-bottom:10px;
}

.logout-card p{
    color:#ccc;
    font-size:14px;
    margin-bottom:30px;
}

.btn-group{
    display:flex;
    justify-content:center;
    gap:15px;
}

.btn{
    padding:12px 26px;
    border-radius:30px;
    font-size:14px;
    cursor:pointer;
    border:none;
}

.btn-login{
    background:#f5d48e;
    color:#2a1414;
    font-weight:600;
}

.btn-home{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
}

.btn-login:hover{
    background:#fff;
}
.btn-home:hover{
    background:rgba(245,212,142,0.1);
}
</style>
</head>

<body>
<jsp:include page="header.jsp"/>
<div class="logout-card">

    <div class="logout-icon">
        <i class="fa-solid fa-right-from-bracket"></i>
    </div>

    <h2>Youâ€™re Logged Out</h2>
    <p>
        You have been successfully logged out of your
        ChocoAura account.
    </p>

    <div class="btn-group">
        <button class="btn btn-login"
            onclick="location.href='login.jsp'">
            Login Again
        </button>

        <button class="btn btn-home"
            onclick="location.href='index.jsp'">
            Go to Home
        </button>
    </div>

</div>
<jsp:include page="footer1.jsp"/>
</body>
</html>
<% } %>

