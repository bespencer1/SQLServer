USE MyDB;
GO

--Create the crm schema
CREATE SCHEMA [crm];
GO

--Grant SELECT permission to [Brian] on schema [crm] 
GRANT SELECT ON SCHEMA :: [crm] TO Brian; 