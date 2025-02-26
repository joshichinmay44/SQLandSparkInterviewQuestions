create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 10000,4,37);
insert into emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',300,7000,6,50);

select * from emp;

/*--find departments with average salary which is less than the average salary of the company.
While calculating the average salary of the company exclude the department which is being used for comparison*/

with department_wise_data as 
(
  select sum(salary) over(partition by department_id) as department_sal,
  count(1) over(partition by department_id) as department_emp_count,
  sum(salary) over() as total_sal,count(1) over() as total_emp_count,
  department_id,emp_id,emp_name,salary,manager_id  
  from emp
)
, department_wise_adjusted_data as 
(
  select department_id,department_emp_count,department_sal,
  (total_sal-department_sal) as dept_excluded_total_comp_sal,
  (total_emp_count-department_emp_count) as dept_excluded_total_comp_emp
  from department_wise_data
)
, department_wise_agg_data as 
(
  select department_id,department_emp_count,department_sal,dept_excluded_total_comp_sal,
  (dept_excluded_total_comp_sal/dept_excluded_total_comp_emp) as dept_excluded_com_avg,
  (department_sal/department_emp_count) as dept_avg
  from department_wise_adjusted_data
)
select distinct department_id,dept_avg as dep_avg,
department_emp_count as no_of_employees,
dept_excluded_total_comp_sal as total_salary,
dept_excluded_com_avg as company_avg_salary
from department_wise_agg_data
where dept_avg<dept_excluded_com_avg;
