CREATE OR REPLACE PACKAGE BODY BUDM_UOR_TMD.DM_LOADER_BUDM_UOR_ASUOR
IS 

/* Будет инициализирована позднее */

--PROCEDURE LOAD_UOR_DET_EMPLOYEE_ASUP (p_date in DATE)
--IS
--	v_name_proc varchar2(50);
--	v_row_count number;
--	v_id_log number;
--
--BEGIN 
--  v_name_proc := 'LOAD_UOR_DET_EMPLOYEE'; 
--  v_row_count := 0;
--  v_id_log := SEQ_OPER_LOG.NEXTVAL;
--   OR_LOG( P_ID_LOG    => v_id_log,
--           P_DATA1    => p_date,
--           P_DATA2       => null,
--           P_NAME_PROC => v_name_proc,
--           P_ROW_COUNT => v_row_count
--          );
--	
--  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_DET_EMPLOYEE';
--	-- DELETE BUDM_UOR.UOR_DET_EMPLOYEE_ASUP; --variant 2
--
--  INSERT /*+ append*/ INTO BUDM_UOR.UOR_DET_EMPLOYEE 
--	  (CODE,
--	   SURNAME,
--	   NAME,
--	   SECOND_NAME,
--	   CODE_DEPARTMENT,
--	   ID_DEPARTMENT,
--	   NAME_DEPARTMENT,
--	   CODE_POSITION,
--	   NAME_POSITION,
--	   IS_MANAGER,
--	   DT_FIRE,
--	   DSC_EMAIL,
--	   DTTM_INSERT
--	   )
--  SELECT 
--		BDE.CODE             	AS CODE, 
--		BDE.Surname          	AS SURNAME, 
--		BDE.NAME             	AS NAME, 
--		BDE.SECOND_NAME      	AS SECOND_NAME, 
--		'ASUP#' || BDD.CODE   	AS CODE_DEPARTMENT,
--		BDD.ID_DEPARTMENT    	AS ID_DEPARTMENT, 
--		BDD.Name_Department  	AS NAME_DEPARTMENT, 
--		AED.CODE_POSITION    	AS CODE_POSITION, 
--		AED.Name_Position    	AS NAME_POSITION, 
--		AED.IS_MANAGERPOSITION  AS IS_MANAGER, 
--		AED.DT_FIRE             AS DT_FIRE, 
--		BDSC.CONTACT_FULL       AS DSC_MAIL,
--		trunc(sysdate) 			AS DTTM_INSERT
--	
--  FROM BMRT.BM_DET_EMPLOYEE BDE
--  INNER JOIN BMRT.BM_ASS_EMPLOYEE_DEPARTMENT AED on BDE.ID_EMPLOYEE=AED.ID_EMPLOYEE
--  INNER JOIN BMRT.BM_DET_DEPARTMENT BDD on BDD.ID_DEPARTMENT = AED.ID_DEPARTMENT
--  INNER JOIN BMRT.BM_ASS_SUBJECT BAS on BAS.ID_SUBJECT_LINKED = BDE.ID_EMPLOYEE
--  INNER JOIN BMRT.BM_DET_SUBJECT_CONTACT BDSC on BDSC.ID_SUBJECT=BAS.ID_SUBJECT
--  WHERE UPPER(BDD.CODE) LIKE 'ASUP#%';
--
--
--  COMMIT; 
--
--  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
--  SET END_DATE = SYSTIMESTAMP,
--	  ROW_COUNT = (select count(*)
--	               from BUDM_UOR.UOR_DET_EMPLOYEE_ASUP)
--  WHERE ID_LOG = v_id_log;
--
--  COMMIT;
--
--END LOAD_UOR_DET_EMPLOYEE;


