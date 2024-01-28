create table "my_schema".t1(a int, b int);
 
MERGE INTO "my_schema".t1 USING "my_schema".t2 ON "my_schema".t1.a = "my_schema".t2.a
 WHEN MATCHED THEN UPDATE SET "my_schema".t1.b = "my_schema".t2.b
 WHEN NOT MATCHED THEN INSERT VALUES("my_schema".t2.a, "my_schema".t2.b);