-- GET ALL the values of a table
SELECT * FROM order_details
WHERE product_id = 2;

SELECT
    product_id AS id,
    product_name AS "product name",
    unit_price
FROM products;

SELECT
    product_name,
    unit_price * units_in_stock AS price_in_stock,
    unit_price * units_on_order AS total_sold
FROM products;

SELECT  * FROM products
ORDER BY units_in_stock DESC, product_name
OFFSET 10
    LIMIT 10;


SELECT
    customer_id,
    date_part('Y', order_date)
FROM orders;

SELECT
    stddev(unit_price)
FROM products;

-- SELECT
--     category_id,
--     AVG(unit_price) AS avg_price,
--     string_agg(product_name, ' - ')
-- FROM products
-- GROUP BY category_id;

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