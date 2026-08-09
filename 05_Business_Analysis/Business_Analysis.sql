# Olist SQL Project — Final Approved Queries (Reorganized)

USE olist;

## A. Customer & Geography Analysis

-- 1. Which states have the highest number of customers?
-- Understanding customer distribution helps identify high-demand regions and target markets. 
-- This query counts distinct customers per state and ranks states based on customer volume.
SELECT customer_state, COUNT(DISTINCT customer_unique_id) AS total_customer FROM customers
GROUP BY customer_state
ORDER BY total_customer DESC;

-- 2. Which cities generate the most orders?
-- This helps determine which cities drive the most sales, useful for logistics and regional marketing. 
-- The query joins customers with orders and aggregates order counts by city.
SELECT c.customer_city, COUNT(o.order_id) AS total_orders FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC;

-- 3. What % of customers return for repeat purchases?
-- Repeat customers are crucial for long-term revenue. 
-- This query identifies how many unique customers placed more than one order and calculates their percentage.
WITH Repeated_customer AS(
SELECT c.customer_unique_id FROM orders o
JOIN customers c 
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
),
total_customer_placed_order AS(
SELECT COUNT(DISTINCT c.customer_unique_id) AS total_customer FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
)
SELECT 
(SELECT  total_customer FROM total_customer_placed_order) AS total_customer_placed_order,
COUNT(*) AS repeat_customer,
ROUND(count(*) * 100.0 / (SELECT  total_customer FROM total_customer_placed_order) , 2) AS percentage_repeat
FROM Repeated_customer;

-- 4. What is the average number of orders per customer?
-- This metric helps estimate customer purchasing behavior and engagement. 
-- The query calculates the average number of orders grouped by customer.
WITH customer_with_their_orders AS
(SELECT c.customer_unique_id, COUNT(o.order_id) AS order_counts FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id)
SELECT 
COUNT(customer_unique_id) AS total_customers,
ROUND(AVG(order_counts)  ,2) AS avg_order
FROM customer_with_their_orders ;

-- 5. Which states contribute the highest revenue?
-- Identifying revenue-heavy regions helps prioritize supply chain and delivery resources. 
-- The query aggregates total item prices across orders by customer state.
SELECT c.customer_state, SUM(oi.price) AS revenue FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- 6. Top 10 highest spending customers (Customer Lifetime Value)
-- CLV helps businesses understand their most valuable customers. 
-- This query sums total spending per customer and returns the top 10.
SELECT c.customer_unique_id, SUM(op.payment_value) AS total_spend_amount FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spend_amount DESC
LIMIT 10;

## B. Order & Logistics Performance

-- 1. What is the average time from purchase to delivery?
-- Delivery time is a key metric for logistics efficiency. 
-- This query computes the average duration between order placement and delivery.
SELECT
  FLOOR(AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp,
  order_delivered_customer_date)) / 24) AS days,
  ROUND(MOD(AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp,
  order_delivered_customer_date)), 24)) AS hours
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;


-- 2. What is the difference between estimated and actual delivery?
-- This helps measure delivery accuracy and customer experience. The query returns delays or early deliveries for every order.
SELECT
  order_id,
  order_delivered_customer_date,
  order_estimated_delivery_date,
  DATEDIFF(
    order_delivered_customer_date,
    order_estimated_delivery_date
  ) AS delivery_delay_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- 3. How many orders were delivered late?
-- Late deliveries directly impact customer satisfaction. This query counts all orders delivered after the estimated delivery date.
SELECT
  COUNT(*) AS late_delivered_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;


-- 4. How long do deliveries actually take vs estimates? 
-- This query prepares delivery duration metrics used for SLA and delay analysis. 
-- It computes actual delivery days and compares them with estimated delivery timelines.
SELECT
  ROUND(AVG(DATEDIFF(
    order_delivered_customer_date,
    order_purchase_timestamp
  )), 2) AS avg_actual_delivery_days,
  ROUND(AVG(DATEDIFF(
    order_estimated_delivery_date,
    order_purchase_timestamp
  )), 2) AS avg_estimated_delivery_days
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- 5. Which sellers have the best delivery performance?
SELECT
  s.seller_id,
  ROUND(AVG(DATEDIFF(
    o.order_delivered_carrier_date, o.order_approved_at
  )), 2) AS average_shipping_time_days
FROM sellers s
JOIN order_items oi
  ON s.seller_id = oi.seller_id
JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_approved_at IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_carrier_date >= o.order_approved_at
GROUP BY s.seller_id
ORDER BY average_shipping_time_days ASC;


-- 6. Which sellers have the worst delivery delays?
-- Slow sellers impact overall marketplace ratings and logistics cost. This query lists sellers with the longest average shipping duration.
SELECT
  oi.seller_id,
  ROUND(AVG(DATEDIFF(
    o.order_delivered_carrier_date,
    o.order_approved_at
  )), 2) AS average_shipping_time_days
FROM order_items oi
JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_approved_at IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_carrier_date >= o.order_approved_at
GROUP BY oi.seller_id
ORDER BY average_shipping_time_days DESC;

