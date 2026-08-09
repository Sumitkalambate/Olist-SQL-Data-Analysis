# 🛒 Olist Brazilian E-Commerce — SQL Data Analysis Project

## 📌 Project Overview

This project analyzes the **Olist Brazilian E-Commerce dataset** using **MySQL**.

The project is designed to simulate a real-world **Data Analyst workflow**: starting with database and table creation, loading raw CSV files, validating data quality, performing exploratory analysis, and finally answering business questions using SQL.

The main objective is to transform raw e-commerce data into meaningful business insights related to:

- Customer behavior
- Sales and revenue
- Product performance
- Seller performance
- Delivery and logistics
- Payment behavior
- Customer satisfaction
- Customer retention

---

# 🎯 Problem Statement

Olist is a Brazilian e-commerce marketplace that connects customers with sellers across Brazil.

The business has data covering customers, orders, products, sellers, payments, reviews, and geographic information. However, raw transactional data alone does not directly answer important business questions.

The purpose of this project is to use SQL to analyze the Olist marketplace and answer questions such as:

- Which states and cities have the highest customer and order activity?
- What percentage of customers make repeat purchases?
- Which states generate the highest revenue?
- Who are the highest-spending customers?
- Which product categories generate the most sales and revenue?
- Which sellers perform best and worst?
- How long do customers wait for their orders?
- How frequently are orders delivered late?
- Which payment methods and installment options are most common?
- How does delivery performance relate to customer review scores?
- Which product categories have higher freight costs or delivery issues?

The overall goal is to identify **actionable business insights using SQL** that could help an e-commerce marketplace improve customer retention, sales performance, logistics, seller performance, and customer satisfaction.

---

# 🧭 Project Approach

The project follows a structured Data Analyst workflow.

```text
Raw CSV Data
      ↓
Database & Table Creation
      ↓
Data Loading
      ↓
Data Validation
      ↓
Exploratory Data Analysis
      ↓
Business Analysis
      ↓
Business Insights
```

---

# 📂 Project Structure

```text
Olist-SQL-Data-Analysis/
│
├── README.md
│
├── 1.Table_Creation.sql
├── 2.Data_load.sql
├── 3.Data_Validation.sql
├── 4.Data_Validatiion2.sql
├── 5.ExploratoryDataAnalysis.sql
└── 6.Business_Analysis.sql
```

Each SQL file represents a separate stage of the project.

---

# 🗃️ Dataset

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** Kaggle

The dataset contains information about orders placed on the Olist marketplace and includes multiple related datasets.

## Main Tables

| Table | Description |
|---|---|
| `customers` | Customer information and location |
| `orders` | Order status and order lifecycle timestamps |
| `order_items` | Products and sellers associated with orders |
| `order_payments` | Payment method, installments, and payment amount |
| `order_reviews` | Customer review scores and review information |
| `products` | Product categories, dimensions, weight, and other attributes |
| `sellers` | Seller information and location |
| `geolocation` | Brazilian ZIP-code geographic information |
| `product_category_name_translation` | Portuguese-to-English product category translation |

---

# 1️⃣ Table Creation

### File

`1.Table_Creation.sql`

### Objective

Create the MySQL database and relational tables required for the Olist dataset.

The database contains nine main tables:

```text
customers
orders
order_items
order_payments
order_reviews
products
sellers
geolocation
product_category_name_translation
```

### Key Database Relationships

```text
customers
    │
    └── orders
          │
          ├── order_items ── products
          │        │
          │        └── sellers
          │
          ├── order_payments
          │
          └── order_reviews
```

`order_items` acts as an important bridge between orders, products, and sellers.

---

# 2️⃣ Data Loading

### File

`2.Data_load.sql`

### Objective

Load the raw Olist CSV files into the corresponding MySQL tables.

The script uses:

```sql
LOAD DATA LOCAL INFILE
```

Each CSV file is loaded separately.

