
---

CREATE OR REPLACE  VIEW EDM_UOR.UOR_DET_EMPLOYEE  ( em_id,
												    surname,
													lname,
													patronymic, 
													sub_id,  
													employee_subsection_code,
													employee_subsection_name,
													post_id, 
													post_name,
													is_ruk,
													fire_date,
													email,
													upload_date
						  							)   
AS		  							
													SELECT * FROM BUDM_UOR.UOR_DET_EMPLOYEE 
													
--- 
													
												
CREATE OR REPLACE VIEW EDM_UOR.UOR_ BM_DET_DEPARTMENT ( sub_id,
														lname,
														abbrv,
														parent_id,
														root_id,
														sub_type,
														balance_code,
														upload_date
														)
AS 
														SELECT * FROM BUDM_UOR.UOR_ BM_DET_DEPARTMENT
														
														
---
														
													
CREATE OR REPLACE VIEW EDM_UOR.UOR_FCT_STAFFTURNOVER ( 	report_date,
														"year",
														quarter,
														sub_id,
														sub_name,
														shtat_begda,
														shtat_enddate,
														shtat_delta,
														fact_begda,
														fact_endda,
														fact_delta,
														spis_begda,
														spis_endda,
														spis_delta,
														sredn_spis_all,
														sredn_spis_top,
														sredn_spis_spc,
														vac_begda,
														vac_enddda,
														acc_all,
														acc_top,
														fire_all,
														fire_top,
														turn_all,
														turn_top,
														turn_spc,
														)
AS
														SELECT * FROM BUDM_UOR.UOR_FCT_STAFFTURNOVER
														
														
---
														
														

CREATE OR REPLACE VIEW EDM_UOR.UOR_FCT_ASCEVENT ( em_id,
												  ldate,
												  ltime,
												  ltype,
												  upload_date	
											    )
AS
														SELECT * FROM BUDM_UOR.UOR_FCT_ASCEVENT
														
														
---

														

CREATE OR REPLACE VIEW EDM_UOR.UOR_FCT_EMPLOYEEABSCENE (em_id,
														absence_type,
														is_block,
														begin_date,
														end_date,
														lname,
														upload_date
													 	)
AS
														 SELECT * FROM BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE
														
														
														
														
	