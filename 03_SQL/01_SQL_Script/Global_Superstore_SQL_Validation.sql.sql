/* ============================================================
   GLOBAL SUPERSTORE SALES ANALYSIS 
   ============================================================
   Database: MySQL 8.0+
   Primary table: superstore_sales
   Purpose: Validate sales, profitability, customer, product,
            discount, shipping, regional, and YoY business metrics.

   BUSINESS OBJECTIVE
   ------------------------------------------------------------
   Evaluate commercial performance and operational efficiency,
   identify profitable and loss-making products, understand
   customer and segment contribution, assess discount impact,
   measure shipping performance, and validate annual growth.
   
   -- Note:
   --   Single-table analysis. No JOINs are required.

/* ============================================================
   GLOBAL SUPERSTORE SALES ANALYSIS — SQL DATA ANALYSIS & VALIDATION
   Purpose: Data validation, business analysis and Power BI
            dashboard validation
   ============================================================ */

/* ============================================================
-- GROUP 01 — DATABASE & TABLE SETUP
-- QUERY PURPOSE: Create the analytical database and define the source table schema.
   ============================================================ */
CREATE DATABASE superstore_db;
USE superstore_db;
CREATE TABLE superstore_sales (
Order_ID VARCHAR(100),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Order_Priority VARCHAR(50),
Customer_ID VARCHAR(100),
Customer_Name VARCHAR(255),
Segment VARCHAR(100),
Product_ID VARCHAR(100),
Product_Name VARCHAR(100),
Category VARCHAR(100),
Sub_Category VARCHAR(100),
Market VARCHAR(50),
Region VARCHAR(50),
Country VARCHAR(50),
State VARCHAR(50),
City  VARCHAR(50),
Sales DECIMAL(10,2),
Quantity INT ,
Discount DECIMAL(10,2),
Discount_Range VARCHAR(50),
Discount_Category VARCHAR(50),
Profit DECIMAL(10,2),
Profit_Margin_Percent DECIMAL(10,2) NULL,
Profit_Status VARCHAR(100),
Ship_Cost DECIMAL(10,2),
Ship_Days INT,
Order_Status VARCHAR(50),
Year INT ,
Quarter INT ,
Month_No INT ,
Month_Name VARCHAR(20));

/* ============================================================
-- 02. DATA IMPORT & MYSQL CONFIGURATION
-- QUERY PURPOSE: Configure MySQL and import the cleaned Superstore Sales dataset.
   ============================================================ */
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/global_superstore_cleaned.csv.csv'
INTO TABLE superstore_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW CREATE TABLE superstore_sales;
SELECT * FROM superstore_sales LIMIT 10;
SELECT COUNT(*) AS Total_Records FROM superstore_sales;

/* ============================================================
-- GROUP 03 — DATA STRUCTURE & QUALITY VALIDATION
-- PURPOSE: Validate table structure,data completeness and duplicate records.
   ============================================================ */
-- 3.1 — Identify Zero-Sales Records
SELECT *
FROM superstore_sales
WHERE Sales = 0;

-- 3.2 — Validate Order and Ship Dates
SELECT *
FROM superstore_sales
WHERE Order_Date > Ship_Date;

-- 3.3 — Identify Invalid Shipping Days
SELECT *
FROM superstore_sales
WHERE Ship_Days < 0;

-- 3.4 — Identify Duplicate Order-Product-Customer Records
SELECT order_id,product_id,customer_id ,
       COUNT(*) AS COUNT_COLUMN
FROM superstore_sales
GROUP BY order_id ,  product_id , customer_id 
HAVING count_column > 1;

--  3.5 — Add Row-Level Identifier
ALTER TABLE superstore_sales
ADD COLUMN Row_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- 3.6 — Enforce Order-Product-Customer Uniqueness
ALTER TABLE superstore_sales
ADD CONSTRAINT Unique_Order_Product_Customer
UNIQUE (Order_ID, Product_ID, Customer_ID);

/* ============================================================
    04 — QUERY PERFORMANCE OPTIMIZATION
   ============================================================ */
CREATE INDEX Index_Country
ON superstore_sales(Country);
CREATE INDEX Index_Region
ON superstore_sales(Region);
CREATE INDEX Index_Category
ON superstore_sales(Category);
CREATE INDEX Index_Order_Date
ON superstore_sales(Order_Date);

/* ============================================================
    05 — KPI & OVERALL BUSINESS PERFORMANCE
   ============================================================ */
-- 5.1 — Overall Business KPI Performance
SELECT 
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(SUM(profit)/SUM(sales),2) AS profit_margin,
       COUNT(DISTINCT order_id) AS total_orders,
       COUNT(DISTINCT customer_id) AS total_customers,
       ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) AS avg_order_value,
       ROUND(AVG(ship_days),2) AS avg_ship_days
FROM superstore_sales;

/* ============================================================
    06 — TIME & TREND ANALYSIS
   ============================================================ */
