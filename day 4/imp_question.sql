CREATE TABLE temp(
	sub_category varchar(20),
	order_date date,
	sales int
   
);

insert into temp values
	('chairs', '2019-01-01', 100),
	('chairs', '2019-10-10', 200),
	('bookcases', '2019-01-01', 300),
	('bookcases', '2020-10-10', 400)
;
SELECT sub_category, sum(sales) as total_sales
from temp
group by sub_category
having max(order_date) > '2020-01-01'
order by total_sales  desc;
