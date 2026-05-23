<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    if (session == null || session.getAttribute("admin_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String orderIdStr = request.getParameter("id");
    if (orderIdStr == null) {
        response.sendRedirect("admin_manage_orders.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Order | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#f5d48e; color:#fff; padding-top:100px; padding-bottom:60px; }
        .container { width:900px; margin:auto; background:#1f0f0f; padding:40px; border-radius:18px; box-shadow:0 10px 30px rgba(0,0,0,0.5); }
        .container h2 { color:#f5d48e; margin-bottom:20px; border-bottom:1px solid rgba(245,212,142,0.3); padding-bottom:10px; }
        
        .order-info { margin-bottom: 30px; font-size: 15px; color: #ccc; }
        .order-info p { margin-bottom: 8px; }
        .order-info strong { color: #fff; }

        .items-table { width:100%; border-collapse:collapse; margin-bottom: 20px; }
        .items-table th, .items-table td { padding:12px; text-align:left; border-bottom:1px solid rgba(245,212,142,0.2); }
        .items-table th { color:#f5d48e; font-weight:500; }
        
        .back-link { display:inline-block; margin-top:20px; color:#f5d48e; text-decoration:none; padding:10px 20px; border:1px solid #f5d48e; border-radius:8px; transition:0.3s; }
        .back-link:hover { background:#f5d48e; color:#2a1414; }
    </style>
</head>
<body>
    <jsp:include page="admin_header.jsp"/>

    <div class="container">
        <%
            try (Connection con = com.chocoaura.DBConnection.getConnection();
                 PreparedStatement psOrder = con.prepareStatement(
                    "SELECT o.*, u.full_name, u.email FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?")) {
                
                psOrder.setInt(1, Integer.parseInt(orderIdStr));
                try (ResultSet rsOrder = psOrder.executeQuery()) {
                    if (rsOrder.next()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                        Timestamp ts = rsOrder.getTimestamp("created_at");
                        String dateStr = (ts != null) ? sdf.format(ts) : "N/A";
        %>
        
        <h2>Order Details #<%= rsOrder.getString("order_number") %></h2>
        
        <div class="order-info">
            <p><strong>Customer:</strong> <%= rsOrder.getString("full_name") %> (<%= rsOrder.getString("email") %>)</p>
            <p><strong>Date Placed:</strong> <%= dateStr %></p>
            <p><strong>Order Status:</strong> <%= rsOrder.getString("status") %></p>
            <p><strong>Total Amount:</strong> ₹<%= String.format("%.2f", rsOrder.getDouble("total_amount")) %></p>
        </div>
        
        <table class="items-table">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (PreparedStatement psItems = con.prepareStatement("SELECT * FROM order_items WHERE order_id = ?")) {
                        psItems.setInt(1, Integer.parseInt(orderIdStr));
                        try (ResultSet rsItems = psItems.executeQuery()) {
                            while(rsItems.next()) {
                                double price = rsItems.getDouble("price");
                                int quantity = rsItems.getInt("quantity");
                                double subtotal = price * quantity;
                %>
                <tr>
                    <td><%= rsItems.getString("product_name") %></td>
                    <td>₹<%= String.format("%.2f", price) %></td>
                    <td><%= quantity %></td>
                    <td>₹<%= String.format("%.2f", subtotal) %></td>
                </tr>
                <%          }
                        }
                    } 
                %>
            </tbody>
        </table>
        <%
                    } else {
                        out.println("<p style='color:red;'>Order not found.</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error loading order details: " + e.getMessage() + "</p>");
            }
        %>
        
        <a href="admin_manage_orders.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Orders</a>
    </div>

    <jsp:include page="admin_footer.jsp"/>
</body>
</html>
