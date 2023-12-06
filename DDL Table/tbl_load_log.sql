-- meta_info.tbl_load_log определение

-- Drop table

-- DROP TABLE meta_info.tbl_load_log;

CREATE TABLE meta_info.tbl_load_log (
	id int8 NOT NULL DEFAULT nextval('meta_info.tbl_load_update_id_seq'::regclass),
	load_type int4 NOT NULL,
	src_tbl_name varchar(50) NOT NULL,
	trg_tbl_name varchar(50) NULL,
	last_load_dttm timestamp NULL,
	last_load_status varchar(50) NULL,
	last_load_cnt int2 NULL,
	message_text varchar(512) NULL,
	crt_date timestamp NOT NULL DEFAULT clock_timestamp(),
	sql_query text NULL,
	CONSTRAINT tbl_load_update_pkey PRIMARY KEY (id)
)
WITH (
	appendonly=false
)
DISTRIBUTED REPLICATED;