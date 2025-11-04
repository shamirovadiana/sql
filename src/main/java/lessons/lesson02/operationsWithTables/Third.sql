--#3
CREATE TABLE categories(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	price NUMERIC(10,4) CHECK (price > 0),
	categoryId INTEGER,
	FOREIGN KEY (categoryId) REFERENCES categories (id)
);