PROCEDURE LOAD_UOR_FCT_STAFFTURNOVER (p_date IN DATE)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_FCT_STAFFTURNOVER';
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;

	
      OR_LOG( P_ID_LOG    => v_id_log,
           P_DATA1    => p_date,
           P_DATA2       => null,
           P_NAME_PROC => v_name_proc,
           P_ROW_COUNT => v_row_count
          );
	    
	         
  ---EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_FCT_STAFFTURNOVER';
  DELETE BUDM_UOR.UOR_FCT_STAFFTURNOVER; --variant 2
	
  INSERT /*+ append*/ 
  INTO BUDM_UOR.UOR_FCT_STAFFTURNOVER 
  		 (
  		 YEAR,
		 QUARTER,
		 CODE_DEPARTMENT,
         NAME_DEPARTMENT,
		 MANNINGTABLE_START,
		 MANNINGTABLE_END,
		 MANNINGTABLE_CHANGE,
	     EMPLOYEES_COUNT_START,
	     EMPLOYEES_COUNT_END,
		 EMPLOYEES_COUNT_CHANGE,
		 HEADCOUNT_START,
		 HEADCOUNT_END,
	     HEADCOUNT_CHANGE,
		 AVG_HEADCOUNT,
		 AVG_HEADCOUNT_MANAGER,
		 AVG_HEADCOUNT_SPECIALIST,
         VACANCY_START,
		 VACANCY_END,
		 HIRED,
		 HIRED_MANAGER,
		 FIRED,
		 FIRED_MANAGER,
		 TURNOVER,
		 TURNOVER_MANAGER,
		 TURNOVER_SPECIALIST,
		 DTTM_INSERT
		 )
  SELECT 
  		 YEAR,
		 QUARTER,
		 CODE_DEPARTMENT,
         NAME_DEPARTMENT,
		 MANNINGTABLE_START,
		 MANNINGTABLE_END,
		 MANNINGTABLE_CHANGE,
	     EMPLOYEES_COUNT_START,
	     EMPLOYEES_COUNT_END,
		 EMPLOYEES_COUNT_CHANGE,
		 HEADCOUNT_START,
		 HEADCOUNT_END,
	     HEADCOUNT_CHANGE,
		 AVG_HEADCOUNT,
		 AVG_HEADCOUNT_MANAGER,
		 AVG_HEADCOUNT_SPECIALIST,
         VACANCY_START,
		 VACANCY_END,
		 HIRED,
		 HIRED_MANAGER,
		 FIRED,
		 FIRED_MANAGER,
		 TURNOVER,
		 TURNOVER_MANAGER,
		 TURNOVER_SPECIALIST,
		 trunc(sysdate)
  FROM BMRT.BM_FCT_STAFFTURNOVER;
	
  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_FCT_STAFFTURNOVER)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;
		
END LOAD_UOR_FCT_STAFFTURNOVER;






PROCEDURE LOAD_UOR_FCT_ASCEVENT (p_date IN DATE)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_FCT_ASCEVENT'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;


   OR_LOG( P_ID_LOG    => v_id_log,
           P_DATA1    => p_date,
           P_DATA2       => null,
           P_NAME_PROC => v_name_proc,
           P_ROW_COUNT => v_row_count
          );
	         
  ---EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_FCT_ASCEVENT';
  DELETE BUDM_UOR.UOR_FCT_ASCEVENT; --variant 2
	
  INSERT /*+ append*/ INTO BUDM_UOR.UOR_FCT_ASCEVENT 
		  (CODE_EMPLOYEE,
		   DT, 
		   TIME,
		   CODE_ASCEVENTTYPE,
		   DTTM_INSERT
		   )
  SELECT ID_EMPLOYEE,
		 trunc(DT),
		 DT,
		 CODE_ASCEVENTTYPE,
		 trunc(sysdate)  
  FROM BMRT.BM_FCT_ASCEVENT;

  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_FCT_ASCEVENT)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;

		
END LOAD_UOR_FCT_ASCEVENT;



PROCEDURE LOAD_UOR_FCT_EMPLOYEEABSCENE (p_date IN DATE)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_FCT_EMPLOYEEABSCENE'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;


   OR_LOG( P_ID_LOG    => v_id_log,
           P_DATA1    => p_date,
           P_DATA2       => null,
           P_NAME_PROC => v_name_proc,
           P_ROW_COUNT => v_row_count
          );
	         
  ---EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_FCT_ASCEVENT';
  DELETE BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE; --variant 2
	
  INSERT /*+ append*/ INTO BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE 
		  (CODE_EMPLOYEE,
		   CODE_EMPLOYEEABSCENEKIND,
		   IS_BLOCKED,
		   DATE_START_PERIOD,
		   DATE_END_PERIOD,
		   NAME_EMPLOYEEABSCENEKIND,
		   DTTM_INSERT
		   )
  SELECT ID_EMPLOYEE,
		 CODE_EMPLOYEEABSCENEKIND,
		 IS_BLOCKED,
		 DATE_START_PERIOD,
		 DATE_END_PERIOD,
		 NAME_EMPLOYEEABSCENEKIND,
		 trunc(sysdate)  
  FROM BMRT.BM_FCT_EMPLOYEEABSCENE;

  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;

		
END LOAD_UOR_FCT_EMPLOYEEABSCENE;


/* Будет инициализирована позднее */

