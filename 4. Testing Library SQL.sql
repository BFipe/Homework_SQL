use Library_SQL
go

select * from UserInfo
go
exec GiveBookToUser 'Книгискучно@шиломыло', 'Александр', 'Пушкин', 'Капитанская дочка'
go
exec ReturnBook 'ИльяМаксимов@шиломыло', 'Антон', 'Чехов', 'Хамелеон'
go
exec ReturnBook 'НеТакаяКакВсе@шиломыло', 'Михаил', 'Булгаков', 'Мастер и Маргарита'
go
delete from Users where ExpiredDate < GETDATE() 
 