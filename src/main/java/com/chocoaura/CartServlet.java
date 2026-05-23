package com.chocoaura;

import java.io.IOException; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=cart.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        if (action == null || idParam == null || idParam.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int productId = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                String qParam = request.getParameter("qty");
                String weight = request.getParameter("weight");
                if (weight == null || weight.isEmpty()) weight = "250g";
                
                int qty = 1;
                if (qParam != null && !qParam.isEmpty()) {
                    try { qty = Integer.parseInt(qParam); } catch (NumberFormatException e) {}
                }
                addOrUpdateCart(con, userId, productId, weight, qty);
                String from = request.getParameter("from");
                if (from != null && !from.isEmpty()) {
                    response.sendRedirect(from);
                } else {
                    response.sendRedirect("cart.jsp");
                }
            } else if ("remove".equals(action)) {
                String weight = request.getParameter("weight");
                String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
                if (weight != null && !weight.isEmpty()) sql += " AND weight = ?";
                
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    if (weight != null && !weight.isEmpty()) ps.setString(3, weight);
                    ps.executeUpdate();
                }
                response.sendRedirect("cart.jsp");
            } else {
                response.sendRedirect("cart.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=cart.jsp");
            return;
        }

        String productIdParam = request.getParameter("product_id");
        String qtyParam = request.getParameter("quantity");
        String weight = request.getParameter("weight");
        if (weight == null || weight.isEmpty()) weight = "250g";
        
        if (productIdParam == null || qtyParam == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int productId = Integer.parseInt(productIdParam);
        int qty = Integer.parseInt(qtyParam);
        if (qty < 1) {
            qty = 1;
        }

        try (Connection con = DBConnection.getConnection()) {
            addOrUpdateCart(con, userId, productId, weight, qty);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("cart.jsp");
    }

    private void addOrUpdateCart(Connection con, int userId, int productId, String weight, int qty) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO cart (user_id, product_id, weight, quantity) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE quantity = quantity + ?")) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, weight);
            ps.setInt(4, qty);
            ps.setInt(5, qty);
            ps.executeUpdate();
        }
    }
}