--  6.1 — Monthly Sales, Profit & Margin Trend
SELECT  year,month_no,month_name,
       SUM(sales)AS total_sales,
       SUM(profit)AS total_profit,
       ROUND(SUM(profit)*100/SUM(sales),2) AS profit_margin
FROM superstore_sales
GROUP BY year,month_no,month_name
ORDER BY year,month_no ASC;

/* ============================================================
    07 — PRODUCT & CATEGORY PERFORMANCE
   ============================================================ */
--  7.1 — Validate Profit Status Distribution
SELECT Profit_Status,
      COUNT(*) AS Record_Count
FROM superstore_sales
GROUP BY Profit_Status;

--  7.2 — Category Performance
SELECT category,
       ROUND(SUM(sales),2)AS Total_Sales,
       ROUND(SUM(profit),2)AS Total_Profit,
       SUM(quantity)AS Total_Quantity,
       ROUND(SUM(Profit)*100/SUM(Sales),2)AS Profit_Margin_Percent
FROM superstore_sales
GROUP BY category
ORDER BY Total_Sales DESC;

--  7.3 — Sub-Category Performance
SELECT sub_category,
       ROUND(SUM(sales),2)AS Total_Sales,
       ROUND(SUM(profit),2)AS Total_Profit,
       SUM(quantity)AS Total_Quantity,
       ROUND(SUM(Profit)*100/SUM(Sales),2)AS Profit_Margin_Percent
FROM superstore_sales
GROUP BY sub_category
ORDER BY Total_Sales DESC;

--  7.4 — Product-Level Performance
SELECT product_name,
       ROUND(SUM(sales),2)AS Total_Sales,
       ROUND(SUM(profit),2)AS Total_Profit,
       SUM(quantity)AS Total_Quantity,
       ROUND(SUM(Profit)*100/SUM(Sales),2)AS Profit_Margin_Percent
FROM superstore_sales
GROUP BY product_name
ORDER BY Total_Sales DESC;

--  7.5 — Top 3 Loss-Making Products by Category
WITH 
Loss_Product AS
     (SELECT category, product_name, 
			SUM(profit) AS Total_Loss
      FROM superstore_sales
      GROUP BY category,product_name
      HAVING SUM(profit)< 0),
Ranked_product AS
      (SELECT category, product_name, Total_Loss,
              ROW_NUMBER() OVER(PARTITION BY category 
              ORDER BY Total_Loss ASC) AS product_Rank 
       FROM Loss_Product)
SELECT category, product_name ,Total_Loss,product_Rank
FROM Ranked_product
WHERE product_Rank <=3
ORDER BY category, product_Rank;

/* ============================================================
    08 — CUSTOMER PERFORMANCE
   ============================================================ */
-- 8.1 — Customer-Level Performance
SELECT customer_id ,customer_name,
       COUNT(DISTINCT order_id) AS Total_Orders,
       SUM(sales)AS Total_Sales,
       SUM(profit)AS Total_Profit
FROM superstore_sales
GROUP BY customer_id ,customer_name;

-- 8.2 — Customers Above Average Sales
WITH 
Customer_Sales AS
       (SELECT customer_id ,customer_name,
              COUNT(DISTINCT order_id) AS Total_Orders,
              SUM(sales)AS Total_Sales
       FROM superstore_sales
       GROUP BY customer_id ,customer_name)
SELECT customer_id ,customer_name,Total_Sales
FROM Customer_Sales
WHERE Total_Sales>
       (SELECT AVG(Total_Sales)
        FROM Customer_Sales)
ORDER BY Total_Sales DESC;

-- 8.3 — Customers Contributing to the First 20% of Sales
WITH 
Customer_Sales AS
       (SELECT customer_id,customer_name,
              SUM(sales) AS Total_Sales
	    FROM superstore_sales 
        GROUP BY customer_id,customer_name),
