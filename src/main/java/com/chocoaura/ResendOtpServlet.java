package com.chocoaura;
import com.chocoaura.OtpUtil;
import com.chocoaura.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ResendOtpServlet")
public class ResendOtpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("temp_user_email") == null) {
            response.sendRedirect("login.jsp?error=Session expired. Please login again.");
            return;
        }

        String email = (String) session.getAttribute("temp_user_email");
        
        // 🔄 Generate NEW OTP
	        String newOtp = OtpUtil.generateOtp();
	        session.setAttribute("otp", newOtp);
	        session.setAttribute("otpTime", System.currentTimeMillis());
	
	        // 📧 Resend Email
	        boolean sent = EmailUtil.sendOtp(email, newOtp);
        
        if (sent) {
            response.sendRedirect("verify_otp.jsp?success=New OTP sent");
        } else {
            response.sendRedirect("verify_otp.jsp?error=Failed to send OTP. Please try again.");
        }
    }
}
