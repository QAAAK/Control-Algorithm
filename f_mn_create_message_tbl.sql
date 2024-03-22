


CREATE OR REPLACE FUNCTION meta_info.f_mn_create_message_tbl()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	

/* 
   f__mn_create_message_tbl - Процедура генерации создания таблицы для отправки ее на почту
 			              администратору drp или же иному лицу
  		   
   параметры : 
   				
   			
   возвращаемое значение: сгенерированная таблица 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 22.03.2024
*/	
			
	
	
	
		

declare

	l_tbl_message_proc_detail text; -- Генерируемая таблица на основе meta_info.v_mn_task_process_detail
	l_tbl_message_proc_status text; -- Генерируемая таблица на основе meta_info.v_mn_process_status
	l_tbl_message text; -- Получаемый на выходе сгенерированный текст
	l_err_text text; -- сообщение об ошибке
	
	

begin 
	   -- логирование
	   perform meta_info.f_log('f_mn_create_message_tbl','RUNNING','Operation started.');
	   -- Формируем таблицу meta_info.v_mn_task_process_detail
		select string_agg( 
			   '| ' || rpad(task_type, 10, ' ') || '| ' || 
			   rpad(name_table , 50, ' ') || '|  ' ||
			   rpad(process_type  , 14, ' ') || '| '  ||
			   rpad(status, 10, ' ') || '| '  ||
			   rpad(coalesce (dt_begin::text, '')  , 27, ' ') || '| '  ||
			   rpad(coalesce (dt_end::text, '')  , 27, ' ') || '|' || chr(10) ||
			   '+' || rpad('-', 150, '-') || '+ ' , chr(10))
		into l_tbl_message_proc_detail
		from meta_info.v_mn_task_process_detail vmtpd;
		
		l_tbl_message_proc_detail := 
		       ' Состояние потоков регламентных процессов (meta_info.v_mn_task_process_detail)' || chr(10) ||
				'+' || rpad('-', 150, '-') || '+' || chr(10) ||
			   '| ' || rpad('task_type', 10, ' ') || '| ' || 
			   rpad('name_table' , 50, ' ') || '|  ' ||
			   rpad('process_type'  , 14, ' ') || '| '  ||
			   rpad('status', 10, ' ') || '| '  ||
			   rpad('dt_begin' , 27, ' ') || '| '  ||
			   rpad('dt_end' , 27, ' ') || '|' || chr(10) ||
			   '+' || rpad('-', 150, '-') || '+' || chr(10) ||  l_tbl_message_proc_detail || chr(10);
			      
		-- Формируем таблицуmeta_info.v_mn_process_status
		select string_agg( 
			   '| ' || rpad(process_type , 12, ' ') || '| ' || 
			   rpad(system_code , 12, ' ') || '| ' ||
			   rpad(status_ready::text  , 12, ' ') || '| '  ||
			   rpad(status_started::text , 14, ' ') || '| '  ||
			   rpad(status_succesful::text  , 16, ' ') || '| ' ||
			   rpad(status_fail::text , 12, ' ') || '| '  ||
			   rpad(coalesce (last_dttm ::text, '') , 27, ' ') || '| ' || chr(10) ||
			   '+' || rpad('-', 118, '-') || '+ ' , chr(10))
		into l_tbl_message_proc_status
		from meta_info.v_mn_process_status vmps;
	
		l_tbl_message_proc_status :=
		       ' Состояние регламентных потоков (meta_info.v_mn_process_status)' || chr(10) ||
			   '+' || rpad('-', 118, '-') || '+ ' || chr(10) ||
			   '| ' || rpad('process_type' , 12, ' ') || '| ' || 
			   rpad('system_code' , 12, ' ') || '| ' ||
			   rpad('status_ready'  , 12, ' ') || '| '  ||
			   rpad('status_started', 14, ' ') || '| '  ||
			   rpad('status_successful' , 16, ' ') || '| ' ||
			   rpad('status_fail', 12, ' ') || '| '  ||
			   rpad(coalesce ('last_dttm', '') , 27, ' ') || '| ' || chr(10) ||
			   '+' || rpad('-', 118, '-') || '+ ' || chr(10) ||  l_tbl_message_proc_status || chr(10);
	
		l_tbl_message := l_tbl_message_proc_status || chr(10) ||  l_tbl_message_proc_detail;
		-- логирование
		perform meta_info.f_log('f_mn_create_message_tbl','SUCCESSFUL','Operation completed.');
	
return l_tbl_message;

exception when
	  others then
		   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
		   	-- логирование
		   perform meta_info.f_log('f_mn_create_message_tbl','FAIL',l_err_text);
		  
		   return 'FAIL';

end;










$$
EXECUTE ON ANY;



