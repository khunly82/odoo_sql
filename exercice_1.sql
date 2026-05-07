SELECT
    product_name,
    unit_price,
    units_in_stock
FROM products
WHERE units_in_stock > 0 AND unit_price > 50
ORDER BY unit_price DESC;

SELECT
    last_name || first_name AS full_name
    --concat(last_name, first_name) AS full_name
    --concat_ws('-', first_name, last_name)
FROM employees
WHERE city IN ('London', 'Redmond');

CREATE COLLATION case_insensitive (
    provider = 'icu',
    locale = 'en-US-u-ks-level1',
    deterministic = false
);

SELECT
    contact_name
FROM customers
WHERE city IN ('London', 'Paris')
    -- AND LEFT(contact_name, 1) = 'S'
    AND contact_name LIKE 's%' COLLATE case_insensitive;

-- The Late Summer Sales:
-- Find all orders in the Orders table
-- that were placed in August 1997
-- but have a Freight cost of more than $100.
SELECT *
FROM orders
-- WHERE order_date BETWEEN  '1997-08-01' AND '1997-08-31'
WHERE date_part('Y', order_date) = 1997
        AND date_part('month', order_date) = 8
    AND freight > 100

-- The "Contact" Audit:
-- Identify customers where the ContactName contains
-- the word "owner" (case-insensitive)
-- but the City is not "Mexico D.F.".

SELECT
    *
FROM customers
WHERE contact_title ILIKE '%owner%'
    AND city <> 'Mexico D.F.'


-- Shipping Urgency Label: From the Orders table,
-- display the OrderID, OrderDate, and RequiredDate.
-- Add a fourth column called Priority:
-- If the RequiredDate is within 7 days of the OrderDate,
-- label it 'Express'.
-- Otherwise, label it 'Standard'.
-- Note: Students will need to use DATEDIFF or simple subtraction depending on the SQL engine.
SELECT order_id, order_date, required_date,
    CASE
        WHEN required_date - order_date < 21 THEN 'Express'
        ELSE 'Standard'
    END AS priority
FROM orders

-- The Discounted Catalog: Display ProductName, UnitPrice,
-- and a new column called SalesPrice.
-- If the product belongs to CategoryID 1 or 2,
-- the SalesPrice is 10% off the UnitPrice.
-- For all other categories, the SalesPrice is 5% off.

SELECT
    product_name, unit_price,
    CASE
        WHEN category_id IN (1,2) THEN 0.9 * unit_price
        ELSE 0.95 * unit_price
    END AS sales_price
FROM products;

-- Postal Code Patterns:
-- List all customers from the Customers table
-- whose PostalCode starts with a digit between 0 and 5.
SELECT *
FROM customers
WHERE postal_code ~ '^[0-5]';

