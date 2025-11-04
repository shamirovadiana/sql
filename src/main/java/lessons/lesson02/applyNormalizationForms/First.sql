--SQL. Lesson 02
--Применить формы нормализации
--#1
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	product_id INTEGER,
	amount INTEGER,
    product_price NUMERIC(10,2),
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(product_id) REFERENCES products(id)
);
CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	customer_name TEXT NOT NULL,
    customer_email VARCHAR(30) UNIQUE
);
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL
);