### CSV files loaded

```text
olist_customers_dataset.csv
olist_orders_dataset.csv
olist_order_items_dataset.csv
olist_order_payments_dataset.csv
olist_order_reviews_dataset.csv
olist_products_dataset.csv
olist_sellers_dataset.csv
product_category_name_translation.csv
olist_geolocation_dataset.csv
```

### Before Running

Replace:

```text
path_of_customers.csv
```

with the actual location of the CSV file on your system.

For example:

```sql
LOAD DATA LOCAL INFILE 'path_of_customers.csv'
```

can be changed to:

```sql
LOAD DATA LOCAL INFILE 'D:/your_folder/olist_customers_dataset.csv'
```

The same process should be followed for the other CSV files.

> **Note:** The actual local file paths are intentionally not included in GitHub.

---

# 3️⃣ Data Validation

### File

`3.Data_Validation.sql`

### Objective

Check whether the imported data is complete, valid, and suitable for analysis.

The validation includes checks for:

### Customers

- NULL values
- Empty values
- Duplicate `customer_id`
- Repeated `customer_unique_id`
- Invalid state codes
- Invalid ZIP-code values
- Customers without orders
- Orders referencing missing customers

### Orders

- Missing order status
- Missing timestamps
- Duplicate order IDs
- Invalid order statuses
- Referential consistency
- Timestamp-related issues

The purpose of this stage is to identify data-quality issues **before performing business analysis**.

---

# 4️⃣ Advanced Data Validation

### File

`4.Data_Validatiion2.sql`

### Objective

Perform deeper validation and logical consistency checks across the complete dataset.

The checks cover:

- Customers
- Orders
- Order items
- Products
- Sellers
- Payments
- Reviews
- Geolocation
- Product-category translation

Examples of validation performed include:

- NULL-value checks
- Duplicate checks
- Valid state-code checks
- Invalid ZIP-code checks
- Invalid product dimensions
- Invalid product weights
- Invalid prices
- Invalid freight values
- Payment validation
- Installment validation
- Review-score validation
- Date and timestamp consistency
- Referential integrity checks
- Geographic data validation
- Category translation validation

This stage provides a deeper level of data-quality assurance before analysis.

---

# 5️⃣ Exploratory Data Analysis

### File

`5.ExploratoryDataAnalysis.sql`

### Objective

Understand the overall structure, volume, and behavior of the Olist marketplace before answering detailed business questions.

## Customer Analysis

The analysis includes:

- Total customers
- Customers by state
- Customers by city
- Top 10 customer cities
- Monthly customer acquisition

## Order Analysis

The analysis includes:

- Total orders
- Monthly order volume
- Yearly order volume
- Average daily orders
- Cancelled orders
- Successfully delivered orders
- Order-status distribution

## Product Analysis

The analysis includes:

- Number of product categories
- Products per category
- Largest product categories
- Smallest product categories

## Seller Analysis

The analysis includes:

- Total sellers
- Sellers by state
- Seller distribution

## Payment Analysis

The analysis includes:

- Total payment value
- Average payment value
- Highest payment value
- Lowest payment value
- Installment distribution
- Payment behavior

This stage establishes the baseline KPIs and helps identify areas requiring deeper business analysis.

---

# 6️⃣ Business Analysis

### File

`6.Business_Analysis.sql`

### Objective

Answer real-world business questions and convert SQL results into business insights.

The business analysis is divided into the following areas.

---

## A. 👥 Customer & Geography Analysis

Questions analyzed include:

- Which states have the highest number of customers?
- Which cities generate the most orders?
- What percentage of customers return for repeat purchases?
- What is the average number of orders per customer?
- Which states contribute the highest revenue?
- Who are the top-spending customers?

### Business Value

This analysis helps understand:

- Customer concentration
- Regional demand
- Customer loyalty
- Customer purchasing behavior
- High-value customers
- High-revenue regions

---

