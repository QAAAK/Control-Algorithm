-- DROP FUNCTION meta_info.f_ee_gl_replicate(numeric);

 

CREATE OR REPLACE FUNCTION meta_info.f_ee_gl_replicate(p_a_id numeric)

RETURNS int4

LANGUAGE plpgsql

VOLATILE

AS $$

 

 

 

 

 

 

 

 

 

 

/* f_ee_gl_replicate - функция, обновляющая таблицу логов загрузки meta_info.tbl_load_log, 

а также запускающая процесс перекладки данных из схемы STG в схему GL

 

параметры функции:

p_a_id - id таблицы для переноса данных

 

возвращаемое значение: количество перенесенных строк 

 

Автор: Санталов Д.В. SantalovDV@intech.rshb.ru

Дата создания: 29.11.2023

*/

 

 

declare

l_a_StartDt timestamp; -- Время начала операции

l_a_Cnt int := 0; -- Количество перенесенных строк

l_a_tablename_trg text; -- имя таблицы-приемника

l_a_tablename_src text; -- имя таблицы-источника

l_a_loadtype numeric; -- тип загрузки

l_sql_text text; -- переменная, которая принимает возвращаемое значение функции 

l_err_text text; -- текст ошибки

 

begin

--логирование

perform meta_info.f_log('f_ee_gl_replicate','RUNNING', 'Аргументы функции - {' || p_a_id || '}');

 

-- извлекаем данные для дальнейшей загруки 

select load_type, trg_tbl_name, src_tbl_name

into l_a_loadtype, l_a_tablename_trg, l_a_tablename_src

from meta_info.ee_gl_md

where id=p_a_id;

 

begin

-- обновление статуса загруки 

l_a_StartDt := clock_timestamp();

update meta_info.ee_gl_md

set last_load_dttm = l_a_StartDt, last_load_status = 'READY', last_load_cnt = 0

where id=p_a_id;

end;

 

-- вызов функции для получения возвращаемого значения

l_sql_text := meta_info.f_ee_gl_prepare_dynamic(p_a_id);

 

-- обновляем таблицу статусом запущено

update meta_info.ee_gl_md

set last_load_dttm = l_a_StartDt, last_load_status = 'STARTED',

dt_begin = current_timestamp, dt_end = null

where id=p_a_id;

 

-- проверка условия для дальнейшей загрузки данных

if l_sql_text != '0'

then

 

execute l_sql_text;

 

get diagnostics l_a_Cnt := ROW_COUNT;

 

-- вызываем функцию удаления записей

perform meta_info.f_dq_ldp_delete(l_a_tablename_trg);

 

--Очистить таблицу stg

perform meta_info.f_truncate_table('stg.'||l_a_tablename_src);

end if;

 

-- добавление статуса успешной загрузки в таблицу логов

insert into meta_info.tbl_load_log(load_type, src_tbl_name, trg_tbl_name, last_load_dttm, last_load_status, last_load_cnt, sql_query)

values (l_a_loadtype, l_a_tablename_src, l_a_tablename_trg, l_a_StartDt, 'SUCCESSFUL', l_a_Cnt, l_sql_text);

update meta_info.ee_gl_md

set last_load_dttm = l_a_StartDt, last_load_status = 'SUCCESSFUL', last_load_cnt = l_a_Cnt,

dt_end = current_timestamp, message_text = null

where id=p_a_id;

 

-- логирование

perform meta_info.f_log('f_ee_gl_replicate','PASSED', 'Количество перенесенных строк - ' || l_a_Cnt);

 

return l_a_Cnt;

 

-- обработка исключений

exception when others then

get STACKED diagnostics l_err_text = PG_EXCEPTION_CONTEXT;

raise notice 'context: >>%<<', l_err_text;

 

-- добавление статуса провальной загрузки в таблицу логов 

insert into meta_info.tbl_load_log(load_type, src_tbl_name, trg_tbl_name, last_load_dttm, last_load_status, last_load_cnt, sql_query, message_text)

values (l_a_loadtype, l_a_tablename_src, l_a_tablename_trg, l_a_StartDt, 'FAIL', l_a_Cnt, l_sql_text, l_err_text);

update meta_info.ee_gl_md

set last_load_dttm = l_a_StartDt, last_load_status = 'FAIL', last_load_cnt = l_a_Cnt, message_text = l_err_text,

dt_end = current_timestamp

where id=p_a_id;

 

-- логирование

perform meta_info.f_log('f_ee_gl_replicate','FAIL', l_err_text);

 

return -1;

raise;

end;

 

 

 

 

 

 

 

 

 

 

 

 

$$

EXECUTE ON ANY;

 

-- Permissions

 

ALTER FUNCTION meta_info.f_ee_gl_replicate(numeric) OWNER TO drp;

GRANT ALL ON FUNCTION meta_info.f_ee_gl_replicate(numeric) TO public;

GRANT ALL ON FUNCTION meta_info.f_ee_gl_replicate(numeric) TO drp;

 