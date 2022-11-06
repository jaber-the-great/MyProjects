
CREATE TABLE Students
(
FirstName varchar(20) NOT NULL,
LastName varchar(30) NOT NULL ,
StudentNumber char(7) PRIMARY KEY,
BirthYear int,
DepartmentID char(5),
AdvisorID char(7),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
FOREIGN KEY (AdvisorID) REFERENCES Teachers(ID)
);


CREATE TABLE Departments
(
Name varchar(20) NOT NULL ,
ID char(5) PRIMARY KEY,
Budget numeric(12,2),
Category varchar(15) Check (Category in ('Engineering','Science'))
);
CREATE TABLE Teachers
(
FirstName varchar(20) NOT NULL,
LastName varchar(30) NOT NULL ,
ID char(7),
BirthYear int,
DepartmentID char(5),
Salary numeric(7,2) Default 10000.00,
PRIMARY KEY (ID),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
);


alter table Students
add credits int


create table course 
(
ID char(7) primary key,
tilte varchar(15) not null,
credits int check(credits >0 and credits <10),
departmentID char(5),
foreign key (departmentID) references Departments(ID),
);


create table Available_courses 
(
ID char(7) primary key,
courseID char(7),
semester varchar(15) check(semester in('fall','spring')),
year int not null,
TeacherID char(7),
foreign key (courseID) references course(ID),
foreign key (teacherID) references teachers(ID),
);


create table taken_courses
(
studentID char(7),
courseID char(7),
semester varchar(15) check(semester in('fall','spring')),
year int,
grade int check(grade>0),
primary key (courseID,StudentID,semester,year),
foreign key (courseID) references course(ID),
foreign key (studentID) references students(StudentNumber),
); 



CREATE TABLE PREREQUISITES
(
courseID char(7),
PrereqID char(7),
primary key (courseID, prereqID),
foreign key (courseID) references course(ID),
foreign key (prereqID) references course(ID),
);

select Departments.Name as dname,avg(grade) as avrage 
from Students  inner join taken_courses on(Students.StudentNumber=taken_courses.studentID) 
	 inner join  Departments on (Students.departmentID=Departments.ID)
group by Departments.Name


select avg(grade) as total_avg
from taken_courses inner join Students on (Students.StudentNumber=taken_courses.studentID)


;;;;;;;
with deptRank(value1,value2) as (select Students.StudentNumber,avg(grade) as studentAvg
		from  Students  inner join taken_courses on(Students.StudentNumber=taken_courses.studentID) 
	 inner join  Departments on (Students.departmentID=Departments.ID)
	 group by Students.StudentNumber)
select Departments.Name as deptname,Max(value2) as maximum, min(value2) as minimum
from deptRank inner join Students on(deptRank.value1 = Students.StudentNumber) 
inner join Departments on(Students.DepartmentID=Departments.ID)
group by Departments.Name
						


select avg(salary) as avrage_salary , Teachers.ID as ID
from Teachers 
where Teachers.ID  in(select TeacherID
							from Available_courses)							
group by Teachers.ID




with func(v1,v2) as (select Teachers.ID,avg(Teachers.Salary)
						from Teachers
						group by Teachers.ID)
select func.v1 as TeacherID , max(v2) as maximum_salary
from func 
group by v1



with oftade(v1,v2) as (select taken_courses.courseID, count (Students.StudentNumber)
						from taken_courses inner join Students on (taken_courses.studentID=
						Students.StudentNumber)
						where taken_courses.grade <10
						group by taken_courses.courseID)
select course.ID,course.tilte,course.credits
from oftade inner join course on (oftade.v1=course.ID)
group by course.ID,course.tilte,course.credits