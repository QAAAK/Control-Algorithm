-- meta_info.v_mn_process_status исходный текст

CREATE OR REPLACE VIEW meta_info.v_mn_process_status
AS SELECT DISTINCT et.process_type,
    et.task_type AS system_code,
    sum(
        CASE
            WHEN et.status = 1 THEN 1
            ELSE 0
        END) AS status_ready,
    sum(
        CASE
            WHEN et.status = 2 THEN 1
            ELSE 0
        END) AS status_started,
    sum(
        CASE
            WHEN et.status = 5 THEN 1
            ELSE 0
        END) AS status_succesful,
    sum(
        CASE
            WHEN et.status = '-1'::integer THEN 1
            ELSE 0
        END) AS status_fail
   FROM meta_info.ecm_task et
  GROUP BY et.process_type, et.system_code, et.task_type;

-- Permissions

ALTER TABLE meta_info.v_mn_process_status OWNER TO drp;
GRANT ALL ON TABLE meta_info.v_mn_process_status TO drp;