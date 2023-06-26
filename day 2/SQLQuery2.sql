drop table a_orders;
CREATE TABLE a_orders
(
order_id integer not null UNIQUE,  -- first constraint
order_date date,
product_name varchar(50), 
total_price decimal(5, 2),
-- check constraint checks if what you're inserting is in a particualar set of values
payment_method varchar(20) check (payment_method in ('UPI', 'CREDIT CARD')),
-- default constraint sets default value in case nothing is supplied
category varchar(20) default 'MENS WEAR'
primary key(order_id, product_name )
);
insert into a_orders values
(1, '2022-10-01', 'Shoes', 132.5, 'upi', 'women wear'
);
insert into a_orders values
(2, '2022-10-01', 'Shoes', 132.5, 'upi', null
);
insert into a_orders (order_id, order_date, product_name, total_price, payment_method)values
(3, '2022-10-01', 'Shoes', 132.5, 'upi'
);
-- Primary key constraint VS unique
-- in primary you cant have null 
-- there can be mutiple unique col. but not multiple primary keys

SELECT * FROM a_orders;