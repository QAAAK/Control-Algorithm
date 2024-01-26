-- meta_info.dq_ldp_protocol определение

-- Drop table

-- DROP TABLE meta_info.dq_ldp_protocol;

CREATE TABLE meta_info.dq_ldp_protocol (
	id bigserial NOT NULL,
	trg_tbl_name varchar NULL,
	check_type varchar NULL,
	date_start timestamp NULL,
	date_end timestamp NULL,
	loss_cnt numeric NULL,
	status varchar NULL,
	recovery_dttm timestamp NULL,
	crt_date timestamp NULL DEFAULT now()
)
DISTRIBUTED REPLICATED;

-- Permissions

ALTER TABLE meta_info.dq_ldp_protocol OWNER TO drp;
GRANT ALL ON TABLE meta_info.dq_ldp_protocol TO drp;