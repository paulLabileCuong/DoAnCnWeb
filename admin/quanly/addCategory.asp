<!-- #include file="../../aspuploader/include_aspuploader.asp" -->
<!--#include file="../../connect.asp"-->
<!--#include file="../../model/Category.asp"-->


<%
   Set listOfCategory = Server.CreateObject("Scripting.Dictionary")
    set  recordset = connDB.execute("select * from Category")
   Dim aCategory, seq
   seq = 0
  Do While Not recordset.EOF
    seq = seq+1
    set aCategory = New Category
    aCategory.Id = recordset.Fields("id")
    aCategory.Name = recordset.Fields("Name")
    listOfCategory.add seq, aCategory
    recordset.MoveNext
  Loop 
%>

<!DOCTYPE html >
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Add Product</title>
   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/css/bootstrap.min.css">
</head>
<body>
   <div class="container">
      <h1>Thêm thể loại</h1>

      <form method="POST" > 
         <div class="mb-3">
            <label for="title" class="form-label">Tên:</label>
            <input type="text" class="form-control" id="name" name="name" required>
         </div> 
         <div class="mb-3">
            <button type="submit" class="btn btn-primary">Nhập</button>
         </div>

      </form>
   </div> 
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/js/bootstrap.bundle.min.js"></script>
</body>
 </html>
 
<%
   Dim name
   ' Retrieve form data
   If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
   
  name = Request.Form("name")
         Dim cmdPrep
         set cmdPrep = Server.CreateObject("ADODB.Command")
         cmdPrep.ActiveConnection = connDB
         cmdPrep.CommandType=1
         cmdPrep.Prepared=true
         dim sql
         sql = "INSERT INTO Category(name) VALUES ('" & name & "')"
         cmdPrep.CommandText =sql
         cmdPrep.execute()
      Response.Redirect("admin.asp?page=managementCategory")
   End if

%>