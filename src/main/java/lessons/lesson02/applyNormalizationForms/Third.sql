--#3
CREATE TABLE customers(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);
CREATE TABLE addresses(
	id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	city TEXT,
	region TEXT,
	FOREIGN KEY(customer_id) REFERENCES customers(id)
);