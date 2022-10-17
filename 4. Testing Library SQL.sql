use Library_SQL
go
select * from UserBooks
go
exec GiveBookToUser N'Книгискучно@шиломыло', N'Александр', N'Пушкин', N'Капитанская дочка'
go
exec ReturnBook N'ИльяМаксимов@шиломыло', N'Антон', N'Чехов', N'Хамелеон'
go
exec ReturnBook N'НеТакаяКакВсе@шиломыло', N'Михаил', N'Булгаков', N'Мастер и Маргарита'
go
exec DeleteUsersByExpiredDate