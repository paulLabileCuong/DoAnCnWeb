<!--#include file="connect.asp"-->
<%
' Add your billing logic here

' Example code to calculate the total amount
Dim totalAmount
totalAmount = subtotal ' Use your own calculation logic here

' End of billing logic
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing</title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">

</head>
<body>
<section class="h-100 h-custom" style="background-color: #eee;">
  <div class="container py-2 h-100">
    <div class="row d-flex justify-content-center align-items-center h-100">
      <div class="col-12">
        <div class="card card-registration card-registration-2" style="border-radius: 15px;">
          <div class="card-body p-0">
            <div class="row g-0">
              <div class="col-lg-8">
                <div class="p-5">
                  <div class="d-flex justify-content-between align-items-center mb-5">
                    <h1 class="fw-bold mb-0 text-black">Billing</h1>
                  </div>
                  <form action="process_payment.asp" method="post">
                    <div class="row mb-4">
                      <div class="col-md-6">
                        <div class="form-outline">
                          <input type="text" id="form3Example1" class="form-control form-control-lg" />
                          <label class="form-label" for="form3Example1">First Name</label>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-outline">
                          <input type="text" id="form3Example2" class="form-control form-control-lg" />
                          <label class="form-label" for="form3Example2">Last Name</label>
                        </div>
                      </div>
                    </div>

                    <div class="form-outline mb-4">
                      <input type="text" id="form3Example3" class="form-control form-control-lg" />
                      <label class="form-label" for="form3Example3">Email</label>
                    </div>

                    <div class="form-outline mb-4">
                      <input type="text" id="form3Example4" class="form-control form-control-lg" />
                      <label class="form-label" for="form3Example4">Address</label>
                    </div>

                    <div class="row mb-4">
                      <div class="col-md-6">
                        <div class="form-outline">
                          <input type="text" id="form3Example5" class="form-control form-control-lg" />
                          <label class="form-label" for="form3Example5">City</label>
                        </div>
                      </div>
                    <div class="form-outline mb-4">
                      <input type="text" id="form3Example7" class="form-control form-control-lg" />
                      <label class="form-label" for="form3Example7">Phone Number</label>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-between mb-5">
                      <h5 class="text-uppercase">Total amount</h5>
                      <h5>$ <%= totalAmount %></h5>
                    </div>

                    <div class="row">
                      <button type="submit" class="btn btn-success btn-lg"
                        data-mdb-ripple-color="dark">Pay Now</button>
                    </div>
                  </form>
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
