# 🛒 Olist Brazilian E-Commerce — SQL & Power BI Data Analysis Project

## 📌 Project Overview

This project analyzes the **Olist Brazilian E-Commerce dataset** using **MySQL** and **Microsoft Power BI**.

The project is designed to simulate a real-world **Data Analyst workflow**: starting with database and table creation, loading raw CSV files, validating data quality, performing exploratory analysis, answering business questions using SQL, and finally building an **interactive Power BI dashboard** to visualize and communicate the insights.

**Raw Data → MySQL Database → Data Validation → SQL Analysis → Power BI Data Modeling → DAX Measures → Interactive Dashboards → Business Insights**

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

The purpose of this project is to use SQL — and then Power BI — to analyze the Olist marketplace and answer questions such as:

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

The overall goal is to identify **actionable business insights using SQL and Power BI** that could help an e-commerce marketplace improve customer retention, sales performance, logistics, seller performance, and customer satisfaction.

---

# 🧭 Project Approach

The project follows a structured Data Analyst workflow, from raw data to a final interactive dashboard.

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
Business Analysis (SQL)
      ↓
Power BI Data Modeling & DAX
      ↓
Interactive Dashboard
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
├── 01_Database_Setup/
│   └── 1.Table_Creation.sql
│
├── 02_Data_Loading/
│   └── 2.Data_load.sql
│
├── 03_Data_Validation/
│   ├── 3.Data_Validation.sql
│   └── 4.Data_Validatiion2.sql
│
├── 04_Exploratory_Analysis/
│   └── 5.ExploratoryDataAnalysis.sql
│
├── 05_Business_Analysis/
│   └── 6.Business_Analysis.sql
│
└── 06_PowerBI_Dashboard/
    └── Olist_PowerBI_Dashboard
