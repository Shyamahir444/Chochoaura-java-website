<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=cart_payment.jsp");
        return;
    }
    String addressIdParam = request.getParameter("address_id");
    if (addressIdParam == null || addressIdParam.isEmpty()) {
        response.sendRedirect("checkout.jsp?error=Please select an address.");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    box-sizing:border-box;
    font-family:Poppins;
}
body{
    background:#f5d48e;
    margin:0;
}

.payment-wrapper{
    max-width:900px;
    margin:50px auto 90px;
    background:#1f0f0f;
    color:#fff;
    border-radius:20px;
    padding:40px;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
    margin-bottom:50px;
}

h2{
    text-align:center;
    color:#f5d48e;
    margin-bottom:30px;
}

.options{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:18px;
    margin-bottom:25px;
}

.option-card{
    border:1px solid #f5d48e;
    border-radius:16px;
    padding:20px;
    text-align:center;
    cursor:pointer;
    transition:0.3s;
}

.option-card i{
    font-size:26px;
    color:#f5d48e;
    margin-bottom:10px;
}

.option-card h4{
    font-size:15px;
    margin:0;
}

.option-card.active,
.option-card:hover{
    background:#f5d48e;
    color:#2a1414;
}

.option-card.active i,
.option-card:hover i{
    color:#2a1414;
}

.payment-box{
    display:none;
    margin-top:25px;
}

.payment-box input{
    width:100%;
    padding:12px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    margin-bottom:15px;
}

.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:15px;
}

.pay-btn{
    margin-top:30px;
    width:100%;
    padding:14px;
    border:none;
    border-radius:30px;
    background:#f5d48e;
    color:#2a1414;
    font-weight:600;
    cursor:pointer;
}

.pay-btn:hover{
    background:#fff;
}

</style>

<script>
function selectPayment(type){
    // remove active
    document.querySelectorAll(".option-card").forEach(c=>c.classList.remove("active"));
    document.getElementById("cardBox").style.display="none";
    document.getElementById("upiBox").style.display="none";

    // add active
    document.getElementById(type).classList.add("active");

    if(type==="card"){
        document.getElementById("cardBox").style.display="block";
    }
    if(type==="upi"){
        document.getElementById("upiBox").style.display="block";
    }
}
</script>

</head>

<body>

<jsp:include page="header.jsp"/>

<div class="payment-wrapper">

    <h2>Select Payment Method</h2>

    <form action="placeOrder" method="post">
        <input type="hidden" name="address_id" value="<%= addressIdParam %>">
        <div class="form-group" style="margin-bottom:20px;">
            <label>Saved cards</label>
            <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id, card_holder, card_last_four, card_type FROM payment_methods WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String holder = rs.getString("card_holder");
                    String last4 = rs.getString("card_last_four");
                    String ctype = rs.getString("card_type");
            %>
            <label style="display:flex; align-items:center; gap:10px; margin-bottom:10px; cursor:pointer;">
                <input type="radio" name="payment_id" value="<%= id %>">
                <span>**** **** **** <%= last4 %> (<%= ctype %>) - <%= holder %></span>
            </label>
            <%
                }
            } catch (Exception e) { e.printStackTrace(); }
            %>
            <label style="display:flex; align-items:center; gap:10px; margin-bottom:10px; cursor:pointer;">
                <input type="radio" name="payment_id" value="" checked>
                <span>Cash on Delivery</span>
            </label>
        </div>
        <button type="submit" class="pay-btn">Place Order</button>
    </form>
    <p style="text-align:center; margin-top:15px;"><a href="checkout.jsp" style="color:#f5d48e;">&larr; Back to Address</a></p>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>

