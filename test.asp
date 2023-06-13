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
    page = Request.QueryString("page")
'    Số bản ghi trong 1 trang
    limit = 5

    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

'    Vị trí để lấy bản ghi ( từ vị trí nào đến vị trí nào)
    offset = (Clng(page) * Clng(limit)) - Clng(limit)

    strSQL = "SELECT COUNT(id) AS count FROM Product"
    'connDB.Open()
    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing
' lay ve tong so trang = tổng số dòng / số bản ghi trong 1 trang
    pages = Ceil(totalRows/limit)
%>
<%  
  Dim cmdPrep,rs
  Set cmdPrep = Server.CreateObject("ADODB.Command")
  'connDB.Open()
  cmdPrep.ActiveConnection = connDB
  cmdPrep.CommandType = 1
  Dim sqlString
    sqlString = "SELECT Category.name, Product.* FROM Product INNER JOIN Category ON Product.category_id = Category.id ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
    set rs = connDB.execute(sqlString)
    Set ProductList = Server.CreateObject("Scripting.Dictionary")

    Dim Aproduct ,seq
    Do While Not rs.EOF
    set Aproduct = New Product
    seq = seq + 1
    Aproduct.ProductID = rs.Fields("id")
    Aproduct.ProductTitle = rs.Fields("title")
    Aproduct.ProductPrice = rs.Fields("price")
    Aproduct.CategoryID = rs.Fields("name").Value
    Aproduct.ProductThumbnail = rs.Fields("thumbnail")
    ProductList.add seq, Aproduct
    rs.MoveNext
    Loop
%>
<table class="table">
   <a href="?page=management&action=add" class="btn btn-primary">ADD PRODUCT</a>
  <thead>
    <tr>
      <th scope="col">ID</th>
      <th scope="col">Ảnh sản phẩm</th>
      <th scope="col">Loại sản phẩm</th>
      <th scope="col">Tên sản phẩm</th>
      <th scope="col">Giá</th>
      <th scope="col">Sửa</th>
      <th scope="col">Xoá</th>
    </tr>
  </thead>
  <tbody>
     <%
        For Each item in ProductList
      %>
    <tr>
      <td><%= ProductList(item).ProductID%></td>
      <td><img src="anh/<%=ProductList(item).ProductThumbnail%>" alt=""></td>
      <td><%= ProductList(item).CategoryID%></td>
      <td><%= ProductList(item).ProductTitle%></td>
      <td><%= FormatNumber(ProductList(item).ProductPrice, 2) %> VND</td>
      <td><button class="btn btn-primary">Sửa</button></td>
      <td><button class="btn btn-danger">Xoá</button></td>
    </tr>
    <%
        Next
    %>
  </tbody>
</table>
<nav aria-label="Page Navigation">
                        <ul class="pagination pagination-sm justify-content-center my-5">
                            <% if (pages>1) then
                            'kiem tra trang hien tai co >=2
                            if(Clng(page)>=2) then
                            %>
                            <li class="page-item"><a class="page-link" href="index.asp?page=<%=Clng(page)-1%>">Trước</a></li>
                            <%    
                            end if 
                            for i= 1 to pages
                            %>
                            <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="index.asp?page=<%=i%>"><%=i%></a></li>
                            <% 
                            next
                            if (Clng(page)<pages) then
                            
                            %>
                            <li class="page-item"><a class="page-link" href="index.asp?page=<%=Clng(page)+1%>">Sau</a></li>
                            <%
                            end if    
                            end if
 
                        %>                           
                        </ul>
                    </nav>
