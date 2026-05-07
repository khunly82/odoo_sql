SELECT
    category_id,
    AVG(unit_price) AS avg_price,
    string_agg(product_name, ' - '),
    -- get the standard deviation
    stddev(unit_price)
FROM products
GROUP BY category_id;

SELECT
    product_name,
    category_id,
    AVG(unit_price) OVER(PARTITION BY category_id),
    string_agg(product_name, ' - ') OVER(PARTITION BY category_id)
FROM products;

SELECT
    customer_id,
    freight,
    sum(freight) OVER (PARTITION BY customer_id ORDER BY order_date),
    @(freight - lag(freight) OVER (partition by customer_id ORDER BY order_date))
FROM orders;

-- WITH HAVING
EXPLAIN ANALYSE
SELECT
    order_id,
    sum(quantity)
FROM order_details
GROUP BY order_id
HAVING order_id BETWEEN 10480 AND 10500;

-- WITH WHERE
EXPLAIN ANALYSE
SELECT
    order_id,
    sum(quantity)
FROM order_details
WHERE order_id BETWEEN 10480 AND 10500
GROUP BY order_id;

SELECT
    date_part('year', order_date),
    case
        when date_part('month', order_date) <= 6 THEN 'first semester'
        else 'second semester' end semester,
    avg(freight)
FROM orders
GROUP BY
    date_part('year', order_date),
    case
        when date_part('month', order_date) <= 6 THEN 'first semester'
        else 'second semester'
    end;



