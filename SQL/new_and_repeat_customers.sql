create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
select * from customer_orders;


with ranks as (select customer_id, order_date,
dense_rank() over(partition by customer_id order by order_date) as rn from
customer_orders)
select order_date, sum(case when rn=1 then 1 else 0 end) as new_customers, 
sum(case when rn>1 then 1 else 0 end) as repeat_customers from ranks
group by order_date