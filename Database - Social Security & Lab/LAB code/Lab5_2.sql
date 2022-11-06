USE AdventureWorks2012
GO
SELECT Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderDetail.LineTotal,
AVG(Sales.SalesOrderDetail.LineTotal)OVER (PARTITION BY
Sales.SalesOrderHeader.CustomerID
ORDER BY Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderHeader.SalesOrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM Sales.SalesOrderHeader JOIN Sales.SalesOrderDetail ON
(SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)


select 
case GROUPING(Name)
when 0 then Name
when 1 then 'all territories'
end as Name,
case grouping ([group])
when 0 then [group]
when 1 then 'all regions'
end as [group] ,
sum(h.SubTotal)as summm ,count(h.SalesOrderID)
from Sales.SalesOrderHeader  as h join Sales.SalesTerritory as t on(h.TerritoryID=t.TerritoryID)
--GROUP BY GROUPING SETS(t.name,t.[Group])
group by rollup (Name,[Group])

select
case grouping (t.name)
when 0 then t.name
when 1 then 'all territories'
end as name,
case grouping (color)
when 0 then color
when 1 then 'all colors'
end as color,
sum(p.ProductID)
from Sales.SalesTerritory as t join Sales.SalesOrderHeader as h on (t.TerritoryID=h.TerritoryID) join
Sales.SalesOrderDetail as d on (h.SalesOrderID = d.SalesOrderID) join Production.Product as p on (p.ProductID=d.ProductID)
group by cube(p.Color,t.Name)




select name, Europe,[North America] as na,Pacific
from (select p.name,[group],p.productID as pid
from  Sales.SalesTerritory as t join Sales.SalesOrderHeader as h on (t.TerritoryID=h.TerritoryID) join
Sales.SalesOrderDetail as d on (h.SalesOrderID = d.SalesOrderID) join Production.Product as p on (p.ProductID=d.ProductID)
) as jaber
pivot
(
sum(pid)
for [group] in
([Europe],[North America],[Pacific])
)as pvt



select Person.BusinessEntityID, PersonType, Gender
from Person.Person join HumanResources.Employee on (Person.BusinessEntityID
= Employee.BusinessEntityID)



select personType, [M] as M , [F] as F
from(
select p.PersonType,hr.Gender,p.BusinessEntityID as pbeID
from Person.Person as p join HumanResources.Employee as hr on(p.BusinessEntityID=hr.BusinessEntityID))as  tttt
pivot (
count(pbeID)
for Gender in
( [M],[F])
)as pvt