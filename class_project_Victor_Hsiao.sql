

-- sakila Database

/*
1. Select all columns from the film table for PG-rated films. (1 point)
*/
SELECT *
FROM film
WHERE rating = 'PG';


/*
2. Select the customer_id, first_name, and last_name for the active customers (0 means inactive). 
Sort the customers by their last name and restrict the results to 10 customers. (1 point)
*/
SELECT customer_id, first_name, last_name 
FROM customer
WHERE active = 1
ORDER BY last_name
LIMIT 10;

/*
3. Select customer_id, first_name, and last_name for all customers where the last name is Clark. (1 point)
*/
SELECT customer_id, first_name, last_name 
FROM customer 
WHERE last_name = 'Clark';

/*
4. Select film_id, title, rental_duration, and description for films with a rental duration of 3 days. (1 point)
*/
desc film;

SELECT film_id, rental_duration, description 
FROM film
WHERE rental_duration = 3;

/*
5. Select film_id, title, rental_rate, and rental_duration for films that can be rented for more than 1 day 
and at a cost of $0.99 or more. Sort the results by rental_rate then rental_duration. (2 points)
*/
SELECT film_id, title, rental_rate, rental_duration
FROM film
WHERE rental_duration > 1 
	AND rental_rate >= 0.99
ORDER BY rental_rate, rental_duration;
/*
6. Select film_id, title, replacement_cost, and length for films that cost 9.99 or 10.99 to replace and have a 
running time of 60 minutes or more. (2 points)
*/
SELECT film_id, title, replacement_cost, `length` 
FROM film
WHERE replacement_cost BETWEEN 9.99 AND 10.99
	AND `length` >= 60
ORDER BY replacement_cost, `length`;



/*
7. Select film_id, title, replacement_cost, and rental_rate for films that cost $20 or more to replace and the 
cost to rent is less than a dollar. (2 points)
*/
SELECT film_id , title ,replacement_cost ,rental_rate 
FROM film
WHERE replacement_cost >= 20
	AND rental_rate < 1;


/*
8. Select film_id, title, and rating for films that do not have a G, PG, and PG-13 rating.  Do not use the OR 
logical operator. (2 points)
*/
SELECT film_id , title , rating 
FROM film
WHERE rating NOT IN ('G','PG','PG-13');

/*
9. How many films can be rented for 5 to 7 days? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(*) AS Films_rented_for_5_to_7_days
FROM film 
WHERE rental_duration BETWEEN 5 AND 7;


/*
10. INSERT your favorite movie into the film table. You can arbitrarily set the column values as long as they 
are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
DESC film ;

INSERT INTO film 
(title,description,release_year,language_id,`length`,special_features)
VALUES
('HappyFeet','penguins',2005,1,70,'Cute Penguins');

SELECT *
FROM film 
WHERE title = 'HappyFeet';

/*
11. INSERT your two favorite actors/actresses into the actor table with a single SQL statement. (2 points)
*/
INSERT INTO actor 
(first_name,last_name)
VALUES
('Victor','Hsiao'),
('Elon','Musk');

/*
12. The address2 column in the address table inconsistently defines what it means to not have an address2 associated 
with an address. UPDATE the address2 column to an empty string where the address2 value is currently null. (2 points)
*/
UPDATE address 
SET address2 = ''
WHERE address2 IS NULL;

/*
13. For rated G films less than an hour long, update the special_features column to replace Commentaries with Audio 
Commentary. Be sure the other special features are not removed. (2 points)
*/
UPDATE film 
SET special_features = 'Audio Commentaries'
WHERE special_features = 'Commentaries';


-- LinkedIn Database

/*
14. Create a new database named LinkedIn. You will still need to use  LMU.build to create the database. Even though 
you're creating the database on LMU.build, write the SQL to create a database.(1 point)
*/
CREATE DATABASE linkedIn;

/*
15. Create a user table to store LinkedIn users. The table must include 5 columns minimum with the appropriate data 
type and a primary key. One of the columns should be Email and must be a unique value. (3 points)
*/
CREATE TABLE user(
	linkedin_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	phone VARCHAR(255),
	email VARCHAR(255),
	created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (linkedin_id),
	UNIQUE KEY uniq_email (email)
) ENGINE=InnoDB;


/*
16. Create a table to store a user's work experience. The table must include a primary key, a foreign key column to 
the user table, and have at least 5 columns with the appropriate data type. (3 points)
*/
CREATE TABLE work(
	work_id INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(255),
	company VARCHAR(255),
	years_of_experience DECIMAL(3,2),
	linkedin_id INT,
	created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (work_id),
	CONSTRAINT fk_user_work_linkedin_id_linkedin_id FOREIGN KEY (linkedin_id) REFERENCES user(linkedin_id)
) ENGINE=InnoDB;

