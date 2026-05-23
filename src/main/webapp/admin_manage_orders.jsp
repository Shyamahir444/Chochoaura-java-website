<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.chocoaura.DBConnection" %>

<%
    if ("update_status".equals(request.getParameter("action"))) {
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");
        if (idStr != null && newStatus != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("UPDATE orders SET status=? WHERE id=?")) {
                ps.setString(1, newStatus);
                ps.setInt(2, Integer.parseInt(idStr));
                ps.executeUpdate();
            } catch(Exception e) {}
            response.sendRedirect("admin_manage_orders.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Orders | Admin</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
}

body{
    background:#f5d48e;
    color:#fff;
    padding-top:100px;
    padding-bottom:60px;
}

.container{
    width:1200px;
    margin:auto;
}

.table-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
}

.table-header h2{
    color:#2a1414;
    font-size:28px;
}

.admin-table{
    width:100%;
    border-collapse:collapse;
    background:#2a1414;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);
}

.admin-table th, .admin-table td{
    padding:15px;
    text-align:left;
    border-bottom:1px solid rgba(245,212,142,0.1);
}

.admin-table th{
    background:#1f0f0f;
    color:#f5d48e;
    font-weight:600;
}

.admin-table td{
    color:#ccc;
}

.status-badge{
    padding:4px 10px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
}
.status-placed{ background:#5bc0de; color:#fff; }
.status-shipped{ background:#f0ad4e; color:#fff; }
.status-delivered{ background:#5cb85c; color:#fff; }
.status-cancelled{ background:#d9534f; color:#fff; }

.action-btn{
    padding:6px 10px;
    border-radius:4px;
    text-decoration:none;
    font-size:14px;
    margin-right:5px;
    color:#fff;
}

.btn-view{ background:#0275d8; }

</style>
</head>
<body>
<jsp:include page="admin_header.jsp"/>

<div class="container">
    <div class="table-header">
        <h2>Manage Orders</h2>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Order Number</th>
                <th>Customer</th>
                <th>Total Amount</th>
                <th>Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT o.*, u.full_name FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.id DESC")) {
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                
                while(rs.next()){
                    Timestamp ts = rs.getTimestamp("created_at");
                    String dateStr = (ts != null) ? sdf.format(ts) : "N/A";
                    String status = rs.getString("status");
                    
                    String statusClass = "status-placed";
                    if("Shipped".equalsIgnoreCase(status)) statusClass = "status-shipped";
                    else if("Delivered".equalsIgnoreCase(status)) statusClass = "status-delivered";
                    else if("Cancelled".equalsIgnoreCase(status)) statusClass = "status-cancelled";
        %>
            <tr>
                <td><strong><%= rs.getString("order_number") %></strong></td>
                <td><%= rs.getString("full_name") %></td>
                <td>₹<%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
                <td><%= dateStr %></td>
                <td>
                    <form action="admin_manage_orders.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="update_status">
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                        <select name="status" onchange="this.form.submit()" style="padding:4px; border-radius:4px; border:1px solid #f5d48e; background:#2a1414; color:#fff; outline:none;">
                            <option value="Placed" <%= "Placed".equalsIgnoreCase(status) ? "selected" : "" %>>Placed</option>
                            <option value="Shipped" <%= "Shipped".equalsIgnoreCase(status) ? "selected" : "" %>>Shipped</option>
                            <option value="Delivered" <%= "Delivered".equalsIgnoreCase(status) ? "selected" : "" %>>Delivered</option>
                            <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(status) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </form>
                </td>
                <td>
                    <a class="action-btn btn-view" title="View Details" href="admin_view_order.jsp?id=<%= rs.getInt("id") %>"><i class="fa-solid fa-eye"></i></a>
                </td>
            </tr>
        <%
                }
            }catch(Exception e){
                out.println("<tr><td colspan='6'>Error loading orders</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="admin_footer.jsp"/>
</body>
</html>
