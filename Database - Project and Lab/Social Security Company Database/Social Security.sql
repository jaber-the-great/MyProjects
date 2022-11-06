create table branch
(
branch_code char(7) primary key,

);


create table staff
(
ID char(7) primary key,
first_name varchar(20)not null,
last_name varchar(30) not null,
birth_day date,
hire_day date,
salary numeric(10,2),
position varchar(20),
branch_code char(7) not null,
national_code numeric(10,0) unique,
foreign key (branch_code) references branch(branch_code),
)


create table medical_station
(
medical_station_code char(7) primary key,
name varchar(20),
belongsTo char(3) check (belongsTO in ('YES', 'NO')),
)

create table doctor
(
Mediacal_code char(7) primary key,
first_name varchar(20)not null,
last_name varchar(30) not null,
birth_day date,
speciality varchar(30),
national_code numeric(10,0) unique,
contract_rate numeric(4,2) not null,
);

alter table doctor
add avg_salary numeric(10,2)

create table doctor_workat
(
Medical_code char(7),
medical_station_code char(7),
start_day date,
foreign key (medical_station_code) references medical_station(medical_station_code),
foreign key (Medical_code) references doctor(Mediacal_code),
primary key(medical_station_code,Medical_code),

);

create table insured
(
SSN char(11) primary key,
first_name varchar(20)not null,
last_name varchar(30) not null,
birth_day date,
begin_date date,
kind varchar(20) default 'ordinary',
payment_per_period numeric(10,2),
isRetired char(3) check ( isRetired in ('YES','NO')),
salary numeric(10,2),
national_code numeric(10,0) unique,
periods int check (periods >= 0),
branch_code char(7) not null,
foreign key (branch_code) references branch(branch_code),

);




--//////////////////phones
create table phone_stations
(
medical_station_code char(7) default null,
branch_code char(7) default null,
phone_number numeric(11,0) primary key,
foreign key (medical_station_code) references medical_station(medical_station_code),
foreign key (branch_code) references branch(branch_code),
);


create table phone_person
(
staff_id char(7) default null,
SSN char (11) default null,
Medical_code char(7) default null,
phone_number numeric(11,0) primary key,
foreign key (staff_id) references staff(ID),
foreign key (SSN) references insured(SSN),
foreign key (Medical_code) references doctor(Mediacal_code),
);
--///////////////
--///////////////address
create table add_stations
(
postal_code numeric(10,0) primary key,
province varchar(20),
city varchar(20),
pelak varchar(3),
street varchar(20),
alley varchar(20),
medical_station_code char(7) default null,
branch_code char(7) default null,
foreign key (medical_station_code) references medical_station(medical_station_code),
foreign key (branch_code) references branch(branch_code),
);


create table add_person
(
postal_code numeric(10,0) primary key,
province varchar(20),
city varchar(20),
pelak varchar(3),
street varchar(20),
alley varchar(20),
staff_id char(7) default null,
SSN char (11) default null,
Medical_code char(7) default null,
foreign key (staff_id) references staff(ID),
foreign key (SSN) references insured(SSN),
foreign key (Medical_code) references doctor(Mediacal_code),
);
--//////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////
select * 
from medical_station

select branch_code 
from branch

-------/////////////
insert into medical_station(medical_station_code,name,belongsTo) values ('2222228','ghodds','YES')
insert into branch(branch_code) values('0000008')


------//////////////
select first_name , speciality
from doctor 
where Mediacal_code = 3333331

-----//////////////
select * 
from staff
where salary > 20000
Order by first_name
asc

-----/////////////
update staff
set first_name='Mohammad'
where ID = 1111115

-------////////////
select first_name , phone_number
from staff join phone_person on (staff.ID = phone_person.staff_id)

-------////////////
select phone_number , city,street, alley , pelak
from medical_station  join phone_stations on ( medical_station.medical_station_code = phone_stations.medical_station_code)
join add_stations on (phone_stations.medical_station_code = add_stations.medical_station_code)
where medical_station.name='milad'

------////////////
select count(SSN)
from insured

------////////////
select avg(salary) as avrage_salary_of_staff
from staff

------////////////
select count(SSN) as tedad , kind
from insured
group by kind

-----/////////////
select count(dr) as Tedad , cd 
from (select doctor_workat.Medical_code as dr , medical_station_code as cd 
		from doctor_workat
		) as s
