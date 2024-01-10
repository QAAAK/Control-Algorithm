-- DROP FUNCTION meta_info.f_ee_gl_replicate(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_replicate(p_a_id numeric)
	RETURNS int4
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	

DECLARE
      l_a_PartCol text;
     --l_only_tgt_tbl integer;
      l_a_StartDt timestamp;
      --l_a_FinihDt timestamp;
      l_a_Cnt int := 0;
      --l_a_PrmString text;
      l_a_tablename_trg text;
      l_a_tablename_src text;
      l_a_loadtype numeric;
      l_sql_text text;
      l_err_text text;
    
begin
	
    SELECT load_type, trg_tbl_name, src_tbl_name
      INTO l_a_loadtype, l_a_tablename_trg, l_a_tablename_src
      FROM meta_info.ee_gl_md
     WHERE id=p_a_id;
    
    begin
   		l_a_StartDt := clock_timestamp();
    	UPDATE meta_info.ee_gl_md
       	 SET last_load_dttm = l_a_StartDt, last_load_status = 'READY', last_load_cnt = 0
	 	WHERE id=p_a_id;
    end;
   
	l_sql_text := meta_info.f_ee_gl_prepare_dynamic(p_a_id);


    if l_sql_text != '0' then
		execute l_sql_text;	
	
	    GET DIAGNOSTICS l_a_Cnt := ROW_COUNT; 
	    --Очистить таблицу stg
		perform  meta_info.f_truncate_table('stg.'||l_a_tablename_src);	    
    end if;  
    --l_a_FinihDt := clock_timestamp();
   
  
    INSERT INTO meta_info.tbl_load_log(load_type, src_tbl_name, trg_tbl_name, last_load_dttm, last_load_status, last_load_cnt, sql_query)
         VALUES (l_a_loadtype, l_a_tablename_src, l_a_tablename_trg, l_a_StartDt, 'SUCCESSFUL', l_a_Cnt, l_sql_text);
    UPDATE meta_info.ee_gl_md
       	 SET last_load_dttm = l_a_StartDt, last_load_status = 'SUCCESSFUL', last_load_cnt = l_a_Cnt
	 WHERE id=p_a_id;
	
	perform meta_info.f_log('f_ee_gl_replicate','SUCCESFUL','Операция выполнена');
	return l_a_Cnt;


exception when others then null;
    get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;
    raise notice 'context: >>%<<', l_err_text; 
   
    INSERT INTO meta_info.tbl_load_log(load_type, src_tbl_name, trg_tbl_name, last_load_dttm, last_load_status, last_load_cnt, sql_query, message_text)
         VALUES (l_a_loadtype, l_a_tablename_src, l_a_tablename_trg, l_a_StartDt, 'FAIL', l_a_Cnt, l_sql_text, l_err_text);
    UPDATE meta_info.ee_gl_md
       	 SET last_load_dttm = l_a_StartDt, last_load_status = 'FAIL', last_load_cnt = l_a_Cnt, message_text = l_err_text
	 WHERE id=p_a_id;
	
	perform meta_info.f_log('f_ee_gl_replicate','FAIL', l_err_text);
	return -1;
raise;
END;







$$
EXECUTE ON ANY;
