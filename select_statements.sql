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
payment id and amount, only when a match is found ON the ones specified */
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

/* CROSS JOIN - cartesian product */
SELECT *
FROM T1
CROSS JOIN T2;

--GROUP BY used to remove duplicate results
--as well as allow me to sum up the amounts each customer has paid
SELECT customer_id,SUM(amount)
FROM payment
GROUP BY customer_id;

--returns the amounts customers have spent, with the most spent first
SELECT customer_id,SUM(amount)  
FROM payment  
GROUP BY customer_id 
ORDER BY SUM(amount) DESC;

--return the staff id and a count of how many payment_ids
--match thier staff ID
SELECT staff_id,
COUNT(payment_id)
FROM payment
GROUP BY staff_id;

--HAVING statement allows conditional selection on an aggregate function
--below, only customers who've spent a total over 200 are selected
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200;

--UNION operator
/*
 combines results of two SELECTs into one set of results
 the selects must return the same number of cols
 the cols must be the compatible data type e.g int and decimal ok
 but int and bool, no

 the below query would UNION sales 2007q1 results with sales 2007q2
 and remove all duplicate rows. UNION ALL doesn't remove duplicates
 */

SELECT * FROM sales2007q1
UNION
SELECT * FROM sales2007q2;

--find city with most customers
SELECT city.city,COUNT(address_id) 
FROM city 
INNER JOIN address ON city.city_id = address.city_id 
GROUP BY city.city_id 
ORDER BY COUNT(address_id) DESC;

--find most popular film rented
SELECT film.title,COUNT(rental_id) number_of_rentals
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;

--output the values to a CSV file. this could then be modified in 
--excel or using python, R etc...
COPY (SELECT film.title,COUNT(rental_id) number_of_rentals
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC) 
TO 'users/documents/customer_rentals.csv' (format CSV);

COPY(SELECT COUNT(film.film_id),category.name FROM film 
	INNER JOIN film_category ON film.film_id = film_category.film_id 
	INNER JOIN category ON film_category.category_id = category.category_id 
	GROUP BY category.name 
	ORDER BY COUNT(film.film_id) DESC) 
TO '/users/documents/film_category_by_count.csv' (format CSV);

COPY(SELECT COUNT(film.film_id),actor.first_name,actor.last_name FROM actor 
	INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id 
	INNER JOIN film ON film.film_id = film_actor.film_id 
	GROUP BY actor.first_name,actor.last_name 
	ORDER BY COUNT(film.film_id) DESC) 
TO '/users/documents/most_common_actors.csv' (format CSV);

COPY(SELECT city.city,COUNT(address.address_id) FROM customer 
	INNER JOIN address ON customer.address_id = address.address_id 
	INNER JOIN city ON address.city_id = city.city_id 
	GROUP BY city.city 
	ORDER BY COUNT(address.address_id) DESC LIMIT 5)
TO '/users/documents/most_common_cities.csv' (format CSV);

CREATE TABLE employees (
 employee_id serial PRIMARY KEY,
 employee_name VARCHAR (255) NOT NULL
);
 
CREATE TABLE keys (
 employee_id INT PRIMARY KEY,
 effective_date DATE NOT NULL,
 FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);
 
CREATE TABLE hipos (
 employee_id INT PRIMARY KEY,
 effective_date DATE NOT NULL,
 FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

INSERT INTO employees (employee_name)
VALUES
 ('Joyce Edwards'),
 ('Diane Collins'),
 ('Alice Stewart'),
 ('Julie Sanchez'),
 ('Heather Morris'),
 ('Teresa Rogers'),
 ('Doris Reed'),
 ('Gloria Cook'),
 ('Evelyn Morgan'),
 ('Jean Bell');
 
INSERT INTO keys
VALUES
 (1, '2000-02-01'),
 (2, '2001-06-01'),
 (5, '2002-01-01'),
 (7, '2005-06-01');
 
INSERT INTO hipos
VALUES
 (9, '2000-01-01'),
 (2, '2002-06-01'),
 (5, '2006-06-01'),
 (10, '2005-06-01');

-- INTERSECT return all rows in common between both tables
-- INNER JOIN only works on specified cols, by contrast
-- works on a temp table, not the actual table
SELECT employee_id
FROM keys INTERSECT
SELECT employee_id
FROM hipos;

-- select all films from film and arrange by title
SELECT film_id, title
FROM film
ORDER BY title;

--select each film's inventory information
SELECT DISTINCT inventory.film_id,
title
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
ORDER BY title;

--return only the results from the first query before EXCEPT
--that are NOT also in the second query results
SELECT film_id, title
FROM film
EXCEPT 
SELECT DISTINCT inventory.film_id,title
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
ORDER BY title;

--this query WILL NOT WORK! because aggregate functions
--cannot be used with the WHERE clause
SELECT AVG(film.rental_rate)
FROM film
WHERE film.rental_rate > AVG(film.rental_rate);

--this is the correct way to use a subquery
SELECT film_id, title, rental_rate
FROM film
WHERE film.rental_rate > (SELECT AVG(film.rental_rate) FROM film)
ORDER BY rental_rate;

--EXISTS operator returns True or False if a record in it can be found
SELECT first_name,last_name 
FROM customer 
WHERE EXISTS(SELECT 1 FROM payment 
			 WHERE payment.customer_id = customer.customer_id);

--example of a basic update (actually does not work because of constraints)
--e.g CHECK(first_name != NULL)
UPDATE actor SET first_name = NULL WHERE actor_id = 102;

--this does work, because it's not a null value
UPDATE actor SET first_name = 'Charlie',last_name = 'Jones' WHERE actor_id = 102;

--find the longest films and group them into the query results
SELECT film.title,film.length 
FROM film 
INNER JOIN film_category ON film.film_id = film_category.film_id 
WHERE film.length >= (SELECT MAX(film.length) FROM film) 
					  GROUP BY film_category.category_id,film.title,film.length;

--ANY statement, SOME is also valid syntax
--works similar to IN statement, but <> ANY is different from NOT IN
SELECT title, category_id
FROM film
INNER JOIN film_category USING(film_id)
WHERE category_id = ANY(SELECT category_id
						FROM category
						WHERE NAME = 'Action'
						OR NAME = 'Drama');

--COALESCE,ISNULL,ifNULL etc... all allow substitute of a value if 
--the value would otherwise be null, which can cause reporting issues
SELECT COALESCE(NULL,2,1);

--select all film categories, and all films, regardless if
--they have matching rows in category and film category
SELECT film.title,category.name
FROM category 
LEFT JOIN film_category ON film_category.category_id = category.category_id 
LEFT JOIN film ON film.film_id = film_category.film_id 
ORDER BY category.name;




