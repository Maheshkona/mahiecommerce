-- SQL schema for the BookStore project

-- Users table (renamed to Customer since the application uses Customer model)
CREATE TABLE Customer (
    CustomerId    INT IDENTITY(1,1) PRIMARY KEY,
    Username      VARCHAR(100)   NOT NULL UNIQUE,
    Name          VARCHAR(100)   NOT NULL,
    Email         VARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash  VARCHAR(255)   NOT NULL,
    Role          VARCHAR(50)    NOT NULL DEFAULT 'CUSTOMER',
    Phone         VARCHAR(25),
    CreatedAt     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Address table
CREATE TABLE Address (
    AddressId     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId    INT NOT NULL,
    Street        VARCHAR(255) NOT NULL,
    City          VARCHAR(100) NOT NULL,
    State         VARCHAR(100) NOT NULL,
    PostalCode    VARCHAR(20)  NOT NULL,
    Country       VARCHAR(100) NOT NULL,
    CONSTRAINT fk_address_customer FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

-- Category table
CREATE TABLE Category (
    CategoryId    INT IDENTITY(1,1) PRIMARY KEY,
    Name          VARCHAR(100) NOT NULL UNIQUE
);

-- Book table
CREATE TABLE Book (
    BookId        INT IDENTITY(1,1) PRIMARY KEY,
    Title         VARCHAR(200)  NOT NULL,
    Author        VARCHAR(200)  NOT NULL,
    Description   TEXT,
    Price         DECIMAL(10,2) NOT NULL,
    ImageUrl      VARCHAR(255),
    CategoryId    INT,
    StockQuantity INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_book_category FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId)
);

-- Cart table
CREATE TABLE Cart (
    CartId        INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId    INT NOT NULL UNIQUE,
    CONSTRAINT fk_cart_customer FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

-- CartItem table
CREATE TABLE CartItem (
    CartItemId    INT IDENTITY(1,1) PRIMARY KEY,
    CartId        INT NOT NULL,
    BookId        INT NOT NULL,
    Quantity      INT NOT NULL CHECK (Quantity > 0),
    CONSTRAINT fk_cartitem_cart FOREIGN KEY (CartId) REFERENCES Cart(CartId) ON DELETE CASCADE,
    CONSTRAINT fk_cartitem_book FOREIGN KEY (BookId) REFERENCES Book(BookId)
);

-- Wishlist table
CREATE TABLE Wishlist (
    WishlistId    INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId    INT NOT NULL UNIQUE,
    CONSTRAINT fk_wishlist_customer FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

-- WishlistItem table
CREATE TABLE WishlistItem (
    WishlistItemId INT IDENTITY(1,1) PRIMARY KEY,
    WishlistId     INT NOT NULL,
    BookId         INT NOT NULL,
    CONSTRAINT fk_wishlistitem_wishlist FOREIGN KEY (WishlistId) REFERENCES Wishlist(WishlistId) ON DELETE CASCADE,
    CONSTRAINT fk_wishlistitem_book FOREIGN KEY (BookId) REFERENCES Book(BookId)
);

-- Order table
CREATE TABLE [Order] (
    OrderId       INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId    INT NOT NULL,
    OrderDate     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount   DECIMAL(10,2) NOT NULL,
    Status        VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);

-- OrderItem table
CREATE TABLE OrderItem (
    OrderItemId   INT IDENTITY(1,1) PRIMARY KEY,
    OrderId       INT NOT NULL,
    BookId        INT NOT NULL,
    Quantity      INT NOT NULL CHECK (Quantity > 0),
    UnitPrice     DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orderitem_order FOREIGN KEY (OrderId) REFERENCES [Order](OrderId) ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_book FOREIGN KEY (BookId) REFERENCES Book(BookId)
);

-- Payment table
CREATE TABLE Payment (
    PaymentId     INT IDENTITY(1,1) PRIMARY KEY,
    OrderId       INT NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    PaymentDate   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order FOREIGN KEY (OrderId) REFERENCES [Order](OrderId) ON DELETE CASCADE
);

-- AdminUser table for store administrators
CREATE TABLE AdminUser (
    AdminUserId   INT IDENTITY(1,1) PRIMARY KEY,
    Name          VARCHAR(100) NOT NULL,
    Email         VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash  VARCHAR(255) NOT NULL
);