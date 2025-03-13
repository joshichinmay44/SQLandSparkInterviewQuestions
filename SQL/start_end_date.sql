create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

select * from tasks;

with cte as (
select lag(date_value)over(partition by state order by date_value) as prev , date_value,state,lead(state) over(order by date_value) as nxt_state
from tasks)
,cte1 as (select case when prev is null then date_value when prev <> dateadd(dd,-1,date_value)then date_value else '1900-01-01' end as start_date
,case when state <> nxt_state then date_value when lead(date_value) over (order by date_value) is null then date_value else '1900-01-01' end as end_date, state
from cte)
select distinct c1.start_date,c.end_date,c.state from cte1 c join cte1 c1 
on c.start_date=c1.end_date and c.state=c1.state
where c.end_date <> '1900-01-01' and c1.start_date<> '1900-01-01'
