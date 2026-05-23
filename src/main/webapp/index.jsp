<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    if(session.getAttribute("user_id") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home | ChocoAura</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
}

body{
    background:#f5d48e;
    color:#fff;
    padding-top:80px;
}

.container{
    width:1200px;
    margin:auto;
}

.btn{
    padding:14px 32px;
    border-radius:30px;
    text-decoration:none;
    font-size:14px;
    font-weight:600;
    display:inline-block;
}

.btn-gold{
    background:#f5d48e;
    color:#2a1414;
}

.hero{
    margin-top:60px;
    background:#1f0f0f;
    padding:60px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.2fr 1fr;
    gap:60px;
    align-items:center;
}

.hero h1{
    font-size:54px;
    color:#f5d48e;
    line-height:1.2;
}

.hero p{
    color:#ccc;
    margin:25px 0 35px;
}

.hero img{
    width:100%;
    height:500px;
    object-fit:cover;
    border-radius:22px;
}

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:18px;
    margin-top:40px;
}

.stats div{
    background:#2a1414;
    padding:22px;
    border-radius:18px;
    text-align:center;
    border:1px solid rgba(245,212,142,0.3);
}

.stats strong{
    display:block;
    font-size:26px;
    color:#f5d48e;
}

.stats span{
    color:#ccc;
    font-size:14px;
}

.section{
    margin-top:120px;
}

.section h2{
    color:#2a1414;
    font-size:34px;
    margin-bottom:30px;
}

.products{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:26px;
}

.card{
    background:#2a1414;
    padding:18px;
    border-radius:22px;
    border:1px solid rgba(245,212,142,0.3);
}

.card img{
    width:100%;
    height:220px;
    object-fit:cover;
    border-radius:18px;
}

.card h4{
    margin:14px 0 6px;
    color:#fff;
}

.card span{
    color:#f5d48e;
    font-size:14px;
}

.story{
    display:grid;
    grid-template-columns:1.2fr 1fr;
    gap:60px;
    align-items:center;
}

.story img{
    width:100%;
    height:300px;
    border-radius:26px;
}

.story p{
    color:#ccc;
    margin:12px 0;
}

.icon-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    margin-top:40px;
}

.icon-box-home{
    background:#2a1414;
    padding:26px;
    border-radius:22px;
    text-align:center;
    color:#f5d48e;
    border:1px solid rgba(245,212,142,0.3);
}

.master{
    display:grid;
    grid-template-columns:1fr 1.3fr;
    gap:60px;
    align-items:center;
}

.master img{
    width:100%;
    height:260px;
    border-radius:26px;
}

.faq{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:60px;
}

.faq-list div{
    padding:16px 0;
    border-bottom:1px solid rgba(245,212,142,0.3);
    color:#2a1414;
}

.subscribe{
    margin:120px 0;
    background:#1f0f0f;
    padding:40px;
    border-radius:26px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.subscribe p{
    color:#ccc;
}

.subscribe input{
    padding:12px 18px;
    border-radius:22px;
    border:1px solid #f5d48e;
    background:transparent;
    color:#fff;
    width:260px;
}

</style>
</head>

<body>
<jsp:include page="header.jsp"/>


<div class="container">

<section class="hero">
    <div>
        <h1>Handmade chocolates<br>for every moment</h1>
        <p>Premium ingredients, rich flavors and crafted with love.</p>
        <a href="products.jsp" class="btn btn-gold">Explore Chocolates</a>

        <div class="stats">
            <div><strong>50+</strong><span>Chocolate varieties</span></div>
            <div><strong>100%</strong><span>Natural ingredients</span></div>
            <div><strong>10+</strong><span>Years experience</span></div>
            <div><strong>5k+</strong><span>Happy customers</span></div>
        </div>
    </div>

    <img src="home1.jpg" alt="ChocoAura">
</section>

<section class="section">
    <h2>Customer Favorites</h2>
    <div class="products">
        <div class="card"><img src="home2.jpg"><h4>Dark Exposure</h4><span>₹299</span></div>
        <div class="card"><img src="home3.jpg"><h4>Hazelnut Focus</h4><span>₹349</span></div>
        <div class="card"><img src="home4.jpg"><h4>Golden Frame Caramel</h4><span>₹279</span></div>
        <div class="card"><img src="home5.jpg"><h4>Classic Cocoa Shot</h4><span>₹249</span></div>
    </div>
</section>

<section class="section story">
    <img src="home6.jpg">
    <div>
        <h2 style="color:#2a1414">Our Chocolate Story</h2><br>
        <p style="color:#2a1414">ChocoAura was born from a passion for authentic chocolate making.</p>
        <p style="color:#2a1414">Every piece reflects craftsmanship, care, and premium quality.</p>
    </div>
</section>

<div class="icon-grid">
    <div class="icon-box-home">Premium Quality</div>
    <div class="icon-box-home">Handcrafted</div>
    <div class="icon-box-home">Fresh Ingredients</div>
    <div class="icon-box-home">Perfect Gifts</div>
</div>

<section class="section master">
    <div>
        <h2>Create your own <br>chocolate</h2><br>
        <p style="color:#2a1414">Join our chocolate making workshop and craft your flavor.</p>
    </div>
    <img src="home7.jpg">
</section>

<section class="section faq">
    <div>
        <h2>Need Help?</h2><br><br><br><br>
        <a href="contact.jsp" class="btn btn-gold" style="background-color:#2a1414;color:white;">Contact Us</a>
    </div>
    <div class="faq-list">
        <div>How do you ensure freshness?</div>
        <div>Do you offer gift packaging?</div>
        <div>How long does delivery take?</div>
        <div>Can I customize chocolates?</div>
    </div>
</section>

<div class="subscribe">
    <div>
        <h3>Stay Updated</h3>
        <p>New chocolates, offers and updates</p>
    </div>
    <div>
        <input type="email" placeholder="Your email">
        <a class="btn btn-gold">Subscribe</a>
    </div>
</div>

</div>
<br>
<jsp:include page="footer1.jsp"/>

</body>
</html>
