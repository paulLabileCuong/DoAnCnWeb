<!--#include file="../../connect.asp"-->
<%
    Dim category_id
    category_id = Request.QueryString("id")

    Set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = true
    cmdPrep.commandText = "Select deleted from Category where id="&category_id&""
    set rs = cmdPrep.execute
    If not rs.eof Then
        if rs("deleted") = "1" then
            cmdPrep.CommandText = "Update Category set deleted = '0' WHERE id="&category_id&""
            cmdPrep.execute
        elseif rs("deleted") = "0" then
            cmdPrep.CommandText = "Update Category set deleted = '1' WHERE id="&category_id&""
            cmdPrep.execute
        end if
    End If

    response.Redirect("admin.asp?page=managementCategory")
    
%>