USE MyDB;
GO

--Goal: Parition the orders table by order year
--Place orders where year >= 2023 into the Sales partition 

--Step 1: Create the file groups
ALTER DATABASE MyDB  
ADD FILEGROUP Orders;
GO
ALTER DATABASE MyDB  
ADD FILEGROUP Orders2022;  
GO  
ALTER DATABASE MyDB  
ADD FILEGROUP Orders2021;  
GO  


--Step 2: Create the files for the file groups
ALTER DATABASE MyDB   
ADD FILE   
(  
    NAME = Orders,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Orders.ndf',  
    SIZE = 5MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP Orders; 

ALTER DATABASE MyDB   
ADD FILE   
(  
    NAME = Orders2022,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Orders2022.ndf',  
    SIZE = 5MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP Orders2022; 


ALTER DATABASE MyDB   
ADD FILE   
(  
    NAME = Orders2021,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Orders2021.ndf',  
    SIZE = 5MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP Orders2021; 


--Step 3: Create the partition function OrderYear
--Partition 1: <= 2021
--Partition 2: > 2021 AND <= 2022
--Partition 3: > 2022
CREATE PARTITION FUNCTION pf_OrderYear (smallint)  
    AS RANGE LEFT FOR VALUES (2021,2022);  
GO  

--Step 4: Create partition schema
CREATE PARTITION SCHEME ps_OrderYear
    AS PARTITION pf_OrderYear  
    TO (Orders2021, Orders2022, Orders);  
GO  

--Step 5:  Create the Orders table using the partition scheme on the OrderYear column
--OrderYear column must be included in the primary key
CREATE TABLE dbo.Orders (
	OrderID UNIQUEIDENTIFIER NOT NULL DEFAULT(NewID())
	, OrderDate Date NOT NULL DEFAULT(GetDate())
	, OrderYear smallint NOT NULL
	, CustomerID int NOT NULL
	, InsertDate DateTime NOT NULL DEFAULT(GetUTCDate())
	, UpdateDate DateTime NOT NULL DEFAULT(GetUTCDate())
	, PRIMARY KEY(OrderID,OrderYear)
) ON ps_OrderYear(OrderYear);