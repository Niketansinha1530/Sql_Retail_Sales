-- Sql Sales Retail Analysis -- P1

--  Create Database Retail_Sales

-- Create Table
Drop table if exists retail_sales;
Create table retail_sales
   (
	
    transactions_id	int primary key,
	sale_date Date,
	sale_time Time,
	customer_id	int,
	gender	Varchar(15),
	age	int,
	category Varchar(25),
	quantiy	int,
	price_per_unit float,
	cogs float,
	total_sale float

   )
   
-- Show Table
select * from retail_sales
limit 5
-- Count total Number of rows
select count(*) from retail_sales

-- total Number of distinct category present in category
select distinct category from retail_sales

-- finding null values

-- Data Cleaning --
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL 
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


-- Delete rows if null values present in a rows
Delete from retail_sales
WHERE transactions_id IS NULL 
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

-- How many transaction we have
select count(transactions_id) from retail_sales

-- how many distinct customers we have

select count(distinct customer_id) from retail_sales

SELECT COUNT(category) 
FROM retail_sales
WHERE category = 'Clothing';


-- My Analysis & Findings
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

select * from retail_sales
where sale_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 
-- more than 4 in the month of Nov-2022.

select * from retail_sales
where category = 'Clothing' and quantiy >= 4 and EXTRACT(MONTH FROM sale_date) = 11

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

select category,
sum(total_sale) as total_sales,
count(*) as total_order
from retail_sales
group by category


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2)
from retail_sales
where category = 'Beauty'


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale>=1000


-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as transaction from retail_sales
group by category,gender
order by 1

-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
select 
	year,
	month,
	avg_sales
from
(
select 
extract(Year from sale_date) as Year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over(partition by extract(year from sale_date)order by avg(total_sale) desc) as rank
from retail_sales
group by month, Year
) as t1
where rank = 1


-- order by 1,3 desc



-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.


select customer_id,sum(total_sale) as highest_sales from retail_sales
group by customer_id
order by highest_sales desc
limit 5

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as unique_customer from retail_sales
group by category


-- Q10. Write a SQL query to create each shift and number of orders (Example: Morning ≤ 12, Afternoon Between 12 & 17, 
-- Evening > 17).

select count(transactions_id),
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN  'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AfterNoon'
		ELSE 'Evening'
	END AS shift
From retail_sales
group by shift


-- End of Project

-- Best way (2nd Method)
with hourly_sales
as(
select *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
from retail_sales
)
select shift,count(transactions_id)
from hourly_sales
group by shift