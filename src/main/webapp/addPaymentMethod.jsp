<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Payment Method | ChocoAura</title>

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
    padding-bottom:80px;
}

.wrapper{
    width:1100px;
    background:#1f0f0f;
    border-radius:22px;
    display:flex;
    box-shadow:0 30px 60px rgba(0,0,0,0.65);
    overflow:hidden;
}

.sidebar{
    width:300px;
    background:#2a1414;
    padding:35px 25px;
    color:#fff;
}

.sidebar h3{
    color:#f5d48e;
    margin-bottom:5px;
}

.sidebar p{
    font-size:13px;
    color:#ccc;
    margin-bottom:30px;
}

.menu a{
    display:flex;
    align-items:center;
    gap:12px;
    padding:12px 16px;
    margin-bottom:10px;
    color:#fff;
    text-decoration:none;
    border-radius:30px;
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
    padding:45px;
    color:#fff;
}

.content h2{
    color:#f5d48e;
    margin-bottom:30px;
}

.form-grid{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:22px;
}

.input-group{
    display:flex;
    flex-direction:column;
}

.input-group label{
    color:#f5d48e;
    font-size:14px;
    margin-bottom:6px;
}

.input-group input,
.input-group select{
    padding:13px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:#1f0f0f;
    color:#fff;
    outline:none;
}

.full{
    grid-column:1 / -1;
}

select{
    appearance:none;
    cursor:pointer;
}

select option{
    background:#2a1414;
    color:#fff;
}

select option:hover,
select option:checked{
    background:#f5d48e;
    color:#2a1414;
}

.btn-row{
    margin-top:35px;
    display:flex;
    gap:15px;
}

.save-btn{
    background:#f5d48e;
    border:none;
    color:#2a1414;
    padding:12px 36px;
    border-radius:30px;
    font-weight:600;
    cursor:pointer;
}

.save-btn:hover{
    background:#fff;
}

.cancel-btn{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
    padding:12px 30px;
    border-radius:30px;
    cursor:pointer;
}

.cancel-btn:hover{
    background:rgba(245,212,142,0.12);
}
</style>
</head>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=addPaymentMethod.jsp");
        return;
    }
    String uName = (String) sess.getAttribute("user_name");
    if (uName == null) uName = "User";
%>
<body>

<jsp:include page="header.jsp"/>

<div class="wrapper">

    <div class="sidebar">
        <h3><%= uName %></h3>
        <p>ChocoAura Customer</p>

        <div class="menu">
            <a href="profile.jsp"><i class="fa-regular fa-user"></i> Personal Information</a>
            <a href="orders.jsp"><i class="fa-solid fa-box"></i> My Orders</a>
            <a href="address.jsp"><i class="fa-solid fa-location-dot"></i> Manage Address</a>
            <a href="payment.jsp" class="active"><i class="fa-solid fa-credit-card"></i> Payment Method</a>
            <a href="changePassword.jsp"><i class="fa-solid fa-lock"></i> Password Manager</a>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>

    <div class="content">
        <h2>Add Payment Method</h2>
        <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
        <p style="color:#ff6b6b; margin-bottom:15px;"><%= err %></p>
        <% } %>
        <form action="addPayment" method="post">
            <div class="form-grid">

                <div class="input-group full">
                    <label>Card Holder Name</label>
                    <input type="text" name="card_holder" placeholder="Enter card holder name" required>
                </div>

                <div class="input-group full">
                    <label>Card Number</label>
                    <input type="text" name="card_number" placeholder="XXXX XXXX XXXX XXXX" required>
                </div>

                <div class="input-group">
                    <label>Expiry Month</label>
                    <input type="text" name="expiry_month" placeholder="MM">
                </div>

                <div class="input-group">
                    <label>Expiry Year</label>
                    <input type="text" name="expiry_year" placeholder="YYYY">
                </div>

                <div class="input-group">
                    <label>Card Type</label>
                    <select name="card_type">
                        <option value="Visa" selected>Visa</option>
                        <option value="MasterCard">MasterCard</option>
                        <option value="RuPay">RuPay</option>
                    </select>
                </div>

            </div>

            <div class="btn-row">
                <button type="button" class="cancel-btn"
                    onclick="location.href='payment.jsp'">
                    Cancel
                </button>
                <button type="submit" class="save-btn">
                    Save Payment Method
                </button>
            </div>
        </form>
    </div>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>

