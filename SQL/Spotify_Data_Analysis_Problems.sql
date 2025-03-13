CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select * from activity;

--Daily active users

select event_date,count(1) as total_active_users 
from activity group by event_date order by event_date asc;

--Weekly active users

select year(event_date) as year,upper(cast (datename(month,event_date) as varchar(3))) as month,datepart(week,event_date) as week,count(1) as total_active_users 
from activity group by year(event_date),upper(cast (datename(month,event_date) as varchar(3))),datepart(week,event_date) order by year(event_date),upper(cast (datename(month,event_date) as varchar(3))),datepart(week,event_date);

--same day install and app-purchase
with nxt_action as 
(
select *,lead(event_name) over(partition by user_id,event_date order by event_date) as nxt_action from activity
)
select event_date, 
count(case when event_name='app-installed' and nxt_action='app-purchase' then 1
else null end)
from nxt_action
group by event_date order by event_date asc;

--country wise paid users
select country,cast(count(case when event_name='app-purchase' then 1 else null end) as decimal)*100/cast(count(1) as decimal) as percentage_paid_users from activity
group by country;

--how many users purchased the app very next day that it was app-installed
with analytical_data as(
select event_date,lag(event_date) over(partition by user_id order by event_date asc) as prev_date,event_name,lag(event_name) over(partition by user_id order by event_date asc) as prev_event from activity
)
select event_date, count(case when prev_date=dateadd(day,-1,event_date) and event_name='app-purchase' and prev_event='app-installed' then 1 else null end) as total_next_day_purchases 
from analytical_data
group by event_date
order by event_date asc;
