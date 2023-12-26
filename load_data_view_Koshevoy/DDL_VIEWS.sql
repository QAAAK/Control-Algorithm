
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
 SELECT t.CODE AS em_id,
 		t.SURNAME AS surname,
 		t.NAME AS lname,
 		t.SECOND_NAME AS patronymic,
 		t.CODE_DEPARTMENT AS sub_id,
 		t.ID_DEPARTMENT AS employee_subsection_code,
 		t.NAME_DEPARTMENT AS employee_subsection_name,
 		t.CODE_POSITION AS post_id,
 		t.NAME_POSITION AS post_name,
 		t.IS_MANAGER AS is_ruk,
 		t.DT_FIRE AS fire_date,
 		t.DSC_EMAIL AS email,
 		t.DTTM_INSERT AS upload_date
 		
 		
 FROM BUDM_UOR.UOR_DET_EMPLOYEE_ASUP t;
													
--- 
													
												
CREATE OR REPLACE VIEW EDM_UOR.UOR_BM_DET_DEPARTMENT ( sub_id,
														lname,
														abbrv,
														parent_id,
														root_id,
														sub_type,
														balance_code,
														upload_date
														)
AS 
SELECT t.CODE AS sub_id,
	   t.NAME_DEPARTMENT AS lname,
	   t.CODE_ABBRV AS abbvr,
	   t.CODE_PARENT AS parent_id,
	   t.CODE_ASUP_FIL AS root_id,
	   t.CODE_TYPE_DEPARTMENT AS sub_type,
	   t.CODE_BALANCE AS balance_code,
	   t.DTTM_INSERT AS upload_date
	   
	   
FROM BUDM_UOR.UOR_DET_DEPARTMENT t;
														
														
---
														
													
CREATE OR REPLACE VIEW EDM_UOR.UOR_FCT_STAFFTURNOVER ( 	
														year,
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
														report_date
														)
AS
SELECT t.YEAR AS "year",
	   t.QUARTER AS quater,
	   t.CODE_DEPARTMENT AS sub_id,
	   t.NAME_DEPARTMENT AS sub_name,
	   t.MANNINGTABLE_START AS shtat_begda,
	   t.MANNINGTABLE_END AS shtat_enddate,
	   t.MANNINGTABLE_CHANGE AS shtat_delta,
	   t.EMPLOYEES_COUNT_START AS fact_begda,
	   t.EMPLOYEES_COUNT_END AS fact_endda,
	   t.EMPLOYEES_COUNT_CHANGE AS fact_delta,
	   t.HEADCOUNT_START AS spis_begda,
	   t.HEADCOUNT_END AS spis_endda,
	   t.HEADCOUNT_CHANGE AS spis_delta,
	   t.AVG_HEADCOUNT as sredn_spis_all,
	   t.AVG_HEADCOUNT_MANAGER as sredn_spis_top,
	   t.AVG_HEADCOUNT_SPECIALIST as sredn_spis_spc,
	   t.VACANCY_START as vac_begda,
	   t.VACANCY_END as vac_enddda,
	   t.HIRED as acc_all,
	   t.HIRED_MANAGER as acc_top,
	   t.FIRED as fire_all,
	   t.FIRED_MANAGER as fire_top,
	   t.TURNOVER as turn_all,
	   t.TURNOVER_MANAGER as turn_top,
	   t.TURNOVER_SPECIALIST as turn_spc,
	   t.DTTM_INSERT AS report_date

FROM BUDM_UOR.UOR_FCT_STAFFTURNOVER t;
														
														
---
														
														

CREATE OR REPLACE VIEW EDM_UOR.UOR_FCT_ASCEVENT ( em_id,
												  ldate,
												  ltime,
												  ltype,
												  upload_date	
											    )
AS

SELECT t.CODE_EMPLOYEE AS em_id,
	   t.DT AS ldate,
	   t.TIME AS ltime,
	   t.CODE_ASCEVENTTYPE AS ltype,
	   t.DTTM_INSERT AS upload_date
FROM BUDM_UOR.UOR_FCT_ASCEVENT t;
														
														
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
SELECT t.CODE_EMPLOYEE as em_id,
	   t.CODE_EMPLOYEEABSCENEKIND as absence_type,
	   t.IS_BLOCKED as is_block,
	   t.DATE_START_PERIOD as begin_date,
	   t.DATE_END_PERIOD as end_date,
	   t.NAME_EMPLOYEEABSCENEKIND as lname,
	   t.DTTM_INSERT as upload_date
FROM BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE t;



														
														
														
														
	