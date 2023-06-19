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

    strSQL = "SELECT COUNT(id) AS count FROM Category"
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
    <table class="table">
        <a href="?page=managementCategory&action=add" class="btn btn-primary">Thêm thể loại</a>
       <thead>
         <tr>
           <th scope="col">ID</th>
           <th scope="col">Tên</th>
         </tr>
       </thead>
       <tbody>
          <%
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT Category.* FROM Category ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
            cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
            cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)     
            set rs = cmdPrep.execute               
             do while not rs.EOF
           %>
         <tr>
           <td><%=rs("id")%></td>
           <td><%= rs("name")%></td>
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
         <li class="page-item"><a class="page-link" href="?page=managementCategory&page1=<%=Clng(page1)-1%>">Trước</a></li>
         <%    
             end if 
             for i= 1 to page1s
         %>
         <li class="page-item <%=checkPage(Clng(i)=Clng(page1),"active")%>"><a class="page-link" href="?page=managementCategory&page1=<%=i%>"><%=i%></a></li>
         <% 
             next
             if (Clng(page1)<page1s) then
         %>
         <li class="page-item"><a class="page-link" href="?page=managementCategory&page1=<%=Clng(page1)+1%>">Sau</a></li>
         <%
             end if    
         end if
         %>                           
       </ul>
     </nav>
</body>
</html>