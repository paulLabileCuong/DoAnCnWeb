-- Tạo cơ sở dữ liệu
CREATE DATABASE DoAnNopFinal;
go
-- Sử dụng cơ sở dữ liệu
USE DoAnNopFinal;

-- Tạo bảng Role
CREATE TABLE Role (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(20)
);

insert into Role(name) values('admin')
insert into Role(name) values('user')
-- Tạo bảng User
CREATE TABLE [User] (
  id INT PRIMARY KEY IDENTITY(1,1),
  fullname NVARCHAR(50),
  email NVARCHAR(150),
  phone_number NVARCHAR(20),
  address NVARCHAR(200),
  password NVARCHAR(MAX),
  role_id INT,
  deleted int,
  FOREIGN KEY (role_id) REFERENCES Role(id)
);
-- Insert a user with admin email and role_id = 1
INSERT INTO [User] (fullname, email, phone_number, address, password, role_id, deleted)
VALUES ('Admin', 'admin@gmail.com', '123456789', 'Admin Address', '1', 1, 0);

-- Tạo bảng Category
CREATE TABLE Category (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(100)
);
insert into Category(name) values('Naruto')
insert into Category(name) values('One Piece')

-- Tạo bảng Product
CREATE TABLE Product (
  id INT PRIMARY KEY IDENTITY,
  category_id INT,
  title NVARCHAR(350),
  price INT,
  thumbnail NVARCHAR(500),
  FOREIGN KEY (category_id) REFERENCES Category(id)
);
alter table Product
add deleted int

-- Tạo bảng Order
CREATE TABLE [Order] (
  id INT PRIMARY KEY IDENTITY,
  user_id INT,
  fullname NVARCHAR(50),
  email NVARCHAR(150),
  phone_number NVARCHAR(20),
  address NVARCHAR(200),
  order_date DATETIME DEFAULT GETDATE(),
  status INT,
  total_price INT,
  FOREIGN KEY (user_id) REFERENCES [User](id)
);

-- Tạo bảng chi tiết đơn hàng
CREATE TABLE OrderDetail (
  id INT PRIMARY KEY IDENTITY(1,1),
  order_id INT,
  product_id INT,
  price INT,
  num INT,
  FOREIGN KEY (order_id) REFERENCES [Order](id),
  FOREIGN KEY (product_id) REFERENCES Product(id)
);
