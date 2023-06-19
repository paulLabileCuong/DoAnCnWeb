<!--#include file="../../connect.asp"-->

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
        if Ceil <> Number Then
            Ceil = Ceil + 1
        end if
    end function

    function checkPage(cond, ret) 
        if cond = true then
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

    strSQL = "SELECT COUNT(id) AS count FROM [Order]"
    'connDB.Open()
    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing

    ' lay ve tong so trang = tổng số dòng / số bản ghi trong 1 trang
    page1s = Ceil(totalRows / limit)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <title>Document</title>
</head>
<body>
    <h1>Quản lý hoá đơn</h1>
    <form method="GET" action="table_of_product.asp">
        <div class="input-group mb-3">
            <input type="text" class="form-control" name="search" placeholder="Search for products">
            <button class="btn btn-primary" type="submit">Search</button>
        </div>
    </form>
    <table class="table">
       <thead>
         <tr>
           <th scope="col">ID</th>
           <th scope="col">ID Khách</th>
           <th scope="col">Tên khách hàng</th>
           <th scope="col">Địa chỉ giao hàng</th>
           <th scope="col">Trang thái</th>
           <th scope="col">Ngày tạo</th>
           <th scope="col">Tổng tiền</th>
           <th scope="col">Chi tiết đơn hàng</th>
         </tr>
       </thead>
       <tbody>
          <%
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT * FROM [Order] ORDER BY [Order].id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
            cmdPrep.Parameters.Append cmdPrep.CreateParameter("offset", 3, 1, , offset)
            cmdPrep.Parameters.Append cmdPrep.CreateParameter("limit", 3, 1, , limit)
            Set rs = cmdPrep.Execute

            do while not rs.EOF
         %>
         <tr>
           <td><%=rs("id")%></td>
           <td><%=rs("user_id")%></td>
           <td><%= rs("fullname")%></td>
           <td><%= rs("address")%></td>
           <td><%=rs("status")%></td>
           <td><%=rs("order_date")%></td>
           <td><%= FormatNumber(rs("total_price"), 2) %> VND</td>
           <td>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#myModal<%=rs("id")%>">
                    Chi tiết sản phẩm
                </button>

                <!-- Modal -->
                <div class="modal fade" id="myModal<%=rs("id")%>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Chi tiết đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <% cmdPrep.CommandText = "SELECT OrderDetail.*, Product.title, Product.thumbnail FROM OrderDetail JOIN Product ON OrderDetail.product_id = Product.id WHERE OrderDetail.order_id = " & rs("id")&""
                                Set rs1 = cmdPrep.Execute %>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>ID sản phẩm</th>
                                            <th>Ảnh sản phẩm</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Giá 1 sản phẩm</th>
                                            <th>Số lượng</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% do while not rs1.EOF %>
                                            <tr>
                                                <td><%=rs1("product_id")%></td>
                                                <td><img src="anh/<%=rs1("thumbnail")%>" alt="" width="100px"></td>
                                                <td><%=rs1("title")%></td>
                                                <td><%=rs1("price")%></td>
                                                <td><%=rs1("num")%></td>
                                            </tr>
                                            <% rs1.MoveNext
                                        loop
                                        rs1.Close %>
                                    </tbody>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
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
         <li class="page-item"><a class="page-link" href="?page=managementOrder&page1=<%=Clng(page1)-1%>">Trước</a></li>
         <%    
             end if 
             for i= 1 to page1s
         %>
         <li class="page-item <%=checkPage(Clng(i)=Clng(page1),"active")%>"><a class="page-link" href="?page=managementOrder&page1=<%=i%>"><%=i%></a></li>
         <% 
             next
             if (Clng(page1)<page1s) then
         %>
         <li class="page-item"><a class="page-link" href="?page=managementOrder&page1=<%=Clng(page1)+1%>">Sau</a></li>
         <%
             end if    
         end if
         %>                           
       </ul>
     </nav>
</body>
</html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ"
    crossorigin="anonymous"></script>
<script>
    window.setTimeout(function() {
        $(".alert").fadeTo(500, 0).slideUp(500, function() {
            $(this).remove();
        });
    }, 2000);
</script>
