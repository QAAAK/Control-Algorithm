-- DROP FUNCTION meta_info.f_dq_ldp(int4);

CREATE OR REPLACE FUNCTION meta_info.f_dq_ldp(p_id int4)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	

/* 
 * f_dq_ldp - 	 Первая версия функции по поиску удаленных данных на источнике
  		   
   параметры : 
   				p_id - идентификатор таблицы
   			
   возвращаемое значение: результат выполнения функции 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 27.12.2023
*/	
			
	
	
	
		

declare

	l_trg_tbl_name text; -- таблица-приемник
	l_src_tbl_name text; -- таблица-источник
	l_schema text; -- схема источника
	l_message text := 'Analyze completed'; -- расхождения
	l_clmn_id text; -- поля по которым производится поиск потерь
	l_clmn_id_vals text; -- найденые значения расхождений
	l_cnt bigint = 0; -- количество расхождений
	l_id numeric; -- id протокола
	l_err_text text; -- текст ошибки
	
	

begin 
	-- логирование
	perform meta_info.f_log('f_dq_ldp','RUNNING','Аргумент функции - '|| p_id);
	-- необходимые поля для поиска потерь
	select src_tbl_name, trg_tbl_name, clmn_id, src_schema_name, replace(clmn_id,',','||''//''||')
	  into l_src_tbl_name, l_trg_tbl_name, l_clmn_id, l_schema, l_clmn_id_vals
	  from meta_info.dq_ldp
	where id = p_id 
	  and is_enable_d = 1; 
	 
 
	-- добавляем новую запись в таблицу и возвращаем последний сформированный id
	insert into meta_info.dq_ldp_protocol (trg_tbl_name, check_type, date_start, status) 
	values (l_trg_tbl_name, 'DELETE', current_timestamp,'RUNNING') returning id into l_id;


	-- выполняем запрос на поиск удаленных записей
	begin 
		 execute 'insert into meta_info.dq_ldp_protocol_detail(protocol_id, loss_id, crt_dttm)
    	select ' || l_id ||', '||l_clmn_id_vals||', current_timestamp from (select ' || l_clmn_id || ' from '|| l_schema ||'.' ||l_src_tbl_name || 
    	' except select ' || l_clmn_id || ' from gl.' || l_trg_tbl_name||') t' ;
	end;
	-- кладем в переменную количество добавленных строк за выполнение процедуры
	get diagnostics l_cnt = ROW_COUNT;

	-- обновляем таблицу протокола 
	update meta_info.dq_ldp_protocol 
	   set date_end = current_timestamp, status = 'PASSED', loss_cnt = l_cnt
	where id = l_id;

	-- обновляем таблицу dq_ldp
	update meta_info.dq_ldp 
	  set  status_d = 'PASSED', loss_qnt_d = l_cnt, message_d = l_message, check_d_dttm = current_timestamp
	where id = p_id;

	-- логирование
	perform meta_info.f_log('f_dq_ldp','PASSED',l_message);

return l_message;

-- обработчик ошибок
exception when
	  others then
		   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
		   -- обновляем таблицу dq_ldp
		   update meta_info.dq_ldp 
		     set  status_d = 'FAIL', loss_qnt_d = l_cnt, message_d = l_err_text, check_d_dttm = current_timestamp
		   where id = p_id;
		  
		   l_message := 'Analyze failed';
		  
		   	-- логирование
		   perform meta_info.f_log('f_dq_ldp','FAILED',l_err_text);
		  
		   return l_message;
	
end;









$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_dq_ldp(int4) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_dq_ldp(int4) TO public;
GRANT ALL ON FUNCTION meta_info.f_dq_ldp(int4) TO drp;
