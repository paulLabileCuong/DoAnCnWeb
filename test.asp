<!-- #include file="db/connectDB.asp" -->
<!--#include file="./models/Capacity.asp" -->
<!--#include file="./models/Color.asp" -->
<!-- #include file="aspuploader/include_aspuploader.asp" -->


<%
  ' create an instance of ADO connection and recordset objects
  Set capacities = Server.CreateObject("Scripting.Dictionary")
  Set colors = Server.CreateObject("Scripting.Dictionary")

  Dim Acapacity, seq, Acolor
  'load capacity
  Set recordset = connection.Execute("select * from capacities")
  
  seq = 0
  Do While Not recordset.EOF
    seq = seq+1
    set Acapacity = New Capacity
    Acapacity.Id = recordset.Fields("id")
    Acapacity.Rom = recordset.Fields("rom")
    Acapacity.Ram = recordset.Fields("ram")
    capacities.add seq, Acapacity
    recordset.MoveNext
  Loop 
  ' load colors 
  Set recordset = connection.Execute("select * from colors")
  seq = 0
  Do While Not recordset.EOF
    seq = seq+1
    set Acolor = New Color
    Acolor.Id = recordset.Fields("id")
    Acolor.Color = recordset.Fields("colorName")
    colors.add seq, Acolor
    recordset.MoveNext
  Loop 
  
  dim id ,  phoneName ,  description , price , quantity , cap , Pcolor , cat , picture
  
  Dim cmdPrep
  set cmdPrep = Server.CreateObject("ADODB.Command")
  cmdPrep.ActiveConnection = connection
  cmdPrep.CommandType=1
  cmdPrep.Prepared=true
%>

<%

Dim sqlphone ,sqlphonecolor
  sqlphone = "insert into phones(id , phoneName , description , price , quantity ,category , iamge) values(?,?,?,?,?,?,?)"
  sqlphonecolor = "insert into prColors(phoneId , colorId) values(?,?)"
  sqlphonecap = "insert into phoneCapacity(phoneId , capacityId) values(?,?)"
if (Request.QueryString("id")<>"") then
    id = Request.QueryString("id")
    cmdPrep.CommandText = "select * from phones where id=?"
    cmdPrep.Parameters(0)=cint(id)
    dim result 
    set result = cmdPrep.Execute()

    phoneName = result("phoneName")
    description = result("description")
    price = result("price")
    quantity = result("quantity")
    cat = result("category")
  end if
%>





<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link
      rel="stylesheet"
      href="./css/dist/bootstrap-5.0.2-dist/css/bootstrap.min.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
      integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer" />
      <script type="text/javascript">

</script>
  </head>
  <body>
    <!-- SideBar -->


    <div class="container-fluid row position-relative">
      <!--#include file="./components/sidebar.asp"  -->
      <div class="col-10">
        <form method='post' >
          <h5 class="text-center">
          <%
          IF Request.QueryString("id")<>"" THEN
          Response.write("CAP NHAT ")
          Else
          Response.write("THEM MOI ")
          END If
          %>
          
          </h5>


          <div class="mb-3">
            <label for="" class="form-label">MSP</label>
            <input type="text" class="form-control" name="id" value="<%=id%>" />
          </div>


          <div class="mb-3">
            <label for="" class="form-label">Ten San Pham</label>
            <input type="text" class="form-control" name="phoneName"  value="<%=phoneName%>"/>
          </div>
          
          
          <div class="mb-3">
            <label for="" class="form-label">Mo ta</label>
            <textarea
              type="text"
              value="<%=description%>"
              class="form-control"
              name="description"></textarea>
          </div>
          
          
          <div class="mb-3">
            <label for="" class="form-label">Gia</label>
            <input type="number" class="form-control" name="price" value="<%=price%>" />
          </div>

          
          <div class="mb-3">
            <label for="" class="form-label">So luong</label>
            <input
          value="<%=quantity%>"
              type="number"
              class="form-control"
              name="quantity"
              placeholder="So luong" />
          </div>

          
          <div class="mb-3">
              <label for="" class="form-label">Dung luong:</label>
              <% For Each item in capacities %> 
                <input type="checkbox" name="capacity"  placeholder="Loai" value = "<%= capacities(item).Id %>"  />
                <span><%= capacities(item).Rom %> / <%= capacities(item).Ram %>  GB </span>
              <% Next %>
          </div>

          
          <div class="mb-3">
              <label for="" class="form-label">Mau:</label>
              <% For Each item in colors %> 
                <input type="checkbox" name="color"  placeholder="Loai" value = "
                <%= colors(item).Id %> "  />
                <span><%= colors(item).Color %> </span>
              <% Next %>
          </div>

          <div class="d-flex gap-2 align-items-center">
            <strong>Capacities:</strong>
              <% For Each item in capacities %> 
                <input type="checkbox" name="capacity" required  placeholder="Loai" value = "<%= capacities(item).Id %>"  />
                <span><%= capacities(item).Rom %> / <%= capacities(item).Ram %>  GB </span>
              <% Next %>
          </div>
          
          <div class="mb-3">
            <label for="" class="form-label">Loai</label>
            <input type="radio"  name="category" value='iphone' /><span> Iphone </span>
            <input type="radio"  name="category" value='samsung' /><span> Samsung </span>
            <input type="radio"  name="category" value='oppo' /><span> Oppo </span>
            <input type="radio"  name="category" value='xiaomi' /><span> Xiaomi </span>
          </div>

           <%
				Dim uploader
				Set uploader=new AspUploader
				uploader.MaxSizeKB=10240
				uploader.Name="picture"
				uploader.InsertText="Upload File (Max 10M)"
				uploader.MultipleFilesUpload=true
        uploader.AllowedFileExtensions="*.jpg,*.png,*.gif,*.zip"
		    uploader.SaveDirectory="savefiles"
        
				%>
				<%=uploader.GetString() %>

          
          
          <div class="list-btn d-flex justify-contents-center">
    				<button id="" type="submit" >Luu</button>
            <div class="btn btn-warning">Huy bo</div>
          </div>
        
        </form>
      </div>
    </div>
  </body>
</html>



<%
  'insert phone
  if (Request.QueryString("id")="") then
  If Request.Form("picture")&""<>"" Then
  id = Request.Form("id")
  phoneName = Request.Form("phoneName")
  description = Request.Form("description")
  price = Request.Form("price")
  quantity = Request.Form("quantity")
  cap = split (Request.Form("capacity"),",")
  Pcolor =split(Request.Form("color"), ",")
  cat = Request.Form("category")
 
  sqlCheck = "select * from phones where= ?"


  dim mvcfile
  Set mvcfile=uploader.GetUploadedFile(Request.Form("picture")) 
  picture =mvcfile.FileName
  
  
  
  if(not isnull(id) and not isnull(phoneName) and not isnull(description) and not isnull(price) and Not isnull(quantity) and not isnull(cap) and not isnull(Pcolor) and not isnull(cat) and TRIM(id)<>"" and TRIM(phoneName)<>"" and TRIM(description)<>"")THEN
  
  
  
  cmdPrep.CommandText = sqlphone
  cmdPrep.Parameters(0)=cint(id)
  cmdPrep.Parameters(1)=phoneName 
  cmdPrep.Parameters(2)=description
  cmdPrep.Parameters(3)= price
  cmdPrep.Parameters(4)=quantity
  cmdPrep.Parameters(5)=cat
  cmdPrep.Parameters(6)=picture
  cmdPrep.execute()


  end if
  end if
  end if
  
%>