```

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
Create the MySQL database and relational tables required for the Olist dataset — `customers`, `orders`, `order_items`, `order_payments`, `order_reviews`, `products`, `sellers`, `geolocation`, and `product_category_name_translation`.

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
Load the raw Olist CSV files into the corresponding MySQL tables using `LOAD DATA LOCAL INFILE`.

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

Replace the placeholder path:

```sql
LOAD DATA LOCAL INFILE 'path_of_customers.csv'
```

with your actual local file location, for example:

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
Check whether the imported data is complete, valid, and suitable for analysis — including NULL values, duplicates, invalid state/ZIP codes, orphaned records, and timestamp issues across customers and orders.

---

# 4️⃣ Advanced Data Validation

### File
`4.Data_Validatiion2.sql`

### Objective
Perform deeper validation and logical consistency checks across the complete dataset — customers, orders, order items, products, sellers, payments, reviews, geolocation, and category translation — including invalid dimensions, weights, prices, freight values, installments, review scores, and referential integrity.

---

# 5️⃣ Exploratory Data Analysis

### File
`5.ExploratoryDataAnalysis.sql`

### Objective
Understand the overall structure, volume, and behavior of the Olist marketplace before answering detailed business questions — covering customer counts and acquisition, order volume and status, product category distribution, seller distribution, and payment behavior.

---

# 6️⃣ Business Analysis (SQL)

### File
`6.Business_Analysis.sql`

### Objective
Answer real-world business questions and convert SQL results into business insights, organized into five areas:

- **👥 Customer & Geography Analysis** — customer concentration, repeat purchase rate, top-spending customers, revenue by state
- **🚚 Order & Logistics Analysis** — delivery time, late deliveries, seller delivery performance, regional delays
- **📦 Product & Category Analysis** — units sold, revenue by category, pricing, freight cost patterns
- **💳 Payment Analysis** — payment type preference, installment behavior, transaction value
- **⭐ Review & Customer Satisfaction Analysis** — average review scores, seller/category ratings, impact of late delivery on satisfaction

---

# 📊 Power BI Dashboard

The SQL analysis was extended into an interactive **Power BI dashboard** containing **three pages**:

1. **Summary**
2. **Customers**
3. **Orders**

The dashboard uses KPI cards, bar charts, line charts, donut charts, and combined column/line visuals to communicate business performance, built on a data model developed in Power Query with DAX measures for core KPIs.

## 1. 📈 Summary Dashboard

Provides an overall view of Olist e-commerce performance.

### Key KPIs

- **Total Revenue:** 13.59M
- **Total Orders:** 99K
- **Total Customers:** 96K
- **Average Review Score:** 4.09
- **On-Time Delivery:** 92.13%
- **Average Order Value:** 137.75
- **Average Delivery Days:** 12.50

### Visual Analysis

**Top 5 Sold Product Categories**

1. bed_bath_table – 11.1K
2. health_beauty – 9.7K
3. sports_leisure – 8.6K
4. furniture_decor – 8.3K
5. computers_accessories – 7.8K

**Monthly Revenue Trend** — highest monthly revenue is approximately 1.50M in May; lowest is approximately 0.62M in September.

**Payment Type Preference**

- Credit Card – 76.8K (73.92%)
- Boleto – 19.78K (19.04%)
- Voucher – 5.78K (5.56%)

**Delivery Performance** — approximately 92.13% of orders delivered on time; 7.87% delivered late.

## 2. 👥 Customers Dashboard

Focuses on customer acquisition, retention, geography, and payment behavior.

### Key KPIs

- **Total Customers:** 96K
- **Total Revenue:** 13.59M
- **Repeat Customers:** 3K
- **Retention Rate:** 3.12%

### Visual Analysis

**New Customer Acquisition Over Time** — stronger acquisition in March (9.75K), May (10.43K), July (10.17K), and August (10.70K).

**New vs Returning Customers**

- New Customers: 3K (3.12%)
- Repeat Customers: 93K (96.88%)

> Note: These labels and values are presented as shown in the dashboard.

**Top 10 Cities Contributing Customers**

1. São Paulo – 14.98K
2. Rio de Janeiro – 6.62K
3. Belo Horizonte – 2.67K
4. Brasília – 2.07K
5. Curitiba – 1.47K
6. Campinas – 1.40K
7. Porto Alegre – 1.33K
8. Salvador – 1.21K
9. Guarulhos – 1.15K
10. São Bernardo do Campo – 0.91K

## 3. 📦 Orders Dashboard

Focuses on order volume, delivery performance, delivery speed, and payment installments.

### Key KPIs

- **Total Units Sold:** 113K
- **Average Product Price:** 120.65
- **Average Shipping Cost:** 19.99
- **Average Delivery Days:** 12.50
- **On-Time Delivery:** 92.13%
- **Average Order Value:** 137.75

### Visual Analysis

**Order Volume vs On-Time Delivery by Day of Week**

| Day | Orders | On-Time Delivery |
|---|---:|---:|
| Monday | 16.20K | 91.22% |
| Tuesday | 15.96K | 91.76% |
| Wednesday | 15.55K | 92.44% |
| Thursday | 14.76K | 92.66% |
| Friday | 14.12K | 91.81% |
| Saturday | 10.89K | 92.63% |
| Sunday | 11.96K | 92.72% |

**Delivery Speed Distribution** — orders categorized into Very Slow, Slow, Normal, and Fast.

**Distribution of Orders by Number of Installments** — the largest group is 1 installment, with approximately 52.55K orders, followed by 2 and 3 installments.

---

# 🔍 Key Business Insights

- Olist generated approximately **13.59M in total revenue** across **99K orders** and **96K customers**.
- **Credit card** is the most preferred payment method.
- **bed_bath_table** is the highest-selling product category among the top five.
- **São Paulo** contributes the largest number of customers among the displayed cities.
- Overall **on-time delivery performance is 92.13%**, with an average delivery time of **12.50 days**.
- Average order value is **137.75**.
- Customers commonly use **1 installment** for their purchases.
- The dashboard highlights noticeable monthly variation in both revenue and customer acquisition.

---

# ⚠️ Important Analytical Limitation

The Olist dataset does **not** contain the actual product acquisition/manufacturing cost. Therefore, actual business profit cannot be calculated from this dataset.

For category-level analysis, the project uses:

```text
Profitability Proxy = Product Price - Freight Value
```

This should **not** be interpreted as actual company profit — it is only a proxy for the amount remaining after freight cost.

---

# 🧠 SQL Concepts Demonstrated

```text
SELECT, WHERE, DISTINCT, GROUP BY, HAVING, ORDER BY, LIMIT
INNER JOIN, LEFT JOIN
CASE, Aggregate Functions, Subqueries, CTEs
COUNT(), SUM(), AVG(), MIN(), MAX(), ROUND()
DATE(), YEAR(), DATE_FORMAT(), DATEDIFF(), TIMESTAMPDIFF()
REGEXP
Data Validation, Data Quality Checks, Business KPI Analysis
```

---

# 📈 Power BI & DAX Concepts Demonstrated

```text
Power Query — data transformation and preparation
Data Modeling — relationships between fact and dimension tables
DAX Measures — Total Revenue, Total Orders, Total Customers,
               Average Order Value, On-Time Delivery %,
               Repeat Customers, Retention Rate
