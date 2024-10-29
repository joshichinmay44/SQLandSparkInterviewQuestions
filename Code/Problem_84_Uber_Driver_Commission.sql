create table trips(
trip_id int,
driver_id int,
fare float,
rating decimal(16,1)
);

insert into trips values (1,101,1500,4.5),
(2,101,2000,4.2),
(3,101,2500,5.0),
(4,201,1500,4.6),
(5,301,1000,4.0),
(6,101,1700,5.0),
(7,201,300,4.3),
(8,301,1500,4.7),
(9,201,1500,4.5),
(10,101,1700,3.8),
(11,501,1800,5.0);

select * from trips;

with ranked_data as (
select *,row_number() over(partition by driver_id order by trip_id) as rn from trips
)
, commission_calculation as (select 
driver_id,fare,
case when rn<4 then fare*24/100
else
  case when rating between 4.8 and 5.0 then fare*20/100
  when rating between 4.6 and 4.7 then fare*23/100
  else fare*24/100 end
end as commission_rate
from ranked_data)
select driver_id,sum(fare-commission_rate) as total_earnings 
from commission_calculation 
group by driver_id order by driver_id asc;
