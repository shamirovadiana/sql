--Пример №1
--CREATE TABLE sales (
--   id SERIAL PRIMARY KEY,
--   region VARCHAR(20),
--   amount BIGINT,
--   sale_date DATE
--);

--INSERT INTO sales (region, amount, sale_date) VALUES
--('North', 1000, '2024-01-01'),
--('South', 700, '2024-01-02'),
--('North', 500, '2024-01-03'),
--('West', NULL, '2024-01-04'),
--('South', 900, '2024-01-05'),
--('North', 1500, '2024-01-06');

--Задание
--Найди сумму продаж по каждому региону.
SELECT region, SUM(amount) as total_sum FROM sales
GROUP BY region
ORDER BY total_sum ASC

--Покажи среднюю сумму продаж по регионам, где больше одной продажи.
SELECT region, AVG(amount) AS average_sum
FROM sales
GROUP BY region
HAVING COUNT(region) > 1
ORDER BY average_sum ASC

--Найди регион с максимальной суммой продаж.
SELECT region, MAX(amount) FROM sales
GROUP BY region
ORDER BY region ASC
LIMIT 1

--Выведи общее количество продаж и сколько из них имеют ненулевую сумму.
SELECT COUNT(amount) as total_count FROM sales

SELECT region, COUNT(amount) FROM sales
WHERE amount > 0
GROUP BY region

--Покажи регионы, где продажи превышают среднюю по всем регионам.
SELECT region, SUM(amount)
FROM sales GROUP BY region
HAVING SUM(amount) >
(
 SELECT AVG(amount) FROM sales
)

--Пример №2
--CREATE TABLE students (
--                         student_id SERIAL PRIMARY KEY,
--                         first_name VARCHAR(50) NOT NULL,
--                         last_name VARCHAR(50) NOT NULL,
--                         birth_date DATE NOT NULL,
--                         email VARCHAR(100) UNIQUE,
--                         group_id INT NOT NULL
--);
--Задание
--Напишите INSERT для заполнения таблицы
INSERT INTO students (first_name, last_name, birth_date, email, group_id) VALUES
('Алексей', 'Иванов', '2005-10-12', 'ivanov05@gmail.com', 1),
('Алексей', 'Иванов', '2004-05-19', 'aleksey04@gmail.com', 2),
('Мария', 'Петрова', '2005-06-20', 'mariya2005@gamil.com',1),
('Мария', 'Петрова', '2004-07-10', 'masha2004@gmail.com', 2),
('Дмитрий', 'Соколов', '2005-10-25', 'dmitriy05@gmail.com',1),
('Дмитрий', 'Соколов', '2004-10-10', 'sokolov@gmail.com',2);

--Найти дубликаты по имени и фамилии студента
SELECT first_name, last_name, COUNT(*)
FROM students
GROUP BY first_name, last_name
HAVING COUNT(*) > 1

--Удалить дубликаты, оставить только первую запись
DELETE FROM students
WHERE student_id NOT IN(
 SELECT MIN(student_id)
 FROM students
 GROUP BY first_name, last_name
)

--Пример №3
--CREATE TABLE students (
--   student_id INT PRIMARY KEY,
--   full_name VARCHAR(100),
--   age INT,
--   group_id INT
--);

--CREATE TABLE groups (
--   group_id INT PRIMARY KEY,
--   group_name VARCHAR(50)
--);

--CREATE TABLE subjects (
--   subject_id INT PRIMARY KEY,
--   subject_name VARCHAR(50)
--);

--CREATE TABLE grades (
--   grade_id INT PRIMARY KEY,
--   student_id INT,
--   subject_id INT,
--   grade INT,
--   FOREIGN KEY (student_id) REFERENCES students(student_id),
--   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
--);

--Задание
--Напишите INSERT для заполнения таблиц
--(Не знаю можно было или нет, я поменяла int на serial, чтобы вручную не вводить)
INSERT INTO groups(group_id, group_name) VALUES
(1, 'МАТ-201'),
(2, 'МАТ-302');

INSERT INTO students(full_name, age, group_id) VALUES
('Александр Смирнов', 20, 2),
('Екатерина Орлова', 21, 1),
('Данил Фёдоров', 19, 2),
('Валерия Никитина', 22, 2),
('Максим Громов', 23, 1),
('Анастасия Морозова', 20, 1);

INSERT INTO subjects(subject_name) VALUES
('Математика'),
('Физика'),
('Химия'),
('Литература');

INSERT INTO grades(student_id, subject_id, grade) VALUES
(1,1,7),
(1,2,4),
(1,3,8),
(1,4,4),
(2,1,6),
(2,2,5),
(2,3,8),
(2,4,9),
(3,1,6),
(3,2,6),
(3,3,7),
(3,4,8),
(4,1,6),
(4,2,7),
(4,3,9),
(4,4,10),
(5,1,5),
(5,2,5),
(5,3,5),
(5,4,7),
(6,1,8),
(6,2,5),
(6,3,4),
(6,4,4);

--Подсчитайте количество студентов в университете.
SELECT COUNT(*) FROM students

--Найдите средний возраст студентов.
SELECT AVG(age) FROM students

--Определите минимальный и максимальный возраст студентов.
SELECT MIN(age), MAX(age) FROM students

--Подсчитайте, сколько всего оценок выставлено.
SELECT COUNT(*) FROM grades

--Подсчитайте, сколько студентов учится в каждой группе.
SELECT group_id, COUNT(*)
FROM students
GROUP BY group_id

--Найдите средний возраст студентов по каждой группе.
SELECT group_id, AVG(age)
FROM students
GROUP BY group_id
ORDER BY group_id

--Определите средний балл по каждому предмету.
SELECT subject_id, AVG(grade) FROM grades
GROUP BY subject_id
ORDER BY subject_id

--Найдите количество студентов, у которых есть оценки по каждому предмету.
SELECT student_id, COUNT(student_id) as student_count, COUNT(subject_id) as subject_count
FROM grades
GROUP BY student_id
HAVING COUNT(subject_id) = MAX(subject_id)
ORDER BY student_id ASC

--Выведите только те группы, где учится больше 1 студента.
SELECT group_id, COUNT(student_id) FROM students
GROUP BY group_id
HAVING COUNT(student_id) > 1
ORDER BY group_id ASC

--Покажите предметы, где средний балл выше 8.
SELECT subject_id, AVG(grade)
FROM grades group by subject_id
having AVG(grade) > 8
ORDER BY subject_id

--Найдите студентов, у которых средний балл по всем предметам выше 8.5.
SELECT student_id,AVG(grade)
FROM grades group by student_id
having AVG(grade) > 8.5
ORDER BY student_id

