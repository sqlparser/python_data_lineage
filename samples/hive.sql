CREATE TABLE merge_data.transactions(
	ID int,
	TranValue string,
	last_update_user string)
PARTITIONED BY (tran_date string)
CLUSTERED BY (ID) into 5 buckets 
STORED AS ORC TBLPROPERTIES ('transactional'='true');
 
CREATE TABLE merge_data.merge_source(
	ID int,
	TranValue string,
	tran_date string)
STORED AS ORC;

 MERGE INTO merge_data.transactions AS T 
 USING merge_data.merge_source AS S
 ON T.ID = S.ID and T.tran_date = S.tran_date
 WHEN MATCHED AND (T.TranValue != S.TranValue AND S.TranValue IS NOT NULL) THEN UPDATE SET TranValue = S.TranValue, last_update_user = 'merge_update'
 WHEN MATCHED AND S.TranValue IS NULL THEN DELETE
 WHEN NOT MATCHED THEN INSERT VALUES (S.ID, S.TranValue, 'merge_insert', S.tran_date)