<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Resend OTP | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins', sans-serif;
}

body{
    min-height:100vh;
    background:#f5d48e;
    display:flex;
    align-items:center;
    justify-content:center;
    padding-bottom:70px;
}

.login-wrapper{
    width:900px;
    height:480px;
    background:#1f0f0f;
    border-radius:18px;
    display:flex;
    overflow:hidden;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
}

.login-left{
    width:55%;
    padding:45px;
    color:#fff;
}

.login-left h1{
    color:#f5d48e;
    letter-spacing:2px;
    margin-bottom:10px;
}

.login-left p{
    font-size:14px;
    margin-bottom:35px;
    color:#ccc;
}

.input-group{
    margin-bottom:25px;
}

.input-group label{
    font-size:14px;
    color:#f5d48e;
    display:block;
    margin-bottom:6px;
}
.input-group input{
    width:100%;
    padding:12px 14px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
    font-size:14px;
}
.input-group input::placeholder{
    color:#ccc;
}

.login-btn{
    width:100%;
    padding:12px;
    border-radius:30px;
    border:none;
    background:#f5d48e;
    color:#2a1414;
    font-size:15px;
    font-weight:600;
    cursor:pointer;
    transition:0.3s;
}

.login-btn:hover{
    background:#fff;
}

.back-link{
    margin-top:18px;
    text-align:center;
    font-size:13px;
}
.back-link a{
    color:#f5d48e;
    text-decoration:none;
}

.login-right{
    width:45%;
    background:linear-gradient(135deg,#f5d48e,#caa34a);
    display:flex;
    align-items:center;
    justify-content:center;
}

.avatar{
    width:260px;
    height:260px;
    border-radius:50%;
    background:#2a1414;
    overflow:hidden;
    box-shadow:0 18px 35px rgba(0,0,0,0.55);
    display:flex;
    align-items:center;
    justify-content:center;
}

.avatar img{
    width:100%;
    height:100%;
    object-fit:cover;
    border-radius:50%;
}

</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="login-wrapper">

    <div class="login-left">
        <h1>RESEND OTP</h1>
        <p>
            Enter your registered Email or Mobile number to receive a new OTP.
        </p>

        <form>
            <div class="input-group">
                <label>Email / Mobile</label>
                <input type="text" placeholder="example@gmail.com or +91 XXXXX XXXXX">
            </div>

            <button type="button" class="login-btn"
                onclick="location.href='verify_otp.jsp'">
                Resend OTP
            </button>

            <div class="back-link">
                <a href="verify_otp.jsp">â† Back to OTP Verification</a>
            </div>
        </form>
    </div>

    <div class="login-right">
        <div class="avatar">
            <img src="login.jpg" alt="Resend OTP">
        </div>
    </div>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
