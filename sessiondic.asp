<% Option Explicit %>  
<html>  
<head>  
<title>ShotDev.Com Tutorial</title>  
</head>  
<body>  
<%  
Dim strObjDic,List  
Set strObjDic = Server.CreateObject("Scripting.Dictionary")  
  
strObjDic.Add "re","Red"  
strObjDic.Add "gr","Green"  
strObjDic.Add "bl","Blue"  
strObjDic.Add "pi","Pink"  
  
Set Session("strObjectDic") = strObjDic  
  
Response.write("Dictionary Created<br>")  
Response.write("Click <a href=viewsessiondic.asp>here</a> to view data<br>")  
  
Set strObjDic = Nothing  
%>  
</body>  
</html> 