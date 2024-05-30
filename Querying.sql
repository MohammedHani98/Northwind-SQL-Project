USE Northwind;
-- Explore the data within each table
SELECT TOP 2 *
FROM Customers;

SELECT *
FROM Orders
ORDER BY OrderDate;

SELECT *
FROM OrderItems;

SELECT TOP 2 *
FROM Products;

SELECT TOP 2 *
FROM Suppliers;

-- What is the company that made the highest level of revenues within the first week of the month
WITH table_1 As (
SELECT 
    s.CompanyName,
	s.Country,
	SUM(o.UnitPrice * o.Quantity) AS Revenue
FROM
    Suppliers s
INNER JOIN
    Products p
ON s.Id = p.SupplierId
INNER JOIN
    OrderItems o
ON o.ProductId = p.Id
INNER JOIN
    Orders od
ON od.Id = o.OrderId
WHERE
    OrderDate <= '2012-07-07'
GROUP BY 
    s.CompanyName,
	s.Country
)

SELECT
    *,
    CASE 
	    WHEN Revenue > 1000 THEN 'Good' 
		WHEN Revenue <= 1000 and Revenue >= 500 THEN 'Moderate'
		ElSE 'Bad'
		END AS Performance
FROM table_1;

-- Get the product with the highest level of sales in each country
WITH table_2 AS (SELECT
		p.ProductName,
		s.Country,
		SUM(o.UnitPrice * o.Quantity) AS Revenue
	FROM 
		Products p
	INNER JOIN
		OrderItems o
	ON  p.Id = o.ProductId
	INNER JOIN Orders od
	ON od.Id = o.OrderId
	INNER JOIN Suppliers s
	ON p.SupplierId = s.Id
	GROUP BY
		P.ProductName,
		s.Country
),

table_3 AS (
SELECT 
	Country,
	MAX(Revenue) MaxSales
FROM table_2
GROUP BY
	Country
)

SELECT 
    table_2.ProductName,
	table_2.Country,
	table_3.MaxSales
FROM 
    table_2
INNER JOIN
    table_3
ON table_2.Revenue = table_3.MaxSales

-- Set a password for the customers based on their information
WITH table_4 AS (
SELECT
    Id,
	CONCAT(FirstName,' ', LastName) AS FullName,
	City,
	Country,
	Phone
FROM
    Customers
)

SELECT
    FullName,
	CONCAT(LOWER(LEFT(FullName, 1)), RIGHT(LEFT(FullName, CHARINDEX(' ', FullName) - 1), 1), 
	LEFT(LOWER(RIGHT(FullName, LEN(FullName) - CHARINDEX(' ', FullName))), 1),
	RIGHT(FullName, 1), RIGHT(Phone, 2)) AS Password
FROM 
    table_4;

-- Getting the running total of the total amount of sales in each day
SELECT 
    TotalAmount,
    dbo.TruncateDate(OrderDate, 'day') MonthSales, 
	SUM(TotalAmount) OVER (PARTITION BY dbo.TruncateDate(OrderDate, 'day') ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RunningTotal
FROM
    Orders

-- Get the percentage change in revenues of each order and its precedeing one
SELECT
    OrderDate,
	TotalAmount,
	LAG(TotalAmount) OVER (ORDER BY OrderDate) AS LagRevenue,
	TotalAmount - LAG(TotalAmount) OVER (ORDER BY OrderDate) AS Diff,
	CAST(ROUND((TotalAmount - LAG(TotalAmount) OVER (ORDER BY OrderDate))/LAG(TotalAmount) OVER (ORDER BY OrderDate) * 100, 3) AS decimal(10,2)) AS PctChange
FROM (
    SELECT
	    OrderDate,
		SUM(TotalAmount) AS TotalAmount
	FROM
	    Orders
	GROUP BY OrderDate) sub1









