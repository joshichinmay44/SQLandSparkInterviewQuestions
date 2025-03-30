create table candidates (
emp_id int,
experience varchar(20),
salary int
);
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);


select * from candidates;

/*
A company wants to hire new employees. The budget of the company for the salaries is $70000. The company's criteria for hiring are:
Keep hiring the senior with the smallest salary until you can not hire any more seniors.
Use the remaning budget to hire the junior with the smallest salary.
Keep hiring the junior with the smallest salary until you can not hire any more junior.
Write a SQL query to find the seniors and juniors hired under the mentioned criteria.
*/

declare @a int;

select emp_id,experience,salary,
sum(salary) over(partition by experience order by salary) as cum_salary into #temp
from candidates ;

select @a=max(cum_salary) over() from #temp where experience='senior' and cum_salary<=70000
if(@a<70000)
select emp_id,experience,salary from #temp where experience='senior' and cum_salary<=70000
union
select emp_id,experience,salary from #temp where experience='junior' and cum_salary<=@a
