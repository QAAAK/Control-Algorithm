-- meta_info.dq_ldp_protocol_detail определение

-- Drop table

-- DROP TABLE meta_info.dq_ldp_protocol_detail;

CREATE TABLE meta_info.dq_ldp_protocol_detail (
	id bigserial NOT NULL,
	protocol_id numeric NOT NULL,
	loss_id varchar NULL,
	crt_dttm timestamp NULL DEFAULT now()
)
DISTRIBUTED REPLICATED;

-- Permissions

ALTER TABLE meta_info.dq_ldp_protocol_detail OWNER TO drp;
GRANT ALL ON TABLE meta_info.dq_ldp_protocol_detail TO drp;