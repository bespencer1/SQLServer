USE [master];
GO

IF DB_ID (N'MyDB') IS NOT NULL
	DROP DATABASE MyDB;
GO

--Create MyDB database
--Specify multiple database and transaction log files
CREATE DATABASE MyDB
	ON  PRIMARY 
		( NAME = N'MyDB', FILENAME = N'D:\...\MSSQL\Data\MyDB.mdf', SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 5MB )
	, FILEGROUP CRM
		( NAME = N'MyDB_CRM', FILENAME = N'M:\...\MSSQL\Data\MyDB_CRM.mdf', SIZE = 100MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB )
	LOG ON 
	( NAME = N'MyDB_log', FILENAME = N'T:\...\MSSQL\Log\MyDB_log.ldf' , SIZE = 5MB , MAXSIZE = 512MB , FILEGROWTH = 5MB )
GO
