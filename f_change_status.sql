-- DROP FUNCTION meta_info.f_change_status(numeric, numeric, numeric, text);

CREATE OR REPLACE FUNCTION meta_info.f_change_status(p_id numeric, p_status numeric, p_load_cnt numeric, p_message text DEFAULT NULL::text)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	


declare 


l_md_id numeric; -- ee_stg_md.id
l_err_text text; -- текст ошибки
l_status text; -- change status


begin
	
	select md_id 
	into l_md_id
	from meta_info.ecm_task
	where 1=1
	and id = p_id
	and md_table_name = 'EE_STG_MD'
	limit 1;

	begin

	if l_md_id is not null
		then 
		    case
			    when p_status = 1 then l_status := 'READY';
			    when p_status = -1 then l_status := 'FAIL';
			    when p_status = 5 then l_status := 'SUCCESFUL';
			    else l_status := 'NOT DEFINED';
			end case;
		
		
			update meta_info.ee_stg_md set last_load_status = l_status, last_load_cnt = p_load_cnt, message_text = p_message, last_load_dttm = current_timestamp 
			where id = l_md_id;
	
		
	else 
		return 'Нет таблицы с таким id';
	
	end if;


	exception when others then
	
	    get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;
	   
	    perform meta_info.f_log('f_change_status','FAIL',l_err_text); 
	   
	    return 'Операция не выполнена';
 	
    end;
   
   
    perform meta_info.f_log('f_change_status','SUCCESFUL','Операция выполнена');
   
    return 'Операция выполнена';
end;
	






$$
EXECUTE ON ANY;
