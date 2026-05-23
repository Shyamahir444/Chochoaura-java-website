package com.chocoaura;

import java.io.IOException; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=changePassword.jsp");
            return;
        }

        String current = request.getParameter("current_password");
        String newPwd = request.getParameter("new_password");
        String confirm = request.getParameter("confirm_password");

        if (current == null || current.isEmpty() || newPwd == null || newPwd.isEmpty() || confirm == null || confirm.isEmpty()) {
            response.sendRedirect("changePassword.jsp?error=Please fill all fields.");
            return;
        }
        if (!newPwd.equals(confirm)) {
            response.sendRedirect("changePassword.jsp?error=New passwords do not match.");
            return;
        }
        if (newPwd.length() < 6) {
            response.sendRedirect("changePassword.jsp?error=New password must be at least 6 characters.");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE id = ? AND password = ?")) {
                ps.setInt(1, userId);
                ps.setString(2, current);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    response.sendRedirect("changePassword.jsp?error=Current password is incorrect.");
                    return;
                }
            }
            try (PreparedStatement ps = con.prepareStatement("UPDATE users SET password = ? WHERE id = ?")) {
                ps.setString(1, newPwd);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
            response.sendRedirect("changePassword.jsp?success=1");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("changePassword.jsp?error=Could not update password. Try again.");
        }
    }
}
