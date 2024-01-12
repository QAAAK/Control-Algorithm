-- DROP FUNCTION meta_info.f_ee_gl_add_parts(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_add_parts(p_a_id numeric)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	


/* f_ee_gl_add_parts - Вспомогательная функция, которая добавляет партицию в таблицу 
 					   если данные не входят в диапазон партиций.
  		   
   параметры функции:
   					p_a_id - id таблицы в meta_info.ee_gl_md
   			
   возвращаемое значение: результат выполнения функции 
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru и Кулагин В.Н. KulaginVN@intech.rshb.ru

   Дата создания: 05.11.2023
*/	
	
		
declare     
     cur refcursor; -- курсор
     l_s_dt date; -- дата начала партиции
     l_e_dt date; -- дата окончания партиции
     l_sql text; -- exec запрос
     l_a_part_col text;  -- поле, по которому производится партицирование
     l_a_loadtype numeric;  -- тип загрузки
     l_a_tablename_src text; -- таблица источник
     l_a_tablename_trg text; -- целевая таблица
     l_count int; -- переменная количества партиций
     
begin
	--логирование
	perform meta_info.f_log('f_ee_gl_add_parts','RUNNING','аргументы функции - '|| p_a_id);
	
	-- получаем значения переменных на основе аргумента функции
	select load_type, src_tbl_name, trg_tbl_name , coalesce(part_key_col, '')
	  into l_a_loadtype, l_a_tablename_src,l_a_tablename_trg, l_a_part_col
	  from  meta_info.ee_gl_md
	where 1=1
	  and id = p_a_id;

	-- открываем курсор
    open cur for execute 'select date_trunc(''month'',' || l_a_part_col || ') from ' || 'stg.' || lower(l_a_tablename_src);
   
   -- блок кода для добавления партиций 
	loop
	    fetch cur into l_s_dt; 	    
	    exit when not found;
	    l_e_dt := l_s_dt + interval '1' month;
	   
	    begin
		    
		    -- получаем количество партиций в заданном диапазоне
		    select count(*) 
			  into l_count 
			  from pg_catalog.pg_partitions 
			where partitionrangestart like '%' || l_s_dt || '%'  
			  and  partitionrangeend like '%' || l_e_dt || '%'
			  and  schemaname = 'gl'
			  and tablename = l_a_tablename_trg;
			 
			--проверка условия с последующим выполнением операции для добавления новой партиции
			if l_count = 0 
			then
		    	l_sql :=  'alter table gl.'||l_a_tablename_trg||' add partition start (timestamp '''||l_s_dt::text ||''') inclusive end (timestamp '''||l_e_dt::text ||''') exclusive';
		        execute l_sql;
		        -- логирование 
		        perform meta_info.f_log('f_ee_gl_add_parts','PASSED','SQL QUERY - '|| l_sql);
		        exit;
		    end if;
		
		-- обработка исключений
	    exception 
	        when others then
	        	--логирование
	        	perform meta_info.f_log('f_ee_gl_add_parts','FAIL','SQL QUERY - '|| l_sql);
	    		raise notice 'Партиция уже существует, оператор не выполнен: %', l_sql;
	    	exit;
	    
	    end;
	end loop;
   return '0';
end;





$$
EXECUTE ON ANY;
