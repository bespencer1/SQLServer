-- =============================================
-- Create stored procedure template
-- =============================================

--Set the database to user
USE <Database_Name>

-- Drop stored procedure if it already exists
IF EXISTS (
	SELECT 1 
	FROM sys.objects
    WHERE object_id = OBJECT_ID(N'<Schema_Name>.<Procedure_Name') AND type in (N'P', N'PC')
)
	DROP PROCEDURE <Schema_Name>.<Procedure_Name>;
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE <Schema_Name>.<Procedure_Name>
	<@param1> <datatype> = <default_value>, 
	<@param2> <datatype> = <default_value>
AS

/*

Author: <Your Name>
Version: 0.0.0
Purpose:
Calling System:
Change History:
Date		Name			Comments
2000-01-01	<Your Name>		<Notes>

*/
	--Use for dirty reads
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--Do not output counts
	SET NOCOUNT ON;

	BEGIN TRY
	
		--Select records
		SELECT @p1, @p2;
		
		--Insert records into a table
		INSERT INTO <Table_Name> (<Column_Names>)
		VALUES (@p1, @p2);
		
		--Update records in a table
		UPDATE <Table_Name>
		SET <Column_Name> = <Column_Value>
		
		
		--DB_NAME() --returns the current database name
		--SCOPE_IDENTITY() --Returns the value of an identity column when inserting a record
		
	END TRY
	BEGIN CATCH

		--Get the error information
		SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;

		--Raise an error to the calling system
		--RAISERROR('<Error_Message>',<level (16)>,<state (1)>);
		--THROW <Error_Number>, '<Error_Message', <state (1)>;
		
	END CATCH;

SET NOCOUNT OFF;

GO

-- =============================================
-- Example to grant execute permissions to stored procedure
-- =============================================
GRANT EXECUTE ON <Schema_Name>.<Procedure_Name> TO <Security_Account>;
GO

-- =============================================
-- Example to execute the stored procedure
-- =============================================
EXECUTE <Schema_Name>.<Procedure_Name>;
GO


