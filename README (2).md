# Pizza Sales Analysis using SQL

A SQL project that answers 12 business questions about pizza sales of **Pizza Resto** using **PostgreSQL** (pgAdmin).

## Dataset (CSV files in the `data` folder)
| File | Description |
|---|---|
| `orders.csv` | Order id, date and time of every order |
| `order_details.csv` | Pizza ids and quantity for each order |
| `pizzas.csv` | Pizza size and price |
| `pizza_types.csv` | Pizza name, category and ingredients |

## Questions solved
1. Total number of orders placed
2. Total revenue from pizza sales
3. Highest-priced pizza
4. Most common pizza size ordered
5. Top 5 most ordered pizza types with quantities
6. Total quantity ordered for each pizza category
7. Category-wise distribution of pizzas
8. Average number of pizzas ordered per day
9. Top 3 pizza types by revenue
10. Percentage contribution of each category to total revenue
11. Cumulative revenue over time
12. Top 3 pizza types by revenue within each category

## Key results
- Total orders: 21,350
- Total revenue: 817,860.05
- Most common size: L (18,526 orders)
- Highest-priced pizza: The Greek Pizza (35.95)
- Top revenue pizza: The Thai Chicken Pizza (43,434.25)
- About 138 pizzas ordered per day on average

## SQL concepts used
Joins, GROUP BY, aggregate functions, subqueries, window functions (`SUM() OVER`, `RANK() OVER`), ORDER BY and LIMIT.

## How to run
1. Create a database in PostgreSQL.
2. Run the CREATE TABLE part of `pizza_sales_queries.sql`.
3. Import the 4 CSV files from the `data` folder (order: pizza_types, pizzas, orders, order_details).
4. Run the queries one by one.

## Files
- `pizza_sales_queries.sql`: all tables and queries
- `Pizza_Sales_Presentation.pdf`: presentation with queries and outputs
- `data/`: CSV files

## Author
Prem Kumar
