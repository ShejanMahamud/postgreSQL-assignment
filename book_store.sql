-- Active: 1750915286560@@127.0.0.1@5432@bookstore_db
CREATE TABLE books (
    id SERIAL NOT NULL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK(price >= 0),
    stock INTEGER NOT NULL,
    published_year SMALLINT CHECK(published_year BETWEEN 1000 AND 9999)
);

CREATE TABLE customers (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    joined_date DATE DEFAULT current_date
);

CREATE TABLE orders (
    id SERIAL NOT NULL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    book_id INTEGER NOT NULL REFERENCES books(id),
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    order_date TIMESTAMP NOT NULL DEFAULT current_timestamp
);

INSERT INTO books (title, author, price, stock, published_year) VALUES ('The Pragmatic Programmer','Andrew Hunt',40.00, 10,1999),('Clean Code','Robert C. Martin',35.00,5,2008),('You Don''t Know JS','Kyle Simpson',30.00,8,2014),('Refactoring','Martin Fowler',50.00,3,1999),('Database Design Principles','Jane Smith ',20.00,0,2018);
INSERT INTO customers (name, email, joined_date) VALUES ('Alice','alice@email.com','2023-01-10'),('Bob','bob@email.com','2022-05-15'),('Charlie','charlie@email.com','2023-06-20');
INSERT INTO orders (customer_id,book_id,quantity,order_date) VALUES (1,2,1,'2024-03-10'), (2,1,1,'2024-02-20'), (1,3,2,'2024-03-05');


SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- 1️⃣ Find books that are out of stock.

SELECT title FROM books WHERE stock = 0;

-- 2️⃣ Retrieve the most expensive book in the store.
SELECT * FROM books WHERE price = (SELECT max(price) FROM books);

-- 3️⃣ Find the total number of orders placed by each customer.

SELECT c.name, count(o.id) AS total_orders FROM orders o JOIN customers c ON o.customer_id = c.id GROUP BY c.name;

-- 4️⃣ Calculate the total revenue generated from book sales.

SELECT sum(b.price * o.quantity) as total_revenue FROM orders o JOIN books b ON o.book_id = b.id;

-- 5️⃣ List all customers who have placed more than one order.
SELECT c.name, COUNT(o.id) AS orders_count FROM orders o JOIN customers c ON o.customer_id = c.id GROUP BY c.name HAVING COUNT (o.id) > 1;

-- 6️⃣ Find the average price of books in the store.
SELECT AVG(books.price)::NUMERIC(10,2) AS avg_book_price FROM books;

-- 7️⃣ Increase the price of all books published before 2000 by 10%.
UPDATE books SET price = price + price/10 WHERE published_year < 2000;

-- 8️⃣ Delete customers who haven't placed any orders.
DELETE FROM customers WHERE NOT EXISTS (SELECT 1 FROM orders WHERE orders.customer_id = customers.id);