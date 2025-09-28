--A
--create database
create database advanced_lab;
--create tables
create table employees(
    emp_id  serial primary key,
    first_name varchar,
    last_name varchar,
    department varchar,
    salary integer,
    hire_date date,
    status varchar default 'Active'
);
create table department(
    dept_id serial primary key,
    dept_name varchar,
    budget integer,
    manager_id integer
);
create table projects(
    project_id serial primary key,
    project_name varchar,
    dept_id integer,
    start_date date,
    end_date date,
    budget integer
);

--B
--insert dates with specification
insert into employees(emp_id,first_name,last_name,department)
values
    (1,'Nigara','Kamaldinova','IT'),
    (2,'Madina','Mullahodzaeva','jurnalist'),
    (3,'Ailin','Khasanova','IT');

insert into employees(emp_id,first_name,last_name,department,salary,hire_date)
values
    (4,'Aigerim','Karimova','IT',Default,current_date );

insert into department(dept_name,budget,manager_id)
values
    ('IT',200000, 1 ),
    ('HR',500000,2),
    ('Manager',300000,3);

insert into employees(emp_id,first_name,last_name,department,salary,hire_date)
values
    (5,'Saera','Talipova','turism',50000 * 1.1, current_date);

--create template and insert data from select
create temp table temp_employees as
select * from employees where department = 'IT';

--C
--update data
update employees
set salary = salary * 1.10
where emp_id > 0;

update employees
set status = 'Senior'
where salary>60000 and hire_date<'2020-01-01';

update employees
set department = case
    when salary>80000 then 'Manager'
    when salary between 50000 and 80000 then 'Senior'
    else 'Junior'
end
where status = 'Active';

update employees
set department = default
where status = 'Inactive';

--update data with union tables
update department d
set budget = (
    select avg(e.salary) * 1.2
    from employees e
    where e.department=d.dept_name)
where exists (
    select 1 from employees e
             where e.department= d.dept_name
);

update employees
set salary = (salary = 1.15) :: int,
    status='Promoted'
where department= 'Sales';

--D
delete from employees
where status = 'Terminated';

delete from employees
where salary<40000 and hire_date>'2023-01-01' and department = 'Null';

delete from department
where dept_name not in (
    select distinct department
    from employees
    where department is not null
    );

delete from projects
where end_date<'2023-01-01'
returning *;

--E
insert into employees (emp_id,first_name,last_name,salary,department,hire_date)
values
    (6,'Anelya','Kamaldinova',null,null,current_date);

update employees
set department='Unassigned'
where department is null;

delete from employees
where salary is null or department is null;

--F
insert into employees (emp_id,first_name,last_name,department,salary,hire_date)
values(7,'Shahnoza','Kamaldinova','Designer',55000,current_date)
returning emp_id,first_name || ' ' || last_name as full_name;

update employees
set salary=salary+5000
where department='IT'
returning emp_id,(salary-5000) as old_salary, salary as new_salary;

delete from employees
where hire_date<'2020-01-01'
returning *;

--G
insert into employees (emp_id,first_name,last_name,department,salary,hire_date)
select '8','Amina','Pidakhmetova','HR',450000,CURRENT_DATE
where not exists (
    select 1
    from employees
    where first_name = 'Amina' and last_name = 'Pidakhmetova'
);

update employees e
set salary = salary * (
    case
        when (select d.budget
              from department d
              where d.dept_name= e.department)>100000
             then 1.10
        else 1.05
    end
)
where department is not null;

insert into employees (emp_id,first_name,last_name,department,salary,hire_date)
values
    (9,'Liam', 'Davis', 'IT', 600000, current_date),
    (10,'Sophia', 'White', 'Sales', 500000, current_date),
    (11,'Mason', 'Hall', 'Finance', 700000, current_date),
    (12,'Isabella', 'Clark', 'HR', 480000, current_date),
    (13,'James', 'Lewis', 'IT', 620000, current_date);
update employees
set salary= salary * 1.10
where(first_name, last_name) IN (
  ('Liam','Davis'),
  ('Sophia','White'),
  ('Mason','Hall'),
  ('Isabella','Clark'),
  ('James','Lewis')
);

--create archive table
create table if not exists employee_archive as
    table employees with no data;
--insert non active employees
insert into employee_archive
select *
from employees
where status ='Inactive';
--delete from main table
delete from employees
where status='Inactive';

update projects p
set end_date = end_date +interval '30 days'
where budget >50000 and (
    select count(*)
    from employees e
    where e.department = (
        select d.dept_name
        from department d
        where d.dept_id = p.dept_id
        )
    )>3;