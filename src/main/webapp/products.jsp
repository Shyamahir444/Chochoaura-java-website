<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.chocoaura.DBConnection" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shop | ChocoAura</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins', sans-serif;
}

body{
    background:#f5d48e;
    padding-top:120px;
    color:#fff;
}

.shop-wrapper{
    width:1200px;
    margin:auto;
    display:flex;
    gap:30px;
}

.filter{
    width:260px;
    background:#1f0f0f;
    padding:22px;
    border-radius:18px;
    position:sticky;
    top:140px;
    height:fit-content;
    border:1px solid rgba(245,212,142,0.3);
}

.filter h3{
    color:#f5d48e;
    margin-bottom:15px;
}

.filter h4{
    font-size:14px;
    color:#f5d48e;
    margin:18px 0 10px;
}

.filter label{
    display:block;
    font-size:13px;
    color:#ccc;
    margin-bottom:6px;
}

.shop-content{
    flex:1;
}

.top-bar{
    display:flex;
    justify-content:flex-end;
    margin-bottom:20px;
}

.top-bar select{
    padding:8px 14px;
    border-radius:20px;
    border:1px solid #f5d48e;
    background:#1f0f0f;
    color:#f5d48e;
}

.products{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:26px;
}

.card{
    background:#2a1414;
    border-radius:20px;
    overflow:hidden;
    position:relative;
    border:1px solid rgba(245,212,142,0.3);
}

.card img{
    width:100%;
    height:220px;
    object-fit:cover;
}

.badge{
    position:absolute;
    top:12px;
    left:12px;
    background:#f5d48e;
    color:#2a1414;
    font-size:12px;
    padding:4px 12px;
    border-radius:20px;
    font-weight:600;
}

.icons{
    position:absolute;
    top:12px;
    right:12px;
    display:flex;
    flex-direction:column;
    gap:8px;
}

.icons i{
    background:#1f0f0f;
    color:#f5d48e;
    padding:8px;
    border-radius:50%;
    cursor:pointer;
}

.card-body{
    padding:15px;
}

.card-body h4{
    color:#fff;
    font-size:16px;
}

.rating{
    font-size:13px;
    color:gold;
    margin:6px 0;
}

.price{
    color:#f5d48e;
}

.price-row{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-top:8px;
}

.pick-btn{
    background:#f5d48e;
    border:none;
    color:#2a1414;
    padding:6px 14px;
    border-radius:20px;
    font-size:13px;
    cursor:pointer;
    font-weight:600;
}

.pagination{
    display:flex;
    justify-content:center;
    gap:12px;
    margin:50px 0;
}

.pagination button{
    background:none;
    border:none;
    font-size:18px;
    color:#2a1414;
    cursor:pointer;
}

.pagination button.active{
    font-weight:900;
    text-decoration:underline;
}
</style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="shop-wrapper">

<form class="filter" action="products.jsp" method="GET">
    <h3>Filter Chocolates</h3>

    <h4>Categories</h4>
    <label><input type="checkbox" name="category" value="All"> All Chocolates</label>
    <label><input type="checkbox" name="category" value="Dark Chocolates"> Dark Chocolates</label>
    <label><input type="checkbox" name="category" value="Milk Chocolates"> Milk Chocolates</label>
    <label><input type="checkbox" name="category" value="White Chocolates"> White Chocolates</label>
    <label><input type="checkbox" name="category" value="Truffle Chocolates"> Truffle Chocolates</label>
    <label><input type="checkbox" name="category" value="Assorted Boxes"> Assorted Boxes</label>
    <label><input type="checkbox" name="category" value="Gift Hampers"> Gift Hampers</label>
    <label><input type="checkbox" name="category" value="Premium Chocolates"> Premium Chocolates</label>

    <h4>Price</h4>
    <label><input type="radio" name="price" value="0-500"> ₹0 - ₹500</label>
    <label><input type="radio" name="price" value="500-1000"> ₹500 - ₹1000</label>
    <input type="hidden" name="sort" value="<%= request.getParameter("sort") != null ? request.getParameter("sort") : "default" %>">
    
    <button type="submit" class="pick-btn" style="width:100%; margin-top:15px;">Apply Filters</button>
</form>

<div class="shop-content">

<div class="top-bar">
    <select onchange="applySort(this.value)">
        <option value="default" <%= request.getParameter("sort") == null || "default".equals(request.getParameter("sort")) ? "selected" : "" %>>Default Sorting</option>
        <option value="asc" <%= "asc".equals(request.getParameter("sort")) ? "selected" : "" %>>Price Low to High</option>
        <option value="desc" <%= "desc".equals(request.getParameter("sort")) ? "selected" : "" %>>Price High to Low</option>
    </select>
