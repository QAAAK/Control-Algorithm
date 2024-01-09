-- meta_info.cm_prm_md определение

-- Drop table

-- DROP TABLE meta_info.cm_prm_md;

CREATE TABLE meta_info.cm_prm_md (
	id serial4 NOT NULL,
	param_name varchar(30) NOT NULL,
	param_value varchar(30) NULL,
	param_value_def varchar(30) NULL,
	is_enable int4 NULL,
	description varchar(500) NOT NULL,
	crt_date timestamp NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_cm_prm_md PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
)
WITH (
	appendonly=false
)
DISTRIBUTED REPLICATED;