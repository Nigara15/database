CREATE TABLE employes (
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
department VARCHAR(50),
salary NUMERIC(10,2),
hire_date DATE,
manager_id INTEGER,
email VARCHAR(100)
);

CREATE TABLE project (
project_id SERIAL PRIMARY KEY,
project_name VARCHAR(100),
budget NUMERIC(12,2),
start_date DATE,
end_date DATE,
status VARCHAR(20)
);

CREATE TABLE assignments (
assignment_id SERIAL PRIMARY KEY,
employee_id INTEGER REFERENCES employes(employee_id),
project_id INTEGER REFERENCES project(project_id),
hours_worked NUMERIC(5,1),
assignment_date DATE
);

INSERT INTO employes (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');

INSERT INTO project (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');

--1.1
select first_name || ' ' || last_name as full_name, department,salary
from employes;

--1.2
select distinct department
from employes;

--1.3
select project_name,budget,
       case
           when budget > 15000 then 'Large'
           when budget between 100000 and 150000 then 'Medium'
           else 'Small'
       end as budget_category
from project;

--1.4
select first_name || ' ' || last_name AS full_name,
  COALESCE(email, 'No email provided') AS email
from employes;

--2.1
select *
from employes
where hire_date >'2020-01-01';

--2.2
select *
from employes
where salary between 60000 and 70000;

--2.3
select *
from employes
where last_name like 'S%' or last_name like 'J%';

--2.4
select *
from employes
where manager_id is not null and department='IT';

--3.1
select upper(first_name || ' ' || last_name) as full_name, length(last_name), substring (email from 1 for 3)
from employes;

--3.2
select first_name || ' ' || last_name as full_name, salary *12 as annualsalary, round(salary,2) as mounthlysalary, round(salary *0.10,2) as raisesalary
from employes;

--3.3
select format ('project: %s - Budget: $%s - Status: %s', project_name, budget, status) as project
from project;

--3.4
select first_name || ' ' || last_name as full_name, extract(year from age(current_date, hire_date))
from employes;

--4.1
select avg(salary),department
from employes
group by department;

--4.2
select p.project_name, sum(a.hours_worked)
from assignments a
join project p
on a.project_id = p.project_id
group by p.project_name;

--4.3
select department, count(*)
from employes
group by department
having count(*)>1;

--4.4
select max(salary), min(salary), sum(salary)
from employes;

--5.1
select employee_id, first_name || ' ' || last_name as full_name,salary
from employes
where salary > 65000
union
select employee_id, first_name || ' ' || last_name as full_name,salary
from employes
where hire_date > '2020-01-01';

--5.2
select first_name || ' ' || last_name as full_name,salary,department
from employes
where department='IT'
intersect
select first_name || ' ' || last_name as full_name,salary,department
from employes
where salary>65000;

--5.3
select employee_id,first_name || ' ' || last_name as full_name
from employes
except
select distinct e.employee_id, e.first_name || ' ' || e.last_name as full_name
from employes e
join assignments a
    on e.employee_id = a.employee_id;

--6.1
select e.employee_id, e.first_name || ' ' || e.last_name
from employes e
where exists (
    select 1
    from assignments
    where e.employee_id=e.employee_id
);

--6.2
select e.employee_id, e.first_name || ' ' || e.last_name
from employes e
where e.employee_id in (
    select a.employee_id
    from assignments a
    join project p
    on a.project_id= p.project_id
    where p.status = 'Active'
    );

--6.3
select e.employee_id, e.first_name || ' ' || e.last_name
from employes e
where salary > any (
    select salary
    from employes
    where department='Sales'
    );

--7.1
select e.first_name || ' ' || e.last_name AS full_name, e.department, round(avg(a.hours_worked),2), rank() over (partition by e.department order by e.salary desc) as salary_rank
from employes e
left join assignments a on e.employee_id = a.employee_id
group by e.employee_id, e.first_name, e.last_name, e.department, e.salary
order by e.department, salary_rank;

--7.2
select p.project_name, sum(a.hours_worked) as total_hours, count(distinct a.employee_id)
from projects p
join assignments a on p.project_id=a.project_id
group by p.project_name
having sum(a.hours_worked) >150
order by total_hours;

--7.3
select department, count(*) , round(avg(salary),2) as avg_salary, max(first_name || ' ' || last_name), greatest(max(salary),avg(salary)), least(min(salary),avg(salary))
from employes
group by department
order by avg_salary desc;