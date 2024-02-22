-- DROP FUNCTION meta_info.f_dq_ldp_delete(text);

CREATE OR REPLACE FUNCTION meta_info.f_dq_ldp_delete(p_tbl_name text)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
/* f_dp_ldp_delete -   функция, удаляющая записи на в целевой таблице схемы gl
  		   
   	параметры функции:
   					p_tbl_name - имя целевой таблицы
   			
    возвращаемое значение: результат выполнения функции 
   
   
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 22.02.2024
 */		




declare

	l_trg_tbl_name text; -- таблица-приемник
	l_src_tbl_name text; -- таблица-источник
	dp_id int4; -- id таблицы
	l_schema text; -- схема источника
	l_message text := 'Analyze completed'; -- расхождения
	l_clmn_id text; -- поля по которым производится поиск потерь
	l_delete_cnt bigint = 0; -- количество расхождений
	l_id numeric; -- id протокола
	l_err_text text; -- текст ошибки

begin 
	
	-- получаем необходимые для удаления переменные
	select id,src_tbl_name, trg_tbl_name, clmn_id, src_schema_name
	into dp_id, l_src_tbl_name, l_trg_tbl_name, l_clmn_id, l_schema
	  from meta_info.dq_ldp
	where trg_tbl_name =  p_tbl_name
	  and is_enable_d = 1; 
	 
	 
	-- логирование
	perform meta_info.f_log('f_dq_ldp_delete','RUNNING','Аргумент функции - '|| p_tbl_name );
	 
	-- если запрос на получения необходимых переменных для удаления ничего не вернет, тогда выходим из функции
	if l_trg_tbl_name is null 
	 	then 
	 	    l_message := 'Not found table from meta_info.dq_ldp';
	 		-- логирование
			perform meta_info.f_log('f_dq_ldp_delete','COMPLETED EARLIER THAN EXPECTED',l_message);
			
	 		return l_message;
	 end if;

	-- добавляем новую запись в таблицу и возвращаем последний сформированный id
	insert into meta_info.dq_ldp_protocol (trg_tbl_name, check_type, date_start, status) 
	values (l_trg_tbl_name, 'DELETE', current_timestamp,'RUNNING') returning id into l_id;


	-- выполняем удаление записей по подзапросу, где таблица источник ищет расхождения с целовой таблицой.
	begin 
		
		execute 'delete from gl.'|| l_trg_tbl_name ||' where ('|| l_clmn_id || ') in (select ' || l_clmn_id || ' from '|| l_schema ||'.' ||l_src_tbl_name 
      || ' except select ' || l_clmn_id || ' from gl.' || l_trg_tbl_name|| ');';
    
	end;

	-- кладем в переменную количество удаленных записей
	
	get diagnostics l_delete_cnt = ROW_COUNT;

	-- обновляем таблицу протокола 
	update meta_info.dq_ldp_protocol 
	   set date_end = current_timestamp, status = 'PASSED', loss_cnt = l_delete_cnt
	where id = l_id;

	-- обновляем таблицу dq_ldp
	update meta_info.dq_ldp 
	  set  status_d = 'PASSED', loss_qnt_d = l_delete_cnt, message_d = l_message, check_d_dttm = current_timestamp
	where id = dp_id;

	-- логирование
	perform meta_info.f_log('f_dq_ldp_delete','PASSED',l_message);

return l_message;

-- обработчик ошибок
exception when
	  others then
		   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
		   -- обновляем таблицу dq_ldp
		   update meta_info.dq_ldp 
		     set  status_d = 'FAIL', loss_qnt_d = l_delete_cnt, message_d = l_err_text, check_d_dttm = current_timestamp
		   where id = dp_id;
		  
		   l_message := 'Analyze failed';
		  
		   	-- логирование
		   perform meta_info.f_log('f_dq_ldp_delete','FAILED',l_err_text);
		  
		   return l_message;
	
end;











$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_dq_ldp_delete(text) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_dq_ldp_delete(text) TO drp;
