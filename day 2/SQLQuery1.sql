CREATE TABLE amazon_orders
(
order_id integer,
order_date date,
product_name varchar(50), 
total_price decimal(5, 2), 
payment_method varchar(20)
);
insert into amazon_orders values(1, '2023-10-01', 'Baby Milk', 30.5, 'UPI');
insert into amazon_orders values(2, '2023-10-02', 'Baby Powder', 130.5, 'Credit card');
-- HA BHAI YE KARLO
insert into amazon_orders values(3, '2023-10-01', 'Baby Soap', 30.5, 'UPI');
insert into amazon_orders values(4, '2023-10-02', 'Baby Diaper', 130.5, 'Credit card');
DELETE FROM amazon_orders;

SELECT TOP(2)* FROM amazon_orders;
SELECT TOP(2) order_date, product_name FROM amazon_orders;
-- ordering data
SELECT * FROM amazon_orders
ORDER BY order_date DESC, product_name ASC;

SELECT * FROM amazon_orders;
-- ALTER COLUMN  = change the datatype of the col.
ALTER TABLE amazon_orders alter column order_date datetime; --DDL command as we changing def.
-- time is in HH:MM:SS
insert into amazon_orders values(4, '2023-10-02 12:05:12', 'Baby Milk', 130.5, 'Credit card');

update amazon_orders
set order_id = 5, product_name = 'Baby Lotion'
WHERE order_date = '2023-10-02 12:05:12'
-- ADD  = add another Column at the end
ALTER TABLE amazon_orders add user_name varchar(20);
insert into amazon_orders values(4, '2023-10-02 12:05:12', null, 130.5, 'Credit card', 'Vivek');

Alter table amazon_orders add category varchar(20);
-- DROP COLUMN  = drop unecessary col.
ALTER TABLE amazon_orders drop column  category;





/*
integer 
date -> '2020-11-21'
varchar(50) -> string of 50 length at max
decimal(5, 2) -> it means three digit number and two digit
				 decimal part
*/