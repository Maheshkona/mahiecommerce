
/* =========================================================
   Bookory E‑Commerce DB (SQL Server) — Database‑First DDL
   Matches the project in your zip:
     - Identity-based users & roles
     - Products/Categories
     - Cart, Wishlist
     - Orders, OrderItems, Payments
     - Addresses
   Tested for SQL Server 2019+
   ========================================================= */

-- 1) Create Database
IF DB_ID('BookoryDb') IS NULL
BEGIN
  CREATE DATABASE BookoryDb;
END
GO

USE BookoryDb;
GO

/* ========================
   2) ASP.NET Identity Core
   ======================== */

-- ROLES
IF OBJECT_ID('dbo.AspNetRoles','U') IS NULL
CREATE TABLE dbo.AspNetRoles
(
    Id               NVARCHAR(450) NOT NULL,
    Name             NVARCHAR(256) NULL,
    NormalizedName   NVARCHAR(256) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL,
    CONSTRAINT PK_AspNetRoles PRIMARY KEY (Id)
);
GO

-- USERS
IF OBJECT_ID('dbo.AspNetUsers','U') IS NULL
CREATE TABLE dbo.AspNetUsers
(
    Id                   NVARCHAR(450) NOT NULL,
    UserName             NVARCHAR(256) NULL,
    NormalizedUserName   NVARCHAR(256) NULL,
    Email                NVARCHAR(256) NULL,
    NormalizedEmail      NVARCHAR(256) NULL,
    EmailConfirmed       BIT NOT NULL DEFAULT 0,
    PasswordHash         NVARCHAR(MAX) NULL,
    SecurityStamp        NVARCHAR(MAX) NULL,
    ConcurrencyStamp     NVARCHAR(MAX) NULL,
    PhoneNumber          NVARCHAR(MAX) NULL,
    PhoneNumberConfirmed BIT NOT NULL DEFAULT 0,
    TwoFactorEnabled     BIT NOT NULL DEFAULT 0,
    LockoutEnd           DATETIMEOFFSET NULL,
    LockoutEnabled       BIT NOT NULL DEFAULT 1,
    AccessFailedCount    INT NOT NULL DEFAULT 0,
    -- Extra profile fields from Models/User.cs
    FirstName            NVARCHAR(100) NULL,
    LastName             NVARCHAR(100) NULL,
    CreatedAtUtc         DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_AspNetUsers PRIMARY KEY (Id)
);
GO

-- ROLE CLAIMS
IF OBJECT_ID('dbo.AspNetRoleClaims','U') IS NULL
CREATE TABLE dbo.AspNetRoleClaims
(
    Id         INT IDENTITY(1,1) NOT NULL,
    RoleId     NVARCHAR(450) NOT NULL,
    ClaimType  NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT PK_AspNetRoleClaims PRIMARY KEY (Id),
    CONSTRAINT FK_AspNetRoleClaims_Role FOREIGN KEY (RoleId)
        REFERENCES dbo.AspNetRoles(Id) ON DELETE CASCADE
);
GO

