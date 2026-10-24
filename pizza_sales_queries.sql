-- =====================================================
-- Pizza Sales Analysis (PostgreSQL)
-- Author: Prem Kumar
-- Tables: orders, order_details, pizzas, pizza_types
-- =====================================================

-- ---------- Table creation ----------
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY NOT NULL,
    order_id         INT NOT NULL,
    pizza_id         VARCHAR(50),
    quantity         INT
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    date       DATE,
    order_time TIME
);

DROP TABLE IF EXISTS pizza_types;
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(100),
    name          VARCHAR(100),
    category      VARCHAR(100),
    ingredients   VARCHAR(150)
);

CREATE TABLE pizzas (
    pizza_id      VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size          VARCHAR(50),
    price         NUMERIC(10,2)
);

-- Import the 4 CSV files (data folder) into these tables, Header = ON.
-- Check the data after import:
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;


-- =====================================================
-- BASIC
-- =====================================================

-- Q1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_number
FROM orders;


-- Q2. Calculate the total revenue generated from pizza sales.
SELECT SUM(od.quantity * p.price) AS total_sales
FROM pizzas p
JOIN order_details od
ON od.pizza_id = p.pizza_id;


-- Q3. Identify the highest-priced pizza.
SELECT * FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);

-- or (with pizza name)
SELECT pt.name, p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Q4. Identify the most common pizza size ordered.
SELECT p.size, COUNT(od.order_details_id) AS order_count
FROM pizzas p
JOIN order_details od
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;


-- Q5. List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name, SUM(od.quantity) AS sum_of_quantity
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY sum_of_quantity DESC
LIMIT 5;


-- =====================================================
-- INTERMEDIATE
-- =====================================================

-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.category;


-- Q7. Find the category-wise distribution of pizzas.
SELECT category, COUNT(name)
FROM pizza_types
GROUP BY category;


-- Q8. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(quantity), 0)
FROM (
    SELECT o.date, SUM(od.quantity) AS quantity
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY o.date
) AS order_quantity;


-- Q9. Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name, SUM(p.price * od.quantity) AS total_sales
FROM pizzas p
JOIN order_details od
ON p.pizza_id = od.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sales DESC
LIMIT 3;


-- =====================================================
-- ADVANCED
-- =====================================================

-- Q10. Calculate the percentage contribution of each pizza category to total revenue.
SELECT
    pt.category,
    SUM(p.price * od.quantity) AS category_sales,
    SUM(p.price * od.quantity) * 100.0 /
    (
        SELECT SUM(p2.price * od2.quantity)
        FROM order_details od2
        JOIN pizzas p2
            ON p2.pizza_id = od2.pizza_id
    ) AS revenue_percentage
FROM pizzas p
JOIN order_details od
    ON p.pizza_id = od.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


-- Q11. Analyze the cumulative revenue generated over time.
SELECT sales.date,
       SUM(sales.revenue) OVER (ORDER BY sales.date) AS cum_revenue
FROM (
    SELECT o.date, SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON od.pizza_id = p.pizza_id
    GROUP BY o.date
) AS sales;


-- Q12. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, revenue
FROM (
    SELECT category, name, revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS revenue
        FROM pizza_types pt
        JOIN pizzas p
        ON pt.pizza_type_id = p.pizza_type_id
        JOIN order_details od
        ON od.pizza_id = p.pizza_id
        GROUP BY pt.category, pt.name
    ) AS a
) AS b
WHERE rn <= 3;
