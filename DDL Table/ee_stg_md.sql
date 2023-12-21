-- meta_info.ee_stg_md определение

-- Drop table

-- DROP TABLE meta_info.ee_stg_md;

CREATE TABLE meta_info.ee_stg_md (
	id bigserial NOT NULL,
	rss_code varchar(4) NOT NULL,
	src_schema_name varchar(20) NOT NULL,
	src_tbl_name varchar(20) NOT NULL,
	task_code varchar(1000) NOT NULL,
	date_from date NULL,
	date_to date NULL,
	stg_tbl_name varchar(50) NULL,
	is_enable int2 NOT NULL,
	last_load_dttm timestamp NULL,
	last_load_status varchar(50) NULL,
	last_load_cnt int4 NULL,
	message_text varchar(512) NULL,
	crt_date timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_ee_stg_md PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
)
DISTRIBUTED REPLICATED;