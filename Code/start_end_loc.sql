CREATE TABLE travel_data (
 customer VARCHAR(10),
 start_loc VARCHAR(50),
 end_loc VARCHAR(50)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
 ('c1', 'New York', 'Lima'),
 ('c1', 'London', 'New York'),
 ('c1', 'Lima', 'Sao Paulo'),
 ('c1', 'Sao Paulo', 'New Delhi'),
 ('c2', 'Mumbai', 'Hyderabad'),
 ('c2', 'Surat', 'Pune'),
 ('c2', 'Hyderabad', 'Surat'),
 ('c3', 'Kochi', 'Kurnool'),
 ('c3', 'Lucknow', 'Agra'),
 ('c3', 'Agra', 'Jaipur'),
 ('c3', 'Jaipur', 'Kochi');
 
 select * from travel_data;
 
 with cte as(
 select t.customer,t.start_loc ,t1.start_loc as end_loc from travel_data  t 
 left  join travel_data t1 on t.customer=t1.customer and t.start_loc= t1.end_loc 
 )
 ,start_loc_cte as (select customer, start_loc from cte where end_loc is null)
, cte2 as (
  select t.customer,t.end_Loc ,t1.start_loc as start_loc from travel_data  t 
 left  join travel_data t1 on t.customer=t1.customer and t.end_loc= t1.start_loc 
)
, end_loc_cte as (
select customer,end_Loc from cte2 where start_loc is null
)
select s.customer, s.start_loc,e.end_loc from start_loc_cte s 
join end_loc_cte e on s.customer=e.customer