create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);
insert into customer_budget values (100,400),(200,800),(300,1500);

select * from products;

select * from customer_budget;

--How many products falls into customer budget along with list of products.In case of clash, choose the less costly product

with cumulative_product_total as (
select product_id,cost,sum(cost) over(order by cost) as cum_cost
from products
)
select customer_id,budget,string_agg(p.product_id,',') as products
from customer_budget,cumulative_product_total p
where p.cum_cost<=budget
group by customer_id,budget
