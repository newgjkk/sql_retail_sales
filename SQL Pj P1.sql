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

SELECT COUNT(*) FROM retail_sales;


--------- DATA CLEANING ---------

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

---------------------------------------------------------
--------- DATA ANALYSIS & BUSINESS KEY PROBLEMS ---------
---------------------------------------------------------

-- retrive all colums fro sales made on 2022 11 05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- retrove all tranactions where the category is 'Clothing' and quantity sold is more that 4 on month of NOV-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing' 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
	AND
	quantity >= 4;


-- TOTAL SALES/ORDERS FOR EACH CATEGORY
SELECT	
	category,
	SUM(total_sale) as total_sales,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

SELECT * FROM retail_sales;
-- AVERAGE AGE OF CUSTOMERS WHO PURCHASED 'Beauty category'
SELECT ROUND(AVG(age),2) AS avg_age_purchased_beauty

FROM retail_sales

GROUP BY category
HAVING category = 'Beauty'
	
-- Transaction where total sales are more than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Total number of Transaction per category adn gender
SELECT category, gender,COUNT(*) AS  total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- HIGHEST SALES OF MONTH FOR EACH YEAR
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

-- FIND TOP 5 customers based on the higehest total sales

SELECT customer_id, SUM(total_sale) as buy

FROM retail_sales
GROUP BY customer_id
ORDER BY 2 desc 
LIMIT 5;


-- UNIQUE CUSTOMERS who purchase item from each category

SELECT category, count(DISTINCT(customer_id)) cnt_unique_cs
FROM retail_sales
GROUP BY category

-- CREATE EACH SHIFT AND NUMBER OF ORDER 
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

---- END OF PROJECT------


