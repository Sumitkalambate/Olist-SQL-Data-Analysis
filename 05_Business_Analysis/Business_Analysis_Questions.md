# Business Analysis — SQL Questions & Queries

This document provides the business questions addressed in `6.Business_Analysis.sql`, along with the SQL queries used to answer them.

The purpose is to make the analytical work easy to understand from a business perspective rather than presenting SQL code without context.

> **Dataset:** Olist Brazilian E-Commerce Public Dataset  
> **Database:** MySQL  

---

# A. Customer & Geography Analysis

## 1. Which states have the highest number of customers?

**Business Purpose:**  
Understanding customer distribution helps identify high-demand regions and target markets.

```sql
SELECT customer_state, COUNT(DISTINCT customer_unique_id) AS total_customer
FROM customers
GROUP BY customer_state
ORDER BY total_customer DESC;
```

---

## 2. Which cities generate the most orders?

**Business Purpose:**  
Identifying cities with the highest order volume helps support regional marketing and logistics planning.

```sql
SELECT
    c.customer_city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC;
```

---

## 3. What percentage of customers return for repeat purchases?

**Business Purpose:**  
Repeat customers are important for long-term revenue and customer retention.

```sql
WITH Repeated_customer AS (
    SELECT c.customer_unique_id
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
),
total_customer_placed_order AS (
    SELECT COUNT(DISTINCT c.customer_unique_id) AS total_customer
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
SELECT
    (SELECT total_customer
     FROM total_customer_placed_order) AS total_customer_placed_order,
    COUNT(*) AS repeat_customer,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT total_customer FROM total_customer_placed_order),
        2
    ) AS percentage_repeat
FROM Repeated_customer;
```

---

## 4. What is the average number of orders per customer?

**Business Purpose:**  
This metric helps measure customer purchasing frequency and engagement.

```sql
WITH customer_with_their_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_counts
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(customer_unique_id) AS total_customers,
    ROUND(AVG(order_counts), 2) AS avg_order
FROM customer_with_their_orders;
```

---

## 5. Which states contribute the highest revenue?

**Business Purpose:**  
Revenue-heavy regions can help businesses prioritize marketing, supply chain, and delivery resources.

```sql
SELECT
    c.customer_state,
    SUM(oi.price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;
```

---

## 6. Who are the top 10 highest-spending customers?

**Business Purpose:**  
Identifying high-value customers helps understand customer lifetime value and potential retention priorities.

```sql
SELECT
    c.customer_unique_id,
    SUM(op.payment_value) AS total_spend_amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spend_amount DESC
LIMIT 10;
```

---

# B. Order & Logistics Performance

## 1. What is the average time from purchase to delivery?

**Business Purpose:**  
Delivery time is an important indicator of logistics efficiency and customer experience.

```sql
SELECT
    FLOOR(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_delivered_customer_date
            )
        ) / 24
    ) AS days,
    ROUND(
        MOD(
            AVG(
                TIMESTAMPDIFF(
                    HOUR,
                    order_purchase_timestamp,
                    order_delivered_customer_date
                )
            ),
            24
        )
    ) AS hours
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;
```

---

## 2. What is the difference between estimated and actual delivery?

**Business Purpose:**  
Comparing actual and estimated delivery helps measure delivery accuracy.

```sql
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
```

---

## 3. How many orders were delivered late?

**Business Purpose:**  
Late deliveries can negatively affect customer satisfaction and operational performance.

```sql
SELECT
    COUNT(*) AS late_delivered_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;
```

---

## 4. How long do deliveries actually take compared with estimates?

**Business Purpose:**  
This compares actual delivery duration with the estimated delivery timeline and supports SLA analysis.

```sql
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS avg_actual_delivery_days,
    ROUND(
        AVG(
            DATEDIFF(
                order_estimated_delivery_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS avg_estimated_delivery_days
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
```

---

## 5. Which sellers have the best delivery performance?

