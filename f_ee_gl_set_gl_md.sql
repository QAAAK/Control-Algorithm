-- DROP FUNCTION meta_info.f_ee_gl_set_gl_md(meta_info.ee_gl_md);

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_set_gl_md(p_gl_md_row meta_info.ee_gl_md)
	RETURNS int2
	LANGUAGE plpgsql
	VOLATILE
AS $$
	
	
	
	
/* f_ee_gl_set_gl_md - функция, добавляющая новую запись в таблицу meta_info.f_ee_gl_md
  		   
   параметры функции:
   			p_gl_md_row meta_info._ee_gl_md -- строка, которую добавить в таблицу
   
   возвращаемое значение: результат о выполнении в виде числа (1 или 0)
      
   Автор: Санталов Д.В. SantalovDV@intech.rshb.ru и Кулагин В.Н. KulaginVN@intech.rshb.ru
   Дата создания: 15.11.2023
*/	
	

declare
    
l_err_text text; -- текст ошибки 

begin
	--логирование
	perform meta_info.f_log('f_ee_gl_set_gl_md', 'RUNNING', p_gl_md_row);
	-- получаем строку для добавления новой записи в таблицу
	p_gl_md_row.id = nextval(pg_get_serial_sequence('ee_gl_md','id'));
	-- добавляем новую запись в таблицу
	insert into meta_info.ee_gl_md select p_gl_md_row.*;
    --commit;
    --логирование
    perform meta_info.f_log('f_ee_gl_set_gl_md', 'PASSED', 'Operation completed');
    return 1;

--обработка исключений
exception 
   when others then 
   
   get STACKED diagnostics l_err_text := PG_EXCEPTION_CONTEXT;	
   --логирование
   perform meta_info.f_log('f_ee_gl_set_gl_md', 'FAIL', l_err_text);
  
   return 0;
  
end;





$$
EXECUTE ON ANY;

-- Permissions

ALTER FUNCTION meta_info.f_ee_gl_set_gl_md(meta_info.ee_gl_md) OWNER TO root;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_set_gl_md(meta_info.ee_gl_md) TO public;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_set_gl_md(meta_info.ee_gl_md) TO root;
GRANT ALL ON FUNCTION meta_info.f_ee_gl_set_gl_md(meta_info.ee_gl_md) TO drp_meta_info_w;
