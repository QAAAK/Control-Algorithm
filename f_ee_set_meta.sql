-- DROP FUNCTION meta_info.f_ee_set_meta();

CREATE OR REPLACE FUNCTION meta_info.f_ee_set_meta()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
declare 
l_table text;

cur refcursor;

l_arr_col_name text[];

l_pk_arr_col text[];

l_col_string text;

l_pk_col_string text;

l_part_attr text;

is_true int;

rowcount int := 0;
--load_type int;
--is_type int;
l_trg_col_string text := '';

l_col_trg text;

data_trg text;

char_max int;

num_precision int;

l_param text;

l_total_rows bigint;

l_type_load smallint;

begin
open cur for execute 'select table_name from information_schema.tables
					  where 1= 1 and
					  table_schema = ''stg'' and 
                      table_type = ''BASE TABLE'' and 
                      table_name not like ''%_prt_%'';';

loop
	    fetch cur into l_table;

		exit when not found;

		select count(*)    --- получаем информацию о наличии таблицы в метаданных
		into is_true
		from meta_info.ee_gl_md egm 
		where src_tbl_name = l_table;
		
		if is_true = 0
			    then	
			    	select array_agg(column_name::text order by ordinal_position) --- получаем имена полей таблицы источника
				    into l_arr_col_name
				    from information_schema.columns
					where table_name = l_table and table_schema = 'stg';
		
					l_col_string := array_to_string(l_arr_col_name,',');  --- преобразуем в строку
		
					foreach l_col_trg in array l_arr_col_name loop  --- с помощью цикла получаем типы данных и преобразуем по арх.дизайну для таблицы приемника
				       
					    select data_type, character_maximum_length, numeric_precision
					     into data_trg, char_max, num_precision
					     from information_schema.columns
						where 1 = 1
						 and column_name = l_col_trg
						 and table_schema = 'gl';
			
						case 
							when data_trg ~ 'character varying' then data_trg := 'V';
							when data_trg ~ 'numeric' then data_trg := 'N';
							when data_trg ~ 'smallint/bigint/int' then data_trg := 'I';
							when data_trg ~ 'timestamp' then data_trg := 'T';
							when data_trg ~ 'date' then data_trg := 'D';
							else data_trg := 'V';
						end case;
			
						if char_max is null = false   
						or num_precision is null = false
					  	  then
					  	   		l_trg_col_string := l_trg_col_string || l_col_trg || ' ' || '[' || data_trg || '(' || coalesce(char_max, num_precision) || ')], ';
					  	else
						 		l_trg_col_string := l_trg_col_string || l_col_trg || ' ' || '[' || data_trg || '], ';
					   	end if;
					  
					 end loop;
		
					 l_trg_col_string := rtrim(l_trg_col_string,', ');  --- преобразуем в строку

					 select array_agg(c.column_name::text)  --- получаем ключи таблицы и дистрибуцию
					 into l_pk_arr_col
					 from information_schema.table_constraints tc
					 join information_schema.constraint_column_usage as ccu using (constraint_schema,constraint_name)
					 join information_schema.columns as c on c.table_schema = tc.constraint_schema
					 and tc.table_name = c.table_name
					 and ccu.column_name = c.column_name
					 where 1 = 1
						and constraint_type = 'PRIMARY KEY'
						and c.table_schema = 'stg'
						and tc.table_name = l_table;

					if l_pk_arr_col is null = true
	    				then 
      	   					l_pk_col_string := '';
					else
      						l_pk_col_string := array_to_string(l_pk_arr_col,',');
					end if;

					select column_name              --- получаем поля партиции 
					into l_part_attr
					from information_schema.constraint_column_usage
					where 1 = 1
					and table_name like '%_prt_%'
					and table_name like '%' || l_table || '%'
					limit 1;

					if l_part_attr is null = true
		    			then 
	      	   				l_part_attr := '';
					end if;
	       
				    select pg_catalog.pg_class.reloptions  --- получаем параметры таблицы
				    into l_param
					from pg_catalog.pg_class
				    
					join pg_catalog.pg_namespace on
					pg_catalog.pg_class.relnamespace = pg_catalog.pg_namespace.oid
					where
					pg_catalog.pg_class.relname = l_table
					and pg_catalog.pg_namespace.nspname = 'stg';

					if l_param is null = true
						    	then 
						    		l_param := '';
					end if;

				
				    select n_live_tup  from pg_stat_user_tables
					into l_type_load
					where schemaname = 'stg' and relname = l_table;  --- определяем тип загрузки таблицы 
			
				  
				   if l_total_rows > 10000
				   		then l_type_load := 2;
				   else 
				   		l_type_load := 1;
				   end if;
				   
					insert            --- заносим данные о таблицы в meta_info.f_ee_gl_md
						into
						meta_info.ee_gl_md  (src_tbl_name,
						src_cols,
						trg_tbl_name,
						src_key_cols,
						distr_col,
						part_key_col,
						is_enable,
						load_type,
						trg_cols,
						tbl_param)
					values (l_table,
					l_col_string,
					l_table,
					l_pk_col_string,
					l_pk_col_string,
					l_part_attr,
					1,
					l_type_load,
					l_trg_col_string,
					l_param);
					
					l_arr_col_name := null;  --- обнуляем переменные
					
					l_pk_arr_col := null;
					
					l_part_attr := null;
					
					l_trg_col_string := '';
					
					l_param := null;
					
					rowcount := rowcount + 1;  --- наполняем счетчик добавленных полей в метаданные
		end if;
end loop;

return 'Добавлено ' || rowcount || ' строк в метаданные.';
end;



$$
EXECUTE ON ANY;
