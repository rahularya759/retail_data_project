-- SQL Retail Sales Analysis 
create database sql_project;


-- Create Table
create table retail_sales(
     transactions_id int primary key,	
	 sale_date	date,
	 sale_time	time,
	 customer_id int,	
	 gender	text,
	 age int,	
	 category text,	
	 quantity int,	
	 price_per_unit float,	
	 cogs float,	
	 total_sale float
);



select * from retail_sales;

select count(*) from retail_sales;

-- checking nulls
select 
   sum(case when transactions_id is null then 1 else 0 end) as null_transactions_id,
   sum(case when sale_date is null then 1 else 0 end) as null_sale_date,
   sum(case when sale_time is null then 1 else 0 end) as null_sale_time,
   sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
   sum(case when gender is null then 1 else 0 end) as null_gender,
   sum(case when age is null then 1 else 0 end) as null_age,
   sum(case when category is null then 1 else 0 end) as null_category,
   sum(case when quantity is null then 1 else 0 end) as null_quantity,
   sum(case when price_per_unit is null then 1 else 0 end) as null_price_per_unit,
   sum(case when cogs is null then 1 else 0 end) as null_cogs,
   sum(case when total_sale is null then 1 else 0 end) as null_total_sale
from retail_sales;   

--replace nulls

update retail_sales
set gender=coalesce(gender,'unknown') ,
    age = coalesce(age,0),
    quantity = coalesce(quantity,0),
	price_per_unit = coalesce(price_per_unit,0),
	cogs = coalesce(cogs,0),
	total_sale = coalesce(total_sale,0);
------------------------------------------------------------------------------------------------------------------------

--Data Analysis and Business key Problems and Answers
--My Analysis and findings
--1.Write a SQl query to retrive all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date='2022-11-05';
	
--2.Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than 3
--in the month of Nov-2022
select transactions_id,category,sale_date,quantity
from retail_sales
where category='Clothing' 
and quantity > 3
and to_char(sale_date,'YYYY-MM')='2022-11';

--3.write a SQL query to calculate the total sales (total_sales) for each category.
select category,sum(total_sale) as total_sales
from retail_sales
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) as avg_age
from retail_sales
where category='Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select  *
from retail_sales
where total_sale>1000

--6.Write a SQL query to find the total number of (transactions_id) made by each gender in each category.
select gender,category,count(*) as transactions 
from retail_sales
group by gender,category;


--7.Write a SQL query to calculate the average sale for each month.Find out best selling month in each year. 
select * from(
select 
     extract(year from sale_date ) as year,
     extract(month from sale_date) as month,
	 avg(total_sale) as avg_sales,
	 rank() over(partition by extract(year from sale_date ) order by avg(total_sale) desc ) as rank
from retail_sales
group by month,year) t
where rank=1;


--Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id ,sum(total_sale) as total_sales
from retail_Sales
group by customer_id
order by total_sales desc
limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
       count(distinct customer_id) as unique_customers
from retail_sales
group by category;


--10.Write a SQL qeury to create each shift and number of orders(Example Morning <=12,Afternoon Between 12&17,Evening >17)

select shift,count(*) as total_orders from
(
select *,
 case when extract(hour from sale_time)<=12 then 'Morning' 
      when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'evening'
end as shift
from retail_sales
)
group by shift;


 




