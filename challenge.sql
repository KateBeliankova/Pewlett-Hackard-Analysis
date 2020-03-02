-- CHALLENGE
-- new employee table
SELECT e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
s.salary
INTO chal_emp_info
FROM employees as e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
;

--remove previous titles
SELECT emp_no,first_name, last_name, title, from_date, salary 
into chal_emp_partition
FROM
  (SELECT emp_no, first_name, last_name, title, from_date, salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM chal_emp_info) tmp 
   WHERE rn = 1;

--count of titles
select title, count(emp_no) 
into title_count
from chal_emp_partition 
group by title
order by count(emp_no) desc;

--ready for mentor
SELECT cep.emp_no,
cep.first_name,
cep.last_name,
cep.title,
cep.from_date,
ti.to_date
into ready_for_mentor
FROM chal_emp_partition as cep
INNER JOIN titles AS ti
ON (cep.emp_no = ti.emp_no)
INNER JOIN employees AS e
on (cep.emp_no = e.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    and (ti.to_date = '9999-01-01');

