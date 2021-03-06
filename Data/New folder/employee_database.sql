-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR(40) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining departments and dept_manager tables using alias
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables using alias
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--use left join for retirement_info and dept_emp
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT ri.emp_no,
ri.first_name,
ri.last_name,
di.dept_name
INTO sales_info
FROM retirement_info as ri
INNER JOIN dept_info AS di
ON (ri.emp_no = di.emp_no)
WHERE di.dept_name = ('Sales');

SELECT ri.emp_no,
ri.first_name,
ri.last_name,
di.dept_name
INTO sales_development_info
FROM retirement_info as ri
INNER JOIN dept_info AS di
ON (ri.emp_no = di.emp_no)
WHERE di.dept_name IN ('Sales','Development');

SELECT*FROM departments;
SELECT*FROM dept_manager;
SELECT*FROM employees;
SELECT*FROM dept_emp;
SELECT*FROM salaries;
SELECT*FROM titles;
SELECT*FROM retiring_titles;
SELECT*FROM retiring_title;
SELECT*FROM unique_titles;
SELECT*FROM retirement_titles;
SELECT*FROM unique_titles_new;

--module challenge (Deliverable 1)
SELECT e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, from_date DESC;

--retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT (title)
FROM unique_titles;

SELECT COUNT(title),title
INTO retiring_title
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

--(Deliverable2)create a Mentorship Eligibility table that holds the employees who are eligible to participate in a mentorship program.
SELECT DISTINCT ON (emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de 
ON (e.emp_no=de.emp_no)
INNER JOIN titles as t 
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no ASC;

SELECT COUNT(title),title
INTO mentorship_eligibility_title
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC;

--expand eligibility for those whose b-day b/w 1962 to 1965
SELECT DISTINCT ON (emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
INTO aaa
FROM employees as e
INNER JOIN dept_emp as de 
ON (e.emp_no=de.emp_no)
INNER JOIN titles as t 
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no ASC;

SELECT COUNT(title),title
INTO mentorship_eligibility1962_1965
FROM aaa
GROUP BY title
ORDER BY count DESC;

--add gender
SELECT e.emp_no,
e.first_name,
e.last_name,
e.gender,
ti.title,
ti.from_date,
ti.to_date
INTO retirement_titles_new
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

--delete dup emp_no
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title,
gender
INTO unique_titles_new
FROM retirement_titles_new
ORDER BY emp_no ASC, from_date DESC;

--count retiring title by gender 
SELECT COUNT(gender),gender
INTO retiring_title_new
FROM unique_titles_new
GROUP BY gender;

--count employees by gender
SELECT COUNT (gender), gender
INTO gender
FROM employees
GROUP BY gender;

SELECT * FROM full_titles;
SELECT * FROM full_emp_gender;

--add gender
SELECT DISTINCT ON (emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
e.gender,
de.from_date,
de.to_date,
t.title
INTO mentorship_eligibility_gender
FROM employees as e
INNER JOIN dept_emp as de 
ON (e.emp_no=de.emp_no)
INNER JOIN titles as t 
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no ASC;

SELECT COUNT(gender),gender
-- INTO mentorship_eligibility_title
FROM mentorship_eligibility_gender
GROUP BY gender;

SELECT DISTINCT ON (emp_no) e.emp_no, 
e.first_name, 
e.last_name, 
e.gender, 
s.salary, 
de.from_date,
de.to_date
INTO full_emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
AND (de.to_date = '9999-01-01')
ORDER BY emp_no ASC, from_date DESC;

SELECT e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
ti.to_date
INTO full_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (ti.to_date = '9999-01-01')
ORDER BY emp_no ASC;

SELECT fe.emp_no,
fe.first_name,
fe.last_name,
fe.gender,
ft.title,
fe.salary,
fe.from_date,
fe.to_date
INTO full_emp_gender
FROM full_emp_info AS fe
INNER JOIN full_titles as ft
ON (fe.emp_no=ft.emp_no)
ORDER BY emp_no ASC;

SELECT AVG (salary), gender, title
INTO avg_salary
FROM full_emp_gender
GROUP BY title, gender

SELECT * FROM current_emp_count;

SELECT COUNT(gender), title, gender
-- INTO retiring_title_new
FROM unique_titles_new
GROUP BY gender, title
ORDER BY title;