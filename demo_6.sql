CREATE TEMP TABLE temp_data (name VARCHAR(50), unit_price decimal(11,2), diff decimal(11,2));

DO $$
DECLARE
    my_variable INT;
BEGIN
    TRUNCATE temp_data;
    SELECT MAX(unit_price) INTO my_variable FROM products;
    INSERT INTO temp_data (SELECT
        product_name,
        unit_price,
        my_variable - unit_price AS diff
    FROM products);
END $$ language plpgsql;

SELECT * FROM temp_data;

CREATE OR REPLACE FUNCTION get_countries()
RETURNS TABLE (iso CHAR(2), name VARCHAR(255), population INT) AS
$$
import requests

list = requests.get('https://restcountries.com/v3.1/all?fields=name,population,cca2')

return [{
    "iso": item["cca2"],
    "name": item["name"]["common"],
    "population": item["population"]
} for item in list.json()]

$$ language plpython3u;


SELECT * FROM get_countries() WHERE iso = 'BE';


CREATE OR REPLACE VIEW v_employee AS
SELECT
    employee_id, title, last_name, first_name, title_of_courtesy
FROM employees;

SELECT * FROM v_employee;

CREATE INDEX idx_employee_last_name ON employees (last_name);
CREATE INDEX idx_employee_last_name ON employees (first_name, last_name);

REINDEX INDEX idx_employee_last_name;


CREATE PROCEDURE sp_insert_pokemon(
    number INT,
    name VARCHAR(50),
    evolvefrom INT
) language plpgsql AS $$
DECLARE
    count INT;
BEGIN
    IF evolvefrom IS NULL THEN
        INSERT INTO pokemon VALUES (number, name, evolvefrom);
    ELSE
        SELECT COUNT(*) INTO count FROM pokemon
        WHERE pokemon.evolve_from = evolvefrom;
        IF count > 3 THEN
            RAISE PLPGSQL_ERROR;
        ELSE
            INSERT INTO pokemon VALUES (number, name, evolvefrom);
        END IF;
    END IF;
END $$

CALL sp_insert_pokemon(154, 'Thierry', 133);

SELECT * FROM pokemon