**Business Purpose:**  
Identifying sellers with shorter shipping times can help improve marketplace logistics performance.

```sql
SELECT
    oi.seller_id,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_approved_at,
                order_delivered_carrier_date
            )
        ),
        2
    ) AS avg_shippind_time
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_approved_at IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND order_approved_at <= order_delivered_carrier_date
GROUP BY oi.seller_id
ORDER BY avg_shippind_time ASC;
```

---

## 6. Which sellers have the worst delivery delays?

**Business Purpose:**  
Identifying sellers with longer shipping durations can help target operational improvements.

```sql
SELECT
    oi.seller_id,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_carrier_date,
                o.order_approved_at
            )
        ),
        2
    ) AS average_shipping_time_days
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_approved_at IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_carrier_date >= o.order_approved_at
GROUP BY oi.seller_id
ORDER BY average_shipping_time_days DESC;
```

---

## 7. Which states experience the slowest deliveries?

**Business Purpose:**  
Delivery performance can vary by geography because of distance and logistics capacity.

```sql
SELECT
    c.customer_state,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS avg_delivery_time
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp <= o.order_delivered_customer_date
GROUP BY c.customer_state
ORDER BY avg_delivery_time DESC;
```

---

## 8. What is the distribution of delivery times by category?

**Business Purpose:**  
Some product categories may require longer preparation, handling, or shipping times.

```sql
SELECT
    p.product_category_name,
    pct.product_category_name_english,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS delivery_time
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
GROUP BY
    p.product_category_name,
    pct.product_category_name_english
ORDER BY delivery_time DESC;
```

---

# C. Product & Category Analytics

## 1. Which product categories sell the most units?

**Business Purpose:**  
Unit sales help identify the most popular product segments.

```sql
WITH category_unit_summary AS (
    SELECT
        p.product_category_name,
        pct.product_category_name_english,
        COUNT(oi.order_item_id) AS total_items,
        DENSE_RANK() OVER (
            ORDER BY COUNT(oi.order_item_id) DESC
        ) AS RNK
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    GROUP BY
        p.product_category_name,
        pct.product_category_name_english
)
SELECT
    product_category_name,
    product_category_name_english,
    total_items
FROM category_unit_summary
WHERE RNK IN (1, 2, 3);
```

---

## 2. Which categories generate the highest revenue?

**Business Purpose:**  
Revenue contribution helps identify the strongest product categories.

```sql
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
GROUP BY
    p.product_category_name,
    ptc.product_category_name_english
ORDER BY total_revenue DESC;
```

---

## 3. What is the average price by category?

**Business Purpose:**  
Average price helps distinguish premium and lower-priced product categories.

```sql
SELECT
    p.product_category_name,
    pct.product_category_name_english,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    p.product_category_name,
    pct.product_category_name_english
ORDER BY avg_price DESC;
```

---

## 4. Which category has the highest freight charges?

**Business Purpose:**  
Freight analysis helps identify categories with higher shipping costs.

```sql
SELECT
    p.product_category_name,
    ptc.product_category_name_english,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation ptc
    ON p.product_category_name = ptc.product_category_name
GROUP BY
    p.product_category_name,
    ptc.product_category_name_english
ORDER BY avg_freight_value DESC;
```

---

## 5. Are heavier items more expensive?

**Business Purpose:**  
This analysis explores whether product weight is associated with selling price.

```sql
SELECT
    CASE
        WHEN p.product_weight_g BETWEEN 0 AND 500 THEN '1. 0-500g'
        WHEN p.product_weight_g BETWEEN 501 AND 1000 THEN '2. 501-1000g'
        WHEN p.product_weight_g BETWEEN 1001 AND 1500 THEN '3. 1001-1500g'
        WHEN p.product_weight_g BETWEEN 1501 AND 2000 THEN '4. 1501-2000g'
        WHEN p.product_weight_g BETWEEN 2001 AND 2500 THEN '5. 2001-2500g'
        ELSE '6. 2500g+'
    END AS weight_category,
    AVG(oi.price) AS avg_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY weight_category
ORDER BY weight_category;
```

