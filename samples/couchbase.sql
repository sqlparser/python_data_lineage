
	  
MERGE INTO all_empts a USING emps_deptb b ON KEY b.empId
WHEN MATCHED THEN
     UPDATE SET a.depts = a.depts + 1,
     a.title = b.title || ", " || b.title
WHEN NOT MATCHED THEN
     INSERT  { "name": b.name, "title": b.title, "depts": b.depts, "empId": b.empId, "dob": b.dob }
;
