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
      <h1>Add Product</h1>

      <form method="POST" >
         <div class="mb-3">
            <label for="category_id" class="form-label">Category:</label>
            <select name ="category_id" class="custom-select" >
            <% For Each item in listOfCategory %> 
                <option value="<%=listOfCategory(item).Id %>"><%=listOfCategory(item).Name%></option>
            <% Next %>
            </select>  
         </div>  
         <div class="mb-3">
            <label for="title" class="form-label">Title:</label>
            <input type="text" class="form-control" id="title" name="title" required>
         </div>

         <div class="mb-3">
            <label for="price" class="form-label">Price:</label>
            <input type="text" class="form-control" id="price" name="price" required>
         </div>

         <div class="mb-3">
            <label for="discount" class="form-label">Discount:</label>
            <input type="text" class="form-control" id="discount" name="discount">
         </div>

         <label for="" class="form-label">Thumbnail:</label>
		         <%
		            Dim uploader
		            Set uploader=new AspUploader
		            uploader.Name="thumbnail"
    		
		            uploader.MaxSizeKB=10240
		            uploader.InsertText="Upload File (Max 10M)"
                  uploader.AllowedFileExtensions="*.jpg,*.png,*.gif"
		            uploader.MultipleFilesUpload=true

		            'Where'd the files go?
		            uploader.SaveDirectory="anh"
                  uploader.GetString()
		         %>
               
         <div class="mb-3">
            <button type="submit" class="btn btn-primary">Submit</button>
         </div>

      </form>
   </div> 
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/js/bootstrap.bundle.min.js"></script>
</body>
 </html>
 
<%
   Dim category_id, title, price, discount, thumbnail
   ' Retrieve form data
   If (Request.Form("thumbnail")&""<>"") Then
   
   category_id = Request.Form("category_id")
   title = Request.Form("title")
   price = Request.Form("price")
   discount = Request.Form("discount")  
    dim mvcfile
    Set mvcfile=uploader.GetUploadedFile(Request.Form("thumbnail")) 
    thumbnail =mvcfile.FileName
         Dim cmdPrep
         set cmdPrep = Server.CreateObject("ADODB.Command")
         cmdPrep.ActiveConnection = connDB
         cmdPrep.CommandType=1
         cmdPrep.Prepared=true
         dim sql
         sql = "INSERT INTO Product(category_id, title, price, discount,thumbnail, deleted) VALUES (N'" & category_id & "','" & title & "','" & price & "','" & discount & "','" & thumbnail & "','0')"
         cmdPrep.CommandText =sql
         cmdPrep.execute()
      Response.Redirect("admin.asp?page=management")
   End if

%>