/*
17. INSERT 1 user into the user table. (2 points)
*/
INSERT INTO `user` 
(first_name,last_name,phone,email)
VALUES
('Tim','Cook','3235997029','timcook@apple.com');

/*
18. INSERT 1 work experience entry for the user just inserted. (2 points)
*/
INSERT INTO `work` 
(title,company,years_of_experience,linkedin_id)
VALUES
('CEO','Apple','5.4','00001');



-- SpecialtyFood Database

/*
19. The warehouse manager wants to know all of the products the company carries. Generate a list of all the products 
with all of the columns. (1 point)
*/
SELECT *
FROM Products;


/*
20. The marketing department wants to run a direct mail marketing campaign to its American, Canadian, and Mexican 
customers. Write a query to gather the data needed for a mailing label. (2 points)
*/
SELECT ContactName, Address, City, Region, PostalCode, Country 
FROM Customers 
WHERE Country IN ('USA', 'Canada', 'Mexico');



/*
21. HR wants to celebrate hire date anniversaries for the sales representatives in the USA office. Develop a query 
that would give HR the information they need to coordinate hire date anniversary gifts. Sort the data as you see 
best fit. (2 points)
*/
SELECT EmployeeID, LastName, FirstName, HireDate 
FROM Employees
WHERE Title = 'Sales Representative' 
	AND Country = 'USA'
ORDER BY HireDate;
/*
22. What is the SQL command to show the structure for the Shippers table? (1 point)
*/
DESCRIBE Shippers;

/*
23. Customer service noticed an increase in shipping errors for orders handled by the employee, Janet Leverling. 
Return the OrderIDs handled by Janet so that the orders can be inspected for other errors. (2 points)
*/
SELECT OrderID
FROM Employees e JOIN Orders o 
	ON e.EmployeeID = o.EmployeeID 
WHERE FirstName = 'Janet' 
	AND LastName = 'Leverling';

/*
24. The sales team wants to develop stronger supply chain relationships with its suppliers by reaching out to the 
managers who have the decision making power to create a just-in-time inventory arrangement. Display the supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title. (2 points)
*/
SELECT SupplierID, CompanyName, ContactName, ContactTitle 
FROM Suppliers 
WHERE ContactTitle LIKE ('%Manager%') OR ContactTitle LIKE ('%mgr%');


/*
25. The warehouse packers want to label breakable products with a fragile sticker. Identify the products with 
glasses, jars, or bottles and are not discontinued (0 = not discontinued). (2 points)
*/
SELECT ProductID, ProductName, QuantityPerUnit, Discontinued 
FROM Products
WHERE Discontinued != 1
	AND QuantityPerUnit LIKE ('%glasses')
	OR QuantityPerUnit LIKE ('%jars')
	OR QuantityPerUnit LIKE ('%bottles')
	


/*
26. How many customers are from Brazil and have a role in sales? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(*) AS Number_of_Customers_in_Brazil 
FROM Customers 
WHERE Country = 'Brazil'
	AND ContactTitle LIKE ('%Sales%');


/*
27. Who is the oldest employee in terms of age? Your query should only return 1 row. (2 points)
*/
SELECT EmployeeID, LastName, FirstName, MIN(BirthDate) 
FROM Employees;


/*
28. Calculate the total order price per order and product before and after the discount. The products listed should 
only be for those where a discount was applied. Alias the before discount and after discount expressions. (3 points)
*/
SELECT  OrderID,
		Total_per_Product_Before_Discount,
		Total_per_Product_After_Discount, 
		SUM(Total_per_Product_Before_Discount) AS Order_Total_Before_Discount,
		SUM(Total_per_Product_After_Discount) AS Order_Total_After_Discount
FROM
	(
		SELECT *, (UnitPrice * Quantity) AS Total_per_Product_Before_Discount, (UnitPrice*Quantity*(1-Discount)) AS Total_per_Product_After_Discount
		FROM OrderDetails 
		WHERE Discount > 0
		GROUP BY ProductID
		ORDER BY ProductID
	) AS Calculated_Product_Discounts
	GROUP BY OrderID;


/*
29. To assist in determining the company's assets, find the total dollar value for all products in stock. Your query 
should only return 1 row.  (2 points)
*/
SELECT SUM(UnitPrice * UnitsInStock) AS Total_Value_of_Products_in_stock
FROM Products;



