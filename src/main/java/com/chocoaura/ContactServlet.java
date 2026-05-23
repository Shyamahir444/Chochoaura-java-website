package com.chocoaura;

import java.io.IOException; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ContactServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()
                || message == null || message.trim().isEmpty()) {
            response.sendRedirect("contact.jsp?error=Please fill name, email and message.");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO contact (name, email, subject, message) VALUES (?, ?, ?, ?)")) {

            ps.setString(1, name.trim());
            ps.setString(2, email.trim());
            ps.setString(3, subject != null ? subject.trim() : "");
            ps.setString(4, message.trim());
            ps.executeUpdate();

            response.sendRedirect("contact.jsp?success=1");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("contact.jsp?error=Could not send message. Please try again.");
        }
    }
}
