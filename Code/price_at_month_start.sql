create table sku
(
sku_id int,
price_date date ,
price int
);
delete from sku;
insert into sku values
(1,'2022-12-01',14),
(1,'2023-01-02',10),
(1,'2023-02-15',12),
(1,'2023-03-07',16),
(1,'2023-03-27',18),
(1,'2023-04-27',18),
(1,'2024-01-01',200),
(1,'2024-03-11',200)



select *,dateadd(dd,-1*day(price_date),dateadd(dd,1,price_date)) from sku;




with cte as (select sku_id,dateadd(dd,-1*day(price_date),dateadd(dd,1,price_date)) as start
,month(price_date) as month,price_date,price
,row_number() over(partition by month(price_date),year(price_date) order by price_date) as rn_date
,row_number() over(order by price_date) as rn
from sku)
select * from (
select sku_id,start as date,case 
when price_date <> start and rn_date=1 then lag(price) over( order by price_date)
when price_date <> start and rn_date<>1 then null
when year(price_date)<> lag(year(price_date)) over(order by price_date) then lag(price) over( order by price_date)
else price end as price from cte 
union 
select sku_id,dateadd(mm,1,start) as date,price from cte where rn=(select count(distinct price_date) from sku)
)t where price is not null
