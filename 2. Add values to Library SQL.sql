use Library_SQL

insert into Authors
values 
('Лев','Толстой','Россия','1828-08-28'),
('Федор','Достоевский','Россия','1821-10-30'),
('Александр','Пушкин','Россия','1799-05-26'),
('Антон','Чехов','Россия','1860-01-17'),
('Иван','Тургенев','Россия','1818-10-28'),
('Николай','Гоголь','Россия','1809-03-20'),
('Михаил','Булгаков','Украина','1891-05-03'),
('Михаил','Лермонтов','Россия','1814-10-15')

insert into Books
values 
('Муму',(select Id from Authors where Authors.FirstName = 'Иван' and Authors.LastName = 'Тургенев'),1854),
('Мертвые души',(select Id from Authors where Authors.FirstName = 'Николай' and Authors.LastName = 'Гоголь'),1842),
('Преступление и наказание',(select Id from Authors where Authors.FirstName = 'Федор' and Authors.LastName = 'Достоевский'),1866),
('Капитанская дочка',(select Id from Authors where Authors.FirstName = 'Александр' and Authors.LastName = 'Пушкин'),1836),
('Война и мир',(select Id from Authors where Authors.FirstName = 'Лев' and Authors.LastName = 'Толстой'),1865),
('Хамелеон',(select Id from Authors where Authors.FirstName = 'Антон' and Authors.LastName = 'Чехов'), 1884),
('Мастер и Маргарита',(select Id from Authors where Authors.FirstName = 'Михаил' and Authors.LastName = 'Булгаков'),1967),
('Герой нашего времени',(select Id from Authors where Authors.FirstName = 'Михаил' and Authors.LastName = 'Лермонтов'),1840)

 insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
('Илья','Максимов','ИльяМаксимов@шиломыло','2002-11-21','Минск Якутского 11'),
('Юлия','Прохорова','НеТакаяКакВсе@шиломыло','2004-05-24','Минск Лабесова 4'),
('Лев','Тигрович','Леопардовак@шиломыло','2000-04-04','Минск Божьекоровского 5'),
('Татьяна','Кадымирина','Скулгерл12@шиломыло','2006-03-01','Минск Якутского 11'),
('Леонид','Нечитаев','Книгискучно@шиломыло','2009-02-17','Минск Гаждетовского 2')

insert into UserBooks (UserId, BookId)
values
((select Id from Users where Users.FirstName = 'Илья'),(select Id from Books where Books.Name = 'Муму')),
((select Id from Users where Users.FirstName = 'Илья'),(select Id from Books where Books.Name = 'Хамелеон')),
((select Id from Users where Users.FirstName = 'Лев'),(select Id from Books where Books.Name = 'Война и мир')),
((select Id from Users where Users.FirstName = 'Юлия'),(select Id from Books where Books.Name = 'Мастер и Маргарита')),
((select Id from Users where Users.FirstName = 'Татьяна'),(select Id from Books where Books.Name = 'Мертвые души')),
((select Id from Users where Users.FirstName = 'Юлия'),(select Id from Books where Books.Name = 'Преступление и наказание'))