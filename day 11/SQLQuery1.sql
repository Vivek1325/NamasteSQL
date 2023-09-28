select * from Orders

--aggregation fucntion with window functions
select *,
AVG(salary) over(partition by dept_id) as avg_sal,
MAX(salary) over(partition by dept_id) as max_sal
from employee;

--earlier we had to do this using a subquery or a cte
select e.*, s.avg_sal from employee as e 
inner join (select dept_id, avg(salary) as avg_sal from employee group by dept_id) as s
on e.dept_id = s.dept_id

-- we can also use order by with aggregation with window functions
select *, 
SUM(salary) over(partition by dept_id order by emp_age) as sum_sal,
SUM(salary) over(partition by dept_id) as dep_running_sal
from employee;
-- we can see that we have a running sum with respect to the salary and emp_age
--we can also get entire table running sum
select*,
sum(salary) over(order by emp_age asc) as running_sal
from employee

-- if we use func like min/max it will give running min/max
SELECT *, 
MAX(salary) OVER(ORDER BY salary DESC)
FROM employee
-- we first sort the whole table(the window) then take the running max in below case it will be max all the way till the bootom because due to sorting it was in the first row
SELECT *, 
MAX(salary) OVER(ORDER BY salary DESC)
FROM employee
-- in the below query we can see that the sum is somewhat fked up the second column should have value 27000 but it is 39000
SELECT *, 
SUM(salary) OVER(ORDER BY salary DESC)
FROM employee
-- it is happening because there are duplicates in the table and sql server adds them and considers them as one hence this issue
-- to tackle this we can give another column in over clause so that the combination of the columns is unique
SELECT *, 
SUM(salary) OVER(ORDER BY salary, emp_id )
FROM employee
-- issue fixed as the combo of the above columns is unique

-- now if you want rolling aggregate(not running) then we can use another clause
select *,
sum(salary) over(order by emp_id rows between 2 preceding and current row) as rolling_sum_2pre
from employee
--we got the rolling sum for previous two columns
-- we can also do the same for upcoming columns/ following columns
select *,
sum(salary) over(order by emp_id rows between 1 preceding and 1 following ) as rolling_sum_2pre
from employee
-- the above query will get you the sum of one column before the current row and one after
-- the way this window -> between 1 preceding and 1 following  is defined is important it should be existing not like between 1 following and 1 preceding

select *,
sum(salary) over(order by emp_id rows between current row and 2 following) as rolling_sum_2pre
from employee

-- we have another keyword that is unbounded
select *, 
--sum(salary) over(order by emp_id rows between unbounded preceding and current row) as rolling_sal,
--sum(salary) over(order by emp_id ) as actual_rolling_sal,
sum(salary) over( order by emp_id asc rows between current row and unbounded following) as forward_rolling_sal
from employee
-- the above query will just give you the rolling sum from previous values
-- we can also do unbounded following to get forward rolling salary
