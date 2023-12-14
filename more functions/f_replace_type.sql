-- DROP FUNCTION public.f_replace_type(meta_info.ee_gl_md);

CREATE OR REPLACE FUNCTION public.f_replace_type(p_gl_md_row meta_info.ee_gl_md)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	

DECLARE
    
cur refcursor;
l_table_name text;
l_table_schema text;
l_col text;
l_data_type text;




begin 
	open cur for execute 'SELECT table_name, table_schema, column_name, data_type from information_schema.columns
					  where table_schema in (''gl'',''stg'')';
	loop 				 
		FETCH cur INTO l_table_name, l_table_schema, l_col, l_data_type; 	    
		    EXIT WHEN NOT FOUND;
		    begin
			    execute 'alter table '|| l_table_schema || '.' || l_table_name ||' alter column '|| l_col ||' TYPE ' || l_data_type || ' USING ' || l_col ||'::'|| l_data_type;
				
			   
			    exception when others then
	        		raise notice '%', l_table_name || '/' || l_col;
	    			raise notice 'Не удалось преобразовать тип данных: %', l_table_name || '/' || l_col;
	    	end;
		    	
		    		
			    
		    	
		    	
		   
	 end loop;  


return 'Функция завершила работу';
END;



$$
EXECUTE ON ANY;
