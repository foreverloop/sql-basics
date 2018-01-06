--finding the most common category of film, most common actors 
--and most common cities customers Live in

COPY(SELECT COUNT(film.film_id),category.name FROM film 
	INNER JOIN film_category ON film.film_id = film_category.film_id 
	INNER JOIN category ON film_category.category_id = category.category_id 
	GROUP BY category.name 
	ORDER BY COUNT(film.film_id) DESC) 
TO 'film_category_by_count.csv' (format CSV);

COPY(SELECT COUNT(film.film_id),actor.first_name,actor.last_name FROM actor 
	INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id 
	INNER JOIN film ON film.film_id = film_actor.film_id 
	GROUP BY actor.first_name,actor.last_name 
	ORDER BY COUNT(film.film_id) DESC) 
TO 'most_common_actors.csv' (format CSV);

COPY(SELECT city.city,COUNT(address.address_id) FROM customer 
	INNER JOIN address ON customer.address_id = address.address_id 
	INNER JOIN city ON address.city_id = city.city_id 
	GROUP BY city.city 
	ORDER BY COUNT(address.address_id) DESC LIMIT 5)
TO 'most_common_cities.csv' (format CSV);

--find a specific actor, list the films they were in, and how many copies
--we have in stock on the database
SELECT film.title,film.release_year,actor.actor_id,COUNT(inventory.film_id) 
FROM film 
INNER JOIN film_actor ON film.film_id = film_actor.film_id 
INNER JOIN actor ON film_actor.actor_id = actor.actor_id 
INNER JOIN inventory ON inventory.film_id = film.film_id 
WHERE actor.first_name = 'Walter' AND actor.last_name = 'Torn' 
GROUP BY actor.actor_id,film.title,film.release_year 
ORDER BY COUNT(inventory.film_id) DESC;

