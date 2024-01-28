DECLARE
	z_empid employees.employee_id%TYPE;
	z_depid employees.department_id%TYPE;
	z_firstname employees.first_name%TYPE;
	z_lastname employees.last_name%TYPE;

	CURSOR cur_stclerk IS
		SELECT employee_id,
		department_id,
		first_name,
		last_name
		FROM employees
		WHERE job_id = 'ST_CLERK';
BEGIN
OPEN cur_stclerk;
LOOP
	FETCH cur_stclerk INTO z_empid,z_depid,z_firstname,
	z_lastname;
	EXIT WHEN cur_stclerk%NOTFOUND;

	INSERT INTO emp_temp
	(employee_id,
	department_id,
	job_id)
	VALUES (z_empid,
	z_depid,
	'ST_CLERK');

	INSERT INTO emp_detls_temp
	(employee_id,
	empname)
	VALUES (z_empid,
	z_firstname
	|| ' '
	|| z_lastname);
END LOOP;

CLOSE cur_stclerk;
COMMIT;
END;