-- 7. Which states experience the slowest deliveries?
-- Delivery time varies by geography due to distance and logistics capacity. This query calculates average delivery times per state.
SELECT c.customer_state,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),2) AS avg_delivery_time FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp IS NOT NULL
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_purchase_timestamp <= o.order_delivered_customer_date
GROUP BY c.customer_state
ORDER BY avg_delivery_time DESC;

-- 8. What is the distribution of delivery times per category?
-- Some product types take longer to prepare or ship. This query analyzes delivery speed across product categories.
SELECT p.product_category_name, pct.product_category_name_english,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),2) AS delivery_time
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp IS NOT NULL
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_purchase_timestamp <= o.order_delivered_customer_date
GROUP BY p.product_category_name, pct.product_category_name_english
ORDER BY delivery_time DESC;



## C. Product & Category Analytics

-- 1. Which product categories sell the most units?
-- Understanding unit sales by category helps businesses identify popular product segments. This query counts the number of items sold per category and ranks them from highest to lowest.
WITH category_unit_summary AS (
	SELECT p.product_category_name,pct.product_category_name_english,
	COUNT(oi.order_item_id) AS total_items,
	DENSE_RANK() OVER( ORDER BY COUNT(oi.order_item_id) DESC ) AS RNK  FROM order_items oi
	JOIN products p
	ON oi.product_id = p.product_id
	LEFT JOIN product_category_name_translation pct
	ON p.product_category_name = pct.product_category_name
	GROUP BY p.product_category_name, pct.product_category_name_english
)
SELECT product_category_name, product_category_name_english, total_items FROM category_unit_summary
WHERE RNK IN (1,2,3);

-- 2. Which categories generate the highest revenue?
-- Revenue contribution per category helps identify top-performing product types. This query sums item prices to determine total revenue by product category.
SELECT
  p.product_category_name,
  ptc.product_category_name_english,
  SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation ptc
  ON p.product_category_name = ptc.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name,
  ptc.product_category_name_english
ORDER BY total_revenue DESC;

-- 3. What is the average price by category?
-- Average price analysis helps identify premium vs. budget categories. This query calculates the mean selling price for each product category.
SELECT p.product_category_name, pct.product_category_name_english,
ROUND(AVG(oi.price),2) AS avg_price FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY p.product_category_name, pct.product_category_name_english
ORDER BY avg_price DESC ;

-- 4. Which category has the highest freight charges?
-- Freight cost insights help evaluate logistics expenses across categories. This query computes the average freight value per category.

SELECT
  p.product_category_name,
  ptc.product_category_name_english,
  ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation ptc
  ON p.product_category_name = ptc.product_category_name
GROUP BY p.product_category_name,
  ptc.product_category_name_english
ORDER BY avg_freight_value DESC;

-- 5. Are heavier items more expensive?
-- This helps determine whether product weight influences pricing. 
SELECT 
CASE 
	WHEN p.product_weight_g BETWEEN 0 AND 500 THEN '1. 0-500g'
    WHEN p.product_weight_g BETWEEN 501 AND 1000 THEN '2. 501-1000g'
    WHEN p.product_weight_g BETWEEN 1001 AND 1500 THEN '3. 1001-1500g'
    WHEN p.product_weight_g BETWEEN 1501 AND 2000 THEN '4. 1501-2000g'  
    WHEN p.product_weight_g BETWEEN 2001 AND 2500 THEN '5. 2001-2500g'
    ELSE '6. 2500g+'
END AS weight_category , AVG(oi.price) AS avg_price
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY weight_category
ORDER BY weight_category;

-- 6. Which categories have the highest late delivery percentage?
-- Late delivery trends by category help identify supply chain bottlenecks. 
-- This query calculates the share of late orders for each product category.
SELECT p.product_category_name, pct.product_category_name_english,
COUNT(DISTINCT o.order_id) AS total_delivery_per_category,
COUNT( DISTINCT(CASE WHEN  o.order_estimated_delivery_date < o.order_delivered_customer_date THEN o.order_id END)) AS late_delivery_count,
ROUND(
	COUNT(DISTINCT(CASE WHEN o.order_estimated_delivery_date < o.order_delivered_customer_date THEN o.order_id END))*100.0 / COUNT(DISTINCT o.order_id),2)  AS late_delivery_percentage
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp IS NOT NULL
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY p.product_category_name, pct.product_category_name_english
ORDER BY late_delivery_percentage DESC;


-- 7. Top 10 most profitable categories
-- Profitability gives a true measure of business value after deducting logistics costs. This query computes profit = price – freight and returns the top 10 categories.
SELECT p.product_category_name, pct.product_category_name_english,
SUM(oi.price - oi.freight_value) AS revenue_after_freight FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name, pct.product_category_name_english
ORDER BY revenue_after_freight DESC
LIMIT 10 ;


## D. Payment Analysis

-- 1. What are the most common payment types?
-- This helps understand customer preferences in payment methods. The query counts how often each payment type is used.

SELECT
  op.payment_type,
  COUNT(DISTINCT op.order_id) AS order_count
FROM order_payments op
JOIN orders o
  ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY order_count DESC;


