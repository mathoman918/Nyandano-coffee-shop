--- DATA EXPLORATION
-- Preview the table
SELECT *
FROM workspace.default.coffee_shop
LIMIT 10;

-- Check total records
SELECT COUNT(*) AS total_rows
FROM workspace.default.coffee_shop;

-- Check distinct sales, products, stores
SELECT 
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores
FROM workspace.default.coffee_shop;

--- Check date range
SELECT 
    MIN(transaction_date) AS min_date,
    MAX(transaction_date) AS max_date
FROM workspace.default.coffee_shop;

--- Check store locations
SELECT DISTINCT store_location
FROM workspace.default.coffee_shop;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM workspace.default.coffee_shop;

--- Check products sold
SELECT DISTINCT 
    product_category,
    product_type,
    product_detail
FROM workspace.default.coffee_shop
ORDER BY product_category, product_type, product_detail;

--- Check price range
SELECT 
    MIN(unit_price) AS cheapest_price,
    MAX(unit_price) AS most_expensive_price
FROM workspace.default.coffee_shop;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--- Data Cleaning & Transformation
CREATE OR REPLACE TABLE workspace.default.coffee_shop_clean AS
SELECT
    transaction_id,
    TO_DATE(transaction_date, 'M/d/yyyy') AS transaction_date,

    YEAR(TO_DATE(transaction_date, 'M/d/yyyy')) AS year,
    MONTH(TO_DATE(transaction_date, 'M/d/yyyy')) AS month,
    DAY(TO_DATE(transaction_date, 'M/d/yyyy')) AS day,

    DATE_FORMAT(TO_DATE(transaction_date, 'M/d/yyyy'), 'MMMM') AS month_name,
    DATE_FORMAT(TO_DATE(transaction_date, 'M/d/yyyy'), 'EEEE') AS day_name,

    DATE_FORMAT(transaction_time, 'HH:mm:ss') AS transaction_time,

    HOUR(transaction_time) AS transaction_hour,

    CONCAT(
        LPAD(CAST(HOUR(transaction_time) AS STRING), 2, '0'),
        ':',
        CASE
            WHEN MINUTE(transaction_time) < 30 THEN '00'
            ELSE '30'
        END
    ) AS transaction_time_bucket,

    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    transaction_qty,

    CAST(REPLACE(CAST(unit_price AS STRING), ',', '.') AS DOUBLE) AS unit_price,
    transaction_qty * CAST(REPLACE(CAST(unit_price AS STRING), ',', '.') AS DOUBLE) AS total_amount

FROM workspace.default.coffee_shop;
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
--- View Cleaned Data
SELECT *
FROM workspace.default.coffee_shop_clean
LIMIT 10;

--- Daily sales trend
SELECT
    transaction_date,
    day_name,
    month_name,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(total_amount) AS revenue_per_day
FROM coffee_shop_clean
GROUP BY
    transaction_date,
    day_name,
    month_name
ORDER BY transaction_date;

--- Total revenue
SELECT
    COUNT(*) AS number_of_rows,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores,
    SUM(total_amount) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold
FROM coffee_shop_clean;

--- Revenue by store
SELECT
    store_location,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS total_units_sold,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY store_location
ORDER BY total_revenue DESC;

--- Revenue by product category
SELECT
    product_category,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY product_category
ORDER BY total_revenue DESC;

--- Revenue by product type
SELECT
    product_type,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY product_type
ORDER BY total_revenue DESC;

--- Best-selling product details
SELECT
    product_detail,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY product_detail
ORDER BY total_revenue DESC
LIMIT 10;

--- Lowest-performing products
SELECT
    product_detail,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY product_detail
ORDER BY total_revenue ASC
LIMIT 10;

--- Peak sales by 30-minute interval
SELECT
    transaction_time_bucket,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS total_units_sold,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY transaction_time_bucket
ORDER BY total_revenue DESC;

--- Peak sales by 1hour interval
SELECT
    transaction_hour,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS total_units_sold,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY transaction_hour
ORDER BY total_revenue DESC;

--- Sales by day of week
SELECT
    day_name,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS total_units_sold,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY day_name
ORDER BY total_revenue DESC;

--- Monthly trend
SELECT
    month_name,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS total_units_sold,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY month_name
ORDER BY 
    CASE month_name
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
    END;

--- Best product category per store
SELECT
    store_location,
    product_category,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY store_location, product_category
ORDER BY store_location, total_revenue DESC;

--- Best time bucket per store :param_1
SELECT
    store_location,
    transaction_time_bucket,
    SUM(total_amount) AS total_revenue
FROM coffee_shop_clean
GROUP BY store_location, transaction_time_bucket
ORDER BY store_location, total_revenue DESC;
