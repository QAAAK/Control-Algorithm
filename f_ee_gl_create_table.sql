-- DROP FUNCTION meta_info.f_ee_gl_create_table(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_create_table(p_id numeric)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	

DECLARE
  
  arr text[]; -- массив значений
  --arr_key text[]; -- массив ключей таблицы
  result_string text := ''; -- строка результирующая
  name_data_type text; -- переменная для преобразования типов данных
  x text; -- переменная для цикла
  l_a_trg_cols text; -- поля таблицы target
  l_a_name_tbl_trg text; -- имя таблицы target
  l_a_Stmt text;  -- скрипт 
  l_a_distr_col text; -- поле дистрибуции 
  l_a_tbl_param text; -- параметры создания таблицы
  --l_a_name_tbl_src text; -- имя таблицы src
  --l_a_mindate timestamp; -- минимальная дата (для создания первой партиции)
  l_a_part_col text; -- поле партиции
  l_a_src_key_col text; --  ключевое поле таблицы
 
  
begin
  select trg_tbl_name, trg_cols, distr_col, tbl_param, part_key_col, src_key_cols
  into l_a_name_tbl_trg,l_a_trg_cols, l_a_distr_col, l_a_tbl_param, l_a_part_col, l_a_src_key_col
  from meta_info.ee_gl_md
  where id = p_id;
 
 
  arr := string_to_array(l_a_trg_cols, ',');
  --arr_key := string_to_array(l_a_src_key_col, ',');
 
  FOREACH x IN ARRAY arr loop
	  -- извлекаем атрибут с типом данных, и преобразовываем его 
	  name_data_type := substring(x, '\[(.*?)\]');
	  case 
		   when name_data_type ~ 'N' then name_data_type := replace(name_data_type, 'N', 'numeric');
	  	   when name_data_type ~ 'D' then name_data_type := replace(name_data_type, 'D', 'date');
	  	   when name_data_type ~ 'T' then name_data_type := replace(name_data_type, 'T', 'timestamp');
	  	   when name_data_type ~ 'I' then name_data_type := replace(name_data_type, 'I', 'integer');
	  	   when name_data_type ~ 'V' then name_data_type := replace(name_data_type, 'V', 'varchar');
	  	   else name_data_type := 'varchar(512)';
	  end case;
	  -- проверяем, есть ли атрибут в поле ключевых полей таблицы
	  if  l_a_src_key_col ~ split_part(x ,'[', 1) = true
	  	then
	  	result_string := result_string || split_part(x ,'[', 1) || ' ' || name_data_type || ' not null, ' || chr(10);
	  else
	  	result_string := result_string || split_part(x ,'[', 1) || ' ' || name_data_type || ' null, ' || chr(10);
	  end if;
	  	
  END LOOP;
 	  result_string := rtrim(result_string, ', ' || chr(10));
	  -- создаем скрипт создания таблицы
 	 
 	  -- со служебными полями
 	  -- l_a_Stmt := 'create table if not exists gl.'||l_a_name_tbl_trg || ' (' || result_string || 'w$loadid text not null, w$ldate timestamp)' || chr(10);
 	  l_a_Stmt := 'create table if not exists gl.'||l_a_name_tbl_trg || ' (' || rtrim(result_string, ',') || ')' || chr(10);
 	  
 	 --создаем параметры таблицы
 	 if l_a_tbl_param != ''
 	 then 
 	 	l_a_Stmt := l_a_Stmt || 'with (' || l_a_tbl_param || ') ' || chr(10);
 	 end if;
	
 	-- добавляем дистрибуцию
 	  if l_a_distr_col != ''
 	  then 
 	  	l_a_Stmt := l_a_Stmt || 'distributed by (' || l_a_distr_col || ') ' || chr(10);
 	  else
 	  	l_a_Stmt := l_a_Stmt || 'distributed randomly ' || chr(10);
 	  end if;
 	 
 	 --делаем запрос к таблице в stg для получения минимальной даты
 	  --execute 'select min(' ||l_a_part_col|| ') from stg.'|| l_a_name_tbl_src
 	  --into l_a_mindate;
 	 
 	  -- добавляем партицию
 	   if l_a_part_col != ''
 	   then
 	 	l_a_Stmt := l_a_Stmt || 'partition by range (' ||l_a_part_col|| ') (start (''2021-01-01''::timestamp) inclusive end (''2025-12-31''::timestamp) exclusive every (interval ''1 month''),' ||chr(10);
 	    l_a_Stmt := l_a_Stmt || 'start (''2000-01-01''::timestamp) inclusive end (''2020-12-31''::timestamp) exclusive);' ||chr(10);
 	   end if;
 	   
 	   -- создаем индекс по ключевым полям табилцы
 	   --l_a_Stmt := l_a_Stmt || 'create unique index ' || 'index_' ||  l_a_name_tbl_trg || ' on gl.' || l_a_name_tbl_trg || ' (' || l_a_src_key_col || ')' || chr(10);
 	  

 	  -- выполнить скрипт создания таблицы
 	  -- execute l_a_Stmt;
 	  
return l_a_Stmt;
END;






$$
EXECUTE ON ANY;
