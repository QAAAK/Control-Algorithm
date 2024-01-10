-- DROP FUNCTION meta_info.f_log(text, text, text);

CREATE OR REPLACE FUNCTION meta_info.f_log(p_func_name text, p_status text DEFAULT 'NOT DIFINED'::text, p_return text DEFAULT 'VOID'::text)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
begin
	insert into meta_info.log_func (func, status, return_value)
	values (p_func_name, p_status, p_return);
end;





$$
EXECUTE ON ANY;
