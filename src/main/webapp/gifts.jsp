<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gifts | ChocoAura</title>

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

.gift-hero{
    background:#1f0f0f;
    padding:60px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.1fr 1fr;
    gap:60px;
    align-items:center;
}

.gift-hero h1{
    font-size:48px;
    margin-bottom:20px;
}

.gift-hero img{
    width:100%;
    height:380px;
    object-fit:cover;
    border-radius:22px;
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

.occasions{
    margin-top:120px;
}

.occasion-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:22px;
    margin-top:40px;
}

.occasion{
    background:#2a1414;
    padding:26px;
    border-radius:22px;
    text-align:center;
    border:1px solid rgba(245,212,142,0.3);
}

.occasion h3{
    margin-bottom:10px;
}

.gift-sets{
    margin-top:120px;
}

.set-grid{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:26px;
    margin-top:40px;
}

.set{
    background:#2a1414;
    padding:20px;
    border-radius:22px;
    border:1px solid rgba(245,212,142,0.3);
}

.set img{
    width:100%;
    height:240px;
    object-fit:cover;
    border-radius:20px;
}

.set h4{
    margin:16px 0 6px;
    color:#fff;
}

.set span{
    font-size:14px;
    color:#f5d48e;
}

.gift-cta{
    margin-top:120px;
    background:#1f0f0f;
    padding:50px;
    border-radius:26px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    border:1px solid rgba(245,212,142,0.3);
}
</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">

<section class="gift-hero">
    <div>
        <h1>Perfect Gifts for Every Occasion</h1><br>
        <p>
            Thoughtfully crafted chocolate gifts that express love, care,
            and warmth for every special moment.
        </p><br>
        <br>
        <a href="products.jsp" class="btn btn-gold">Choose a Gift</a>
    </div>

    <img src="gift1.jpg" alt="Chocolate Gifts">
</section>

<section class="occasions">
    <h2 style="color:#2a1414">Gifts for Any Occasion</h2>

    <div class="occasion-grid">
        <div class="occasion">
            <h3>Birthdays</h3>
            <p>Celebrate with rich flavors and delightful surprises.</p>
        </div>

        <div class="occasion">
            <h3>Anniversaries</h3>
            <p>Elegant gift sets to honor love and togetherness.</p>
        </div>

        <div class="occasion">
            <h3>Festivals</h3>
            <p>Perfect for Diwali, Christmas, and festive celebrations.</p>
        </div>

        <div class="occasion">
            <h3>Thank You</h3>
            <p>A simple yet meaningful way to show appreciation.</p>
        </div>
    </div>
</section>

<section class="gift-sets">
    <h2 style="color:#2a1414">Popular Gift Sets</h2>

    <div class="set-grid">
        <div class="set">
            <img src="gift2.jpg">
            <h4>Relax and Indulge</h4>
            <span>₹1,299</span>
        </div>

        <div class="set">
            <img src="gift3.jpg">
            <h4>Warm Moments</h4>
            <span>₹1,599</span>
        </div>

        <div class="set">
            <img src="gift4.jpg">
            <h4>Festive Delight</h4>
            <span>₹1,899</span>
        </div>
    </div>
</section>

<section class="gift-cta">
    <div>
        <h2>Make Someone Smile Today</h2>
        <p>Choose a chocolate gift that speaks from the heart.</p>
    </div>
    <a href="index.jsp" class="btn btn-gold">Back to Home</a>
</section>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
