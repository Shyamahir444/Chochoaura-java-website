<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=cart.jsp");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
    double subtotal = 0;
    int itemCount = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cart | ChocoAura</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
*{ box-sizing:border-box; font-family:Poppins; }
body{ background:#f5d48e; min-height:100vh; margin:0; display:flex; flex-direction:column; }
.main-content{ flex:1; display:flex; justify-content:center; align-items:center; padding:40px 20px; }
.cart-wrapper{ width:100%; max-width:1100px; background:#1f0f0f; border-radius:18px; padding:30px; box-shadow:0 25px 50px rgba(0,0,0,0.6); color:#fff; margin-bottom:50px; }
.cart-title{ text-align:center; color:#f5d48e; font-size:26px; margin-bottom:25px; }
table{ width:100%; border-collapse:collapse; }
thead{ background:#f5d48e; }
thead th{ color:#2a1414; padding:12px; text-align:left; }
tbody tr{ border-bottom:1px solid rgba(255,255,255,0.08); }
tbody td{ padding:16px 12px; vertical-align:middle; }
.product{ display:flex; align-items:center; gap:15px; }
.product img{ width:60px; border-radius:8px; }
.product small{ color:#ccc; font-size:12px; }
.qty{ display:flex; align-items:center; gap:10px; }
.qty button{ width:28px; height:28px; border-radius:50%; border:none; background:#f5d48e; color:#2a1414; cursor:pointer; }
.qty span{ min-width:20px; text-align:center; }
.remove{ color:#ccc; font-size:18px; cursor:pointer; }
.remove:hover{ color:#f5d48e; }
.cart-summary{ margin-top:30px; display:flex; justify-content:flex-end; }
.summary-box{ width:320px; background:#2a1414; border-radius:16px; padding:20px; }
.summary-box h3{ color:#f5d48e; margin-bottom:15px; }
.summary-row{ display:flex; justify-content:space-between; margin-bottom:10px; font-size:14px; }
.summary-row.total{ font-weight:600; font-size:16px; margin-top:10px; }
.checkout-btn{ margin-top:20px; width:100%; padding:12px; border:none; border-radius:30px; background:#f5d48e; color:#2a1414; font-weight:600; cursor:pointer; }
.checkout-btn:hover{ background:#fff; }
.empty-cart{ text-align:center; padding:40px; color:#ccc; }
.empty-cart a{ color:#f5d48e; }
</style>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="main-content">
<div class="cart-wrapper">
    <div class="cart-title">Shopping Cart</div>
    
    <%-- Debug Info --%>
    <div style="font-size:10px; color:#555; margin-bottom:10px;">
        User ID: <%= userId %> | 
        <%
            int totalInDb = 0;
            try(Connection conDebug = DBConnection.getConnection();
                PreparedStatement psDebug = conDebug.prepareStatement("SELECT COUNT(*) FROM cart WHERE user_id=?")) {
                psDebug.setInt(1, userId);
                ResultSet rsDebug = psDebug.executeQuery();
                if(rsDebug.next()) totalInDb = rsDebug.getInt(1);
            } catch(Exception e) { out.print("DB Error: " + e.getMessage()); }
        %>
        Rows in DB: <%= totalInDb %>
    </div>
    <table>
        <thead>
            <tr>
                <th></th>
                <th>Product</th>
                <th>Weight</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                         "SELECT c.id, c.product_id, c.quantity, c.weight, p.name, p.price, p.image FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int cartId = rs.getInt("id");
                    int productId = rs.getInt("product_id");
                    int qty = rs.getInt("quantity");
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    String img = rs.getString("image");
                    String weight = rs.getString("weight");
                    if (img == null) img = "product1.jpg";
                    if (weight == null) weight = "250g";
                    double rowTotal = price * qty;
                    subtotal += rowTotal;
                    itemCount++;
            %>
            <tr>
                <td><a href="cart_handler.jsp?action=remove&id=<%= productId %>&weight=<%= weight %>" class="remove" onclick="return confirm('Remove from cart?');">×</a></td>
                <td>
                    <div class="product">
                        <img src="<%= img %>" alt="">
                        <div><%= name %></div>
                    </div>
                </td>
                <td><span style="background:#f5d48e; color:#2a1414; padding:2px 8px; border-radius:12px; font-size:12px; font-weight:600;"><%= weight %></span></td>
                <td>₹<%= String.format("%.0f", price) %></td>
                <td>
                    <form action="cart_handler.jsp" method="post" style="display:inline-flex; align-items:center; gap:8px;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= productId %>">
                        <input type="hidden" name="weight" value="<%= weight %>">
                        <input type="hidden" name="quantity" value="<%= qty %>" id="qty_<%= productId %>_<%= weight %>">
                        <button type="button" onclick="var e=document.getElementById('qty_<%= productId %>_<%= weight %>'); var v=parseInt(e.value)-1; if(v>=1){ e.value=v; this.form.submit(); }">−</button>
                        <span><%= qty %></span>
                        <button type="button" onclick="var e=document.getElementById('qty_<%= productId %>_<%= weight %>'); e.value=parseInt(e.value)+1; this.form.submit();">+</button>
                    </form>
                </td>
                <td>₹<%= String.format("%.0f", rowTotal) %></td>
                <td></td>
            </tr>
            <%
                }
            } catch (Exception e) { e.printStackTrace(); }
            %>
        </tbody>
    </table>
    <% if (itemCount == 0) { %>
    <div class="empty-cart">
        <p>Your cart is empty.</p>
        <p><a href="products.jsp">Continue shopping</a></p>
    </div>
    <% } else {
        double delivery = 50;
        double total = subtotal + delivery;
    %>
    <div class="cart-summary">
        <div class="summary-box">
            <h3>Order Summary</h3>
            <div class="summary-row"><span>Subtotal</span><span>₹<%= String.format("%.0f", subtotal) %></span></div>
            <div class="summary-row"><span>Delivery</span><span>₹<%= String.format("%.0f", delivery) %></span></div>
            <div class="summary-row total"><span>Total</span><span>₹<%= String.format("%.0f", total) %></span></div>
            <button class="checkout-btn" onclick="location.href='checkout.jsp'">Proceed to Checkout</button>
        </div>
    </div>
    <% } %>
</div>
</div>
<jsp:include page="footer1.jsp"/>
</body>
</html>

