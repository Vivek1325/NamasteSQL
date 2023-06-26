\
-- filter null values using the is keyword || or "is not" keyword
select * from Orders
where city is not NULL;

-- AGGREGATION

--COUNT
SELECT COUNT(*) AS cnt, SUM(sales) AS total_sales,
MAX(profit) as max_profit, MIN(profit) as min_profit
FROM Orders;

select top 1 profit from Orders
order by profit desc;

--group by
SELECT region, COUNT(*) AS cnt, SUM(sales) AS total_sales,
MAX(profit) as max_profit, MIN(profit) as min_profit, AVG(profit) as avg_profit
FROM Orders
group by region;

SELECT DISTINCT(region) from Orders;
-- below is a common interview question and below will give an error
SELECT region, category, sum(sales) from Orders
group by region;


SELECT region, sum(sales) as total_sales from Orders
where profit>50
group by region
order by sum(sales) desc;

SELECT top(2) region, sum(sales) as total_sales from Orders
group by region
order by sum(sales) desc;

-- from ->where ->group by ->aggregate/select ->having ->order by ->


SELECT sub_category, sum(sales) as total_sales from Orders
where profit>50
group by sub_category
having sum(sales) > 100000
order by total_sales desc;


SELECT sub_category, sum(sales) as total_sales
from Orders
group by sub_category
having max(order_date) > '2021-01-01'
order by total_sales  desc;

--count function -> it does not count null values 
select count(DISTINCT region) as _Count from Orders;

-- *ANY AGGREGATE FUCNTION IGNORES THE NULL VALUES*


--Q1
UPDATE Orders
SET city = NULL
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909');

--Q2
SELECT * from Orders
where city IS NULL

--Q3
SELECT category, SUM(profit) AS total_profit, 
MAX(order_date) AS first_order, MIN(order_date) as latest_order
FROM Orders
GROUP BY category

SELECT DISTINCT(category ) from Orders

--Q4
SELECT sub_category FROM Orders
group by sub_category
having AVG(profit) > (MAX(profit) / 2);

--q5
	create table exams (student_id int, subject varchar(20), marks int);
	insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
	,(2,'Chemistry',80),(2,'Physics',90)
	,(3,'Chemistry',80),(3,'Maths',80)
	,(4,'Chemistry',71),(4,'Physics',54)
	,(5,'Chemistry',79);

-- first approach
SELECT student_id, COUNT(*)as total_records,
COUNT(distinct(marks)) as distinct_marks
from exams
where subject in ('Physics', 'Chemistry')
group by student_id
having count(*) = 2 AND COUNT(distinct(marks)) = 1;

-- second approach
select student_id, marks , count(*) as total_rows
from exams
where subject in ('Physics', 'Chemistry')
group by student_id, marks
having count(*) = 2
order by student_id;

--q6
SELECT category, COUNT(*) as counting from Orders
group by category;


--q7
SELECT top 5 sub_category, sum(quantity) as total_quantity from Orders
where region = 'West'
group by sub_category
order by sum(quantity) desc;

--q8
SELECT region, ship_mode, SUM(sales) AS total_sales FROM Orders
WHERE cast(order_date as date) LIKE '2020%'
GROUP BY region, ship_mode;

