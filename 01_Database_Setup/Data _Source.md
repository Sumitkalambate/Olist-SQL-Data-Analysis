## 📊 Dataset

This project uses publicly available datasets from **Kaggle**:

### Olist Brazilian E-Commerce Dataset

**Source:** [Olist E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains approximately 100K orders from the Brazilian Olist marketplace and includes information related to:

* Orders
* Customers
* Sellers
* Products
* Payments
* Reviews
* Geolocation
* Product categories

The datasets originate from different operational systems and are treated as **separate data sources during the ingestion process**. Each source is loaded into its corresponding MySQL table and later combined through relational keys for data validation, exploratory analysis, and business analysis.

### 📁 Data Sources

| Dataset                                 | Description                                                   |
| --------------------------------------- | ------------------------------------------------------------- |
| `olist_customers_dataset.csv`           | Customer information and location                             |
| `olist_orders_dataset.csv`              | Order status and order lifecycle dates                        |
| `olist_order_items_dataset.csv`         | Products, sellers, prices, and freight associated with orders |
| `olist_order_payments_dataset.csv`      | Payment methods, installments, and payment values             |
| `olist_order_reviews_dataset.csv`       | Customer reviews and review scores                            |
| `olist_products_dataset.csv`            | Product attributes and dimensions                             |
| `olist_sellers_dataset.csv`             | Seller information and location                               |
| `olist_geolocation_dataset.csv`         | Brazilian ZIP-code geographic information                     |
| `product_category_name_translation.csv` | Product category translations                                 |

### 🔗 Source

The original dataset is publicly available on Kaggle:

[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

> **Note:** The raw CSV files are not included in this GitHub repository. They can be downloaded directly from the Kaggle source above.
