-- DROP FUNCTION public.add_columns_dlk();

CREATE OR REPLACE FUNCTION public.add_columns_dlk()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
DECLARE     
     cur refcursor;
     l_table_name text;
     l_table_schema text;
     sql_query text;
     
begin
	
	open cur for execute 'select table_schema, table_name from information_schema.tables
					  where 1= 1 and
					  table_schema in (''stg'', ''gl'') and 
                      table_type = ''BASE TABLE'' and 
                      table_name not like ''%_prt_%'' and
					  table_name like ''%dlk%''';

	loop
		fetch cur into l_table_schema, l_table_name;
		
		exit when not found;
		begin
			sql_query := 'alter table '|| l_table_schema || '.' || l_table_name ||' add column op_type varchar(1)';
			execute sql_query;
		
			exception when others then
		        raise notice '%', sql_query;
		    	raise notice 'Такое поле уже существует в таблице: %', l_table_name;
		end;
	end loop;
	
   return 'Процесс завершен';
END;


$$
EXECUTE ON ANY;
