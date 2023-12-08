-- DROP FUNCTION meta_info.f_ecm_set_tasks();

CREATE OR REPLACE FUNCTION meta_info.f_ecm_set_tasks()
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
declare
	l_parent_id int;
begin
	delete from meta_info.ecm_task where process_type = 'STG_TO_GL';
	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
		status,	message, is_enable,	last_dttm)
	SELECT 'DRP','STG_TO_GL','EE_GL_MD',id,'select meta_info.f_ee_gl_replicate('''||id||''')' exec_path, 1, '', 1, clock_timestamp()
	FROM meta_info.ee_gl_md
	where is_enable = 1  ;
	
	insert into meta_info.ecm_task (system_code, process_type,	md_table_name, md_id, task_code,
		status,	message, is_enable,	last_dttm)
	SELECT 'DRP','SRC_TO_STG','<NONE>',0,'<NONE>', 5, '', 0, clock_timestamp() 
	where
	not exists (select 1 from meta_info.ecm_task where process_type = 'SRC_TO_STG');
	
	truncate table  meta_info.ecm_task_link;
    select max(id) into l_parent_id  from meta_info.ecm_task where process_type = 'SRC_TO_STG';
	insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, null,5  from meta_info.ecm_task where process_type = 'SRC_TO_STG';
	
	insert into meta_info.ecm_task_link (task_id, parent_id,is_enable)
	select id, l_parent_id,1  
	from meta_info.ecm_task where process_type = 'STG_TO_GL';
    return 'SUCCESSFUL';
exception when others then
	return 'FAIL';
END;


$$
EXECUTE ON ANY;
