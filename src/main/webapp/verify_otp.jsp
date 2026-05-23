<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Verify OTP | ChocoAura</title>

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
    margin-bottom:25px;
    color:#ccc;
}

.input-group{
    margin-bottom:20px;
}

.input-group input{
    width:100%;
    padding:12px 14px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
    font-size:18px;
    text-align:center;
    letter-spacing:6px;
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
}

.login-btn:hover{
    background:#fff;
}

.resend{
    margin-top:15px;
    text-align:center;
    font-size:13px;
}

.resend a{
    color:#f5d48e;
    text-decoration:none;
}

.error{
    color:red;
    margin-bottom:10px;
    text-align:center;
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
    overflow:hidden;
}

.avatar img{
    width:100%;
    height:100%;
    object-fit:cover;
}
</style>
</head>

<body>

<div class="login-wrapper">

    <div class="login-left">
        <h1>OTP VERIFICATION</h1>
        <p>Enter the OTP sent to your email.</p>

        <!-- ✅ ERROR MESSAGE -->
        <%
            String error = request.getParameter("error");
            if(error != null){
        %>
            <div class="error"><%= error %></div>
        <%
            }
        %>

        <!-- ✅ SUCCESS MESSAGE -->
        <%
            String success = request.getParameter("success");
            if(success != null){
        %>
            <div style="color:#51cf66; margin-bottom:10px; text-align:center;"><%= success %></div>
        <%
            }
        %>

        <!-- ✅ CORRECT FORM -->
        <form action="VerifyOtpServlet" method="post">

            <div class="input-group">
                <input type="text" name="otp" placeholder="● ● ● ● ● ●" maxlength="6" required>
            </div>

            <button type="submit" class="login-btn">
                Verify OTP
            </button>

            <div class="resend">
                Didn't receive OTP?
                <a href="ResendOtpServlet">Resend OTP</a>
            </div>

        </form>
    </div>

    <div class="login-right">
        <div class="avatar">
            <img src="login.jpg" alt="OTP">
        </div>
    </div>

</div>

</body>
</html>