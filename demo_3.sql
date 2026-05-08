EXPLAIN  ANALYSE
SELECT
       c.category_name,
       c.category_id,
       p.category_id,
       p.product_name
FROM categories c, products p
WHERE c.category_id = p.category_id;

EXPLAIN  ANALYSE
SELECT
    c.category_name,
    c.category_id,
    p.category_id,
    p.product_name
FROM categories c LEFT JOIN products p
ON c.category_id = p.category_id;

SELECT
    first_name || ' ' || last_name
FROM employees
UNION
-- UNION ALL
-- INTERSECT
-- EXCEPT
SELECT
    contact_name
FROM customers;

