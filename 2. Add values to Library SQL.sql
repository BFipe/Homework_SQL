use Library_SQL
go
insert into Authors
values 
(N'Лев',N'Толстой',N'Россия',N'1828-08-28'),
(N'Федор',N'Достоевский',N'Россия',N'1821-10-30'),
(N'Александр',N'Пушкин',N'Россия',N'1799-05-26'),
(N'Антон',N'Чехов',N'Россия',N'1860-01-17'),
(N'Иван',N'Тургенев',N'Россия',N'1818-10-28'),
(N'Николай',N'Гоголь',N'Россия',N'1809-03-20'),
(N'Михаил',N'Булгаков',N'Украина',N'1891-05-03'),
(N'Михаил',N'Лермонтов',N'Россия',N'1814-10-15')
go
insert into Books
values 
(N'Муму',(select Id from Authors where Authors.FirstName = N'Иван' and Authors.LastName = N'Тургенев'),1854),
(N'Мертвые души',(select Id from Authors where Authors.FirstName = N'Николай' and Authors.LastName = N'Гоголь'),1842),
(N'Преступление и наказание',(select Id from Authors where Authors.FirstName = N'Федор' and Authors.LastName = N'Достоевский'),1866),
(N'Капитанская дочка',(select Id from Authors where Authors.FirstName = N'Александр' and Authors.LastName = N'Пушкин'),1836),
(N'Война и мир',(select Id from Authors where Authors.FirstName = N'Лев' and Authors.LastName = N'Толстой'),1865),
(N'Хамелеон',(select Id from Authors where Authors.FirstName = N'Антон' and Authors.LastName = N'Чехов'), 1884),
(N'Мастер и Маргарита',(select Id from Authors where Authors.FirstName = N'Михаил' and Authors.LastName = N'Булгаков'),1967),
(N'Герой нашего времени',(select Id from Authors where Authors.FirstName = N'Михаил' and Authors.LastName = N'Лермонтов'),1840)
go
 insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
(N'Илья',N'Максимов',N'ИльяМаксимов@шиломыло',N'2002-11-21',N'Минск Якутского 11'),
(N'Юлия',N'Прохорова',N'НеТакаяКакВсе@шиломыло',N'2004-05-24',N'Минск Лабесова 4'),
(N'Лев',N'Тигрович',N'Леопардовак@шиломыло',N'2000-04-04',N'Минск Божьекоровского 5'),
(N'Татьяна',N'Кадымирина',N'Скулгерл12@шиломыло',N'2006-03-01',N'Минск Якутского 11'),
(N'Леонид',N'Нечитаев',N'Книгискучно@шиломыло',N'2009-02-17',N'Минск Гаждетовского 2')
go
insert into UserBooks (UserId, BookId)
values
((select Id from Users where Users.FirstName = N'Илья'),(select Id from Books where Books.Name = N'Муму')),
((select Id from Users where Users.FirstName = N'Илья'),(select Id from Books where Books.Name = N'Хамелеон')),
((select Id from Users where Users.FirstName = N'Лев'),(select Id from Books where Books.Name = N'Война и мир')),
((select Id from Users where Users.FirstName = N'Юлия'),(select Id from Books where Books.Name = N'Мастер и Маргарита')),
((select Id from Users where Users.FirstName = N'Татьяна'),(select Id from Books where Books.Name = N'Мертвые души')),
((select Id from Users where Users.FirstName = N'Юлия'),(select Id from Books where Books.Name = N'Преступление и наказание'))