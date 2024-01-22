drop function meta_info.f_parts_list(p_id int4);
CREATE OR REPLACE FUNCTION meta_info.f_parts_list(p_id int4)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
declare

l_sql_query text; -- sql запрос
l_a_cnt numeric; -- количество строк для конкретного значения
l_value_col text; -- значение поля
l_src_tbl_name text; -- имя таблицы-источника 
l_trg_tbl_name text; -- имя таблицы-приемника
l_part_col text; -- поле по которому создано сегментирование
l_err_text text; -- текст ошибки
cur refcursor; -- курсор



begin 
	-- получили значения полей необходимых для патриции
	select src_tbl_name, trg_tbl_name, part_key_col_list 
	into l_src_tbl_name, l_trg_tbl_name, l_part_col
	from meta_info.ee_gl_md egm
	where id = p_id;
	-- получаем все уникальные значения поля сегментирования
	open cur for execute 'select distinct '|| l_part_col || ' from stg.'|| l_src_tbl_name;
	
	loop 
		fetch cur into l_value_col;
		exit when not found;
		
		begin
			
			-- проверка на наличие значения патриции
			select count(*) 
			into l_a_cnt
			from pg_catalog.pg_partitions
			where schemaname = 'gl'
			and tablename =  l_trg_tbl_name
			and partitionlistvalues like '%' || l_value_col || '%';
		
			-- если партиции нет, то выполнить запрос на ее добавление
			if l_a_cnt = 0
				then 
					l_sql_query:= 'alter table gl.' || l_trg_tbl_name || ' add partition ' || l_trg_tbl_name || '_' || l_value_col || ' values (' || '''' || l_value_col || '''' || ')';
					execute l_sql_query;
			end if;
		
		-- обработчик ошибок
		exception when
			   others then
					get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;
					return l_err_text;
				
		end;
		
	end loop;
	
return l_sql_query;

end;


$$
EXECUTE ON ANY;


select meta_info.f_parts_list(2070);





