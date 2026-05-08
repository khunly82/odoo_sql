-- 1. The Product-Category Bridge Horizontal
-- Select the product_name and its associated category_name.
-- Tables: products, categories

SELECT
    c.category_name,
    p.product_name
FROM categories c JOIN products p ON c.category_id = p.category_id;

--2. Regional Footprint Vertical
-- Combine the city column from customers and the city column from suppliers into a
-- single list of unique cities.
-- Tables: customers, suppliers
SELECT city FROM customers
UNION
SELECT city FROM suppliers;
-- 3. Employee Order Tracking Horizontal
-- List every order_id and the first_name of the employee who took the order.
-- Tables: orders, employees

SELECT
    o.order_id,
    e.first_name
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id;

-- Create a two-column list.
-- Column 1: contact_name. Column 2: A label (string literal)
-- 'Customer' or 'Supplier'
-- depending on which table the row came from.

SELECT contact_name, 'customer' FROM customers
UNION
SELECT contact_name, 'supplier' FROM suppliers;

SELECT
    o.order_id,
    c.company_name AS customer,
    s.company_name AS shipper
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shippers s ON o.ship_via = s.shipper_id;

-- 6. Supplier Inventory Horizontal
-- Show product_name, category_name, and the supplier's company_name.
-- Sort the results by category name.
-- Tables: products, categories, suppliers

SELECT
    p.product_name, c.category_name, s.company_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON s.supplier_id = p.supplier_id
ORDER BY c.category_name;

-- 7. Staff & Management List Vertical
-- Produce a list of all names in the company.
-- Combine first_name and last_name from
-- employees and any contact_name
-- from customers located in 'London'.
-- Tables: employees, customers
SELECT last_name || ' ' || first_name, city
FROM employees
WHERE city ILIKE 'london'
UNION
SELECT contact_name, city
FROM customers
WHERE city ILIKE 'london';

-- 8. Detailed Order Breakdown Horizontal
-- For each order detail,
-- show the order_id, product_name,
-- and the total price calculated as
-- (unit_price * quantity).
-- Tables: order_details, products
SELECT order_id, product_name,
       od.unit_price * od.quantity AS total_price
FROM order_details od
JOIN products p ON p.product_id = od.product_id;
-- 9. Territory & Region Audit Horizontal
-- Show a list of employees and the region_description they are assigned to. This requires
-- traversing through employee_territories and territories to reach region.
-- Tables: employees, employee_territories, territories, region
SELECT
    distinct
    e.last_name,
    r.region_description
FROM employees e
JOIN employee_territories et ON e.employee_id = et.employee_id
JOIN territories t ON et.territory_id = t.territory_id
JOIN region r ON r.region_id = t.region_id;


--10. The Grand Summary DIFFICULTY: 10/10 Vertical
--Create a query that returns two columns: ReportItem and TotalCount. Row 1: 'Total
--Customers' and the count of customers. Row 2: 'Total Suppliers' and the count of suppliers. Row
--3: 'Total Products' and the count of products. Use UNION to combine these counts into one
--vertical report.
--Tables: customers, suppliers, products
SELECT 'customers' AS report_item, count(*) AS total_count FROM customers
UNION
SELECT 'products', count(*) FROM products
UNION
SELECT 'suppliers', count(*) FROM suppliers

