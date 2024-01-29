-- meta_info.cm_prm_md
comment on table meta_info.cm_prm_md is 'Cистемные параметры процессов';

comment on column meta_info.cm_prm_md.id is 'Идентификатор записи';
comment on column meta_info.cm_prm_md.param_name is 'Наименование параметра';
comment on column meta_info.cm_prm_md.param_value is 'Значение параметра';
comment on column meta_info.cm_prm_md.param_value_def is 'Значение параметра по умолчанию';
comment on column meta_info.cm_prm_md.is_enable is 'Параметр: 1-вкл.  0-выкл.';
comment on column meta_info.cm_prm_md.description is 'Описание параметра';
comment on column meta_info.cm_prm_md.crt_date is 'Дата создания записи';


-- meta_info.ee_rss_md
comment on table meta_info.ee_rss_md is 'Метаданные взаимодействия со смежными системами';

comment on column meta_info.ee_rss_md.id is 'Идентификатор записи, устанавливается вручную, строго в диапазоне от 0 до 999';
comment on column meta_info.ee_rss_md.rss_code is 'Четырехзначный код смежной системы';
comment on column meta_info.ee_rss_md.rss_name is 'Наименование смежной системы';
comment on column meta_info.ee_rss_md.rss_description is 'Описание смежной системы';
comment on column meta_info.ee_rss_md.data_integrator is 'Data Integrator используемый для интеграции со смежной системой: NULL - не используется, IPC – Informatica PC';
comment on column meta_info.ee_rss_md.priority is 'Приоритет';
comment on column meta_info.ee_rss_md.is_enable is 'Процессы для системы: 1-вкл. 0-выкл.';
comment on column meta_info.ee_rss_md.crt_date is 'Дата и время создания записи';
comment on column meta_info.ee_rss_md.host is 'Хост';
comment on column meta_info.ee_rss_md.port is 'Порт';
comment on column meta_info.ee_rss_md.login is 'Логин'; 
comment on column meta_info.ee_rss_md.password is 'Пароль';
comment on column meta_info.ee_rss_md.rss_schema is 'Схема смежной системы';
comment on column meta_info.ee_rss_md.rss_type is 'Тип смежной системы';
comment on column meta_info.ee_rss_md.interaction_type is 'Тип взаимодействия со смежной системой';
comment on column meta_info.ee_rss_md.rss_db is 'База данных смежной системы';
comment on column meta_info.ee_rss_md.crt_date is 'Дата создания записи';


--meta_info.ee_stg_md
comment on table meta_info.ee_stg_md is 'Mетаданные таблиц в схеме stg';

comment on column meta_info.ee_stg_md.id is 'Идентификатор записи';
comment on column meta_info.ee_stg_md.rss_code is 'Код загрузки (‘DLK’, ‘CDWH’)';
comment on column meta_info.ee_stg_md.src_schema_name is 'схема таблицы-источника';
comment on column meta_info.ee_stg_md.src_tbl_name is 'Имя таблицы-источника';
comment on column meta_info.ee_stg_md.stg_tbl_name is 'Имя таблицы-приемника';
comment on column meta_info.ee_stg_md.task_code is 'Исполняемый код загрузки'; 
comment on column meta_info.ee_stg_md.prm_date_from is 'Дата начала загрузки';
comment on column meta_info.ee_stg_md.prm_date_to is 'Дата окончания загрузки';
comment on column meta_info.ee_stg_md.is_enable is 'Активность записи метаданных (1- активна)';
comment on column meta_info.ee_stg_md.last_load_dttm is 'Дата и время последней загрузки';
comment on column meta_info.ee_stg_md.last_load_status is 'Статус последней загрузки (SUCCESS/ERROR)';
comment on column meta_info.ee_stg_md.last_load_cnt is 'Количество загруженных записей';
comment on column meta_info.ee_stg_md.message_text is 'Сообщения (о загрузке, описание ошибки и т.п.)';
comment on column meta_info.ee_stg_md.crt_date is 'Дата создания записи';


--meta_info.ee_gl_md
comment on table meta_info.ee_gl_md is 'Mетаданные процесса репликации в gl';

