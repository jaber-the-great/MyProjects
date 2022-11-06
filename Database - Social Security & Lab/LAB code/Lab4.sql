-- 1
use AdventureWorks2012;
SELECT Name From Production.Product WHERE Name like '%e_' AND len(Name) < 15;

-- 2
IF OBJECT_ID (N'myFunc') IS NOT NULL
DROP FUNCTION myFunc;
GO
CREATE FUNCTION myFunc(@phone_number varchar(11))
RETURNS varchar(50)
AS
BEGIN
	DECLARE @ret varchar(50)
	IF @phone_number not like '0%'
	BEGIN
		SET @ret = 'invlid phone number';
	END
	ELSE 
	BEGIN
		IF @phone_number like '09%'
			SET @ret = 'mobile phone number';
		ELSE 
		BEGIN
			DECLARE @last varchar(8)
			DECLARE @code varchar(3)
			DECLARE @city varchar(10)

			SET @last = SUBSTRING(@phone_number, 4, 11)
			SET @code = SUBSTRING(@phone_number, 1, 3)
			IF @code like '031'
				SET @city = 'Esfahan'
			ELSE 
				SET @city = 'Tehran'
			SET @ret = CONCAT('last 8 digits=',@last,',city code=',@city, ',city=',@code);
		END
	END
	RETURN @ret
END;
select dbo.myFunc('02188888888');
-- 3
IF OBJECT_ID (N'terr_info') IS NOT NULL
DROP FUNCTION myFunc;
GO
CREATE FUNCTION terr_info(@name varchar(50))
RETURNS TABLE
AS
RETURN
(
	SELECT [SalesOrderID]
      ,[RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[SalesOrderNumber]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,Sales.SalesOrderHeader.[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[TotalDue]
      ,[Comment]
      ,Sales.SalesOrderHeader.[rowguid]
      ,Sales.SalesOrderHeader.[ModifiedDate]
	FROM Sales.SalesOrderHeader JOIN Sales.SalesTerritory ON
	 (Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
	WHERE YEAR(Sales.SalesOrderHeader.OrderDate) = 2008 and Sales.SalesTerritory.Name = @name
);

-- 4
CREATE TABLE [Production].[ProductLogs](
	[ProductID] [int],
	[Name] [dbo].[Name],
	[ProductNumber] [nvarchar](25),
	[MakeFlag] [dbo].[Flag],
	[FinishedGoodsFlag] [dbo].[Flag],
	[Color] [nvarchar](15),
	[SafetyStockLevel] [smallint],
	[ReorderPoint] [smallint],
	[StandardCost] [money],
	[ListPrice] [money],
	[Size] [nvarchar](5),
	[SizeUnitMeasureCode] [nchar](3),
	[WeightUnitMeasureCode] [nchar](3),
	[Weight] [decimal](8, 2),
	[DaysToManufacture] [int],
	[ProductLine] [nchar](2),
	[Class] [nchar](2),
	[Style] [nchar](2),
	[ProductSubcategoryID] [int],
	[ProductModelID] [int],
	[SellStartDate] [datetime],
	[SellEndDate] [datetime],
	[DiscontinuedDate] [datetime],
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime],
	query_type varchar(10) check (query_type in ('delete', 'insert', 'update'))
);

IF OBJECT_ID (N'log_product') IS NOT NULL
DROP FUNCTION myFunc;
GO
CREATE TRIGGER log_product ON Production.Product
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
	IF (SELECT COUNT(*) FROM inserted) > 0 AND (SELECT COUNT(*) FROM deleted) > 0
	BEGIN
		INSERT INTO Production.ProductLogs SELECT *,'update' FROM inserted
	END
	ELSE 
	BEGIN
		IF (SELECT COUNT(*) FROM inserted) > 0
			INSERT INTO Production.ProductLogs SELECT *,'insert' FROM inserted
		ELSE
			INSERT INTO Production.ProductLogs SELECT *,'delete' FROM deleted
	END
END;
--test trigger
update Production.Product set MakeFlag = 1 where ProductID = 1