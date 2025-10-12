--Kamaldinova Nigara 24B030398
--1.1
--age must be between 18 and 65, salary must be > 0
create table employeess(
    employee_id integer,
    first_name text,
    last_name text,
    age integer check (age between 18 and 65),
    salary numeric check (salary>0)
);

insert into employeess (employee_id, first_name, last_name, age, salary)
values
(1, 'Alice', 'Ivanova', 28, 3500.00),
(2, 'Bob', 'Petrov', 45, 5200.50);
-- Violates age CHECK
--insert into employees (employee_id, first_name, last_name, age, salary)
-- values (3, 'Charlie', 'Young', 17, 2000.00);
-- fails: CHECK (age BETWEEN 18 AND 65) — age = 17 is < 18

-- Violates salary CHECK
-- insert into employees (employee_id, first_name, last_name, age, salary)
-- values(4, 'Dora', 'Zero', 30, 0);
-- fails: CHECK (salary > 0) — salary = 0 is not > 0

--1.2
--named CHECK constraint
create table products_catalog (
    product_id integer,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    constraint valid_discount check(
        regular_price > 0
        and discount_price >0
        and discount_price < regular_price
        )
);

insert into products_catalog (product_id, product_name, regular_price, discount_price)
values
(1, 'Widget A', 100.00, 80.00),
(2, 'Gadget B', 50.00, 45.00);

-- discount_price >= regular_price (violates valid_discount)
-- insert into products_catalog (product_id, product_name, regular_price, discount_price)
-- values(3, 'Bad Deal', 20.00, 25.00);
-- fails: valid_discount requires discount_price < regular_price

-- regular_price <= 0
-- insert into products_catalog (product_id, product_name, regular_price, discount_price)
-- values(4, 'Freebie', 0.00, 0.00);
-- fails: valid_discount requires regular_price > 0 and discount_price > 0

--1.3
create table booking (
    booking_id integer,
    check_in_date date,
    check_out_date date,
    num_guests integer check (num_guests between 1 and 10),
    check(check_out_date > check_in_date)
);

insert into booking (booking_id, check_in_date, check_out_date, num_guests)
values
(1, '2025-11-01', '2025-11-05', 2),
(2, '2025-12-20', '2025-12-25', 4);

-- num_guests out of range
-- insert into bookings (booking_id, check_in_date, check_out_date, num_guests)
-- values(3, '2025-11-10', '2025-11-12', 0);
-- fails: CHECK (num_guests BETWEEN 1 AND 10) — num_guests = 0

-- check_out_date not after check_in_date
-- insert into bookings (booking_id, check_in_date, check_out_date, num_guests)
-- values(4, '2025-11-10', '2025-11-10', 2);
-- fails: CHECK (check_out_date > check_in_date) — check_out_date = check_in_date

--2.1
create table customers (
    customer_id integer not null,
    email text not null,
    phone text,
    registration_date date not null
);

insert into customers (customer_id, email, phone, registration_date)
values
(1, 'a.ivanova@example.com', '+77001234567', '2024-09-01'),
(2, 'b.petrov@example.com', NULL, '2024-10-05');

-- Missing NOT NULL column
-- insert into customers (email, phone, registration_date)
-- values('noid@example.com', NULL, '2024-11-01');
-- fails: customer_id is NOT NULL

-- Missing NOT NULL column: email
-- insert into customers (customer_id, phone, registration_date)
-- values(3, NULL, '2024-12-01');
-- FAILS: email is NOT NULL

--2.2
create table inventory (
    item_id integer not null,
    item_name text not null,
    quantity integer not null check (quantity >=0),
    unit_price numeric not null check(unit_price>0),
    last_updated timestamp not null
);

insert into inventory (item_id, item_name, quantity, unit_price, last_updated)
values
(1, 'Screwdriver', 50, 7.99, '2025-01-10 10:00:00'),
(2, 'Hammer', 30, 12.50, '2025-01-11 12:30:00');

-- Negative quantity
-- insert into inventory (item_id, item_name, quantity, unit_price, last_updated)
-- values(3, 'Broken', -5, 2.00, '2025-01-12 09:00:00');
-- fails: CHECK (quantity >= 0)

-- Zero or negative price
-- insert into inventory (item_id, item_name, quantity, unit_price, last_updated)
-- values(4, 'Free Stuff', 10, 0.00, '2025-01-12 09:15:00');
-- fails: CHECK (unit_price > 0)

--2.3
-- Insert with NULL in nullable column
insert into customers (customer_id, email, phone, registration_date)
values
(4, 'c.nullphone@example.com', NULL, '2025-02-02');

-- insert into inventory (item_id, item_name, quantity, unit_price, last_updated)
-- values(5, NULL, 10, 5.00, '2025-02-02 08:00:00');
-- fails: item_name is NOT NULL

--3.1
create table users (
    user_id integer,
    username text unique,
    email text unique,
    created_at timestamp
);

