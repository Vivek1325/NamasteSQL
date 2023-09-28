-- window analytical functions

-- row_number() -> in this even if two columns have the same value they will get different row number
select * from employee
-- it gives us a number based on the partition and over condition
-- here we do not have any partition hence we get rn on whole table
select *, ROW_NUMBER() over(order by salary desc) as rn
from employee
--now we will give partitions
select * , ROW_NUMBER() over(partition by dept_id order by salary desc) as rn 
from employee
-- here we have not used group by or any other function but created windows based on dept_id
-- we can not remove the order by part of the syntax otherwise it won't work
-- query the details of employees that have the max sal in their dept
select * from 
(select *, ROW_NUMBER() over(partition by dept_id order by salary desc) as rn from employee) a
where rn = 1

--rank() function -> in this if two rows have the same value they will get same rank
select * , ROW_NUMBER() over(partition by dept_id order by salary desc) as rn,
RANK() over(partition by dept_id order by salary desc) as rnk
from employee
-- we can see the above in action as follows
select * , ROW_NUMBER() over(order by salary desc) as rn,
RANK() over(order by salary desc) as rnk
from employee
-- if two people have the same salary , lets say 2nd and 3rd then the rank will be 1 2 2 but the 4th person will have the rank 4 because he had 3 people before him which means 1 2 2 4
--DENSE_RANK()
-- dense rank is same as rank but it will just be 1 2 2 3 and not 4 like rank

select * , ROW_NUMBER() over(order by salary desc) as rn,
RANK() over(order by salary desc) as rnk,
Dense_RANK() over(order by salary desc) as d_rnk
from employee

--WAQ to print top 5 selling products from each category
select * from Orders;

with cte1 as
(
select category, product_id, sum(sales) as categ_sales from Orders
group by category, product_id
), cte2 as
(
select *,
rank() over(partition by category order by categ_sales desc) as rn
from cte1 
)select * from cte2
where rn <= 5;

with cte1  as
(
select category, product_id, 
RANK() over(partition by category order by sum(sales) desc) as rn
from Orders
group by category, product_id
)
select * from cte1
where rn <= 5

-- LEAD(column_name, x, default_value) function where x is how far you want to look
-- without the third parameter
select * ,
LEAD(emp_id, 2) over(order by salary desc) as lead_emp
from employee
--with third parameter
select * ,
LEAD(salary, 2, -1) over(order by salary desc) as lead_sal
from employee
-- you can also put that same column values as shown below
select * ,
LEAD(salary, 2, salary) over(order by salary desc) as lead_sal
from employee

select * ,
LEAD(salary, 1) over(partition by dept_id order by salary desc) as lead_sal
from employee

--similiar to lead we have lag function
select * ,
lag(salary, 1) over(partition by dept_id order by salary desc) as lag_sal,
LEAD(salary, 1) over(partition by dept_id order by salary desc) as lead_sal
from employee

-- you can get the same result from lead and lag depending on how you have order by the data in over() clause

--first_value(column_name), last_value(column_name) will give you the first and last value of the column you give as parameter from the window

--1
-- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
-- In case a department has less than 3 employees then print the details of highest salaried employee in that department.
select * from employee;

with cte1 as
(
select dept_id, salary, emp_age from employee
group by dept_id
),
cte2 as
(
select dept_id, salary, emp_age ,
rank() over(partition by dept_id order by salary desc, emp_age asc) as rnk
from cte1
)
select dept_id, salary, emp_age from cte2 ;

--2
--write a query to find top 3 and bottom 3 products by sales in each region.
with sales_cte as
(
select region, product_id, sum(sales) as total_sales
from Orders
group by region, product_id
), d_rank_cte as
(
select *,
DENSE_RANK() over(partition by region order by total_sales asc) as a_rank,
DENSE_RANK() over(partition by region order by total_sales desc) as d_rank
from sales_cte
)
select region, product_id, total_sales , 
CASE WHEN d_rank<=3 then 'TOP' else 'BOTTOM' end AS TOP_BOTTOM
from d_rank_cte
where a_rank<=3 or d_rank <= 3

--3
-- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020. --hard question
select * from Orders;

with sbc_sales as (
select sub_category,format(order_date,'yyyyMM') as year_month, sum(sales) as sales
from Orders
group by sub_category,format(order_date,'yyyyMM')
)
, prev_month_sales as (select *,lag(sales) over(partition by sub_category order by year_month) as prev_sales
from sbc_sales)
select  top 1 * , (sales-prev_sales)/prev_sales as mom_growth
from prev_month_sales
where year_month='202001'
order by mom_growth desc

--4
--write a query to print top 3 products in each category by year over year sales growth in year 2020.
with order_agg as
(
select category, sum(sales) as total_sales, product_id, DATEPART(year, order_date) as yr from Orders
group by category, product_id, DATEPART(YEAR, order_date)
),
prev_yr as
(
select *, lag(total_sales,1 ) over(partition by category order by yr) as prev_year_sales from order_agg
),
rank_cte as
(
select *, RANK() over(partition by category order by (total_sales-prev_year_sales)/prev_year_sales desc) as rn, (total_sales-prev_year_sales)/prev_year_sales as yoy_growth from prev_yr
where yr = 2020
)
select * from rank_cte 
where rn <= 3


--5
--create table call_start_logs
--(
--phone_number varchar(10),
--start_time datetime
--);
--insert into call_start_logs values
--('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
--,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
--create table call_end_logs
--(
--phone_number varchar(10),
--end_time datetime
--);
--insert into call_end_logs values
--('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
--,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
--;

select * from call_start_logs
select * from call_end_logs

select s.phone_number, s.rn, e.rn, s.start_time, e.end_time	, datediff(MINUTE, start_time, end_time) as duration 
from 
(select*, ROW_NUMBER() over(partition by phone_number order by start_time) as rn from call_start_logs) as s
inner join (select *, ROW_NUMBER() over(partition by phone_number order by end_time) as rn from call_end_logs) as e
on s.phone_number = e.phone_number and s.rn = e.rn



