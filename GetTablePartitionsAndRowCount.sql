SELECT 
SCHEMA_NAME(t.schema_id) AS Schema_Name
, t.name AS Table_Name
, i.name AS Index_Name
, fg.name AS [FileGroup_Name]
, a.partition_number AS Parition_Number


, ps.name AS ParitionSchema_Name
, pf.name as ParitionFunction_Name

, a.Row_Count

, CAST(a.used_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'UsedPages_MB'
, CAST(a.in_row_data_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'DataPages_MB'
, CAST(a.reserved_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'ReservedPages_MB'

, rv_lower.value as Lower_Boundary
, rv_upper.value as Upper_Boundary

, CASE WHEN ISNULL(rv_upper.value, rv_lower.value) IS NULL THEN 'N/A' 
	ELSE
		CASE WHEN pf.boundary_value_on_right = 0 AND rv_lower.value IS NULL THEN '>=' 
			WHEN pf.boundary_value_on_right = 0 THEN '>' 
			ELSE '>=' 
		END + ' ' + ISNULL(CONVERT(varchar(64), rv_lower.value), 'Min Value') + ' ' + 
			CASE pf.boundary_value_on_right WHEN 1 THEN 'and <' 
					ELSE 'and <=' END 
			+ ' ' + ISNULL(CONVERT(varchar(64), rv_upper.value), 'Max Value') 
	END AS TextComparison

FROM sys.dm_db_partition_stats a
INNER JOIN sys.tables t
	ON a.object_id = t.object_id
INNER JOIN sys.indexes i
	ON a.OBJECT_ID = i.OBJECT_ID  
	AND a.index_id = i.index_id
INNER JOIN sys.data_spaces ds
	ON i.data_space_id = ds.data_space_id
INNER JOIN sys.partition_schemes ps
	ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions AS pf   
    ON ps.function_id = pf.function_id 
INNER JOIN sys.destination_data_spaces dds
	ON ps.data_space_id = dds.partition_scheme_id
	AND a.partition_number = dds.destination_id
INNER JOIN sys.filegroups fg
	ON dds.data_space_id = fg.data_space_id
LEFT JOIN sys.partition_range_values AS rv_lower
    ON pf.function_id = rv_lower.function_id
    AND a.partition_number - 1 = rv_lower.boundary_id 
LEFT JOIN sys.partition_range_values AS rv_upper
    ON pf.function_id = rv_upper.function_id
    AND a.partition_number= rv_upper.boundary_id