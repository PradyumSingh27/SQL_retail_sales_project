-- SQL Retail Sales Analysis
create database sql_project_p1;

-- create table
drop table if exists retail_sales;
create table retail_sales
            (
		transactions_id INT primary key,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
        );

-- 
select * from retail_sales
limit 10 ;
        
select count(*) from retail_sales;

-- Data cleaning
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date isnull;

select * from retail_sales
where sale_time isnull;

select * from retail_sales
where customer_id is null;

select * from retail_sales
where gender is null 

select * from retail_sales
where age is null;

select * from retail_sales
where category is null;

select * from retail_sales
where quantiy is null;

select * from retail_sales
where price_per_unit is null;

select * from retail_sales
where cogs isnull;

select * from retail_sales 
where total_sale is null;

delete from retail_sales
where 
	transactions_id isnull
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or 
	gender is null
	or
	age is null
	or
	category is null
	or
	price_per_unit is null
	or
	cogs is null 
	or
	total_sale is null;

-- Data Exploration

--how many sales we have?
select count(*) as total_sales from retail_sales

--how many unique customers we have?
select count(distinct customer_id) as total_uniuque_customers from retail_sales; 

--how many type of category we have?
select distinct category as type_of_category from retail_sales;

--Data analysis & Business Key Problems & Answers

--Q.1. Write a SQl query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date='2022-11-05';

--Q.2.Write a SQl query to retrive  all transaction where the category is 'clothing' and the quantity sold is more than 2 in the month of 'nov-2022'.

select * from retail_sales
where
	category='Clothing'
	and
	to_char(sale_date,'YYYY-MM')='2022-11'
	and
	quantiy >=2;


--Q.3.Write a SQL query to calculate the total sales (total_sales) for each category.

select category,sum(total_sale) as net_sales,count(*) as total_order from retail_sales
group by 1;

--Q.4.Write a SQL query to find the average age of customer who purchased item from the 'beauty' category.

select round(avg(age),2) as avg_age from retail_sales
where category ='Beauty';

--Q.5.Write a SQL query to find all transactions where the total_sale is greater than '1000'.
select * from retail_sales
where total_sale > 1000;

--Q.6.Write a SQL query to find the total number of transactions ( transactions_id ) made by each gender in each category.
select category,gender, count(*) as total_transactions from retail_sales
group by category,gender 
order by 1;

--Q.7.Write a SQL query to calculate the average sale for each month. find out the best selling month in each year.

select * from
(
  select
	  EXTRACT(year from sale_date) as year, 
	  EXTRACT(month from sale_date) as month,
	  round(avg(total_sale)) as avg_sales,
	  Rank() over(partition by EXTRACT(year from sale_date) order by  avg(total_sale) desc  ) as Rank
  from retail_sales
  group by 1 ,2
 ) as t1 
 where Rank = 1;
	 
--Q.8. Write a SQL query to find the top 5 customers based on the highest total_sale.

select customer_id as user_id ,sum(total_sale) as net_sales from retail_sales
group by 1 order by 2 desc
limit 5;

--Q.9. Write a SQL query to find the number of unique customers who purchased item from each category.

select category, count(distinct customer_id) as total_user from retail_sales
group by 1

--Q.10. Write a SQL query to create each shift and number of order 'Example morning <=12 , Afternoon between 12 - 17 , Evening > 17 '.

WITH hourly_sale
AS
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
	from retail_sales
)
select shift,count(*) from hourly_sale
group by 1

--END OF PROJECT--