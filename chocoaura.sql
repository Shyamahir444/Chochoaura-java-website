-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2026 at 06:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chocoaura`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `address_line` varchar(255) NOT NULL,
  `city` varchar(80) NOT NULL,
  `state` varchar(80) NOT NULL,
  `pincode` varchar(15) NOT NULL,
  `address_type` varchar(20) DEFAULT 'Home',
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `full_name`, `mobile`, `address_line`, `city`, `state`, `pincode`, `address_type`, `is_default`, `created_at`) VALUES
(2, 10, 'Ashish jatapara', '9904011801', 'Jasdan', 'Rajkot', 'Gujarat', '360050', 'Home', 0, '2026-03-10 10:04:53');

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`) VALUES
(1, 'admin@chocoaura.com', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `weight` varchar(20) DEFAULT '250g',
  `quantity` int(11) NOT NULL DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(5, 'Assorted Boxes'),
(1, 'Dark Chocolates'),
(6, 'Gift Hampers'),
(2, 'Milk Chocolates'),
(7, 'Premium Chocolates'),
(4, 'Truffle Chocolates'),
(3, 'White Chocolates');

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `address_id` int(11) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `order_number` varchar(30) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` varchar(30) DEFAULT 'Placed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `address_id`, `payment_method_id`, `order_number`, `total_amount`, `status`, `created_at`) VALUES
(1, 10, 2, NULL, 'CA1773137132652', 400.00, 'Delivered', '2026-03-10 10:05:32'),
(2, 10, 2, NULL, 'CA1773219637205', 400.00, 'Delivered', '2026-03-11 09:00:37'),
(3, 10, 2, NULL, 'CA1773854516690', 470.00, 'Delivered', '2026-03-18 17:21:56'),
(4, 10, 2, NULL, 'CA1774115737551', 400.00, 'Shipped', '2026-03-21 17:55:37');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `quantity`, `price`) VALUES
(1, 1, 1, 'Golden Lens Truffle', 1, 350.00),
(2, 2, 1, 'Golden Lens Truffle', 1, 350.00),
(3, 3, 2, 'Macro Mocha Bites', 1, 420.00),
(4, 4, 1, 'Golden Lens Truffle', 1, 350.00);

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `card_holder` varchar(100) NOT NULL,
  `card_last_four` varchar(4) NOT NULL,
  `card_type` varchar(20) DEFAULT 'Visa',
  `expiry_month` varchar(2) DEFAULT NULL,
  `expiry_year` varchar(4) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT 'Chocolates',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image`, `category`, `created_at`) VALUES
