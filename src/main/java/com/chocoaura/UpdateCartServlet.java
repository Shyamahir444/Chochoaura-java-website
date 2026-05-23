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

/** Updates cart item quantity. POST: product_id, quantity. If quantity <= 0, removes item. */
public class UpdateCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
        if (productIdParam == null || qtyParam == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int productId = Integer.parseInt(productIdParam);
        int qty = Integer.parseInt(qtyParam);

        try (Connection con = DBConnection.getConnection()) {
            if (qty < 1) {
                try (PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE user_id = ? AND product_id = ?")) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = con.prepareStatement("UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?")) {
                    ps.setInt(1, qty);
                    ps.setInt(2, userId);
                    ps.setInt(3, productId);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("cart.jsp");
    }
}