group by cd

-----////////////
select first_name 
from staff
where salary>10000
union 
select first_name
from insured
where salary < 30000

------///////////
select first_name
from doctor
where speciality = 'dentist'
except 
select first_name
from doctor
where contract_rate < 50.00

-----///////////
select 
	case speciality
	when 'eye' then 'eye doctor'
	when 'blood vessel' then 'vessel'
end as Takhassos,first_name
from doctor
order by first_name

-----////////////
update  doctor
set speciality = 'Eye doctor'
where speciality='eye'

-----/////////////
select speciality, avg(avg_salary) as avg_salary_of_each_speciality
from doctor 
group by speciality
having avg(avg_salary) >10000

----////////////
select 
	case
	when salary<10000 then salary*0.2
	when salary >=10000 and salary<15000 then  salary*.15
	when salary >=15000 and salary<25000 then salary * .1
	else salary + 1000
end as 'New salary',ID
from staff
order by salary 
desc

------/////////////
select lower(i.first_name),upper(i.last_name)
from insured as i
where kind = 'driver'

------////////////
select SUBSTRING(kind,1,2)
from insured

-----/////////////
insert into insured (SSN,first_name,last_name,begin_date,branch_code) values
('55555555558','Abbas','Ghasemi',CONVERT(Date,getdate()),'0000006')

------////////////
select s.first_name ,s.last_name
,ROW_NUMBER() over (order by salary) as "Row Number"
,RANK() over (order by salary) as "Rank"
,DENSE_RANK() over (order by salary) as "Dense Rank"
,NTILE(3) over (order by salary) as "Ntile 3",
s.salary,p.phone_number
from staff as s left join phone_person as p on (s.ID = p.staff_id)

-----////////////
IF OBJECT_ID (N'dbo.FindDoctor', N'FN') IS NOT NULL
DROP FUNCTION dbo.FindDoctor;
go 
create function dbo.FindDoctor(@takhassos varchar(30))
returns table
as 
return
(select d.first_name,d.last_name,d.contract_rate, m.name as medical_station_name
from doctor as d  left join doctor_workat as w on(d.Mediacal_code = w.Medical_code)
 left join medical_station as m on(w.medical_station_code=m.medical_station_code)
 where d.speciality=@takhassos
)
go

select * 
from dbo.FindDoctor('Eye doctor')


------//////////////
IF OBJECT_ID (N'dbo.StationPhoneNumber', N'FN') IS NOT NULL
DROP FUNCTION dbo.StationPhoneNumber;
go 
create function dbo.StationPhoneNumber(@med_name varchar(20))
returns numeric(11,0)
as begin
	declare @ret numeric(11,0)
	select @ret = p.phone_number
	from medical_station as m join phone_stations as p on(m.medical_station_code=p.medical_station_code)
	where m.name=@med_name
	if(@ret is null)
		set @ret=0;
	return @ret;
end;
go

select dbo.StationPhoneNumber('milad')
select dbo.StationPhoneNumber('Tehran')

-----////////////////
if OBJECT_ID(N'dbo.BranchManager1',N'FN') is not null
drop function dbo.BranchManager1;
go
create function dbo.BranchManager1(@brCode char(7))
returns table
as 
return
(select staff.first_name,staff.last_name,staff.ID
from staff join branch on (staff.branch_code = branch.branch_code)
where branch.branch_code=@brCode and staff.position='manager')
go

select * 
from dbo.BranchManager1('0000003')

------/////////////////
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jaber
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE PhoneOfDoctor
	-- Add the parameters for the stored procedure here
	@p1 varchar(20) = '', 
	@p2 varchar(30) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT p.phone_number
	from doctor as d join phone_person as p on (d.Mediacal_code=p.Medical_code)
	where d.first_name=@p1 and d.last_name = @p2

END
GO


USE [Social_Security]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[PhoneOfDoctor]
		@p1 = N'zahra',
		@p2 = N'nikbakht'

SELECT	'Return Value' = @return_value

GO


-------//////////////
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE DoctorsOfMedicalStations
	-- Add the parameters for the stored procedure here
	@p1 varchar(20) = ''
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select d.first_name,d.last_name,d.speciality
	from doctor as d join doctor_workat  as w on (d.Mediacal_code=w.Medical_code)
	join medical_station as m on(m.medical_station_code = w.medical_station_code)
	where m.name=@p1
