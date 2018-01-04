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

--between statement for values which fall in a range
SELECT customer_id,payment_id,amount
FROM payment
WHERE amount BETWEEN 8 AND 9;

/*
returns every payment that has customer_id associated
WHERE and ORDER BY can also be specified after the ON syntax
*/
SELECT customer.customer_id, first_name,last_name,email,amount,payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id;

/* inner join on staff, payment and customer 
return customer first name, staff first name
payment id and amount
*/
SELECT customer.first_name customer_first_name,
staff.staff_id,staff.first_name staff_first_name,
payment.payment_id,amount,payment.customer_id
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
INNER JOIN staff ON payment.staff_id = staff.staff_id;

/* below shows a FULL OUTER JOIN
it returns all rows, even if there is not a match in one row side of the join
so it would return all employees and all departments regardless
may be useful if for example you had to find an employee not assigned
to a department
*/
SELECT employee_name, department_name
FROM employees
FULL OUTER JOIN departments ON d.department_id = e.department_id;

/* return all films, and any inventory record for that film
if there is no inventory record, it will return NULL for that row
*/
SELECT film.film_id,film.title,inventory_id
FROM film
LEFT JOIN inventory ON inventory.film_id = film.film_id;

/* There is a NATURAL JOIN, which defaults to an inner join
unless otherwise specified. 
it tries to match based on common columns 
(and if the values are different, it will fail) 
t's results can be unpredictable. so it's usually better to be specific
*/

/* Cross join creates a cartesean product as a result
  e.g below a1,a2,a3,b1,b2,b3
 */
CREATE TABLE T1 (label CHAR(1) PRIMARY KEY);
 
CREATE TABLE T2 (score INT PRIMARY KEY);
 
INSERT INTO T1 (label)
VALUES
 ('A'),
 ('B');
 
INSERT INTO T2 (score)
VALUES
 (1),
 (2),
 (3);

SELECT 
*
FROM T1
CROSS JOIN T2;

