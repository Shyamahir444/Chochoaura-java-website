package com.chocoaura;

import java.io.IOException; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=checkout.jsp");
            return;
        }

        String addressIdParam = request.getParameter("address_id");
        String paymentIdParam = request.getParameter("payment_id");
        if (addressIdParam == null || addressIdParam.isEmpty()) {
            response.sendRedirect("checkout.jsp?error=Please select a delivery address.");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int addressId = Integer.parseInt(addressIdParam);
        Integer paymentId = null;
        if (paymentIdParam != null && !paymentIdParam.isEmpty()) {
            try { paymentId = Integer.parseInt(paymentIdParam); } catch (NumberFormatException e) {}
        }

        String orderNumber = "CA" + System.currentTimeMillis();
        List<CartItem> items = new ArrayList<>();
        double total = 0;

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT c.product_id, c.quantity, p.name, p.price FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.productId = rs.getInt("product_id");
                    item.quantity = rs.getInt("quantity");
                    item.name = rs.getString("name");
                    item.price = rs.getDouble("price");
                    items.add(item);
                    total += item.price * item.quantity;
                }
            }

            if (items.isEmpty()) {
                response.sendRedirect("cart.jsp?error=Your cart is empty.");
                return;
            }

            double delivery = 50;
            total += delivery;

            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO orders (user_id, address_id, payment_method_id, order_number, total_amount, status) VALUES (?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, addressId);
                    ps.setObject(3, paymentId);
                    ps.setString(4, orderNumber);
                    ps.setDouble(5, total);
                    ps.setString(6, "Placed");
                    ps.executeUpdate();
                    ResultSet keys = ps.getGeneratedKeys();
                    int orderId = 0;
                    if (keys.next()) {
						orderId = keys.getInt(1);
					}

                    try (PreparedStatement ips = con.prepareStatement(
                            "INSERT INTO order_items (order_id, product_id, product_name, quantity, price) VALUES (?,?,?,?,?)")) {
                        for (CartItem item : items) {
                            ips.setInt(1, orderId);
                            ips.setInt(2, item.productId);
                            ips.setString(3, item.name);
                            ips.setInt(4, item.quantity);
                            ips.setDouble(5, item.price);
                            ips.executeUpdate();
                        }
                    }

                    try (PreparedStatement del = con.prepareStatement("DELETE FROM cart WHERE user_id = ?")) {
                        del.setInt(1, userId);
                        del.executeUpdate();
                    }
                }
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }

            response.sendRedirect("orderSuccess.jsp?order_id=" + orderNumber);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=Could not place order. Try again.");
        }
    }

    private static class CartItem {
        int productId, quantity;
        String name;
        double price;
    }
}
