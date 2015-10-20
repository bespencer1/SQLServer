-- Searches in SQL objects for a string

DECLARE @SearchStr nvarchar(100); 
SET @SearchStr = '%<Search String>%';  -- The search string. 
 
WITH def AS  
   (SELECT SCH.name + '.' + OBJ.name AS [Object_Name]
          ,OBJ.type_desc AS Object_Type 
          ,OBJ.modify_date AS Object_Modify_Date 
          ,PARSCH.name + '.' + PAROBJ.name as Parent_Name 
          ,PAROBJ.type_desc AS Parent_Type 
          ,RTRIM(LTRIM(MDL.[definition])) AS Sql_Code 
    FROM sys.sql_modules AS MDL 
         INNER JOIN sys.objects AS OBJ 
             ON MDL.object_id = OBJ.object_id 
         INNER JOIN sys.schemas AS SCH 
             ON OBJ.schema_id = SCH.schema_id 
         LEFT JOIN sys.objects AS PAROBJ 
             ON OBJ.parent_object_id = PAROBJ.object_id 
         LEFT JOIN sys.schemas AS PARSCH 
             ON PAROBJ.schema_id = PARSCH.schema_id 
    WHERE MDL.[definition] LIKE @SearchStr) 
    
SELECT [Object_Name]
      ,Object_Type 
      ,Object_Modify_Date 
      ,Parent_Name 
      ,Parent_Type 
      ,Sql_Code 
FROM def     
ORDER BY Object_Type     

GO 