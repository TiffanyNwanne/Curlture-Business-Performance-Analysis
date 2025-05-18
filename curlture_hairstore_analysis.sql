-- DATA IMPORT & EXPLORATION--

-- View table --
SELECT * FROM orders_march2025;

-- DATA CLEANING --

-- Standardize data types
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
 
-- View changes --
SELECT * FROM orders_march2025;
   
-- Because Returned column is stored as a string and cannot be converted to an integer to enable it to be converted to boolean(MySQL alias for TINYINT, I will convert it to an integer
-- Temporarily Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;
UPDATE orders_march2025
SET Returned = CASE
    WHEN Returned = 'True' THEN 1
    WHEN Returned = 'False' THEN 0
    ELSE Returned
END;

-- View changes --
SELECT * FROM orders_march2025;


-- Change to boolean now
ALTER TABLE orders_march2025
MODIFY Returned BOOLEAN;

-- View changes --
SELECT * FROM orders_march2025;

-- Standardize categorical values by checking for inconsistent labels
SELECT DISTINCT PaymentMethod FROM orders_march2025;

-- View changes --
SELECT * FROM orders_march2025;

-- DATA ANALYSIS --

-- Total Revenue --
SELECT SUM(OrderValue) FROM orders_march2025;

-- Total Orders & Average Order Value -- 
SELECT COUNT(*) AS TotalOrders,
       ROUND(SUM(OrderValue)/COUNT(*), 2) AS AvgOrderValue
FROM orders_march2025;

-- Revenue by Product Type --
SELECT Product, SUM(OrderValue) AS Revenue
FROM orders_march2025
GROUP BY Product
ORDER BY Revenue DESC;

-- BNPL (Klarna and Afterpay) Usage
SELECT PaymentMethod,
       COUNT(*) AS NumOrders,
       ROUND(AVG(OrderValue), 2) AS AvgOrderValue
FROM orders_march2025
WHERE PaymentMethod IN ('Klarna', 'Afterpay')
GROUP BY PaymentMethod;

--  Overall Return Rate --
SELECT 
  ROUND(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS ReturnRate
FROM orders_march2025;

-- Returns by Product --
SELECT Product,
       COUNT(*) AS TotalOrders,
       SUM(Returned) AS Returns,
       ROUND(SUM(Returned) / COUNT(*) * 100, 2) AS ReturnRate
FROM orders_march2025
GROUP BY Product
ORDER BY ReturnRate DESC;

-- Top Return Reasons --
SELECT ReturnReason, COUNT(*) AS Count
FROM orders_march2025
WHERE Returned = 1
GROUP BY ReturnReason
ORDER BY Count DESC;

-- New vs Returning Customers --
SELECT CustomerType, COUNT(*) AS Orders,
       ROUND(SUM(OrderValue), 2) AS Revenue
FROM orders_march2025
GROUP BY CustomerType;