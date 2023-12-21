-- meta_info.ecm_task определение

-- Drop table

-- DROP TABLE meta_info.ecm_task;

CREATE TABLE meta_info.ecm_task (
	id bigserial NOT NULL,
	system_code varchar(30) NOT NULL,
	process_type varchar(30) NOT NULL,
	md_table_name varchar(30) NOT NULL,
	md_id int2 NULL,
	task_code varchar(1000) NOT NULL,
	status int2 NOT NULL,
	message varchar(1000) NULL,
	is_enable int2 NOT NULL,
	last_dttm timestamp NULL,
	crt_dttm timestamp NOT NULL DEFAULT clock_timestamp(),
	task_type text NULL,
	prm_date_from date NULL,
	prm_date_to date NULL,
	last_load_cnt int4 NULL,
	CONSTRAINT pk_ecm_queue PRIMARY KEY (id)
)
WITH (
	appendonly=false
)
DISTRIBUTED BY (id);