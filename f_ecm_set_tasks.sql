-- DROP FUNCTION meta_info.f_ecm_set_tasks();

CREATE OR REPLACE FUNCTION meta_info.f_ecm_set_tasks()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	
/* f_ecm_set_tasks - Вспомогательная функция, которая добавляет записи о ходе выполнения функций в таблицу meta_info.log_func,
  					 а также обновляется таблицу ecm_tass
  		   
   У функции нет входящих параметров
   			
   возвращаемое значение: результат выполнения функции 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 27.12.2023
*/	
			
declare
	l_parent_id int; -- id родительской таблицы
	l_err_text text; -- текст ошибки
	l_message text;  -- переменная, содержащая возвращаемое значение

begin
	-- логирование
	perform meta_info.f_log('f_ecm_set_tasks','RUNNING','none');

	-- удаление записей по условию с последующим добавлением в таблицу meta_info.ecm_task
	delete from meta_info.ecm_task where process_type = 'INI_PARAM';
	
	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
	status,	message, is_enable,	last_dttm)
	SELECT 'DRP','INI_PARAM','<NONE>',0,'select meta_info.f_ini()', 5, '', 0, clock_timestamp();

	-- удаление записей по условию с последующим добавлением в таблицу meta_info.ecm_task
	delete from meta_info.ecm_task where process_type in ('DLK_TO_STG', 'CDWH_TO_STG');

	insert into meta_info.ecm_task (system_code, process_type, md_table_name, md_id, 
	task_code, status, message, is_enable, last_dttm, task_type)
	select 
	rss_code, rss_code || '_TO_STG', 'EE_STG_MD', id, task_code, 
	case last_load_status
		when 'SUCCESSFUL' then 5
		when 'FAIL' then -1
		when 'READY' then 1
		else 1
	end, '', 1, clock_timestamp(),
	case 
		when rss_code = 'CDWH' then 'IPC'
	    when rss_code = 'DLK' then 'DEI'
    end
	  from meta_info.ee_stg_md
	where rss_code in ('CDWH', 'DLK');

	-- удаление записей по условию с последующим добавлением в таблицу meta_info.ecm_task
	delete from meta_info.ecm_task where process_type = 'STG_TO_GL';

	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
		status,	message, is_enable,	last_dttm, task_type)
	select 'DRP','STG_TO_GL','EE_GL_MD',id,'select meta_info.f_ee_gl_replicate('||id||')' exec_path, 
	case coalesce(last_load_status, 'READY')
		when 'SUCCESSFUL' then 5
		when 'FAIL' then -1
		when 'READY' then 1
	end, '', 1, clock_timestamp(),'SQL'
	  from meta_info.ee_gl_md
	where is_enable = 1  ;

	-- очистка таблицы 
	truncate table  meta_info.ecm_task_link;

	-- добавление новых записей-связей в таблицу meta_info.ecm_task_link
    insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, null,5  
       from meta_info.ecm_task 
    where process_type = 'INI_PARAM';

   -- получение родительского id
    select max(id) 
   	  into l_parent_id  
   	  from meta_info.ecm_task 
   	where process_type = 'INI_PARAM';
   
	-- добавление новых записей-связей в таблицу meta_info.ecm_task_link
	insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, l_parent_id, 1  
	  from meta_info.ecm_task where process_type in ('DLK_TO_STG', 'CDWH_TO_STG');

	insert into meta_info.ecm_task_link (task_id, parent_id, is_enable)
	select tg.id,ts.id, 1
	  from meta_info.ee_gl_md gl
	inner join meta_info.ecm_task tg on gl.id=tg.md_id and tg.md_table_name = 'EE_GL_MD' 
	inner join meta_info.ee_stg_md stg on gl.src_tbl_name=stg.stg_tbl_name
	inner join meta_info.ecm_task ts on stg.id=ts.md_id and ts.md_table_name = 'EE_STG_MD';
	
	l_message := 'PASSED';
	-- логирование
	perform meta_info.f_log('f_ecm_set_tasks','PASSED','Operation completed');
	
    return l_message;
   
-- обработка исключений     
exception 
   when others then
    	
	  get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;
	  l_message := 'FAIL';	
	  -- логирование
	  perform meta_info.f_log('f_ecm_set_tasks','FAIL',l_err_text);
	     
	  return l_message;
end;











$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ecm_set_tasks() OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ecm_set_tasks() TO public;
GRANT ALL ON FUNCTION meta_info.f_ecm_set_tasks() TO drp;
