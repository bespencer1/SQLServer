USE MyDB;
GO

--Create the crm schema
IF SCHEMA_ID('crm') IS NULL
	EXEC('CREATE SCHEMA [crm]')
GO

--Create table 'Contacts' in scheam 'crm' in the FILEGROUP 'CRM'
--Set default values for InsertDate and UpdateDate
--Calculate Age using Date of Birth
--Add Unique constraint for UniqueID
--Add Check constraint for UniqueID_Source
--Add Foreign Key constraint on ParentContactID referencing ContactID

IF OBJECT_ID('crm.Contacts','U') IS NOT NULL
	DROP TABLE crm.Contacts;
GO

CREATE TABLE crm.Contacts (
	ContactID int NOT NULL IDENTITY(1,1) PRIMARY KEY
	, FirstName nvarchar(100) NOT NULL
	, LastName nvarchar(100) NOT NULL
	, DateOfBirth DATE NOT NULL
	, Age AS ((CAST(CONVERT(char(8),GetUTCDate(),112) AS INT) - CAST(CONVERT(char(8),DateofBirth,112) AS INT)) / 10000)
	, UniqueID nvarchar(100) NOT NULL
	, UniqueID_Source nvarchar(50) NOT NULL
	, ParentContactID int NULL
	, InsertDate DATETIME NOT NULL DEFAULT(GetUTCDate())
	, UpdateDate DATETIME NOT NULL DEFAULT(GetUTCDate())
	, CONSTRAINT CHK_Contacts_UniqueID_Source CHECK(UniqueID_Source IN ('SSN','Drivers License','Passport','Tax ID','Phone Number','Email'))
	, CONSTRAINT UC_Contacts_UniqueID UNIQUE (UniqueID)
	, CONSTRAINT FK_Contacts_ParentContactID FOREIGN KEY(ParentContactID) REFERENCES crm.Contacts (ContactID)
)
ON [CRM];


