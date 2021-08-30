CREATE TYPE gender AS ENUM('M', 'F');

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      gender 		NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

\echo 'LOADING employees'
\i load_employees.sql