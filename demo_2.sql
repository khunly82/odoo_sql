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