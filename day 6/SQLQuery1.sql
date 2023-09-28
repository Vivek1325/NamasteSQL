select * from employee
select * from dept

--SELF JOIN
-- employee and their managers
select e1.emp_id, e1.emp_name, e2.emp_name as manager_name
from employee as e1
inner join employee as e2 
ON e1.manager_id = e2.emp_id;

--employees that have more salary than their managers

select e1.emp_id, e1.emp_name, e1.salary, e2.emp_name as manager_name, e2.salary from
employee as e1
inner join employee as e2 
ON e1.manager_id = e2.emp_id
where e1.salary > e2.salary

--average salary by dept

select dept_id, avg(salary) as avg_sal
from employee
group by dept_id

--basic functions - min, max, count

--String_aggregate fucntion , in some db s it is string_concat or list_agg
select dept_id, STRING_AGG(emp_name, ' | ') as employees
from employee
group by dept_id

-- to sort the aggregated list we have to use within group

select dept_id, STRING_AGG(emp_name, ' | ') within group (order by salary) as employees
from employee
group by dept_id

-- date functions

--datepart fucntion on w3schools
select order_id, order_date, datepart(year, order_date) as order_year,
datepart(month, order_date) as order_month,
datepart(day, order_date) as order_day,
datename(month, order_date) as month_name
from Orders
where datepart(year, order_date) = 2019 
and datepart(month, order_date) = 12
and datepart(day, order_date) = 1

--dateadd fucn
select order_id, order_date, 
dateadd(DAY, 5, order_date) as new_date
from Orders
-- we can use negative values to just go back
select order_id, order_date, 
dateadd(DAY, -5, order_date) as new_date
from Orders

--datediff func
select --order_id, order_date, ship_date, 
max(datediff(DAY, order_date, ship_date)) as no_of_days
from Orders

--case_when VVIMP
select order_id, profit,
case 
when profit < 0 then 'loss'
when profit < 100 then 'low profit'
when profit < 250 and profit >= 100 then 'medium profit'
when profit < 400 and profit >= 250 then 'high profit'
else 'very high profit'
end as profit_category
from Orders
-- case_when is executed top to bottom so we do not need the and conditions so make sure to 
--put it with that in mind.
-- case when can also be nested in an when and then you can get nested is else behaviour

--questions

alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate())

--1
select * from employee
select e1.emp_name, e2.emp_name as manager_name , datediff(DAY, e1.dob, e2.dob) as date_diff
from employee as e1
inner join employee as e2
ON e1.manager_id = e2.emp_id
where datepart(year, e1.dob) < datepart(year, e2.dob) 

--2  IMPORTANT
select * from Orders
select * from returns;
select o.sub_category from Orders as o
left join returns as r
ON o.order_id = r.order_id 
where DATEPART(MONTH, o.order_date) = 11 
group by o.sub_category
having count(r.order_id) = 0

--3
select order_id from Orders
group by order_id
having count(1) = 1

--4
select e2.emp_name as manager_name, STRING_AGG(e1.emp_name, ' , ') within group(order by e1.salary) as emp_list  from employee as e1
inner join employee as e2
on e1.manager_id = e2.emp_id
group by e2.emp_name

--5  IMPORTANT
select datepart(WEEKDAY, ship_date) from Orders

select order_date , ship_date, datediff(day, order_date, ship_date) - 2*DATEDIFF(WEEK, order_date, ship_date) as no_of_business_days from Orders

--6 IMPORTANT
select o.category as category, sum(o.sales) as total_sales , 
sum(case
	when r.order_id is not NULL then sales
	end) as returns_sales
from Orders as o
left join returns as r 
ON r.order_id = o.order_id
group by o.category

--7
select * from Orders
select category, sum(case when DATEPART(YEAR, order_date) = 2019 then sales end) as total_sales_2019, 
sum(case when DATEPART(YEAR, order_date) = 2020 then sales end) as total_sales_2020
from Orders
group by category

--8
select top 5 city, AVG(DATEDIFF(DAY, order_date, ship_date)) as avg_date from Orders
where region = 'West'
group by city
order by AVG(DATEDIFF(DAY, order_date, ship_date)) asc

--9  LENGTHY
select * from employee
select * from employee
select e1.emp_name as emp_name, e2.emp_name as manager_name, e3.emp_name as senior_manager from employee as e1
inner join employee as e2
ON e1.manager_id = e2.emp_id
inner join employee as e3
on e2.manager_id = e3.emp_id

--DONE