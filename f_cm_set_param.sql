-- DROP FUNCTION meta_info.f_cm_set_param(varchar, varchar);

CREATE OR REPLACE FUNCTION meta_info.f_cm_set_param(p_param_name varchar, p_param_value varchar)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
/* f_сm_set_param - функция, обновляющая параметры в таблице meta_info.cm_prm_md
  		   
   параметры функции:
   			p_param_name - имя параметра
   			p_param_value - значение параметра
   
   возвращаемое значение: результат о выполнении
      
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru и Кулагин В.Н. KulaginVN@intech.rshb.ru
   Дата создания: 06.11.2023
*/	

	
DECLARE     
     l_qnt int2; -- количество строк
     l_res varchar(200) := 'Устанволено значение: '||p_param_value||', параметра: '||p_param_name; -- строка со значениями
     l_err_text text; -- текст ошибки
     
begin
   -- логирование	
   perform meta_info.f_log('f_cm_set_param','RUNNING', l_res);

   -- обновление записей
   update meta_info.cm_prm_md set param_value = p_param_value
   where param_name = p_param_name;
  
   -- количество записей 
   GET DIAGNOSTICS l_qnt = ROW_COUNT;
  
   -- условие
   if l_qnt = 0 
     then
   	   l_res := 'Параметр: '||p_param_name||' не найден';
       perform meta_info.f_log('f_cm_set_param','COMPLETED EARLIER THAN EXPECTED', l_res);
   end if;
  
-- обработка исключений
exception 
	when others then
	
	l_res := 'FAIL';
	get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
	-- логирование
    perform meta_info.f_log('f_cm_set_param','FAIL', l_err_text);
   
    return l_res;

-- логирование
perform meta_info.f_log('f_cm_set_param','SUCCESFUL', 'Operation completed');

return l_res;
END;







$$
EXECUTE ON ANY;
