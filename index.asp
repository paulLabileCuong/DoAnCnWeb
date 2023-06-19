<!--#include file="connect.asp"-->

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
    limit = 10

    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

'    Vị trí để lấy bản ghi ( từ vị trí nào đến vị trí nào)
    offset = (Clng(page) * Clng(limit)) - Clng(limit)
    dim a
    a= Request.QueryString("danhmuc")
    If a <> "" Then
        if a = "all" then
            strSQL = "SELECT COUNT(id) AS count FROM Product"
        else
            strSQL = "SELECT COUNT(id) AS count FROM Product WHERE Product.category_id IN (SELECT id FROM Category WHERE Category.name = '" & a & "')"
        end if
    ElseIf a = ""  Then
        strSQL = "SELECT COUNT(id) AS count FROM Product"
    End If
    'connDB.Open()
    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing
' lay ve tong so trang = tổng số dòng / số bản ghi trong 1 trang
    pages = Ceil(totalRows/limit)
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="../assest/css/base.css">
    <link rel="stylesheet" href="../assest/css/main.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        
</head>
<body>
    <section class="Header sticky-top" style="background-color: #e3f2fd;">
        <div class="container" >
            <div class="row">
                <div class="col-md py-4">
                    <a href="index.asp">
                        <img src="assets/image/nz_toys__1__926b0eda4b2246d6bbdc.webp" class="img-fluid" alt="logo" style="height: 100px;">
                    </a>
                </div>
                <div class="col-md-4 py-5">
                <form method="GET" action="index.asp">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" name="search" placeholder="Tìm kiếm sản phẩm">
                            <button class="btn btn-primary" type="submit" ><i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                </form>
                </div>
                <div class="col-md py-5">
                    <button type="button" class="btn btn-outline-success ">
                        <a class="nav-link active" href="./shoppingcart.asp">
                            <strong>Giỏ hàng</strong> <i class="fa-solid fa-cart-shopping"></i>
                        </a>
                    </button>
                </div>
                <div class="col-md-2"> 
                    <div class="row py-5">
                        <div class="col-md-2 py-2"><i class="fa-solid fa-user"></i></div>
                        <div class="col-md-10">
                            <span>Xin chào !<br><strong><%=Session("fullname")%></strong></span></div>
                    </div>
                </div>
                
                <div class="col">
                <div class="row py-5">
                    <div class="col-md-2 py-2"></div>
                    <div class="col-md-10 py-2">
                        <%
                           if (NOT isnull(Session("fullname"))) AND (TRIM(Session("fullname"))<>"") Then
                        %> 
                        <div class="dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" id="menuDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-bars"></i><strong>Tài khoản</strong>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="menuDropdown">
                            <% 
                                if Session("role_id") = 1 then
                            %>
                                <li><a class="dropdown-item" href="admin/quanly/admin.asp">Quản trị</a></li>
                            <%
                                end if
                            %>
                                <li><a class="dropdown-item" href="logout.asp">Đăng xuất</a></li>
                                <li><a class="dropdown-item" href="./user.asp">Tài khoản</a></li>
                                <li><a class="dropdown-item" href="./orders.asp">Đơn hàng</a></li>
                            </ul>
                        </div>
                        <%    
                        else
                     %>
                            <a class="btn btn-primary" href="login.asp">Đăng nhập</a>
                        <%                        
                            End If 
                        %>   
                    </div>
                </div>
                </div>              
            </div>
        </div>
    </section>
    <div class="container">
    <%
        If (NOT isnull(Session("Success"))) AND (TRIM(Session("Success"))<>"") Then
    %>
            <div class="alert alert-success" role="alert">
                <%=Session("Success")%>
            </div>
    <%
        Session.Contents.Remove("Success")
        End If
    %>
    <%
    ' Kiểm tra lỗi
        If (NOT isnull(Session("Error"))) AND (TRIM(Session("Error"))<>"") Then
    %>
            <div class="alert alert-danger" role="alert">
                <%=Session("Error")%>
            </div>
    <%
            Session.Contents.Remove("Error")
        End If
    %>
