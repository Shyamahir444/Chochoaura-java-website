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

public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=wishlist.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        if (action == null || idParam == null || idParam.isEmpty()) {
            response.sendRedirect("wishlist.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int productId = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                try (PreparedStatement ps = con.prepareStatement(
                        "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?,?)")) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
            } else if ("remove".equals(action)) {
                try (PreparedStatement ps = con.prepareStatement("DELETE FROM wishlist WHERE user_id = ? AND product_id = ?")) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
            }
            String from = request.getParameter("from");
            if ("add".equals(action) && from != null && !from.isEmpty()) {
                response.sendRedirect(from);
            } else {
                response.sendRedirect("wishlist.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("wishlist.jsp?error=1");
        }
    }
}
