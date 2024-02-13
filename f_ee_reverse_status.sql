-- DROP FUNCTION meta_info.f_ecm_ini(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ecm_ini(p_force numeric DEFAULT 0)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	
	 /* f_ecm_ini - корневая функция, сбрасывающая статусы в таблицы и обновляя таблицу 
	    			для ЕКМ на основе метовых таблиц
  		   
   	параметры функции:
   					p_force - параметр для отладки
   			
    возвращаемое значение: результат выполнения функции 
   
   
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 07.02.2024
 */	
	
	
	
	
declare
	l_time time := current_time; -- текущее время
	l_err_text text; -- текст ошибки
	l_message text; -- текст возвращаемого значения
	
begin
	-- логирование
    perform meta_info.f_log('f_ecm_ini','RUNNING','аргументы функции - {' || p_force || '}');
	-- Проверка на корректное время запуска 
	if p_force = 0 and l_time > '04:00:00'
	 then
	   l_message := 'Incorrect start time'; 
	   -- логирование
	   perform meta_info.f_log('f_ecm_ini','COMPLETED EARLIER THAN EXPECTED', l_message);
	  
	   return l_message;
	  
    end if;		 
	-- Блок программы, сдвигающий параметры и обновление таблицы 
	  begin
		-- обновление таблиц meta_info.ee_gl_md и meta_info.ee_stg_md
			  update meta_info.ee_stg_md 
				set last_load_status = 'READY' 
			  where last_load_status in ('SUCCESSFUL','FAIL');
									
			  update meta_info.ee_gl_md 
			  	set last_load_status = 'READY'
			  where last_load_status in ('SUCCESSFUL','FAIL');
			 
		-- вызов функции смены времени запуска ЕКМ
		perform meta_info.f_ee_reset_stg_param();
		
	   -- обработка исключений
		exception 
		   when others then
		   
		   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	   
		   l_message := 'FAIL';		
		   -- логирование
    	   perform meta_info.f_log('f_ecm_ini',l_message,l_err_text);
					
    	   return l_message;
			 
	   end;
	--вызов функции для обновления таблицы meta_info.ecm_task
	perform meta_info.f_ecm_set_tasks();	

	l_message := 'PASSED';
	--логирование
	perform meta_info.f_log('f_ecm_ini',l_message,'Operation completed');

	return l_message;

end;
			









$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ecm_ini(numeric) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ecm_ini(numeric) TO public;
GRANT ALL ON FUNCTION meta_info.f_ecm_ini(numeric) TO drp;
