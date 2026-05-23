package com.chocoaura;

import java.io.File; 
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/RegisterServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        
        String profileImage = "default_user.jpg";

        try {
            // Check if request has multipart content
            if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
                Part part = request.getPart("profile_pic");
                if (part != null && part.getSize() > 0) {
                    String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    // Sanitize filename: remove spaces
                    submittedFileName = submittedFileName.replaceAll("\\s+", "_");
                    
                    // Create unique filename using timestamp
                    String uniqueFileName = System.currentTimeMillis() + "_" + submittedFileName;
                    
                    // Path to save: webapp/user_images
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "user_images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    
                    part.write(uploadPath + File.separator + uniqueFileName);
                    profileImage = uniqueFileName;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (full_name, email, password, address, phone, date_of_birth, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, password);
                // Handle optional fields
                ps.setString(4, (address != null && !address.trim().isEmpty()) ? address.trim() : null);
                ps.setString(5, (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null);
                ps.setString(6, (dob != null && !dob.trim().isEmpty()) ? dob : null);
                ps.setString(7, profileImage);
                
                ps.executeUpdate();
                
                // Redirect to login on success
                response.sendRedirect("login.jsp?msg=Registration Successful! Please Login.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = "Registration Failed";
            if (e.getMessage().contains("Duplicate")) {
                errorMsg = "Email already registered!";
            }
            response.sendRedirect("register.jsp?error=" + errorMsg);
        }
    }
}
