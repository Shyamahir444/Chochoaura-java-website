<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session == null || session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    boolean adminLoggedIn=(session !=null && session.getAttribute("admin_id") !=null); 
%>
        <title>Admin Header | ChocoAura</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                padding-top: 80px;
            }

            .site-header {
                background: #2a1414;
                padding: 15px 0;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 1000;
            }

            .header-container {
                width: 90%;
                margin: auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .logo a {
                color: #f5d48e;
                font-size: 26px;
                font-weight: 700;
                text-decoration: none;
            }

            .nav-menu a {
                color: #fff;
                margin: 0 15px;
                text-decoration: none;
                font-size: 15px;
            }

            .nav-menu a:hover {
                color: #f5d48e;
            }

            .header-icons {
                display: flex;
                gap: 22px;
            }

            .icon-box {
                position: relative;
                color: #fff;
                cursor: pointer;
                outline: none;
            }

            .icon-box i {
                font-size: 18px;
                transition: 0.2s;
            }

            .icon-box:hover i {
                color: #f5d48e;
                transform: scale(1.1);
            }

            .dropdown {
                position: absolute;
                top: 40px;
                right: 0;
                background: #2a1414;
                width: 150px;
                padding: 14px;
                border-radius: 10px;
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.25);
                opacity: 0;
                visibility: hidden;
                transform: translateY(12px);
                transition: all 0.3s ease;
                z-index: 9999;
            }

            .icon-box:focus-within .dropdown {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown a {
                display: block;
                padding: 8px 12px;
                margin: 5px 0;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                color: #f5d48e;
            }

            .dropdown a:hover {
                background: #f5d48e;
                color: #2a1414;
            }
        </style>

        <header class="site-header">
            <div class="header-container">

                <div class="logo">
                    <a href="admin_dashboard.jsp"><i class="fa-solid fa-cookie"></i> ChocoAura Admin</a>
                </div>

                <nav class="nav-menu">
                    <a href="admin_dashboard.jsp">Dashboard</a>
                    <a href="admin_manage_products.jsp">Products</a>
                    <a href="admin_manage_categories.jsp">Categories</a>
                    <a href="admin_manage_users.jsp">Users</a>
                    <a href="admin_manage_orders.jsp">Orders</a>
                </nav>

                <div class="header-icons">

                    <div class="icon-box" tabindex="0">
                        <i class="fa-solid fa-user-shield"></i>
                        <div class="dropdown">
                            <a href="admin_logout.jsp">Logout</a>
                        </div>
                    </div>

                </div>
            </div>
        </header>
