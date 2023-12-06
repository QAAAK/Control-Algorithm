-- DROP FUNCTION meta_info.f_truncate_table(text);

CREATE OR REPLACE FUNCTION meta_info.f_truncate_table(p_tbl_name text)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
begin
	EXECUTE 'truncate ' || p_tbl_name || ';' ;		
end;



$$
EXECUTE ON ANY;