Ranked_Customers AS
	   (SELECT *,
              SUM(Total_Sales) 
              OVER(ORDER BY Total_Sales DESC 
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
			  AS Cumulative_Sales,
              SUM(Total_Sales) 
              OVER() AS Overall_Sales
	   FROM Customer_Sales)
SELECT customer_id,customer_name,Total_Sales,
       ROUND(Cumulative_Sales*100/Overall_Sales,2)AS Cumulative_Sales_Percent
FROM Ranked_Customers
WHERE Cumulative_Sales <= Overall_Sales*0.20
ORDER BY Total_Sales DESC;

/* ============================================================
    09 — CUSTOMER SEGMENT PERFORMANCE
   ============================================================ */
-- 9.1 — Segment Performance
SELECT segment,
       ROUND(SUM(sales),2)AS Total_Sales,
       ROUND(SUM(profit),2)AS Total_Profit,
       SUM(quantity)AS Total_Quantity,
       ROUND(SUM(Profit)*100/SUM(Sales),2)AS Profit_Margin_Percent
FROM superstore_sales
GROUP BY segment;

/* ============================================================
    10 — DISCOUNT ANALYSIS
   ============================================================ */
-- Query 10.1 — Discount Range Performance
SELECT discount_range,
      ROUND(SUM(sales),0)AS Total_Sales,
      ROUND(SUM(profit),0)AS Total_Profit,
      SUM(quantity)AS Total_Quantity,
	  ROUND(SUM(Profit)*100/SUM(Sales),2)AS Profit_Margin_Percent
FROM superstore_sales
GROUP BY discount_range
ORDER BY Total_Sales DESC;

/* ============================================================
    11 — SHIPPING & OPERATIONAL PERFORMANCE
   ============================================================ */
-- 11.1 — Shipment Status Performance
WITH 
Order_Status AS
           (SELECT order_id,ship_mode,
                  MAX(ship_days)AS Ship_Days,
                  SUM(sales) AS Order_Sales
		   FROM superstore_sales 
           GROUP BY order_id,ship_mode),
Classified_Orders AS
           (SELECT order_id,ship_mode,Ship_days,Order_Sales,
           CASE 
           WHEN Ship_Days<=3 THEN "On-Time"
           WHEN Ship_Days<=6 THEN "Delayed"
           ELSE "Critically Delayed"
           END AS Shipment_Status
           FROM Order_Status)
SELECT  Shipment_Status,
       COUNT(*) AS Total_Orders,
       ROUND(AVG(ship_days),2)AS Avg_Ship_days,
       ROUND(COUNT(*)*100/SUM(COUNT(*))OVER(),2) AS Order_Percent,
       SUM(order_sales)AS Total_Sales
FROM Classified_Orders
GROUP BY  Shipment_Status;

-- 11.2 — Ship Mode Performance
WITH 
Order_Status AS
           (SELECT order_id,ship_mode,
           MAX(ship_days)AS Ship_Days,
           SUM(sales) AS Order_Sales
           FROM superstore_sales 
           GROUP BY order_id,ship_mode),
Classified_Orders AS
           (SELECT order_id,ship_mode,Ship_days,Order_Sales,
           CASE 
           WHEN Ship_Days<=3 THEN "On-Time"
           WHEN Ship_Days<=6 THEN "Delayed"
           ELSE "Critically Delayed"
           END AS Shipment_Status
           FROM Order_Status)
SELECT Ship_Mode,
       COUNT(*) AS Total_Orders,
       ROUND(AVG(ship_days),2)AS Avg_Ship_days,
       ROUND(COUNT(*)*100/SUM(COUNT(*))OVER(),2) AS Order_Percent,
       SUM(order_sales)AS Total_Sales
FROM Classified_Orders
GROUP BY Ship_Mode;

/* ============================================================
    12 — REGIONAL & GEOGRAPHICAL PERFORMANCE
   ============================================================ */
--  12.1 — Regional Sales & Profit Ranking
SELECT region,
       ROUND(SUM(sales),2)AS Total_Sales,
       DENSE_RANK()Over(ORDER BY SUM(sales)DESC) AS Sales_Rank,
       ROUND(SUM(profit),2)AS Total_Profit,
       DENSE_RANK()Over(ORDER BY SUM(profit)DESC) AS Profit_Rank
FROM superstore_sales
GROUP BY region;

-- 12.2 — Top 3 Countries by Sales within Each Region
WITH
 Country_Sales AS
     (SELECT region, country,SUM(sales) AS Total_Sales
      FROM superstore_sales
      GROUP BY region,country),
Ranked_Country AS
      (SELECT region,country,Total_Sales,
       ROW_NUMBER() OVER(PARTITION BY Region 
       ORDER BY Total_Sales DESC) AS Country_Rank 
       FROM Country_Sales)
SELECT region,country,Total_Sales,Country_Rank
FROM Ranked_Country
WHERE Country_Rank <=3
ORDER BY Region,Country_Rank;

/* ============================================================
    13 — YEAR-OVER-YEAR BUSINESS PERFORMANCE VALIDATION
   ============================================================ */
--  13.1 — Annual Sales, Profit & YoY Growth
WITH 
YearlyPerformance AS
       (SELECT year,
              SUM(sales) AS Total_Sales,
              Sum(profit) AS Total_Profit
       FROM superstore_sales
       GROUP BY year),
PreviousYear AS
       (SELECT 
              year,Total_Sales,Total_Profit,
              LAG (Total_Sales) Over(ORDER BY year ) AS Previous_Year_Sales,
              LAG(Total_Profit) OVER (ORDER BY year) AS Previous_Year_Profit
       FROM YearlyPerformance)
SELECT year,Total_Sales,Total_Profit,
       Round((Total_Sales-Previous_Year_Sales)*100/
       NULLIF(Previous_Year_Sales,0),2) AS Sales_YoY_Percent,
       Round((Total_Profit-Previous_Year_Profit)*100/
       NULLIF(Previous_Year_Profit,0),2) AS Profit_YoY_Percent
FROM PreviousYear
ORDER BY Year;

-- ============================================================
-- END OF GLOBAL SUPERSTORE SALES ANALYSIS
-- ============================================================