-- DROP FUNCTION meta_info.f_ini(text, numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ini(p_day text DEFAULT '1'::text, p_force numeric DEFAULT 0)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	
	

		
declare

	l_id smallint; -- id таблицы
	l_status varchar(10); -- статус 
	l_sql_query text; -- команда sql
	l_days text := p_day || ' day'; -- интервал сдвига
	l_time time := current_time; -- текущее время
	l_err_text text; -- текст ошибки

	cur refcursor; -- курсор
	
	begin
		
		if p_force = 0 and l_time > '04:00:00'
			then 
				return 'Некорректное время для запуска';
		end if;

	
	   	
		open cur for execute 'select id,  last_load_status from meta_info.ee_stg_md esm 
							  union all
							  select id, last_load_status from meta_info.ee_gl_md egm';
		loop
			fetch cur into l_id,  l_status;
			exit when not found;
			
			begin
		
				if l_status = 'SACCESFUL' or l_status = 'FAIL'
					then 
						l_sql_query := 'update meta_info.ecm_task 
										set status = 1, 
										prm_date_from = prm_date_from + interval  ''' || l_days || ''' , 
										prm_date_to = prm_date_to + interval  ''' || l_days || '''
										where md_id = ' || l_id ;
									
						execute l_sql_query;
				end if; 
				
				exception when others then
				    get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;
				   
    				perform meta_info.f_log('f_ini','FAIL',l_err_text);
    			
    				return 'Операция выполнена с ошбикой';
			 
			end;
		end loop;
			perform meta_info.f_ecm_set_tasks();
		
			perform meta_info.f_log('f_ini','SUCCESFUL','Операция выполнена');
		
		return 'Операция выполнена';		
	end;
			








$$
EXECUTE ON ANY;
