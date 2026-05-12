SELECT c.category_name, p.product_name
FROM categories c
CROSS JOIN LATERAL (
    SELECT * FROM products
    WHERE c.category_id = category_id
    LIMIT 3
) p;

SELECT * FROM string_to_table('test,test1,test2', ',')

CREATE TABLE book (
    id INT,
    name VARCHAR(50),
    categories VARCHAR(255)
);

INSERT INTO book (id, name, categories) VALUES
(1, 'The Great Gatsby', 'Classic|Fiction|Drama'),
(2, 'The Hobbit', 'Fantasy|Adventure|Children'),
(3, 'A Brief History of Time', 'Science|Non-Fiction|Physics'),
(4, 'The Shining', 'Horror|Thriller|Suspense'),
(5, 'The Alchemist', 'Philosophy|Adventure|Inspirational'),
(6, 'Dune', 'Sci-Fi|Space Opera|Politics'),
(7, 'Sherlock Holmes: A Study in Scarlet', 'Mystery|Detective|Crime');

SELECT id, name, cat FROM book b
CROSS JOIN LATERAL (
    SELECT string_to_table(categories, '|') cat FROM book b2
    WHERE b.id = b2.id
);