## B. 🚚 Order & Logistics Analysis

Questions analyzed include:

- What is the average time from purchase to delivery?
- What is the difference between estimated and actual delivery?
- How many orders were delivered late?
- Which sellers have better delivery performance?
- Which regions experience longer delivery times?
- Which categories have higher late-delivery rates?

### Business Value

This helps identify:

- Delivery bottlenecks
- Logistics problems
- Seller performance differences
- Regions requiring operational attention
- Potential customer-experience issues

---

## C. 📦 Product & Category Analysis

Questions analyzed include:

- Which categories sell the most units?
- Which categories generate the highest revenue?
- What is the average price by category?
- Which categories have higher freight charges?
- Is there a relationship between product weight and price?
- Which categories have higher late-delivery percentages?

### Business Value

This helps understand:

- Product demand
- Revenue-driving categories
- Pricing patterns
- Shipping-cost patterns
- Product-category performance

---

## D. 💳 Payment Analysis

Questions analyzed include:

- Which payment types are most commonly used?
- How are installment payments distributed?
- How many orders use multiple installments?
- Which payment methods generate the highest transaction value?
- What is the average payment value?

### Business Value

This helps understand:

- Customer payment preferences
- Installment behavior
- Payment transaction patterns
- Potential opportunities for payment optimization

---

## E. ⭐ Review & Customer Satisfaction Analysis

Questions analyzed include:

- What is the average review score?
- Which sellers receive the best and worst ratings?
- Which categories receive lower ratings?
- Do late deliveries affect customer review scores?
- How long do customers take to submit reviews?

### Business Value

This helps understand:

- Customer satisfaction
- Seller quality
- Product-category satisfaction
- Potential relationship between logistics and customer experience

---

# 📊 Findings & Business Insights

The SQL analysis is designed to produce findings that can be directly connected to business decisions.

## Customer Insights

The analysis identifies the regions with the largest customer base and measures repeat purchasing behavior.

A key retention metric is:

```text
Repeat Customer Rate =
Customers with more than one order
------------------------------------ × 100
Customers who placed at least one order
```

This helps determine which regions have stronger customer loyalty.

---

## Revenue Insights

Revenue is analyzed by state, customer, product category, and other business dimensions.

The analysis identifies:

- High-revenue states
- Highest-spending customers
- Revenue-generating product categories
- Sales concentration across regions

These results can help prioritize regional marketing and customer-retention strategies.

---

## Delivery Insights

Delivery performance is measured by comparing:

```text
Actual Delivery Date
        vs.
Estimated Delivery Date
```

Late deliveries are identified using the difference between actual and estimated delivery dates.

This helps determine whether logistics performance may be contributing to customer dissatisfaction.

---

## Product Insights

Product categories are compared using:

- Units sold
- Revenue
- Average price
- Freight value
- Late-delivery rate

This helps identify both high-performing categories and categories that may require operational attention.

---

## Seller Insights

Seller performance is evaluated using:

- Number of orders
- Revenue
- Delivery performance
- Average review score

This allows sellers to be compared from both operational and customer-satisfaction perspectives.

---

## Payment Insights

Payment analysis identifies the most commonly used payment methods and installment patterns.

This can help understand customer payment preferences and purchasing behavior.

---

## Customer Satisfaction Insights

Review scores are analyzed against delivery performance and seller/category characteristics.

One important business question is whether:

```text
Late Delivery
      ↓
Lower Customer Satisfaction
      ↓
Lower Review Score
```

The SQL analysis investigates this relationship using actual order and review data.

---

# ⚠️ Important Analytical Limitation

The Olist dataset does **not** contain the actual product acquisition/manufacturing cost.

Therefore, actual business profit cannot be calculated from this dataset.

For category-level analysis, the project uses:

```text
Profitability Proxy = Product Price - Freight Value
```

This should **not** be interpreted as actual company profit.

It is only a proxy for analyzing the amount remaining after freight cost.

