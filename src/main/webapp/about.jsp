<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About Us | ChocoAura</title>

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
    padding:60px 0;
}

h1,h2,h3{
    color:#f5d48e;
}

p{
    color:#ccc;
    line-height:1.7;
}

.about-hero{
    background:#1f0f0f;
    padding:60px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.1fr 1fr;
    gap:60px;
    align-items:center;
}

.about-hero h1{
    font-size:48px;
    margin-bottom:20px;
}

.about-hero img{
    width:100%;
    height:380px;
    object-fit:cover;
    border-radius:22px;
}

.values{
    margin-top:120px;
}

.values-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:22px;
    margin-top:40px;
}

.value-box{
    background:#2a1414;
    padding:28px;
    border-radius:22px;
    text-align:center;
    border:1px solid rgba(245,212,142,0.3);
}

.value-box h3{
    margin-bottom:10px;
    font-size:18px;
}

.story{
    margin-top:120px;
    background:#1f0f0f;
    padding:60px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.3fr 1fr;
    gap:60px;
    align-items:center;
}

.story img{
    width:100%;
    height:380px;
    object-fit:cover;
    border-radius:22px;
}

.about-cta{
    margin-top:120px;
    background:#2a1414;
    padding:50px;
    border-radius:26px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    border:1px solid rgba(245,212,142,0.3);
}

.btn{
    padding:14px 32px;
    border-radius:30px;
    text-decoration:none;
    font-size:14px;
    font-weight:600;
}

.btn-gold{
    background:#f5d48e;
    color:#2a1414;
}

</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">

<section class="about-hero">
    <div>
        <h1>About our handmade chocholates</h1><br>
        <p>
            ChocoAura was born from a passion for creating rich, comforting chocolate
            experiences that bring joy and warmth to everyday life.
        </p>
        <br>
        <p>
            Each chocolate is handcrafted using premium ingredients, ensuring
            exceptional taste, quality, and freshness in every bite.
        </p>
    </div>
    <img src="about1.jpg" alt="About ChocoAura">
</section>

<section class="values">
    <h2 style="color:#2a1414;font-size:30px;">Our Values</h2>

    <div class="values-grid">
        <div class="value-box">
            <h3>Premium Quality</h3>
            <p>We use carefully sourced ingredients to deliver rich flavor and purity.</p>
        </div>

        <div class="value-box">
            <h3>Handcrafted</h3>
            <p>Every product is crafted with attention, passion, and skill.</p>
        </div>

        <div class="value-box">
            <h3>Responsibility</h3>
            <p>Ethical sourcing and sustainable practices guide our work.</p>
        </div>

        <div class="value-box">
            <h3>Warmth and Joy</h3>
            <p>Our chocolates are made to create moments worth remembering.</p>
        </div>
    </div>
</section>

<section class="story">
    <img src="about2.jpg" alt="Our Story">
    <div>
        <h2>Our Journey</h2><br>
        <p>
            What began as a small kitchen experiment soon transformed into a brand
            loved by chocolate enthusiasts.
        </p>
        <br>
        <p>
            Today, ChocoAura blends traditional craftsmanship with modern creativity,
            delivering chocolates that speak of elegance and comfort.
        </p>
    </div>
</section>

<section class="about-cta">
    <div>
        <h2>Create Sweet Moments With Us</h2>
        <p>Explore our handcrafted chocolates and experience true indulgence.</p>
    </div>
    <a href="index.jsp" class="btn btn-gold">Go to Home</a>
</section>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
