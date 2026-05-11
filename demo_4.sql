
EXPLAIN ANALYSE
SELECT * FROM
    orders
WHERE customer_id = (
    SELECT customer_id FROM customers
    WHERE company_name LIKE 'Around the Horn'
);

EXPLAIN ANALYSE
SELECT o.* FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.company_name LIKE 'Around the Horn';


SELECT * FROM
    suppliers
WHERE contact_name ~ ANY (
    SELECT
        case
            when  customer_id = 'AROUT' THEN '^B'
            else '^A'
        end
    FROM customers
);

SELECT o2.order_id, SUM(od.unit_price * od.quantity)
FROM orders o2
JOIN order_details od ON o2.order_id = od.order_id
GROUP BY o2.order_id
HAVING  SUM(od.unit_price * od.quantity) > (
    SELECT AVG(s.total_by_order) FROM (
          SELECT SUM(od.unit_price * od.quantity) total_by_order
          FROM orders o
          JOIN order_details od ON o.order_id = od.order_id
          WHERE o.customer_id = o2.customer_id
          GROUP BY o.order_id
    )  s
);


SELECT
    product_name,
    unit_price
FROM products p1
WHERE unit_price > (
    SELECT AVG(unit_price) FROM products p2
    WHERE p1.category_id = p2.category_id
);


with orders_with_total_amount as (
    SELECT order_id,
           SUM(od.unit_price * od.quantity) as total,
           customer_id
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_id
), other_cte AS (SELECT * FROM customers)
SELECT * FROM orders_with_total_amount o1
WHERE total > (
    SELECT AVG(total) FROM orders_with_total_amount o2
    WHERE o1.customer_id = o2.customer_id
);

WITH recursive pokemon_tree AS (
    SELECT * FROM pokemon WHERE number = 147
    UNION ALL
    SELECT p.* FROM pokemon p
    JOIN pokemon_tree pt ON p.evolve_from = pt.number
)
SELECT * FROM pokemon_tree;