comment on column meta_info.ee_gl_md.id is 'Идентификатор записи';
comment on column meta_info.ee_gl_md.load_type is 'Тип загрузки - полная(1), добавочная(2), загрузка без удаленных записей(4)';
comment on column meta_info.ee_gl_md.src_tbl_name is 'Наименование таблицы-источника';
comment on column meta_info.ee_gl_md.src_cols is 'Наименования полей таблицы-источника в строку, через разделитель "запятая"'; 
comment on column meta_info.ee_gl_md.src_key_cols is 'Наименования ключевых полей таблицы-источника в строку, через разделитель "запятая"';
comment on column meta_info.ee_gl_md.trg_tbl_name is 'Наименование целевой таблицы, если NULL подставляется наименование таблицы источника';
comment on column meta_info.ee_gl_md.trg_cols is 'Наименования полей целевой таблицы в строку, через разделитель "запятая", с указанием типа данных, например: id[N], tdate[D], name[T], qnt[I]. Где: [N] – numeric, [D] - datetime,  [V(NNNN)] – varchar(размер), [I] - Int.';
comment on column meta_info.ee_gl_md .part_key_col is 'Наименования полей-ключей для вложенного секционирования: в строку, через разделитель "запятая"'; 
comment on column meta_info.ee_gl_md .distr_col is 'Ключ распределения (шардирования)';
comment on column meta_info.ee_gl_md .tbl_param is 'Параметры создания таблицы gl (appendonly, orientation)';
comment on column meta_info.ee_gl_md .is_enable is 'Активность записи метаданных (1- активна)';
comment on column meta_info.ee_gl_md .last_load_dttm is 'Дата и время последней загрузки';
comment on column meta_info.ee_gl_md .last_load_status is 'Статус последней загрузки (SUCCESS/ERROR)';
comment on column meta_info.ee_gl_md .last_load_cnt is 'Количество загруженных записей';
comment on column meta_info.ee_gl_md.message_text is 'Сообщения (о загрузке, описание ошибки и т.п.)';
comment on column meta_info.ee_gl_md .crt_date is 'Дата создания записи';


--meta_info.ecm_task
comment on table meta_info.ecm_task is 'Задания';

comment on column meta_info.ecm_task.id is 'Идентификатор записи, меняется при каждом переформировании данных';
comment on column meta_info.ecm_task.system_code is 'Код системы источника, DRP – DRP, CDWH – ИС КХД, DLK – Озеро данных';
comment on column meta_info.ecm_task.process_type is 'Тип процесса:INI_PARAM – Корневой процесс, CDWH_TO_STG – Процесс репликации из КХД в DRP.STG,DLK_TO_STG – Процесс репликации из Озера в DRP.STG ,STG_TO_GL -– Процесс репликации из схемы STG в GL';
comment on column meta_info.ecm_task.md_table_name is 'Таблица источник метаданных DRP, для данной записи';
comment on column meta_info.ecm_task.md_id is 'Идентификатор записи в таблице метаданных';
comment on column meta_info.ecm_task.task_code is 'Код задания (команда или скрипт выполнения); Для task_type: SQL – обычный SQL запрос или неименованный блок, для выполнения в БД DRP; IPC – текст по шаблону: [WF]|[FOLDER], для выполнения в IPC; DEI – текст по шаблону: [WF]|[FOLDER], для выполнения в DEI;'; 
comment on column meta_info.ecm_task.status is 'Статус задания:1 – Готово к запуску; 2 – Запущено; 5 – Успешно завершено; -1 – Завершено с ошибкой;';
comment on column meta_info.ecm_task.message is 'Сообщение, в случае ошибки при выполнении задания, здесь размещается текст ошибки';
comment on column meta_info.ecm_task.is_enable is 'Признак активности: 1 – Задание включено, можно выполнять;0 – задание выключено, выполнять не нужно;'; 
comment on column meta_info.ecm_task.last_dttm is 'Дата последнего изменения';
comment on column meta_info.ecm_task.crt_dttm is 'Дата создания записи';
comment on column meta_info.ecm_task.task_type is 'Признак активности: 1 – Задание включено, можно выполнять;0 – задание выключено, выполнять не нужно;';
comment on column meta_info.ecm_task.prm_date_from is 'Параметр – дата начала, для DEI и IPC';
comment on column meta_info.ecm_task.prm_date_to is 'Параметр – дата окончания, для DEI и IPC';
comment on column meta_info.ecm_task.last_load_cnt is 'Количество вставленных записей';


--meta_info.ecm_task_link
comment on table meta_info.ecm_task_link is 'Зависимости заданий';

comment on column meta_info.ecm_task_link.id is 'Идентификатор записи, меняется при каждом переформировании данных';
comment on column meta_info.ecm_task_link.task_id  is 'Идентификатор задания в таблице ECM_TASK';
comment on column meta_info.ecm_task_link.parent_id is 'Идентификатор родительского задания в таблице ECM_TASK';
comment on column meta_info.ecm_task_link.is_enable is  'Признак активности: 1 – Связь активна, нужно учитывать; 0 – Связь неактивна, не учитывать;';
comment on column meta_info.ecm_task_link.crt_dttm is 'Дата создания записи';


--meta_info.log_func
comment on table meta_info.log_func is 'Таблица-журнал работы функций';

comment on column meta_info.log_func.id is 'Идентификатор записи';
comment on column meta_info.log_func.func is 'Имя функции';
comment on column meta_info.log_func.status is 'Статус выполнения функции';
comment on column meta_info.log_func.detail is 'Детали выполнения (аргументы функции, сообщения об ошибки, на каком этапе находится функция)';
comment on column meta_info.log_func.last_launch_dttm  is 'Дата создания записи';


