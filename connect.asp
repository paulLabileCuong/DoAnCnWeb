<%
' code here
Dim connDB
set connDB = Server.CreateObject("ADODB.Connection")
Dim strConnection
strConnection = "Provider=SQLOLEDB.1;Data Source=CUONG\SQLEXPRESS;Database=DoAnNopFinal;User Id=Cuong;Password=Cuong123"
connDB.ConnectionString = strConnection
connDB.Open
%>