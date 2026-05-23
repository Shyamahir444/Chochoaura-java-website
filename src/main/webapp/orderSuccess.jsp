<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String orderId = request.getParameter("order_id");
    if (orderId == null || orderId.isEmpty()) orderId = "CA" + System.currentTimeMillis();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Successful | ChocoAura</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Poppins;
}
body{
    min-height:100vh;
    background:#f5d48e;
    display:flex;
    align-items:center;
    justify-content:center;
}

.success-box{
    width:420px;
    background:#1f0f0f;
    padding:40px;
    border-radius:20px;
    text-align:center;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
}

.check{
    width:90px;
    height:90px;
    border-radius:50%;
    border:4px solid #4caf50;
    margin:0 auto 20px;
    position:relative;
    animation:pop 0.6s ease;
}
.check:after{
    content:'';
    position:absolute;
    width:25px;
    height:50px;
    border-right:5px solid #4caf50;
    border-bottom:5px solid #4caf50;
    transform:rotate(45deg);
    left:28px;
    top:10px;
    animation:draw 0.5s ease forwards;
}
@keyframes pop{
    0%{transform:scale(0);}
    100%{transform:scale(1);}
}
@keyframes draw{
    0%{height:0;width:0;}
    100%{height:50px;width:25px;}
}

h2{
    color:#f5d48e;
    margin-bottom:10px;
}
p{
    font-size:14px;
    color:#ccc;
    margin-bottom:8px;
}
.order-id{
    color:#4caf50;
    font-weight:600;
    margin-bottom:25px;
    font-size:18px;
}

.btn{
    display:block;
    width:100%;
    padding:12px;
    border-radius:30px;
    font-weight:600;
    text-decoration:none;
    margin-bottom:12px;
}
.btn-orders{
    background:#f5d48e;
    color:#2a1414;
}
.btn-orders:hover{
    background:#fff;
}
.btn-shop{
    border:1px solid #f5d48e;
    color:#f5d48e;
}
.btn-shop:hover{
    background:rgba(245,212,142,0.15);
}
</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="success-box">

    <div class="check"></div>

    <h2>Order Placed Successfully!</h2>
    <p>Thank you for shopping with ChocoAura.</p>

    <div class="order-id">
        Order ID: <%= orderId %>
    </div>

    <a href="orders.jsp" class="btn btn-orders">
        View My Orders
    </a>

    <a href="index.jsp" class="btn btn-shop">
        Continue Shopping
    </a>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
