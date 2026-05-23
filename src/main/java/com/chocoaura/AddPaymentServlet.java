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

public class AddPaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=addPaymentMethod.jsp");
            return;
        }

        String cardHolder = request.getParameter("card_holder");
        String cardNumber = request.getParameter("card_number");
        String expiryMonth = request.getParameter("expiry_month");
        String expiryYear = request.getParameter("expiry_year");
        String cardType = request.getParameter("card_type");
        if (cardType == null || cardType.isEmpty()) {
			cardType = "Visa";
		}

        if (cardHolder == null || cardHolder.trim().isEmpty() || cardNumber == null || cardNumber.trim().isEmpty()) {
            response.sendRedirect("addPaymentMethod.jsp?error=Please fill card holder name and card number.");
            return;
        }

        String lastFour = cardNumber.replaceAll("\\s", "");
        if (lastFour.length() >= 4) {
            lastFour = lastFour.substring(lastFour.length() - 4);
        } else {
            lastFour = "****";
        }

        int userId = (Integer) session.getAttribute("user_id");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO payment_methods (user_id, card_holder, card_last_four, card_type, expiry_month, expiry_year) VALUES (?,?,?,?,?,?)")) {
            ps.setInt(1, userId);
            ps.setString(2, cardHolder.trim());
            ps.setString(3, lastFour);
            ps.setString(4, cardType.trim());
            ps.setString(5, expiryMonth != null ? expiryMonth.trim() : "");
            ps.setString(6, expiryYear != null ? expiryYear.trim() : "");
            ps.executeUpdate();
            response.sendRedirect("payment.jsp?added=1");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addPaymentMethod.jsp?error=Could not save payment method. Try again.");
        }
    }
}
