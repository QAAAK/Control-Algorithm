-- DROP FUNCTION meta_info.f_ecm_set_tasks();

CREATE OR REPLACE FUNCTION meta_info.f_ecm_set_tasks()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
declare
	l_parent_id int;
	l_err_text text;
begin
	
	delete from meta_info.ecm_task where process_type = 'INI_PARAM';
	
	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
	status,	message, is_enable,	last_dttm)
	SELECT 'DRP','INI_PARAM','<NONE>',0,'select meta_info.f_ini()', 5, '', 0, clock_timestamp();


	delete from meta_info.ecm_task where process_type in ('DLK_TO_STG', 'CDWH_TO_STG');
	insert into meta_info.ecm_task (system_code, process_type, md_table_name, md_id, 
	task_code, status, message, is_enable, last_dttm)
	select 
	rss_code, rss_code || '_TO_STG', 'EE_STG_MD', id, task_code, 
	case coalesce(last_load_status, 'READY')
		when 'SUCCESSFUL' then 5
		when 'FAIL' then -1
		when 'READY' then 1
	end, '', 1, clock_timestamp()
	from meta_info.ee_stg_md
	where rss_code in ('CDWH', 'DLK');

	delete from meta_info.ecm_task where process_type = 'STG_TO_GL';
	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
		status,	message, is_enable,	last_dttm)
	SELECT 'DRP','STG_TO_GL','EE_GL_MD',id,'select meta_info.f_ee_gl_replicate('||id||')' exec_path, 
	case coalesce(last_load_status, 'READY')
		when 'SUCCESSFUL' then 5
		when 'FAIL' then -1
		when 'READY' then 1
	end, '', 1, clock_timestamp()
	FROM meta_info.ee_gl_md
	where is_enable = 1  ;



	truncate table  meta_info.ecm_task_link;

    insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, null,5  from meta_info.ecm_task where process_type = 'INI_PARAM';

    select max(id) into l_parent_id  from meta_info.ecm_task where process_type = 'INI_PARAM';
	
	insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, l_parent_id, 1  
	from meta_info.ecm_task where process_type in ('DLK_TO_STG', 'CDWH_TO_STG');


	insert into meta_info.ecm_task_link (task_id, parent_id, is_enable)
	select 
	tg.id,
	ts.id,
	1
	from meta_info.ee_gl_md gl
	inner join meta_info.ecm_task tg on gl.id=tg.md_id and tg.md_table_name = 'EE_GL_MD' 
	inner join meta_info.ee_stg_md stg on gl.src_tbl_name=stg.stg_tbl_name
	inner join meta_info.ecm_task ts on stg.id=ts.md_id and ts.md_table_name = 'EE_STG_MD';
	
	perform meta_info.f_log('f_ecm_set_tasks','SUCCESFUL','Операция выполнена');
	
    return 'Операция завершена';
   
   
    exception when others then
		get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;
					   
	    perform meta_info.f_log('f_ecm_set_tasks','FAIL',l_err_text);
	    			
	    return 'Операция выполнена с ошибкой';
END;


	



$$
EXECUTE ON ANY;
