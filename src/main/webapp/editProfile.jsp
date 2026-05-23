<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=editProfile.jsp");
        return;
    }
    Integer userId = (Integer) sess.getAttribute("user_id");
    String userName = (String) sess.getAttribute("user_name");
    String userEmail = (String) sess.getAttribute("user_email");
    String address = "";
    String phone = "";
    String dobStr = "";
    String profileImage = "default_user.jpg";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fullName = request.getParameter("full_name");
        String addr = request.getParameter("address");
        String p = request.getParameter("phone");
        String d = request.getParameter("dob");
        
        String imageBase64 = request.getParameter("profileBase64");
        String imageName = request.getParameter("profileName");
        String fileName = null;
        
        if (imageBase64 != null && !imageBase64.isEmpty() && imageName != null && !imageName.isEmpty()) {
            fileName = userId + "_" + System.currentTimeMillis() + "_" + imageName.replaceAll("[^a-zA-Z0-9.-]", "_");
            byte[] imageBytes = java.util.Base64.getDecoder().decode(imageBase64);
            
            String sourceDir = "d:/4BCA/Practice/chocoaura/src/main/webapp/user_images";
            new java.io.File(sourceDir).mkdirs();
            try (java.io.FileOutputStream fos1 = new java.io.FileOutputStream(sourceDir + "/" + fileName)) {
                fos1.write(imageBytes);
            } catch(Exception e) {}
            
            String deployDir = application.getRealPath("/") + "user_images";
            if (deployDir != null && !deployDir.contains("null")) {
                new java.io.File(deployDir).mkdirs();
                try (java.io.FileOutputStream fos2 = new java.io.FileOutputStream(deployDir + "/" + fileName)) {
                    fos2.write(imageBytes);
                } catch(Exception e) {}
            }
        }
        
        String sql = "UPDATE users SET full_name = ?, address = ?, phone = ?, date_of_birth = ?" + (fileName != null ? ", profile_image = ?" : "") + " WHERE id = ?";
        try (Connection conUpdate = DBConnection.getConnection();
             PreparedStatement psUpdate = conUpdate.prepareStatement(sql)) {
            psUpdate.setString(1, fullName);
            psUpdate.setString(2, addr != null ? addr.trim() : null);
            psUpdate.setString(3, p != null ? p.trim() : null);
            psUpdate.setString(4, (d != null && !d.trim().isEmpty()) ? d.trim() : null);
            if (fileName != null) {
                psUpdate.setString(5, fileName);
                psUpdate.setInt(6, userId);
            } else {
                psUpdate.setInt(5, userId);
            }
            psUpdate.executeUpdate();
            
            if (fullName != null && !fullName.isEmpty()) {
                sess.setAttribute("user_name", fullName);
            }
            if (fileName != null) {
                sess.setAttribute("user_image", fileName);
            }
            response.sendRedirect("profile.jsp?updated=1");
            return;
        } catch (Exception e) {
            response.sendRedirect("editProfile.jsp?error=Could not update profile.");
            return;
        }
    }
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT address, phone, date_of_birth, profile_image FROM users WHERE id = ?")) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String a = rs.getString("address"); if (a != null) address = a;
            String p = rs.getString("phone");   if (p != null) phone = p;
            Date d = rs.getDate("date_of_birth"); if (d != null) dobStr = d.toString();
            String img = rs.getString("profile_image"); if (img != null && !img.isEmpty()) profileImage = img;
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Profile | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Poppins;
}

body{
    background:#f5d48e;
    min-height:100vh;
    display:flex;
    flex-direction:column;
}

.main-area{
    flex:1;
    display:flex;
    align-items:center;
    justify-content:center;
    margin-bottom:50px;
}

.wrapper{
    width:1050px;
    background:#1f0f0f;
    border-radius:20px;
    padding:45px;
    color:#fff;
    box-shadow:0 30px 60px rgba(0,0,0,0.65);
}

.page-title{
    text-align:center;
    color:#f5d48e;
    font-size:26px;
    margin-bottom:30px;
}