</div>
    <section style="background-color: #eee;">    
        <div class="container py-3">
        <div class="grid">
        <h3 style="text-align: center;">Danh sách sản phẩm </h3>
                <div class="grid__row app__content">
                    <div class="grid__column-2">
                        <nav class="category">
                        <h3 class="category__heading">
                            <div class="category__heading-icon">
                                <li class="fa fa-list"></li>
                            </div>
                            DANH MỤC
                        </h3>
                        <% 
                            Set cuong = Server.CreateObject("ADODB.Command")
                            cuong.ActiveConnection = connDB
                            cuong.CommandType = 1
                            cuong.CommandText = "SELECT name FROM Category"
                            Set rs1 = cuong.execute                          
                            do while not rs1.EOF
                        %>
                        <ul class="category-list">
                            <li class="category-item">
                                <a href="index.asp?danhmuc=<%=rs1("name")%>" class="category-item__link">-<%=rs1("name")%></a>
                            </li>
                        </ul>
                        <%
                            rs1.MoveNext
                            loop
                            rs1.Close()
                        %>
                        <ul class="category-list">
                            <li class="category-item">
                                <a href="?danhmuc=all" class="category-item__link">-Tất cả</a>
                            </li>
                        </ul>                            
                    </nav>
                </div>                
                <div class="grid__column-10">
                    <div class="home-product">
                        <div class="grid__row">
                            <!-- Product item -->
                            <%
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            Dim danhmuc
                            danhmuc = Request.QueryString("danhmuc")
                            Dim search
                            search = Request.QueryString("search")
                            If danhmuc <> "" Then
                                if danhmuc = "all" then
                                    cmdPrep.CommandText = "SELECT * FROM Product  Where deleted = '0' ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"

                                else
                                    cmdPrep.CommandText = "SELECT Category.name, Product.* FROM Product INNER JOIN Category ON Product.category_id = Category.id where Category.name like '%" & danhmuc & "%' ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
                         
                                end if                           
                            ElseIf search <> "" Then
                                cmdPrep.CommandText = "SELECT * FROM Product  Where deleted = '0' AND title LIKE '%" & search & "%' ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"

                            Else
                                cmdPrep.CommandText = "SELECT * FROM Product  Where deleted = '0' ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"

                            End If
                                cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
                                cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)
                                Set rs = cmdPrep.execute                          
                                do while not rs.EOF
                            %>
                                <div class="grid__column-2-4">
                                    
                                <a class="home-product-item" href="#">
                                    <div class="home-product-item__img" width="100%" style="background-image: url(admin/quanly/anh/<% = rs("thumbnail")%>);"></div>
                                    <h4 class="home-product-item__name">
                                        <b style="font-size: 16px;">
                                            <%
                                            = rs("title")
                                            %>
                                        </b>
                                    </h4>
                                    <div class="home-product-item__price">
                                        <span class="home-product-item__price-current">
                                        Giá:
                                            <%
                                                =  FormatNumber(rs("price"), 2)
                                            %> VND    
                                        </span>
                                    </div>
                                    <div class="d-flex flex-column" style="background-color: var(--white-color)">   
                                        
                                        <a class="btn btn-outline-success" href="addCart.asp?idproduct=<%= rs("id")%>">
                                            Thêm vào giỏ
                                        </a>
                                        
                                    </div>
                                </a>
                            </div> 
                            <%
                            rs.MoveNext
                            loop
                            %>     
                        </div>
                    <%
                        dim cuong
                        cuong= Request.QueryString("danhmuc")
                        if (cuong <> "") then
                    %>
                    <nav aria-label="Page Navigation">
                        <ul class="pagination pagination-sm justify-content-center my-5">
                            <% 
                                if (pages>1) then
                                'kiem tra trang hien tai co >=2
                                if(Clng(page)>=2) then
                            %>
                                <li class="page-item"><a class="page-link" href="index.asp?danhmuc=<%=cuong%>&page=<%=Clng(page)-1%>">Trước</a></li>
                            <%    
                                end if 
                                for i= 1 to pages
                            %>
                                <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="index.asp?danhmuc=<%=cuong%>&page=<%=i%>"><%=i%></a></li>
                            <% 
                                next
                                if (Clng(page)<pages) then
                            %>
                            <li class="page-item"><a class="page-link" href="index.asp?danhmuc=<%=cuong%>&page=<%=Clng(page)+1%>">Sau</a></li>
                            <%
                                end if    
                                end if
                            %>                           
                        </ul>
                    </nav>
                    <%
                        else
                    %>
                    <nav aria-label="Page Navigation">
                        <ul class="pagination pagination-sm justify-content-center my-5">
                            <% 
                                if (pages>1) then
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
                    <%
                        end if
                    %>
                    </div>
                </div>
            </div>
        </div>   

        </div>
    </section>
<!--#include file="components/footer.asp"-->
</body>
<script 
    language="javascript" src="../assest/js/slider.js">
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    setTimeout(function() {
        // Remove the session message from the DOM after 2 seconds
        var successAlert = document.querySelector(".alert-success");
        var errorAlert = document.querySelector(".alert-danger");
        if (successAlert) {
            successAlert.remove();
        }
        if (errorAlert) {
            errorAlert.remove();
        }
    }, 2000); // 2 seconds
</script>
</html>