END
GO



USE [Social_Security]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DoctorsOfMedicalStations]
		@p1 = N'milad'

SELECT	'Return Value' = @return_value

GO

------/////////////
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE StaffsOfCity 
	-- Add the parameters for the stored procedure here
	@p1 varchar(20)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select s.first_name,s.last_name,s.position
	from staff as s join add_person as a on (s.ID = a.staff_id)
	where a.city =@p1
END
GO

USE [Social_Security]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[StaffsOfCity]
		@p1 = N'Tafresh'

SELECT	'Return Value' = @return_value

GO

-----/////////
create view StaffSalary as 
select s.first_name, s.last_name,s.salary
from staff as s 
where branch_code='0000002'


create view InsuredLog as 
select i.first_name,i.last_name,i.kind,i.payment_per_period,i.periods,i.salary,i.isRetired
from insured as i join add_person as a on (i.SSN = a.SSN)

create view BranchStaffPosition as 
select s.first_name,s.last_name,s.ID,s.position
from staff as s 
where s.branch_code='0000002'


-----//////////////
create trigger InsertStatus on Insured
after insert 
as 
print 'The client successfully inserted into the database'
go


create table staffLog
(
ID char(7) primary key,
first_name varchar(20)not null,
last_name varchar(30) not null,
birth_day date,
hire_day date,
salary numeric(10,2),
position varchar(20),
branch_code char(7) not null,
national_code numeric(10,0) unique,
foreign key (branch_code) references branch(branch_code),
trStatus varchar(10) null,
)


--------/////////////////
go
create trigger StaffLogTr on staff
after update, delete,insert
as 
begin
	if((select count(*) from deleted) > 0)
	begin 
		insert into staffLog(ID,first_name,last_name,birth_day,hire_day,salary,position,branch_code
		,national_code)
		select * from deleted


		update staffLog
		set trStatus = 'deleted'
		where trStatus !='inserted'
	end
	if((select count(*) from inserted) > 0  )
	begin
		insert into staffLog (ID,first_name,last_name,birth_day,hire_day,salary,position,branch_code
		,national_code)
		select* from inserted


		update staffLog
		set trStatus = 'inserted'
		where trStatus !='deleted'
	end
end
go

----////////////
create table doctorLog
(
Mediacal_code char(7) primary key,
first_name varchar(20)not null,
last_name varchar(30) not null,
birth_day date,
speciality varchar(30),
national_code numeric(10,0) unique,
contract_rate numeric(4,2) not null,
trStatus varchar(10) null,
);

alter table doctorLog
add avg_salary numeric(10,2)


go
create trigger doctorLogTr on doctor
after update, delete,insert
as 
begin
	if((select count(*) from deleted) > 0)
	begin 
		insert into doctorLog
		(Mediacal_code,first_name,last_name,birth_day,speciality,national_code,contract_rate,avg_salary)
		select * from deleted


		update doctorLog
		set trStatus = 'deleted'
		where trStatus !='inserted'
	end
	if((select count(*) from inserted) > 0  )
	begin
		insert into doctorLog
		(Mediacal_code,first_name,last_name,birth_day,speciality,national_code,contract_rate,avg_salary)
		select * from deleted


		update doctorLog
		set trStatus = 'inserted'
		where trStatus !='deleted'
	end
end
go



-----//////////////

select first_name, last_name,Mediacal_code,avg_salary,speciality,
sum(avg_salary) over (partition by speciality) as majorIncomeSum,
avg(avg_salary) over (partition by speciality) as majorIncomeAvg
from doctor
order by speciality


-------////////////////
select first_name,last_name,kind,salary,
sum (salary) over (partition by kind order by salary 
					rows between 2 preceding and current row) as SumSalary
from insured
order by salary

-----/////////////
select  kind, payment_per_period,AVG(salary) as avg_salary
from insured
group by grouping sets (kind,payment_per_period)


select 
case grouping(kind)
when 0 then kind
when 1 then 'all kinds'
end as kind,
case grouping (payment_per_period) 
when 0 then payment_per_period
when 1 then 0
end as payment_per_period,
sum(salary) as avg_salary
from insured 
group by cube (kind,payment_per_period)





