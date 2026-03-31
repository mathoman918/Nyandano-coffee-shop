# Nyandano-coffee-shop
End-to-end data analysis project using SQL and data visualization to analyze Bright Coffee Shop sales data and provide business insights and recommendations.

## Bright Coffee Shop Sales Analysis

### Project Overview

This project analyzes historical transactional data from Bright Coffee Shop to generate business insights for the new CEO. The objective of the analysis is to understand product performance, store performance, peak sales times, and overall sales trends in order to make recommendations to improve revenue and business performance.

### Dataset Description

The dataset contains transactional sales data from three Bright Coffee Shop store locations:

* Lower Manhattan
* Hell’s Kitchen
* Astoria

### The dataset covers the period:

1 January 2023 – 30 June 2023

### The dataset includes:

•Transaction ID
•Transaction date and time
•Store location
•Product category
•Product type
•Product detail
•Unit price
•Quantity sold
•Project Objectives

### The main objectives of this project were to:

•Identify the products that generate the most revenue.
•Determine peak sales times.
•Analyze sales trends over time.
•Compare performance across store locations.
•Provide business recommendations to improve sales performance.

### Data Processing Steps

•The data was processed using SQL in Databricks. The following transformations were performed:
•Converted unit_price into numeric format.
•Created total_amount = unit_price × transaction_qty.
•Created day_name and month_name fields.
•Created transaction_hour field.
•Created transaction_time_bucket for 30-minute intervals.
•Aggregated revenue by product, store, and time intervals.

### Key Business Metrics Calculated

•Total Revenue
•Total Units Sold
•Number of Sales Transactions
•Revenue by Store Location
•Revenue by Product Category
•Revenue by Product Type
•Peak Sales Time
•Monthly Revenue Trend

### Key Insights

•Coffee is the highest revenue-generating product category.
•Tea is the second highest revenue-generating category.
•Hell’s Kitchen is the highest-performing store.
•Peak sales occur in the morning between 09:00 and 11:00.
•Revenue increased steadily from January to June.
•Some products perform poorly and may require promotion or pricing adjustments.

### Business Recommendations

•Increase stock of high-performing coffee and tea products.
•Run promotions during slow time periods.
•Increase staff during morning peak hours.
•Promote underperforming products.
•Implement a loyalty program for regular customers.
•Automate daily sales reporting and dashboards.

## Tools Used

*Databricks SQL
*Microsoft Excel
*PowerPoint
*Miro
*GitHub
