	Use retail_sales;
-- All products
SELECT * FROM Product;

-- Products > $50
SELECT ProductName, UnitPrice
FROM Product
WHERE UnitPrice > 50;

-- Customers in Germany
SELECT *
FROM Customer
WHERE Country = 'Germany';

-- Total orders
SELECT COUNT(*) FROM SalesOrder;

-- Average price
SELECT AVG(UnitPrice) FROM Product;

-- Total revenue
SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS TotalRevenue
FROM OrderDetail;

-------- Join Operation
-- Product + Category
SELECT p.ProductName, c.CategoryName, p.UnitPrice
FROM Product p
JOIN Category c
ON p.CategoryID = c.CategoryID;

-- Coustomer + Order 
SELECT c.CompanyName, s.OrderID, s.OrderDate
FROM Customer c
JOIN SalesOrder s
ON c.custid = s.custid;

-- Sale Performance by Employee
SELECT e.FirstName, s.OrderID, c.CompanyName
FROM Employee e
JOIN SalesOrder s ON e.employeeID = s.employeeID
JOIN Customer c ON s.custid = c.custid;

------ Subqueries 
-- Expensive Products
SELECT ProductName, UnitPrice
FROM Product
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Product);

-- Customers with Greater Than > 5 orders
SELECT custid
FROM SalesOrder
GROUP BY custid
HAVING COUNT(OrderID) > 5;

-- Products that have been never ordered.
SELECT ProductName
FROM Product
WHERE ProductID NOT IN (
    SELECT ProductID FROM OrderDetail
);

--------- Windows Functions 
-- Products Ranked by Price
SELECT ProductName, CategoryID, UnitPrice,
RANK() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS RankPrice
FROM Product;
	
-- Running Total Revenue of Sales 
SELECT s.OrderDate,
SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) AS OrderRevenue,
SUM(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)))
OVER (ORDER BY s.OrderDate) AS RunningTotal
FROM SalesOrder s
JOIN OrderDetail o ON s.OrderID = o.OrderID
GROUP BY s.OrderDate;

-- Top Coustomers by Revenue
SELECT c.CompanyName,
SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) AS TotalRevenue,
RANK() OVER (ORDER BY SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) DESC) AS RankCustomer
FROM Customer c
JOIN SalesOrder s ON c.custid = s.custid
JOIN OrderDetail o ON s.OrderID = o.OrderID
GROUP BY c.CompanyName;

--------------- Advanced Analytical Queries
-- Highest Revenue Category
SELECT c.CategoryName,
SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) AS Revenue
FROM Category c
JOIN Product p ON c.CategoryID = p.CategoryID
JOIN OrderDetail o ON p.ProductID = o.ProductID
GROUP BY c.CategoryName
ORDER BY Revenue DESC
LIMIT 1;

-- Coustomer With Most Orders
SELECT Custid, COUNT(OrderID) AS TotalOrders
FROM SalesOrder
GROUP BY Custid
ORDER BY TotalOrders DESC
LIMIT 1;

-- Top Employee
SELECT EmployeeID, COUNT(OrderID) AS TotalOrders
FROM SalesOrder
GROUP BY EmployeeID
ORDER BY TotalOrders DESC
LIMIT 1;