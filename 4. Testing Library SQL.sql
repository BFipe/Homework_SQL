use Library_SQL
go
select * from UserInfo
go
exec GiveBookToUser N'�����������@��������', N'���������', N'������', N'����������� �����'
go
exec ReturnBook N'������������@��������', N'�����', N'�����', N'��������'
go
exec ReturnBook N'�������������@��������', N'������', N'��������', N'������ � ���������'
go
delete from Users where ExpiredDate < GETDATE() 
 