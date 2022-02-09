-- https://www.interviewquery.com/questions/upsell-transactions


-- 01 - How many orders were booked by employees from the 425 area code?

SELECT COUNT(*)
FROM Orders
WHERE EmployeeID IN 
	(
		SELECT EmployeeID 
		FROM Employees 
		WHERE EmpAreaCode = 425
	);

-- 02 - How many orders were booked by employees from the 425 area code? 
-- Use a JOIN instead of a subquery.

SELECT COUNT(*) AS EmpCount
FROM Orders o
JOIN Employees e
	ON o.EmployeeID = e.EmployeeID
WHERE e.EmpAreaCode = 425;

-- 03 - Show me the average number of days to deliver products per vendor name.
-- Filter the results to only show vendors where the 
-- average number of days to deliver is greater than 5.

SELECT v.VendName, AVG(DaysToDeliver) AS Average
FROM Product_Vendors pv
JOIN Vendors v
	ON pv.VendorID = v.VendorID
GROUP BY 1
HAVING AVG(DaysToDeliver) > 5
ORDER BY Average;


-- Avoid GROUP BY column_#
-- it is not self documenting
-- fragile if someone changes the select field list


-- 04 - Show me the average number of days to deliver products per vendor name 
-- where the average is greater than the average delivery days for all vendors.
SELECT v.VendorID, VendName, AVG(DaysToDeliver) AS AvgDaysToDeliver 
FROM Product_Vendors pv
JOIN Vendors v
	ON pv.VendorID = v.VendorID
GROUP BY v.VendorID 
HAVING AvgDaysToDeliver >
(
	SELECT AVG(DaysToDeliver)
	FROM Product_Vendors pv2
)
ORDER BY AvgDaysToDeliver DESC;

-- 05 - Return just the number of vendors where their number of days to deliver 
-- products is greater than the average days to deliver across all vendors.
SELECT COUNT(*) AS VendorDaysToDeliverGreaterThanAvgCount
FROM 
(
	SELECT v.VendorID, VendName, AVG(DaysToDeliver) AS AvgDaysToDeliver 
	FROM Product_Vendors pv
	JOIN Vendors v
		ON pv.VendorID = v.VendorID
	GROUP BY v.VendorID 
	HAVING AvgDaysToDeliver >
	(
		SELECT AVG(DaysToDeliver)
		FROM Product_Vendors pv2
	)
	ORDER BY AvgDaysToDeliver DESC
) AS VendorCount;

-- 06 - How many products are associated to each category name?
-- Alias the aggregate expression
-- Sort the product counts from high to low

SELECT c.CategoryID, c.CategoryDescription, COUNT(ProductNumber) AS ProductCountPerCategory
FROM Products p 
JOIN Categories c
    ON c.CategoryID = p.CategoryID
GROUP BY CategoryID
ORDER BY ProductCountPerCategory DESC;



	
-- 07 - List the categories with more than 3 products.
SELECT c.CategoryID, c.CategoryDescription, COUNT(ProductNumber) AS ProductCountPerCategory
FROM Products p 
JOIN Categories c
    ON c.CategoryID = p.CategoryID
GROUP BY CategoryID
HAVING ProductCountPerCategory > 3
ORDER BY ProductCountPerCategory DESC;




-- 08 - List the categories with a product count greater than the average.
-- Average based on grouped results and not just a column's value.

-- 08.01 - Select the product counts per category

SELECT 
	c.CategoryID,
	c.CategoryDescription,
	COUNT(p.ProductNumber) AS ProductCount
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID;

-- 08.02 - Get average # of products per category
-- Can AVG RetailPrice and QuantityOnHand but not a row count

SELECT AVG(ProductCount) AS AvgProductCount
FROM
(
	SELECT 
		c.CategoryID,
		c.CategoryDescription,
		COUNT(p.ProductNumber) AS ProductCount
	FROM Categories c 
	JOIN Products p 
		ON c.CategoryID = p.CategoryID 
	GROUP BY c.CategoryID
) AS ProductCoutnByCategory;


-- 08.03 - Add the average # of products per category as a subquery to the right-hand side of the HAVING comparison operator 
SELECT
	c.CategoryID,
	CategoryDescription,
	COUNT(ProductNumber) AS ProductCountPerCategory
FROM
	Products p
JOIN Categories c 
	ON
	p.CategoryID = c.CategoryID
GROUP BY
	CategoryID
HAVING
	ProductCountPerCategory >
(
	SELECT
		AVG(ProductCountPerCategory) AS AvgNumOfProductsPerCategory
	FROM
		(
		SELECT
			c.CategoryID,
			c.CategoryDescription,
			COUNT(ProductNumber) AS ProductCountPerCategory
		FROM
			Products p
		JOIN Categories c 
			ON
			p.CategoryID = c.CategoryID
		GROUP BY
			CategoryID
	) AS ProductCountByCategory
);


-- 08.04 - Display the average product count alongside the category product count
SELECT 
	c.CategoryID,
	c.CategoryDescription,
	COUNT(p.ProductNumber) AS ProductCount,
	(
		SELECT AVG(ProductCount) AS AvgProductCount
		FROM
		(
			SELECT 
				c.CategoryID,
				c.CategoryDescription,
				COUNT(p.ProductNumber) AS ProductCount
			FROM Categories c 
			JOIN Products p 
				ON c.CategoryID = p.CategoryID 
			GROUP BY c.CategoryID
		) AS ProductCoutnByCategory
	) AS AverageProductCount
FROM Categories c 
JOIN Products p 
	ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID
HAVING ProductCount >
(
	SELECT AVG(ProductCount) AS AvgProductCount
	FROM
	(
		SELECT 
			c.CategoryID,
			c.CategoryDescription,
			COUNT(p.ProductNumber) AS ProductCount
		FROM Categories c 
		JOIN Products p 
			ON c.CategoryID = p.CategoryID 
		GROUP BY c.CategoryID
	) AS ProductCoutnByCategory
);

-- 09 - How many categories have more products than the average product count per category?
-- Return a single row with the count
SELECT COUNT(*) AS CategoryCount
FROM
(
	SELECT 
		c.CategoryID,
		c.CategoryDescription,
		COUNT(p.ProductNumber) AS ProductCount,
		(
			SELECT AVG(ProductCount) AS AvgProductCount
			FROM
			(
				SELECT 
					c.CategoryID,
					c.CategoryDescription,
					COUNT(p.ProductNumber) AS ProductCount
				FROM Categories c 
				JOIN Products p 
					ON c.CategoryID = p.CategoryID 
				GROUP BY c.CategoryID
			) AS ProductCoutnByCategory
		) AS AverageProductCount
	FROM Categories c 
	JOIN Products p 
		ON c.CategoryID = p.CategoryID 
	GROUP BY c.CategoryID
	HAVING ProductCount >
	(
		SELECT AVG(ProductCount) AS AvgProductCount
		FROM
		(
			SELECT 
				c.CategoryID,
				c.CategoryDescription,
				COUNT(p.ProductNumber) AS ProductCount
			FROM Categories c 
			JOIN Products p 
				ON c.CategoryID = p.CategoryID 
			GROUP BY c.CategoryID
		) AS ProductCoutnByCategory
	)
) AS a;









