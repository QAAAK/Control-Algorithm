-- meta_info.log_func определение

-- Drop table

-- DROP TABLE meta_info.log_func;

CREATE TABLE meta_info.log_func (
	id int8 NOT NULL DEFAULT nextval('meta_info.func_id_seq'::regclass),
	func text NOT NULL,
	status text NULL,
	return_value text NULL,
	last_launch_dttm timestamp NOT NULL DEFAULT now()
)
DISTRIBUTED REPLICATED;