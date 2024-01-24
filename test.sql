CREATE VIEW vsal
AS
  SELECT a.deptno                  "Department",
         a.num_emp / b.total_count "Employees",
         a.sal_sum / b.total_sal   "Salary"
  FROM   (SELECT deptno,
                 Count()  num_emp,
                 SUM(sal) sal_sum
          FROM   scott.emp
          WHERE  city = 'NYC'
          GROUP  BY deptno) a,
         (SELECT Count()  total_count,
                 SUM(sal) total_sal
          FROM   scott.emp
          WHERE  city = 'NYC') b
;

INSERT ALL
	WHEN ottl < 100000 THEN
		INTO small_orders
			VALUES(oid, ottl, sid, cid)
	WHEN ottl > 100000 and ottl < 200000 THEN
		INTO medium_orders
			VALUES(oid, ottl, sid, cid)
	WHEN ottl > 200000 THEN
		into large_orders
			VALUES(oid, ottl, sid, cid)
	WHEN ottl > 290000 THEN
		INTO special_orders
SELECT o.order_id oid, o.customer_id cid, o.order_total ottl,
o.sales_rep_id sid, c.credit_limit cl, c.cust_email cem
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

create table scott.dept(
  deptno     number(2,0),
  dname      varchar2(14),
  loc        varchar2(13),
  constraint pk_dept primary key (deptno)
);

create table scott.emp(
  empno    number(4,0),
  ename    varchar2(10),
  job      varchar2(9),
  mgr      number(4,0),
  hiredate date,
  sal      number(7,2),
  comm     number(7,2),
  deptno   number(2,0),
  constraint pk_emp primary key (empno),
  constraint fk_deptno foreign key (deptno) references dept (deptno)
);