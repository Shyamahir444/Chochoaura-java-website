<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=wishlist.jsp");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Wishlist | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    box-sizing:border-box;
    font-family:Poppins;
}

body{
    background:#f5d48e;
    min-height:100vh;
    margin:0;
    display:flex;
    flex-direction:column;
}

.main-content{
    flex:1;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:40px 20px;
}

.wishlist-wrapper{
    width:100%;
    max-width:1100px;
    background:#1f0f0f;
    border-radius:18px;
    padding:30px;
    box-shadow:0 25px 50px rgba(0,0,0,0.6);
    margin-bottom:50px;
}

.page-title{
    text-align:center;
    margin-bottom:25px;
}

.page-title h1{
    color:#f5d48e;
}

table{
    width:100%;
    border-collapse:collapse;
}

thead{
    background:#f5d48e;
}

thead th{
    color:#2a1414;
    padding:12px;
    text-align:left;
    font-size:14px;
}

tbody tr{
    border-bottom:1px solid rgba(255,255,255,0.08);
}

tbody td{
    padding:16px 12px;
    vertical-align:middle;
    font-size:14px;
    color:#fff;
}

.product{
    display:flex;
    align-items:center;
    gap:15px;
}

.product img{
    width:55px;
    border-radius:8px;
}

.product small{
    color:#ccc;
    font-size:12px;
}

.remove{
    font-size:18px;
    color:#ccc;
    cursor:pointer;
}
.remove:hover{
    color:#f5d48e;
}

.stock{
    color:#4caf50;
    font-weight:600;
}

.btn-cart{
    background:#f5d48e;
    color:#2a1414;
    border:none;
    padding:7px 18px;
    border-radius:20px;
    font-size:13px;
    cursor:pointer;
}
.btn-cart:hover{
    background:#fff;
}

.footer-actions{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-top:25px;
    flex-wrap:wrap;
    gap:15px;
}

.link-box{
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
}

.link-box input{
    padding:8px 12px;
    border-radius:20px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    width:260px;
}

.btn-copy,
.btn-clear,
.btn-all{
    padding:8px 18px;
    border-radius:20px;
    font-size:13px;
    cursor:pointer;
    border:none;
}

.btn-copy{
    background:#f5d48e;
    color:#2a1414;
}

.btn-clear{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
}

.btn-all{
    background:#f5d48e;
    color:#2a1414;
    font-weight:600;
}

</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="main-content">
    <div class="wishlist-wrapper">

        <div class="page-title">
            <h1>Wishlist</h1>
        </div>

        <table>
            <thead>
                <tr>
                    <th></th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Stock Status</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <%
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                             "SELECT w.product_id, p.name, p.price, p.image FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.user_id = ?")) {
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        int pid = rs.getInt("product_id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String img = rs.getString("image");
                        if (img == null) img = "product1.jpg";
                %>
                <tr>
                    <td><a href="wishlist?action=remove&id=<%= pid %>" class="remove" onclick="return confirm('Remove from wishlist?');">×</a></td>
                    <td>
                        <div class="product">
                            <img src="<%= img %>" alt="">
                            <div><%= name %></div>
                        </div>
                    </td>
                    <td>₹<%= String.format("%.0f", price) %></td>
                    <td class="stock">In Stock</td>
                    <td><a href="cart?action=add&id=<%= pid %>&from=wishlist.jsp" class="btn-cart">Add to Cart</a></td>
                </tr>
                <%
                    }
                } catch (Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
        <div class="footer-actions">
            <p style="color:#ccc;"><a href="products.jsp" style="color:#f5d48e;">Continue shopping</a></p>
        </div>

    </div>
</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>

