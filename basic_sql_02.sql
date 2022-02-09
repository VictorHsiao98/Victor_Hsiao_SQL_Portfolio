-- 01 - CREATE User Table
CREATE TABLE User(
	UserID INT(11) NOT NULL AUTO_INCREMENT,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (UserID),
	UNIQUE KEY (Email)
)ENGINE=InnoDB; 

-- 02 - List Tables
SHOW TABLES;

-- 03 - Confirm Table Structure
DESCRIBE User;

-- 04 - CREATE Tweet Table
CREATE TABLE Tweet(
	TweetID INT(11) NOT NULL AUTO_INCREMENT,
	Tweet VARCHAR(255) NOT NULL,
	UserID INT(11) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (TweetID)
)ENGINE=InnoDB;

-- 05 - Establish Relationship with a Foreign Key
ALTER TABLE Tweet 
ADD CONSTRAINT fk_Tweet_User_UserID FOREIGN KEY (UserID)
REFERENCES User (UserID);

DESCRIBE Tweet;

-- 06 - Delete Table to Recreate Table with Foreign Key
DROP TABLE Tweet;

-- 07 - Recreate Table with Foreign Key
CREATE TABLE Tweet(
	TweetID INT(11) NOT NULL AUTO_INCREMENT,
	Tweet VARCHAR(255) NOT NULL,
	UserID INT(11) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (TweetID),
	CONSTRAINT fk_Tweet_User_UserID FOREIGN KEY (UserID)
	REFERENCES User (UserID)
)ENGINE=InnoDB;

-- 08 - Confirm Table Structure
DESCRIBE Tweet;

-- 09 - INSERT 1 User
INSERT INTO `User`
(FirstName, LastName, Email)
VALUES
('Greg','Lontok','Gregory.lontok@lmu.edu'); 

-- 10 - Confirm INSERT
SELECT*
FROM User;

SELECT@@system_time_zone;

-- 11 - INSERT 2 Users at the Same Time
INSERT INTO `User`
(FirstName, LastName, Email)
VALUES
('John', 'Doe', 'john@doe.com'),
('Jane', 'Doe', 'Jane@doe.com');

-- 12 - Can List Columns in a Different Order from Table Structure
INSERT INTO `User` 
(Email, Lastname, FirstName)
VALUES
('bobsmith@gmail.com','Smith','Bob');

-- 13 - Use SET if Dealing with Many Columns
INSERT INTO `User` 
SET LastName = 'Johnson', FirstName = 'Mary', Email = 'mary@gmail.com'

-- 14 - Verify File Insert and Table Schema
SELECT *
FROM SupplierSales2010;

-- 15 - Spaces in the Column Name?!
SELECT `Order ID` , `Order Date` 
FROM SupplierSales2010 ss 
LIMIT 10;

-- 16 - Change Column Type - ALTER TABLE
DESCRIBE SupplierSales2010
ALTER TABLE SupplierSales2010 MODIFY `Order Date` DATETIME;
ALTER TABLE SupplierSales2010 MODIFY `Ship Date` DATETIME;

-- 17 - Copy Existing Table Structure
CREATE TABLE SupplierSales2011 LIKE SupplierSales2010;
SHOW TABLES;
DESCRIBE SupplierSales2011;

-- 18 - Verify File Insert
SELECT *
FROM SupplierSales2011 ss 
LIMIT 10;

-- 19 - Before a DELETE, confirm WHERE with a SELECT
SELECT *
FROM SupplierSales2011 ss 
WHERE `Order ID` = '443193900';

-- 20 - DELETE and Double Check WHERE
DELETE FROM SupplierSales2011
WHERE `Order ID` = '443193900';

-- 21 - As an extra precaution, LIMIT the # of rows deleted
DELETE FROM SupplierSales2011
WHERE `Order ID` = '443193900'
ORDER BY `Order ID`
LIMIT 1;

-- 22 - TRUNCATE to empty a table
TRUNCATE TABLE SupplierSales2011;
SELECT *
FROM SupplierSales2011;

-- 23 - UPDATE Jane's first name to Jill
Update User
SET FirstName = 'Jill'
WHERE FirstName = 'Jane';

-- 24 - Confirm UPDATE
SELECT *
FROM `User`
WHERE FirstName = 'Jill';

-- 25 - UPDATE Multiple Columns
Update User
SET FirstName = 'Bob',
	LastName = 'Miller'
WHERE FirstName = 'John'
	AND LastName = 'Doe';

