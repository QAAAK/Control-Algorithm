-- meta_info.v_mn_task_process_detail исходный текст

CREATE OR REPLACE VIEW meta_info.v_mn_task_process_detail
AS WITH t AS (
         SELECT et.task_type,
            'stg.'::text || esm.stg_tbl_name::text AS name_table,
            et.system_code,
            et.process_type,
            et.md_table_name AS type_operation,
            esm.last_load_status AS status,
            et.message,
            et.prm_date_from,
            et.prm_date_to
           FROM meta_info.ecm_task et
             JOIN meta_info.ee_stg_md esm ON et.md_id = esm.id
        UNION ALL
         SELECT et.task_type,
            'gl.'::text || egm.trg_tbl_name::text AS name_table,
            et.system_code,
            et.process_type,
            et.md_table_name AS type_operation,
            egm.last_load_status AS status,
            et.message,
            et.prm_date_from,
            et.prm_date_to
           FROM meta_info.ecm_task et
             JOIN meta_info.ee_gl_md egm ON et.md_id = egm.id
        )
 SELECT t.task_type,
    t.name_table,
    t.system_code,
    t.process_type,
    t.type_operation,
    t.status,
    t.message,
    t.prm_date_from,
    t.prm_date_to
   FROM t;

-- Permissions

ALTER TABLE meta_info.v_mn_task_process_detail OWNER TO drp;
GRANT ALL ON TABLE meta_info.v_mn_task_process_detail TO drp;