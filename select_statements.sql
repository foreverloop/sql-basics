--normally best to specify columns
SELECT first_name,last_name,email FROM customer;

--basic sample table
CREATE TABLE t1 ( id serial NOT NULL PRIMARY KEY, bcolor VARCHAR,  fcolor VARCHAR  );

--insert data to work with
INSERT INTO t1 (bcolor, fcolor) VALUES('red', 'red'),  ('red', 'red'),  ('red', NULL),(NULL, 'red'),('red', 'green'),('red', 'blue'), ('green', 'red'),('green', 'blue'),  ('green', 'green'), ('blue', 'red'), ('blue', 'green'),  ('blue', 'blue');

--select distinct values from bcolor. will print blue green red
SELECT DISTINCT bcolor FROM t1 ORDER BY bcolor;

--selects all except red red, which appears twice, so is not distinct
SELECT DISTINCT bcolor, fcolor FROM  t1  ORDER BY bcolor, fcolor;

