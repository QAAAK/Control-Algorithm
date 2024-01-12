-- DROP FUNCTION meta_info.f_change_status(numeric, numeric, numeric, text);

CREATE OR REPLACE FUNCTION meta_info.f_change_status(p_id numeric, p_status numeric, p_load_cnt numeric, p_message text DEFAULT NULL::text)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
 /* f_change_status - функция, отвечающая за обновление таблицы meta_info.ee_stg_md
   				      а также обновление meta_info.ecm_task на основе полученных аргументов
   				      функции.
  		   
   	параметры функции:
   					p_id - id обновляемой таблицы
   	   				p_status - статус операции
   	   				p_load_cnt - количество добавленных записей
   	   				p_message - сообщение о загрузке (по умолчанию null)
   			
    возвращаемое значение: результат выполнения функции 
   
   
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 29.12.2023
 */	

declare 

	l_md_id numeric; -- id таблицы
	l_err_text text; -- текст ошибки
	l_status text; -- change status
	l_message text; -- переменная, содержащая возвращаемое значение

begin
	-- логирование
	perform meta_info.f_log('f_change_status','RUNNING','аргументы функции - {' || p_id || ',' || p_status || ',' || p_load_cnt || ',' || p_message '}');
	
	-- на основе аргументов функции, обновляем таблицу meta_info.ecm_task
	update meta_info.ecm_task set status = p_status, last_load_cnt = p_load_cnt, message = p_message 
	where id = p_id;
	
	-- кладем в переменную id по заданному условию
	select md_id 
	  into l_md_id
	  from meta_info.ecm_task
	where 1=1
	  and id = p_id
	  and md_table_name = 'EE_STG_MD'
	limit 1;

	begin	
		-- проверяем полученное значение и изменяем переменную статусов с последующим обновлением записей
		if l_md_id is not null
			then 
			    case
				    when p_status = 1 then l_status := 'READY';
				    when p_status = -1 then l_status := 'FAIL';
				    when p_status = 5 then l_status := 'SUCCESFUL';
				    else l_status := 'NOT DEFINED';
				end case;
				
	   			update meta_info.ee_stg_md set last_load_status = l_status, last_load_cnt = p_load_cnt, message_text = p_message, last_load_dttm = current_timestamp 
				where id = l_md_id;
		
		else 
		    l_message := 'There is no table with this id';
		    -- логирование
		    perform meta_info.f_log('f_change_status','COMPLETED EARLIER THAN EXPECTED',l_message);
		   
			return l_message;
		
		end if;
	
	-- обработка исключений
	exception 
	  when others then
		
      get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;      
	  l_message := 'FAIL'; 
	  -- логирование
      perform meta_info.f_log('f_change_status','FAIL',l_err_text);
     
	  return l_message;
	 
    end;
   
    l_message := 'PASSED';
    -- логирование
    perform meta_info.f_log('f_change_status','PASSED','Operation completed');
   
    return l_message;
   
end;
	



$$
EXECUTE ON ANY;
