-- To enable the feature.
  EXEC sp_configure 'xp_cmdshell', 1
  GO
  -- To update the currently configured value for this feature.
  RECONFIGURE
  GO

sp_configure 'show advanced options', 1; RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1; RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'AllowInProcess', 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'DynamicParameters', 1
GO



select t.Name,t.TerritoryID
from AdventureWorks2012.Sales.SalesTerritory as t

------question3 

EXEC xp_cmdshell 'bcp "select Name,TerritoryID
from AdventureWorks2012.Sales.SalesTerritory " queryout "‪E:\jaber.txt" -T -c -t'

------question4
select *
from AdventureWorks2012.Production.Product


EXEC xp_cmdshell 'bcp "select *
from AdventureWorks2012.Production.Product" queryout "E:\location.dat" -T -c -t'
-----question5

create table xmlTable(
name nvarchar(50) null,
annualsell [xml] null,
establish [xml] ,
staffNum [xml],
);

insert into xmlTable SELECT Name ,Demographics.query('
declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $p in /StoreSurvey
return
  <AnnualSales>
  {$p /AnnualSales}
  </AnnualSales>
  ') as annualsell,Demographics.query('
declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $p in /StoreSurvey
return
<YearOpened>
{$p /YearOpened}
</YearOpened>
') as establish ,Demographics.query('
declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $p in /StoreSurvey
return
<NumberEmployees>
{$p /NumberEmployees}
</NumberEmployees>
') as staffNum
from AdventureWorks2012.Sales.Store
select* 
from dbo.xmlTable

EXEC xp_cmdshell 'bcp "select *
from AdventureWorks2012.dbo.xmlTable" queryout "E:\xmlTest.txt" -T -c -t'