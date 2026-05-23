<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password | ChocoAura</title>

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
    width:1050px;
    height:560px;
    background:#1f0f0f;
    border-radius:18px;
    display:flex;
    overflow:hidden;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
    margin-bottom:50px;
}

.login-left{
    width:60%;
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
}

.login-left a{
    color:#f5d48e;
    text-decoration:none;
    font-weight:600;
}

.recovery-options{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:15px;
    margin-bottom:25px;
}

.option-card{
    border:1px solid #f5d48e;
    border-radius:14px;
    padding:16px;
    display:flex;
    align-items:center;
    gap:12px;
    cursor:pointer;
    transition:0.3s;
}

.option-card i{
    font-size:22px;
    color:#f5d48e;
}

.option-card h4{
    font-size:14px;
    color:#fff;
    margin:0;
}

.option-card:hover{
    background:#f5d48e;
}

.option-card:hover i,
.option-card:hover h4{
    color:#2a1414;
}

.form-box{
    display:none;
}

.input-group{
    margin-bottom:18px;
}

.input-group label{
    font-size:14px;
    color:#f5d48e;
    display:block;
    margin-bottom:6px;
}

.input-group input,
.security-select,
.country-select{
    width:100%;
    padding:12px 14px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;              
    font-size:14px;
}

.input-group input:focus,
.security-select:focus,
.country-select:focus{
    border-color:#f5d48e;
    box-shadow:0 0 0 2px rgba(245,212,142,0.4);
    outline:none;
}

.input-group input::placeholder{
    color:#ccc;
}

.security-select option,
.country-select option{
    background:#2a1414;
    color:#fff;
}

.mobile-row{
    display:flex;
    gap:10px;
}

.country-select{
    width:35%;
}

.mobile-input{
    width:65%;
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

.login-right{
    width:40%;
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
        <h1>FORGOT PASSWORD</h1>
        <p>Select a recovery option</p>

        <div class="recovery-options">
            <div class="option-card" onclick="showForm('email')">
                <i class="fa-regular fa-envelope"></i>
                <h4>Email OTP</h4>
            </div>

            <div class="option-card" onclick="showForm('mobile')">
                <i class="fa-solid fa-mobile-screen"></i>
                <h4>Mobile OTP</h4>
            </div>

            <div class="option-card" onclick="showForm('security')">
                <i class="fa-solid fa-shield-halved"></i>
                <h4>Security Question</h4>
            </div>
        </div>

        <form id="emailForm" class="form-box" style="display:block;">
            <div class="input-group">
                <label>Email Address</label>
                <input type="email" placeholder="example@gmail.com">
            </div>
            <button type="button" class="login-btn"
                onclick="location.href='verify_otp.jsp'">
                Send Email OTP
            </button>
        </form>

        <form id="mobileForm" class="form-box">
            <div class="input-group">
                <label>Mobile Number</label>
                <div class="mobile-row">
                    <select class="country-select">
                        <option selected>ðŸ‡®ðŸ‡³ +91</option>
                        <option>ðŸ‡ºðŸ‡¸ +1</option>
                        <option>ðŸ‡¬ðŸ‡§ +44</option>
                        <option>ðŸ‡¦ðŸ‡º +61</option>
                        <option>ðŸ‡¦ðŸ‡ª +971</option>
                    </select>
                    <input class="mobile-input" type="text"
                        placeholder="Enter mobile number">
                </div>
            </div>
            <button type="button" class="login-btn"
                onclick="location.href='verify_otp.jsp'">
                Send Mobile OTP
            </button>
        </form>

        <form id="securityForm" class="form-box">
            <div class="input-group">
                <label>Select Security Question</label>
                <select class="security-select">
                    <option value="">-- Select a question --</option>
                    <option>What is your favorite chocolate?</option>
                    <option>What is the name of your first school?</option>
                    <option>What is your childhood friend name?</option>
                    <option>What is your favorite food?</option>
                    <option>What city were you born in?</option>
                </select>
            </div>

            <div class="input-group">
                <label>Your Answer</label>
                <input type="text" placeholder="Enter your answer">
            </div>

            <button type="button" class="login-btn"
                onclick="location.href='resetPassword.jsp'">
                Verify Answer
            </button>
        </form>

        <p style="margin-top:20px;">
            <a href="login.jsp">â† Back to Login</a>
        </p>
    </div>

    <div class="login-right">
        <div class="avatar">
            <img src="login.jpg" alt="User">
        </div>
    </div>

</div>

<script>
function showForm(type){
    emailForm.style.display = "none";
    mobileForm.style.display = "none";
    securityForm.style.display = "none";

    if(type==="email") emailForm.style.display="block";
    if(type==="mobile") mobileForm.style.display="block";
    if(type==="security") securityForm.style.display="block";
}
</script>
<jsp:include page="footer1.jsp"/>
</body>
</html>
