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

public class SaveAddressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=addAddress.jsp");
            return;
        }

        String fullName = request.getParameter("full_name");
        String mobile = request.getParameter("mobile");
        String addressLine = request.getParameter("address_line");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String addressType = request.getParameter("address_type");
        if (addressType == null || addressType.isEmpty()) {
			addressType = "Home";
		}

        if (fullName == null || fullName.trim().isEmpty() || mobile == null || mobile.trim().isEmpty()
                || addressLine == null || addressLine.trim().isEmpty() || city == null || city.trim().isEmpty()
                || state == null || state.trim().isEmpty() || pincode == null || pincode.trim().isEmpty()) {
            response.sendRedirect("addAddress.jsp?error=Please fill all required fields.");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO addresses (user_id, full_name, mobile, address_line, city, state, pincode, address_type) VALUES (?,?,?,?,?,?,?,?)")) {
            ps.setInt(1, userId);
            ps.setString(2, fullName.trim());
            ps.setString(3, mobile.trim());
            ps.setString(4, addressLine.trim());
            ps.setString(5, city.trim());
            ps.setString(6, state.trim());
            ps.setString(7, pincode.trim());
            ps.setString(8, addressType.trim());
            ps.executeUpdate();
            response.sendRedirect("address.jsp?added=1");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addAddress.jsp?error=Could not save address. Try again.");
        }
    }
}
