create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);

select * from candidates;

declare @rem_salary float

select emp_id,experience, salary,sum(salary) over(partition by experience order by salary) as cum_salary 
into #tempsenior
from candidates
where experience = 'Senior'

select emp_id,experience, salary,sum(salary) over(partition by experience order by salary) as cum_salary 
into #tempjunior
from candidates
where experience = 'Junior' 


set @rem_salary= 70000-(select max(cum_salary) from #tempsenior where cum_salary<=70000)

select emp_id,experience,salary from #tempsenior where cum_salary<=70000
union all
select emp_id,experience,salary from #tempjunior where cum_salary<=@rem_salary
