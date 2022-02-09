-- 01 - How many employees are from Washington?
SELECT COUNT(*) 
FROM Employees
WHERE EmpState = 'WA';

-- 02 - How many vendors provided a web page?
SELECT COUNT(VendWebPage), COUNT(*) 
FROM Vendors;


-- 03 - What is the total quantity ordered for the product, Eagle FS-3 Mountain Bike?
SELECT SUM(QuantityOrdered)
FROM Order_Details od 
WHERE ProductNumber = 2;

-- 04 - How much is the current inventory worth?
SELECT SUM(RetailPrice * QuantityOnHand)
FROM Products;

-- 05 - What is the average quoted price for the Dog Ear Aero-Flow Floor Pump (ProductNumber 21)?
SELECT AVG(QuotedPrice) 
FROM Order_Details 
WHERE ProductNumber = 21;

-- 06 - Count the unique number of quoted prices for the Dog Ear Aero-Flow Floor Pump (ProductNumber 21).
SELECT COUNT(DISTINCT(QuotedPrice)) AS UniqueQuotedPriceCount
FROM Order_Details 
WHERE ProductNumber = 21;

-- 07 - What is lowest, highest, and average retail price charged for a product?
SELECT 
	MIN(RetailPrice),
	AVG(RetailPrice),
	MAX(RetailPrice)
FROM Products;

-- 08 - Show me each vendor ID and the average by vendor  ID of the number of days to deliver products
DESCRIBE Product_Vendors ;

SELECT VendorID, AVG(DaysToDeliver)
FROM Product_Vendors
GROUP BY VendorID
ORDER BY AVG(DaysToDeliver) ASC;

-- 09 - Display for each product the product number and the total sales sorted by the product number
SELECT ProductNumber, SUM(QuotedPrice * QuantityOrdered ) AS Sales 
FROM Order_Details
GROUP BY ProductNumber
ORDER BY Sales DESC;

DESCRIBE Order_Details ;

-- 10 - List all vendors IDs and the count of products sold by each. Sort the results by the count of products sold in descending order.
SELECT VendorID, COUNT(ProductNumber) AS Products_Sold
FROM Product_Vendors 
GROUP BY VendorID 
ORDER BY Products_Sold DESC;

-- 11 - Display the customer ID and their most recent order date.
SELECT CustomerID, MAX(OrderDate) 
FROM Orders 
GROUP BY CustomerID
ORDER BY MAX(OrderDate); 

-- 12 - Show me each vendor ID and the average by vendor  ID of the number of days to deliver products. 
-- Filter the results to only show vendors where the average number of days to deliver is greater than 5.
SELECT VendorID, AVG(DaysToDeliver)
FROM Product_Vendors
GROUP BY VendorID 
HAVING AVG(DaysToDeliver) > 5; 

-- 13 - Show me each vendor and the average by vendor of the number of days to deliver products that are greater than the average delivery days for all vendors
SELECT VendorID, AVG(DaysToDeliver)
FROM Product_Vendors
GROUP BY VendorID 
HAVING AVG(DaysToDeliver) >
	(
		SELECT AVG(DaysToDeliver)
		FROM Product_Vendors
	);
	
-- subquery used in the main query	
SELECT AVG(DaysToDeliver)
FROM Product_Vendors;

-- 14 - Return just the number of vendors where their number of days to deliver products 
-- is greater than the average days to deliver across all vendors --making a derived table

SELECT COUNT(VendorID)
FROM
	(
		SELECT VendorID, AVG(DaysToDeliver)
		FROM Product_Vendors
		GROUP BY VendorID 
		HAVING AVG(DaysToDeliver) >
		(
			SELECT AVG(DaysToDeliver)
			FROM Product_Vendors
		)
	) AS DaysToDeliverGreaterThanAVG;


-- 15 - How many orders are for only one product?
DESC Order_Details;

