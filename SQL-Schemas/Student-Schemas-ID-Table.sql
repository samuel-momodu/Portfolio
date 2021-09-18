/*# This query is used to create a sample schema for a table.
# This table is used to record names, student identification number and majors of students.*/
CREATE TABLE student (
    student_id INT,
    name VARCHAR(20),
    major VARCHAR(20),
    PRIMARY KEY(student_id)
);
SELECT * 
FROM student
WHERE major IN ('Biology', 'Chemistry') AND student_id >2;
/*# We can use this to insert values into each column and row.*/
INSERT INTO student (student_id, name, major) VALUES(1, 'Mori', 'UI/UX');
INSERT INTO student (student_id, name, major) VALUES(2, 'Jack', 'Biology');
INSERT INTO student (student_id, name, major) VALUES(3, 'Kate', 'Sociology');
INSERT INTO student (student_id, name, major) VALUES(4, 'Claire', 'Chemistry');
INSERT INTO student (student_id, name, major) VALUES(5, 'jack', 'Biology');
INSERT INTO student (student_id, name, major) VALUES(6, 'Mike', 'Computer Science');

/*#For times whe we have incomplete values, we can use this.*/
INSERT INTO student(student_id, name) VALUES(3, 'Claire');

/*# We can continuer to insert into the table.*/
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');
INSERT INTO student VALUES(6, 'Samuel', 'COmputer Science');
/*# This is used to update or make corrections to rows and columns*/
UPDATE student
 SET major = 'Computer Science' 
 WHERE student_id = 6;
/*# We can also use update syntax to abbreviate data attributes in database tables*/
 
UPDATE student 
SET major = 'Comp Sci'
WHERE major = 'Computer Science';

UPDATE student 
SET major = 'Biochemistry'
WHERE major = 'Bio' OR major = 'Chemistry';