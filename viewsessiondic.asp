<% Option Explicit %>  
<html>  
<head>  
<title>ShotDev.Com Tutorial</title>  
</head>  
<body>  
<%  
Dim strObjDic,List  
If (NOT isnull(Session("strObjectDic"))) Then
    ' true
    Set strObjDic = Session("strObjectDic")
  
    For Each List In strObjDic.Keys  
    Response.write List& " = " & strObjDic.Item(List)  & "<br>"  
    Next  
    
    Set strObjDic = Nothing  
End if 

%>  
</body>  
</html> 