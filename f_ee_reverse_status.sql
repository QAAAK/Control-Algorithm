-- DROP FUNCTION meta_info.f_ini(text, numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ini(p_day text DEFAULT '1'::text, p_force numeric DEFAULT 0)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	

/* f_ini - корневая функция, отвечающая за переустановку статусов и сдвига параметров запуска загрузки в таблице meta_info.ee_stg_md, 
  		   основываясь на статусах из таблицы meta_info.ecm_task.
  		   
   параметры функции:
   			p_day - количество дней сдвига параметров (по умолчанию 1)
   			p_force - служебный параметр для отладки (по умолчанию 0)
   
   возвращаемое значение: статус о выполнении 
      
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 29.12.2023
*/	
			
declare
	l_id smallint; -- id таблицы
	l_status varchar(10); -- статус 
	l_sql_query text; -- команда sql
	l_days text := p_day || ' day'; -- интервал сдвига
	l_time time := current_time; -- текущее время
	l_err_text text; -- текст ошибки
	l_message text; -- текст возвращаемого значения
	cur refcursor; -- курсор
	
begin
	-- логирование
    perform meta_info.f_log('f_ini','RUNNING','аргументы функции - {' || p_day || ',' || p_force || '}');
	-- Проверка на корректное время запуска 
	if p_force = 0 and l_time > '04:00:00'
	 then
	   l_message := 'Incorrect start time'; 
	   -- логирование
	   perform meta_info.f_log('f_ini','FAIL', l_message);
	  
	   return l_message;
    end if;
   	
    -- Курсор открыт
	open cur for execute 'select id,  last_load_status from meta_info.ee_stg_md esm 
						  union all
						  select id, last_load_status from meta_info.ee_gl_md egm';
						 
	-- Блок программы, сдвигающий параметры и обновление таблицы 					 
	loop
	  fetch cur into l_id,  l_status;
	  exit when not found;	
	  begin
		
		-- условие, которое выполняется для конкретных статусов (статусов больше двух, будет доработано позднее)
		if l_status = 'SACCESFUL' or l_status = 'FAIL'
		  then 
			l_sql_query := 'update meta_info.ecm_task 
							set status = 1, 
							prm_date_from = prm_date_from + interval  ''' || l_days || ''' , 
							prm_date_to = prm_date_to + interval  ''' || l_days || '''
							where md_id = ' || l_id ;
									
			execute l_sql_query;
	    end if; 
		
	   -- обработка исключений
		exception 
		   when others then
		   
		   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	   
		   l_message := 'FAIL';		
		   -- логирование
    	   perform meta_info.f_log('f_ini','FAIL',l_err_text);
					
    	   return l_message;
			 
	   end;
	end loop;
	
	--вызов функции для обновления таблицы meta_info.ecm_task
	perform meta_info.f_ecm_set_tasks();	
	l_message := 'PASSED';
	--логирование
	perform meta_info.f_log('f_ini','PASSED','Operation completed');

	return l_message;

end;
			





$$
EXECUTE ON ANY;
