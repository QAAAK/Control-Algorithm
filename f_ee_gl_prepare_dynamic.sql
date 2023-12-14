-- DROP FUNCTION meta_info.f_ee_gl_prepare_dynamic(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_prepare_dynamic(p_a_id numeric)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
	
	

DECLARE
     l_a_part_col text;  
     l_a_pk_key text;
     l_src_cols text; -- ПОКА ИСПОЛЬЗУЮТСЯ ПОЛЯ ТАБЛИЦЫ-ИСТОЧНИКА, В ПОСЛЕДСТВИИ БУДЕТ ИСПОЛЬЗОВАТЬСЯ ПЕРЕМЕННАЯ l_trg_cols
     l_trg_cols text; 
     l_a_Stmt text; -- СТАРТ ДЛЯ ОТЛАДКИ КОДА
     l_a_cnt int;
     l_a_loadtype numeric;  -- ТИП ЗАГРУЗКИ
     l_a_tablename_src text; -- ТАБЛИЦА ИСТОЧНИК
     l_a_tablename_trg text; -- ЦЕЛЕВАЯ ТАБЛИЦА
     l_ret text;
begin
	select load_type, src_tbl_name, trg_tbl_name, part_key_col, src_key_cols, src_cols, trg_cols
	INTO l_a_loadtype, l_a_tablename_src,l_a_tablename_trg, l_a_part_col, l_a_pk_key, l_src_cols, l_trg_cols
	from  meta_info.ee_gl_md
	where 1=1
	and id = p_a_id;
 
     EXECUTE 'SELECT count(*) FROM ' || 'stg.' || lower(l_a_tablename_src) || ' LIMIT 1'
      into strict l_a_cnt;    
    IF l_a_cnt > 0
    THEN
       IF l_a_pk_key = '' AND l_a_loadtype = 2
       then          
          RAISE EXCEPTION 'У таблицы % не задан уникальный ключ для строк, добавление не возможно!', 'gl' || '.' || lower(l_a_tablename_trg);
    END IF;
       
       if l_a_part_col != '' 
       then
          --Создать новые партиции если необходимо
       	  l_ret := meta_info.f_ee_gl_add_parts(p_a_id);
       end if;

      
       IF l_a_loadtype = 1
          THEN
            -- Очистим основную таблицу
            l_a_Stmt := 'truncate table ' || 'gl' || '.' || lower(l_a_tablename_trg) || ';' || chr(10) ||
            -- Перенесём данные из STG в основную таблицу
                   'insert into ' || 'gl' || '.' || l_a_tablename_trg || '(' || l_src_cols || ')' || chr(10) ||
                   '(select ' || l_src_cols || chr(10) || 'from ' ||
                   'stg.' || l_a_tablename_src || ');';
                 
       ELSIF l_a_loadtype = 2 -- 
          then      
			l_a_Stmt := 'delete from gl.'||l_a_tablename_trg||' where '||l_a_pk_key||' IN (select '||l_a_pk_key||' from stg.'||l_a_tablename_src||');'
		    ||chr(10)||'insert into gl.'||l_a_tablename_trg|| ' (' || l_src_cols || ') select ' || l_src_cols || ' from stg.'||l_a_tablename_src||';';
		   
       elsif l_a_loadtype = 4
       	  then 
       	  			l_a_Stmt := 'delete from gl.'||l_a_tablename_trg||' where '||l_a_pk_key||' IN (select '||l_a_pk_key||' from stg.'||l_a_tablename_src||');'
		    		||chr(10)||'insert into gl.'||l_a_tablename_trg|| ' (' || l_src_cols || ') select ' || l_src_cols || ' from stg.'||l_a_tablename_src||' 
					 where w$optype = 0;';
					--perform f_ee_gl_delete_row(p_a_id);
       	    
       END IF;       
    ELSE   
    	l_a_Stmt := '0';
    END IF;
   return l_a_Stmt;
END;







$$
EXECUTE ON ANY;
