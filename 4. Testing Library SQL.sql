use Library_SQL
go
select * from UserBooks
go
exec GiveBookToUser N'�����������@��������', N'���������', N'������', N'����������� �����'
go
exec ReturnBook N'������������@��������', N'�����', N'�����', N'��������'
go
exec ReturnBook N'�������������@��������', N'������', N'��������', N'������ � ���������'
go
exec DeleteUsersByExpiredDate