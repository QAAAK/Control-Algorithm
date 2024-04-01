CREATE OR REPLACE FUNCTION meta_info.f_gl_to_sbx(p_a_id numeric)
	RETURNS int4
	LANGUAGE plpgsql
	VOLATILE
AS $function$ 	 	 	 	 	 	
	
	
			
	
declare 
     
	l_tbl_name text;
	l_cols text;
    
begin
	
	
	select trg_tbl_name, src_cols
	into l_tbl_name, l_cols
	from meta_info.ee_gl_md
	where id = p_a_id;
	
	
	
	execute 'insert into ' || 'sbx$dbd' || '.' || l_tbl_name || '(' || l_cols || ')' || chr(10) ||
            '(select ' || l_cols || chr(10) || 'from ' ||
            'gl.' || l_tbl_name || ');';
	
	
	
	return 1;
	
end;


