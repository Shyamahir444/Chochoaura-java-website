<% boolean loggedIn = (session != null && session.getAttribute("user_id") != null); %>
<title>header | ChocoAura</title>
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
    padding-top:80px;
}

.site-header{
    background:#2a1414; 
    padding:15px 0;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    z-index:1000;
}

.header-container{
    width:90%;
    margin:auto;
    display:flex;
    align-items:center;
    justify-content:space-between;
}

.logo a{
    color:#f5d48e;
    font-size:26px;
    font-weight:700;
    text-decoration:none;
}

.nav-menu a{
    color:#fff;
    margin:0 15px;
    text-decoration:none;
    font-size:15px;
}

.nav-menu a:hover{
    color:#f5d48e;
}

.header-icons{
    display:flex;
    gap:22px;
}

.icon-box{
    position:relative;
    color:#fff;
    cursor:pointer;
    outline:none;
}

.icon-box i{
    font-size:18px;
    transition:0.2s;
}

.icon-box:hover i{
    color:#f5d48e;
    transform:scale(1.1);
}

.dropdown{
    position:absolute;
    top:40px;
    right:0;
    background:#2a1414;
    width:210px;
    padding:14px;
    border-radius:10px;
    box-shadow:0 12px 30px rgba(0,0,0,0.25);
    opacity:0;
    visibility:hidden;
    transform:translateY(12px);
    transition:all 0.3s ease;
    z-index:9999;
}

.icon-box:focus-within .dropdown{
    opacity:1;
    visibility:visible;
    transform:translateY(0);
}

.dropdown p{
    font-size:14px;
    color:#666;
    margin-bottom:10px;
}

.dropdown a{
    display:block;
    padding:8px 12px;
    margin:5px 0;
    border-radius:6px;
    text-decoration:none;
    font-size:14px;
    color:#f5d48e;
}

.dropdown a:hover{
    background:#f5d48e;
    color:#2a1414;
}

</style>

<header class="site-header">
    <div class="header-container">

        <div class="logo">
            <a href="index.jsp">ChocoAura</a>
        </div>

        <nav class="nav-menu">
            <a href="index.jsp">Home</a>
            <a href="about.jsp">About</a>
            <a href="products.jsp">Chocolates</a>
            <a href="gifts.jsp">Gifts</a>
            <a href="offers.jsp">Offers</a>
            <a href="contact.jsp">Contact</a>
        </nav>

        <div class="header-icons">

            <div class="icon-box" tabindex="0">
                <i class="fa-regular fa-heart"></i>
                <div class="dropdown">
                    <p>Your wishlist is empty</p>
                    <a href="wishlist.jsp">View Wishlist</a>
                </div>
            </div>

            <div class="icon-box" tabindex="0">
                <i class="fa-solid fa-cart-shopping"></i>
                <div class="dropdown">
                    <p>No items in cart</p>
                    <a href="cart.jsp">View Cart</a>
                    <a href="checkout.jsp">Checkout</a>
                </div>
            </div>

            <div class="icon-box" tabindex="0">
                <i class="fa-regular fa-user"></i>
                <div class="dropdown">
                    <% if (loggedIn) { %>
                    <a href="profile.jsp">My Profile</a>
                    <a href="logout">Logout</a>
                    <% } else { %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                    <% } %>
                </div>
            </div>

        </div>
    </div>
</header>
