

DROP TABLE IF EXISTS retail_sales;
GO


CREATE TABLE retail_sales
   (
     transactions_id INT PRIMARY KEY,	
     sale_date  DATE,	
     sale_time	TIME,
     customer_id INT,
     gender	VARCHAR (15),
     age	INT,
     category VARCHAR (15),	
     quantity  INT,
     price_per_unit	FLOAT,
     cogs           FLOAT,	
     total_sale FLOAT
   );

   SELECT * 
   FROM retail_sales; 

   USE sql_project_p2;
GO

BULK INSERT retail_sales
FROM "C:\Users\admin\Documents\SQL\SQL - Retail Sales Analysis_utf .csv"
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

SELECT COUNT(*) FROM retail_sales;
SELECT * FROM retail_sales;
SELECT TOP 10 * FROM retail_sales;
USE sql_project_p2;
GO
SELECT TOP 10 * FROM retail_sales;
SELECT COUNT (*) FROM retail_sales;

--
Data Cleaning
Checking for NULL 
USE sql_project_p2;
GO
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;
SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE
transactions_id is NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
gender IS NULL	
OR
category IS NULL
OR
quantity IS NULL

OR
cogs IS NULL
OR
total_sale IS NULL ;
--
DELETE FROM retail_sales
WHERE
transactions_id is NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
gender IS NULL	
OR
category IS NULL
OR
quantity IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL ;
---
Data Exploration
How many sales we have
SELECT COUNT (*) AS total_sales FROM retail_sales ;
----
How many unique customers we have
SELECT COUNT (DISTINCT customer_id) AS customers FROM retail_sales ;

---
How many unique categories we have
SELECT COUNT (DISTINCT category) AS unique_categories  FROM retail_sales ;
SELECT DISTINCT category FROM retail_sales ;

----
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
USE sql_project_p2
GO

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
USE sql_project_p2
GO
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND YEAR(sale_date) = 2022
AND MONTH(sale_date) = 11
AND quantity  >= 4 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS net_sales, COUNT (*) total_orders FROM retail_sales
GROUP BY category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT * FROM retail_sales

USE sql_project_p2
GO
SELECT AVG(age) AS average_age  FROM retail_sales
WHERE category = 'Beauty';



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale ASC;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM retail_sales
USE sql_project_p2
GO
SELECT YEAR(sale_date) AS Year, MONTH(sale_date) Month, ROUND(AVG(total_sale),2) AS average_sale
RANK (OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC)
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY Year, average_sale DESC;

SELECT
    YEAR(sale_date) AS sales_year,
    MONTH(sale_date) AS sales_month,
    ROUND(AVG(total_sale), 2) AS avg_monthly_sale
FROM retail_sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date)
ORDER BY
    sales_year,
    sales_month;

    Ranking

    USE sql_project_p2;
GO

WITH monthly_avg AS (
    SELECT
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        ROUND(AVG(total_sale), 2) AS average_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT
    sales_year,
    sales_month,
    average_sale,
    RANK() OVER (
        PARTITION BY sales_year
        ORDER BY average_sale DESC
    ) AS rank_in_year
FROM monthly_avg
ORDER BY sales_year, rank_in_year;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
USE sql_project_p2
GO
SELECT * FROM retail_sales
SELECT TOP 5 customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT * FROM retail_sales
USE sql_project_p2
GO
SELECT category, COUNT(DISTINCT customer_id) distinct_customers  FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
 SELECT *,
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)

--- end of project
SELECT 
shift,
COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
---- Data Analysis & Business Key Problems & Answers



