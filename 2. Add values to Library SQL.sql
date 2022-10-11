use Library_SQL

insert into Authors
values 
('���','�������','������','1828-08-28'),
('�����','�����������','������','1821-10-30'),
('���������','������','������','1799-05-26'),
('�����','�����','������','1860-01-17'),
('����','��������','������','1818-10-28'),
('�������','������','������','1809-03-20'),
('������','��������','�������','1891-05-03'),
('������','���������','������','1814-10-15')

insert into Books
values 
('����',(select Id from Authors where Authors.FirstName = '����' and Authors.LastName = '��������'),1854),
('������� ����',(select Id from Authors where Authors.FirstName = '�������' and Authors.LastName = '������'),1842),
('������������ � ���������',(select Id from Authors where Authors.FirstName = '�����' and Authors.LastName = '�����������'),1866),
('����������� �����',(select Id from Authors where Authors.FirstName = '���������' and Authors.LastName = '������'),1836),
('����� � ���',(select Id from Authors where Authors.FirstName = '���' and Authors.LastName = '�������'),1865),
('��������',(select Id from Authors where Authors.FirstName = '�����' and Authors.LastName = '�����'), 1884),
('������ � ���������',(select Id from Authors where Authors.FirstName = '������' and Authors.LastName = '��������'),1967),
('����� ������ �������',(select Id from Authors where Authors.FirstName = '������' and Authors.LastName = '���������'),1840)

 insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
('����','��������','������������@��������','2002-11-21','����� ��������� 11'),
('����','���������','�������������@��������','2004-05-24','����� �������� 4'),
('���','��������','�����������@��������','2000-04-04','����� ��������������� 5'),
('�������','����������','��������12@��������','2006-03-01','����� ��������� 11'),
('������','��������','�����������@��������','2009-02-17','����� ������������� 2')

insert into UserBooks (UserId, BookId)
values
((select Id from Users where Users.FirstName = '����'),(select Id from Books where Books.Name = '����')),
((select Id from Users where Users.FirstName = '����'),(select Id from Books where Books.Name = '��������')),
((select Id from Users where Users.FirstName = '���'),(select Id from Books where Books.Name = '����� � ���')),
((select Id from Users where Users.FirstName = '����'),(select Id from Books where Books.Name = '������ � ���������')),
((select Id from Users where Users.FirstName = '�������'),(select Id from Books where Books.Name = '������� ����')),
((select Id from Users where Users.FirstName = '����'),(select Id from Books where Books.Name = '������������ � ���������'))