/*
30. Supplier deliveries are confirmed via email and fax. Create a list of suppliers with a missing fax number to help 
the warehouse receiving team identify who to contact to fill in the missing information. (2 points)
*/
SELECT SupplierID 
FROM Suppliers 
WHERE Fax IS NULL;
/*
31. The PR team wants to promote the company's global presence on the website. Identify a unique and sorted list of 
countries where the company has customers. (2 points)
*/
SELECT Country, COUNT(*) AS Customers
FROM Customers
GROUP BY Country
ORDER BY Customers DESC;


/*
32. List the products that need to be reordered from the supplier. Know that you can use column names on the right-hand 
side of a comparison operator. Disregard the UnitsOnOrder column. (2 points)
*/

SELECT ProductName, ReorderLevel 
FROM Products 
WHERE ReorderLevel > 0
    AND Discontinued = 0;
   

/*
33. You're the newest hire. INSERT yourself as an employee with the INSERT … SET method. You can arbitrarily set the 
column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
INSERT INTO Employees 
(LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,
HomePhone,Extension,Notes,ReportsTo)
VALUES
('Hsiao','Victor','CEO','Dr.','2000-10-04','2021-10-10','Big Road Ave','Los Angeles',
'CA','90045','USA','(123) 321-7777',4322,'Best in the company',null);


/*
34. The supplier, Bigfoot Breweries, recently launched their website. UPDATE their website to bigfootbreweries.com. (2 points)
*/
UPDATE Suppliers 
SET HomePage = 'bigfootbreweries.com'
WHERE CompanyName = 'Bigfoot Breweries';

SELECT *
FROM Suppliers 
WHERE CompanyName = 'Bigfoot Breweries';

/*
35. The images on the employee profiles are broken. The link to the employee headshot is missing the .com domain extension. 
Fix the PhotoPath link so that the domain properly resolves. 
Broken link example: http://accweb/emmployees/buchanan.bmp (2 points)
*/
UPDATE Employees 					-- old string, new string
SET PhotoPath = REPLACE(PhotoPath , 'bmp', 'bmp.com')
WHERE PhotoPath LIKE '%bmp';

/*
36. Show a list of orders with the shipper used. Restrict the results to orders placed Jan 1, 2015 to July 31, 2015 and 
sort by when the order was placed.
*/
SELECT OrderID, OrderDate, ShipVia 
FROM Orders 
WHERE OrderDate BETWEEN '2015-01-01' AND '2015-07-31' 
ORDER BY OrderDate DESC;


/*
37. We want to see the total number of products in each category. In descending order, sort the output by the total number of products.
*/
SELECT CategoryID, COUNT(ProductID) AS Number_of_Products
FROM Products
GROUP BY CategoryID 
ORDER BY Number_of_Products;

/*
38. Where are our customers located? Return the total customers per country and city. Order the results from highest to lowest.
*/
SELECT Country, City, COUNT(*) AS Total_Customers
FROM Customers 
GROUP BY Country, City
ORDER BY Total_Customers DESC;



/*
39. Return the country and city combinations where there is only 1 customer. Order the results in alphabetical order.
*/
SELECT Country, City, COUNT(*) AS Total_Customers
FROM Customers 
GROUP BY Country, City
HAVING COUNT(*) = 1
ORDER BY Total_Customers DESC;

/*
40. We incur noticeably higher freight charges for some of our destination shipping countries. We would like to explore alternative
shipping options for our customers. Give the two top countries with the highest average freight cost to help prioritize where to start.
*/
SELECT ShipCountry, AVG(Freight)
FROM Orders
GROUP BY ShipCountry
ORDER BY AVG(Freight) DESC
LIMIT 2;


/*
41. The sales manager wants to gain insight into the top-selling products sold per employee where the employee sold at least 150 units.
The manager is requesting the employee's ID and full name along with the product ID, product name, and the number of items sold per 
product by the employee.  
*/
SELECT o.EmployeeID, e.FirstName, e.LastName, od.ProductID, p.ProductName, SUM(od.Quantity) AS ProductsSold
FROM Employees e 
JOIN Orders o 
    ON e.EmployeeID = o.EmployeeID 
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID 
JOIN Products p 
    ON od.ProductID = p.ProductID 
GROUP BY o.EmployeeID, od.ProductID
HAVING ProductsSold >= 150
ORDER BY o.EmployeeID, ProductID DESC;

/*
42. Some customers in the database never placed an order. Identify these customers by company name and company ID. 
*/
SELECT c.CustomerID, c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o 
    ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL;

