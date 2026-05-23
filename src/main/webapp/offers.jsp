<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Offers | ChocoAura</title>

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

.offer-hero{
    background:#1f0f0f;
    padding:60px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.1fr 1fr;
    gap:60px;
    align-items:center;
}

.offer-hero h1{
    font-size:48px;
    margin-bottom:20px;
}

.offer-hero img{
    width:100%;
    height:380px;
    object-fit:cover;
    border-radius:22px;
}

.deals{
    margin-top:120px;
}

.deal-grid{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:26px;
    margin-top:40px;
}

.deal{
    background:#2a1414;
    padding:24px;
    border-radius:22px;
    border:1px solid rgba(245,212,142,0.3);
}

.deal h3{
    color:#fff;
    margin-bottom:10px;
}

.badge{
    display:inline-block;
    background:#f5d48e;
    color:#2a1414;
    padding:6px 14px;
    border-radius:20px;
    font-size:12px;
    margin-bottom:12px;
    font-weight:600;
}

.season{
    margin-top:120px;
    background:#1f0f0f;
    padding:50px;
    border-radius:26px;
    display:grid;
    grid-template-columns:1.3fr 1fr;
    gap:40px;
    align-items:center;
    border:1px solid rgba(245,212,142,0.3);
}

.season img{
    width:100%;
    height:180px;
    object-fit:cover;
    border-radius:22px;
}

.offer-cta{
    margin-top:120px;
    background:#2a1414;
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

<section class="offer-hero">
    <div>
        <h1>Special Offers on Chocolates</h1><br>
        <p>
            Enjoy exclusive discounts on our most loved chocolates and gift boxes.
            Limited-time offers crafted to spread sweetness and joy.
        </p>
        <br><br>
        <a href="products.jsp" class="btn btn-gold">Shop Offers</a>
    </div>

    <img src="offers1.jpg" alt="Chocolate Offers">
</section>

<section class="deals">
    <h2 style="color:#2a1414">Hot Deals</h2>

    <div class="deal-grid">
        <div class="deal">
            <span class="badge">20% OFF</span>
            <h3>Relax Chocolate Box</h3>
            <p>Perfect for stress relief and cozy evenings.</p>
        </div>

        <div class="deal">
            <span class="badge">Buy 1 Get 1</span>
            <h3>Classic Dark Chocolates</h3>
            <p>Double the delight with our best-selling dark range.</p>
        </div>

        <div class="deal">
            <span class="badge">Flat ₹500 OFF</span>
            <h3>Festive Gift Hamper</h3>
            <p>Ideal for festivals, celebrations, and special moments.</p>
        </div>
    </div>
</section>

<section class="season">
    <div>
        <h2>Seasonal Special</h2><br>
        <p>
            Celebrate the season with our limited-edition chocolates crafted
            for festive moods and warm moments.
        </p>
        <br><br>
        <a href="products.jsp" class="btn btn-gold">Explore Gifts</a>
    </div>

    <img src="offers2.jpg" alt="Seasonal Chocolates">
</section>

<section class="offer-cta">
    <div>
        <h2>Don't Miss Out</h2>
        <p>Offers available for a limited time only.</p>
    </div>
    <a href="index.jsp" class="btn btn-gold">Back to Home</a>
</section>

</div>

<jsp:include page="footer1.jsp"/>

</body>
</html>
