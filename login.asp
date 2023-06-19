 <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 

<!--#include file="connect.asp"-->
<%
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim email, password
    email = Trim(Request.Form("email"))
    password = Trim(Request.Form("password"))
    
    If (NOT isnull(email) AND NOT isnull(password) AND TRIM(email)<>"" AND TRIM(password)<>"" ) Then
        Dim sql
        sql = "SELECT * FROM [User] WHERE email = '" & email & "' AND password = '" & password & "'"
        Dim cmdPrep
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType=1
        cmdPrep.Prepared=true
        cmdPrep.CommandText = sql
        Dim result
        set result = cmdPrep.execute
        
        If Not result.EOF Then
            ' Login successful
            If result("deleted").Value = 0 Then
                Session("email") = result("email").Value
                Session("role_id") = result("role_id").Value
                Session("id") = result("id").Value
                Session("fullname") = result("fullname").Value
                Session("Success") = "Login Successfully"
                
                If Trim(Session("role_id")) = "1" Then
                    Response.Redirect("admin/quanly/admin.asp")
                ElseIf Trim(Session("role_id")) = "2" Then
                    Response.Redirect("index.asp")
                End If
                
                result.Close
                connDB.Close
            Else
                ' Handle case when user is marked as deleted
                ' Display an error message or redirect to an appropriate page
            End If
        Else
            ' Handle case when user is not found
            ' Display an error message or redirect to an appropriate page
        End If
        
        result.Close
        Set result = Nothing
        Set cmdPrep = Nothing
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
    <title>Đăng nhập</title>
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
                    <form method="post" action="login.asp">
                        <div class="input-box">
                            <header>Đăng nhập</header>
                            <div class="input-field">
                                <input type="text" class="input" id="email" name="email" required autocomplete="off">
                                <label for="email">Email</label>
                            </div>
                            <div class="input-field">
                                <input type="password" class="input" id="password" name="password" required>
                                <label for="password">Mật khẩu</label>
                            </div>
                            
                            <div class="input-field">

                                <button type="submit" class="submit">Đăng nhập</button>

                            </div>
                            <div class="signin">
                                <span>Bạn mới đến với NZ Toys ? <a href="signup.asp">Đăng ký</a></span>
                            </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</body>

</html>