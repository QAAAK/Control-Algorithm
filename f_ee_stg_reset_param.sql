-- DROP FUNCTION meta_info.f_ee_reset_stg_param(numeric, text, text);

CREATE OR REPLACE FUNCTION meta_info.f_ee_reset_stg_param(p_id numeric DEFAULT NULL::numeric, p_date_from text DEFAULT NULL::text, p_date_to text DEFAULT NULL::text)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$

	/* f_truncate_table - функция, сдвигающая дату загрузки в таблице meta_info.ee_stg_md 
	  					  по умолчанию на один день, есть возможность отладки
	  					  
	  					 
	   параметры функции:
	   			p_id - Идентификатор таблицы 
	   			p_date_from - количество дней свига prm_date_from
	   			p_date_to - количество дней сдвига prm_date_to
	   
	   возвращаемое значение: void 
	      
	   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
	   Дата создания: 07.02.2024
*/	
	

declare 

	l_date_from text := concat(coalesce (p_date_from, '1'),' day'); -- дата с 
	l_date_to text := concat(coalesce (p_date_to, '1'),' day'); -- дата после
	l_err_text text; -- текст ошибки
	l_message text := 'PASSED'; -- возвращаемое значение


begin
	-- логирование
	perform meta_info.f_log('f_reset_stg_param', 'RUNNING', 'Operation completed');
	-- блок кода, обновляющий таблицу по заданному условию
	begin 
		if p_id is not null 
			then 
				execute 'update meta_info.ee_stg_md
				set prm_date_from = prm_date_from + interval '''|| l_date_from || ''',
					prm_date_to = prm_date_to + interval ''' || l_date_to || '''
				where last_load_status = ''READY''
				and prm_date_from < current_date and prm_date_to < current_date
				and id = ' || p_id;
			
		else  
				execute 'update meta_info.ee_stg_md
				set prm_date_from = prm_date_from + interval ''' || l_date_from|| ''',
					prm_date_to = prm_date_to + interval ''' || l_date_to || '''
				where last_load_status = ''READY''
				    and prm_date_from < current_date and prm_date_to < current_date';
				
		
		end if;

		-- обработчик ошибок
		exception when 
			others then
				   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	   
				  
				   l_message := 'FAIL';
				   -- логирование
		    	   perform meta_info.f_log('f_ecm_ini_zen',l_message,l_err_text);
							
		    	   return l_message;
		  end;
		 
-- логирование
perform meta_info.f_log('f_reset_stg_param', l_message, 'Operation completed');

return l_message;

end;




$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_reset_stg_param(numeric, text, text) OWNER TO drp;
GRANT ALL ON FUNCTION meta_info.f_ee_reset_stg_param(numeric, text, text) TO drp;
