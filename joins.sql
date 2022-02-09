-- SalesOrders Database

-- INNER JOINS

-- 01 - List customers and the dates they placed an order
SELECT c.CustomerID, c.CustFirstName , c.CustLastName,o.OrderDate
FROM Customers c 
JOIN Orders o 
	ON c.CustomerID = o.CustomerID ;

-- 02 - Show me customers and employees who share the same last name


-- 03 - Show me customers and employees who live in the same city
SELECT c.CustCity ,e.EmpCity ,c.CustFirstName, c.CustLastName, e.EmpFirstName, e.EmpLastName 
FROM Customers c 
JOIN Employees e 
	ON c.CustCity = e.EmpCity ;

-- 04 - Generate a list of employees and the customers for whom they booked an order


-- 05 - Display all orders with the order date, the products in each order, and the amount owed for each product, in order number sequence
-- orders, order details, products
SELECT od.OrderNumber, o.OrderDate, p.ProductNumber, od.QuotedPrice * od.QuantityOrdered AS Amount_Owed
FROM Order_Details od JOIN Orders o 
	ON od.OrderNumber = o.OrderNumber 
		JOIN Products p 
			ON od.ProductNumber = p.ProductNumber ;
		
SELECT -- do we use o.OrderNumber or od.OrderNumber -- need od because we cannot connect to p unless...
	o.OrderNumber, o.OrderDate, p.ProductName,
	QuotedPrice * QuantityOrdered AS AmountOwed
FROM Orders o
JOIN Order_Details od 
	ON o.OrderNumber = od.OrderNumber 
JOIN Products p 
	ON p.ProductNumber = od.ProductNumber 
ORDER BY o.OrderNumber ;

-- 06 - Show me the vendors and the products they supply to us for products that have a wholesale price under $100. Sort by the vendor name then the wholesale price.


-- 07 - Display customer names who have a sales rep (employees) in the same ZIP Code. Include the employee name.
SELECT c.CustFirstName ,c.CustLastName, e.EmpFirstName, e.EmpLastname, e.EmpZipCode 
FROM Customers c 
LEFT JOIN Employees e 
	ON c.CustZipCode = e.EmpZipCode;


-- LEFT JOINS

-- 08 - Display customers who do NOT have a sales rep (employees) in the same ZIP Code
SELECT c.CustFirstName ,c.CustLastName, e.EmpFirstName, e.EmpLastname, e.EmpZipCode 
FROM Customers c 
LEFT JOIN Employees e 
	ON c.CustZipCode = e.EmpZipCode
WHERE e.EmpZipCode IS NULL;

-- 09 - Are there any products that have never been ordered?
SELECT p.ProductNumber, od.OrderNumber 
FROM Products p LEFT JOIN Order_Details od
	ON od.ProductNumber = p.ProductNumber 
WHERE od.ProductNumber IS NULL;




-- sakila Database

-- INNER JOINS

-- 10 - What country is the city based in?
SELECT city, country
FROM city c
JOIN country co
	ON c.country_id = co.country_id;

-- 11 - What language is spoken in each film?
-- Try this on your own before watching the video solution.
SELECT title, name
FROM film f
JOIN `language` l 
	ON f.language_id = l.language_id;

-- 12 - List all film titles and their category (genre)
SELECT f.film_id, f.title, name, c.category_id
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id 
JOIN category c
	ON c.category_id = fc.category_id;

-- 13 - Create an email list of Canadian customers
SELECT customer_id, first_name, last_name, email, city, country
FROM customer c
JOIN address a 	
	ON c.address_id = a.address_id
JOIN city ci
	ON a.city_id = ci.city_id 
JOIN country co
	ON ci.country_id = co.country_id
WHERE country = 'Canada';

-- 14 - How much rental revenue has each customer generated? In other words, what is the SUM rental payment amount for each customer ordered by the SUM amount from high to low?
SELECT c.customer_id, first_name, last_name, SUM(amount) AS rental_revenue
FROM payment p 
JOIN customer c 
	ON p.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY rental_revenue DESC;

-- 15 - How many cities are associated to each country? Filter the results to countries with at least 10 cities.
SELECT country, COUNT(city) AS city_count
FROM city c 
JOIN country co 
	ON c.country_id = co.country_id 
GROUP BY country
HAVING city_count > 10
ORDER BY city_count DESC;


-- LEFT JOINS

-- 16 - Which films do not have an actor?
-- Try this on your own before watching the video solution.
SELECT title, fa.film_id, actor_id
FROM film f
LEFT JOIN film_actor fa
	ON f.film_id = fa.film_id
WHERE fa.film_id IS NULL;

-- 17 - Which comedies are not in inventory?
SELECT title, i.inventory_id
FROM film f
LEFT JOIN inventory i 
	ON f.film_id = i.film_id
JOIN film_category fc 
	ON f.film_id = fc.film_id 
JOIN category c 
	ON fc.category_id = c.category_id 
WHERE i.inventory_id IS NULL
	AND c.name = 'Comedy';

-- 18 - Generate a list of never been rented films
SELECT title, r.inventory_id, i.inventory_id 
FROM film f
JOIN inventory i 
	ON f.film_id = i.film_id
LEFT JOIN rental r 
	ON i.inventory_id  = r.inventory_id
WHERE r.inventory_id IS NULL;
