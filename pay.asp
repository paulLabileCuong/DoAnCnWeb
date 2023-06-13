  <!--#include file="connect.asp"-->
  <!--#include file="model/Product.asp"-->
  <%
  Dim idList, mycarts, totalProduct, subtotal, statusViews, statusButtons, rs
  If (NOT IsEmpty(Session("mycarts"))) Then
    statusViews = "d-none"
    statusButtons = "d-block"
  ' true
    Set mycarts = Session("mycarts")
    idList = ""
    totalProduct=mycarts.Count    
    For Each List In mycarts.Keys
      If (idList="") Then
  ' true
        idList = List
      Else
        idList = idList & "," & List
      End if                               
    Next
    Dim sqlString
    sqlString = "Select * from Product where id IN (" & idList &")"
    set rs = connDB.execute(sqlString)
    calSubtotal(rs)
    Set ProductList = Server.CreateObject("Scripting.Dictionary")

    Dim Aproduct ,seq
    Do While Not rs.EOF
    Dim id  ,num
    id = CStr(rs("id"))
    num = mycarts.Item(id)
    seq = seq+1
    set Aproduct = New Product
    Aproduct.ProductID = rs.Fields("id")
    Aproduct.ProductTitle = rs.Fields("title")
    Aproduct.ProductPrice = rs.Fields("price")
    Aproduct.ProductNum = num
    Aproduct.ProductThumbnail = rs.Fields("thumbnail")
    ProductList.add seq, Aproduct
    rs.MoveNext
  Loop 
    Else
      'Session empty
      statusViews = "d-block"
      statusButtons = "d-none"
      totalProduct=0
  End If
    Sub calSubtotal(rs)
  ' Do Something...
      subtotal = 0
      do while not rs.EOF
        subtotal = subtotal + Clng(mycarts.Item(CStr(rs("id")))) * CDbl(CStr(rs("price")))
        rs.MoveNext
      loop
      rs.MoveFirst
    End Sub
    Sub defineItems(v)
      If (v>1) Then
        Response.Write(" Items")
      Else
        Response.Write(" Item")
      End If
    End Sub
  
  %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    
    <link rel="stylesheet" href="../assest/css/main.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
        integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">

