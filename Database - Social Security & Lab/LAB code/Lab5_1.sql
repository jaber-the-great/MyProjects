--1

USE AdventureWorks2012
GO
SELECT Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderDetail.LineTotal,
AVG(Sales.SalesOrderDetail.LineTotal)OVER (PARTITION BY Sales.SalesOrderHeader.CustomerID
ORDER BY Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderHeader.SalesOrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM Sales.SalesOrderHeader JOIN Sales.SalesOrderDetail ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)

--2

SELECT 
	CASE GROUPING(Sales.SalesTerritory.Name)
	WHEN 0 THEN Sales.SalesTerritory.Name
	WHEN 1 THEN 'All Territories'
	END AS TerritoryName,
	CASE GROUPING(Sales.SalesTerritory.[Group])
	WHEN 0 THEN Sales.SalesTerritory.[Group]
	WHEN 1 THEN 'All Territories'
	END AS Region,
	SUM(Sales.SalesOrderHeader.SubTotal) AS SalesTotal,
	COUNT(*) AS CountTotal
FROM Sales.SalesTerritory join Sales.SalesOrderHeader on (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
GROUP BY ROLLUP(Sales.SalesTerritory.[Group], Sales.SalesTerritory.Name)

--3

SELECT 
	CASE GROUPING(Sales.SalesTerritory.Name)
	WHEN 0 THEN Sales.SalesTerritory.Name
	WHEN 1 THEN 'All Territories'
	END AS TerritoryName,
	CASE GROUPING(Production.Product.Color)
	WHEN 0 THEN Production.Product.Color
	WHEN 1 THEN 'All Colors'
	END AS Color,
	COUNT(*) AS ProductCount
FROM Sales.SalesTerritory join Sales.SalesOrderHeader on (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
	join Sales.SalesOrderDetail on (Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID) 
	join Production.Product on (Sales.SalesOrderDetail.ProductID = Production.Product.ProductID)
GROUP BY CUBE(Production.Product.Color, Sales.SalesTerritory.Name)

--4

SELECT Name, Europe, [North America], Pacific
FROM 
(SELECT Production.Product.Name AS Name, Sales.SalesTerritory.[Group] AS TerritoryName, COUNT(*) AS TotalSell 
FROM Sales.SalesTerritory join Sales.SalesOrderHeader on (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
	join Sales.SalesOrderDetail on (Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID) 
	join Production.Product on (Sales.SalesOrderDetail.ProductID = Production.Product.ProductID)
GROUP BY Production.Product.Name,Sales.SalesTerritory.[Group]) as ps
PIVOT
(
SUM(TotalSell)
FOR TerritoryName IN
(Europe, [North America], Pacific)
) AS pvt

--5

select Person.BusinessEntityID, PersonType, Gender
from Person.Person join HumanResources.Employee on (Person.BusinessEntityID = Employee.BusinessEntityID)

SELECT PersonType, M, F
FROM 
(select PersonType, Gender, COUNT(*) as num
from Person.Person join HumanResources.Employee on (Person.BusinessEntityID = Employee.BusinessEntityID)
GROUP BY PersonType,Gender) as ps
PIVOT
(
SUM(num)
FOR Gender IN
(M,F)
) AS pvt