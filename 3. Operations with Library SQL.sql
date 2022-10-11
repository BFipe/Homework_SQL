create or alter view UserInfo
as 
select 
U.Id as UserId,
U.FirstName + ' ' + U.LastName as UserFullName, 
U.Age as UserAge,
A.FirstName + ' ' + A.LastName as AuthorFullName,
B.Name as BookName,
B.Year as BookYear,
UB.CreatedDate as WhenBookWasTaken
from UserBooks UB
         right join Users U on U.Id = UB.UserId
         left join Books B on B.Id = UB.BookId
		 left join Authors A on A.Id = B.AuthorId

------------------------------------------------------------

create procedure GiveBookToUser(@Email nvarchar(50),@AuthorFirstName nvarchar(50), @AuthorLastName nvarchar(50), @BookName nvarchar(50))
as
begin
 declare @EmailStatus int = iif(@Email IN (SELECT Email FROM Users), 1, 0)
 if @EmailStatus = 0
	begin
		print 'Такого юзера не существует'
		return;
	end

 declare @AuthorStatus int = iif(Concat(@AuthorFirstName, ' ', @AuthorLastName)  IN (Select Concat(FirstName, ' ', LastName) from Authors) ,1,0)
  if @AuthorStatus = 0
	begin
		print 'Такого автора не существует'
		return;
	end

 declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print 'Такой книги не существует'
		return;
	end

  declare @AuthorFullName nvarchar(50) = Concat(@AuthorFirstName, ' ', @AuthorLastName)
  declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
  if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName, ' ', LastName)) 
   begin
        declare @AuthorOfThisBook nvarchar(50) = (Select Concat(FirstName, ' ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print 'Такой книги у автора нет, автор этой книги - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 1
	begin
		print 'Эту книгу уже взяли'
		return;
	end

 insert into UserBooks (UserId, BookId)
 values
 ((select Id from Users where Users.Email = @Email), @BookId)
 print 'Вы взяли книгу "' + @BookName + '" автора ' + @AuthorFullName
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
create or alter procedure ChargeUser @Email nvarchar(50)
as
begin
	declare @Sum int = (select sum(dbo.GetCharge(CreatedDate, 60)) from UserBooks where UserId = (select Id from Users where @Email = Email))
	update UserBooks set ToCharge = @Sum where UserId = (select Id from Users where Email = @Email)
end

------------------------------------------------------------
Create or alter procedure ReturnBook (@Email nvarchar(50),@AuthorFirstName nvarchar(50), @AuthorLastName nvarchar(50), @BookName nvarchar(50))
as
begin
 declare @EmailStatus int = iif(@Email IN (SELECT Email FROM Users), 1, 0)
 if @EmailStatus = 0
	begin
		print 'Такого юзера не существует'
		return;
	end

 declare @AuthorStatus int = iif(Concat(@AuthorFirstName, ' ', @AuthorLastName)  IN (Select Concat(FirstName, ' ', LastName) from Authors) ,1,0)
  if @AuthorStatus = 0
	begin
		print 'Такого автора не существует'
		return;
	end

 declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print 'Такой книги не существует'
		return;
	end

  declare @AuthorFullName nvarchar(50) = Concat(@AuthorFirstName, ' ', @AuthorLastName)
  declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
  if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName, ' ', LastName)) 
   begin
        declare @AuthorOfThisBook nvarchar(50) = (Select Concat(FirstName, ' ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print 'Такой книги у автора нет, автор этой книги - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 0
	begin
		print 'Эту книгу еще не брали'
		return;
	end

 exec ChargeUser @Email
 declare @ChargeAmount int = (select ToCharge from UserBooks where BookId = @BookId) 
 print concat('Вы должны ', @ChargeAmount ,' за удержание книги')
 delete from UserBooks where BookId = @BookId
end

