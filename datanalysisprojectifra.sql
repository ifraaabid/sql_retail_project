-- SQL Retail Sales Analysis - 

CREATE DATABASE my_DA_project;
USE my_DA_project;

-- Creating Table

CREATE TABLE retail_sales 
(  
    transactions_id INT PRIMARY KEY,
	sale_date	DATE ,
    sale_time   TIME ,
	customer_id  INT ,
	gender	VARCHAR (15) ,
    age	   INT ,
    category  VARCHAR (15) ,
	quantity	INT ,
    price_per_unit DECIMAL(10,2) ,
	cogs	DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

-- check if i have data
SELECT * FROM retail_sales 
 LIMIT 80;

-- to check how many records do i have

SELECT COUNT(*) FROM retail_sales ;

SELECT transactions_id , COUNT(*)
FROM retail_sales
GROUP BY transactions_id
HAVING COUNT(*) > 1;

SELECT * FROM retail_sales 
WHERE 
transactions_id is NULL 
OR
sale_time is NULL
OR 
sale_date is NULL
OR
gender is NULL
OR 
age is NULL
OR
category IS NULL
OR 
quantity IS NULL
OR
price_per_unit  IS NULL
OR 
cogs IS NULL 
OR 
total_sale IS NULL;

-- Data Exploration
SELECT COUNT(*) as total_sales FROM retail_sales;
-- how many customers we have
SELECT COUNT(customer_id) as total_sales FROM retail_sales;
-- but one customer can have many sales so we need distinction
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;

-- name of categories

SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS

-- Q1 Write a query to retreive all columns for sales made on "2022-11-05"
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05" ;

-- Q2 Write a query to retreive all transactions where the category is clothing and the quantity sold is more than 4 in the 
-- month if nov 2022

SELECT * FROM retail_sales
WHERE
category = "Clothing" AND quantity >= 4 AND  sale_date LIKE "2022-11%" ;

-- OR
-- SELECT * FROM retail_sales;
-- WHERE
-- category = "Clothing" AND quantity >= 4 AND  TO_CHAR(sale_date , 'YYYY-MM') = '2022-11';

-- Q3 Query to calculate the total sales for each category

SELECT category, SUM(total_sale) as net_sales, SUM(price_per_unit)
FROM retail_sales
GROUP BY 1;

-- Q4 avg age of customers who purchased items from category 'Beauty'
SELECT category, ROUND(AVG(age),2) as avg_age 
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1;

-- Q5 a query to find all transactions where the total sale is greater than 1000.
SELECT 
*
FROM retail_sales
WHERE total_sale > 1000 ;

-- Q6 a query to find the total no. of transactions made y each gender in each category

SELECT category, gender, COUNT(*) as total_sales
FROM retail_sales
GROUP BY category, gender
-- to organize it such as the same category is ordered together
ORDER BY 1 ;

-- Q7 A query to calculate the avg sale of each month. Find out the best selling year
SELECT -- * 
year, month, avg_sales
FROM
(
SELECT YEAR(sale_date) as year , MONTH(sale_date) as month, AVG(total_sale) as avg_sales, RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as ranks
FROM retail_sales
GROUP BY 1, 2 ) AS t1
WHERE ranks = 1 ;
-- ORDER BY 1, 3 DESC

-- Q7 A query to calculate the total of price per unit of each month. Find out the best selling year
SELECT year, month, total_price_per_unit  FROM (SELECT YEAR(sale_date) as year, MONTH(sale_date) as month, SUM(price_per_unit)as total_price_per_unit, RANK() OVER(PARTITION BY YEAR(sale_date), MONTH(sale_date) ORDER BY SUM(sale_date) DESC) as ranks
FROM retail_sales
GROUP BY 1, 2) as t1
WHERE ranks = 1;
-- ORDER BY 1 , 3 DESC ;

-- Q8 A query to find the top 5 customers based on the highest total sales
SELECT customer_id , SUM(total_sale) as total_saleS
FROM retail_saleS
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9 Find no. of unique customers who purchased items from each category
SELECT category , COUNT(DISTINCT customer_id) as unique_custs
FROM retail_sales
GROUP BY 1;

-- 10 a query to create each shift & no. of orders e.g (morning<< =12 , noon b/w 12 & 17 , eveening >17)
WITH hourly_sale
AS(
SELECT *,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales)
SELECT
shift , COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift ;

-- SELECT HOUR(sale_time)







