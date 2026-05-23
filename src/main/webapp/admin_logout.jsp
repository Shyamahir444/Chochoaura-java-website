<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    session.removeAttribute("admin_id");
    session.removeAttribute("admin_username");
    response.sendRedirect("admin_login.jsp");
%>
