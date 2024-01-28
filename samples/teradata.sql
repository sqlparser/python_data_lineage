USING (empno INTEGER,
salary INTEGER)
MERGE INTO employee AS t
USING (SELECT :empno, :salary, name
FROM names
WHERE empno=:empno) AS s(empno, salary, name)
ON t.empno=s.empno
WHEN MATCHED THEN UPDATE
SET salary=s.salary, name = s.name
WHEN NOT MATCHED THEN INSERT (empno, name, salary)
VALUES (s.empno, s.name, s.salary);