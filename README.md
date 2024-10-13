# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  

**Database**: `p1_retail_db`


## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
--------- SQL RETAIL SALES ANALYST ---------
CREATE DATABASE sql_pj_p1;



--------- CREATE TABLE  ---------
DROP TABLE IF EXISTS retail_sales; 
CREATE TABLE retail_sales(
	transactions_id	 INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(20),
	age INT,
	category VARCHAR(20),
	quantity  INT,
	price_per_unit  FLOAT,
	cogs FLOAT,
	total_sale  FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- CHECK IF ANY NULL VALUE EXIST

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity  IS NULL
	OR
	price_per_unit  IS NULL
	OR
	cogs IS NULL
	OR
	total_sale  IS NULL;

-- DELETE ROW THAT HAVE NULL VALUE
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity  IS NULL
	OR
	price_per_unit  IS NULL
	OR
	cogs IS NULL
	OR
	total_sale  IS NULL;

--------- DATA EXPLORATION ---------

-- How many sales we have on data? 
SELECT COUNT(*) as total_sales FROM retail_sales;
-- How many customers we have?   
SELECT COUNT(DISTINCT customer_id ) FROM retail_sales;   
-- What categories we have?
SELECT DISTINCT category  FROM retail_sales;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

```

2. **SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
	AND
	quantity >= 4;

```

3. **SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT	
	category,
	SUM(total_sale) as total_sales,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

```

4. **SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),2) AS avg_age_purchased_beauty
FROM retail_sales
GROUP BY category
HAVING category = 'Beauty'
	
```

5. **SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

```

6. **SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,
    gender,
    COUNT(*) AS  total_transaction

FROM retail_sales
GROUP BY category, gender
ORDER BY category;

```

7. **SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH cte_1 AS(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year,month
ORDER BY year, avg_sales DESC
)

SELECT *
FROM cte_1
WHERE rank = 1;
```

8. **SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id,
    SUM(total_sale) as buy
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 desc 
LIMIT 5;
```

9. **SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
    count(DISTINCT(customer_id)) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH cte_hr_sale AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)

SELECT shift,
	COUNT(*) AS total_orders
		
FROM cte_hr_sale
GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project encompasses a comprehensive SQL analysis, covering database setup, data cleaning, exploratory data analysis, and SQL queries tailored to business needs. The insights gained from this project aim to support strategic business decisions by understanding sales trends, identifying customer behaviors, and evaluating product performance.

