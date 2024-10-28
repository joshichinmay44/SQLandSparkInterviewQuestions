create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

with ranked_data as(
select *,row_number() over(partition by username order by startDate desc) as rn
,count(username) over(partition by username) as cnt
from UserActivity
)
select username,activity,startDate,endDate from ranked_data where rn=2 or cnt=1;