-- 2. Which payment installment ranges are most used?
-- Installment behavior is important for financial planning and fraud prevention. This query groups installment counts into meaningful ranges.
SELECT
CASE 
	WHEN payment_installments= 1 THEN '1-installment'
    WHEN payment_installments BETWEEN 2 AND 4 THEN '2-4 installments'
    WHEN payment_installments BETWEEN 5 AND 7 THEN '5-7 installments'
    WHEN payment_installments BETWEEN 8 AND 10 THEN '8-10 installments'
    WHEN payment_installments BETWEEN 11 AND 13 THEN '11-13 installments'
    WHEN payment_installments BETWEEN 14 AND 16 THEN '14-16 installments'
    ELSE '17+ installments'
END AS installments_range,
COUNT( order_id) AS order_count
FROM order_payments
GROUP BY installments_range
ORDER BY installments_range DESC
LIMIT 1;

-- 3. What % of orders are paid using multiple installments?
-- This indicates how often customers rely on credit-based payments. The query calculates the percentage of orders with more than one installment.
SELECT COUNT(DISTINCT order_id) AS total_orders,
							COUNT(DISTINCT (CASE WHEN payment_installments > 1 THEN order_id END)) AS total_orders_with_multiple_installments,
							ROUND(COUNT(DISTINCT (CASE WHEN payment_installments > 1 THEN order_id END)) *100.0 /COUNT(DISTINCT order_id) ,2) AS percentage_multiple_installment
FROM order_payments
WHERE payment_installments IS NOT NULL ;


-- 4. How much revenue comes from different payment types?
-- This helps identify which payment channels contribute the most sales. The query sums revenue associated with each payment method.
SELECT op.payment_type, SUM(op.payment_value) AS payment_type_revenue FROM order_payments op
JOIN orders o
ON op.order_id = o.order_id 
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY payment_type_revenue DESC;


-- 5. Average order value by payment type
-- Customers using certain payment methods (like credit cards) may have higher order values. This query calculates the mean order total grouped by payment type.
WITH orders_total AS 
(
SELECT order_id, SUM(price) AS order_vaule FROM order_items
GROUP BY order_id
)
SELECT op.payment_type, ROUND(AVG(order_vaule),2) AS average_order_vaule_par_payments FROM order_payments op
JOIN orders_total ot
ON op.order_id = ot.order_id
GROUP BY op.payment_type
ORDER BY average_order_vaule_par_payments DESC ;



## E. Review & Customer Satisfaction

-- 1. What is the average review score?
-- This is a baseline indicator for overall customer satisfaction. The query computes the average star rating across all reviews.
SELECT
  ROUND(AVG(ors.review_score), 2) AS average_review_score
FROM order_reviews ors
JOIN orders o
  ON o.order_id = ors.order_id
WHERE o.order_status = 'delivered'
  AND ors.review_score IS NOT NULL;


-- 2. Do late deliveries lead to lower review scores?
-- Delivery delays often reduce customer satisfaction. This query compares average review scores between late and on-time orders.
SELECT
	CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on-time'
		 WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late'
	END AS deliverey_time,
	AVG(ors.review_score) AS avg_review_score
FROM orders o
JOIN order_reviews ors
ON o.order_id = ors.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_estimated_delivery_date IS NOT NULL
AND ors.review_score IS NOT NULL
GROUP BY deliverey_time;

-- 3. What is the distribution of review scores?
-- Score distribution reveals how polarized customer feedback is. This query counts reviews for each rating level (1–5).
SELECT
  review_score,
  COUNT(*) AS review_counts
FROM order_reviews
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;


-- 4. Which categories receive the lowest ratings?
-- Low-rated categories may suffer from quality issues or misleading listings. This query finds categories with the poorest average review scores.
SELECT p.product_category_name, pct.product_category_name_english, 
						ROUND(AVG(ors.review_score),2) AS avg_rating_per_category
FROM orders o
JOIN order_reviews ors
ON o.order_id = ors.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
AND ors.review_score IS NOT NULL
GROUP BY p.product_category_name, pct.product_category_name_english
ORDER BY avg_rating_per_category ASC;

-- 5. Which sellers receive the best and worst ratings?
-- Seller performance impacts customer trust and marketplace reputation. These queries compute average ratings per seller.
SELECT s.seller_id , COUNT(ors.review_id) AS total_reviews, ROUND(AVG(ors.review_score),2) AS avg_review_score FROM orders o
JOIN order_reviews ors
ON o.order_id = ors.order_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
AND ors.review_score IS NOT NULL
GROUP BY  s.seller_id
ORDER BY avg_review_score ASC;

-- 6. How long do customers take to respond with reviews?
-- Review response time reflects how quickly customers engage post-delivery. This query computes the average time between review creation and answer timestamp.
SELECT 
ROUND(AVG(TIMESTAMPDIFF(HOUR, review_creation_date, review_answer_timestamp)),2) AS avg_reviews_response_time_hour
FROM order_reviews
WHERE review_creation_date IS NOT NULL
AND review_answer_timestamp IS NOT NULL
AND review_creation_date <  review_answer_timestamp;

