-- =====================================================
-- Sprint 3 : Data Validation
-- Project : Olist Brazilian E-Commerce
-- Objective : Identify data quality issues
-- =====================================================
USE olist;

SELECT * FROM customers;

-- Table 1 — Customers 
-- Before any analysis, we need to ensure the customers table is reliable. We will validate one rule at a time.

-- Are there customers where this value is NULL or empty?
SELECT * FROM customers
WHERE customer_id IS NULL OR customer_id = '';

-- Find records where customer_unique_id is missing or blank.
SELECT * FROM customers
WHERE customer_unique_id IS NULL OR customer_unique_id = '';

-- Checks only for missing (NULL) ZIP codes.
SELECT * FROM customers 
WHERE customer_zip_code_prefix IS NULL OR customer_zip_code_prefix = '';

-- Write a query to find products where product_category_name is missing.
SELECT * FROM products 
WHERE product_category_name IS NULL OR TRIM(product_category_name) = "";

-- Find duplicate customer_id values in the customers table.
SELECT customer_id, COUNT(*) AS DUPLICATE_COUNT FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- List all repeated customer_unique_id values along with the number of times they appear.
SELECT customer_unique_id, COUNT(*) AS duplicate_count  FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

-- Find customers whose customer_state is not one of the valid Brazilian state abbreviations.
SELECT * FROM customers
WHERE customer_state NOT IN (
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO',
    'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI',
    'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
);

-- Find customers with invalid ZIP codes.
SELECT * FROM customers
WHERE customer_zip_code_prefix < 1;

-- How many customers have never placed an order?
SELECT C.* FROM customers C
LEFT JOIN orders O
ON C.customer_id = O.customer_id
WHERE O.customer_id IS NULL;


-- Are there any orders whose customer_id does not exist in the customers table?
SELECT C.* FROM  orders O
LEFT JOIN  customers C 
ON O.customer_id = C.customer_id
WHERE C.customer_id IS NULL;


SELECT 
	SUM( CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END ) AS CUSTOMER_ID_NULL_COUNT,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS UNIQUE_ID_NULL_COUNT,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_code_prefix_NULL_COUNT,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS customer_city_NULL_COUNT,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS customer_state_COUNT
FROM customers;


-- Orders Table

-- Find orders where order_status is missing.
SELECT * FROM orders
WHERE order_status IS NULL OR TRIM(order_status)='';

-- Find orders where order_purchase_timestamp is missing.
SELECT * FROM orders 
WHERE order_purchase_timestamp IS NULL;

-- Find duplicate order_id values in the orders table.
SELECT order_id, COUNT(*) AS DUPLICATE_COUNT FROM orders 
GROUP BY order_id
HAVING COUNT(*) > 1;

-- List all distinct values of order_status.
SELECT DISTINCT(order_status) FROM  orders;

-- Find orders whose order_status is not valid status
SELECT * FROM orders
WHERE order_status NOT IN('unavailabl', 'shipped', 'processing', 'invoiced', 'delivered', 'created', 'canceled', 'approved');




