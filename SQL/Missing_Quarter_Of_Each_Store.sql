CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

/*Write a SQL Query to find the missing quarter of each store.
*/

select * from stores;

with ordered_stores as
(
  select store,quarter,amount, lead(quarter,1,'1') over(partition by store order by quarter asc) as nxt_quarter
  from stores
)
, missed_quarters as(
select store, case when quarter='Q1' and nxt_quarter<>'Q2' then 'Q2' 
when quarter='Q2' and nxt_quarter <> 'Q3' then 'Q3'
when quarter='Q3' and nxt_quarter <>'Q4' then 'Q4'
else null end as missing_quarter
from ordered_stores
)
select store,missing_quarter from missed_quarters where missing_quarter is not null;

