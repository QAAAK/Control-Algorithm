-- DROP FUNCTION meta_info.f_ee_stg_mod_stg_md(meta_info.ee_stg_md);

CREATE OR REPLACE FUNCTION meta_info.f_ee_stg_mod_stg_md(p_stg_md_row meta_info.ee_stg_md)
	RETURNS int2
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	


declare

	l_err_text text; -- текст ошибки

begin 
	-- логирование
	perform meta_info.f_log('f_ee_stg_mod_stg_md', 'RUNNING', p_stg_md_row);
	-- обновление полей на основе агрумента функции
	update meta_info.ee_stg_md 
	  set src_tbl_name = p_stg_md_row.src_tbl_name, rss_code = p_stg_md_row.rss_code,
	  	  src_schema_name = p_stg_md_row.src_schema_name, stg_tbl_name = p_stg_md_row.stg_tbl_name,
	  	  task_code = p_stg_md_row.task_code, is_enable = p_stg_md_row.is_enable
	where id = p_stg_md_row.id;
	-- логирование
	perform meta_info.f_log('f_ee_stg_mod_stg_md', 'PASSED', 'Operation completed');

-- обработчик ошибок
exception 
   when others then 
   
   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
   --логирование
   perform meta_info.f_log('f_ee_stg_mod_stg_md', 'FAIL', l_err_text);
  
   return 0;
	
end;






$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_stg_mod_stg_md(meta_info.ee_stg_md) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ee_stg_mod_stg_md(meta_info.ee_stg_md) TO drp;
