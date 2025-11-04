--#2
CREATE TABLE departments(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);
CREATE TABLE employees(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30),
	position TEXT NOT NULL,
	departmentId INTEGER,
	FOREIGN KEY (departmentId) REFERENCES departments (id) ON DELETE SET NULL
);