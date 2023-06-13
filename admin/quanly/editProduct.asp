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
   <script type="text/javascript">
		var handlerurl='misc-filemanager-handler.asp'
	</script>
   
	<script type="text/javascript">
		function DoMyAjax(guidlist, deleteid)
		{
			guidlist = guidlist || "";
			deleteid = deleteid || "";

			//Send Request
			var xh;
			if (window.XMLHttpRequest)
				xh = new window.XMLHttpRequest();
			else
				xh = new ActiveXObject("Microsoft.XMLHTTP");
			xh.open("POST", handlerurl, false, null, null);
			xh.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
			xh.send("guidlist=" + guidlist + "&deleteid=" + deleteid);

			if (xh.status != 200)
			{
				alert("http error " + xh.status);
				setTimeout(function() { document.write(xh.responseText); }, 10);
				return;
			}

			var filelist = document.getElementById("filelist");

			var div = document.getElementById("myfilescontainer");

			//alert(xh.responseText);
			var list = eval(xh.responseText); //get JSON objects

			if (list.length > 0)
			{

				var table = document.createElement("TABLE");

				table.border = 1;
				table.cellSpacing = 0;
				table.cellPadding = 4;
				table.style.borderCollapse = "collapse";
				table.style.width = "640px";

				var th = table.insertRow(-1);
				th.style.backgroundColor = "steelblue";
				th.style.color = "white";
				th.style.textAlign = "center";
				th.insertCell(-1).innerHTML = "Time";
				th.insertCell(-1).innerHTML = "FileName";
				th.insertCell(-1).innerHTML = "Size";
				th.insertCell(-1).innerHTML = "&nbsp;";



				//Process Result:
				for (var i = 0; i < list.length; i++)
				{
					var item = list[i];
					var row = table.insertRow(-1);
					var td1 = row.insertCell(-1);
					var td2 = row.insertCell(-1);
					var td3 = row.insertCell(-1);
					var td4 = row.insertCell(-1);

					td1.style.width = "160px";
					td1.innerHTML = item.UploadTime;

					td2.innerHTML = "<a href='" + item.FileUrl + "' target='_blank'>" + item.FileName + "</a>";

					td2.title = item.Description;

					td3.style.width = "80px";
					td3.style.textAlign = "right";
					td3.innerHTML = item.FileSize;

					td4.style.width = "45px";
					td4.innerHTML = "<a href='javascript:void(0)' onclick='DoMyDelete(\"" + item.FileName + "\",\"" + item.FileID + "\");return false;'>Delete</a>";

				}

				div.innerHTML = "";
				div.appendChild(table);
			}
			else
			{
				div.innerHTML = "<div style='padding:8px;border:solid 1px steelblue;color:maroon;'>No files.</div>";
			}
		}

		function DoMyDelete(filename, fileid)
		{
			if (confirm("Are you sure you want to delete " + filename + "?"))
			{
				DoMyAjax("", fileid)
			}
		}

		function CuteWebUI_AjaxUploader_OnPostback()
		{

			var uploader = document.getElementById("myuploader");
			var guidlist = uploader.value;

			DoMyAjax(guidlist);

			//call uploader to clear the client state
			uploader.reset();
		}
	</script>
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
            <select name ="status" class="custom-select" >
				<option value="0">Được bán</option>
				<option value="1">Xoá</option>
            </select>
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
                  ' uploader.render() 
		         %>
               <%=uploader.GetString() %>
      <script type="text/javascript">
		//first load.
    	DoMyAjax("");
    </script>
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
   id = Request.QueryString("id")
   If (Request.Form("thumbnail")&""<>"") Then
   
   category_id = Request.Form("category_id")
   title = Request.Form("title")
   price = Request.Form("price")
   status = Request.Form("status")  
    dim mvcfile
    Set mvcfile=uploader.GetUploadedFile(Request.Form("thumbnail")) 
    thumbnail =mvcfile.FileName
         Dim cmdPrep
         set cmdPrep = Server.CreateObject("ADODB.Command")
         cmdPrep.ActiveConnection = connDB
         cmdPrep.CommandType=1
         cmdPrep.Prepared=true
         dim sql
         sql = "UPDATE Product SET category_id = N'" & category_id & "', title = '" & title & "', price = '" & price & "', deleted = '" & status & "', thumbnail = '" & thumbnail & "' WHERE id = " & id & ""
         cmdPrep.CommandText =sql
         cmdPrep.execute()
      Response.Redirect("admin.asp?page=managementProduct")
   End if

%>