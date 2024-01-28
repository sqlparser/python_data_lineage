UPDATE nmosdb@wnmserver1:test
SET name=(SELECT name FROM test
WHERE test.id = nmosdb@wnmserver1:test.id)
WHERE EXISTS(
SELECT 1 FROM test WHERE test.id = nmosdb@wnmserver1:test.id
);