<!--#include file="../../connect.asp"-->
<%
    Dim productId
    productId = Request.QueryString("id")

    Set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
cmdPrep.CommandType = 1
    cmdPrep.Prepared = true
    cmdPrep.commandText = "Select deleted from Product where id="&productId&""
    set rs = cmdPrep.execute
    If not rs.eof Then
        if rs("deleted") = "1" then
            cmdPrep.CommandText = "Update Product set deleted = '0' WHERE id="&productId&""
            cmdPrep.execute
        elseif rs("deleted") = "0" then
            cmdPrep.CommandText = "Update Product set deleted = '1' WHERE id="&productId&""
            cmdPrep.execute
        end if
    End If

    response.Redirect("admin.asp?page=managementProduct")
    
%>