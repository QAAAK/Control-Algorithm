-- meta_info.ee_gl_md определение

-- Drop table

-- DROP TABLE meta_info.ee_gl_md;

CREATE TABLE meta_info.ee_gl_md (
	id bigserial NOT NULL,
	load_type int4 NOT NULL,
	src_tbl_name varchar(50) NOT NULL,
	src_cols text NOT NULL,
	src_key_cols varchar(100) NOT NULL,
	trg_tbl_name varchar(50) NULL,
	trg_cols text NULL,
	part_key_col varchar(100) NULL,
	distr_col varchar(100) NULL,
	tbl_param text NULL,
	is_enable int2 NOT NULL,
	last_load_dttm timestamp NULL,
	last_load_status varchar(50) NULL,
	last_load_cnt int4 NULL,
	message_text text NULL,
	crt_date timestamp NOT NULL DEFAULT clock_timestamp(),
	part_type text NULL,
	dt_begin timestamp NULL,
	dt_end timestamp NULL,
	CONSTRAINT pk_ee_gl_md PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
)
WITH (
	appendonly=false
)
DISTRIBUTED REPLICATED;

-- Permissions

ALTER TABLE meta_info.ee_gl_md OWNER TO drp;
GRANT ALL ON TABLE meta_info.ee_gl_md TO drp;