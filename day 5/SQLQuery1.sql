-- JOINS

select * from returns$

exec sp_rename 'Sheet1$', 'returns'

select * from returns; 
-- the returns table is fucked and we need to create
-- a new table to proceed


-- first rename returns to return_backup

exec sp_rename 'returns', 'returns_backup'

SELECT * from returns_backup

--now create a new table by the name of returns
CREATE table returns(order_id varchar(20), return_reason varchar(20));

-- now copy the data from backup to the new one
insert INTO returns 
SELECT * from returns_backup



--INNER JOIN
SELECT o.order_id, r.return_reason
from Orders o
INNER JOIN returns r on o.order_id = r.order_id






