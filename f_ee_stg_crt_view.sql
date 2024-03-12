-- DROP FUNCTION meta_info.f_ee_stg_crt_view(int2);

CREATE OR REPLACE FUNCTION meta_info.f_ee_stg_crt_view(p_force int2)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	 	
	
 /* 
   f_ee_stg_crt_view - Функция, создающая view на основе метаданных таблицы ee_stg_md
  		   
   параметры : 
   				p_force - служебный параметр для отладки
   			
   возвращаемое значение: результат выполнения функции 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 29.02.2024
*/	
			
	



declare 

	l_tbl_name text; -- имя таблицы
	l_err_text text; -- текст ошибки
	cur refcursor; -- курсор
	l_message text; -- возвращаемое значение
	l_column_name text; -- имена полей 
	
begin
	-- логирование
	perform meta_info.f_log('f_ee_stg_crt_view', 'RUNNUNG', 'none');
	-- получаем из курсора имена таблиц
	open cur for execute 'select stg_tbl_name from meta_info.ee_stg_md';
				
	loop 
		fetch cur into l_tbl_name;
		exit when not found;
		
		begin 
			-- получаем имена полей для создания view
			select string_agg(column_name || ' as ' || replace(column_name, '$','_'), ','  order by ordinal_position)  from information_schema.columns
			into l_column_name
			where table_schema = 'stg' and table_name = l_tbl_name;
		
		
			-- блок кода с указанием типа операции над вью (1 - drop, иначе - create)
			if p_force is not null and p_force = 1 
				then 
					execute 'drop view if exists stg.v_'|| replace(l_tbl_name, '$','_');
			else 
					execute 'create or replace view  stg.v_' || replace(l_tbl_name, '$','_') ||' as select '|| l_column_name ||' from stg.'||l_tbl_name;
			end if;
		 end;	
	 end loop;
	
	l_message := 'PASSED';
	-- логирование
	perform meta_info.f_log('f_ee_stg_crt_view', l_message, 'Operation completed');

return l_message;

-- обработчик ошибок 
exception 
   when others then
   l_message := 'FAIL';
   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;
  -- логирование
   perform meta_info.f_log('f_ee_stg_crt_view',l_message, l_err_text);
   
   return l_message;
  
end;

	
	







 
$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_stg_crt_view(int2) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ee_stg_crt_view(int2) TO drp;
