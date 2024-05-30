-- Instead of writing Northwind.dbo.TableName
USE Northwind;
-- Get the tables within the database schema
SELECT *
FROM Northwind.INFORMATION_SCHEMA.TABLES;

-- Explore the data within each table
SELECT TOP 2 *
FROM Customers;

SELECT TOP 2 *
FROM Orders;

SELECT TOP 2 *
FROM OrderItems;

SELECT TOP 2 *
FROM Products;

SELECT TOP 2 *
FROM Suppliers;


SELECT COUNT(*), COUNT(Country)
FROM Suppliers;

-- Count the number of Null values in each column in Suppliers table
DECLARE @t nvarchar(max)
SET @t = N'SELECT '

SELECT @t = @t + 'SUM(CASE WHEN ' + c.name + ' IS NULL THEN 1 ELSE 0 END) "Null Values for ' + c.name + '",'
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('Suppliers');

SET @t = SUBSTRING(@t, 1, LEN(@t) - 1) + ' FROM Suppliers;'

EXEC sp_executesql @t;

-- Check the duplicate values in Customers Table
SELECT FirstName, LastName, City, Country, Phone, COUNT(*) CountDuplicates
FROM Customers
GROUP BY FirstName, LastName, City, Country, Phone
ORDER BY CountDuplicates DESC


-- Deleting duplicate values in the Customers Table
DELETE T
FROM
(
SELECT *
, DupRank = ROW_NUMBER() OVER (
              PARTITION BY Phone
              ORDER BY (SELECT NULL)
            )
FROM Customers
) AS T
WHERE DupRank > 1

