<!--#include file="connect.asp"-->
<% 
    Response.Charset = "UTF-8"
    
    If Request.ServerVariables("REQUEST_METHOD") = "POST" THEN
        fullname = Request.Form("fullname")
        email = Request.Form("email")
        address = Request.Form("address")
        phone_number = Request.Form("phone_number")
        password = Request.Form("password")


        
        If (Not IsNull(fullname) Or Trim(fullname) <> "" Or Not IsNull(address) Or Trim(address) <> "" Or Not IsNull(email) Or Trim(email) <> "" Or Not IsNull(phone_number) Or Trim(phone_number) <> "" Or Not IsNull(password) Or Trim(password) <> "") Then
            Dim sql, result
            sql = "INSERT INTO [User] (fullname, email, phone_number, address, password, role_id, deleted) VALUES (N'" & fullname & "','" & email & "','" & phone_number & "','" & address & "','" & password & "','2','0')"
            
            Dim cmdPrep
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = sql
            
            Set result = cmdPrep.Execute
            Session("Success") = "New customer added!"
            Response.Redirect("login.asp") 
        End If
    End If
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assest/style/login.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <title>Đăng ký</title>
</head>

<body>
    <div class="wrapper">
        <div class="container main">
            <div class="row">
                <div class="col-md-6 side-image">
                    <!-------Image-------->
                    <img src="images/white.png" alt="">
                    <div class="text">
                        <p>Hãy trở thành thành viên của NZ Toys <i>- Cường còi</i></p>
                    </div>
                </div>

                <div class="col-md-6 right">
                    <form method="post" action="signup.asp">
                      
                
                        <div class="input-box">
                            <header>Đăng ký</header>

                            <div class="input-field">
                                <input type="text" class="input" id="fullname" name="fullname" autocomplete="off">
                                <label for="fullname">Họ và tên</label>
                            </div>
                            <div class="input-field">
                                <input type="text" class="input" id="email" name="email" autocomplete="off">
                                <label for="email">Email</label>
                            </div>
                            <div class="input-field">
                                <input type="text" class="input" id="address" name="address" autocomplete="off">
                                <label for="address">Địa chỉ</label>
                            </div>
                            <div class="input-field">
                                <input type="text" class="input" id="phone_number" name="phone_number" autocomplete="off">
                                <label for="phone_number">Số điện thoại</label>
                            </div>
                            <div class="input-field">
                                <input type="password" class="input" id="password" name="password" autocomplete="off">
                                <label for="password">Mật khẩu</label>
                            </div>
                            
                            <div class="input-field">
                                <button type="submit" class="submit">Đăng ký</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>

</html>
