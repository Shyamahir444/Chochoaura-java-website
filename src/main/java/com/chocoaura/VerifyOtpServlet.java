package com.chocoaura;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🚫 If session expired or invalid access
        if (session == null || session.getAttribute("otp") == null) {
            response.sendRedirect("login.jsp?error=Session expired. Please login again.");
            return;
        }

        String sessionOtp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");
        String userOtp = request.getParameter("otp");

        // ⏳ OTP expiry check (5 minutes)
        long currentTime = System.currentTimeMillis();
        if (otpTime != null && (currentTime - otpTime > 5 * 60 * 1000)) {
            session.removeAttribute("otp");
            session.removeAttribute("otpTime");
            response.sendRedirect("verify_otp.jsp?error=OTP expired. Please try again.");
            return;
        }

        // ✅ OTP MATCH
        if (sessionOtp != null && sessionOtp.equals(userOtp)) {
            
            // 1. Move temp data to permanent session
            session.setAttribute("user_id", session.getAttribute("temp_user_id"));
            session.setAttribute("user_name", session.getAttribute("temp_user_name"));
            session.setAttribute("user_email", session.getAttribute("temp_user_email"));

            // 2. Clear OTP & Temp data
            session.removeAttribute("otp");
            session.removeAttribute("otpTime");
            session.removeAttribute("temp_user_id");
            session.removeAttribute("temp_user_name");
            session.removeAttribute("temp_user_email");

            // 3. Success -> Redirect to Home
            response.sendRedirect("index.jsp");
            
        } 
        // ❌ WRONG OTP
        else {
            response.sendRedirect("verify_otp.jsp?error=Invalid OTP");
        }
    }
}