---

## 6. Which categories have the highest late-delivery percentage?

**Business Purpose:**  
Late-delivery trends by category can help identify potential supply-chain bottlenecks.

```sql
SELECT
    p.product_category_name,
    pct.product_category_name_english,
    COUNT(DISTINCT o.order_id) AS total_delivery_per_category,
    COUNT(
        DISTINCT (
            CASE
                WHEN o.order_estimated_delivery_date
                     < o.order_delivered_customer_date
                THEN o.order_id
            END
        )
    ) AS late_delivery_count,
    ROUND(
        COUNT(
            DISTINCT (
                CASE
                    WHEN o.order_estimated_delivery_date
                         < o.order_delivered_customer_date
                    THEN o.order_id
                END
            )
        ) * 100.0 /
        COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_percentage
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
GROUP BY
    p.product_category_name,
    pct.product_category_name_english
ORDER BY late_delivery_percentage DESC;
```

---

## 7. What are the top 10 most profitable categories?

**Business Purpose:**  
This identifies categories with the highest amount remaining after freight costs.

> **Important:** The dataset does not contain actual product cost. Therefore, `price - freight_value` is used as a **profitability proxy**, not actual profit.

```sql
SELECT
    p.product_category_name,
    pct.product_category_name_english,
    SUM(oi.price - oi.freight_value) AS revenue_after_freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    p.product_category_name,
    pct.product_category_name_english
ORDER BY revenue_after_freight DESC
LIMIT 10;
```

---

# D. Payment Analysis

## 1. What are the most common payment types?

**Business Purpose:**  
Understanding payment preferences can help optimize the customer payment experience.

```sql
SELECT
    op.payment_type,
    COUNT(DISTINCT op.order_id) AS order_count
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY order_count DESC;
```

---

## 2. Which payment installment ranges are most used?

**Business Purpose:**  
Installment behavior helps understand how customers finance purchases.

```sql
SELECT
    CASE
        WHEN payment_installments = 1 THEN '1-installment'
        WHEN payment_installments BETWEEN 2 AND 4 THEN '2-4 installments'
        WHEN payment_installments BETWEEN 5 AND 7 THEN '5-7 installments'
        WHEN payment_installments BETWEEN 8 AND 10 THEN '8-10 installments'
        WHEN payment_installments BETWEEN 11 AND 13 THEN '11-13 installments'
        WHEN payment_installments BETWEEN 14 AND 16 THEN '14-16 installments'
        ELSE '17+ installments'
    END AS installments_range,
    COUNT(order_id) AS order_count
FROM order_payments
GROUP BY installments_range
ORDER BY installments_range DESC
LIMIT 1;
```

---

## 3. What percentage of orders are paid using multiple installments?

**Business Purpose:**  
This indicates how frequently customers use installment-based payments.

```sql
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(
        DISTINCT (
            CASE
                WHEN payment_installments > 1 THEN order_id
            END
        )
    ) AS total_orders_with_multiple_installments,
    ROUND(
        COUNT(
            DISTINCT (
                CASE
                    WHEN payment_installments > 1 THEN order_id
                END
            )
        ) * 100.0 /
        COUNT(DISTINCT order_id),
        2
    ) AS percentage_multiple_installment
FROM order_payments
WHERE payment_installments IS NOT NULL;
```

---

## 4. How much revenue comes from different payment types?

**Business Purpose:**  
This identifies which payment channels contribute the most transaction value.

```sql
SELECT
    op.payment_type,
    SUM(op.payment_value) AS payment_type_revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY payment_type_revenue DESC;
```

---

## 5. What is the average order value by payment type?

**Business Purpose:**  
Comparing order values by payment method can reveal differences in customer purchasing behavior.

