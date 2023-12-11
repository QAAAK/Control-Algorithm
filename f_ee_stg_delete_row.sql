-- DROP FUNCTION meta_info.f_ee_stg_delete_row(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_stg_delete_row(p_a_id numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	

declare

l_name_table_trg text;
l_name_table_src text;
l_err_text text;
sql_query text;
l_key_cols text;

begin
	
	select trg_tbl_name, src_tbl_name, src_key_cols
	into l_name_table_trg, l_name_table_src, l_key_cols
	from meta_info.ee_gl_md egm
	where id = p_a_id;
	
	begin
	
		
	if l_key_cols != '' or l_key_cols != null
		then
			if ',' ~ l_key_cols
				then 
					sql_query := 'delete from gl.'|| l_name_table_trg || ' where ('|| l_key_cols || ') 
					in  (select ' || l_key_cols || ' from stg.' ||l_name_table_src || ' where w$optype = 1)';
			else
					sql_query:= 'delete from gl.'|| l_name_table_trg || ' where '|| l_key_cols || ' 
					in  (select ' || l_key_cols || ' from stg.' ||l_name_table_src || ' where w$optype = 1)';
			execute sql_query;
			
			end if;
	else
		raise notice 'Нет ключа по которому удалить поле';
	
	end if;


	exception when others then 
    	get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;
    	raise notice 'context: >>%<<', l_err_text; 

	end;

END;



$$
EXECUTE ON ANY;
