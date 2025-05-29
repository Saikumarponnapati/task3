
# Sakila SQL Analysis – task3.sql

This SQL script demonstrates various key SQL operations using the Sakila sample database. It showcases query techniques such as filtering, grouping, joining tables, using subqueries, creating views, and optimizing queries using indexes.

## Contents

The script covers the following SQL concepts:

### a. SELECT, WHERE, ORDER BY, GROUP BY

Counts the total number of rentals per customer from 2005 onward, sorted by highest rental count:

```sql
SELECT customer_id, COUNT(*) AS total_rentals
FROM rental
WHERE rental_date >= '2005-01-01'
GROUP BY customer_id
ORDER BY total_rentals DESC;
```

### b. JOINS (INNER, LEFT, RIGHT)

* INNER JOIN: Lists films and their associated categories
* LEFT JOIN: Lists all customers along with any rentals (if available)
* RIGHT JOIN: Displays rentals and corresponding customer information (if available)

```sql
-- INNER JOIN
SELECT f.title, c.name AS category
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id;

-- LEFT JOIN
SELECT c.first_name, c.last_name, r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

-- RIGHT JOIN
SELECT r.rental_id, c.first_name
FROM customer c
RIGHT JOIN rental r ON c.customer_id = r.customer_id;
```

### c. Subqueries

* Retrieves customers who rented films in the "Action" category
* Calculates rental count per film using a subquery in SELECT

```sql
-- Customers who rented "Action" films
SELECT DISTINCT customer_id
FROM rental
WHERE inventory_id IN (
  SELECT i.inventory_id
  FROM inventory i
  JOIN film_category fc ON i.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Action'
);

-- Total rentals per film
SELECT title,
  (SELECT COUNT(*) FROM rental r
   JOIN inventory i ON r.inventory_id = i.inventory_id
   WHERE i.film_id = f.film_id) AS rental_count
FROM film f;
```

### d. Aggregate Functions (SUM, AVG)

Calculates the average and total payment amount by each customer:

```sql
SELECT customer_id,
       SUM(amount) AS total_spent,
       AVG(amount) AS avg_payment
FROM payment
GROUP BY customer_id;
```

### e. Create Views

Creates a view top\_10\_films to show the ten most rented films:

```sql
CREATE VIEW top_10_films AS
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;
```

To use the view:

```sql
SELECT * FROM top_10_films;
```

### f. Optimize Queries with Indexes

Adds indexes on columns frequently used in filtering and joining:

```sql
CREATE INDEX idx_rental_customer ON rental(customer_id);
CREATE INDEX idx_payment_customer ON payment(customer_id);
CREATE INDEX idx_inventory_film ON inventory(film_id);
```

## Usage

1. Ensure the Sakila database is imported into your MySQL environment.
2. Open your SQL client (e.g., MySQL Workbench, DBeaver).
3. Run the script task3.sql.

This will execute all defined operations for analysis and performance optimization.

## License

This project is for educational and demonstration purposes only. Sakila is provided by MySQL under an open license.

Let me know if you’d like this in downloadable form or included as a .md file alongside the SQL.