---

# 🧠 SQL Concepts Demonstrated

This project demonstrates practical use of:

```text
SELECT
WHERE
DISTINCT
GROUP BY
HAVING
ORDER BY
LIMIT

INNER JOIN
LEFT JOIN

CASE
Aggregate Functions
Subqueries
CTEs

COUNT()
SUM()
AVG()
MIN()
MAX()
ROUND()

DATE()
YEAR()
DATE_FORMAT()
DATEDIFF()
TIMESTAMPDIFF()

REGEXP

Data Validation
Data Quality Checks
Business KPI Analysis
```

---

# 🛠️ Tools & Technologies

| Tool / Technology | Purpose |
|---|---|
| MySQL 8 | Database and SQL analysis |
| MySQL Workbench | SQL development and database management |
| SQL | Data loading, validation, EDA, and business analysis |
| CSV | Raw dataset format |
| Git | Version control |
| GitHub | Project portfolio and code sharing |

---

# ▶️ How to Run the Project

## Step 1 — Create the Database

Run:

```sql
CREATE DATABASE olist;
USE olist;
```

This is also included in:

```text
1.Table_Creation.sql
```

## Step 2 — Create the Tables

Run:

```text
1.Table_Creation.sql
```

## Step 3 — Load the Data

Open:

```text
2.Data_load.sql
```

Replace the placeholder CSV paths with your local file paths.

Then execute the script.

## Step 4 — Validate the Data

Run:

```text
3.Data_Validation.sql
```

Then run:

```text
4.Data_Validatiion2.sql
```

## Step 5 — Perform Exploratory Analysis

Run:

```text
5.ExploratoryDataAnalysis.sql
```

## Step 6 — Perform Business Analysis

Finally, run:

```text
6.Business_Analysis.sql
```

---

# 📌 Important Dataset Notes

### `customer_id` vs `customer_unique_id`

`customer_id` identifies a customer record associated with an order.

`customer_unique_id` represents the actual customer identity and is therefore more appropriate when analyzing repeat customers across orders.

For customer-retention analysis, this project uses:

```sql
customer_unique_id
```

---

### `order_items`

`order_items` connects:

```text
Orders → Products → Sellers
```

An order can contain multiple products/items and potentially multiple sellers.

Therefore, care must be taken to avoid double-counting orders when calculating order-level metrics.

---

### Multiple Payments

An order can have multiple payment records.

Therefore, payment-level calculations should use appropriate aggregation to avoid incorrectly duplicating order-level metrics.

---

### Order Status

The source dataset contains several order statuses, including:

```text
created
approved
invoiced
processing
shipped
delivered
canceled
unavailable
```

The values are treated as source-data values during validation and analysis.

---

# 📈 Future Improvements

The project can be extended by adding:

- RFM customer segmentation
- Cohort analysis
- Customer retention dashboard
- SQL views for reusable KPIs
- Star-schema data modeling
- Power BI dashboard
- Automated data-quality checks
- Executive-level business dashboard
- Advanced seller-performance scoring

---

# 🎓 Learning Outcomes

Through this project, I practiced how to:

- Design a relational database
- Load CSV data into MySQL
- Validate real-world datasets
- Identify data-quality issues
- Work with multiple related tables
- Write complex SQL joins
- Use CTEs and subqueries
- Perform KPI analysis
- Analyze customer retention
- Analyze revenue and sales
- Evaluate delivery performance
- Analyze payment behavior
- Analyze customer reviews
- Convert SQL results into business insights

---



# ⭐ Project Workflow Summary

```text
                OLIST E-COMMERCE DATA
                         │
                         ▼
              ┌─────────────────────┐
              │  Table Creation     │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │    Data Loading     │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │  Data Validation    │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │ Exploratory Analysis│
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │ Business Analysis   │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │ Business Insights   │
              └─────────────────────┘
```

**From raw data to business decisions using SQL.**
