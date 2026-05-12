-- 1. Above Average Prices
-- Find all products that have a UnitPrice greater
-- than the average price of all products in the database.
-- Concepts: AVG(), Scalar Subquery in WHERE
SELECT * FROM products WHERE unit_price >= (
    SELECT AVG(unit_price) FROM products
);
-- 2. Specific Market Customers
-- List the CompanyName of all customers who
-- have placed at least one order
-- where the ShipCountry is 'Mexico'.
-- Concepts: IN operator, Subquery

SELECT company_name FROM customers
WHERE customer_id = ANY (
    SELECT customer_id
    FROM orders
    WHERE ship_country = 'Mexico'
);

-- 3. Price Gap Analysis
-- Display all products, their prices,
-- and a column showing the difference between
-- that product's price and the price of
-- the most expensive product in the catalog.
-- Concepts: Subquery in SELECT, Max()
SELECT
    product_name,
    unit_price,
    (SELECT MAX(unit_price) FROM products) - unit_price AS diff
FROM products;



-- 4. Category Champions
-- List the ProductName and UnitPrice
-- for products that have the maximum
-- unit price within their specific CategoryID .
-- Concepts: Correlated Subquery
SELECT product_name, unit_price, category_id FROM products p1
WHERE unit_price = (
    SELECT MAX(unit_price) FROM products p2
    WHERE p1.category_id = p2.category_id
);

-- 5. Inactive Customers
-- Find all customers who have never placed an order.
-- Use the NOT EXISTS operator for the implementation.
-- Concepts: NOT EXISTS, Correlation

SELECT * FROM customers
WHERE NOT EXISTS (
    SELECT FROM orders
    WHERE orders.customer_id = customers.customer_id
)

-- 6. High-Volume Cities (CTE)
-- Create a CTE that calculates total sales (Price * Quantity)
-- per City. Select from it to
-- find cities with sales exceeding $50,000.
-- Concepts: WITH clause, Basic CTE
WITH sales_by_city AS (
    SELECT ship_city, SUM(unit_price * quantity) AS total
    FROM order_details
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY ship_city
) SELECT * FROM sales_by_city WHERE total > 50000;

-- 7. Intra-Category Ranking
-- Display all products, their category name,
-- and their price rank within that
-- category (1 for most expensive).
-- Concepts: RANK(), OVER (PARTITION BY)
SELECT
    product_name,
    unit_price,
    rank() OVER (PARTITION BY category_id ORDER BY unit_price DESC)
FROM products;

-- 8. Running Freight Totals
-- For all orders in the year 1997,
-- show OrderID, OrderDate, and a running total of
-- the Freight cost sorted by date.
-- Concepts: SUM() OVER, Order sequencing
SELECT
    order_id,
    order_date,
    freight,
    SUM(freight) OVER(ORDER BY order_date, order_id)
FROM orders WHERE DATE_PART('YEAR', order_date) = 1997;


-- 9. Deviation from Regional Average
-- Show all orders including their Freight cost
-- and a column displaying the average
-- freight for the country it is being shipped to
-- (calculated using a window function).
-- Concepts: AVG() OVER (PARTITION BY)
SELECT
    order_id,
    freight,
    AVG(freight) OVER (PARTITION BY ship_country)
FROM orders;
-- 10. Management Hierarchy
-- Use a recursive CTE to show the employee management chain.
-- Display Employee
-- Name, Title, and their seniority
-- Level (1 for the top manager).
-- Concepts: WITH RECURSIVE, UNION ALL

WITH RECURSIVE employee_hierarchy AS (
    SELECT employee_id, last_name, title, 1 AS level,
           last_name::VARCHAR breadcrumb
    FROM employees WHERE reports_to IS NULL
    UNION ALL
    SELECT e.employee_id, e.last_name, e.title, eh.level + 1,
        eh.breadcrumb || ' > ' || e.last_name
    FROM employees e
    JOIN employee_hierarchy eh ON e.reports_to = eh.employee_id
) SELECT * FROM employee_hierarchy;


-- 11. Organizational Breadcrumbs
-- Extend the hierarchy query to generate a
-- full path string for each employee (e.g.,
-- "Andrew Fuller > Nancy Davolio").
-- Concepts: String Concatenation in Recursion

-- 12. Month-over-Month Growth
-- Calculate total sales per month.
-- Use the LAG() function to compare current
-- sales to the previous month and calculate
-- the growth percentage.
-- Concepts: LAG(), Advanced Analytics, Multiple CTEs

WITH total_sales_per_month AS (
    SELECT
        date_part('YEAR', order_date) AS year,
        date_part('MONTH', order_date) AS month,
        SUM(unit_price * quantity) AS total
    FROM order_details od
    JOIN orders o ON o.order_id = od.order_id
    GROUP BY year, month
    ORDER BY year, month
) SELECT
      *,
      (-1 + (total / LAG(total) OVER ())) * 100 AS growth
FROM total_sales_per_month;
