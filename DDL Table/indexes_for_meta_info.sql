ALTER TABLE meta_info.cm_prm_md 
ADD CONSTRAINT UC_cm_prm_md UNIQUE (id, param_name); 

ALTER TABLE meta_info.dq_ldp 
ADD CONSTRAINT UC_dq_ldp UNIQUE (id, src_tbl_name,trg_tbl_name);

ALTER TABLE meta_info.dq_ldp_protocol
ADD CONSTRAINT UC_dq_ldp_protocol UNIQUE (id);

ALTER TABLE meta_info.dq_ldp_protocol_detail
ADD CONSTRAINT UC_dq_ldp_protocol_detail UNIQUE (id);

ALTER TABLE meta_info.ecm_task 
ADD CONSTRAINT UC_ecm_task UNIQUE (id, task_code);

ALTER TABLE meta_info.ecm_task_link 
ADD CONSTRAINT UC_ecm_task_link UNIQUE (id);

ALTER TABLE meta_info.ee_gl_md
ADD CONSTRAINT UC_ee_gl_md UNIQUE (id, src_tbl_name);

ALTER TABLE meta_info.ee_stg_md 
ADD CONSTRAINT UC_ee_stg_md UNIQUE (id, stg_tbl_name);

ALTER TABLE meta_info.log_func
ADD CONSTRAINT UC_log_func UNIQUE (id);

ALTER TABLE meta_info.tbl_load_log
ADD CONSTRAINT UC_tbl_load_log UNIQUE (id);