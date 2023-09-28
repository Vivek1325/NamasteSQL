--Views 
create view south_region_vw as
select * from Orders
where region = 'South'

select * from south_region_vw
--views do not hold any data they are just there to make the query look clean
--when you query a view then the query inside the create view statement is run.
--one use case might be when you do not want to give data of one region to another region's manager i.e. data security or low level security
--also you can make big complex queries into views and share them with you team, etc. 
--if you also have a big query, you can just make a view and leave it instead of maintaining it in a notepad or sth


--referential iintegrity constraint
-- this just makes sure that the data in employee table for dept_id should be in 
-- dept master table i.e. 500 cannot be in employee table for an employee as dep_id as
-- there is not dep_id in dept that is equal to 500
select * from employee
select * from dept

create table emp
(
emp_id integer not null,
emp_name varchar(20),
dep_id int references dept(dep_id)
)
-- below adds a constraint of not null to dep_id
alter table dept alter column dep_id int not null
-- adds a primary key constraint to dep_id column with the name as primary_key
alter table dept add constraint primary_key primary key (dep_id)

insert into emp values(1, 'Vivek', 100);
select * from emp
--gives error in below
insert into emp values(2, 'Vivek2', 500);
--if you add the 500 in dept table then it won't give an error
insert into dept values(500, 'Marketing')
-- null values can be inserted into the columns that have referntial integrity constrants-IMP


--if you try to delete data point from the master table which is under referntial integrity
--constraint and the data point is referencing some data point in another table 
-- it will throw error saying it conflicted with the reference constraint, you cannot even
--update the data point in the master table if it damages the integrity of the db.

--concept of auto incrementing colums in tables
create table dept1
(
id int identity(1,1), -- here identity(1,1) means for(int i = 1; ; i++)
dept_id int, 
dept_name varchar(20)
)
insert into dept1 values(100, 'HR')
select * from dept1
insert into dept1 values(200, 'IT')
--you can see the value of id auto increments by 1
insert into dept1 values(3, 300, 'Analytics')
--the above would not work as you cannot give value to the id column in dept1 otherwise error

--IMP you can make a constraint on more than one foreign key but both of those should be
--primary keys of their table


CREATE TABLE posts (
    user_id INT,
    post_id INT,
    post_date DATETIME,
    post_content NVARCHAR(MAX)
);

INSERT INTO posts (user_id, post_id, post_date, post_content)
VALUES
    (151652, 599415, '2021-07-10 12:00:00', N'Need a hug'),
    (661093, 624356, '2021-07-29 13:00:00', N'Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that''s gonna fly by. I miss my girlfriend'),
    (004239, 784254, '2021-07-04 11:00:00', N'Happy 4th of July!'),
    (661093, 442560, '2021-07-08 14:00:00', N'Just going to cry myself to sleep after watching Marley and Me.'),
    (151652, 111766, '2021-07-12 19:00:00', N'I''m so done with covid - need travelling ASAP!');

select user_id, DATEDIFF(DAY, MIN(CAST(post_date as DATE)) , MAX(CAST(post_date as DATE))) as days_between from posts
where DATEPART(YEAR, post_date) = 2021
group by user_id
having COUNT(post_id) > 1