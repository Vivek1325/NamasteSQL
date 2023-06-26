select * from orders
select distinct(ship_mode)from orders;

select distinct Ship_Mode from orders where Ship_Mode in ('first class', 'same day');

select order_date from Orders
where order_date between '2020-12-08' and '2020-12-12';

-- IN , NOT IN, BETWEEN A and B

select cast(order_date as date) as order_date_new, *
from Orders
where cast(order_date as date) = '2020-11-08'
-- we have made the db case sensitive now; 
select getdate() as current_date_time;
-- % means 0 or any number of characters
select order_id, order_date, customer_name, upper(customer_name) as name_upper from Orders
where upper(customer_name) like 'A%A';

-- Next wildcard character is _ where _ means one character
SELECT order_id, order_date, UPPER(customer_name) as name_upper from Orders
where UPPER(customer_name) like '__l%';
--escaper character is used to treat a wildcard character as a literal
SELECT customer_name, upper(customer_name) as name_upper
FROM Orders
WHERE UPPER(customer_name) LIKE '%\%%' ESCAPE '\';

-- 
SELECT customer_name, upper(customer_name) as name_upper
FROM Orders
WHERE UPPER(customer_name) LIKE 'C[albo]%'; -- this means second character 
-- can be anything from a or l or b or o;
-- to make the second character anyhting but not from a or l or b or o we can use the ^ symbol
SELECT customer_name, upper(customer_name) as name_upper
FROM Orders
WHERE UPPER(customer_name) LIKE 'C[^albo]%';

SELECT customer_name, upper(customer_name) as name_upper
FROM Orders
WHERE UPPER(customer_name) LIKE 'C[a-o]%'
order by customer_name;
-- Q1
SELECT customer_name, order_date from Orders
where customer_name like '_a_d%'

--Q2
Select cast(order_date as date)   from Orders
where cast(order_date as date) like '2020-12-%'; 

--Q3
SELECT * FROM Orders
WHERE ship_mode NOT IN ('Standard Class', 'First Class') AND cast(ship_date as date) > '2020-11-30';

--Q4
SELECT * FROM Orders
WHERE customer_name LIKE '[^A]%[^n]';

--Q7
SELECT * FROM Orders
WHERE region = 'South' AND discount > 0;

--Q8
SELECT TOP(5) * FROM Orders
WHERE category = 'Furniture'
ORDER BY sales DESC;

--Q9
SELECT * FROM Orders
WHERE category IN ('Technology', 'Furniture') AND cast (order_date as date) LIKE '2020-%' ;

--Q10
SELECT * FROM Orders
WHERE cast (order_date as date) LIKE '2020%' AND cast (ship_date as date) LIKE '2021%';