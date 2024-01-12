-- DROP FUNCTION meta_info.f_log(text, text, text);

CREATE OR REPLACE FUNCTION meta_info.f_log(p_func_name text, p_status text DEFAULT 'NOT DIFINED'::text, p_detail text DEFAULT 'VOID'::text)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	

/* f_log - Вспомогательная функция, которая добавляет записи о ходе выполнения функций в таблицу meta_info.log_func
  		   
   параметры функции:
   			p_func_name - имя выполняемой функции
   			p_status - статус выполнения функции (по умолчанию NOT DIFINED)
   			p_detail - детали о ходе выполнения функции
   			
   
   возвращаемое значение: void 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru
   Дата создания: 10.01.2024
*/	
	
		
begin
	
	--добавление новой записи в таблицу
	insert into meta_info.log_func (func, status, detail)
	values (p_func_name, p_status, p_detail);

end;







$$
EXECUTE ON ANY;
