
select *
from Sales.SalesOrderHeader
where Sales.SalesOrderHeader.SubTotal>100000

select SalesOrderID,CustomerID,SubTotal,OrderDate, Sales.SalesTerritory.Name
from Sales.SalesOrderHeader join Sales.SalesTerritory on (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)

Select Production.Product.Name
from Production.Product join Sales.SalesOrderDetail on (Production.Product.ProductID = Sales.SalesOrderDetail.ProductID) join
Sales.SalesOrderHeader on (Sales.SalesOrderDetail.SalesOrderID= Sales.SalesOrderHeader.SalesOrderID) join Sales.SalesTerritory on
(Sales.SalesOrderHeader.TerritoryID=Sales.SalesTerritory.TerritoryID)
where Sales.SalesTerritory.[Group]='Europe'


create table Fr_Sales
(
SalesOrderID char(5), 
CustomerID char(5),
SubTotal numeric(12,4),
OrderDate Date,
Name varchar(20),
);

insert into Fr_Sales(SalesOrderID,CustomerID,SubTotal,OrderDate,Name)
select SalesOrderID,CustomerID,SubTotal,OrderDate, Sales.SalesTerritory.Name
from Sales.SalesOrderHeader join Sales.SalesTerritory on (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
where Sales.SalesTerritory.Name='France'


ALTER TABLE Fr_Sales
ADD Jaber nvarchar(4) Check (Jaber in ('HIGH','LOW'))

Select *
from Fr_Sales


select 
	case 
	when Sales.SalesOrderHeader.SubTotal >1000 then 'HIGH'
	Else 'LOW'
	end as Jaber, Fr_Sales.SalesOrderID
from Fr_Sales join Sales.SalesOrderHeader on (Fr_Sales.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID)



USE AdventureWorks2012
GO
SELECT BusinessEntityID ,max(Rate) as maxrate
FROM HumanResources.EmployeePayHistory 
GROUP BY BusinessEntityID
ORDER BY maxrate



USE AdventureWorks2012
GO
Select 
	case
	when Rate < 38.125 then '4'
	when  Rate >= 38.125 and Rate<67.25 then '3'
	when Rate >=67.25 and Rate < 96.375 then '2'
	else '1'
	end as Levele,
	case 
	when Rate < 38.125  then Rate * 1.2
	when  Rate >= 38.125 and Rate<67.25 then Rate * 1.15
	when Rate >=67.25 and Rate < 96.375 then Rate * 1.1
	else Rate * 1.05
	End as NewSalary
from HumanResources.EmployeePayHistory

