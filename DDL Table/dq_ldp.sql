-- meta_info.dq_ldp определение

-- Drop table

-- DROP TABLE meta_info.dq_ldp;

CREATE TABLE meta_info.dq_ldp (
	id int8 NOT NULL DEFAULT nextval('meta_info.ee_ldp_id_seq'::regclass),
	rss_code varchar(4) NOT NULL,
	src_schema_name varchar(10) NULL,
	src_tbl_name varchar(50) NULL,
	trg_tbl_name varchar(50) NULL,
	clmn_id varchar(25) NULL,
	status_d varchar(15) NULL DEFAULT 'READY'::character varying,
	stasus_u varchar(15) NULL DEFAULT 'READY'::character varying,
	loss_qnt_d numeric NULL,
	loss_qnt_u numeric NULL,
	is_enable_d numeric(1) NOT NULL DEFAULT 1,
	is_enable_u numeric(1) NOT NULL DEFAULT 1,
	message_d text NULL,
	message_u text NULL,
	check_d_dttm timestamp NULL,
	check_u_dttm timestamp NULL,
	crt_date timestamp NULL DEFAULT now()
)
DISTRIBUTED REPLICATED;

-- Permissions

ALTER TABLE meta_info.dq_ldp OWNER TO drp;
GRANT ALL ON TABLE meta_info.dq_ldp TO drp;
