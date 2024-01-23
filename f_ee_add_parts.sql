-- DROP FUNCTION meta_info.f_ee_gl_add_parts(int4);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_add_parts(p_id int4)
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
	l_part_type text; -- тип сегментирования
	l_return_message text; -- переменная для возвращаемого значения
	l_s_dt date; -- дата начала партиции
	l_e_dt date; -- дата окончания партиции
	cur refcursor; -- курсор


begin 
	-- логирование
	perform meta_info.f_log('f_ee_gl_add_parts','RUNNING','аргумент функции - ' || p_id);
	-- получили значения полей необходимых для патриции
	select src_tbl_name, trg_tbl_name, part_key_col, part_type
	 into l_src_tbl_name, l_trg_tbl_name, l_part_col, l_part_type
	 from meta_info.ee_gl_md egm
	where id = p_id;

	 --если партицирование имеет тип LIST
	if l_part_type = 'list'
		then 
			-- логирование
			perform meta_info.f_log('f_ee_gl_add_parts', 'IN PROGRESS','медод партицирования - LIST');
		
			-- получаем все уникальные значения поля сегментирования
			open cur for execute 'select distinct '|| l_part_col || ' from stg.'|| l_src_tbl_name;
		
			l_return_message := 'added a list partition';		
			
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
							-- логирование
							perform meta_info.f_log('f_ee_gl_add_parts','PASSED', 'Добавлена партиция со значением: ' || l_value_col);
							
					end if;
				
				 --обработчик исключений
				exception when
					   others then
							get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;
							--логирование
							perform meta_info.f_log('f_ee_gl_add_parts','FAIL', l_err_text);
						
				end;
			end loop;
		
	 --если партицирование имеет тип RANGE	
	  elsif l_part_type = 'range'
		then
			--логирование
			perform meta_info.f_log('f_ee_gl_add_parts','IN PROGRESS','метод партицирования - RANGE');
		
			 --получаем все месяца в таблице
		    open cur for execute 'select distinct date_trunc(''month'',' || l_part_col || ') from ' || 'stg.' || lower(l_src_tbl_name);
		   
		   	l_return_message := 'added a range partition';
		   
		     --блок кода для добавления партиций 
			loop
			    fetch cur into l_s_dt; 	    
			    exit when not found;
			   
			    begin 
				    
				    l_e_dt := l_s_dt + interval '1' month;
				     --получаем количество партиций в заданном диапазоне
				    select count(*) 
					  into l_a_cnt 
					  from pg_catalog.pg_partitions 
					where partitionrangestart like '%' || l_s_dt || '%'  
					  and  partitionrangeend like '%' || l_e_dt || '%'
					  and  schemaname = 'gl'
					  and tablename = l_trg_tbl_name;
					 
					--проверка условия с последующим выполнением операции для добавления новой партиции
					if l_a_cnt = 0 
					then
				    	l_sql_query :=  'alter table gl.'||l_trg_tbl_name||' add partition start (timestamp '''||l_s_dt::text ||''') inclusive end (timestamp '''||l_e_dt::text ||''') exclusive';
				        execute l_sql_query;
				         --логирование 
				        perform meta_info.f_log('f_ee_gl_add_parts','PASSED','Добавлена партиция со значением: ' || l_s_dt::text);
				    end if;
				
				--обработка исключений
			    exception 
			        when others then
			        	get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;
			        	--логирование
			        	perform meta_info.f_log('f_ee_gl_add_parts','FAIL',l_err_text);
			    	
			    
			    end;
			end loop;
		
	else 
		l_return_message := 'the partition method is not recognized';
		--логирование
		perform meta_info.f_log('f_ee_gl_add_parts','A DIFFERENT VALUE WAS EXPECTED', l_return_message);
	end if;

return l_return_message;

end;






$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_gl_add_parts(int4) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_add_parts(int4) TO public;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_add_parts(int4) TO drp;
