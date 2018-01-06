--Insert Statements & More
INSERT INTO film (title,description,release_year,
				rental_duration,rental_rate,length,replacement_cost,rating,language_id) 
VALUES('Harry Potter 1','wizard adventure film',2003,1,5.99,90,1.99,'PG-13',1);

--LEFT JOIN returns all films, even if there is no inventory for them
--this is the intentional behavior and is proved by the LIKE statement
--as Harry Potter inserted above doesn't yet have any inventory, but still appears in the results
SELECT film.film_id,film.title,inventory.inventory_id 
FROM film 
LEFT JOIN inventory ON inventory.film_id = film.film_id
WHERE film.title LIKE 'H%' ORDER BY film.film_id DESC;