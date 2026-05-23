<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        if ("true".equals(request.getParameter("ajax"))) {
            out.print("ERROR: LOGIN_REQUIRED");
            return;
        }
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (Integer) sess.getAttribute("user_id");
    
    String action = request.getParameter("action");
    String idParam = request.getParameter("id");
    String weight = request.getParameter("weight");
    if (weight == null || weight.isEmpty()) weight = "250g";
    
    if (action == null || idParam == null || idParam.isEmpty()) {
        if ("true".equals(request.getParameter("ajax"))) {
            out.print("ERROR: MISSING_PARAMS");
            return;
        }
        response.sendRedirect("cart.jsp");
        return;
    }
    
    int productId = Integer.parseInt(idParam);
    
    try (Connection con = DBConnection.getConnection()) {
        // --- SELF-HEALING DB LOGIC (Ensures weight column and unique keys match) ---
        try (Statement st = con.createStatement()) {
            // 1. Ensure weight column exists
            try {
                st.executeUpdate("ALTER TABLE cart ADD COLUMN weight VARCHAR(20) DEFAULT '250g' AFTER product_id");
            } catch (SQLException e) { /* already exists or handled */ }
            
            // 2. Ensure unique key includes weight
            try {
                // Try to drop old unique key if it's the wrong one
                st.executeUpdate("ALTER TABLE cart DROP INDEX uk_cart_user_product");
                st.executeUpdate("ALTER TABLE cart ADD UNIQUE KEY uk_cart_user_product_weight (user_id, product_id, weight)");
            } catch (SQLException e) { /* might already be updated */ }
        } catch (Exception e) { e.printStackTrace(); }
        // --- END SELF-HEALING ---

        if ("add".equals(action)) {
            // Cart Addition
            int qty = 1;
            String q = request.getParameter("qty");
            if (q != null && !q.isEmpty()) qty = Integer.parseInt(q);
            
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO cart (user_id, product_id, weight, quantity) VALUES (?,?,?,?) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + ?")) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.setString(3, weight);
                ps.setInt(4, qty);
                ps.setInt(5, qty);
                ps.executeUpdate();
            }
        } else if ("remove".equals(action)) {
            // Cart Removal
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE user_id = ? AND product_id = ? AND weight = ?")) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.setString(3, weight);
                ps.executeUpdate();
            }
        } else if ("update".equals(action)) {
            // Cart Update Quantity
            int qty = Integer.parseInt(request.getParameter("quantity"));
            if (qty < 1) qty = 1;
            try (PreparedStatement ps = con.prepareStatement("UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ? AND weight = ?")) {
                ps.setInt(1, qty);
                ps.setInt(2, userId);
                ps.setInt(3, productId);
                ps.setString(4, weight);
                ps.executeUpdate();
            }
        } else if ("wishlist_add".equals(action)) {
            // Wishlist Addition
            try (PreparedStatement ps = con.prepareStatement("INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?,?)")) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.executeUpdate();
            }
        }
    } catch (Exception e) {
        if ("true".equals(request.getParameter("ajax"))) {
            out.print("ERROR: " + e.getMessage());
            return;
        }
        e.printStackTrace();
    }
    
    // Redirect if not AJAX
    if ("true".equals(request.getParameter("ajax"))) {
        out.print("SUCCESS: Product " + action + "ed");
        return;
    }
    
    String from = request.getParameter("from");
    if (from != null && !from.isEmpty()) {
        response.sendRedirect(from);
    } else {
        response.sendRedirect("cart.jsp");
    }
%>

