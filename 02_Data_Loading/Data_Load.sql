-- =========================================================
-- 1. CUSTOMERS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 2. ORDERS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 3. ORDER ITEMS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 4. ORDER PAYMENTS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_order_payments.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 5. ORDER REVIEWS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_order_reviews.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 6. PRODUCTS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 7. SELLERS
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_sellers.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 8. PRODUCT CATEGORY NAME TRANSLATION
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 9. GEOLOCATION
-- =========================================================

LOAD DATA LOCAL INFILE 'path_of_geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
