--#2
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);
CREATE TABLE order_items(
	order_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (order_id, product_id)
);