--Q1
SELECT * 
From customer 
Where last_name LIKE 'T%'
ORDER BY first_name ASC; 

-- Q2
SELECT * 
FROM rental 
WHERE return_date >= '2005-05-28' AND return_date <= '2005-06-01';

-- Q3

SELECT film.title AS movie_title, COUNT (rental.rental_id) AS rental_count 
FROM film 
JOIN inventory ON film.film_id = inventory.film_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
GROUP BY film.title 
ORDER BY rental_count DESC 
LIMIT 10; 

-- Q4

SELECT
	customer.customer_id, 
	CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
	SUM(payment.amount) as total_spent 
	
FROM 
	customer 
JOIN 
	payment ON customer.customer_id = payment.customer_id 
GROUP BY 
	customer.customer_id, 
	customer.first_name, 
	customer.last_name 
ORDER BY 
	total_spent; 
	
-- Q5

SELECT 
	a.actor_id, 
	CONCAT(a.first_name, ' ', a.last_name) as actor_name, 
	COUNT(*) AS movie_count 
FROM 
	actor a 
JOIN 
	film_actor fa ON a.actor_id = fa.actor_id 
JOIN 
	film f ON fa.film_id = f.film_id 
JOIN 
	inventory i ON f.film_id = i.film_id 
JOIN 
	rental r ON i.inventory_id = r.inventory_id 
WHERE 
	EXTRACT(YEAR FROM r.rental_date) = 2006 
GROUP BY 
	a.actor_id, 
	actor_name 
ORDER BY 
	movie_count DESC 
LIMIT 
	1; 
	
-- Q6
--Explanation Plan:

--Query 4:
--1. Retrieve data from the customer table and the payment table.
--2. Create a column called "customer_name" and another column called "total_spent" which is the SUM of all payment amounts for each customer.
--3. Group the data by customer.
--4. Order the results by the total spent to show from the least spent to most spent.

--Query 5:
--1. Retrieve data from the actor, film_actor, film, and rental tables.
--2. Join the actor table with the film_actor table using the actor_id column.
--3. Join the film table using the film_id column.
--4. Join the rental table using the film_id column to filter rentals from the year 2006.
--5. Use the WHERE clause to filter rentals from the year 2006 using the EXTRACT(Year FROM r.rental_date) function.
--6. Group the data by actor_id and actor_name.
--7. Count the movies each actor was in using the COUNT(*) clause.
--8. Order the movie count data using the ORDER BY clause.
--9. Limit the results to 1 so only the actor with the most movies in 2006 is displayed.

-- Q7 

SELECT 
	c.name AS genre, 
	AVG(f.rental_rate) AS average_rental_rate 
	
FROM 
	film f 
JOIN
	film_category fc ON f.film_id = fc.film_id
JOIN 
	category c ON fc.category_id = c.category_id
GROUP BY 
	c.name;

-- Q8

SELECT 
	c.name AS cateogry_name, 
	COUNT(r.rental_id) AS total_rentals, 
	SUM(p.amount) AS total_sales 
FROM 
	category c 
JOIN 
	film_category fc ON c.category_id = fc.category_id 
JOIN
	inventory i ON fc.film_id = i.film_id 
JOIN 
	rental r ON i.inventory_id = r.inventory_id 
JOIN 
	payment p ON r.rental_id = p.rental_id 
GROUP BY 
	c.name 
ORDER BY 
	total_rentals DESC 
LIMIT 
	5; 

-- Extra Credit
SELECT 
	EXTRACT(MONTH FROM rental_date) AS rental_month, 
	EXTRACT (YEAR FROM rental_date) AS rental_year, 
	c.name AS category, 
	COUNT(*) AS total_rentals 
FROM 
	rental r 
JOIN 
	inventory i ON r.inventory_id = i.inventory_id 
JOIN 
	film_category fc ON i.film_id = fc.film_id 
JOIN 
	category c ON fc.category_id = c.category_id 
GROUP BY 
	rental_month, 
	rental_year, 
	category
ORDER BY 
	rental_month, 
	rental_year, 
	total_rentals DESC 