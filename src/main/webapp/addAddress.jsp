<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
    <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Address | ChocoAura</title>

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

select:focus{
    box-shadow:0 0 0 2px rgba(245,212,142,0.4);
}

.btn-row{
    margin-top:35px;
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

</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="wrapper">

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=addAddress.jsp");
        return;
    }
    String uName = (String) sess.getAttribute("user_name");
    if (uName == null) uName = "User";
%>
    <div class="sidebar">
        <h3><%= uName %></h3>
        <p>ChocoAura Customer</p>

        <div class="menu">
            <a href="profile.jsp"><i class="fa-regular fa-user"></i> Personal Information</a>
            <a href="orders.jsp"><i class="fa-solid fa-box"></i> My Orders</a>
            <a href="address.jsp" class="active"><i class="fa-solid fa-location-dot"></i> Manage Address</a>
            <a href="payment.jsp"><i class="fa-solid fa-credit-card"></i> Payment Method</a>
            <a href="changePassword.jsp"><i class="fa-solid fa-lock"></i> Password Manager</a>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>

    <div class="content">
        <h2>Add New Address</h2>
        <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
        <p style="color:#ff6b6b; margin-bottom:15px;"><%= err %></p>
        <% } %>
        <form action="saveAddress" method="post">
            <div class="form-grid">

                <div class="input-group">
                    <label>Full Name</label>
                    <input type="text" name="full_name" placeholder="Enter full name" required>
                </div>

                <div class="input-group">
                    <label>Mobile Number</label>
                    <input type="text" name="mobile" placeholder="+91 XXXXX XXXXX" required>
                </div>

                <div class="input-group full">
                    <label>Address</label>
                    <input type="text" name="address_line" placeholder="House no, Street, Area" required>
                </div>

                <div class="input-group">
                    <label>City</label>
                    <input type="text" name="city" placeholder="City" required>
                </div>

                <div class="input-group">
                    <label>State</label>
                    <input type="text" name="state" placeholder="State" required>
                </div>

                <div class="input-group">
                    <label>Pincode</label>
                    <input type="text" name="pincode" placeholder="Postal Code" required>
                </div>

                <div class="input-group">
                    <label>Address Type</label>
                    <select name="address_type">
                        <option value="Home" selected>Home</option>
                        <option value="Office">Office</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

            </div>

            <div class="btn-row">
                <button type="submit" class="save-btn">Save Address</button>
            </div>
        </form>
    </div>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>

