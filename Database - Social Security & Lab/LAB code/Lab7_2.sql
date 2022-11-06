select * from OPENROWSET
('Microsoft.ACE.OLEDB.12.0', 'E:\Database2.mdb';
'admin'; '', Table1)


EXEC xp_cmdshell 'bcp "select name, territoryID from AdventureWorks2012.Sales.SalesTerritory" queryout "E:\test.txt" -T -c -t,';

EXEC xp_cmdshell 'bcp "select * from AdventureWorks2012.Production.Location" queryout "E:\location.dat" -T -c -t,';

create table test(
Name varchar(200),
yearopened xml,
empnumber xml,
)

insert into test
SELECT Name , Demographics.query('
declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $P in /StoreSurvey
return
$P/YearOpened
') as YearOpened ,Demographics.query('
declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $P in /StoreSurvey
return
$P/NumberEmployees
') as NumberEmployees
FROM AdventureWorks2012.Sales.Store

EXEC xp_cmdshell 'bcp AdventureWorks2012.dbo.test out "E:\xmltest.txt" -T -c'