/*
43. We want to reward our high-value customers by sending them some company swag. A high-value customer spent at 
least $40,000 with the company. Return the customer's ID, name, and how much they spent (sort by this value).
Filter the results to orders placed in 2016.
*/
SELECT c.CustomerID, ContactName, SUM((UnitPrice * Quantity) - (UnitPrice * Quantity * Discount)) AS OrderSum
FROM Customers c 
JOIN Orders o 
    ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
WHERE OrderDate LIKE "2016%"
GROUP BY CustomerID
HAVING OrderSum > 40000
ORDER BY OrderSum DESC;

/*
44. The customer service team states there is an uptick in customers submitting tickets regarding late deliveries.
Identify the late orders by including a list with the order ID, order date, required date, and shipped date. 
*/
SELECT EmployeeID, OrderID, OrderDate, RequiredDate, ShippedDate
FROM Orders 
WHERE ShippedDate > RequiredDate;

/*
45. To help identify the cause behind the late deliveries, return a list of employees with the number of late orders
associated with them. It is possible the employees are delaying the fulfillment process and may require a gentle reminder
to stay on top of their orders. Rank the employees with the most late orders at the top of the list. 
*/
SELECT EmployeeID, FirstName, LastName, COUNT(*) As NumberOfLateDeliveries
FROM 
(
    SELECT o.EmployeeID, FirstName, LastName, OrderID, OrderDate, RequiredDate, ShippedDate
    FROM Orders o
    JOIN Employees e
        ON o.EmployeeID = e.EmployeeID 
    WHERE ShippedDate > RequiredDate
) AS LateDeliveries
GROUP BY EmployeeID
ORDER BY NumberOfLateDeliveries DESC;

-- Custom Data Requests

/*
Data Request 1
Question
Company decides that we have too many workers from the USA, and is considering perhaps firing one employee working there.
Which Employees within the United States sell the most products? we should keep em! and fire the rest!
Business Justification
*/
-- it is important for the company to find out workers in the USAs' performance in order to decide who they fire, firing someone with high performance is not a good idea
-- we want to fire someone that isn't providing much to the company!!
-- SQL 1 First Identifying which employees are working in the United States
SELECT *
FROM Employees 
WHERE Country = 'USA';

-- SQL 2 Let's rank each employees performance! Now we know whos slacking 0.0
SELECT e.EmployeeID, COUNT(o.OrderID ) AS Sales
FROM Employees e 
JOIN Orders o 
	ON e.EmployeeID = o.EmployeeID 
GROUP BY e.EmployeeID
ORDER BY Sales DESC;

-- SQL 3 The Company decides to fire the worst performing employee... who is it?
SELECT e.EmployeeID,e.LastName,e.FirstName ,COUNT(o.OrderID ) AS Sales
FROM Employees e 
JOIN Orders o 
	ON e.EmployeeID = o.EmployeeID 
GROUP BY e.EmployeeID
ORDER BY Sales ASC 
LIMIT 1;
-- Sorry Steven, you're gone. 

/*
Data Request 2
Question
The company has various categories of products, and wants to find out which categories 
makes the most money(UnitPrice*UnitsOnOrder) and which categories make the least amount of money
Business Justification
*/
-- This allows companies to focus more on their categories that make the most money, and also shows which 
-- categories they need to improve on.

-- SQL 1 First let's find out how much revenue each category makes
SELECT c.CategoryID, SUM(p.UnitPrice*p.UnitsOnOrder) AS Current_Revenue 
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID;

-- Me double checking that categoryID 6 is indeed 0 on unitsonodrder
SELECT c.CategoryID, p.UnitPrice, p.UnitsOnOrder 
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID
WHERE c.CategoryID = 6;

-- also me double checking to see if my overall query is indeed correct
-- lets see if category 1's revenue adds up to our first query
SELECT c.CategoryID, SUM(p.UnitPrice*p.UnitsOnOrder)
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID
WHERE c.CategoryID = 1;
-- yay, we're good. It matches up 1370 = 1370 meaning our query 
-- succesfully sums revenue according to each categoryID

-- SQL 2 We can now make mess around with the query, let's see which category has the most revenue
SELECT c.CategoryID, SUM(p.UnitPrice*p.UnitsOnOrder) AS Current_Revenue 
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID
ORDER BY Current_Revenue
LIMIT 1;

-- SQL 3 We can also now see which category has the least revenue
SELECT c.CategoryID, SUM(p.UnitPrice*p.UnitsOnOrder) AS Current_Revenue 
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID
ORDER BY Current_Revenue DESC
LIMIT 1;