--meta_info.tbl_load_log
comment on table meta_info.tbl_load_log is 'таблица-журнал о наполнении таблиц в схеме gl';

comment on column meta_info.tbl_load_log.id is 'Идентификатор записи';
comment on column meta_info.tbl_load_log.load_type is 'Тип загрузки - полная(1), добавочная(2), загрузка без удаленных записей(4)';
comment on column meta_info.tbl_load_log.src_tbl_name is 'Наименование таблицы-источника';
comment on column meta_info.tbl_load_log.trg_tbl_name is 'Наименование целевой таблицы, если NULL подставляется наименование таблицы источника';
comment on column meta_info.tbl_load_log.last_load_dttm is 'Дата и время последней загрузки';
comment on column meta_info.tbl_load_log.last_load_status is 'Статус последней загрузки (SUCCESS/ERROR)';
comment on column meta_info.tbl_load_log.last_load_cnt is 'Количество загруженных записей';
comment on column meta_info.tbl_load_log.message_text is 'Количество загруженных записей';
comment on column meta_info.tbl_load_log.crt_date is 'Дата создания записи';
comment on column meta_info.tbl_load_log.sql_query is 'Сообщение об ошибке.';


-- meta_info.dq_ldp 
comment on table meta_info.dq_ldp is 'Таблица связей между таблицами (external-gl)';

comment on column meta_info.dq_ldp.id is 'Идентификатор записи';
comment on column meta_info.dq_ldp.rss_code is 'Код системы источника';
comment on column meta_info.dq_ldp.src_schema_name is 'Схема таблицы источника';
comment on column meta_info.dq_ldp.src_tbl_name is 'Имя таблицы источника';
comment on column meta_info.dq_ldp.trg_tbl_name is 'Имя таблицы приемника';
comment on column meta_info.dq_ldp.clmn_id is 'Наименования поля-идентификатора';
comment on column meta_info.dq_ldp.status_d is 'Статус выполнения поиска потерянных записей (DELETE)';
comment on column meta_info.dq_ldp.status_u is 'Статус выполнения поиска потерянных записей (UPDATE)';
comment on column meta_info.dq_ldp.loss_cnt_d is 'Количество потерянных записей (DELETE)';
comment on column meta_info.dq_ldp.loss_cnt_u is 'Количество потерянных записей (UPDATE)';
comment on column meta_info.dq_ldp.is_enable_d is 'Активна ли проверка (DELETE) (1 – активна, 0 – неактивна)';
comment on column meta_info.dq_ldp.is_enable_u is 'Активна ли проверка (UPDATE) (1 – активна, 0 – неактивна)';
comment on column meta_info.dq_ldp.message_d is 'Сообщение о проведенной проверке потерянных записей (DELETE)';
comment on column meta_info.dq_ldp.message_u is 'Сообщение о проведенной проверке потерянных записей (UPDATE)';
comment on column meta_info.dq_ldp.check_d_dttm is 'Дата и время проверки (DELETE)';
comment on column meta_info.dq_ldp.check_u_dttm is 'Дата и время проверки (UPDATE)';
comment on column meta_info.dq_ldp.crt_date is 'Дата создания записи';


--meta_info.dq_ldp_protocol
comment on table meta_info.dq_ldp_protocol is 'Таблица-журнал исполняяемых проверок DQ';

comment on column meta_info.dq_ldp_protocol.id is 'Идентификатор записи';
comment on column meta_info.dq_ldp_protocol.trg_tbl_name is 'Имя таблицы источника';
comment on column meta_info.dq_ldp_protocol.check_type is 'Тип проверки (DELETE/UPDATE)';
comment on column meta_info.dq_ldp_protocol.date_start is 'Дата и время начала проверки';
comment on column meta_info.dq_ldp_protocol.date_end is 'Дата и время окончания проверки';
comment on column meta_info.dq_ldp_protocol.loss_cnt is 'Количество потерянных записей';
comment on column meta_info.dq_ldp_protocol.status is 'Статус проверки';
comment on column meta_info.dq_ldp_protocol.recovery_dttm is 'Дата и время восстановления потерянных записей';
comment on column meta_info.dq_ldp_protocol.crt_date is 'Дата создания записи';


--meta_info.dq_ldp_protocol_detail 
comment on table meta_info.dq_ldp_protocol_detail is 'Таблица с потерянными идентификаторами записи';

comment on column meta_info.dq_ldp_protocol_detail.id is 'Идентификатор записи';
comment on column meta_info.dq_ldp_protocol_detail.protocol_id is 'Идентификатор записи в таблице dq_ldp_protocol';
comment on column meta_info.dq_ldp_protocol_detail.loss_id is 'Идентификатор потерянной записи в таблице приемнике';
comment on column meta_info.dq_ldp_protocol_detail.crt_dttm is 'Дата и время найденной записи';























