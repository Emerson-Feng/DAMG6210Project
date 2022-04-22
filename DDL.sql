IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Warehouse')
    DROP DATABASE Warehouse
GO
CREATE DATABASE Warehouse
GO
USE Warehouse
GO

-----Create Tables
--Drop TABLE Administartor
CREATE TABLE Administrator 
(
AdminID char(5)  not null,
AdminName nvarchar(25) not null, /*nvarchar for name*/
AdminNumber char(10),
[Address] varchar(50),
City varchar(20),
ZipCode char(5),
CONSTRAINT Admin_PK PRIMARY KEY (AdminID)
);

GO
CREATE TABLE Warehouse 
(
WhseID int not null,
WhseName nvarchar(25) not null, /*nvarchar for name*/
[Address] varchar(50),
City varchar(20),
ZipCode char(5),
CONSTRAINT Whse_PK PRIMARY KEY (WhseID)
);

CREATE TABLE Product 
(
ProID int not null,
ProName nvarchar(25) not null, /*nvarchar for name*/
ProType varchar(20)
	CONSTRAINT Pro_CHK CHECK(ProType in('appliance','food','furniture')),--only have given possible values,
SupID int,

CONSTRAINT Pro_PK PRIMARY KEY (ProID)
)
GO

CREATE TABLE Supplier 
(
SupID int not null,
SupName nvarchar(25) not null, /*nvarchar for name*/
SupNumber char(10),
[Address] varchar(50),
City varchar(20),
ZipCode char(5),
CONSTRAINT Sup_PK PRIMARY KEY (SupID)
);
GO


CREATE TABLE Customer 
(
CustID int not null,
CustName nvarchar(25) not null, /*nvarchar for name*/
CustNumber char(10),
[Address] varchar(50),
City varchar(20),
ZipCode char(5),
CONSTRAINT Cust_PK PRIMARY KEY (CustID)
);



CREATE TABLE Store 
(
ProID int not null,
WhseID int not null, /*nvarchar for name*/
TotalStorage int,
CONSTRAINT Store_PK PRIMARY KEY (ProID,WhseID)
);


CREATE TABLE InStock
(
ISID int IDENTITY(100001,1) not null,
WhseID int not null,
ProID int not null,
ISQuantity int not null,
AdminID char(5),
ISTime datetime,
CONSTRAINT IS_PK PRIMARY KEY (ISID,WhseID,ProID)
)




-- DROP TABLE OutStock;
CREATE TABLE OutStock
(
OSID int IDENTITY(200001,1) not null,
WhseID int not null,
ProID int not null,
OSQuantity int not null,
CustID int not null,
AdminID char(5),
OSTime datetime,
CONSTRAINT OS_PK PRIMARY KEY (OSID,WhseID,ProID)
)


GO
/****** Table Level Check Constraint:  ForeignKey ******/
--Table Product
ALTER TABLE dbo.Product
   ADD CONSTRAINT Product_FK FOREIGN KEY (SupID)
      REFERENCES dbo.Supplier(SupID);
GO
--Table InStock
ALTER TABLE dbo.InStock
   ADD CONSTRAINT IS_FK1 FOREIGN KEY (WhseID)
      REFERENCES dbo.Warehouse(WhseID);
GO
ALTER TABLE dbo.InStock
   ADD CONSTRAINT IS_FK2 FOREIGN KEY (ProID)
      REFERENCES dbo.Product(ProID);
GO
ALTER TABLE dbo.InStock
   ADD CONSTRAINT IS_FK3 FOREIGN KEY (AdminID)
      REFERENCES dbo.Administrator(AdminID);

--OutStock
ALTER TABLE dbo.OutStock
   ADD CONSTRAINT OS_FK1 FOREIGN KEY (WhseID)
      REFERENCES dbo.Warehouse(WhseID);
GO
ALTER TABLE dbo.OutStock
   ADD CONSTRAINT OS_FK2 FOREIGN KEY (ProID)
      REFERENCES dbo.Product(ProID);
GO
ALTER TABLE dbo.OutStock
   ADD CONSTRAINT OS_FK3 FOREIGN KEY (AdminID)
      REFERENCES dbo.Administrator(AdminID);
GO
ALTER TABLE dbo.OutStock
   ADD CONSTRAINT OS_FK4 FOREIGN KEY (CustID)
      REFERENCES dbo.Customer(CustID);
