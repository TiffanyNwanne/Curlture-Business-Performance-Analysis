# Methodology Report

**Prepared by:** Data Analyst – Tiffany Nwanne

**Date:** May 2025

---

## **1. Objective**

This report aims to provide a clear and structured explanation of the methodology used to analyze Curlture’s sales, return patterns, customer behavior, and payment preferences for March 2025. The analysis was conducted using **MySQL** with a focus on data cleaning, standardization, and exploratory business intelligence queries.

---

## **2. Data Structure and Exploration**
[!]Preview Image](https://github.com/TiffanyNwanne/Curlture-Business-Performance-Analysis/blob/main/Data%2520Structure.png))](https://github.com/TiffanyNwanne/Curlture-Business-Performance-Analysis/blob/main/Data%2520Structure.png)
### **2.1 Data Source**

The raw transactional data was stored in a MySQL table named `orders_march2025`.

The data structure consists of 50 rows of transaction-level data, including:

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

### **2.2 Initial Table Inspection**

```sql
SELECT * FROM orders_march2025;
```

This allowed a quick check on column structure, field consistency, and row integrity.

---

## **3. Data Cleaning**

### **3.1 Standardizing Data Types**

To ensure consistency and proper indexing, the data types for each column were explicitly converted to their appropriate types using the `ALTER TABLE` command.

```sql
ALTER TABLE orders_march2025
   CHANGE OrderID OrderID INT,
   CHANGE `Date` OrderDate DATE,
   CHANGE Product Product VARCHAR(50),
   CHANGE Texture Texture VARCHAR(10),
   CHANGE PaymentMethod PaymentMethod VARCHAR(20),
   CHANGE OrderValue OrderValue DECIMAL(10,2),
   CHANGE ReturnReason ReturnReason VARCHAR(100),
   CHANGE CustomerType CustomerType VARCHAR(20),
   CHANGE Location Location VARCHAR(50),
   ADD PRIMARY KEY (OrderID);
```

### **3.2 Cleaning the Returned Column**

The `Returned` column was originally stored as a string ("True"/"False"). It was cleaned and converted to a Boolean (`TINYINT`) using the following:

```sql
SET SQL_SAFE_UPDATES = 0;
UPDATE orders_march2025
SET Returned = CASE
    WHEN Returned = 'True' THEN 1
    WHEN Returned = 'False' THEN 0
    ELSE Returned
END;

ALTER TABLE orders_march2025
MODIFY Returned BOOLEAN;
```

### **3.3 Categorical Standardization**

Distinct values in fields such as `PaymentMethod` were reviewed to check for inconsistencies:

```sql
SELECT DISTINCT PaymentMethod FROM orders_march2025;
```

---

## **4. Data Analysis**

The analysis was conducted using SQL queries that explored core business performance indicators:

### **4.1 Revenue Analysis**

- **Total Revenue**

```sql
SELECT SUM(OrderValue) FROM orders_march2025;
```

- **Total Orders & Average Order Value**

```sql
SELECT COUNT(*) AS TotalOrders,
       ROUND(SUM(OrderValue)/COUNT(*), 2) AS AvgOrderValue
FROM orders_march2025;
```

### **4.2 Sales by Product**

```sql
SELECT Product, SUM(OrderValue) AS Revenue
FROM orders_march2025
GROUP BY Product
ORDER BY Revenue DESC;
```

### **4.3 Klarna & Afterpay Usage**

```sql
SELECT PaymentMethod,
       COUNT(*) AS NumOrders,
       ROUND(AVG(OrderValue), 2) AS AvgOrderValue
FROM orders_march2025
WHERE PaymentMethod IN ('Klarna', 'Afterpay')
GROUP BY PaymentMethod;
```

### **4.4 Returns Analysis**

- **Overall Return Rate**

```sql
SELECT
  ROUND(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS ReturnRate
FROM orders_march2025;
```

- **Returns by Product**

```sql
SELECT Product,
       COUNT(*) AS TotalOrders,
       SUM(Returned) AS Returns,
       ROUND(SUM(Returned) / COUNT(*) * 100, 2) AS ReturnRate
FROM orders_march2025
GROUP BY Product
ORDER BY ReturnRate DESC;
```

- **Top Return Reasons**

```sql
SELECT ReturnReason, COUNT(*) AS Count
FROM orders_march2025
WHERE Returned = 1
GROUP BY ReturnReason
ORDER BY Count DESC;
```

### **4.5 Customer Segmentation**

- **New vs Returning**

```sql
SELECT CustomerType, COUNT(*) AS Orders,
       ROUND(SUM(OrderValue), 2) AS Revenue
FROM orders_march2025
GROUP BY CustomerType;
```

- **By Location**

```sql
SELECT Location, COUNT(*) AS Orders, SUM(OrderValue) AS Revenue
FROM orders_march2025
GROUP BY Location
ORDER BY Revenue DESC;
```

---

## **5. Output Use & Next Steps**

The results from this MySQL analysis were exported to CSV and used as input for visualization in **Tableau**, where KPIs, benchmarks, and interactive dashboards were developed.

Key dashboards included:

- **Revenue Trend** (with reference line for target)
- **Sales by Product** (vs. benchmark)
- **Return Rate** (vs. 5% target)
- **BNPL Usage**
- **KPI Tiles**: Total Revenue, AOV, Return Rate

---

## **6. Tools Used**

- **MySQL**: Data cleaning, exploration, analysis
- **Tableau Public**: Visualization and dashboard design

---

## **7. Limitations**

- Sample size is small ; results are indicative, not predictive.
- No time-series historic data available to track trends across multiple months.

---

## **8. Conclusion**

This methodology ensures transparent, repeatable analysis of Curlture's monthly performance using SQL-driven insights. It is designed to scale with increased transaction volume, integrate historical tracking, and support ongoing decision-making in product strategy, marketing, and customer experience.