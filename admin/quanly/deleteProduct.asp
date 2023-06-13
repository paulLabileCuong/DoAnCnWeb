<!--#include file="../../connect.asp"-->
<%
    On Error Resume Next
    Dim productId
productId = Request.QueryString("id")

    Set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.CommandText = "Update Product set deleted = '1' WHERE id="&productId&""

    cmdPrep.execute
    If Err.Number = 0 Then
    Session("Success") = "Deleted"    
    Else
        Session("Error") = Err.Description
    End If
    On Error Goto 0 
    response.Redirect("admin.asp?page=managementProduct")
    
%>