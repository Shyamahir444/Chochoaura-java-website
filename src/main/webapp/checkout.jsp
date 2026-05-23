<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=checkout.jsp");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout | ChocoAura</title>

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

.checkout-wrapper{
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
    margin-bottom:35px;
}

.form-group{
    margin-bottom:18px;
}
label{
    display:block;
    margin-bottom:6px;
    color:#f5d48e;
    font-size:14px;
}
input, textarea{
    width:100%;
    padding:12px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
}
textarea{
    resize:none;
    height:90px;
    border-radius:18px;
}

.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:18px;
}

.pay-btn{
    margin-top:35px;
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
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="checkout-wrapper">

    <h2>Delivery Address</h2>
    <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
    <p style="color:#ff6b6b; margin-bottom:15px;"><%= err %></p>
    <% } %>
    <form action="cart_payment.jsp" method="get">
        <div class="form-group">
            <label>Select delivery address</label>
            <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id, full_name, mobile, address_line, city, state, pincode, address_type FROM addresses WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                boolean hasAddr = false;
                while (rs.next()) {
                    hasAddr = true;
                    int id = rs.getInt("id");
                    String fn = rs.getString("full_name");
                    String mob = rs.getString("mobile");
                    String addr = rs.getString("address_line");
                    String city = rs.getString("city");
                    String state = rs.getString("state");
                    String pin = rs.getString("pincode");
                    String atype = rs.getString("address_type");
            %>
            <label style="display:flex; align-items:flex-start; gap:10px; margin-bottom:12px; cursor:pointer;">
                <input type="radio" name="address_id" value="<%= id %>" required>
                <span><strong><%= fn %></strong> (<%= atype %>)<br><%= addr %>, <%= city %>, <%= state %> - <%= pin %><br>Phone: <%= mob %></span>
            </label>
            <%
                }
                if (!hasAddr) {
            %>
            <p style="color:#f5d48e;">No saved address. <a href="addAddress.jsp" style="color:#f5d48e;">Add address</a> first, or <a href="address.jsp" style="color:#f5d48e;">manage addresses</a>.</p>
            <% } else { %>
            <button type="submit" class="pay-btn">Proceed to Payment</button>
            
            <%
            }
            } catch (Exception e) { e.printStackTrace(); }
            %>
        </div>
    </form>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>

