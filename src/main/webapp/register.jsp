<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register | ChocoAura</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    *{ margin:0; padding:0; box-sizing:border-box; font-family:'Poppins', sans-serif; }
    
    body{ 
        background:#f5d48e; 
        min-height:100vh; 
        display:flex; 
        flex-direction:column; 
    }

    .main-content {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 0;
    }

    .register-wrapper{
        width:950px;
        background:#1f0f0f;
        border-radius:18px;
        display:flex;
        overflow:hidden;
        box-shadow:0 25px 50px rgba(0,0,0,0.6);
    }

    .register-left{
        width:60%;
        padding:40px;
        color:#fff;
    }

    .register-left h1{ color:#f5d48e; letter-spacing:2px; margin-bottom:8px; }
    .register-left p{ font-size:14px; margin-bottom:25px; }
    .register-left p a{ color:#f5d48e; text-decoration:none; font-weight:600; }

    .input-group{ margin-bottom:15px; }
    .input-group label{ font-size:13px; color:#f5d48e; display:block; margin-bottom:5px; }
    .input-group input{ width:100%; padding:10px 14px; border-radius:30px; border:1px solid #f5d48e; background:transparent; color:#fff; outline:none; font-size:14px; }
    .input-group input::placeholder{ color:#ccc; }

    .register-btn{ width:100%; padding:12px; border-radius:30px; border:none; background:#f5d48e; color:#2a1414; font-size:15px; font-weight:600; cursor:pointer; margin-top:10px; }
    .register-btn:hover{ background:#fff; }

    .register-right{ width:40%; background:linear-gradient(135deg,#f5d48e,#caa34a); display:flex; align-items:center; justify-content:center; }
    .avatar{ width:260px; height:260px; border-radius:50%; background:#2a1414; overflow:hidden; box-shadow:0 18px 35px rgba(0,0,0,0.55); display:flex; align-items:center; justify-content:center; }
    .avatar img{ width:100%; height:100%; object-fit:cover; }

    .form-row { display: flex; gap: 15px; }
    .form-row .input-group { flex: 1; }
</style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="main-content">
    <div class="register-wrapper">

        <div class="register-left">
            <h1>CREATE ACCOUNT</h1>
            <p>Already have an account? <a href="login.jsp">Sign in</a></p>

        <% String error = request.getParameter("error"); 
           if(error != null) { %>
            <div style="color:#ff6b6b; font-size:13px; margin-bottom:15px;"><%= error %></div>
        <% } %>

        <form action="RegisterServlet" method="POST" enctype="multipart/form-data">
            
            <div class="input-group">
                <label>Full Name</label>
                <input type="text" name="full_name" placeholder="John Doe" required>
            </div>
            
            <div class="form-row">
                <div class="input-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="example@gmail.com" required>
                </div>
                <div class="input-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢" required>
                </div>
            </div>

            <div class="input-group">
                <label>Address</label>
                <input type="text" name="address" placeholder="City, State">
            </div>

            <div class="form-row">
                <div class="input-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" placeholder="+91 XXXXX XXXXX">
                </div>
                <div class="input-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob">
                </div>
            </div>
            
            <div class="input-group">
                <label>Profile Picture</label>
                <input type="file" name="profile_pic" accept="image/*" style="padding: 6px 14px; border-radius: 10px;">
            </div>

            <button type="submit" class="register-btn">Register</button>
        </form>
    </div>

    <div class="register-right">
        <div class="avatar">
            <img src="login.jpg" alt="Chocolate">
        </div>
    </div>

</div>
</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