</div>

<div class="products">

<%
try (Connection con = DBConnection.getConnection()) {
    
    String[] categories = request.getParameterValues("category");
    String priceFilter = request.getParameter("price");
    String sort = request.getParameter("sort");
    
    StringBuilder sql = new StringBuilder("SELECT id, name, price, image FROM products WHERE 1=1");
    List<Object> params = new ArrayList<>();
    
    // Category Filter
    if (categories != null && categories.length > 0) {
        boolean hasAll = false;
        List<String> validCats = new ArrayList<>();
        for (String c : categories) {
            if ("All".equals(c)) {
                hasAll = true;
                break;
            }
            validCats.add(c);
        }
        if (!hasAll && !validCats.isEmpty()) {
            sql.append(" AND category IN (");
            for (int i = 0; i < validCats.size(); i++) {
                if (i > 0) sql.append(",");
                sql.append("?");
                params.add(validCats.get(i));
            }
            sql.append(")");
        }
    }
    
    // Price Filter
    if (priceFilter != null) {
        if ("0-500".equals(priceFilter)) {
            sql.append(" AND price BETWEEN 0 AND 500");
        } else if ("500-1000".equals(priceFilter)) {
            sql.append(" AND price BETWEEN 500 AND 1000");
        }
    }
    
    if ("asc".equals(sort)) {
        sql.append(" ORDER BY price ASC");
    } else if ("desc".equals(sort)) {
        sql.append(" ORDER BY price DESC");
    } else {
        sql.append(" ORDER BY id");
    }
    
    try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        try (ResultSet rs = ps.executeQuery()) {
    while (rs.next()) {
        int pid = rs.getInt("id");
        String pname = rs.getString("name");
        double price = rs.getDouble("price");
        String img = rs.getString("image");
        if (img == null) img = "product" + pid + ".jpg";
%>
<div class="card">
    <div class="icons">
        <a href="wishlist?action=add&id=<%= pid %>&from=products.jsp" style="color:inherit;" title="Add to Wishlist"><i class="fa-regular fa-heart"></i></a>
        <a href="cart?action=add&id=<%= pid %>&from=products.jsp" style="color:inherit;" title="Add to Cart"><i class="fa-solid fa-cart-shopping"></i></a>
    </div>
    <img src="<%= img %>" alt="<%= pname %>">
    <div class="card-body">
        <h4><%= pname %></h4>
        <div class="rating">★★★★★</div>
        <div class="price-row">
            <div class="price">₹<%= String.format("%.0f", price) %></div>
            <button class="pick-btn" onclick="goDetails(<%= pid %>)">View Details</button>
        </div>
    </div>
</div>
<%
    }
        }
    }
} catch (Exception e) { 
    e.printStackTrace(); 
}
%>

</div>

<div class="pagination">
    <button onclick="prevPage()">«</button>
    <button onclick="goPage(1)" class="page-btn active">1</button>
    <button onclick="goPage(2)" class="page-btn">2</button>
    <button onclick="goPage(3)" class="page-btn">3</button>
    <button onclick="nextPage()">»</button>
</div>

</div>
</div>

<jsp:include page="footer1.jsp"/>
<script>
let currentPage = 1;
const itemsPerPage = 9;
const cards = document.querySelectorAll(".card");
const pageButtons = document.querySelectorAll(".page-btn");

function applySort(val){
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort', val);
    window.location.search = urlParams.toString();
}

function showPage(page){
    currentPage = page;

    let start = (page - 1) * itemsPerPage;
    let end = start + itemsPerPage;

    cards.forEach((card, index) => {
        card.style.display = (index >= start && index < end) ? "block" : "none";
    });

    pageButtons.forEach(btn => btn.classList.remove("active"));
    pageButtons[page - 1].classList.add("active");
}

function goPage(page){
    showPage(page);
}

function nextPage(){
    if(currentPage < pageButtons.length){
        showPage(currentPage + 1);
    }
}

function prevPage(){
    if(currentPage > 1){
        showPage(currentPage - 1);
    }
}

/* INITIAL LOAD */
showPage(1);

/* EXISTING FUNCTIONS */
function goDetails(id){
    window.location.href = "productDetails.jsp?id=" + id;
}

const totalPages = Math.ceil(cards.length / itemsPerPage);
</script>


</body>
</html>
