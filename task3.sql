use sakila;
-- Total rentals per customer, ordered by most rentals
SELECT customer_id, COUNT(*) AS total_rentals
FROM rental
WHERE rental_date >= '2005-01-01'
GROUP BY customer_id
ORDER BY total_rentals DESC;
-- INNER JOIN: List films with their categories
SELECT f.title, c.name AS category
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id;

-- LEFT JOIN: List all customers and their rentals (including those who didn't rent)
SELECT c.first_name, c.last_name, r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

-- RIGHT JOIN: Less common, but here's an example
SELECT r.rental_id, c.first_name
FROM customer c
RIGHT JOIN rental r ON c.customer_id = r.customer_id;
-- Customers who have rented films in the "Action" category
SELECT DISTINCT customer_id
FROM rental
WHERE inventory_id IN (
    SELECT i.inventory_id
    FROM inventory i
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
);

-- Subquery in SELECT to show total rentals per film
SELECT title,
       (SELECT COUNT(*) FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        WHERE i.film_id = f.film_id) AS rental_count
FROM film f;
-- Average payment amount and total revenue by customer
SELECT customer_id,
       SUM(amount) AS total_spent,
       AVG(amount) AS avg_payment
FROM payment
GROUP BY customer_id;
-- View of top 10 most rented films
CREATE VIEW top_10_films AS
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- Use the view
SELECT * FROM top_10_films;
-- Index on foreign keys and commonly filtered columns
CREATE INDEX idx_rental_customer ON rental(customer_id);
CREATE INDEX idx_payment_customer ON payment(customer_id);
CREATE INDEX idx_inventory_film ON inventory(film_id);

