# Global Superstore Sales Analysis 🌍

## Project Overview

This project analyzes Global Superstore sales performance using an end-to-end data analytics workflow.

**Workflow:** Excel → Power Query → Power BI → SQL

**Objective:** Analyze sales, profitability, customers, products, discounts, shipping, geography and year-over-year performance to support data-driven business decisions.

**Dataset:** 51,255 analytical records covering 2011–2014.

---

## Tools Used

- Excel
- Power Query
- Power BI
- MySQL
- SQL

---

## Project Workflow

### Data Preparation

Performed using Excel Power Query:

- Data type transformation
- Text standardization
- Column cleanup
- Duplicate removal
- Product name cleaning
- Discount range classification
- Profit margin calculation
- Shipping days calculation
- Shipping status classification
- Profit status classification
- Year, quarter and month feature creation
- Data quality validation

**Final Dataset:** 51,255 rows × 32 columns

### Data Modeling & Dashboard

Power BI was used for dimensional data modeling, DAX measures and interactive dashboard development.

The dashboard contains **3 analytical pages**:

- Overview
- Sales Analysis
- Profit Analysis

Analysis covers sales, profit, margin, orders, customers, products, categories, sub-categories, discounts, shipping, segments and geographic performance. 1

---

## Key KPIs

| KPI | Value |
|---|---:|
| Total Sales | **$12.63M** |
| Total Profit | **$1.46M** |
| Profit Margin | **11.6%** |
| Total Orders | **25,035** |
| Total Customers | **4,873** |
| Average Order Value | **$505** |
| Average Ship Days | **3.97** |
| Total Quantity | **178,184** |

---

## Key Insights

- Sales increased consistently from **$2.26M in 2011 to $4.30M in 2014**.
- **Technology** is the largest category by sales at approximately **$4.74M** and also generates the highest category profit.
- **Consumer** is the largest customer segment with approximately **$6.50M** in sales.
- **Furniture** requires profitability attention, with a comparatively low **6.94% margin**.
- **Tables** is a notable loss-making sub-category with approximately **-$64K profit**.
- Higher discount levels are strongly associated with declining profitability, with discounts above **30% becoming loss-making in aggregate**.
- **Standard Class** is the dominant shipping mode with **15,154 orders**.
- **Central** is the leading region by sales at approximately **$2.82M**.
- **Q4** is the strongest quarter by sales and profit.
- SQL validation independently reproduces major business metrics and year-over-year calculations.

---

## SQL Validation

MySQL was used as an independent validation layer for the Power BI analysis.

Performed:

- Database and table setup
- Data import
- Data-quality validation
- KPI reconciliation
- Monthly trend analysis
- Product and category analysis
- Customer analysis
- Customer segment analysis
- Discount analysis
- Shipping and operational analysis
- Regional and geographic analysis
- Year-over-year validation

**SQL concepts:**

- Aggregations
- `CASE`
- `GROUP BY`
- CTEs
- `DENSE_RANK()`
- `LAG()`
- Window Functions
- Conditional Analysis
- Ranking

The SQL layer independently recalculates key Power BI metrics, providing a reproducible validation and quality-control layer. 2

---

## Project Structure

```
Global-Superstore-Sales-Analysis/

├── 01_Raw_Data
│   └── Original Global Superstore dataset
├── 02_Cleaned_Data
│   └── Cleaned and engineered Excel/CSV data
├── 03_SQL
│   └── SQL validation & analysis queries
├── 04_Power_BI
│   └── Power BI dashboard (.pbix)
├── 05_Screenshots
│   └── Power Query & Power BI evidence
├── 06_Project_Report
│   └── Professional project documentation
└── README.md
```

## Skills Demonstrated

- Excel
- Power Query
- Power BI
- SQL / MySQL
- Data Cleaning
- Feature Engineering
- Data Quality Validation
- Data Modeling
- DAX
- Dashboard Development
- Sales Analysis
- Profitability Analysis
- Business Intelligence
- Data Validation

## Conclusion

End-to-end Global Superstore analysis using Excel, Power Query, Power BI and SQL to deliver actionable insights into sales, profitability, customers, products, discounts, shipping and geographic performance.

## Project Information

**Title:** Global Superstore Sales Analysis  
**Prepared By:** Ashish Verma  
**Role:** Data Analyst / MIS Analyst  
**Tools Used:** Excel | Power Query | Power BI | MySQL  
**Project Type:** End-to-End Data Analytics & MIS Project