KPI Cards, Bar Charts, Line Charts, Donut Charts,
Combined Column/Line Visuals
```

---

# 🛠️ Tools & Technologies

| Tool / Technology | Purpose |
|---|---|
| MySQL 8 | Database and SQL analysis |
| MySQL Workbench | SQL development and database management |
| SQL | Data loading, validation, EDA, and business analysis |
| Power BI | Interactive dashboard development |
| Power Query | Data transformation and preparation |
| DAX | Measures and business KPIs |
| CSV | Raw dataset format |
| Git | Version control |
| GitHub | Project portfolio and code sharing |

---

# ▶️ How to Run the Project

## Step 1 — Create the Database

```sql
CREATE DATABASE olist;
USE olist;
```

Also included in `1.Table_Creation.sql`.

## Step 2 — Create the Tables
Run `1.Table_Creation.sql`.

## Step 3 — Load the Data
Open `2.Data_load.sql`, replace the placeholder CSV paths with your local file paths, then execute the script.

## Step 4 — Validate the Data
Run `3.Data_Validation.sql`, then `4.Data_Validatiion2.sql`.

## Step 5 — Perform Exploratory Analysis
Run `5.ExploratoryDataAnalysis.sql`.

## Step 6 — Perform Business Analysis
Run `6.Business_Analysis.sql`.

## Step 7 — Open the Power BI Dashboard
Open `Olist_PowerBI_Dashboard.pbix` in Power BI Desktop, connect to your MySQL instance (or the refreshed dataset), and refresh the data model to explore the Summary, Customers, and Orders pages.

---

# 📌 Important Dataset Notes

### `customer_id` vs `customer_unique_id`
`customer_id` identifies a customer record associated with an order. `customer_unique_id` represents the actual customer identity and is used for repeat-customer analysis in both SQL and Power BI.

### `order_items`
Connects Orders → Products → Sellers. An order can contain multiple products/items and potentially multiple sellers, so care must be taken to avoid double-counting orders when calculating order-level metrics.

### Multiple Payments
An order can have multiple payment records, so payment-level calculations use appropriate aggregation to avoid duplicating order-level metrics.

### Order Status
The source dataset contains several order statuses: `created`, `approved`, `invoiced`, `processing`, `shipped`, `delivered`, `canceled`, `unavailable`. These are treated as source-data values during validation and analysis.

---

# 📈 Future Improvements

- RFM customer segmentation
- Cohort analysis
- Additional dashboard drill-through pages (Sellers, Reviews, Product Category deep-dive)
- SQL views for reusable KPIs
- Star-schema data modeling
- Automated data-quality checks
- Executive-level business dashboard
- Advanced seller-performance scoring

---

# 🎓 Learning Outcomes

Through this project, I practiced how to:

- Design a relational database
- Load CSV data into MySQL
- Validate real-world datasets and identify data-quality issues
- Write complex SQL joins, CTEs, and subqueries
- Perform KPI, retention, revenue, delivery, payment, and review analysis
- Build a Power BI data model and write DAX measures
- Design an interactive multi-page dashboard
- Convert SQL and Power BI results into business insights

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
              │  Power BI Dashboard │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │ Business Insights   │
              └─────────────────────┘
```

**From raw data to business decisions using SQL and Power BI.**

---

## 👨‍💻 Author

**Sumit Kalambate**

GitHub: **Sumitkalambate**
