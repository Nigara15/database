--1.1
CREATE TABLESPACE student_data
    LOCATION '/Library/PostgreSQL/tablespaces/students';

CREATE TABLESPACE course_data
    OWNER CURRENT_USER
    LOCATION '/Library/PostgreSQL/tablespaces/courses';
--1.2
CREATE DATABASE university_main
    WITH OWNER = postgres
    TEMPLATE = template0
    ENCODING = 'UTF8';

CREATE DATABASE university_archive
    WITH OWNER = postgres
    CONNECTION LIMIT = 50
    TEMPLATE = template0;

CREATE DATABASE university_distributed
    WITH OWNER = postgres
    TABLESPACE = student_data
    ENCODING = 'LATIN9'
    TEMPLATE = template0;
--2.1
create table stuents(
    student_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100) unique,
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa decimal(3,2),
    is_active boolean default true,
    graduation_year smallint
);

create table professors(
    professor_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100) unique,
    office_number varchar(20),
    hire_date date,
    salary numeric(12,2),
    is_tenured boolean default false,
    years_experience int
);

create table courses(
    course_id serial primary key,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment integer,
    course_free numeric(10,2),
    is_online boolean,
    created_at timestamp without time zone
);
--2.2
create table class_schedule (
    schredule_id serial primary key,
    course_id integer,
    professor_id integer,
    classroom varchar(20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);

create table sudent_record(
    record_id serial primary key,
    student_id integer,
    course_id integer,
    semester varchar(20),
    year integer,
    grade char(2),
    attendance_percentage numeric(4,1),
    submission_timestamp timestamptz,
    last_updated timestamptz
);
--3.1
--student:
alter table stuents
add column middle_name varchar(30);

alter table stuents
add column student_status varchar(20);

alter table stuents
alter column phone type varchar(20);

alter table stuents
alter column student_status SET DEFAULT 'ACTIVE';

alter table stuents
alter column gpa SET DEFAULT 0.00;

--professor:
alter table professors
add column department_code char(5);

alter table professors
add column research_area text;

alter table professors
alter column years_experience type smallint;

alter table professors
alter column is_tenured SET DEFAULT false;

alter table professors
add column last_promotion date;

--couses:
alter table courses
add column prerequisite_course_id integer;

alter table courses
add column difficulty_level smallint;

alter table courses
alter column course_id type varchar(10);

alter table courses
alter column credits SET DEFAULT 3;

alter table courses
add column lab_required boolean default false;
--3.2
--class_schredule:
alter table class_schedule
add column room_capacity integer;

alter table class_schedule
drop column duration;

alter table class_schedule
add column session_type varchar(15);

alter table class_schedule
alter column classroom type varchar(30);

alter table class_schedule
add column equipment_neede text;

--student_record:
alter table sudent_record
add column extra_credit_points numeric(4,1);

alter table sudent_record
alter column grade type varchar(5);

alter table sudent_record
alter column extra_credit_points set default 0.0;

alter table sudent_record
add column final_exam_date date;

alter table sudent_record
drop column last_updated;

--4.1
create table departments (
    department_id serial primary key,
    department_name varchar(100),
    department_code char(50),
    building varchar(50),
    phone varchar(15),
    budget numeric(15,2),
    established_year integer
);

create table library_books(
    book_id serial primary key,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price numeric(10,2),
    is_available boolean,
    acquistion_timestamp timestamp without time zone
);

create table student_book_loans(
    loan_id serial primary key,
    student_id integer,
    book_id integer,
    loan_date date,
    due_data date,
    return_date date,
    fine_amount numeric(10,2),
    loan_status varchar(20)
);
--4.2
alter table professors
add column department_id integer;

alter table stuents
add column advisor_id integer;

alter table courses
add column department_id integer;

create table grade_scale(
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2)
);

create table semester_calendar(
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);
--5.1
drop table if exists student_book_loans;
drop table if exists library_books;
drop table if exists grade_scale;

create table grade_scale(
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric (3,2),
    description text
);

drop table if exists semester_calendar cascade;

create table semester_calendar(
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);

drop database if exists university_test;
drop database if exists university_distributed;

create database university_bakup
with template= university_main
owner=postgres;