insert into users (user_id, username, email, created_at)
values
(1,'alice','alice@example.com','2025-01-01 9:00:00'),
(2, 'bob', 'bob@example.com', '2025-03-02 10:00:00');

--3.2
create table course_enrollment(
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    constraint unique_enrollment_per_semester unique (student_id, course_code, semester)
);

insert into course_enrollment (enrollment_id, student_id, course_code, semester)
values
(1, 1001, 'CS101', '2025S1'),
(2, 1002, 'CS101', '2025S1');

-- insert into course_enrollments (enrollment_id, student_id, course_code, semester)
-- values(3, 1001, 'CS101', '2025S1');
-- fails: UNIQUE constraint unique_enrollment_per_semester prevents duplicate

--3.3
drop table users;
create table users (
    user_id integer,
    username text,
    email text,
    created_at timestamp,
    constraint unique_username unique(username),
    constraint unique_email unique(email)
);

insert into users (user_id, username, email, created_at)
values
(1, 'charlie', 'charlie@example.com', '2025-04-01 12:00:00'),
(2, 'dora',    'dora@example.com',    '2025-04-02 13:00:00');

-- insert into users (user_id, username, email, created_at)
-- values(3, 'charlie', 'another@example.com', '2025-04-03 14:00:00');
-- FAILS: CONSTRAINT unique_username

-- Duplicate email (commented)
-- INSERT INTO users (user_id, username, email, created_at) VALUES
-- (4, 'newuser', 'dora@example.com', '2025-04-04 15:00:00');
-- FAILS: CONSTRAINT unique_email

--4.1
create table departmentss(
    dept_id integer primary key,
    dept_name text not null,
    location text
);

insert into departmentss (dept_id, dept_name, location)
values
(10, 'Human Resources', 'Building A'),
(20, 'Sales', 'Building B'),
(30, 'R&D', 'Building C');

-- insert into departments (dept_id, dept_name, location)
-- values(10, 'Finance', 'Building D');
-- fails: PRIMARY KEY violation

-- insert into departments (dept_name, location)
-- values('Legal', 'Building E');
-- fails: dept_id is PRIMARY KEY -> cannot be NULL

--4.2
create table student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    primary key (student_id, course_id)
);

insert into student_courses (student_id, course_id, enrollment_date, grade)
values
(1001, 2001, '2025-02-01', 'A'),
(1002, 2001, '2025-02-02', 'B');

-- insert into student_courses (student_id, course_id, enrollment_date, grade)
-- values(1001, 2001, '2025-02-05', 'A-');
-- fails: duplicate (student_id, course_id)

--4.3
-- 1.
-- PRIMARY KEY: enforces uniqueness and NOT NULL. Each table may have only one PRIMARY KEY
-- UNIQUE: enforces uniqueness but allows NULLs (unless column is declared NOT NULL). A table can have multiple UNIQUE constraints
-- 2.
-- Single-column PK: when a single attribute uniquely identifies a row (e.g., dept_id)
-- Composite PK: when uniqueness requires combination of columns (e.g., student_id + course_id)
-- 3
-- The PRIMARY KEY is the main identifier for the row and implicitly defines the table's identity (also used by foreign keys typically)
-- Multiple UNIQUE constraints are allowed to enforce uniqueness across several different columns/combinations, but conceptually the table may only have one canonical PK

--5.1
create table employees_dept (
    emp_id integer primary key,
    emp_name text not null,
    dept_id integer references departmentss(dept_id),
    hire_date date
);

insert into employees_dept (emp_id, emp_name, dept_id, hire_date)
values (101, 'Ivan', 10, '2024-06-01'),
       (102, 'Elena', 20, '2024-07-10');

-- insert into employees_dept (emp_id, emp_name, dept_id, hire_date)
-- values(103, 'Ghost', 999, '2024-08-01');
-- fails: FOREIGN KEY violation — dept_id 999 does not exist in departments

--5.2
create table authors (
    author_id integer primary key,
    author_name text not null,
    country text
);

create table publishers (
    publisher_id integer primary key,
    publisher_name text not null,
    city text
);

create table books (
    book_id integer primary key,
    title text not null,
    author_id integer references authors(author_id),
    publisher_id integer references publishers(publisher_id),
    publication_year integer,
    isbn text unique
);

insert into authors (author_id, author_name, country)
values
(1, 'Leo Tolstoy', 'Russia'),
(2, 'Jane Austen', 'United Kingdom'),
(3, 'Haruki Murakami', 'Japan');

insert into publishers (publisher_id, publisher_name, city)
values
(1, 'Penguin Classics', 'London'),
(2, 'Vintage', 'New York'),
(3, 'Shinchosha', 'Tokyo');

insert into books (book_id, title, author_id, publisher_id, publication_year, isbn)
values
(1, 'War and Peace', 1, 1, 1869, 'ISBN-0001'),
(2, 'Pride and Prejudice', 2, 1, 1813, 'ISBN-0002'),
(3, 'Norwegian Wood', 3, 3, 1987, 'ISBN-0003');

