-- DROP FUNCTION meta_info.f_truncate_table(text);

CREATE OR REPLACE FUNCTION meta_info.f_truncate_table(p_tbl_name text)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	
/* f_truncate_table - вспомогательная функция очистки таблицы
  		   
   параметры функции:
   			p_tbl_name - имя таблицы
   
   возвращаемое значение: void 
      
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 05.12.2023
*/	
			
declare	
	
begin
	
	-- очищаем таблицу
	execute 'truncate ' || p_tbl_name || ';' ;
	--логирование
	perform meta_info.f_log('f_truncate_table','PASSED','truncate '|| p_tbl_name);

end;









$$
EXECUTE ON ANY;