.profile-pic{
    width:140px;
    height:140px;
    margin:0 auto 30px;
    position:relative;
}
.profile-pic img{
    width:100%;
    height:100%;
    border-radius:50%;
    object-fit:cover;
    border:4px solid #f5d48e;
}
.edit-icon{
    position:absolute;
    bottom:6px;
    right:6px;
    background:#f5d48e;
    width:38px;
    height:38px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#2a1414;
    cursor:pointer;
}
.edit-icon:hover{
    background:#fff;
}

.form-grid{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:22px;
}

.input-group{
    display:flex;
    flex-direction:column;
}
.input-group label{
    font-size:14px;
    color:#f5d48e;
    margin-bottom:6px;
}
.input-group input{
    padding:13px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
}
.input-group input:focus{
    background:rgba(245,212,142,0.08);
}

.full{
    grid-column:1 / -1;
}

.btn-row{
    margin-top:35px;
    display:flex;
    justify-content:center;
    gap:18px;
}

.btn-discard{
    background:transparent;
    border:1px solid #f5d48e;
    color:#f5d48e;
    padding:12px 34px;
    border-radius:30px;
    cursor:pointer;
}
.btn-discard:hover{
    background:rgba(245,212,142,0.12);
}

.btn-save{
    background:#f5d48e;
    border:none;
    color:#2a1414;
    padding:12px 40px;
    border-radius:30px;
    font-weight:600;
    cursor:pointer;
}
.btn-save:hover{
    background:#fff;
}


</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="main-area">

    <div class="wrapper">

        <div class="page-title">Edit Profile</div>
        
        <form action="editProfile.jsp" method="post" id="profileForm">
        <input type="hidden" name="profileBase64" id="profileBase64">
        <input type="hidden" name="profileName" id="profileName">
        
        <div class="profile-pic">
            <img id="img" src="user_images/<%= profileImage %>?v=<%= System.currentTimeMillis() %>" onerror="this.src='profile.jpg'">
            <div class="edit-icon" onclick="document.getElementById('fileInput').click()">
                <i class="fa-solid fa-camera"></i>
            </div>
            <input type="file" id="fileInput" hidden="hidden" accept="image/*"
                onchange="img.src=URL.createObjectURL(event.target.files[0])">
        </div>

            <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
            <div class="input-group full" style="color:#ff6b6b; font-size:13px; margin-bottom:12px;"><%= err %></div>
            <% } %>
            <div class="form-grid">

                <div class="input-group full">
                    <label>Full Name</label>
                    <input type="text" name="full_name" value="<%= userName != null ? userName : "" %>" required>
                </div>

                <div class="input-group full">
                    <label>Email</label>
                    <input type="email" value="<%= userEmail != null ? userEmail : "" %>" readonly>
                </div>

                <div class="input-group full">
                    <label>Address</label>
                    <input type="text" name="address" placeholder="Enter your address" value="<%= address %>">
                </div>

                <div class="input-group">
                    <label>Mobile Number</label>
                    <input type="text" name="phone" placeholder="+91 XXXXX XXXXX" value="<%= phone %>">
                </div>

                <div class="input-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" value="<%= dobStr %>">
                </div>

            </div>

            <div class="btn-row">
                <button type="button" class="btn-discard"
                    onclick="location.href='profile.jsp'">
                    Discard
                </button>
                <button type="button" class="btn-save" onclick="submitProfile()">
                    Save Changes
                </button>
            </div>
        </form>

    </div>

</div>

<script>
function submitProfile() {
    var fileInput = document.getElementById('fileInput');
    if (fileInput.files.length > 0) {
        var file = fileInput.files[0];
        document.getElementById('profileName').value = file.name;
        
        var reader = new FileReader();
        reader.onload = function(e) {
            var base64String = e.target.result.split(',')[1];
            document.getElementById('profileBase64').value = base64String;
            document.getElementById('profileForm').submit();
        };
        reader.readAsDataURL(file);
    } else {
        document.getElementById('profileForm').submit();
    }
}
</script>

<jsp:include page="footer1.jsp"/>

</body>
</html>

