create database Library_SQL
go
use Library_SQL
go
create table Authors(
 Id int not null identity(1, 1) constraint PK_Authors_Id primary key, 
 FirstName nvarchar(50) not null,
 LastName nvarchar(50) not null,
 Country nvarchar(50) not null,
 BirthDate date not null,
)
go
create table Books (
 Id int not null identity(1, 1) constraint PK_Books_Id primary key, 
 Name nvarchar(50) null,
 AuthorId int not null references Authors(Id),
 Year int not null,
)
go
create table Users (
 Id int not null identity(1, 1) constraint PK_Users_Id primary key, 
 FirstName nvarchar(50) not null,
 LastName nvarchar(50) not null,
 Email nvarchar(50) not null unique,
 BirthDate date not null,
 Age int null,
 Address nvarchar(70) not null,
 ExpiredDate date,
)
go
create table UserBooks (
 Id int not null identity(1, 1) constraint PK_UserBooks_Id primary key, 
 UserId int not null references Users(Id) on delete cascade,
 BookId int not null references Books(Id) on delete cascade,
 CreatedDate date,
)
go
create or alter trigger UpdateCreatedDate 
    on UserBooks
    after insert
    as 
	update UserBooks 
	set CreatedDate = CONVERT(date, GETDATE())
	where Id in (select Id from inserted);
go
create or alter trigger UpdateExpiredDateAndAge 
    on Users
    after insert
    as
	begin
	update Users
	set ExpiredDate = GETDATE() + 365
	where Id in (select Id from inserted);
	update Users
	set Age = DATEDIFF(year, BirthDate, CONVERT(date, GETDATE()) )
	where Id in (select Id from inserted);
    end
go
create unique nonclustered index IX_UserId_BookId_Unique
on UserBooks(UserId asc, BookId asc)
go
create unique nonclustered index IX_Name_AuthorId_Unique
on Books(Name asc, AuthorId asc)
go
create unique nonclustered index IX_FirstName_LastName_Country_Unique
on Authors(FirstName asc, LastName asc, Country asc)