(1, 'Golden Lens Truffle', 'Premium truffle chocolates inspired by golden hour tones. Smooth, rich and elegant.', 350.00, 'product1.jpg', 'Truffle Chocolates', '2026-03-03 16:31:22'),
(2, 'Macro Mocha Bites', 'Deep mocha flavored chocolates crafted for true coffee-chocolate lovers.', 420.00, 'product2.jpg', 'Dark Chocolates', '2026-03-03 16:31:22'),
(3, 'Studio Swirl Bonbons', 'Beautifully swirled bonbons with a silky chocolate core.', 399.00, 'product3.jpg', 'Assorted Boxes', '2026-03-03 16:31:22'),
(4, 'Rose Tint Click Box', 'Romantic rose-infused chocolates packed in a premium gift box.', 499.00, 'product4.jpg', 'Premium Chocolates', '2026-03-03 16:31:22'),
(5, 'Soft Focus Cup Truffles', 'Cup-shaped truffles with a smooth melt-in-mouth texture.', 450.00, 'product5.jpg', 'Truffle Chocolates', '2026-03-03 16:31:22'),
(6, 'Blush Frame Delights', 'A delicate chocolate collection framed with elegance and flavor.', 520.00, 'product6.jpg', 'Milk Chocolates', '2026-03-03 16:31:22'),
(7, 'Cocoa Contrast Balls', 'Dark and milk chocolate contrast balls with bold cocoa notes.', 380.00, 'product7.jpg', 'Dark Chocolates', '2026-03-03 16:31:22'),
(8, 'Heart Capture Praline', 'Heart-shaped pralines perfect for gifting your loved ones.', 460.00, 'product8.jpg', 'Premium Chocolates', '2026-03-03 16:31:22'),
(9, 'Dark Pixel Squares', 'Minimalist dark chocolate squares with intense cocoa flavor.', 340.00, 'product9.jpg', 'Dark Chocolates', '2026-03-03 16:31:22'),
(10, 'Citrus Exposure Medley', 'A refreshing mix of citrus-infused premium chocolates.', 480.00, 'product10.jpg', 'Assorted Boxes', '2026-03-03 16:31:22'),
(11, 'Petal Shot Chocolates', 'Floral-inspired chocolates with a luxurious finish.', 510.00, 'product11.jpg', 'Premium Chocolates', '2026-03-03 16:31:22'),
(12, 'Ivory Glow Hearts', 'White chocolate hearts glowing with creamy sweetness.', 560.00, 'product12.jpg', 'White Chocolates', '2026-03-03 16:31:22'),
(13, 'Love Lens Duo Hearts', 'A romantic duo of heart-shaped premium chocolates.', 499.00, 'product13.jpg', 'Gift Hampers', '2026-03-03 16:31:22'),
(14, 'Royal Shutter Collection', 'A royal assortment of handcrafted premium chocolates.', 699.00, 'product14.jpg', 'Gift Hampers', '2026-03-03 16:31:22'),
(15, 'Bloom Frame Signature Hearts', 'Signature heart chocolates designed for special occasions.', 620.00, 'product15.jpg', 'White Chocolates', '2026-03-03 16:31:22'),
(17, 'Nutirent chocklet', 'Whether enjoyed as a snack or used as a supplement for daily nutrition, Nutrient Chocolate offers the perfect balance of taste and health in every bite.', 350.00, 'uploads/7b31c162-6628-42b0-8052-059a97f1bfbb.png', 'Premium Chocolates', '2026-03-21 19:10:00'),
(18, 'Dark Delight Chocolate', 'A rich and intense chocolate made from premium dark cocoa. Perfect for those who love a slightly bitter taste with deep flavor. Packed with antioxidants, itâs a healthy and satisfying treat.', 412.00, 'uploads/a2be604e-eef8-4224-820c-c87d4a39b7f0.png', 'Truffle Chocolates', '2026-03-21 19:18:20'),
(19, 'Nutty Crunch Chocolate', 'A delicious blend of smooth milk chocolate and crunchy roasted nuts. Every bite gives a perfect mix of sweetness and crispiness, making it ideal for snack lovers.', 510.00, 'uploads/9a2369b7-8f02-416b-9211-663ed2930dd9.png', 'Assorted Boxes', '2026-03-21 19:31:15'),
(20, 'Caramel Bliss Chocolate', 'Soft, creamy caramel wrapped in silky milk chocolate. This chocolate melts in your mouth and delivers a sweet, buttery flavor that everyone loves.', 420.00, 'uploads/45b001c6-b434-4456-810d-7dd841afbaf4.png', 'Gift Hampers', '2026-03-21 19:31:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_image` varchar(255) DEFAULT 'default_user.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `address`, `phone`, `date_of_birth`, `created_at`, `profile_image`) VALUES
(10, 'chocha shyam', 'syamahir08@gmail.com', '444444', 'krishna deluxe opposite suncity titanum', '+919313815795', '2006-05-22', '2026-03-04 16:12:43', '10_1773854943398_P-1..png'),
(11, 'SHYAM CHOCHA', 'schocha896@rku.ac.in', '111111', 'rajkot', '9313815795', '2006-05-22', '2026-03-04 17:36:43', '1772645803278_WhatsApp Image 2025-03-18 at 20.17.32_7b6f208d.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`id`, `user_id`, `product_id`, `added_at`) VALUES
(1, 10, 1, '2026-03-10 10:01:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_addresses_user` (`user_id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cart_user_product_weight` (`user_id`,`product_id`,`weight`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_cart_user` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact_email` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_orders_user` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_order_items_order` (`order_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payment_methods_user` (`user_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_wishlist_user_product` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_wishlist_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD CONSTRAINT `payment_methods_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