SELECT *
FROM User;
-- 26 - Search and replace with UPDATE
UPDATE User
SET Email = REPLACE(Email, '@doe.com', '@lmu.edu')
WHERE Email LIKE '%@doe.com';

-- 27 - CREATE TABLE ... SELECT. Make a copy of the entire User table into a new table
CREATE TABLE User20210118 SELECT * FROM User;

SELECT * FROM User20210118;

-- 28 - INSERT INTO ... SELECT. Copy data from one table and insert into an existing table
INSERT INTO User20210118
SELECT *
FROM `User` 
WHERE CreatedOn BETWEEN '2021-01-19 08:00:00' AND '2021-01-21 09:00:00';

-- DDL Practice

-- Create a new database in LMU Build called school
-- You don't need to add anything here.

-- 29

-- Create a student table in the school database with the following columns: student_id, first_name, last_name, phone, email, advisor_id, and graduation_year
-- Write the CREATE TABLE statement and do not use the phpMyAdmin GUI to create the table.
CREATE TABLE student(
	student_id INT NOT NULL AUTO_INCREMENT,
	First_name VARCHAR(255),
	last_name VARCHAR(255),
	phone VARCHAR(255),
	email VARCHAR(255),
	advisor_id INT,
	graduation_year INT(4),
	created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (student_id),
	UNIQUE KEY uniq_phone (phone),
	UNIQUE KEY uniq_email (email),
	CONSTRAINT fk_student_teacher_advisor_id_teacher_id FOREIGN KEY (advisor_id) REFERENCES teacher(teacher_id)
	
) ENGINE=InnoDB;

SELECT *
FROM student;
-- 30
-- Create a teacher table in the school database with the following columns: teacher_id, first_name, last_name, phone, email
-- Write the CREATE TABLE statement and do not use the phpMyAdmin GUI to create the table.
CREATE TABLE teacher(
	teacher_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (teacher_id),
	UNIQUE KEY uniq_phone (phone),
	UNIQUE KEY uniq_email (email)

)ENGINE=InnoDB;

SELECT *
FROM teacher;

-- DML Practice

-- 31
-- Insert your favorite high school teacher into the teacher table in the school database. You can make up the phone number and email.
-- Do not use the phpMyAdmin GUI to insert the record.
INSERT INTO teacher
SET first_name = 'Bob',
	last_name = 'Oddo',
	phone = 3235997029,
	email = 'bob@oddo.com';

-- 32
-- Insert yourself as a student into the student table. Your advisor is your favorite high school teacher.
-- Do not use the phpMyAdmin GUI to insert the record.
INSERT INTO student 
SET first_name = 'Vic',
	last_name = 'Hsiao',
	phone = 1233214567,
	email = 'victorhsiao98@gmail.com',
	advisor_id = 1,
	graduation_year = 2023;

-- 33
-- Update your favorite high school teacher's phone number to 3103382700.
-- Do not use the phpMyAdmin GUI to update the record.
UPDATE teacher 
SET phone = 3103382700
WHERE phone = 3235997029;

-- 34
-- As a best practice, what should you do before deleting rows from a table?
SELECT *
FROM SupplierSales2011 ss 
WHERE `Order ID` = '443193900';
-- select all from a table where there is a certain condition, make sure
-- the data is there, then delete it. (use delete from)


-- DQL Practice

-- 35
-- How many payment transactions were greater than $4.00?
SELECT COUNT(*) AS "Number of Payments Greater than 4"
FROM payment
WHERE amount > 4;

-- 36
-- How many actors have a first name that starts with the letter S?
SELECT COUNT(*) AS "Number of Actors with the first name that starts with S"
FROM actor
WHERE first_name LIKE 'S%';

-- 37
-- How many unique districts are our customers from?
SELECT COUNT(DISTINCT district) AS "Number of Unique Districts"
FROM address;


-- 38
-- Retrieve the names for the distinct districts from the previous request.
SELECT DISTINCT(district) AS "Number of Unique Districts"
FROM address;


-- 39
-- How many films have a rating of PG-13 and a replacement cost between $10 and $20?
SELECT COUNT(*) AS "Number of Films"
FROM film
WHERE rating = "PG-13"
	AND replacement_cost BETWEEN 10 AND 20;

-- 40
-- How many films have the word Angels somewhere in the title?
SELECT COUNT(*) AS "Number of Films"
FROM film
WHERE title LIKE '%Angels%';


