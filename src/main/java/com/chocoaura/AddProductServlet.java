package com.chocoaura;

import java.io.File; 
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;


@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        
        String fileName = "";
        Part part = request.getPart("image");
        
        if (part != null && part.getSize() > 0) {
            String originalFileName = getFileName(part);
            if (originalFileName != null && !originalFileName.isEmpty()) {
                // Generate a unique file name to avoid collisions
                String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
                fileName = UUID.randomUUID().toString() + extension;
                
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                part.write(uploadPath + File.separator + fileName);
            }
        }
        
        if (fileName.isEmpty()) {
            fileName = "product1.jpg"; // Default image if none uploaded
        } else {
            // Prepend uploads/ to the filename for database storage
            fileName = UPLOAD_DIR + "/" + fileName;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO products (name, category, price, description, image) VALUES (?,?,?,?,?)")) {
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setDouble(3, Double.parseDouble(priceStr));
            ps.setString(4, description);
            ps.setString(5, fileName);
            
            ps.executeUpdate();
            response.sendRedirect("admin_manage_products.jsp?msg=Added");
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("admin_add_product.jsp?err=" + e.getMessage());
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