GO
--Table Store
Go
ALTER TABLE dbo.Store
   ADD CONSTRAINT Store_FK1 FOREIGN KEY (ProID)
      REFERENCES dbo.Product(ProID);
GO
ALTER TABLE dbo.Store
   ADD CONSTRAINT Store_FK2 FOREIGN KEY (WhseID)
      REFERENCES dbo.Warehouse(WhseID);
GO
--================================================
--Non-cluster Indexes
Create NONCLUSTERED INDEX IS_NCINDEX1 ON InStock(WhseID);
Create NONCLUSTERED INDEX IS_NCINDEX2 ON InStock(ProID);
Create NONCLUSTERED INDEX IS_NCINDEX3 ON InStock(AdminID);

Create NONCLUSTERED INDEX OS_NCINDEX1 ON OutStock(WhseID);
Create NONCLUSTERED INDEX OS_NCINDEX2 ON OutStock(ProID);
Create NONCLUSTERED INDEX OS_NCINDEX3 ON OutStock(CustID);
Create NONCLUSTERED INDEX OS_NCINDEX4 ON OutStock(AdminID);

Create  NONCLUSTERED INDEX Store_NCINDEX1 ON Store(ProID);
Create  NONCLUSTERED INDEX Store_NCINDEX2 ON Store(WhseID);
--============================================
USE Warehouse
GO
-- What's the quantity of each product in total
CREATE VIEW Product_TotalStorage AS
SELECT ProID, SUM(TotalStorage) AS TotalStorage
FROM Store
GROUP BY ProID

GO
-- Each warehouse has how many product in total
CREATE VIEW Warehouse_TotalStorage AS
SELECT WhseID, SUM(TotalStorage) AS TotalStorage
FROM Store
GROUP BY WhseID


GO
-- product_in_and_out_quantity_within7days
CREATE VIEW product_in_and_out_quantity_within7days AS
SELECT i.ProID as inProID, SUM(ISQuantity) AS ISQuantity,o.ProID as OutProID, SUM(OSQuantity) AS OSQuantity
FROM InStock i FULL JOIN OutStock o ON i.ProID = o.ProID 
WHERE DateDiff(dd,ISTime,getdate())<=7
GROUP BY i.ProID, o.ProID

GO

-- product_in_and_out_quantity_within7days
CREATE VIEW product_in_and_out_quantity AS
SELECT i.ProID as inProID, SUM(ISQuantity) AS ISQuantity,o.ProID as OutProID, SUM(OSQuantity) AS OSQuantity
FROM InStock i FULL JOIN OutStock o ON i.ProID = o.ProID 
GROUP BY i.ProID, o.ProID

GO
-- Statistics on the supply situation of each supplier
CREATE VIEW Supplier_Product_Quantity AS
SELECT p.SupID, p.ProID, p.ProName,p.ProType, SUM(i.ISQuantity) AS quantity
FROM Product p JOIN InStock i ON p.ProID = i.ProID
GROUP BY p.SupID, p.ProID, p.ProName,p.ProType

GO
-- calculate administrator instore workload
CREATE VIEW Administrator_IN_Workload AS
SELECT AdminID, SUM(ISQuantity)AS quantity
FROM  InStock
GROUP BY AdminID

GO
-- calculate administrator ouutstore workload
CREATE VIEW Administrator_OUT_Workload AS
SELECT AdminID, SUM(OSQuantity)AS quantity
FROM  OutStock
GROUP BY AdminID
--====================================================
USE Warehouse
GO
-- 1. Given a AdminID, get the administrator's operation records.
IF OBJECT_ID('getAdminRecord', 'P') IS NOT NULL  
   DROP PROCEDURE getAdminRecord;  
GO
CREATE PROCEDURE getAdminRecord @AdminID CHAR(5)
AS
BEGIN
    SELECT AdminID, 'InStock' as 'Operation', ISID as 'OperationID', ProID, WhseID, ISQuantity as 'Quantity'
    FROM InStock
    WHERE AdminID = @AdminID
    UNION
    SELECT AdminID, 'OutStock' as 'Operation', OSID as 'OperationID', ProID, WhseID, OSQuantity as 'Quantity'
    FROM OutStock
    WHERE AdminID = @AdminID
END
GO
EXEC getAdminRecord @AdminID = 'ad01'

GO

-- 2. Given a quantity of a product which we want outstock, check if the quantity in store is enough
IF OBJECT_ID('CheckQuantityValid', 'P') IS NOT NULL  
   DROP PROCEDURE CheckQuantityValid;  
