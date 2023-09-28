--sub query
select * from Orders
--without using subquery when we try to average we count same order_id multiple times
select AVG(sales) as avg_sales from Orders
-- sub queries are used so that we can have temp tables to derive queries on top of

select AVG(order_sales) as avg_sales
from (select order_id, SUM(sales) as order_sales from Orders
group by order_id) as orders_agg

--find order_id where the sales in more than avg_sales
-- there is not limit to make sub queries you can make as many as you want 
-- also you can use subquery anywhere such as in where and having clause 

select order_id from Orders
group by order_id
having SUM(sales) > (select AVG(order_sales) as avg_sales
from (select order_id, SUM(sales) as order_sales from Orders
group by order_id) as orders_agg)

-- the above subquery calculates the avg sales and then it is compared to every sum(sales)

select * from employee
select * from dept
update employee set dept_id = 700 where emp_name = 'Rakesh'
-- find employees who's dept_id is not in dept table
select emp_id, emp_name from employee
where dept_id not in(select dep_id from dept) 

-- if we have a sub query in select statement it will get executed first then the other things will work.

-- sub queries in joins
-- find the order_ids which have the sales greater than avg(sales)
select a.*, b.* from
(select order_id, sum(sales) as sum_sales from Orders
group by order_id) as a
inner join
(select AVG(order_sales) as avg_order_value from
(select order_id, sum(sales) as order_sales from Orders
group by order_id) as orders_agg) as b
on 1 = 1  
where sum_sales > avg_order_value

--write a query that gives all the data from employees table along with one extra column of avg dept_salary
select e.*, e_agg.avg_dept_sal from employee as e
left join
(select dept_id, AVG(salary) as avg_dept_sal from employee
group by dept_id) as e_agg
on e.dept_id = e_agg.dept_id


--now the earlier icc world cup quesiton
select * from icc_world_cup;
--my solution
select team_name, COUNT(1) as matches_played, SUM(case when winner_flag = 1 then 1 else 0 end) as matches_won, SUM(case when winner_flag = 0 then 1 else 0 end) as matches_lost from
(select team_1 as team_name, case when winner = team_1 then 1 else 0 end as winner_flag
from icc_world_cup
union all
select team_2 as team_name, case when winner = team_2 then 1 else 0 end as winner_flag
from icc_world_cup) as icc_agg
group by team_name

--sir solution'
select team_name, COUNT(1) as matches_played, SUM(winner_flag) as matches_won, COUNT(1) - SUM(winner_flag) as matches_lost from
(select team_1 as team_name, case when winner = team_1 then 1 else 0 end as winner_flag
from icc_world_cup
union all
select team_2 as team_name, case when winner = team_2 then 1 else 0 end as winner_flag
from icc_world_cup) as icc_agg
group by team_name;

--cte common table expression -> it is very similiar to sub query
with cte as 
(
select team_1 as team_name, case when winner = team_1 then 1 else 0 end as winner_flag
from icc_world_cup
union all
select team_2 as team_name, case when winner = team_2 then 1 else 0 end as winner_flag
from icc_world_cup
)
select team_name, COUNT(1) as matches_played, SUM(winner_flag) as matches_won, COUNT(1) - SUM(winner_flag) as matches_lost from cte
group by team_name;

--write a query that gives all the data from employees table along with one extra column of avg dept_salary using cte
with cte as
(
select e.*, e_agg.avg_dept_salary from employee e
left join
(select dept_id, AVG(salary) as avg_dept_salary from employee
group by dept_id) as e_agg
on e.dept_id = e_agg.dept_id
)
select * from cte;

with cte as 
(
select dept_id, AVG(salary) as avg_dept_salary from employee
group by dept_id
)
select e.*, cte.avg_dept_salary from cte
inner join employee as e
on e.dept_id = cte.dept_id
-- one advantage of cte is that they are easier to read hence better readibility
--another is that we can refer to the same cte multiple times and it is also calculated once only hence improves performance sometimes also
--also you can use one cte in another cte that follows it



--questions

--1
--write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.
select * from Orders;
with cte as 
(
select customer_id, COUNT(DISTINCT (order_id)) as order_count from Orders
group by customer_id
)
select customer_id from cte 
where order_count > (select avg(order_count) from cte);

--2
--write a query to find employees whose salary is more than average salary of employees in their department
select * from employee;
-- my answer
with cte as
(
select dept_id, AVG(salary) as avg_sal from employee
group by dept_id
)
select e.emp_id from employee as e
inner join cte 
on e.dept_id = cte.dept_id
where cte.avg_sal < e.salary;
-- sir's answer
select e.* from employee e
inner join (select dept_id,avg(salary) as avg_sal from employee group by dept_id)  d
on e.dept_id=d.dept_id
where salary > avg_sal

--3 
--write a query to find employees whose age is more than average age of all the employees.
select * from employee
where emp_age > (select avg(emp_age) from employee);

--4
--write a query to print emp name, salary and dep id of highest salaried employee in each department
with cte as 
(
select dept_id, MAX(salary) as max_sal from employee
group by dept_id
)
select e.* from employee as e
inner join cte 
on e.dept_id = cte.dept_id
where e.salary = cte.max_sal
order by e.dept_id
-- converting it to a sub query instead of a cte
select * from employee e
inner join (select dept_id, max(salary) as max_sal from employee group by dept_id) as m
on e.dept_id = m.dept_id
where e.salary = max_sal

--5
--write a query to print emp name, salary and dep id of highest salaried overall
select * from employee e
where salary = (select max(salary) from employee) 

--6 IMPORTANT QUESTION
--write a query to print product id and total sales of highest selling products (by no of units sold) in each category
select * from Orders;

with cte1 as
(
select category, product_id, sum(quantity) as total_quantity, sum(sales) as total_sales from Orders
group by category, product_id
), cte2 as 
(
select category, max(total_quantity) as max_quantity from cte1
group by category
)
select c1.category, c1.product_id, c1.total_sales, c1.total_quantity from cte1 as c1
inner join cte2 as c2 
on c1.category = c2.category
where c1.total_quantity = c2.max_quantity;
