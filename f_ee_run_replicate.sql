-- DROP FUNCTION meta_info.f_ee_run_replicate();

CREATE OR REPLACE FUNCTION meta_info.f_ee_run_replicate()
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
DECLARE     
cur refcursor;
l_id smallint;
l_table_name text;
begin
	open cur for execute 'SELECT id, src_tbl_name from meta_info.ee_gl_md';
	loop
		fetch cur into l_id, l_table_name;
		exit when not found;
		begin
		
		perform meta_info.f_ee_gl_replicate(l_id);
		
		exception when others then
			raise notice 'Операция над таблицей % завершилась с ошибкой', l_table_name;
		end;
		
	end loop;

return 'Процесс завершен';
END;


$$
EXECUTE ON ANY;
