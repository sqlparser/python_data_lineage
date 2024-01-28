-- sparksql sample sql

CREATE TABLE person (id INT, name STRING, age INT, class INT, address STRING);

SELECT * FROM person
    PIVOT (
        SUM(age) AS a, AVG(class) AS c
        FOR name IN ('John' AS john, 'Mike' AS mike)
    );