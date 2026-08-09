USE olist;

-- CUSTOMER TABLE 

-- SQL query to return the total number of customers.
SELECT COUNT(customer_id) AS total_customers FROM customers;

-- how many customers are in each state.
SELECT customer_state, COUNT(*) AS coustomer_count FROM customers
GROUP BY customer_state
ORDER BY coustomer_count DESC;

-- how many customers are from each city
SELECT customer_city, COUNT(*) AS customer_count FROM customers
GROUP BY customer_city
ORDER BY customer_count DESC;
 
 -- top 10 cities with the highest number of customers.
 SELECT customer_city , COUNT(*) AS customer_count   FROM customers
 GROUP BY customer_city
 ORDER BY  customer_count DESC
 LIMIT 10;
 
 -- how many new customers were acquired each month.
WITH T AS (
 SELECT customer_id, min(order_purchase_timestamp) AS first_purchase_date FROM orders  
GROUP BY customer_id
) 
SELECT DATE_FORMAT(first_purchase_date, '%Y-%m') AS MONTH, COUNT(*) AS total_customers FROM T
GROUP BY DATE_FORMAT(first_purchase_date, '%Y-%m') 
ORDER BY MONTH ;

-- ORDER TABLE

-- total number of orders placed on the Olist platform.
SELECT COUNT(order_id) FROM orders;

-- how order volume changes month by month. 
SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month , COUNT(*) AS order_volume FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')
ORDER BY month ASC;

-- how many orders were placed each year. 
SELECT YEAR(order_purchase_timestamp) AS year, COUNT(*) AS total_orders FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY year ASC;

-- the average number of orders received per day
WITH T AS(
	SELECT DATE(order_purchase_timestamp) AS DAY, COUNT(*) AS daliy_count FROM orders
	GROUP BY DATE(order_purchase_timestamp)
)
SELECT CEIL(avg(daliy_count)) AS avg_daily_ordes FROM T;

-- How many orders were cancelled? 
SELECT COUNT(*) AS cancelled_orders FROM orders 
WHERE order_status ='canceled';

SELECT DISTINCT order_status FROM orders;

-- How many orders were successfully delivered?
SELECT COUNT(*) AS successfully_delivered_orders FROM orders
WHERE order_status ='delivered';

-- The Operations Manager wants to understand the distribution of order statuses.
WITH order_status_summary AS (
SELECT  order_status, COUNT(*) AS total_orders_per_status 
FROM orders
GROUP BY order_status
)
SELECT T.order_status, 
T.total_orders_per_status, 
ROUND(T.total_orders_per_status*100.0 / (SELECT COUNT(*) FROM orders),2)
FROM  order_status_summary T 
ORDER BY T.total_orders_per_status DESC;

-- PRODUCT TABLE

-- How many unique product categories exist in our catalog?
SELECT COUNT(DISTINCT product_category_name) AS count_product_category FROM products ;

-- How many products are available in each category?
SELECT product_category_name, COUNT(*) AS product_count_per_category FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY product_count_per_category DESC;

-- Which product category contains the highest number of products?
WITH product_category_summery AS(
SELECT product_category_name, COUNT(*) AS product_count_per_category FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
),
category_rank AS (
SELECT product_category_name, product_count_per_category,
DENSE_RANK() OVER(ORDER BY product_count_per_category DESC) AS RNK
FROM product_category_summery
)
SELECT product_category_name, product_count_per_category 
FROM category_rank 
WHERE category_rank.RNK = 1 ;

-- Which product category has the fewest products?
WITH product_per_category AS
(
SELECT product_category_name, COUNT(*) AS product_count_per_category
FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
),
rank_catgeory AS
(
SELECT product_category_name, product_count_per_category,
DENSE_RANK() OVER(ORDER BY  product_count_per_category ASC) AS ranks
FROM product_per_category
)
SELECT product_category_name, product_count_per_category 
FROM rank_catgeory
WHERE ranks = 1;

-- SELLER TABLE

-- sellers are registered on the platform?
SELECT COUNT(seller_id) AS total_registered_seller FROM sellers;

-- How many sellers are located in each state?
SELECT seller_state, COUNT(*) AS number_of_sellerse FROM sellers
GROUP BY seller_state
ORDER BY number_of_sellerse DESC;

-- The Sales Team wants to identify the cities with the highest number of registered sellers.
SELECT seller_city, COUNT(*) AS sellers_count FROM sellers
GROUP BY seller_city
ORDER BY sellers_count DESC
LIMIT 10;

-- ORDER_PAYMENTS TABLE

-- What is the total revenue generated from all customer payments?
SELECT SUM(payment_value) AS total_revenue FROM order_payments;

-- What is the average amount customers pay per payment transaction?
WITH price_prt_payment_summary AS(
SELECT order_id, payment_sequential, SUM(payment_value) AS price_per_payments   FROM order_payments
GROUP BY order_id, payment_sequential)
SELECT AVG(price_per_payments) FROM price_prt_payment_summary;

-- What is the highest single payment transaction recorded?
SELECT * FROM order_payments 
WHERE payment_value = (SELECT MAX(payment_value) FROM order_payments);

-- What is the lowest single payment transaction recorded?
SELECT MIN(payment_value) AS lowest_payment  FROM order_payments;

-- How are payment installments distributed across orders?
SELECT payment_installments, COUNT(*) AS transaction_count FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments ASC;



 
