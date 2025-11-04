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

--Задания
-- #1 Вывести employee.id, employee.name, department.name — сотрудники без отдела должны показать No Department.
SELECT employee_id, employee_name, department
FROM(SELECT e.id AS employee_id, e.name AS employee_name, COALESCE(d.name, 'No Department') AS department
	FROM employees e
	LEFT JOIN departments d ON d.id = e.department_id
)
GROUP BY employee_id, employee_name, department
ORDER BY employee_id ASC

-- #2 Сотрудники, у которых есть менеджер (показать имя сотрудника и имя менеджера).
SELECT
name AS employee_name,
(SELECT name FROM employees WHERE id = e.manager_id) AS manager_name
FROM employees e
WHERE manager_id IS NOT NULL
GROUP BY manager_id, name
ORDER BY manager_id

-- #3 Отделы без сотрудников.
SELECT department, employee_id
FROM(SELECT e.department_id, e.id as employee_id, d.name AS department
	FROM employees e
    RIGHT JOIN departments d ON d.id = e.department_id
)
WHERE employee_id IS NULL
GROUP BY department, employee_id

-- #4 Все заказы с именем сотрудника и именем клиента — если employee или customer отсутствует,
--показывать No Employee / No Customer.
SELECT order_date, amount, COALESCE(e.name, 'No Employee') AS employee_name, COALESCE(c.name, 'No Customer') AS customer_name
FROM orders r
LEFT JOIN employees e ON r.employee_id  = e.id
LEFT JOIN customers c ON r.customer_id = c.id
GROUP BY order_date, amount, employee_name, customer_name

-- #5 Список заказов с товарами: для каждого заказа вывести order_id, product_name, quantity.
--Показать также заказы без позиций.
SELECT r.order_id,
(SELECT name FROM products WHERE id =r. product_id) AS product_name,
r.quantity
FROM order_items r
GROUP BY r.order_id, product_name, r.quantity

-- #6 Для каждого отдела — все заказы (через сотрудников этого отдела); включать отделы с нулём заказов.
SELECT d.name AS department_name, e.name AS employee_name, r.order_date, r.amount
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN orders r ON r.employee_id = e.id
ORDER BY d.name

-- #7 Найти пары клиентов и продуктов, которые этот клиент никогда не покупал
--(т.е. построить Cartesian клиент×продукт и исключить реальные покупки).
SELECT c.id AS customer_id, c.name AS customer_name, p.id AS product_id, p.name AS product_name
FROM (SELECT id, name FROM customers) c
LEFT JOIN orders o ON o.customer_id = c.id
WHERE c.id IS NULL
CROSS JOIN (SELECT id, name FROM products) p
ORDER BY c.id
--получилось только со всеми продуктами соединить:/
SELECT c.id AS customer_id, c.name AS customer_name, p.id AS product_id, p.name AS product_name
FROM (SELECT id, name FROM customers) c
CROSS JOIN (SELECT id, name FROM products) p
LEFT JOIN order_items o ON o.product_id = p.id
WHERE o.order_id IS NULL
ORDER BY c.id
--а тут получилось только с теми продуктами, которые вообще никто не покупал

-- #8 Показать, какие продукты никогда не продавались.
SELECT p.id, p.name FROM products p
LEFT JOIN order_items o ON p.id = o.product_id
WHERE o.product_id IS NULL
ORDER BY p.id

-- #9 Для каждого менеджера — показать суммарную сумму заказов, оформленных его подчинёнными.
SELECT manager_id,
(SELECT name FROM employees WHERE id = e.manager_id) AS manager_name,
SUM(o.amount) AS total_amount
FROM (SELECT id, name, manager_id FROM employees) e
RIGHT JOIN orders o ON o.employee_id = e.id
GROUP BY manager_id

-- #10 Общее количество заказов и суммарная выручка (amount).
SELECT COUNT(o.id) AS total_count, SUM(o.amount) AS total_amount FROM orders o

-- #11 Средняя и максимальная зарплата по отделам.
SELECT d.id AS department_id, d.name AS department_name,
(SELECT AVG(salary) FROM employees e WHERE e.department_id = d.id) AS average_salary,
(SELECT MAX(salary) FROM employees e WHERE e.department_id = d.id) AS max_salary
FROM departments d
GROUP BY department_id, department_name

-- #12 Для каждого заказа — общее количество товаров (sum quantity) и уникальных позиций (count distinct product_id).
SELECT o.id AS order_id, SUM(i.quantity) AS total_quantity, COUNT(DISTINCT(i.product_id)) AS distinct_quantity FROM orders o
LEFT JOIN order_items i ON o.id = i.order_id
GROUP BY o.id

-- #13 Топ-3 продукта по суммарной выручке (price*quantity).
SELECT p.name AS product_name, p.price*COALESCE(o.quantity, 0) AS total_sum FROM products p
LEFT JOIN order_items o ON p.id = o.product_id
GROUP BY product_name, total_sum
ORDER BY total_sum DESC
LIMIT 3

-- #14 Количество клиентов, у которых есть хотя бы один заказ.
SELECT c.name AS customer_name, COUNT(o.customer_id) AS order_count FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY customer_name
HAVING COUNT(o.customer_id)>=1

-- #15 Для каждого отдела — количество сотрудников, средняя зарплата, суммарная сумма заказов (через сотрудников этого отдела).
SELECT d.name AS department_name, AVG(e.salary) AS average_salary, SUM(o.amount) AS orders_sum
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN orders o ON o.employee_id = e.id
GROUP BY department_name
ORDER BY department_name

-- #16 Найти клиентов, чья средняя сумма заказа выше средней по всем заказам.
SELECT c.name AS customer_name, AVG(o.amount) AS average_customer_amount,
(SELECT AVG(amount) FROM orders) AS average_order_amount
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY customer_name
HAVING AVG(o.amount) > (SELECT AVG(amount) FROM orders)
ORDER BY customer_name

-- #17 Сформировать полное имя сотрудника
SELECT
id AS employee_id,
SUBSTRING(name, 1, position(' ' IN name)) AS first_name,
SUBSTRING(name, position(' ' IN name), length(name)) AS last_name
FROM employees
ORDER BY id

-- #18 Вывести дату заказа в формате DD.MM.YYYY HH24:MI.
SELECT id,
to_char(order_date, 'DD.MM.YYYY HH24:MI'),
amount,
employee_id,
customer_id
FROM orders
ORDER BY id

-- #19 Найти заказы старше N дней (параметр)
SELECT *,(CURRENT_DATE - order_date) AS time FROM orders
WHERE CURRENT_DATE - order_date > 2
ORDER BY id

-- #20 Для таблицы employees: заменить NULL в salary на 0 в вычислениях
-- и вывести salary + bonus (bonus = 10% для определённой позиции).
-- Добавила сотрудника с зарплатой null, чтобы проверить правильность выполнения
INSERT INTO employees(name, position, salary, department_id, manager_id) VALUES
('Isabella Rivera', 'Director', NULL, NULL, NULL);

SELECT id, name, position, department_id, manager_id,
CASE WHEN id = manager_id
THEN COALESCE(salary, 0) * 1.1
ELSE COALESCE(salary, 0)
END
AS salary
FROM employees