GO
CREATE PROCEDURE CheckQuantityValid @Quantity INT,@ProID CHAR(5), @message VARCHAR(100) OUTPUT
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE ProID = @ProID
        
    )
    SET @message = 'The product is not in warehouse.'

    ELSE IF EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE TotalStorage >= @Quantity
    )
    BEGIN
        SET @message = 'Valid product quantity.'
    END

    ELSE IF EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE TotalStorage < @Quantity
    )
    BEGIN
        SET @message = 'InValid product quantity. The product in warehouse is not enough.'
    END
END
GO

DECLARE @Quantity INT,@ProID CHAR(5), @massage VARCHAR(100)
SET @Quantity = 500
SET @ProID = 10001
EXEC CheckQuantityValid @Quantity, @ProID , @massage OUTPUT
PRINT @massage

GO

DECLARE @Quantity INT,@ProID CHAR(5), @massage VARCHAR(100)
SET @Quantity = 700
SET @ProID = 10001
EXEC CheckQuantityValid @Quantity, @ProID , @massage OUTPUT
PRINT @massage

GO

-- 3. Put a product into warehouse
IF OBJECT_ID('ProductInStock', 'P') IS NOT NULL  
   DROP PROCEDURE ProductInStock;  
GO
CREATE PROCEDURE ProductInStock @WhseID INT, @ProID int, @quantity int, @AdminID CHAR(5)
AS
BEGIN
    INSERT dbo.InStock VALUES (@WhseID, @ProID, @quantity, @AdminID,getdate())
END
GO
DECLARE @WhseID INT, @ProID int, @quantity int, @AdminID CHAR(5)
-- SET @OSID = 'IS024'
SET @WhseID = 1002
SET @ProID = 10001
SET @quantity = 100
SET @AdminID = 'ad02'
EXEC ProductInStock @WhseID, @ProID, @quantity, @AdminID


-- 4. take some product from warehouse
IF OBJECT_ID('ProductInStock', 'P') IS NOT NULL  
   DROP PROCEDURE ProductInStock;  
GO
IF OBJECT_ID('TakeProductOutStock', 'P') IS NOT NULL  
   DROP PROCEDURE TakeProductOutStock;  
GO
CREATE PROCEDURE TakeProductOutStock @WhseID INT, @ProID int, @quantity int, @CustID int, @AdminID CHAR(5), @message VARCHAR(100) OUTPUT
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE ProID = @ProID and WhseID = @WhseID
        
    )
    SET @message = 'The product is out of stock in that warehouse.'

    ELSE IF EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE TotalStorage >= @quantity and WhseID = @WhseID
    )
    BEGIN
        INSERT dbo.OutStock VALUES (@WhseID,@ProID,@quantity,@CustID,@AdminID,getdate());
        UPDATE dbo.Store SET TotalStorage = TotalStorage - @quantity WHERE ProID = @ProID and WhseID = @WhseID
        SET @message = 'Valid product quantity. Updated warehouse store.'
    END

    ELSE IF EXISTS(
        SELECT 1 FROM dbo.Store
        WHERE TotalStorage < @Quantity and WhseID = @WhseID
    )
    BEGIN
        SET @message = 'InValid product quantity. The product in warehouse is not enough.'
    END
END

GO
DECLARE @WhseID INT, @ProID int, @quantity int, @CustID int, @AdminID CHAR(5), @massage VARCHAR(100)
SET @WhseID = 1001
SET @ProID = 10001
SET @quantity = 100
SET @CustID = 30001
SET @AdminID = 'ad02'
EXEC TakeProductOutStock @WhseID, @ProID, @quantity, @CustID, @AdminID, @massage OUTPUT
PRINT @massage
--=========================================================================================
--Trigger
---1.Change Supplier's Number
CREATE TABLE [dbo].[SupplierAudit](
    [SupplierAuditID] int not null primary key  identity(1,1),
	[SupID] int NOT NULL,
	[SupName] [nvarchar](25) NULL,
	[SupNumber] [char](10) NULL,
	[Address] varchar(50),
	[City] varchar(20),
	[ZipCode] char(5),
	[Action] char(1),
	[ActionDate] datetime
)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE TRIGGER SupplierNumberHistory
   ON  dbo.Supplier
  FOR UPDATE
