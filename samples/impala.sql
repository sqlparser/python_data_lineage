-- Impala sample sql
insert into t2 select c1, c2 from t1;

CREATE VIEW v5 AS SELECT c1, CAST(c3 AS STRING) c3, CONCAT(c4,c5) c5, TRIM(c6) c6, "Constant" c8 FROM t1;

CREATE VIEW v7 (c1 COMMENT 'Comment for c1', c2) COMMENT 'Comment for v7' AS SELECT t1.c1, t1.c2 FROM t1;