```sql
WITH orders_total AS (
    SELECT
        order_id,
        SUM(price) AS order_vaule
    FROM order_items
    GROUP BY order_id
)
SELECT
    op.payment_type,
    ROUND(AVG(order_vaule), 2) AS average_order_vaule_par_payments
FROM order_payments op
JOIN orders_total ot
    ON op.order_id = ot.order_id
GROUP BY op.payment_type
ORDER BY average_order_vaule_par_payments DESC;
```

---

# E. Review & Customer Satisfaction

## 1. What is the average review score?

**Business Purpose:**  
Average review score provides a baseline measure of customer satisfaction.

```sql
SELECT
    ROUND(AVG(ors.review_score), 2) AS average_review_score
FROM order_reviews ors
JOIN orders o
    ON o.order_id = ors.order_id
WHERE o.order_status = 'delivered'
  AND ors.review_score IS NOT NULL;
```

---

## 2. Do late deliveries lead to lower review scores?

**Business Purpose:**  
This compares customer satisfaction between on-time and late deliveries.

```sql
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'on-time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'late'
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
```

---

## 3. What is the distribution of review scores?

**Business Purpose:**  
Review-score distribution helps understand whether customer feedback is mostly positive, negative, or mixed.

```sql
SELECT
    review_score,
    COUNT(*) AS review_counts
FROM order_reviews
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;
```

---

## 4. Which categories receive the lowest ratings?

**Business Purpose:**  
Low-rated categories may require investigation into product quality, customer expectations, or listing accuracy.

```sql
SELECT
    p.product_category_name,
    pct.product_category_name_english,
    ROUND(AVG(ors.review_score), 2) AS avg_rating_per_category
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
GROUP BY
    p.product_category_name,
    pct.product_category_name_english
ORDER BY avg_rating_per_category ASC;
```

---

## 5. Which sellers receive the best and worst ratings?

**Business Purpose:**  
Seller ratings can influence customer trust and marketplace reputation.

```sql
SELECT
    s.seller_id,
    COUNT(ors.review_id) AS total_reviews,
    ROUND(AVG(ors.review_score), 2) AS avg_review_score
FROM orders o
JOIN order_reviews ors
    ON o.order_id = ors.order_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
  AND ors.review_score IS NOT NULL
GROUP BY s.seller_id
ORDER BY avg_review_score ASC;
```

---

## 6. How long do customers take to respond with reviews?

**Business Purpose:**  
Review response time indicates how quickly customers engage after the review process begins.

```sql
SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                review_creation_date,
                review_answer_timestamp
            )
        ),
        2
    ) AS avg_reviews_response_time_hour
FROM order_reviews
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_creation_date < review_answer_timestamp;
```

---

# 📌 Business Analysis Summary

The queries in this document cover five major business areas:

| Section | Focus | Questions |
|---|---|---:|
| A | Customer & Geography | 6 |
| B | Order & Logistics Performance | 8 |
| C | Product & Category Analytics | 7 |
| D | Payment Analysis | 5 |
| E | Review & Customer Satisfaction | 6 |
| **Total** | **Business Analysis** | **32** |

The analysis moves from customer and geographic behavior to operational performance, product economics, payment behavior, and customer satisfaction.

---

# ⚠️ Important Analytical Notes

### 1. Customer Identity

For repeat-customer analysis, `customer_unique_id` is used because the same customer can be associated with multiple `customer_id` records.

### 2. Order Items

`order_items` connects orders with products and sellers. Because one order can contain multiple items, order-level metrics should use `COUNT(DISTINCT order_id)` where appropriate.

### 3. Payments

An order can contain multiple payment records. Payment-level and order-level metrics should therefore be aggregated carefully to avoid double counting.

### 4. Profitability

The dataset does not contain actual product cost.

Therefore:

```text
Profitability Proxy = Price - Freight Value
```

is used only as an analytical proxy.

### 5. Findings

The numerical findings should be added to the project README after executing the queries. The README should report the actual SQL results rather than estimated values.

---
