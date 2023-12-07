-- DROP FUNCTION testing.rename_table_dollar();

CREATE OR REPLACE FUNCTION testing.rename_table_dollar()
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
DECLARE     

cur refcursor;
l_name_table_old text;
l_name_table_new text;
l_schema_name text;
begin

		open cur for execute 'select table_schema, table_name from information_schema.tables
		where table_schema not in (''diskquota'', ''gp_toolkit'', ''pg_catalog'')
		and table_name like ''%$%''';	
		loop 
			fetch cur into l_schema_name, l_name_table_old;
			exit when not found;
			begin 
				
				l_name_table_new := replace (l_name_table_old, '$', '_');
				
				execute 'alter table '|| l_schema_name || '.' || l_name_table_old || ' rename to ' || l_name_table_new;
				
				exception when others then
					raise notice 'Не получилось преобразовать наименование таблицы %', l_name_table_old;
			end;		
				
		end loop;

return 'Операция завершена.';
	
END;

$$
EXECUTE ON ANY;
