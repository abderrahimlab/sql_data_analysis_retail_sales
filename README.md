# sql_data_analysis_retail_sales
## **1- Project Overview**

This project focuses on analyzing and cleaning a retail sales dataset using PostgreSQL.
The dataset contains customer transaction records from 2022 and 2023, including sales details, customer information, and product categories.
The main objective is to:
Clean and validate raw data
Handle missing and inconsistent values using business logic
Prepare the dataset for reliable analysis using SQL

## **2- Dataset Information**

Table name: retail_sales
Time period: 2022–2023
Source: Retail sales CSV dataset
Data type: Transaction-level sales data

## **3- Key Columns**
* transactions_id
* sale_date
* sale_time
* customer_id
* gender
* age
* category
* quantity
* price_per_unit
* cogs
* total_sale

## **4- Data Cleaning & Preparation**
Identifying Missing Values
Initial exploration revealed missing values across multiple columns, including customer attributes and core sales metrics.
```sql 
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
### **Handling Inconsistent Customer Age**
Some customers appeared multiple times with:
* Different age values
* NULL age values
Since all transactions occurred within **2022–2023**, customer age was treated as a stable **customer-level attribute**.
The observed inconsistencies were considered **data quality issues**, not real-world age changes.

#### **Solution**

A single representative age was assigned per customer by calculating the **average age per customer**, excluding NULL values.
```sql
UPDATE retail_sales r
SET age = sub.age_avg
FROM (
    SELECT customer_id, ROUND(AVG(age)) AS age_avg
    FROM retail_sales
    WHERE age IS NOT NULL
    GROUP BY customer_id
) sub
WHERE r.customer_id = sub.customer_id;
```
This step:
* Removes inconsistencies
* Fills missing age values
* Ensures analytical consistency at the customer level

### **Removing Invalid Records**
Records with missing **critical sales fields** were removed, as they cannot support meaningful sales analysis.
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

```

## **Analysis Goals**

* After cleaning, the dataset is suitable for:
* Sales performance analysis
* Category-level insights
* Customer behavior analysis
* Time-based sales trends

## **Tools Used**
* PostgreSQL
* pgAdmin 4
* Visual Studio Code (Database Client Extension)
* SQL

## **Repository Structure**
├── project_1.sql          # SQL queries for data cleaning and analysis

├── retail_sales.csv       # Raw dataset

└── README.md              # Project documentation

## **Key Takeaways**

* Data quality issues must be identified before analysis
* Customer attributes should be treated at the correct granularity
* SQL can effectively handle real-world data cleaning challenges
* Analytical decisions should always be justified by business logic
## Author
**Abderrahim Labdaoui**

**Aspiring Data Analyst | SQL | PostgreSQL** 


