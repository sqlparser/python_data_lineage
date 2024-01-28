create table t as 
WITH manager (mgr_id, mgr_name, mgr_dept) AS
	(SELECT id, name, grp
	FROM emp_copy
	WHERE mgr = id AND grp != 'gone'),
employee (emp_id, emp_name, emp_mgr) AS
	(SELECT id, name, mgr_id
	FROM emp_copy JOIN manager ON grp = mgr_dept),
mgr_cnt (mgr_id, mgr_reports) AS
	(SELECT mgr, COUNT (*)
	FROM emp_copy
	WHERE mgr != id
	GROUP BY mgr)
SELECT *
FROM employee JOIN manager ON emp_mgr = mgr_id 
	JOIN mgr_cnt ON emp_mgr = mgr_id 
WHERE emp_id != mgr_id
ORDER BY mgr_dept;