</head>
<body>
  <section class="h-100 h-custom" style="background-color: #eee;">
    <div class="container py-2 h-100">
      <div class="category-top rows">
        <a href="./home.asp" class="text-decoration-none text-secondary">
          <p style="margin: 0px 10px;">Trang chủ</p>
        </a>
        <span style="font-size: 10px; margin-top: 5px;">&#8212;</span>
        <a href="./shoppingcart.asp" class="text-decoration-none text-secondary">
          <p style="margin: 0px 10px;">Giỏ hàng</p>
        </a>
        <span style="font-size: 10px; margin-top: 5px;">&#8212;</span>
        <a href="./pay.asp" class="text-decoration-none text-secondary">
          <p style="margin: 0px 10px;">Thanh toán</p>
        </a>
      </div>
      <%
        For Each item in ProductList
      %>
      <div class="row mb-4 d-flex justify-content-between align-items-center">
        <div class="col-md-2 col-lg-2 col-xl-2">
          <img src="admin/quanly/anh/<%=ProductList(item).ProductThumbnail %>" class="img-fluid rounded-3" alt="Cotton T-shirt">
        </div>
        <div class="col-md-3 col-lg-3 col-xl-3">
          <h6 class="text-muted"><%= ProductList(item).ProductTitle %></h6>
        </div>
        <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
          <p>
          <%=ProductList(item).ProductNum %>
          </p>
        </div>
        <div class="col-md-3 col-lg-2 col-xl-2 offset-lg-1">
          <h6 class="mb-0"><%= ProductList(item).ProductPrice%></h6>
        </div>
        <div class="col-md-1 col-lg-1 col-xl-1 text-end">
          <a href="removecart.asp?id=<%= ProductList(item).ProductID%>" class="text-muted"><i class="fas fa-times"></i></a>
        </div>
      </div>
      <%
        Next
      %>
      <div class="row d-flex justify-content-center align-items-center h-100">
        <div class="col-12">
          <div class="card card-registration card-registration-2" style="border-radius: 15px;">
            <%
              Dim cmdPrep
              Set cmdPrep = Server.CreateObject("ADODB.Command")
              'connDB.Open()
              cmdPrep.ActiveConnection = connDB
              cmdPrep.CommandType = 1
              cmdPrep.Prepared = True
              Session("payment_completed") = False
              If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
                Dim cuong
                cuong = Session("fullname")
                cmdPrep.CommandText = "SELECT id, fullname, email, phone_number, address FROM [User] WHERE fullname = '" & cuong & "'"
                Set rs = cmdPrep.execute
                If not rs.EOF then
                  Session("makh") = rs("id")
                End If
              Else
                Name = Request.Form("name")
                Address = Request.Form("address")
                Phone = Request.Form("phone_number")
                Email = Request.Form("email")
                makh = Session("makh")
                If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
                  cmdPrep.CommandText = "INSERT INTO [Order] (user_id, fullname, email, phone_number, address, status,total_price) VALUES('" & makh & "','" & Name & "', '" & Email & "', '" & Phone & "', '" & Address & "','1','"&subtotal&"')"
                  cmdPrep.execute
                    Set rs1 = connDB.Execute("SELECT MAX(id) AS max_id FROM [Order]")
                    Dim order_id
                    order_id = rs1("max_id")
                    Response.Write(order_id)
                    For Each item in ProductList
                        product_id = ProductList(item).ProductID
                        price = ProductList(item).ProductPrice
                        num =  ProductList(item).ProductNum
                        cmdPrep.CommandText = "Insert into [OrderDetail] (order_id,product_id,price,num) values (' "& order_id & "',' "& product_id & "','" & price &"','"& num&"')"
                        cmdPrep.execute
                    Next
                    Session("Success") = "New employee added!"
                  Session("Success") = "Thanh toán thành công, Hóa đơn đã được tạo"
                  Session("payment_completed") = True
                  ' Session("mycarts").Abandon
                  ' Response.Redirect("index.asp")
                End If
              End If
            %>
            <div class="card-body p-0">
              <div class="row g-0">
                <div class="col-lg-8">
                  <div class="p-5">
                    <div class="d-flex justify-content-between align-items-center mb-5">
                      <h1 class="fw-bold mb-0 text-black">Thanh toán</h1>
                    </div>
                    <div></div>
                    <hr class="my-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                      <h2 class="fw-bold mb-0 text-primary">Thông tin giao hàng</h2>
                    </div>
                    <form action="pay.asp" id="pay_form" method="POST">
                      <div class="form-group mb-4">
                        <label class="mb-1" for="name"><b>Tên người nhận</b></label>
                        <input type="text" class="form-control" id="name" name="name" value="<% =rs("fullname")%>">
                      </div>
                      <div class="form-group mb-4">
                        <div class="row">
                          <div class="col">
                            <label for="email" class="mb-1"><b>Địa chỉ Email</b></label>
                            <input type="text" class="form-control" id="email" name="email" value="<% =rs("email")%>">
                          </div>
                          <div class="col">
                            <label for="phone" class="mb-1"><b>Số điện thoại nhận hàng</b></label>
                            <input type="text" class="form-control" id="phone" name="phone" value="<% =rs("phone_number")%>">
                          </div>
                        </div>
                      </div>
                      <div class="form-group mb-4">
                        <label for="address" class="mb-1"><b>Địa chỉ</b></label>
                        <input type="text" class="form-control" id="address" name="address" value="<% =rs("address")%>">
                      </div>
                      <div class="row">
                        <button type="submit" class="btn btn-success btn-lg" data-mdb-ripple-color="dark">Thanh toán</button>
                      </div>
                    </form>
                  </div>
                </div>
                <div class="col-lg-4">
                  <div class="p-5">
                    <h3 class="fw-bold mb-5 mt-2 pt-1">Chi tiết</h3>
                    <hr class="my-4">
                    <div class="d-flex justify-content-between mb-4">
                      <h5 class="text-uppercase"><%= totalProduct %> <%call defineItems(totalProduct) %></h5>
                      <div>
                        <h5 class="text-end">Tổng</h5>
                        <h5><%= subtotal%> VNĐ</h5>
                      </div>
                    </div>
                    <hr class="my-4">
                    <div class="d-flex justify-content-between mb-3">
                      <h5>Tổng tiền</h5>
                      <h5><%= subtotal %> VNĐ</h5>
                    </div>
                    <div class="form-check mb-3">
                      <small>
                        <input type="checkbox" class="form-check-input" id="exampleCheck1">
                        <label class="form-check-label" for="exampleCheck1">Tôi đã đọc và đồng ý với các điều khoản điều kiện</label>
                      </small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>