AS 
BEGIN
declare @action char(1)
SET @action = 'U'
INSERT INTO  [SupplierAudit] ( 
  [SupID]
  ,[SupName]
  ,[SupNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,[Action]
  ,[ActionDate]
  )
  SELECT [SupID]
  ,[SupName]
  ,[SupNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,@action,
  GETDATE()
   FROM DELETED
END
GO
select *
from Supplier sup WHERE SupID = '20001' 
update 
 Supplier SET SupNumber ='6171001021' WHERE SupID = '20001' 
 select * from [SupplierAudit]

---2.Change Supplier's Address
 CREATE TABLE [dbo].[SupplierAddressAudit](
    [SupplierAuditID] int not null primary key  identity(1,1),
	[SupID] int NOT NULL,
	[SupName] [nvarchar](25) NULL,
	[SupNumber] [char](10) NULL,
	[Address] varchar(50),
	[City] varchar(20),
	[ZipCode] char(5),
	[Action] char(1),
	[ActionDate] datetime
)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE TRIGGER SupplierAddressHistory
   ON  dbo.Supplier
  FOR UPDATE
AS 
BEGIN
declare @action char(1)
SET @action = 'U'
INSERT INTO  [SupplierAudit] ( 
  [SupID]
  ,[SupName]
  ,[SupNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,[Action]
  ,[ActionDate]
  )
  SELECT [SupID]
  ,[SupName]
  ,[SupNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,@action,
  GETDATE()
   FROM DELETED
END
GO
select *
from Supplier sup WHERE SupID = '20001' 
update 
 Supplier SET Address ='300 Huntington Ave' WHERE SupID = '20001' 
 select * from [SupplierAudit]


 ---3.Change Customer's Number
CREATE TABLE [dbo].[CustomerAudit](
    [CustomerAuditID] int not null primary key  identity(1,1),
	[CustID] int NOT NULL,
	[CustName] [nvarchar](25) NULL,
	[CustNumber] [char](10) NULL,
	[Address] varchar(50),
	[City] varchar(20),
	[ZipCode] char(5),
	[Action] char(1),
	[ActionDate] datetime
)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE TRIGGER CustomerNumberHistory
   ON  dbo.Customer
  FOR UPDATE
AS 
BEGIN
declare @action char(1)
SET @action = 'U'
INSERT INTO  [CustomerAudit] ( 
  [CustID]
  ,[CustName]
  ,[CustNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,[Action]
  ,[ActionDate]
  )
  SELECT [CustID]
  ,[CustName]
  ,[CustNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,@action,
  GETDATE()
   FROM DELETED
END
GO
select *
from Customer cust WHERE cust.CustID = '30001' 
update 
 Customer  SET CustNumber ='6173721011' WHERE CustID = '30001' 
 select * from [CustomerAudit]
 
 
 ---4.Change Customer's Address
 CREATE TABLE [dbo].[CustomerAddressAudit](
    [CustomerAuditID] int not null primary key  identity(1,1),
	[CustID] int NOT NULL,
	[CustName] [nvarchar](25) NULL,
	[CustNumber] [char](10) NULL,
	[Address] varchar(50),
	[City] varchar(20),
	[ZipCode] char(5),
	[Action] char(1),
	[ActionDate] datetime
)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE TRIGGER CustomerAddressHistory
   ON  dbo.Customer
  FOR UPDATE
AS 
BEGIN
declare @action char(1)
SET @action = 'U'
INSERT INTO  [CustomerAddressAudit] ( 
	[CustID]
  ,[CustName]
  ,[CustNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,[Action]
  ,[ActionDate]
  )
  SELECT [CustID]
  ,[CustName]
  ,[CustNumber]
  ,[Address]
  ,[City]
  ,[ZipCode]
  ,@action,
  GETDATE()
   FROM DELETED
END
GO
select *
from Customer  WHERE CustID = '30001' 
update 
 Customer SET Address ='300 Huntington Ave' WHERE CustID = '30001' 
 select * from [CustomerAddressAudit]
 --==================================================================
 --User Defined Functions (UDF)
--1.Get Customers' contact information
--DROP FUNCTION GetCustomerConactInfo
IF OBJECT_ID('GetCustomerConactInfo', 'F') IS NOT NULL  
   DROP FUNCTION GetCustomerConactInfo;  
GO
CREATE FUNCTION GetCustomerConactInfo
(
@CustID int
)
RETURNS varchar(100)
AS
BEGIN
  DEclare @cust_info varchar(100)
 
 SELECT @cust_info = c.CustName + ': ' + c.CustNumber from Customer c WHERE c.CustID = @CustID
 
RETURN @cust_info
END
GO
/* Functions are executed within a query as shown below
*/
select *,dbo.GetCustomerConactInfo(CustID) as Customer_Contact from Customer
GO
--2.Get Customers' address information

IF OBJECT_ID('GetCustomerAddressInfo', 'F') IS NOT NULL  
   DROP FUNCTION GetCustomerAddressInfo;  
GO
CREATE FUNCTION GetCustomerAddressInfo
(
@CustID int
)
RETURNS varchar(100)
AS
BEGIN
  DEclare @cust_addressinfo varchar(100)
 
 SELECT @cust_addressinfo = c.CustName + ': ' + c.Address from Customer c WHERE c.CustID = @CustID
 
RETURN @cust_addressinfo
END
GO
/* Functions are executed within a query as shown below
*/
select *,dbo.GetCustomerAddressInfo(CustID) as Customer_Address from Customer
GO

---========================================================================
--3.Get suppliers' contact information
--DROP FUNCTION GetCustomerConactInfo
IF OBJECT_ID('GetSupplierConactInfo', 'F') IS NOT NULL  
   DROP FUNCTION GetSupplierConactInfo;  
GO
CREATE FUNCTION GetSupplierConactInfo
(
@SupID int
)
RETURNS varchar(100)
AS
BEGIN
  DEclare @Sup_info varchar(100)
 
 SELECT @Sup_info = s.SupName + ': ' + s.SupNumber from Supplier s WHERE s.SupID = @SupID
 
RETURN @Sup_info
END
GO
/* Functions are executed within a query as shown below
*/
select *,dbo.GetSupplierConactInfo(SupID) as Supplier_Contact from Supplier
GO
--4.Get suppliers' address information

IF OBJECT_ID('GetSupplierAddressInfo', 'F') IS NOT NULL  
   DROP FUNCTION GetSupplierAddressInfo;  
GO
CREATE FUNCTION GetSupplierAddressInfo
(
@SupID int
)
RETURNS varchar(100)
AS
BEGIN
  DEclare @Sup_addressinfo varchar(100)
 
 SELECT @Sup_addressinfo = s.SupName + ': ' + s.Address from Supplier s WHERE s.SupID = @SupID
 
RETURN @Sup_addressinfo
END
GO
/* Functions are executed within a query as shown below
*/
select *,dbo.GetSupplierAddressInfo(SupID) as Supplier_Address from Supplier


--5.Computed Columns based on a user defined function (UDF)
--Caculate the total storage time(hour)
IF OBJECT_ID('InStockTime', 'F') IS NOT NULL  
   DROP FUNCTION InStockTime;  
GO
CREATE FUNCTION InStockTime
(
@ISID varchar(10)
)
RETURNS int
WITH SCHEMABINDING
AS
     BEGIN
         DECLARE @newdate int;
         SELECT @newdate = DATEDIFF(HH, ist.ISTime, GETDATE())
         FROM [dbo].InStock AS ist
         WHERE ISID = @ISID;
         RETURN @newdate;
     END;
GO
select *,Warehouse.dbo.InStockTime(InStock.ISID) as TotalStorageTimeByHour from InStock;

SELECT *,DATEDIFF(HOUR, ist.ISTime, GETDATE()) as TotalStorageTimeByHour from InStock ist;


 --================================================================
 --Data Encryption
Alter table dbo.Administartor add Username varchar(50),[Password] varbinary(400);
--Create a master key for the database
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'damg6210';

GO
SELECT name KeyName,
	symmetric_key_id KeyID,
	key_length KeyLength,  
	algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

CREATE CERTIFICATE AdminPass
	WITH SUBJECT = 'Administrator Sample Password';
GO

CREATE SYMMETRIC KEY AdminPass_SM
	WITH ALGORITHM = AES_256
	ENCRYPTION BY CERTIFICATE AdminPass;

GO
UPDATE dbo.Administartor set [Username]=AdminName
, [Password] = ENCRYPTBYKEY(Key_GUID('AdminPass_SM'), convert(varbinary,'Pass123')  );
---===========================
OPEN SYMMETRIC KEY AdminPass_SM
	DECRYPTION BY CERTIFICATE AdminPass;
GO
SELECT *,
	CONVERT(varchar, DecryptByKey ([Password]))
	AS 'Decrypted password'
	From dbo.Administartor;
GO





