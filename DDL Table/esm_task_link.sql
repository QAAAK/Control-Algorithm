-- meta_info.ecm_task_link определение

-- Drop table

-- DROP TABLE meta_info.ecm_task_link;

CREATE TABLE meta_info.ecm_task_link (
	id bigserial NOT NULL,
	task_id int4 NOT NULL,
	parent_id int4 NULL,
	is_enable int2 NOT NULL,
	crt_dttm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_ecm_link_queue PRIMARY KEY (id)
)
WITH (
	appendonly=false
)
DISTRIBUTED BY (id);