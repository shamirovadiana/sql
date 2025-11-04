--Таблицы для ДЗ

CREATE TABLE departments (
 id     SERIAL PRIMARY KEY,
 name   VARCHAR(50) NOT NULL,
 location VARCHAR(50)
);

CREATE TABLE employees (
 id           SERIAL PRIMARY KEY,
 name         VARCHAR(50) NOT NULL,
 position     VARCHAR(50),
 salary       NUMERIC(10,2),
 department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
 manager_id   INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
 id   SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 city VARCHAR(50)
);

CREATE TABLE orders (
 id          SERIAL PRIMARY KEY,
 order_date  DATE NOT NULL,
 amount      NUMERIC(10,2),
 employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
 customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
 id    SERIAL PRIMARY KEY,
 name  VARCHAR(100) NOT NULL,
 price NUMERIC(10,2)
);

CREATE TABLE order_items (
 id         SERIAL PRIMARY KEY,
 order_id   INTEGER REFERENCES orders(id) ON DELETE CASCADE,
 product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
 quantity   INTEGER NOT NULL
);

--Заполнение таблиц
INSERT INTO departments(name, location) VALUES
('IT', 'New York'),
('Marketing and Communications', 'San Francisco'),
('Human Resources and Staff Training', 'Chicago'),
('Financial and Economic', 'Dallas'),
('Research and Development', 'Boston');

INSERT INTO employees(name, position, salary, department_id, manager_id) VALUES
('Ethan Miller', 'Manager', 7000, 1, 1),
('Sophia Johnson', 'Software Engineer', 6000, 1, 1),
('Liam Davis', 'Network Administrator', 6500, 1, 1),
('Oliver Brown', 'Systems Analyst', 6000, 1, 1),
('Ava Thompson', 'Content Strategist', 5000, 2, NULL),
('Benjamin Harris', 'Public Relations Coordinator', 5000, 2, NULL),
('William Scott', 'Chief Financial Officer', 7500, 4, 7),
('Harper Adams', 'Financial Analyst', 7000, 4, 7),
('Lucas Baker', 'Accountant', 7000, 4, 7),
('Amelia Nelson', 'Budget Specialist', 7000, 4, 7),
('Alexander Campbell', 'Lead Research Scientist', 8000, 5, NULL),
('Luna Mitchell', 'Data Scientist', 8000, 5, NULL),
('Elijah Carter', 'Product Development Engineer', 8000, 5, NULL),
('Chloe Turner', 'Laboratory Technician', 7000, 5, NULL);

INSERT INTO employees(name, position, salary, department_id, manager_id) VALUES
('Michael Reed', 'Chief Executive Officer', 9000, NULL, NULL),
('Natalie Brooks', 'Office Administrator', 8000, NULL, NULL),
('Christopher Evans', 'Facilities Manager', 7500, NULL, NULL);

INSERT INTO customers(name, city) VALUES
('Emma Carter', 'Seattle'),
('Jacob Foster', 'Denver'),
('Avery Morgan', 'Miami'),
('Logan Bennett', 'Austin'),
('Scarlett Ramirez', 'Chicago'),
('Owen Phillips', 'Los Angeles');

INSERT INTO orders(order_date, amount, employee_id, customer_id) VALUES
('2025-10-25', 4500, 2, NULL),
('2025-10-20', 0, 3, 1),
('2025-10-28', 6000, 4, 2),
('2025-11-01', 1100, 7, 3),
('2025-10-27', 9000, 8, 4),
('2025-10-29', 5500, NULL, 5);

INSERT INTO products(name, price) VALUES
('Bread', 2.50),
('Milk', 3.20),
('Cheese', 5.80),
('Rice', 2.70),
('Butter', 4.60),
('Apple', 3.50),
('Orange Juice', 5);

INSERT INTO order_items(order_id, product_id, quantity) VALUES
(1, 1, 100),
(2, NULL, 0),
(3, 2, 200),
(4, 6, 100),
(5, 4, 150),
(6, 7, 100);

-- DDL использовать из урока 4.
-- Задания для практики подзапросов:
-- #1.Вывести сотрудников с зарплатой выше средней по компании
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
GROUP BY id
ORDER BY id

-- #2.Вывести продукты дороже среднего
SELECT  *, (SELECT AVG(price) AS average_price FROM products)
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY id

-- #3.Вывести отделы, где есть хотя бы один сотрудник с зарплатой > 10 000
-- Никого в таблицах с такой зарплатой не было, поэтому добавила
INSERT INTO employees(name, position, salary, department_id, manager_id) VALUES
('Zoe Patterson', 'Payroll Coordinator', 11000, 5, NULL);

SELECT d.id AS department_id, d.name AS department_name, e.name AS employee_name, e.position, e.salary
FROM departments d
RIGHT JOIN employees e ON e.department_id = d.id
WHERE e.salary > 10000
ORDER BY d.id

-- #4.Вывести продукты, которые чаще всего встречаются в заказах
INSERT INTO order_items(order_id, product_id, quantity) VALUES
(5, 2, 2);
-- Добавила, потому что в каждом заказе по 1 продукту
SELECT p.id, p.name, COUNT(o.product_id) AS product_count FROM products p
RIGHT JOIN order_items o ON p.id = o.product_id
GROUP BY p.id
ORDER BY product_count DESC
LIMIT 3

-- #5.Вывести для каждого клиента количество его заказов
INSERT INTO orders(order_date, amount, employee_id, customer_id) VALUES
('2025-10-27', 1000, 8, 4);
-- Добавила, потому что у всех по 1 заказу было
SELECT c.id, c.name, COUNT(o.id) AS order_count FROM customers c
RIGHT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id

-- #6.Вывести топ 3 отдела по средней зарплате
SELECT d.id, d.name, AVG(COALESCE(e.salary,0)) AS average_salary FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.id
ORDER BY average_salary DESC
LIMIT 3

-- #7.Вывести клиентов без заказов
SELECT c.id, c.name, COUNT(o.customer_id) FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id
HAVING COUNT(o.customer_id) = 0

-- #8.Вывести сотрудников, зарабатывающих больше, чем любой из менеджеров.
SELECT e.id, e.name, e.salary FROM employees e
GROUP BY e.id
HAVING e.salary >
ANY(SELECT e.salary FROM employees e WHERE e.id = e.manager_id)

-- #9.Вывести отделы, где все сотрудники зарабатывают выше 5000.
SELECT d.id AS department_id, d.name AS department_name, e.name AS employee_name, e.salary FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.id, e.name, e.salary
HAVING MIN(salary) > 5000
ORDER BY d.id

