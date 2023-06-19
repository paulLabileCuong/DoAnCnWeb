<!--#include file="../../connect.asp"-->
<!--#include file="../../model/Product.asp"-->

<style>
  table.table {
    width: 100%;
    border-collapse: collapse;
  }

  table.table th,
  table.table td {
    padding: 10px;
    text-align: center;
    border: 1px solid #ccc;
  }

  table.table th {
    background-color: #f2f2f2;
  }

  table.table img {
    max-width: 100px;
    max-height: 100px;
    object-fit: contain;
  }
    .in-stock {
    color: green;
  }

  .out-of-stock {
    color: red;
    font-weight: bold;
  }
</style>

<%
    'PHÂN TRANG
' ham lam tron so nguyen (làm tròn lên)
    function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number Then
            Ceil = Ceil + 1
        end if
    end function

    function checkPage(cond, ret) 
        if cond=true then
            Response.write ret
        else
            Response.write ""
        end if
    end function
' trang hien tai
    page1 = Request.QueryString("page1")
'    Số bản ghi trong 1 trang
    limit = 10

    if (trim(page1) = "") or (isnull(page1)) then
        page1 = 1
    end if

'    Vị trí để lấy bản ghi ( từ vị trí nào đến vị trí nào)
    offset = (Clng(page1) * Clng(limit)) - Clng(limit)

    strSQL = "SELECT COUNT(id) AS count FROM Product"
    'connDB.Open()
    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing
' lay ve tong so trang = tổng số dòng / số bản ghi trong 1 trang
    page1s = Ceil(totalRows/limit)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <title>Document</title>
</head>
<body>
    <h1>Quản lý sản phẩm</h1>
    <form method="GET" action="table_of_product.asp">
        <div class="input-group mb-3">
            <input type="text" class="form-control" name="search" placeholder="Search for products">
            <button class="btn btn-primary" type="submit">Search</button>
        </div>
    </form>
    <table class="table">
        <a href="?page=managementProduct&action=add" class="btn btn-primary">ADD PRODUCT</a>
       <thead>
         <tr>
           <th scope="col">ID</th>
           <th scope="col">Ảnh sản phẩm</th>
           <th scope="col">Loại sản phẩm</th>
           <th scope="col">Tên sản phẩm</th>
           <th scope="col">Giá</th>
           <th scope="col">Trạng thái</th>
           <th scope="col">Thao tác</th>
         </tr>
       </thead>
       <tbody>
          <%
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            Dim search
            search = Request.QueryString("search")
            If search = "" Then
              cmdPrep.CommandText = "SELECT Category.name, Product.* FROM Product INNER JOIN Category ON Product.category_id = Category.id ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
              cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
              cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)
              Set rs = cmdPrep.execute 
            Else
              cmdPrep.CommandText = "SELECT Category.name, Product.* FROM Product INNER JOIN Category ON Product.category_id = Category.id WHERE Product.title LIKE '%" & search & "%' ORDER BY Product.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
              cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
              cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)
              Set rs = cmdPrep.execute   
             End If                       
             do while not rs.EOF
           %>
         <tr>
           <td><%=rs("id")%></td>
           <td><img src="anh/<%=rs("thumbnail")%>" alt=""></td>
           <td><%= rs("name")%></td>
           <td><%= rs("title")%></td>
           <td><%= FormatNumber(rs("price"), 2) %> VND</td>
           <td>
              <% If rs("deleted") = 0 Then %>
                <a href="changeStatusProduct.asp?id=<%=rs("id")%>" class="btn btn-success"title="Delete">Được bán</a>
              <% Else %>
                <a href="changeStatusProduct.asp?id=<%=rs("id")%>" class="btn btn-danger"title="Delete">Đã xoá</a>
              <% End If %>
          </td>
           <td>
             <a href="?page=managementProduct&action=edit&id=<%=rs("id")%>" class="btn btn-primary">Sửa</a>
           </td>
         </tr>
         <%
             rs.MoveNext
             loop
         %>
       </tbody>
     </table>
     <nav aria-label="Page Navigation">
       <ul class="pagination pagination-sm justify-content-center my-5">
         <% if (page1s>1) then
             ' Check if the current page is greater than or equal to 2
             if(Clng(page1)>=2) then
         %>
         <li class="page-item"><a class="page-link" href="?page=managementProduct&page1=<%=Clng(page1)-1%>">Trước</a></li>
         <%    
             end if 
             for i= 1 to page1s
         %>
         <li class="page-item <%=checkPage(Clng(i)=Clng(page1),"active")%>"><a class="page-link" href="?page=managementProduct&page1=<%=i%>"><%=i%></a></li>
         <% 
             next
             if (Clng(page1)<page1s) then
         %>
         <li class="page-item"><a class="page-link" href="?page=managementProduct&page1=<%=Clng(page1)+1%>">Sau</a></li>
         <%
             end if    
         end if
         %>                           
       </ul>
     </nav>
</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" 
integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" 
crossorigin="anonymous">
</script> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>  
<script>
    window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 2000);
</script>