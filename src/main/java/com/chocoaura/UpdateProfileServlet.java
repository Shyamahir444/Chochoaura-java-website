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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?from=editProfile.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        
        // Handle File Upload
        String fileName = null;
        try {
            if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
                Part part = request.getPart("profile_pic");
                if (part != null && part.getSize() > 0) {
                    String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    submittedFileName = submittedFileName.replaceAll("\\s+", "_");
                    // Prevent filename collisions by prepending user ID and timestamp
                    fileName = userId + "_" + System.currentTimeMillis() + "_" + submittedFileName;
                    
                    // Save path: src/main/webapp/user_images
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "user_images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    part.write(uploadPath + File.separator + fileName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String fullName = request.getParameter("full_name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");

        String sql = "UPDATE users SET full_name = ?, address = ?, phone = ?, date_of_birth = ?" + (fileName != null ? ", profile_image = ?" : "") + " WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, address != null ? address.trim() : null);
            ps.setString(3, phone != null ? phone.trim() : null);
            ps.setString(4, (dob != null && !dob.trim().isEmpty()) ? dob.trim() : null);
            if (fileName != null) {
                ps.setString(5, fileName);
                ps.setInt(6, userId);
            } else {
                ps.setInt(5, userId);
            }
            ps.executeUpdate();
            
            if (fullName != null && !fullName.isEmpty()) {
                session.setAttribute("user_name", fullName);
            }

            response.sendRedirect("profile.jsp?updated=1");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=Could not update profile. Please try again.");
        }
    }
}
