-- Q1
ALTER TABLE rental
ADD COLUMN status VARCHAR(50);

UPDATE rental
SET status = subquery.status
FROM (
    SELECT 
        rental_id,
        CASE
            WHEN return_date IS NULL THEN 'Not Returned'
            WHEN return_date > rental_date + (film.rental_duration || ' days')::interval THEN 'Late'
            WHEN return_date < rental_date + (film.rental_duration || ' days')::interval THEN 'Early'
            ELSE 'On Time'
        END AS status
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
) AS subquery
WHERE rental.rental_id = subquery.rental_id;

SELECT * from rental;

-- Q2
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       a.address,
       ci.city,
       SUM(p.amount) AS total_payment_amount
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE ci.city IN ('Kansas City', 'Saint Louis')
GROUP BY c.customer_id, c.first_name, c.last_name, a.address, ci.city;

-- Q3

SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;

-- Q4
-- Separating the "category" and "film_category" tables helps manage data effectively and makes queries faster. 
-- The "category" table holds details about film categories, like their IDs and names. 
-- On the other hand, the "film_category" table acts as a bridge between films and categories, allowing many films to be linked to many categories.
-- This setup prevents confusion and reduces unnecessary data repetition in the database, making it more organized and efficient.

-- Q5
SELECT f.film_id, 
       f.title, 
       f.length
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date >= '2005-05-15' AND r.return_date <= '2005-05-31';

-- Q6
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate < (SELECT AVG(rental_rate) FROM film);

-- Q7
SELECT
    CASE
        WHEN return_date IS NULL THEN 'Not Returned'
        WHEN return_date > rental_date + (film.rental_duration || ' days')::interval THEN 'Late'
        WHEN return_date < rental_date + (film.rental_duration || ' days')::interval THEN 'Early'
        ELSE 'On Time'
    END AS return_status,
    COUNT(*) AS num_films
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY return_status;

-- Q8
SELECT
    film_id,
    title,
    length,
    PERCENT_RANK() OVER (ORDER BY length) AS duration_percentile
FROM
    film;
-- Q9

EXPLAIN SELECT film_id, 
       title, 
       rental_rate
FROM film
WHERE rental_rate < (SELECT AVG(rental_rate) FROM film);