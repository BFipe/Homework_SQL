use Library_SQL
go

select * from UserInfo
go
exec GiveBookToUser '�����������@��������', '���������', '������', '����������� �����'
go
exec ReturnBook '������������@��������', '�����', '�����', '��������'
go
exec ReturnBook '�������������@��������', '������', '��������', '������ � ���������'
go
delete from Users where ExpiredDate < GETDATE() 
 