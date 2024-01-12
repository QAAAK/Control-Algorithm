-- DROP FUNCTION meta_info.f_ee_gl_prepare_dynamic(numeric);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_prepare_dynamic(p_a_id numeric)
	RETURNS text
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	

/* f_ee_gl_prepare_dynamic - функция, которая перекладывает данные из одной в таблицы в другую
 						     на основе типа загрузки в meta_info.ee_gl_md
  		   
   параметры функции:
   					p_a_id - id таблицы в meta_info.ee_gl_md
   			
   возвращаемое значение: результат выполнения функции  
     
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru и Кулагин В.Н. KulaginVN@intech.rshb.ru

   Дата создания: 15.11.2023
*/	
		
	
declare
     l_a_part_col text; -- поле, по которому сделано партицирование
     l_a_pk_key text; -- primary key
     l_src_cols text; -- пока используются поля таблицы-источника, в последствии будет использоваться переменная l_trg_cols
     l_trg_cols text; 
     l_a_Stmt text; -- старт для отладки кода
     l_a_cnt int;   -- количество строк в таблице
     l_a_loadtype numeric;  -- тип загрузки
     l_a_tablename_src text; -- таблица источник
     l_a_tablename_trg text; -- целевая таблица
     l_ret text; -- параменная для вызова функции
     l_message text; -- возвращающая переменная
begin
	-- логирование
	perform meta_info.f_log('f_ee_gl_prepare_dynamic','RUNNING','аргументы функции - {' || p_a_id || '}');
	
	-- получаем в переменные необходимые данные для последующего добавления в таблицу
	select load_type, src_tbl_name, trg_tbl_name, part_key_col, src_key_cols, src_cols, trg_cols
	  into l_a_loadtype, l_a_tablename_src,l_a_tablename_trg, l_a_part_col, l_a_pk_key, l_src_cols, l_trg_cols
	  from  meta_info.ee_gl_md
	where 1=1
	  and id = p_a_id;
	
	 -- запрос с последующей проверкой условия
    execute 'select count(*) from ' || 'stg.' || lower(l_a_tablename_src) || ' limit 1'
    into strict l_a_cnt;
   
    if l_a_cnt > 0
      then
	   if l_a_pk_key = '' and l_a_loadtype = 2
	     then 
	       l_message := 'у таблицы % не задан уникальный ключ для строк, добавление не возможно!';
	       -- логирование
	       perform meta_info.f_log('f_ee_gl_prepare_dynamic','COMPLETED EARLIER THAN EXPECTED', l_message);
	      
	       return l_message;
	   end if;
      
	-- условия создания дополнительной партиции
    if l_a_part_col != '' 
     then
       -- создать новые партиции если необходимо
       l_ret := meta_info.f_ee_gl_add_parts(p_a_id);
    end if;
  
   	 -- блок к кода в котором проверяется условие по какому сценарию происходит перекладка данных
     if l_a_loadtype = 1
      then
            l_a_Stmt := 'truncate table ' || 'gl' || '.' || lower(l_a_tablename_trg) || ';' || chr(10) ||
            'insert into ' || 'gl' || '.' || l_a_tablename_trg || '(' || l_src_cols || ')' || chr(10) ||
            '(select ' || l_src_cols || chr(10) || 'from ' ||
            'stg.' || l_a_tablename_src || ');';
                 
     elsif l_a_loadtype = 2 -- 
      then      
			l_a_Stmt := 'delete from gl.'||l_a_tablename_trg||' where '||l_a_pk_key||' IN (select '||l_a_pk_key||' from stg.'||l_a_tablename_src||');'
		    ||chr(10)||'insert into gl.'||l_a_tablename_trg|| ' (' || l_src_cols || ') select ' || l_src_cols || ' from stg.'||l_a_tablename_src||';';
		   
     elsif l_a_loadtype = 4
       then 
       	    l_a_Stmt := 'delete from gl.'||l_a_tablename_trg||' where '||l_a_pk_key||' IN (select '||l_a_pk_key||' from stg.'||l_a_tablename_src||');'
		    ||chr(10)||'insert into gl.'||l_a_tablename_trg|| ' (' || l_src_cols || ') select ' || l_src_cols || ' from stg.'||l_a_tablename_src||' 
			where w$optype = 0;';			
     end if;
    
     else   
    	l_a_Stmt := '0';
    	
    end if;
  
   -- логирование
   perform meta_info.f_log('f_ee_gl_prepare_dynamic','PASSED',' SQL QUERY  - ' || l_a_Stmt);
  
   return l_a_Stmt;
  
end;






$$
EXECUTE ON ANY;
