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

-- ASCedning order sort. in this statement, pointless
SELECT first_name,last_name FROM customer ORDER BY first_name ASC;

--sort customers based on last_name, in descending order
SELECT first_name,last_name FROM customer ORDER BY last_name DESC;

/* sort on first name ascending, then sort those results by last name descening
  for example, if there were two customers with the name Edward, 
  they appear in the following:
  Edward Smith
  Edward Bailey
*/
SELECT first_name,last_name FROM customer ORDER BY first_name ASC,last_name DESC;

/*
  select specific customer(s), based on first_name and last name
  in a large database, this would certainly not be considered unique enough
  to be certain this is the right customer */
SELECT first_name,last_name,customer_id FROM customer 
WHERE first_name = 'Charlie' 
AND last_name = 'Bess';

--find a customer id where someone paid a rental less than a dollar
--or more than eight dollars
SELECT customer_id, amount, payment_date
FROM payment
WHERE amount <= 1 OR amount >=8;


/*select only 10 customers, and skip the first two rows
only select people who's name begins with C
the _ sytax can also be used in postgres, it means 'any single character'
*/
SELECT customer_id,first_name,last_name
FROM customer WHERE first_name LIKE 'C%'
LIMIT 10 OFFSET 2;


--using limit to find the most popular films rented
--DESC in this instance returns the 10 highest rated, ASC returns the lowest
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate DESC
LIMIT 10;

--select all customers where their name doesn't begin with A
SELECT first_name,last_name
FROM customer
WHERE first_name NOT LIKE 'A%';

/* the IN statement is used to check for several values 
where any of them match our criteria */
SELECT city FROM city WHERE country_id in (101,87,15);

/* below shows a nested select
this query returns all cities from the city table for the UK
it can also be used as NOT IN, if we wanted all cities except UK ones */
SELECT city FROM city 
WHERE country_id IN (SELECT country_id FROM country 
					 WHERE country LIKE 'United Kingdom%')
ORDER BY city DESC;

