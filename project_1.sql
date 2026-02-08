-- Active: 1770309306489@@127.0.0.1@5432@Project01
-- Create table "retail_sales"
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(30),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Data cleaning and validation
SELECT
    *
FROM
    retail_sales
LIMIT
    10;

SELECT
    count(*)
FROM
    retail_sales;

SELECT
    count(*)
FROM
    retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SELECT
    round(avg(age), 2)
FROM
    retail_sales;

SELECT
    min(age)
FROM
    retail_sales;

SELECT
    max(age)
FROM
    retail_sales;

SELECT
    age
FROM
    retail_sales;

SELECT
    customer_id,
    age
FROM
    retail_sales
WHERE
    customer_id = 16;

-- Normalize age per customer
UPDATE
    retail_sales r
SET
    age = sub.age_avg
FROM
    (
        SELECT
            customer_id,
            round(avg(age)) AS age_avg
        FROM
            retail_sales
        WHERE
            age IS NOT NULL
        GROUP BY
            customer_id
    ) sub
WHERE
    r.customer_id = sub.customer_id;

SELECT
    count(*)
FROM
    retail_sales
WHERE
    age IS NULL;

-- Remove incomplete records
DELETE FROM
    retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SELECT
    count(*)
FROM
    retail_sales;

-- How many unique customers we have 
SELECT
    count(DISTINCT customer_id)
FROM
    retail_sales;

-- How many category we have 
SELECT
    DISTINCT category
FROM
    retail_sales;

-- Data analysis
-- 01 Retrieve sales records for a specific date (2022-11-05)
SELECT
    *
FROM
    retail_sales;

SELECT
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- 02 Filter Clothing transactions with high quantity in November 2022
SELECT
    *
FROM
    retail_sales
WHERE
    to_char(sale_date, 'YYYY-MM') = '2022-11'
    AND category = 'Clothing'
    AND quantiy >= 4;

-- 03 Calculate total sales by product category
SELECT
    category,
    sum(total_sale)
FROM
    retail_sales
GROUP BY
    category;

-- 04 Analyze average customer age for the Beauty category
SELECT
    DISTINCT customer_id
FROM
    retail_sales;

SELECT
    round(avg(age), 0) AS Average_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- 05 Identify high-value transactions (total sales > 1000)
SELECT
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- 06 Count transactions by gender and category
SELECT
    *
FROM
    retail_sales;

SELECT
    DISTINCT category,
    gender,
    count(*)
FROM
    retail_sales
GROUP BY
    1,
    2;

-- 07 Determine the best-selling month for each year based on average sales
SELECT
    *
FROM
    retail_sales;

SELECT
    year,
    month,
    sales_avg
FROM
    (
        SELECT
            extract(
                YEAR
                FROM
                    sale_date
            ) as year,
            extract(
                MONTH
                FROM
                    sale_date
            ) as month,
            round(avg(total_sale)) as sales_avg,
            RANK () OVER(
                PARTITION BY extract(
                    YEAR
                    FROM
                        sale_date
                )
                ORDER BY
                    round(avg(total_sale)) DESC
            ) as rank
        FROM
            retail_sales
        GROUP BY
            1,
            2
    ) AS t1
WHERE
    rank = 1;

-- 08 Identify top 5 customers by total sales value
SELECT
    *
FROM
    retail_sales;

SELECT
    DISTINCT customer_id,
    sum(total_sale)
FROM
    retail_sales
GROUP BY
    customer_id
ORDER BY
    sum(total_sale) DESC
LIMIT
    5;

-- 09 Count unique customers per product category
SELECT
    *
FROM
    retail_sales;

SELECT
    DISTINCT category,
    count(DISTINCT customer_id)
FROM
    retail_sales
GROUP BY
    1;

-- 10 Analyze order distribution by daily time shifts (Morning, Afternoon, Evening)
WITH shift_table AS(
    SELECT
        *,
        CASE
            WHEN extract(
                HOUR
                FROM
                    sale_time
            ) < 12 THEN 'Morning'
            WHEN extract(
                HOUR
                FROM
                    sale_time
            ) BETWEEN 12
            AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM
        retail_sales
)
SELECT
    shift,
    count(*)
FROM
    shift_table
GROUP BY
    shift;