SELECT OrderNumber, COUNT(ProductNumber)
FROM Order_Details 
GROUP BY OrderNumber 
HAVING COUNT(ProductNumber) > 1; 

-- 16 - Show all product names in a comma delimited list
-- GROUP_CONCAT(column/expression) 
-- concatenates strings from group
-- useful for returning a delimited list grouped by a COLUMN 
SELECT GROUP_CONCAT(ProductName)
FROM Products; 

-- 17 - Show all product names in a comma delimited list per category ID
SELECT 
	CategoryId,
	GROUP_CONCAT(ProductName)
FROM Products
GROUP BY CategoryID ;


-- 18 - Show all product names in a comma delimited list per category ID sorted by product name
SELECT  
	CategoryID,
	GROUP_CONCAT(ProductName ORDER BY ProductName)
FROM Products
GROUP BY CategoryID ;


-- Summarizing and Grouping Data Practice
-- Use the SalesOrders database

-- 19 - How many products do we carry?
SELECT COUNT(ProductNumber) AS Total_Number_of_Products
FROM Products;

-- 20 - What are the unique product categories?
SELECT DISTINCT(CategoryDescription) 
FROM Categories;


-- 21 - How many unique product categories exist?
SELECT COUNT(DISTINCT(CategoryDescription)) AS Number_of_Unique_Categories
FROM Categories;

-- 22 - How many products are associated with each category?
-- Sort the product counts from high to low.


SELECT CategoryID, COUNT(ProductNumber) AS Number_of_Products
FROM Products 
GROUP BY CategoryID
ORDER BY Number_of_Products DESC ;
 

-- 23 - List the categories with more than 3 products.

SELECT CategoryID, COUNT(ProductNumber) AS Number_of_Products
FROM Products 
GROUP BY CategoryID 
HAVING Number_of_Products > 3
ORDER BY Number_of_Products DESC;


-- 24
/*
List the categories with a product count greater than the average.
Show the category's product count and the average product count across all categories in the results. 
Expected columns: CategoryID | ProductCount | AvgProductCount

Structure a multi-step approach.
*/

-- shows product count according to category
SELECT CategoryID, COUNT(ProductNumber)
FROM Products
GROUP BY CategoryID;

-- Find avg across all categories

SELECT AVG(ProductCount) AS AvgProductCount
FROM
	(
		SELECT CategoryID, COUNT(*) AS ProductCount
		FROM Products p
		GROUP BY CategoryID

	) AS ProductCountByCategoryID;





-- 25 - How many categories have more products than the average product count per CategoryID? Return a single row.

-- first show avg prod count / category

SELECT CategoryID, COUNT(*) AS NumberofProducts
FROM Products p
GROUP BY CategoryID 
HAVING NumberofProducts > 
	(
		SELECT AVG(ProductCount)
		FROM
			(
				SELECT CategoryID, COUNT(*) AS ProductCount 
				FROM Products p 
				GROUP BY CategoryID
			) AS ProductCountByCategoryID
		
	);

-- avg prod count from table grouped by category id showing productcount
SELECT AVG(ProductCount)
FROM
	(
		SELECT CategoryID, COUNT(*) AS ProductCount 
		FROM Products p 
		GROUP BY CategoryID
	) AS ProductCountByCategoryID;



-- 26
/*
The inventory coordinator wants to reduce the inventory holding cost by comparing the wholesale pricing for products 
supplied by 3 or more vendors. The inventory coordinator will renegotiate or sever ties with the most expensive vendor.
Generate a report to help the inventory coordinator.
*/

-- products supplied by more >= 3 vend


SELECT ProductNumber , VendorID, WholesalePrice 
FROM Product_Vendors pv2 
WHERE ProductNumber IN 
(
	SELECT ProductNumber
	FROM Product_Vendors pv 
	GROUP BY ProductNumber
	HAVING COUNT(VendorID) >= 3
)
ORDER BY ProductNumber , WholesalePrice DESC
;












