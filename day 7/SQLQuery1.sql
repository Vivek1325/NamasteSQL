--string functions
--len
select order_id, customer_name, len(customer_name) as len_name, len(' Craig Carreira ')
from Orders
-- Note that preceding or in between spaces are counted but not trailing spaces

--left
select order_id, customer_name, left(customer_name, 4)
from Orders
-- basically a slicer customer_name[0:4]

--right
select order_id, customer_name, right(customer_name, 4)
from Orders

--substring
select order_id, customer_name, SUBSTRING(customer_name, 4, 5) as substr
from Orders
-- it will take values from 4 and then get 5 characters, indexing is from 1 not 0

SELECT SUBSTRING('vivek', 2, 3);

--charindex
select order_id, customer_name, charindex(' ', customer_name) as index_of_space
from Orders
--it searches the string for the index of a input, indexing is still 1
--if string does not contain the character then it will give 0
--if it is repeating then it will give the index of first occurence
--if you give the third arguement then it will start searching from that index

--concat
select order_id, customer_name, concat(order_id, ' ', customer_name),order_id+' '+customer_name
from Orders

--getting first name from customer_name
select SUBSTRING(customer_name, 1, CHARINDEX(' ', customer_name)) as first_name
from Orders

--replace
select replace(order_id, 'CA','PB')
from Orders

--translate - one to one mapping , it converts A -> T and G -> P and C ->L
select translate(customer_name, 'AGC','TPL')
from Orders

--reverse
select reverse(customer_name) from Orders;

--trim -> trims leading and trailing spaces.
select trim('  VIVEK  ');


UPDATE Orders
SET city = NULL
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909');

--null handling functions
select * from Orders
where city is NULL
--isnull fucntion
select order_id, isnull(city, 'unknown') as new_city from Orders
where city is null
order by city

--coalesce function
select order_id, city, coalesce(city, state, region, 'unknown') from Orders
order by city

--set queries

--union all, union
create table orders_west(
order_id int,
region varchar(10),
sales int
);
create table orders_east(
order_id int,
region varchar(10),
sales int
);
insert into orders_west values(1,'west', 100);
insert into orders_west values(2,'west', 200);

insert into orders_east values(1,'east', 100);
insert into orders_east values(2,'east', 200);
-- it is important to note that both the selects should have same no. of columns and also
-- compatible data

-- union all will not remove duplicates in case there are any but union will give unique cols.
select * from orders_east
union all
select * from orders_west

-- even if there are duplicates in the same table they will also be removed
--internally you first do is union all then remove duplicates
select * from orders_east
union 
select * from orders_west

--select distinct(*) from Orders -- this does not work
-- but distinct works on entire row so you can distinct(primary_key) to get uunique cols.

-- to get common records we can use the intersect set function
select * from orders_east
intersect
select * from orders_west
-- it will find the intersect and remove the duplicates if any

--minus / except - remove duplicates 
select * from orders_east
except
select * from orders_west
-- only union all gives duplicates
-- they can also be applied on the same table
-- if you include null as one of the columns then it will come in all set operations as
--null cannot be compared to null


--1
/*
create table icc_world_cup
(
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');
*/
select* from icc_world_cup;
drop table icc_world_cup;
/*
--1 -- merse nhi hua dekhte h last me
with all_teams as 
(select team_1 as team, case when team_1=winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2 as team, case when team_2=winner then 1 else 0 end as win_flag from icc_world_cup)
select team,count(1) as total_matches_played , sum(win_flag) as matches_won,count(1)-sum(win_flag) as matches_lost
from all_teams
group by team

SELECT 
    team_name,
    COUNT(*) AS no_of_matches_played,
    SUM(CASE WHEN is_win = 1 THEN 1 ELSE 0 END) AS no_of_wins,
    SUM(CASE WHEN is_win = 0 THEN 1 ELSE 0 END) AS no_of_losses
FROM (
    SELECT team_1 AS team_name, 1 AS is_win FROM icc_world_cup
    UNION ALL
    SELECT team_2 AS team_name, 0 AS is_win FROM icc_world_cup
) AS matches
GROUP BY team_name;

select team_name, count(1) as total_matches_played,
	SUM(case when is_win = 1 then 1 else 0 end) as no_of_wins),
	sum(case when is_win = 0 then 1 else 0 end) as no_of_losses)
	FROM(
	select team_1 as team_name
	*/

--2
select * from Orders
select customer_name, Trim(LEFT(customer_name, CHARINDEX(' ', customer_name))) as first_name, RIGHT(customer_name, LEN(customer_name) - CHARINDEX(' ', customer_name)) as last_name from Orders

--3
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers
-- nhi hua last me dkehte h 

--4
select customer_name, LEN(customer_name) - LEN(REPLACE(LOWER(customer_name), 'n', '')) as no_of_n from Orders

--5
select * from Orders
-- My initital answer- WRong
select ship_mode, category, sub_category, SUM(case when region = 'West' then sales end) as total_sales_west, SUM(case when region = 'East' then sales end) as total_sales_east  
from Orders
group by ship_mode, category, sub_category
order by category
-- Correct answer
select 
'category' as hierarchy_type, category as hierarchy_name ,
SUM(case when region = 'West' then sales end) as total_sales_west,
SUM(case when region = 'East' then sales end) as total_sales_east
from Orders
group by category
union all
select 
'sub_category' as hierarchy_type, sub_category as hierarchy_name ,
SUM(case when region = 'West' then sales end) as total_sales_west,
SUM(case when region = 'East' then sales end) as total_sales_east
from Orders
group by sub_category
union all
select 
'ship_mode' as hierarchy_type, ship_mode as hierarchy_name ,
SUM(case when region = 'West' then sales end) as total_sales_west,
SUM(case when region = 'East' then sales end) as total_sales_east
from Orders
group by ship_mode

--7
select * from Orders
select (LEFT(order_id, 2)) as country, COUNT(DISTINCT(order_id)) as number_of_orders from Orders
group by (LEFT(order_id, 2)) 

--1 
--Parked question
select * from icc_world_cup

select team_1 as team_name, case when winner = team_1 then 1 else 0 end as win_flag 
from icc_world_cup
union all
select team_2, case when winner = team_2 then 1 else 0 end as win_flag 
from icc_world_cup

--3
select * from drivers
select * from drivers
select id, count(1) as no_of_rides 
from drivers
group by id

select d1.id, count(1) as total_rides, count(d2.end_time) as profit_rides from drivers as d1
left JOIN drivers as d2 
ON d1.end_time = d2.start_time
group by d1.id
