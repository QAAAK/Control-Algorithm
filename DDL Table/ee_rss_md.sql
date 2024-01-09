-- meta_info.ee_rss_md определение

-- Drop table

-- DROP TABLE meta_info.ee_rss_md;

CREATE TABLE meta_info.ee_rss_md (
	id int4 NOT NULL,
	rss_code varchar(4) NOT NULL,
	rss_name varchar(500) NOT NULL,
	rss_description varchar(500) NULL,
	data_integrator varchar(30) NULL,
	priority int2 NOT NULL,
	is_enable int2 NOT NULL,
	crt_date timestamp NULL DEFAULT clock_timestamp(),
	"host" varchar(50) NULL,
	port int2 NULL,
	login varchar(30) NULL,
	"password" varchar(30) NULL,
	rss_schema varchar(30) NULL,
	rss_type varchar(30) NULL,
	interaction_type varchar(30) NULL,
	rss_db varchar(30) NULL,
	CONSTRAINT pk_ee_rss_md PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
)
WITH (
	appendonly=false
)
DISTRIBUTED REPLICATED;