use Library_SQL
go
insert into Authors
values 
(N'���',N'�������',N'������',N'1828-08-28'),
(N'�����',N'�����������',N'������',N'1821-10-30'),
(N'���������',N'������',N'������',N'1799-05-26'),
(N'�����',N'�����',N'������',N'1860-01-17'),
(N'����',N'��������',N'������',N'1818-10-28'),
(N'�������',N'������',N'������',N'1809-03-20'),
(N'������',N'��������',N'�������',N'1891-05-03'),
(N'������',N'���������',N'������',N'1814-10-15')
go
insert into Books
values 
(N'����',(select Id from Authors where Authors.FirstName = N'����' and Authors.LastName = N'��������'),1854),
(N'������� ����',(select Id from Authors where Authors.FirstName = N'�������' and Authors.LastName = N'������'),1842),
(N'������������ � ���������',(select Id from Authors where Authors.FirstName = N'�����' and Authors.LastName = N'�����������'),1866),
(N'����������� �����',(select Id from Authors where Authors.FirstName = N'���������' and Authors.LastName = N'������'),1836),
(N'����� � ���',(select Id from Authors where Authors.FirstName = N'���' and Authors.LastName = N'�������'),1865),
(N'��������',(select Id from Authors where Authors.FirstName = N'�����' and Authors.LastName = N'�����'), 1884),
(N'������ � ���������',(select Id from Authors where Authors.FirstName = N'������' and Authors.LastName = N'��������'),1967),
(N'����� ������ �������',(select Id from Authors where Authors.FirstName = N'������' and Authors.LastName = N'���������'),1840)
go
 insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
(N'����',N'��������',N'������������@��������',N'2002-11-21',N'����� ��������� 11'),
(N'����',N'���������',N'�������������@��������',N'2004-05-24',N'����� �������� 4'),
(N'���',N'��������',N'�����������@��������',N'2000-04-04',N'����� ��������������� 5'),
(N'�������',N'����������',N'��������12@��������',N'2006-03-01',N'����� ��������� 11'),
(N'������',N'��������',N'�����������@��������',N'2009-02-17',N'����� ������������� 2')
go
insert into UserBooks (UserId, BookId)
values
((select Id from Users where Users.FirstName = N'����'),(select Id from Books where Books.Name = N'����')),
((select Id from Users where Users.FirstName = N'����'),(select Id from Books where Books.Name = N'��������')),
((select Id from Users where Users.FirstName = N'���'),(select Id from Books where Books.Name = N'����� � ���')),
((select Id from Users where Users.FirstName = N'����'),(select Id from Books where Books.Name = N'������ � ���������')),
((select Id from Users where Users.FirstName = N'�������'),(select Id from Books where Books.Name = N'������� ����')),
((select Id from Users where Users.FirstName = N'����'),(select Id from Books where Books.Name = N'������������ � ���������'))