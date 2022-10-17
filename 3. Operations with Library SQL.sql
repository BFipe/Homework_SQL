create or alter view UserInfo
as 
select 
U.Id as UserId,
U.FirstName + ' ' + U.LastName as UserFullName, 
U.Email As Email,
U.Age as UserAge,
U.ExpiredDate as ExpiredDate,
A.FirstName + ' ' + A.LastName as AuthorFullName,
B.Name as BookName,
B.Year as BookYear,
UB.CreatedDate as WhenBookWasTaken
from UserBooks UB
         right join Users U on U.Id = UB.UserId
         left join Books B on B.Id = UB.BookId
		 left join Authors A on A.Id = B.AuthorId
------------------------------------------------------------
go
create or alter procedure DeleteUsersByExpiredDate
as
begin
declare @IdExpiredDate table (UserExpiredId int)
declare @IdExpiredDateWithBooks table (UserExpiredId int)
insert into @IdExpiredDate select UserId from UserInfo where BookName is null and ExpiredDate < GETDATE() 
insert into @IdExpiredDateWithBooks select UserId from UserInfo where BookName is not null and ExpiredDate < GETDATE() group by UserId
declare @ExpiredStatus int = coalesce((select Top(1) * from @IdExpiredDate), 0)
declare @ExpiredStatusWithBooks int = coalesce((select Top(1) * from @IdExpiredDateWithBooks), 0)

	while @ExpiredStatus != 0
	begin
	declare @UserWithoutBooks nvarchar(50) = concat((select UserFullName from UserInfo where UserId = @ExpiredStatus), ', Email - ', (select Email from UserInfo where UserId = @ExpiredStatus))
	delete from Users where Id in (select * from @IdExpiredDate where UserExpiredId = @ExpiredStatus)
	print concat('Юзер ', @UserWithoutBooks,' успешно удален!')
	delete from @IdExpiredDate where UserExpiredId = @ExpiredStatus
	set @ExpiredStatus = coalesce((select Top(1) * from @IdExpiredDate), 0)
	end
	
	while @ExpiredStatusWithBooks != 0
	begin
	declare @UserWithBooks nvarchar(50) = concat((select UserFullName from UserInfo where UserId = @ExpiredStatusWithBooks group by UserFullName), ', Email - ', (select Email from UserInfo where UserId = @ExpiredStatusWithBooks group by Email))
	print concat('Невозможно удалить юзера ', @UserWithBooks, ' так как у него все еще есть книги!' ) 
	delete from @IdExpiredDateWithBooks where UserExpiredId = @ExpiredStatusWithBooks
	set @ExpiredStatusWithBooks = coalesce((select Top(1) * from @IdExpiredDateWithBooks), 0)
	end

	print 'Процедура по удалению юзеров с истекшим сроком хранения данных успешно завершена!'
end

------------------------------------------------------------
go
create or alter procedure GiveBookToUser(@Email nvarchar(50),@AuthorFirstName nvarchar(50), @AuthorLastName nvarchar(50), @BookName nvarchar(50))
as
begin
 declare @EmailStatus int = iif(@Email IN (SELECT Email FROM Users), 1, 0)
 if @EmailStatus = 0
	begin
		print N'Такого юзера не существует'
		return;
	end

 declare @AuthorFullName nvarchar(50) = Concat(@AuthorFirstName, ' ', @AuthorLastName)
 declare @AuthorStatus int = iif(@AuthorFullName IN (Select Concat(FirstName, ' ', LastName) from Authors) ,1,0)
  if @AuthorStatus = 0
	begin
		print N'Такого автора не существует'
		return;
	end

 declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print N'Такой книги не существует'
		return;
	end

  declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
  if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName, ' ', LastName)) 
   begin
        declare @AuthorOfThisBook nvarchar(50) = (Select Concat(FirstName, ' ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print N'Такой книги у автора нет, автор этой книги - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 1
	begin
		print N'Эту книгу уже взяли'
		return;
	end

 insert into UserBooks (UserId, BookId)
 values
 ((select Id from Users where Users.Email = @Email), @BookId)
 print N'Вы взяли книгу "' + @BookName + N'" автора ' + @AuthorFullName
end
go
------------------------------------------------------------
alter table UserBooks
 add ToCharge money null
 -----------------------------------------------------------
go
create or alter function GetCharge(@CreationDate date, @BookHoldingDuration int)
    returns money
begin
    declare @Result money, @Status int
	set @Status = DATEDIFF(day, @CreationDate, CONVERT(date, GETDATE()))
    select @Result = iif(@Status > @BookHoldingDuration , (@Status - @BookHoldingDuration) * 2.7, 0)  
    return @Result;
end
go

create or alter procedure ChargeUser @Email nvarchar(50), @BookId int
as
begin
	declare @Sum int = (select dbo.GetCharge(CreatedDate, 60) from UserBooks where UserId = (select Id from Users where @Email = Email) and BookId = @BookId)
	update UserBooks set ToCharge = @Sum where UserId = (select Id from Users where Email = @Email) and BookId = @BookId
end
go
------------------------------------------------------------
Create or alter procedure ReturnBook (@Email nvarchar(50),@AuthorFirstName nvarchar(50), @AuthorLastName nvarchar(50), @BookName nvarchar(50))
as
begin
 declare @EmailStatus int = iif(@Email IN (SELECT Email FROM Users), 1, 0)
 if @EmailStatus = 0
	begin
		print N'Такого юзера не существует'
		return;
	end

 declare @AuthorStatus int = iif(Concat(@AuthorFirstName, ' ', @AuthorLastName)  IN (Select Concat(FirstName, ' ', LastName) from Authors) ,1,0)
  if @AuthorStatus = 0
	begin
		print N'Такого автора не существует'
		return;
	end

 declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print N'Такой книги не существует'
		return;
	end

  declare @AuthorFullName nvarchar(50) = Concat(@AuthorFirstName, ' ', @AuthorLastName)
  declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
  if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName, ' ', LastName)) 
   begin
        declare @AuthorOfThisBook nvarchar(50) = (Select Concat(FirstName, ' ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print N'Такой книги у автора нет, автор этой книги - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 0
	begin
		print N'Эту книгу еще не брали'
		return;
	end

 exec ChargeUser @Email, @BookId
 declare @ChargeAmount int = (select ToCharge from UserBooks where BookId = @BookId) 
 print concat(N'Вы должны ', @ChargeAmount ,N' за удержание книги')
 delete from UserBooks where BookId = @BookId
end

