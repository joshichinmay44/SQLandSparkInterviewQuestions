CREATE TABLE employee_checkin_details
(
  employeeid  int,
  entry_details varchar(200) CHECK (entry_details in ('login','logout')),
  timestamp_details datetime
)

INSERT INTO employee_checkin_details VALUES
(1000,'login', '2023-06-16 01:00:15.34'),
(1000,'login', '2023-06-16 02:00:15.34'),
(1000,'login', '2023-06-16 03:00:15.34'),
(1000,'logout', '2023-06-16 12:00:15.34'),
(1001,'login', '2023-06-16 01:00:15.34'),
(1001,'login', '2023-06-16 02:00:15.34'),
(1001,'login', '2023-06-16 04:00:15.34'),
(1001,'logout', '2023-06-16 16:00:15.34');

select * from employee_checkin_details ;

CREATE TABLE employee_details
(
  employeeid  int,
  phone_number varchar(200),
  is_default varchar(15)
)

INSERT INTO employee_details VALUES
(1001,'9999','false'),
(1001,'1111','false'),
(1001,'2222','true'),
(1003,'3333','false');

select * from employee_details;
--Return following columns:  employeeid,employee_default_phone_number,totalentry,totallogin,totallogout,latestlogin,latestlogout

with combined_data as
(
  select distinct employeeid,entry_details,timestamp_details,count(1) over(partition by employeeid) as totalentry,
  count(case when entry_details='login' then 1 else null end) over(partition by employeeid) as totallogin,
  count(case when entry_details='logout' then 1 else null end) over(partition by employeeid) as totallogout,
  max(case when entry_details='login' then timestamp_details else null end) over(partition by employeeid) as latestlogin,
  max(case when entry_details='logout' then timestamp_details else null end) over(partition by employeeid) as latestlogout
  from employee_checkin_details
)
select distinct ecd.employeeid,
ed.phone_number as employee_default_phone_number,ecd.totalentry,ecd.totallogin,ecd.totallogout,ecd.latestlogin,ecd.latestlogout
from combined_data ecd left join (
select employeeid,phone_number from employee_details where is_default='true'
) ed
on ed.employeeid=ecd.employeeid;
