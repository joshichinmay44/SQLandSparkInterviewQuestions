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

select *, dense_rank() over(partition by company order by salary) as rn, count(1) over(partition by company) as company_cnt from employee;

with data as (
select *, dense_rank() over(partition by company order by salary) as rn, count(1) over(partition by company) as company_cnt from employee
),
company_wise_cnt as (
 select company, count(emp_id) as cnt from employee group by company
)
select distinct salary, d.company from data d
join company_wise_cnt c on c.company=d.company
where 
rn=
case when c.cnt  %2 <>0 
then  (c.cnt+1)/2 end
union 
select distinct sum(salary)/2 as salary, d.company from data d
join company_wise_cnt c on c.company=d.company 
where  rn= 
case when c.cnt  %2 =0 
then  (c.cnt)/2 end 
or rn = case when c.cnt  %2 =0 
then  (c.cnt/2+1) end group by d.company

