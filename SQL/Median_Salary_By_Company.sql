create table employee 
(
emp_id int,
company varchar(10),
salary int
);
insert into employee values (1,'A',2341)
insert into employee values (2,'A',341)
insert into employee values (3,'A',15)
insert into employee values (4,'A',15314)
insert into employee values (5,'A',451)
insert into employee values (6,'A',513)
insert into employee values (7,'B',15)
insert into employee values (8,'B',13)
insert into employee values (9,'B',1154)
insert into employee values (10,'B',1345)
insert into employee values (11,'B',1221)
insert into employee values (12,'B',234)
insert into employee values (13,'C',2345)
insert into employee values (14,'C',2645)
insert into employee values (15,'C',2645)
insert into employee values (16,'C',2652)
insert into employee values (17,'C',65);

select * from employee;

--Write a SQL Query to find the median salary of each company. If the rows for a company are even then get the average of those middle 2 salaries.

with ranked_employee as 
(
  select emp_id,company,salary
  ,row_number() over(partition by company order by salary asc) as rn
  ,count(emp_id) over(partition by company) as total_emp
  from employee
)
, even_employee_company as 
(
  select *, case when rn=total_emp/2 or rn=(total_emp/2)+1 then 1 else null end as eligible
  from ranked_employee
  where total_emp%2=0
)
, odd_employee_company as 
(
  select *, case when rn=(total_emp+1)/2 then 1 else null end as eligible
  from ranked_employee
  where total_emp%2<>0
)
,even_employee_company_median as
(
  select company,round(cast(avg(salary) as float),2) as median_salary
  from even_employee_company
  where eligible=1
  group by company
)
select company,median_salary from even_employee_company_median
union
select company,salary as median_salary from odd_employee_company where eligible=1
