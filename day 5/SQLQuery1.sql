-- JOINS

select * from returns$

exec sp_rename 'returns$', 'returns'

select * from returns; 
-- the returns table is fucked and we need to create
-- a new table to proceed


-- first rename returns to return_backup

exec sp_rename 'returns', 'returns_backup'

SELECT * from returns_backup

--now create a new table by the name of returns
CREATE table returns(order_id varchar(20), return_reason varchar(20));

-- now copy the data from backup to the new one
insert INTO returns s
SELECT * from returns_backup



--INNER JOIN - default join hota h
SELECT o.order_id, o.order_date, r.return_reason
from Orders o
INNER JOIN returns r on o.order_id = r.order_id


-- LEFT JOIN 
SELECT o.order_id, o.order_date, r.return_reason
from Orders o
LEFT JOIN returns r on o.order_id = r.order_id
where r.order_id IS NULL

SELECT r.return_reason, SUM(sales) as total_sales
from Orders o
INNER JOIN returns r on o.order_id = r.order_id
group by r.return_reason;

--MAKING NEW TABLES AND INSERTING VALUES
create table employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);
select * from employee;

create table dept(
    dep_id int,
    dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');
select * from dept;
SELECT * from employee;

--CROSS JOIN
SELECT *
FROM employee, dept;

SELECT * 
FROM employee
INNER JOIN dept ON 1 = 1 

SELECT *
FROM employee e
INNER JOIN dept d on e.dept_id = d.dep_id
order by e.emp_name;

SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
LEFT JOIN dept d on e.dept_id = d.dep_id
order by e.emp_name;

--RIGHT JOIN can be achieved with left join just by swapping
--the table names in the join statement
--FOR E.G.  a RIGHT Join b
-- OR       b LEFT JOIN a

SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM dept d
RIGHT JOIN employee e on e.dept_id = d.dep_id
order by e.emp_name;


--FULL OUTER JOIN
SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
FULL OUTER JOIN dept d on e.dept_id = d.dep_id
order by e.emp_name;


--ASSIGNMENTS

--1
SELECT * from returns;
SELECT * FROM Orders;

SELECT o.region, COUNT(distinct o.order_id) AS count  FROM
Orders as o 
INNER JOIN returns AS r ON o.order_id = r.order_id
group by o.region


--2 
SELECT o.category, SUM(Sales) AS total_sales
FROM Orders as o 
LEFT JOIN returns AS r ON o.order_id = r.order_id
where r.order_id IS NULL
group by o.category;

3--
SELECT * from dept;
SELECT * FROM employee;
-- My answer
SELECT d.dep_name, SUM(e.salary)/COUNT(1) AS average_sal
FROM dept AS d
LEFT JOIN employee AS e ON d.dep_id = e.dept_id
GROUP BY d.dep_name;

--SIR Answer
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name

--4
 -- my ans
SELECT d.dep_name
FROM dept as d
INNER JOIN employee as e ON d.dep_id = e.dept_id
GROUP BY d.dep_name
HAVING COUNT(1) = COUNT(DISTINCT(e.salary))
--sir ans
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)

--5 
SELECT o.sub_category
FROM Orders as o
INNER JOIN returns as r ON r.order_id = o.order_id
GROUP BY sub_category
HAVING COUNT(DISTINCT(r.return_reason)) = 3;

--6
SELECT o.city FROM 
Orders as o
LEFT JOIN returns as r ON o.order_id = r.order_id
GROUP BY o.city
HAVING COUNT(r.order_id) = 0;

--7
SELECT TOP 3 o.sub_category, SUM(o.sales) as return_sales
from Orders as o
INNER JOIN returns as r ON r.order_id = o.order_id
where o.region = 'East'
group by o.sub_category
ORDER by SUM(o.sales) desc


--8 
SELECT d.dep_name
from dept as d
LEFT JOIN employee e ON e.dept_id = d.dep_id
GROUP BY d.dep_id, d.dep_name
HAVING COUNT(e.emp_id) = 0


--9
SELECT e.emp_name, e.dept_id FROM employee as e
LEFT JOIN dept d ON d.dep_id = e.dept_id
where d.dep_id IS NULL

select * from employee;
insert into employee values(11, 'Ramesh', 300, 8000, 6, 52);






