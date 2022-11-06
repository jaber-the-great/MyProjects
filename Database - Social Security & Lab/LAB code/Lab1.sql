select Name
from Production.Product
where DATALENGTH(Name) <15 and name like '%e_'



IF OBJECT_ID (N'dbo.PhoneNumber', N'FN') IS NOT NULL
DROP FUNCTION dbo.PhoneNumber;
go 
create function dbo.PhoneNumber(@number char(11))
returns varchar(30)
as 
begin
declare @ret varchar(30);
declare @temp varchar(4);
declare @citycode char(3);
declare @otherPart char(8);
set @otherPart =SUBSTRING(@number,2,8)
set @citycode= SUBSTRING(@number,1,3)
set @temp=SUBSTRING(@number,1,2)
if(@temp like '09%')
set @ret = 'Mobile phone number'
else if(@temp like '0%')
Begin
set @ret ='city code' + @citycode ;
	if(@citycode like '031%')
	set @ret = 'Isfahan'
	else if(@citycode like '021')
	set @ret='tehran'
	else
	set @ret ='Invalid number';
End
return @ret;
end;
go


select dbo.PhoneNumber('09111111111')


IF OBJECT_ID (N'dbo.jaber2', N'FN') IS NOT NULL
DROP FUNCTION dbo.jaber2;
go 
create function dbo.jaber2(@tname varchar(3))
returns table
as
return
(
 select tt.Name,tt.SalesYTD,tt.CountryRegionCode
 from Sales.SalesTerritory as tt
 join Sales.SalesOrderHeader  as so on (tt.TerritoryID=so.TerritoryID)
 where  tt.Name = @tname and YEAR(so.OrderDate)=2008 
);
go

select *
from dbo.jaber2('Southwest')


select name
from Sales.SalesTerritory

CREATE TABLE [Production].[ProductLog](
	[ProductID] [int],
	[Name] [dbo].[Name],
	[ProductNumber] [nvarchar](25),
	[MakeFlag] [dbo].[Flag] ,
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15) ,
	[SafetyStockLevel] [smallint] ,
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money],
	[Size] [nvarchar](5) ,
	[SizeUnitMeasureCode] [nchar](3),
	[WeightUnitMeasureCode] [nchar](3) ,
	[Weight] [decimal](8, 2),
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) ,
	[Class] [nchar](2),
	[Style] [nchar](2) ,
	[ProductSubcategoryID] [int],
	[ProductModelID] [int] ,
	[SellStartDate] [datetime],
	[SellEndDate] [datetime] ,
	[DiscontinuedDate] [datetime] ,
	[rowguid] [uniqueidentifier] ,
	[ModifiedDate] [datetime] )

go 
create trigger jaber on Production.Product
after update,delete,insert
as
begin
if((select count(*) from deleted) > 0 )
	Begin
	insert into ProductLog  select * from inserted
	end
if((select count(*) from inserted) >0)
	begin
	insert into ProductLog  select * from deleted
	end

end
go


--in product log table, we alter it and making new column type
