package com.chocoaura;

import com.chocoaura.OtpUtil;
import com.chocoaura.EmailUtil;
import java.io.IOException; 
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=Enter email & password");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            
            // 👤 1. Try Admin Login First
            try (PreparedStatement psAdmin = con.prepareStatement(
                    "SELECT id, username FROM admins WHERE username = ? AND password = ?")) {
                psAdmin.setString(1, email.trim());
                psAdmin.setString(2, password.trim());
                ResultSet rsAdmin = psAdmin.executeQuery();
                
                if (rsAdmin.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("admin_id", rsAdmin.getInt("id"));
                    session.setAttribute("admin_username", rsAdmin.getString("username"));
                    response.sendRedirect("admin_dashboard.jsp");
                    return;
                }
            }

            // 👤 2. Try Regular User Login
            try (PreparedStatement psUser = con.prepareStatement(
                    "SELECT id, full_name, email FROM users WHERE email=? AND password=?")) {
                psUser.setString(1, email.trim());
                psUser.setString(2, password.trim());
                ResultSet rsUser = psUser.executeQuery();

                if (rsUser.next()) {
                    // ✅ Generate OTP using OtpUtil
                    String otp = OtpUtil.generateOtp();
                    System.out.println("Login OTP Generated: " + otp); // For testing

                    // ✅ Store ONLY temporary user data in session before OTP verification
                    HttpSession session = request.getSession(true);
                    // 🚫 DO NOT set "user_id" here to prevent bypass
                    session.setAttribute("temp_user_id", rsUser.getInt("id"));
                    session.setAttribute("temp_user_name", rsUser.getString("full_name"));
                    session.setAttribute("temp_user_email", rsUser.getString("email"));
                    
                    session.setAttribute("otp", otp);
                    session.setAttribute("otpTime", System.currentTimeMillis());

                    // ✅ Send Email and check status
                    boolean emailSent = EmailUtil.sendOtp(email.trim(), otp);

                    if (emailSent) {
                        // ✅ Redirect to OTP verification page
                        response.sendRedirect("verify_otp.jsp");
                    } else {
                        // ❌ Redirect back to login with error if email fails to send
                        response.sendRedirect("login.jsp?error=Failed to send OTP. Please check your SMTP settings or try again.");
                    }
                } else {
                    response.sendRedirect("login.jsp?error=Invalid email or password");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Server error");
        }
    }
}