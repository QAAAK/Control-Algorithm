-- DROP FUNCTION meta_info.f_cm_set_param(varchar, varchar);

CREATE OR REPLACE FUNCTION meta_info.f_cm_set_param(p_param_name varchar, p_param_value varchar)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
DECLARE     
     l_qnt int2;
     l_res varchar(200) := 'Устанволено значение: '||p_param_value||', параметра: '||p_param_name;
begin
   update meta_info.cm_prm_md set param_value = p_param_value
   where param_name = p_param_name;
   GET DIAGNOSTICS l_qnt = ROW_COUNT;
  
   if l_qnt = 0 then
   	l_res := 'Параметр: '||p_param_name||' не найден';
   end if;
  
   return l_res;
END;

$$
EXECUTE ON ANY;
