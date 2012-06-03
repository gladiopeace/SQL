SELECT
	count(*)*8/1024 AS 'Cached Size (MB)'
	,CASE database_id
		WHEN 32767 THEN 'ResourceDb'
		ELSE db_name(database_id)
	 END AS 'Database'
 FROM sys.dm_os_buffer_descriptors
 GROUP BY db_name(database_id) ,database_id
 ORDER BY 'Cached Size (MB)' DESC