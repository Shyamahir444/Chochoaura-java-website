<%
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login | ChocoAura</title>

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
    margin-bottom:8px;
}

.login-left p{
    font-size:14px;
    margin-bottom:35px;
}

.login-left p a{
    color:#f5d48e;
    text-decoration:none;
    font-weight:600;
}

.input-group{
    margin-bottom:20px;
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
}

.input-group input::placeholder{
    color:#ccc;
}

.options{
    display:flex;
    justify-content:space-between;
    align-items:center;
    font-size:13px;
    margin-bottom:25px;
}

.options a{
    color:#f5d48e;
    text-decoration:none;
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
        <h1>WELCOME BACK!</h1>
        <p>Don you have an account?
            <a href="register.jsp">Sign up</a>
        </p>

        <form action="LoginServlet" method="post">
            <% String from = request.getParameter("from"); if (from != null) { %>
            <input type="hidden" name="from" value="<%= from %>">
            <% } %>
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="input-group" style="color:#ff6b6b; font-size:13px; margin-bottom:12px;"><%= errorMsg %></div>
            <% } %>
            <div class="input-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="example@gmail.com" required>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="•••••••" required>
            </div>

            <div class="options">
                <label>
                    <input type="checkbox" name="remember"> Remember me
                </label>
                <a href="forgetPassword.jsp">Forgot password?</a>
            </div>

            <button type="submit" class="login-btn">Sign In</button>
        </form>
    </div>

    <div class="login-right">
        <div class="avatar">
            <img src="login.jpg" alt="Chocolate">
        </div>
    </div>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
