SELECT * FROM sales;


-- Change Column name -------------------------------------------------------------------------------------

ALTER TABLE sales CHANGE `ï»¿transactions_id` transaction_id INT;

select * from sales;

-- Data Check & Cleaning----------------------------------------------------------------------------------
select count(*) from sales;

select * from sales
where transaction_id is null;



-- Check NULL values-------------------------------------------------------------------------------------

SELECT * FROM sales
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;

-- Data Exploration--------------------------------------

-- How many sales we have ------------------------------------

SELECT COUNT(*) AS total_sales
FROM sales;


-- How many unique customer we have----------------------------

SELECT 
    COUNT(DISTINCT customer_id) AS customers
FROM
    sales;
 
    
-- How many category we have--------------------------------------------------------------------

SELECT DISTINCT
    (category) AS type_of_category
FROM
    sales;
 
    
    
-- category wise quantity_sales
SELECT 
    category, SUM(quantiy) AS quantity_sales
FROM
    sales
GROUP BY category;


-- Data analysis & Bussiness key problems & Answers


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from sales
where sale_date = '2022-11-05';



/* Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
 and the quantity sold is more than 3 in the month of Nov-2022*/

SELECT  * FROM sales
WHERE
category = 'Clothing' AND quantiy >= 3
        AND MONTH(sale_date) = 11
        AND YEAR(sale_date) = 2022;

-- Alternative

SELECT * FROM sales
WHERE
category = 'Clothing' AND quantiy >= 3
	 AND sale_date 
     BETWEEN '2022-11-01' AND '2022-11-30';
     
     
     
-- Q.3 Write a SQL query to calculate the total sales (total_sale) & total order for each category.

SELECT 
    category,
    SUM(total_sale) AS sales,
    COUNT(customer_id) AS num_of_orders
FROM
    sales
GROUP BY category;



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    sales
WHERE
    category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from sales
where total_sale > 1000;



-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    gender,
    category,
    COUNT(transaction_id) AS total_transactions
FROM sales
GROUP BY gender, category
ORDER BY gender, category;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_avg AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, avg_sale
FROM (
    SELECT 
        year, 
        month, 
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rnk
    FROM monthly_avg
) ranked
WHERE rnk = 1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY category
ORDER BY unique_customers DESC;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17

 SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transaction_id) AS total_orders
FROM sales
GROUP BY shift
ORDER BY total_orders DESC; 


-- End Project------------------------------