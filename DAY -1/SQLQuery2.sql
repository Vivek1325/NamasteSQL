select top(5) * from orders;

create table hr.test
(
id integer,
name varchar(10)
);
drop table hr.test;

insert into hr.test
values(1, 'Ankit');

SELECT * FROM hr.test;

create table sales.test
(
id integer,
name varchar(10)
);
select * from sales.test;

insert into sales.test
select * from hr.test;