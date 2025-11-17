--2.1
create index emp_salary_idx on employees(salary);

--2.2
create index emp_dept_idx on employees(dept_id);

--2.3
--select tablename,indexname,indexdef
--from pg_indexes
--where schemaname='public'
--order by tablename,indexname;

--3.1
create index emp_dept_salary_idx on employees(dept_id,salary);

--3.2
create index emp_salary_dept_id on employees(salary,dept_id);

--4.1
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
UPDATE employees SET email = 'john.smith@company.com' WHERE emp_id = 1;
UPDATE employees SET email = 'jane.doe@company.com' WHERE emp_id = 2;
UPDATE employees SET email = 'mike.johnson@company.com' WHERE emp_id = 3;
UPDATE employees SET email = 'sarah.williams@company.com' WHERE emp_id = 4;
UPDATE employees SET email = 'tom.brown@company.com' WHERE emp_id = 5;

create index emp_email on employees(email);

--4.2
alter table employees add column phone varchar(20) unique;

--5.1
create index emp_salary_desc on employes(salary DESC);

--5.2
create index proj_budget on projects(budget nulls first);

--6.1
create index emp_name_lower on employees (lower(emp_name));

--6.2
ALTER TABLE employees ADD COLUMN hire_date DATE;
UPDATE employees SET hire_date='2020-01-15' WHERE emp_id=1;
UPDATE employees SET hire_date='2019-06-20' WHERE emp_id=2;
UPDATE employees SET hire_date='2021-03-10' WHERE emp_id=3;
UPDATE employees SET hire_date='2020-11-05' WHERE emp_id=4;
UPDATE employees SET hire_date='2018-08-25' WHERE emp_id=5;

create index emp_hire_year on employees ((extract(year from hire_date)));

--7.1
alter index emp_salary_idx rename to employees_salary_index;

--7.2
drop index if exists emp_salary_index;
reindex index employees_salary_index;

--8.1
create index emp_salary_filter on employees(salary)
where salary>50000;

--8.2
create index proj_high_budget on projects(budget)
where budget>80000;

--9.1
create index dept_name_hash on departments using hash (dept_name);

--9.2
create index proj_name_btree on projects(project_name);
create index proj_name_hash on projects using hash(project_name);

--10.2
drop index if exists proj_nam_hash;

--10.3
create or replace view index_documents as
    select tablename,indexname,indexdef, 'Improves salary-based queries' as purpose
    from pg_indexes
    where schemaname='public' and indexname like '%salary%';

--1
--B-tree
--2
--Columns used in WHERE
--Columns used in JOINs (foreign keys)
--Columns used in ORDER BY or sorting
--3
--Columns with low cardinality (few distinct values)
--Columns that are frequently updated and rarely queried
--4
--They are automatically updated (adds, modifies, removes entries).
--This makes writes slower
--5
--explain