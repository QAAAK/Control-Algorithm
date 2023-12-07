-- DROP FUNCTION public.rename_column_system();

CREATE OR REPLACE FUNCTION public.rename_column_system()
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
DECLARE     

cur refcursor;
l_name_table text;
l_column_name text;
l_schema_name text;
begin

		open cur for execute 'select table_schema, table_name, column_name from information_schema.columns
							  where column_name in (''w$ldate'', ''w$loadid'') and table_name not like ''%_prt_%''';	
		loop 
			fetch cur into l_schema_name, l_name_table, l_column_name;
			exit when not found;
			begin 
				if l_column_name = 'w$ldate'
					then 
						execute 'alter table ' || l_schema_name || '.' || l_name_table || ' rename column w$ldate to w_ldate';
				elsif l_column_name = 'w$loadid'
					then 
						execute 'alter table ' || l_schema_name || '.' || l_name_table || ' rename column w$loadid to w_loadid';
				end if;
				
				--exception when others then
					--raise notice 'Не получилось преобразовать поле таблицы %', l_name_table;
			end;		
				
		end loop;

return 'Операция завершена.';
	
END;

$$
EXECUTE ON ANY;
