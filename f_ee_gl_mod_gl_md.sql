-- DROP FUNCTION meta_info.f_ee_gl_mod_gl_md(meta_info.ee_gl_md);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_mod_gl_md(p_gl_md_row meta_info.ee_gl_md)
	RETURNS int2
	LANGUAGE plpgsql
	VOLATILE
AS $$
	


declare

	l_err_text text; -- текст ошибки

begin 
	-- логирование
	perform meta_info.f_log('f_ee_gl_mod_gl_md', 'RUNNING', p_gl_md_row);
	-- обновление полей на основе агрумента функции
	update meta_info.ee_gl_md 
	  set load_type = p_gl_md_row.load_type, src_tbl_name = p_gl_md_row.src_tbl_name,
	      src_cols = p_gl_md_row.src_cols, src_key_cols = p_gl_md_row.src_key_cols,
	      trg_tbl_name = p_gl_md_row.trg_tbl_name, trg_cols = p_gl_md_row.trg_cols,
	      part_key_col = p_gl_md_row.part_key_col, distr_col = p_gl_md_row.distr_col,
	      tbl_param = p_gl_md_row.tbl_param, is_enable = p_gl_md_row.is_enable, 
	      part_type = p_gl_md_row.part_type
	where id = p_gl_md_row.id;
	-- логирование
	perform meta_info.f_log('f_ee_gl_mod_gl_md', 'PASSED', 'Operation completed');

-- обработчик ошибок
exception 
   when others then 
   
   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
   --логирование
   perform meta_info.f_log('f_ee_gl_mod_gl_md', 'FAIL', l_err_text);
  
   return 0;
	
end;





$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_gl_mod_gl_md(meta_info.ee_gl_md) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_mod_gl_md(meta_info.ee_gl_md) TO drp;
