-- Create Role table
CREATE TABLE Role (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20)
);

-- Create User table
CREATE TABLE [User] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(50),
    email VARCHAR(150),
    phone_number VARCHAR(20),
    address VARCHAR(200),
    password VARCHAR(50),
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES Role(id)
);

-- Create Category table
CREATE TABLE Category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100)
);

-- Create Product table
CREATE TABLE Product (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    title NVARCHAR(350),
    price INT,
    discount INT,
    thumbnail VARCHAR(500),
    FOREIGN KEY (category_id) REFERENCES Category(id)
);

-- Create Order table
CREATE TABLE [Order] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    fullname NVARCHAR(50),
    email VARCHAR(150),
    phone_number VARCHAR(20),
    address VARCHAR(200),
    order_date DATETIME,
    status INT,
    FOREIGN KEY (user_id) REFERENCES [User](id)
);

-- Create OrderDetail table
CREATE TABLE OrderDetail (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    price INT,
    num INT,
    FOREIGN KEY (order_id) REFERENCES [Order](id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);
