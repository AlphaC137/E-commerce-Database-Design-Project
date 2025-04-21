-- =========================================================================
-- E-Commerce Database Schema
-- 
-- Author: Power Learn Project Group 214 Cohort 7
-- Description: Comprehensive schema for an e-commerce platform
--              with support for product variants, inventory management,
--              and product attributes
-- =========================================================================

-- -----------------------------------------------------
-- Enable strict SQL mode for better error handling
-- -----------------------------------------------------
SET SQL_MODE = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION";
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Create database
-- -----------------------------------------------------
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- -----------------------------------------------------
-- Table `brand`
-- Stores information about product manufacturers
-- -----------------------------------------------------
CREATE TABLE brand (
    brand_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    website_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_brand_name (brand_name)
) ENGINE=InnoDB COMMENT='Stores brand information for products';

-- -----------------------------------------------------
-- Table `product_category`
-- Hierarchical category structure for products
-- -----------------------------------------------------
CREATE TABLE product_category (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT UNSIGNED,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT UNSIGNED DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_category_name (category_name),
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Hierarchical product categories';

-- -----------------------------------------------------
-- Table `color`
-- Available color options for products
-- -----------------------------------------------------
CREATE TABLE color (
    color_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(20) NOT NULL COMMENT 'HEX or RGB code',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_color_name (color_name)
) ENGINE=InnoDB COMMENT='Color options for product variations';

-- -----------------------------------------------------
-- Table `size_category`
-- Groups sizes into categories (clothing, shoes, etc.)
-- -----------------------------------------------------
CREATE TABLE size_category (
    size_category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_size_category_name (category_name)
) ENGINE=InnoDB COMMENT='Categories for different size systems';

-- -----------------------------------------------------
-- Table `size_option`
-- Specific sizes within categories
-- -----------------------------------------------------
CREATE TABLE size_option (
    size_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT UNSIGNED NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    size_description VARCHAR(100),
    display_order INT UNSIGNED DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_size_value_category (size_value, size_category_id),
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Specific size options within each size category';

-- -----------------------------------------------------
-- Table `attribute_category`
-- Groups product attributes into categories
-- -----------------------------------------------------
CREATE TABLE attribute_category (
    attribute_category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_attribute_category_name (category_name)
) ENGINE=InnoDB COMMENT='Categories for product attributes (technical, physical, etc.)';

-- -----------------------------------------------------
-- Table `attribute_type`
-- Defines data types for attributes
-- -----------------------------------------------------
CREATE TABLE attribute_type (
    attribute_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_attribute_type_name (type_name)
) ENGINE=InnoDB COMMENT='Data types for product attributes (text, number, boolean, etc.)';

-- -----------------------------------------------------
-- Table `product`
-- Central product information
-- -----------------------------------------------------
CREATE TABLE product (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT UNSIGNED NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    description TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_product_name_brand (product_name, brand_id),
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Core product information';

-- -----------------------------------------------------
-- Table `product_image`
-- Images associated with products
-- -----------------------------------------------------
CREATE TABLE product_image (
    image_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT UNSIGNED DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Stores product image URLs or file references';

-- -----------------------------------------------------
-- Table `product_attribute`
-- Custom attributes for products
-- -----------------------------------------------------
CREATE TABLE product_attribute (
    attribute_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL,
    attribute_category_id INT UNSIGNED NOT NULL,
    attribute_type_id INT UNSIGNED NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    display_order INT UNSIGNED DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_product_attribute (product_id, attribute_name),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Stores custom product specifications and attributes';

-- -----------------------------------------------------
-- Table `product_variation`
-- Links products to their variations (color/size)
-- -----------------------------------------------------
CREATE TABLE product_variation (
    variation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL,
    color_id INT UNSIGNED,
    size_id INT UNSIGNED,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_product_variation (product_id, color_id, size_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Product variations based on color and size combinations';

-- -----------------------------------------------------
-- Table `product_item`
-- Actual inventory items with SKUs and stock levels
-- -----------------------------------------------------
CREATE TABLE product_item (
    item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL,
    variation_id INT UNSIGNED NOT NULL,
    sku VARCHAR(50) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_sku (sku),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Specific purchasable items with inventory tracking';

-- -----------------------------------------------------
-- Insert initial data for testing
-- -----------------------------------------------------

-- Insert brands
INSERT INTO brand (brand_name, description) VALUES 
('Nike', 'Global sports apparel and footwear brand'),
('Samsung', 'Electronics manufacturer'),
('IKEA', 'Furniture and home accessories retailer');

-- Insert product categories
INSERT INTO product_category (category_name, description, parent_category_id) VALUES 
('Electronics', 'Electronic devices and accessories', NULL),
('Clothing', 'Apparel and fashion items', NULL),
('Home & Garden', 'Items for home and garden', NULL),
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Portable computers', 1),
('T-shirts', 'Short-sleeved shirts', 2),
('Shoes', 'Footwear for all occasions', 2);

-- Insert colors
INSERT INTO color (color_name, color_code) VALUES 
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Green', '#00FF00');

-- Insert size categories
INSERT INTO size_category (category_name, description) VALUES 
('Clothing', 'Standard clothing sizes'),
('Shoes', 'Shoe sizes'),
('Electronics', 'Electronics dimensions');

-- Insert size options
INSERT INTO size_option (size_category_id, size_value, size_description, display_order) VALUES 
(1, 'S', 'Small', 1),
(1, 'M', 'Medium', 2),
(1, 'L', 'Large', 3),
(1, 'XL', 'Extra Large', 4),
(2, '38', 'EU Size 38', 1),
(2, '39', 'EU Size 39', 2),
(2, '40', 'EU Size 40', 3),
(2, '41', 'EU Size 41', 4);

-- Insert attribute categories
INSERT INTO attribute_category (category_name, description) VALUES 
('Physical', 'Physical attributes like weight, dimensions'),
('Technical', 'Technical specifications'),
('Material', 'Material composition information');

-- Insert attribute types
INSERT INTO attribute_type (type_name, description) VALUES 
('Text', 'Text values'),
('Number', 'Numeric values'),
('Boolean', 'True/False values');

-- Insert sample products
INSERT INTO product (product_name, brand_id, category_id, base_price, description, is_featured) VALUES 
('Air Max 270', 1, 7, 149.99, 'Lightweight running shoes with Air cushioning', TRUE),
('Galaxy S21', 2, 4, 799.99, 'Flagship smartphone with high-resolution camera', TRUE),
('KALLAX Shelf Unit', 3, 3, 69.99, 'Versatile shelving unit for any room', FALSE);

-- Insert product images
INSERT INTO product_image (product_id, image_url, alt_text, is_primary, display_order) VALUES 
(1, 'https://assets.ajio.com/medias/sys_master/root/20230417/AuJY/643d64b0907deb497aeb3374/-473Wx593H-469473003-white-MODEL.jpg', 'Nike Air Max 270 - Side view', TRUE, 1),
(1, 'https://assets.ajio.com/medias/sys_master/root/20230417/LjeX/643d69c2711cf97ba72e4b2b/-473Wx593H-469473003-white-MODEL4.jpg', 'Nike Air Max 270 - Top view', FALSE, 2),
(2, 'https://cdn.i-scmp.com/sites/default/files/styles/1020x680/public/d8/images/methode/2021/01/15/c2cb3e6a-5581-11eb-84b3-e7426e7b8906_image_hires_004222.jpg?itok=7S4ZuTFx&v=1610642562', 'Samsung Galaxy S21 - Front view', TRUE, 1),
(3, 'https://www.ikea.com/us/en/images/products/kallax-shelf-unit-black-brown__0644754_pe702938_s5.jpg?f=u', 'IKEA KALLAX Shelf in room setting', TRUE, 1);

-- Insert product attributes
INSERT INTO product_attribute (product_id, attribute_category_id, attribute_type_id, attribute_name, attribute_value) VALUES 
(1, 1, 2, 'Weight', '10.5 oz'),
(1, 3, 1, 'Upper Material', 'Engineered mesh'),
(2, 2, 2, 'Screen Size', '6.2 inches'),
(2, 2, 2, 'Battery Capacity', '4000 mAh'),
(3, 1, 2, 'Dimensions', '77 x 77 x 39 cm');

-- Insert product variations
INSERT INTO product_variation (product_id, color_id, size_id, price_adjustment) VALUES 
(1, 1, 5, 0.00),  -- Black, Size 38
(1, 1, 6, 0.00),  -- Black, Size 39
(1, 2, 5, 0.00),  -- White, Size 38
(1, 4, 5, 10.00), -- Blue, Size 38 (costs $10 more)
(2, 1, NULL, 0.00), -- Black phone
(2, 2, NULL, 0.00), -- White phone
(3, 1, NULL, 0.00), -- Black KALLAX
(3, 2, NULL, 0.00); -- White KALLAX

-- Insert product items
INSERT INTO product_item (product_id, variation_id, sku, stock_quantity, price) VALUES 
(1, 1, 'NKE-AM270-BLK-38', 25, 149.99),
(1, 2, 'NKE-AM270-BLK-39', 30, 149.99),
(1, 3, 'NKE-AM270-WHT-38', 15, 149.99),
(1, 4, 'NKE-AM270-BLU-38', 10, 159.99),
(2, 5, 'SAM-GS21-BLK', 50, 799.99),
(2, 6, 'SAM-GS21-WHT', 45, 799.99),
(3, 7, 'IKEA-KLX-BLK', 100, 69.99),
(3, 8, 'IKEA-KLX-WHT', 120, 69.99);

-- -----------------------------------------------------
-- Create views for common operations
-- -----------------------------------------------------

-- Product listing view with primary image
CREATE VIEW vw_product_listing AS
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    pc.category_name,
    p.base_price,
    p.is_featured,
    p.is_active,
    pi.image_url AS primary_image_url
FROM 
    product p
JOIN 
    brand b ON p.brand_id = b.brand_id
JOIN 
    product_category pc ON p.category_id = pc.category_id
LEFT JOIN 
    product_image pi ON p.product_id = pi.product_id AND pi.is_primary = TRUE
WHERE 
    p.is_active = TRUE;

-- Product inventory view
CREATE VIEW vw_product_inventory AS
SELECT 
    pi.item_id,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.color_name,
    so.size_value,
    pi.sku,
    pi.stock_quantity,
    pi.price,
    pi.is_active
FROM 
    product_item pi
JOIN 
    product p ON pi.product_id = p.product_id
JOIN 
    brand b ON p.brand_id = b.brand_id
JOIN 
    product_variation pv ON pi.variation_id = pv.variation_id
LEFT JOIN 
    color c ON pv.color_id = c.color_id
LEFT JOIN 
    size_option so ON pv.size_id = so.size_id;

-- -----------------------------------------------------
-- Enable foreign key checks again
-- -----------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------
-- End of E-Commerce Database Schema
-- -----------------------------------------------------