-- USER CLAIMS
IF OBJECT_ID('dbo.AspNetUserClaims','U') IS NULL
CREATE TABLE dbo.AspNetUserClaims
(
    Id         INT IDENTITY(1,1) NOT NULL,
    UserId     NVARCHAR(450) NOT NULL,
    ClaimType  NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT PK_AspNetUserClaims PRIMARY KEY (Id),
    CONSTRAINT FK_AspNetUserClaims_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- USER LOGINS
IF OBJECT_ID('dbo.AspNetUserLogins','U') IS NULL
CREATE TABLE dbo.AspNetUserLogins
(
    LoginProvider NVARCHAR(128) NOT NULL,
    ProviderKey   NVARCHAR(128) NOT NULL,
    ProviderDisplayName NVARCHAR(MAX) NULL,
    UserId        NVARCHAR(450) NOT NULL,
    CONSTRAINT PK_AspNetUserLogins PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- USER ROLES
IF OBJECT_ID('dbo.AspNetUserRoles','U') IS NULL
CREATE TABLE dbo.AspNetUserRoles
(
    UserId NVARCHAR(450) NOT NULL,
    RoleId NVARCHAR(450) NOT NULL,
    CONSTRAINT PK_AspNetUserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_AspNetUserRoles_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_AspNetUserRoles_Role FOREIGN KEY (RoleId)
        REFERENCES dbo.AspNetRoles(Id) ON DELETE CASCADE
);
GO

-- USER TOKENS
IF OBJECT_ID('dbo.AspNetUserTokens','U') IS NULL
CREATE TABLE dbo.AspNetUserTokens
(
    UserId        NVARCHAR(450) NOT NULL,
    LoginProvider NVARCHAR(128) NOT NULL,
    Name          NVARCHAR(128) NOT NULL,
    Value         NVARCHAR(MAX) NULL,
    CONSTRAINT PK_AspNetUserTokens PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_AspNetUserTokens_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- INDEXES (Identity)
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='RoleNameIndex' AND object_id=OBJECT_ID('dbo.AspNetRoles'))
    CREATE UNIQUE INDEX RoleNameIndex ON dbo.AspNetRoles (NormalizedName) WHERE NormalizedName IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='EmailIndex' AND object_id=OBJECT_ID('dbo.AspNetUsers'))
    CREATE INDEX EmailIndex ON dbo.AspNetUsers (NormalizedEmail);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UserNameIndex' AND object_id=OBJECT_ID('dbo.AspNetUsers'))
    CREATE UNIQUE INDEX UserNameIndex ON dbo.AspNetUsers (NormalizedUserName) WHERE NormalizedUserName IS NOT NULL;
GO

/* ========================
   3) Domain Tables
   ======================== */

-- Categories
IF OBJECT_ID('dbo.Categories','U') IS NULL
CREATE TABLE dbo.Categories
(
    CategoryId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(1000) NULL
);
GO

-- Products
IF OBJECT_ID('dbo.Products','U') IS NULL
CREATE TABLE dbo.Products
(
    ProductId     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name          NVARCHAR(200) NOT NULL,
    Author        NVARCHAR(200) NULL,
    Description   NVARCHAR(MAX) NULL,
    Price         DECIMAL(18,2) NOT NULL,
    Stock         INT NOT NULL DEFAULT 0,
    ImageUrl      NVARCHAR(500) NULL,
    CategoryId    INT NOT NULL,
    CreatedAtUtc  DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Products_Category FOREIGN KEY (CategoryId)
        REFERENCES dbo.Categories(CategoryId) ON DELETE NO ACTION
);
GO

-- Addresses (owned by a User)
IF OBJECT_ID('dbo.Addresses','U') IS NULL
CREATE TABLE dbo.Addresses
(
    AddressId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Line1       NVARCHAR(200) NOT NULL,
    Line2       NVARCHAR(200) NULL,
    City        NVARCHAR(100) NOT NULL,
    State       NVARCHAR(100) NOT NULL,
    PostalCode  NVARCHAR(20)  NOT NULL,
    Country     NVARCHAR(100) NOT NULL,
    UserId      NVARCHAR(450) NOT NULL,
    CONSTRAINT FK_Addresses_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- CartItems (no Cart header table; Cart = all items per User)
IF OBJECT_ID('dbo.CartItems','U') IS NULL
CREATE TABLE dbo.CartItems
(
    CartItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId     NVARCHAR(450) NOT NULL,
    ProductId  INT NOT NULL,
    Quantity   INT NOT NULL CHECK (Quantity >= 1),
    CONSTRAINT FK_CartItems_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_CartItems_Product FOREIGN KEY (ProductId)
        REFERENCES dbo.Products(ProductId) ON DELETE CASCADE
);
GO

-- Wishlist (simple list per User)
IF OBJECT_ID('dbo.Wishlists','U') IS NULL
CREATE TABLE dbo.Wishlists
(
    WishlistId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId     NVARCHAR(450) NOT NULL,
    ProductId  INT NOT NULL,
    CONSTRAINT FK_Wishlists_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_Wishlists_Product FOREIGN KEY (ProductId)
        REFERENCES dbo.Products(ProductId) ON DELETE CASCADE
);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Wishlist_User_Product' AND object_id=OBJECT_ID('dbo.Wishlists'))
    CREATE UNIQUE INDEX IX_Wishlist_User_Product ON dbo.Wishlists(UserId, ProductId);
GO

-- Orders
IF OBJECT_ID('dbo.Orders','U') IS NULL
CREATE TABLE dbo.Orders
(
    OrderId        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId         NVARCHAR(450) NOT NULL,
    OrderDateUtc   DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    Status         NVARCHAR(50) NOT NULL DEFAULT 'Pending',   -- Pending, Paid, Shipped, Delivered, Cancelled
    ShippingAddressId INT NULL,                                -- optional snapshot or reference
    TotalAmount    DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Orders_User FOREIGN KEY (UserId)
        REFERENCES dbo.AspNetUsers(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Orders_ShippingAddress FOREIGN KEY (ShippingAddressId)
        REFERENCES dbo.Addresses(AddressId) ON DELETE SET NULL
);
GO

-- OrderItems
IF OBJECT_ID('dbo.OrderItems','U') IS NULL
CREATE TABLE dbo.OrderItems
(
    OrderItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderId     INT NOT NULL,
    ProductId   INT NOT NULL,
    Quantity    INT NOT NULL CHECK (Quantity >= 1),
    UnitPrice   DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_OrderItems_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Product FOREIGN KEY (ProductId)
        REFERENCES dbo.Products(ProductId) ON DELETE NO ACTION
);
GO

-- Payments (1:1 with Order)
IF OBJECT_ID('dbo.Payments','U') IS NULL
CREATE TABLE dbo.Payments
(
    PaymentId     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderId       INT NOT NULL UNIQUE,
    PaymentDate   DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    Amount        DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL,  -- CreditCard, UPI, NetBanking, etc.
    TransactionId NVARCHAR(100) NULL,
    Status        NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_Payments_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE
);
GO

/* ========================
   4) Seed Data
   ======================== */

-- Roles
IF NOT EXISTS (SELECT 1 FROM dbo.AspNetRoles WHERE NormalizedName='ADMIN')
INSERT INTO dbo.AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES (NEWID(), 'Admin', 'ADMIN', NEWID());

IF NOT EXISTS (SELECT 1 FROM dbo.AspNetRoles WHERE NormalizedName='CUSTOMER')
INSERT INTO dbo.AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES (NEWID(), 'Customer', 'CUSTOMER', NEWID());
GO

-- Sample Categories
IF NOT EXISTS (SELECT 1 FROM dbo.Categories)
BEGIN
    INSERT INTO dbo.Categories (Name, Description) VALUES
    ('Fiction','Novels and stories'),
    ('Non-Fiction','Biographies, history, self-help'),
    ('Technology','Programming, computer science'),
    ('Education','Academic and exam prep'),
    ('Children','Kids books and activity');
END
GO

-- Sample Products
IF NOT EXISTS (SELECT 1 FROM dbo.Products)
BEGIN
    INSERT INTO dbo.Products (Name, Author, Description, Price, Stock, ImageUrl, CategoryId) VALUES
    ('Clean Code','Robert C. Martin','A Handbook of Agile Software Craftsmanship', 799.00, 25, NULL, (SELECT CategoryId FROM dbo.Categories WHERE Name='Technology')),
    ('The Pragmatic Programmer','Andrew Hunt, David Thomas','Journey to Mastery', 899.00, 20, NULL, (SELECT CategoryId FROM dbo.Categories WHERE Name='Technology')),
    ('The Alchemist','Paulo Coelho','A fable about following your dream', 299.00, 40, NULL, (SELECT CategoryId FROM dbo.Categories WHERE Name='Fiction'));
END
GO

/* =========================================================
   (Optional) Seeding an Admin user directly via SQL
   ---------------------------------------------------------
   Identity passwords must be HASHED. If you already created
   an account via the app's Register page, simply add that
   user to the Admin role using the sample below and skip
   the password insert.

   -- 1) Create user with a known Id (GUID string)
   DECLARE @AdminId NVARCHAR(450) = NEWID();
   INSERT INTO dbo.AspNetUsers (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount, FirstName, LastName)
   VALUES (@AdminId, 'admin@bookory.local', 'ADMIN@BOOKORY.LOCAL', 'admin@bookory.local', 'ADMIN@BOOKORY.LOCAL', 1,
           '<PUT_A_VALID_ASPNET_IDENTITY_PASSWORD_HASH_HERE>',
           NEWID(), NEWID(), 0, 0, 1, 0, 'Admin','User');

   -- 2) Add to Admin role
   DECLARE @RoleId NVARCHAR(450) = (SELECT TOP 1 Id FROM dbo.AspNetRoles WHERE NormalizedName='ADMIN');
   INSERT INTO dbo.AspNetUserRoles (UserId, RoleId) VALUES (@AdminId, @RoleId);

   Tip: An easy way to get a valid PasswordHash is to run the app once with an Admin registration and copy the hash from AspNetUsers.
   ========================================================= */
