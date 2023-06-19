<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmation Page</title>
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="col-md-6 offset-md-3">
        <div class="text-center mt-5">
          <h1>Cảm ơn <%= Session("ten") %> đã mua hàng</h1>
          <p><%= Session("success") %></p>
          <p>Tổng đơn hàng: <%= Session("price") %></p>
          <p>Địa chỉ giao hàng: <%= Session("address") %></p>
            <%
            Session.Contents.Remove("mycarts")
            Session.Contents.Remove("success")
            %>
            <p>Bạn có thể kiểm tra trạng thái đơn hàng trang đơn hàng của bạn</p>

          <p><a href="index.asp">Trở về trang chủ</a></p>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
