# Methodology

**Title:**  *March 2025 Business Performance Insights for Curlture* 

**Prepared by:** Data Analyst — Tiffany Nwanne

**Date:** May 2025

---

## **1. Objective**

The purpose of this analysis is to assess Curlture’s business performance for March 2025 by evaluating key metrics such as revenue, product sales, returns, customer behavior, and payment preferences. This methodology outlines how the raw transactional data was cleaned, explored, and analyzed using **MySQL**, applying standard data practices for business intelligence in direct-to-consumer (DTC) ecommerce.

---

## **2. Data Source**

The analysis used a CSV file titled **`CurltureA_March2025_WithBenchmarks.csv`** consisting of 50 rows of transaction-level data, including:

- OrderID
- OrderDate
- Product
- Texture
- PaymentMethod
- OrderValue
- Returned (Boolean)
- ReturnReason
- CustomerType
- Location
- Benchmark columns for revenue and returns

This data was loaded into a MySQL table named `orders_march2025`.

---

## **3. Data Preparation**

### **3.1 Schema Creation**

A table schema was created to match the structure of the data:

```sql
CREATE TABLE orders_march2025 (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Product VARCHAR(50),
    Texture VARCHAR(10),
    PaymentMethod VARCHAR(20),
    OrderValue DECIMAL(10,2),
    Returned BOOLEAN,
    ReturnReason VARCHAR(100),
    CustomerType VARCHAR(20),
    Location VARCHAR(50)
);
```

### **3.2 Data Import**

The data was imported using `LOAD DATA INFILE` for efficient population of the MySQL table.

### **3.3 Data Cleaning**

- Verified and corrected inconsistent `PaymentMethod` or `Product` values.
- Ensured dates were stored in `DATE` format.
- Checked for missing or null fields in key columns.

---

## **4. Data Exploration & Analysis**

The analysis followed structured SQL queries and aggregations using the following thematic dimensions:

### **4.1 Revenue Metrics**

- **Total Revenue**: `SUM(OrderValue)`
- **Net Revenue** (excluding returns)
- **Average Order Value**: `SUM(OrderValue) / COUNT(DISTINCT OrderID)`

### **4.2 Product Performance**

- Revenue by `Product` and `Texture`
- Identification of best- and worst-performing items

### **4.3 Payment Method Insights**

- Number of orders and AOV for each `PaymentMethod`
- Usage percentage for Klarna and Afterpay

### **4.4 Returns Analysis**

- Total return count and return rate
- Return rate by product type
- Top return reasons from `ReturnReason` field

### **4.5 Customer Behavior**

- Split between `New` and `Returning` customers
- Geographic distribution of orders (`Location`)
- Revenue and order counts by customer type

---

## **5. Benchmarks & KPIs**

Industry-standard benchmarks were applied as constants and comparison fields:

| Metric | Benchmark |
| --- | --- |
| Revenue Target | $50,000/month |
| Return Rate | ≤ 5% |

Benchmark fields were integrated into SQL queries using constants or `CASE` statements to compare actuals vs. targets.

---

## **6. Data Outputs**

### **Views and Aggregates**

- Reusable **SQL views** were created for:
    - Daily revenue
    - Product-level sales
    - Return summaries

### **Data Export**

- Aggregated tables were exported as CSV for visualization in Tableau.

---

## **7. Visualization in Tableau**

The enriched dataset was visualized using Tableau. Key dashboards included:

- **Revenue Trend** (with reference line for target)
- **Sales by Product** (vs. benchmark)
- **Return Rate** (vs. 5% target)
- **BNPL Usage**
- **KPI Tiles**: Total Revenue, AOV, Return Rate

---

## **8. Tools Used**

- **MySQL** (v8+): Data cleaning, exploration, analysis
- **Tableau Public**: Visualization and dashboard design
- **Excel/CSV**: Data pre-formatting

---

## **9. Limitations**

- Sample size is small (simulated dataset); results are indicative, not predictive.
- No time-series historic data available to track trends across multiple months.

---

## **10. Conclusion**

This methodology ensures transparent, repeatable analysis of Curlture's monthly performance using SQL-driven insights. It is designed to scale with increased transaction volume, integrate historical tracking, and support ongoing decision-making in product strategy, marketing, and customer experience.

---