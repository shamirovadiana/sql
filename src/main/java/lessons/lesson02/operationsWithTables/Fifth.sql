--#5
CREATE TABLE faculties(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);
CREATE TABLE groups_(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	facultyId INTEGER,
	FOREIGN KEY (facultyId) REFERENCES faculties(id)
);
CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	groupId INTEGER,
	FOREIGN KEY (groupId) REFERENCES groups_(id)
);
CREATE TABLE teachers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);
CREATE TABLE courses(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	teacherId INTEGER,
	FOREIGN KEY (teacherId) REFERENCES teachers(id)
);
CREATE TABLE student_courses(
	id SERIAL PRIMARY KEY,
	studentId INTEGER,
	courseId INTEGER,
	grade INTEGER DEFAULT 0 CHECK(grade >= 1 AND grade <= 5)
);