--PROCEDURE LOAD_UOR_BM_DET_DEPARTMENT (p_date IN DATE)
--IS
--  v_name_proc varchar2(50);
--  v_row_count number;
--  v_id_log number;
--
--BEGIN 
--  v_name_proc := 'LOAD_UOR_BM_DET_DEPARTMENT'; 
--  v_row_count := 0;
--  v_id_log := SEQ_OPER_LOG.NEXTVAL;
--
--
--   OR_LOG( P_ID_LOG    => v_id_log,
--           P_DATA1    => p_date,
--           P_DATA2       => null,
--           P_NAME_PROC => v_name_proc,
--           P_ROW_COUNT => v_row_count
--          );
--	 
--  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_BM_DET_DEPARTMENT';
--	--- DELETE BUDM_UOR.UOR_BM_DET_DEPARTMENT; --variant 2
--
--  INSERT /*+ append*/ INTO BUDM_UOR.UOR_BM_DET_DEPARTMENT 
--  (CODE,
--   NAME_DEPARTMENT,
--   CODE_ABBRV,
--   CODE_PARENT,
--   CODE_ASUP_FIL,
--   CODE_TYPE_DEPARTMENT,
--   CODE_BALANCE,
--   DTTM_INSERT 
--  )
--	
--  select 
--  'ASUP#' || BDD.Code                                        
--  , BDD.NAME_DEPARTMENT           
--  , BDO.NAME                      
--  , BDD_PARENT.CODE                
--  , BDD_PARENT.Name_Department     
--  , BDO3.NAME                      
--  , BDD.CODE_DEPARTMENTTYPE        
--  --BDO4.NAME будет определен позже на этапе загрузке данных в бмрт
--  , trunc(sysdate)                 
--  from BMRT.Bm_Det_Department BDD
--  inner join BMRT.BM_ASS_SUBJECT BAS on BAS.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
--  inner join BMRT.Bm_Det_Subject BDS on BDS.ID_SUBJECT = BAS.ID_SUBJECT
--  inner join BMRT.Bm_Fct_Subject_Attr BFSA on BFSA.ID_SUBJECT = BDS.ID_SUBJECT
--  inner join BMRT.Bm_Det_Objectattr BDO on BDO.ID_OBJECTATTR = BFSA.ID_OBJECTATTR
--
--  inner join BMRT.BM_ASS_SUBJECT BAS2 on BAS2.ID_SUBJECT = BDD.ID_DEPARTMENT
--  inner join BMRT.Bm_Det_Department BDD_PARENT on BDD_PARENT.ID_DEPARTMENT = BAS2.ID_SUBJECT_LINKED
--
--  inner join BMRT.BM_ASS_SUBJECT BAS3 on BAS3.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
--  inner join BMRT.Bm_Det_Subject BDS3 on BDS3.ID_SUBJECT = BAS3.ID_SUBJECT
--  inner join BMRT.Bm_Fct_Subject_Attr BFSA3 on BFSA3.ID_SUBJECT = BDS3.ID_SUBJECT
--  inner join BMRT.Bm_Det_Objectattr BDO3 on BDO3.ID_OBJECTATTR = BFSA3.ID_OBJECTATTR
--
--  inner join BMRT.BM_ASS_SUBJECT BAS4 on BAS4.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
--  inner join BMRT.Bm_Det_Subject BDS4 on BDS4.ID_SUBJECT = BAS4.ID_SUBJECT
--  inner join BMRT.Bm_Fct_Subject_Attr BFSA4 on BFSA4.ID_SUBJECT = BDS4.ID_SUBJECT
--  inner join BMRT.Bm_Det_Objectattr BDO4 on BDO4.ID_OBJECTATTR = BFSA4.ID_OBJECTATTR
--  --inner join BMRT.BM_DET_DEPARTMENTTYPE  BDDT on BDDT.ID_CLVALUE = BDD.ID_DEPARTMENTTYPE
--  where upper(BDO.CODE) like ('%RDM#SUBJECT_ATTR#VSP_NAME_SHORT#JURIDICPERSON#BANK%') 
--   	and upper(BDO3.CODE) like ('%RDM#SUBJECT_ATTR#VSP_ASUP_FIL#JURIDICPERSON#BANK%')
--   	and upper(BDO3.CODE) like ('%RDM#SUBJECT_ATTR#VSP_CODE_BALANCE#JURIDICPERSON#BANK%');
--	
--   		
--  COMMIT;
--
--  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
--  SET END_DATE = SYSTIMESTAMP,
--	  ROW_COUNT = (select count(*)
--	               from BUDM_UOR.UOR_BM_DET_DEPARTMENT)
--  WHERE ID_LOG = v_id_log;
--	
--  COMMIT;
--	 
--
--END LOAD_UOR_BM_DET_DEPARTMENT;




PROCEDURE OR_LOG(P_ID_LOG IN NUMBER,
                 P_DATA1 IN DATE,
                 P_DATA2 in DATE,
                 P_NAME_PROC IN VARCHAR2,
                 P_ROW_COUNT IN NUMBER
                )
IS

BEGIN

  INSERT /*+ append*/ INTO BUDM_UOR_TMD.OR_LOG_TMD(ID_LOG,
                                  				   START_DATE,
                                  				   END_DATE,
                                                   NAME_PROC,
                                                   ROW_COUNT,
                                                   X_BEGIN_DATE,
                                                   X_END_DATE)
       VALUES  (P_ID_LOG,
                SYSTIMESTAMP,
                null,
                P_NAME_PROC,
                P_ROW_COUNT,
                P_DATA1,
                P_DATA2);

 COMMIT;
  
end OR_LOG;


END DM_LOADER_BUDM_UOR_ASUOR;