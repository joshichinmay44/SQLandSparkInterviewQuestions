--Most Popular Room Types
--https://www.youtube.com/watch?v=PE5MZW1CxOI&list=PLBTZqjSKn0IfuIqbMIqzS-waofsPHMS0E&index=6


create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room');

with denormalized_data as (
select user_id,date_searched,value as room_types from airbnb_searches
cross apply string_split(filter_room_types,','))
select room_types,count(1) as searches from denormalized_data
group by room_types order by searches desc;
