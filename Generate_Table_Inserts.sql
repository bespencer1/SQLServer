
DECLARE @TableName SYSNAME  
	, @SchemaName SYSNAME
	, @Condition VARCHAR(500) 

SELECT @TableName = '<Table_Name>'
	, @SchemaName = '<Schema>'
	, @Condition = ''


/* 
Parameters 
---------- 
@TableName    -- TableName for which Insert scripts to be generated. 
@SchemaName    -- SchemaName in which table belongs to. 
               Default value is 'dbo' 
@Condition  -- Filter condition for the records needed to be in the insert scripts. 
               Default Value is '' which generated insert script for all records. 
*/ 
 
    SET NOCOUNT ON 
 
    DECLARE @ColumnList VARCHAR(max) 
    DECLARE @InsertList VARCHAR(max) 
    DECLARE @pkcolList VARCHAR(max) 
    DECLARE @SQL varchar(max) 
    DECLARE @WhereSQL varchar(max) 
 
    SELECT @ColumnList = '' 
    SELECT @InsertList = '' 
    SELECT @pkcolList  = ''  
 
    SELECT @ColumnList = @ColumnList + CASE  
                                       WHEN ST.name not in ('timestamp','geography','geometry','hierarchyid','image','binary','varbinary') THEN Quotename(SC.name) + ','  
                                       ELSE ''  
                                       END  
          ,@InsertList = @InsertList + CASE WHEN ST.name not in ('timestamp','geography','geometry','hierarchyid','image','binary','varbinary') THEN 
                                        '''' +  QUOTENAME(sc.name) + '='' + '  + 'CASE WHEN ' + Quotename(SC.name)  
                                        + ' IS NULL THEN ''NULL'' ELSE  '''''''' +    REPLACE(CONVERT(VARCHAR(MAX),' + Quotename(SC.name) + '),'''''''','''''''''''') + ''''''''  END + ' + ' '','' + ' 
                                       ELSE '' 
                                       END 
      FROM SYS.objects so 
      JOIN SYS.columns sc 
        ON so.object_id = sc.object_id 
      JOIN SYS.types st 
        ON sc.user_type_id = st.user_type_id 
       AND sc.system_type_id = st.system_type_id 
      JOIN SYS.schemas sch 
        ON sch.schema_id = so.schema_id 
     WHERE SO.name = @TableName  
       AND sch.name = @SchemaName 
     ORDER BY SC.column_id 
 
 
    SELECT @WhereSQL = CASE  
                       WHEN LTRIM(RTRIM(@Condition)) <> '' THEN ' WHERE ' + @Condition 
                       ELSE '' 
                       END 
 
    SELECT @ColumnList =SUBSTRING(@ColumnList,1,LEN(@ColumnList)-1) 
    SELECT @InsertList =SUBSTRING(@InsertList,1,LEN(@InsertList)-4) + '''' 
     
    SELECT @SQL = 'SELECT ''INSERT INTO ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@Tablename) +  char(10)+  '(' + @ColumnList + ')'' + char(10)+  ''SELECT '' + ' + @InsertList  
                + ' FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@Tablename)  
                + @WhereSQL 
     
    --print @sql 
    EXEC(@SQL) 
 
GO 