--5.3
create table categories (
    category_id integer primary key,
    category_name text not null
);

create table products_fk (
    product_id integer primary key,
    product_name text not null,
    category_id integer references categories(category_id) on delete restrict
);

create table orders (
    order_id integer primary key,
    order_date date not null
);

create table order_items (
    item_id integer primary key,
    order_id integer references orders(order_id) on delete cascade,
    product_id integer references products_fk(product_id),
    quantity integer check (quantity > 0)
);

insert into categories (category_id, category_name)
values
(100, 'Electronics'),
(200, 'Books');

insert into products_fk (product_id, product_name, category_id)
values
(1001, 'Smartphone', 100),
(1002, 'Laptop', 100),
(2001, 'Novel', 200);

insert into orders (order_id, order_date)
values
(5001, '2025-05-01'),
(5002, '2025-05-02');

insert into order_items (item_id, order_id, product_id, quantity)
values
(1, 5001, 1001, 1),
(2, 5001, 2001, 2),
(3, 5002, 1002, 1);

-- 1) Try to delete a category that has products:
--    DELETE FROM categories WHERE category_id = 100;
--    This will fail because products_fk references categories(category_id) with ON DELETE RESTRICT.
--    Example:
--    -- DELETE FROM categories WHERE category_id = 100;
--    -- ERROR: update or delete on table "categories" violates foreign key constraint "products_fk_category_id_fkey" on table "products_fk"
-- 2) Delete an order and observe that order_items are automatically deleted (CASCADE)
--    Example:
--    -- DELETE FROM orders WHERE order_id = 5001;
--    After deletion, corresponding rows in order_items with order_id = 5001 will be removed automatically.
--    We can demonstrate by performing a SELECT before and after in an interactive session.

-- BEFORE:
-- SELECT * FROM order_items WHERE order_id = 5001;
-- -> returns item_id 1 and 2
-- RUN:
-- DELETE FROM orders WHERE order_id = 5001;
-- AFTER:
-- SELECT * FROM order_items WHERE order_id = 5001;
-- -> returns 0 rows (deleted due to ON DELETE CASCADE)

--6.1
-- customers table
create table ecommerce_customers (
    customer_id integer primary key,
    name text not null,
    email text not null unique,
    phone text,
    registration_date date not null
);

-- products table
create table ecommerce_products (
    product_id integer primary key,
    name text not null,
    description text,
    price numeric not null check (price >= 0),
    stock_quantity integer not null check (stock_quantity >= 0)
);

-- orders table
create table ecommerce_orders (
    order_id integer primary key,
    customer_id integer references ecommerce_customers(customer_id) on delete set null,
    order_date date not null,
    total_amount numeric not null check (total_amount >= 0),
    status text not null check (status in ('pending','processing','shipped','delivered','cancelled'))
);

-- order_details table
create table ecommerce_order_details (
    order_detail_id integer primary key,
    order_id integer references ecommerce_orders(order_id) on delete cascade,
    product_id integer references ecommerce_products(product_id),
    quantity integer not null check (quantity > 0),
    unit_price numeric not null check (unit_price >= 0)
);

-- customers
insert into ecommerce_customers (customer_id, name, email, phone, registration_date)
values
(1, 'Ainur', 'ainur@example.com', '+77001230001', '2025-01-10'),
(2, 'Barys', 'barys@example.com', '+77001230002', '2025-01-15'),
(3, 'Cem',   'cem@example.com',   '+77001230003', '2025-02-01'),
(4, 'Dana',  'dana@example.com',  null,                '2025-02-12'),
(5, 'Erkin', 'erkin@example.com', '+77001230005', '2025-03-01');

-- products
insert into ecommerce_products (product_id, name, description, price, stock_quantity)
values
(101, 'USB Cable', '1m USB-C cable', 5.99, 150),
(102, 'Wireless Mouse', 'Optical mouse', 19.99, 75),
(103, 'Keyboard', 'Mechanical keyboard', 59.99, 40),
(104, 'Monitor', '24-inch 1080p', 129.99, 20),
(105, 'Webcam', '720p webcam', 29.99, 50);

-- orders
insert into ecommerce_orders (order_id, customer_id, order_date, total_amount, status)
values
(9001, 1, '2025-04-01', 25.98, 'pending'),
(9002, 2, '2025-04-02', 59.99, 'processing'),
(9003, 3, '2025-04-03', 159.98, 'shipped'),
(9004, 4, '2025-04-05', 129.99, 'delivered'),
(9005, 5, '2025-04-07', 35.98, 'cancelled');

-- order_details
insert into ecommerce_order_details (order_detail_id, order_id, product_id, quantity, unit_price)
values
(1, 9001, 101, 2, 5.99),
(2, 9002, 103, 1, 59.99),
(3, 9003, 104, 1, 129.99),
(4, 9003, 105, 1, 29.99),
(5, 9004, 104, 1, 129.99),
(6, 9005, 102, 2, 19.99);