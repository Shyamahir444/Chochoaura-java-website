package com.chocoaura;

import java.io.IOException; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLogoutServlet")
public class AdminLogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("admin_id");
            session.removeAttribute("admin_username");
            // Only invalidate if there are no other attributes needed, but usually removing specific ones is safer
            // or just invalidate entirely if it's an admin-only session. We'll just remove the attributes to be safe.
        }
        response.sendRedirect("admin_login.jsp");
    }
}
