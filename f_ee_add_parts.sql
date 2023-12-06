-- DROP FUNCTION meta_info.f_ee_gl_add_parts(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_add_parts(p_a_id numeric)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	
	
		
	
DECLARE     
     cur refcursor;
     l_s_dt date;
     l_e_dt date;
     l_sql text;
     l_a_part_col text;  
     l_a_loadtype numeric;  -- ТИП ЗАГРУЗКИ
     l_a_tablename_src text; -- ТАБЛИЦА ИСТОЧНИК
     l_a_tablename_trg text; -- ЦЕЛЕВАЯ ТАБЛИЦА
     l_count int; -- переменная для количества строк в запросе
BEGIN
	select load_type, src_tbl_name, trg_tbl_name , coalesce(part_key_col, '')
	INTO l_a_loadtype, l_a_tablename_src,l_a_tablename_trg, l_a_part_col
	from  meta_info.ee_gl_md
	where 1=1
	and id = p_a_id;



    OPEN cur FOR EXECUTE 'SELECT date_trunc(''month'',' || l_a_part_col || ') FROM ' || 'stg.' || lower(l_a_tablename_src);
--	        || ' union all select ''2010-01-01''::timestamp union all select ''2023-04-01''::timestamp union all select ''2023-07-01''::timestamp order by dt_end'; --Для отладки
	LOOP
	    FETCH cur INTO l_s_dt; 	    
	    EXIT WHEN NOT FOUND;
	    l_e_dt := l_s_dt + interval '1' month;
	    begin
		    	select count(*) 
				into l_count 
				from pg_catalog.pg_partitions 
			    where partitionrangestart like '%' || l_s_dt || '%'  
			    and  partitionrangeend like '%' || l_e_dt || '%'
			    and  schemaname = 'gl'
			    and tablename = l_a_tablename_trg;
			if l_count = 0 then
		    	l_sql :=  'alter table gl.'||l_a_tablename_trg||' add partition start (timestamp '''||l_s_dt::text ||''') inclusive end (timestamp '''||l_e_dt::text ||''') exclusive';
		        execute l_sql;
		    end if;
		   
		    
	        
	    exception when others then
	        raise notice '%', l_sql;
	    	raise notice 'Партиция уже существует, оператор не выполнен: %', l_sql;
	    end;
	end LOOP;
   return '0';
END;











$$
EXECUTE ON ANY;
