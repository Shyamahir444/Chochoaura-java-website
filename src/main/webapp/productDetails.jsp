<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
String idParam = request.getParameter("id");
String name = "";
String price = "₹0";
String img = "product1.jpg";
String desc = "";
int productId = 0;

if (idParam != null && !idParam.isEmpty()) {
    try {
        productId = Integer.parseInt(idParam);
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT id, name, description, price, image FROM products WHERE id = ?")) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                desc = rs.getString("description");
                if (desc == null) desc = "";
                double p = rs.getDouble("price");
                price = "₹" + String.format("%.0f", p);
                String im = rs.getString("image");
                if (im != null) img = im;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product Details | ChocoAura</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body{
    background:#f5d48e;
    font-family:Poppins;
}

.details-wrapper{
    max-width:1100px;
    margin:150px auto 90px;
    background:#1f0f0f;
    color:#fff;
    padding:35px;
    border-radius:18px;
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:40px;
}

.main-img img{
    width:100%;
    border-radius:16px;
    height:300px;
    object-fit:cover;
}

.info h2{
    color:#f5d48e;
    margin-bottom:10px;
}
.rating{
    color:#ffc107;
    margin-bottom:10px;
}
.price{
    font-size:22px;
    font-weight:600;
    color:#f5d48e;
    margin-bottom:15px;
}
.info p{
    font-size:14px;
    line-height:1.7;
    margin-bottom:20px;
}

.size button{
    padding:6px 14px;
    border-radius:20px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    margin-right:10px;
    cursor:pointer;
    transition: 0.3s;
}
.size button:hover, .size button.active {
    background:#f5d48e;
    color:#2a1414;
    font-weight: 600;
}

.actions{
    margin-top:25px;
}
.actions a{
    padding:10px 25px;
    border-radius:25px;
    text-decoration:none;
    margin-right:15px;
    font-weight:600;
}
.cart{
    background:#f5d48e;
    color:#2a1414;
}
.buy{
    border:1px solid #f5d48e;
    color:#f5d48e;
}
</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="details-wrapper">

    <div class="main-img">
        <img src="<%= img %>">
    </div>

    <div class="info">
        <h2><%= name %></h2>

        <div class="rating">
            
        </div>

        <div class="price"><%= price %></div>

        <p><%= desc %></p>

        <strong>Weight</strong><br><br>
        <div class="size">
            <button class="weight-btn" onclick="selectWeight(this, '250g')">250g</button>
            <button class="weight-btn" onclick="selectWeight(this, '500g')">500g</button>
            <button class="weight-btn" onclick="selectWeight(this, '1kg')">1kg</button>
        </div>

        <div class="actions">
            <% if (productId > 0) { %>
            <a href="#" onclick="return submitAction('cart_handler.jsp?action=add&id=<%= productId %>')" class="cart">Add to Cart</a>
            <a href="#" onclick="return submitAction('cart_handler.jsp?action=wishlist_add&id=<%= productId %>')" class="buy">Add to Wishlist</a>
            <a href="#" onclick="return submitAction('checkout.jsp')" class="buy">Buy Now</a>
            <% } %>
        </div>
    </div>

</div>

<script>
    let selectedWeight = null;

    function selectWeight(btnElement, weightVal) {
        // Remove active class from all buttons
        const buttons = document.querySelectorAll('.weight-btn');
        buttons.forEach(b => b.classList.remove('active'));
        
        // Add active class to clicked button
        btnElement.classList.add('active');
        selectedWeight = weightVal;
    }

    function submitAction(baseUrl) {
        if (!selectedWeight) {
            alert("Please select a weight first.");
            return false;
        }
        
        if (baseUrl.includes('checkout.jsp')) {
            window.location.href = baseUrl + (baseUrl.includes('?') ? '&' : '?') + "weight=" + selectedWeight;
            return false;
        }

        let separator = baseUrl.includes('?') ? '&' : '?';
        let finalUrl = baseUrl + separator + "weight=" + encodeURIComponent(selectedWeight) + "&ajax=true";
        
        fetch(finalUrl)
            .then(res => res.text())
            .then(data => {
                if (data.includes("LOGIN_REQUIRED")) {
                    alert("Please login to add items to your cart/wishlist.");
                    window.location.href = "login.jsp?from=" + encodeURIComponent(window.location.href);
                } else if (data.startsWith("SUCCESS")) {
                    let type = baseUrl.includes('wishlist_add') ? "Wishlist" : "Cart";
                    alert("Added to " + type + "!");
                } else {
                    alert("Server Message: " + data);
                }
            })
            .catch(err => {
                alert("Connection error. Please try again.");
            });

        return false;
    }
</script>

<jsp:include page="footer1.jsp"/>

</body>
</html>
