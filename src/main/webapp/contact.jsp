<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Contact Us | ChocoAura</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins', sans-serif;
}

body{
    background:#f5d48e;
}


.contact-wrapper{
    width:1200px;
    background:#1f0f0f;
    border-radius:20px;
    padding:40px;
    display:grid;
    grid-template-columns:1fr 1.2fr;
    gap:35px;
    box-shadow:0 30px 60px rgba(0,0,0,0.6);
    margin:100px auto 40px;
}

.contact-left{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:20px;
}

.info-card{
    background:#2a1414;
    border-radius:16px;
    padding:22px;
    text-align:center;
    border:1px solid rgba(245,212,142,0.3);
}
.info-card i{
    font-size:26px;
    color:#f5d48e;
    margin-bottom:10px;
}
.info-card h4{
    color:#fff;
    font-size:15px;
    margin-bottom:6px;
}
.info-card p{
    font-size:13px;
    color:#ccc;
}

.map-box{
    grid-column:1 / -1;
    border-radius:16px;
    overflow:hidden;
    border:1px solid rgba(245,212,142,0.3);
}
.map-box iframe{
    width:100%;
    height:230px;
    border:0;
}

.contact-right h2{
    color:#f5d48e;
    margin-bottom:8px;
}
.contact-right p{
    font-size:14px;
    color:#ccc;
    margin-bottom:25px;
}

.form-group{
    margin-bottom:18px;
}
.form-group label{
    display:block;
    font-size:14px;
    color:#f5d48e;
    margin-bottom:6px;
}
.form-group input,
.form-group textarea{
    width:100%;
    padding:14px 16px;
    border-radius:30px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    outline:none;
}
.form-group textarea{
    resize:none;
    height:110px;
    border-radius:18px;
}

.send-btn{
    margin-top:10px;
    background:#f5d48e;
    border:none;
    color:#2a1414;
    padding:14px;
    width:100%;
    border-radius:30px;
    font-size:15px;
    font-weight:600;
    cursor:pointer;
}
.send-btn:hover{
    background:#fff;
}



.team-wrapper{
    width:1200px;
    margin:0 auto 80px;
    background:#1f0f0f;
    padding:50px 40px;
    border-radius:20px;
    box-shadow:0 30px 60px rgba(0,0,0,0.6);
    text-align:center;
}

.team-wrapper h2{
    color:#f5d48e;
    margin-bottom:6px;
}



.team-cards{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:30px;
}

.team-card{
    background:#2a1414;
    border-radius:18px;
    padding:30px 22px;
    border:1px solid rgba(245,212,142,0.3);
}

.team-card img{
    width:110px;
    height:110px;
    border-radius:50%;
    object-fit:cover;
    border:3px solid #f5d48e;
    margin-bottom:15px;
}

.team-card h3{
    color:#fff;
    font-size:18px;
    margin-bottom:4px;
}

.team-card span{
    color:#f5d48e;
    font-size:13px;
}

.team-card p{
    font-size:13px;
    color:#ccc;
    margin:12px 0 18px;
}

.team-social i{
    color:#f5d48e;
    font-size:14px;
    margin:0 8px;
    cursor:pointer;
}
.team-social i:hover{
    color:#fff;
}
</style>
</head>

<body>

<jsp:include page="header.jsp"/>


<div class="contact-wrapper">

    <div class="contact-left">

        <div class="info-card">
            <i class="fa-solid fa-phone"></i>
            <h4>Phone</h4>
            <p>+91 87801 02206</p>
        </div>

        <div class="info-card">
            <i class="fa-brands fa-whatsapp"></i>
            <h4>WhatsApp</h4>
            <p>+91 87801 02206</p>
        </div>

        <div class="info-card">
            <i class="fa-solid fa-envelope"></i>
            <h4>Email</h4>
            <p>chocoaura@gmail.com</p>
        </div>

        <div class="info-card">
            <i class="fa-solid fa-store"></i>
            <h4>Our Shop</h4>
            <p>Rajkot, Gujarat, India</p>
        </div>

        <div class="map-box">
            <iframe src="https://www.google.com/maps?q=RK%20University%20Main%20Campus%20Rajkot&output=embed"></iframe>
        </div>

    </div>

    <div class="contact-right">
        <h2>Get In Touch</h2>
        <p>Have questions about our chocolates or gifts? Fill out the form and weâ€™ll get back to you soon.</p>

        <form action="contact" method="post">
            <% String err = request.getParameter("error"); if (err != null && !err.isEmpty()) { %>
            <div class="form-group" style="color:#ff6b6b; font-size:13px;"><%= err %></div>
            <% } %>
            <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="form-group" style="color:#51cf66; font-size:14px;">Message sent successfully. We will get back to you soon!</div>
            <% } %>
            <div class="form-group">
                <label>Name</label>
                <input type="text" name="name" placeholder="Your Name" required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="example@gmail.com" required>
            </div>

            <div class="form-group">
                <label>Subject</label>
                <input type="text" name="subject" placeholder="Subject">
            </div>

            <div class="form-group">
                <label>Message</label>
                <textarea name="message" placeholder="Write your message..." required></textarea>
            </div>

            <button type="submit" class="send-btn">Send Now</button>
        </form>
    </div>

</div>


<div class="team-wrapper">
    <h2>Our Team</h2>
<br>
    <div class="team-cards">

        <div class="team-card">
            <img src="MITESH.jpg">
            <h3>Mitesh Gauswami</h3>
            <span>24FOTCA11116</span>
            <p>Passionate chocolatier creating premium handmade chocolates.</p>
            <div class="team-social">
                <i class="fab fa-facebook-f"></i>
                <i class="fab fa-instagram"></i>
                <i class="fab fa-linkedin-in"></i>
            </div>
        </div>

        <div class="team-card">
            <img src="ASHISH.png">
            <h3>Ashish Jatapara</h3>
            <span>24FOTCA11233</span>
            <p>Designs gift boxes and flavors with a creative touch.</p>
            <div class="team-social">
                <i class="fab fa-facebook-f"></i>
                <i class="fab fa-instagram"></i>
                <i class="fab fa-linkedin-in"></i>
            </div>
        </div>

        <div class="team-card">
            <img src="SHYAM.jpg">
            <h3>Shyam Chocha</h3>
            <span>24FOTCA11220</span>
            <p>Handles branding and customer experience at ChocoAura.</p>
            <div class="team-social">
                <i class="fab fa-facebook-f"></i>
                <i class="fab fa-instagram"></i>
                <i class="fab fa-linkedin-in"></i>
            </div>
        </div>

    </div>
</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
