--#4
CREATE TABLE customers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	phone VARCHAR(12) UNIQUE,
	email VARCHAR(30) UNIQUE
);
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	price NUMERIC(10,4) CHECK (price > 0)
);
CREATE TABLE orders(
	id SERIAL UNIQUE,
	customerId INTEGER,
	productId INTEGER,
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (customerId) REFERENCES customers(id),
	FOREIGN KEY (productId) REFERENCES products(id),
	PRIMARY KEY(id,customerId, productId)
);
CREATE TABLE order_items(
	orderId INTEGER,
	productId INTEGER,
	amount 	INTEGER,
	FOREIGN KEY (orderId) REFERENCES orders(id),
	FOREIGN KEY (productId) REFERENCES products(id),
	PRIMARY KEY(orderId, productId)
);