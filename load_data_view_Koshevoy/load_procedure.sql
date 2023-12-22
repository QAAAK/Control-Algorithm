CREATE OR REPLACE PACKAGE BODY BUDM_UOR.DM_LOADER_UOR_ASUOR
IS 

PROCEDURE LOAD_UOR_DET_EMPLOYEE_ASUP
			( 
             p_date  in DATE -- dt_to
			)
IS
	v_name_proc varchar2(50);
	v_row_count number;
	v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_DET_EMPLOYEE_ASUP'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;

  OR_LOG( P_ID_LOG    => v_id_log, 
	      P_DATA1    => null,
	      P_DATA2       => p_date,
	      P_NAME_PROC => v_name_proc,
	      P_ROW_COUNT => v_row_count
	        );	
	
  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_DET_EMPLOYEE_ASUP';
	--- DELETE BUDM_UOR.UOR_DET_EMPLOYEE_ASUP; --variant 2

  INSERT INTO BUDM_UOR.UOR_DET_EMPLOYEE_ASUP 
  SELECT 
	BDE.CODE             	AS CODE, 
	BDE.Surname          	AS SURNAME, 
	BDE.NAME             	AS NAME, 
	BDE.SECOND_NAME      	AS SECOND_NAME, 
	BDD.CODE,            	AS CODE_DEPARTMENT,
	BDD.ID_DEPARTMENT    	AS ID_DEPARTMENT, 
	BDD.Name_Department  	AS NAME_DEPARTMENT, 
	AED.CODE_POSITION    	AS CODE_POSITION, 
	AED.Name_Position    	AS NAME_POSITION, 
	AED.IS_MANAGERPOSITION  AS IS_MANAGER, 
	AED.DT_FIRE             AS DT_FIRE, 
	BDSC.CONTACT_FULL       AS DSC_MAIL	
  FROM BMRT.BM_DET_EMPLOYEE BDE
  INNER JOIN BMRT.BM_ASS_EMPLOYEE_DEPARTMENT AED on BDE.ID_EMPLOYEE=AED.ID_EMPLOYEE
  INNER JOIN BMRT.BM_DET_DEPARTMENT BDD on BDD.ID_DEPARTMENT = AED.ID_DEPARTMENT
  INNER JOIN BMRT.BM_ASS_SUBJECT BAS on BAS.ID_SUBJECT_LINKED = BDE.ID_EMPLOYEE
  INNER JOIN BMRT.BM_DET_SUBJECT_CONTACT BDSC on BDSC.ID_SUBJECT=BAS.ID_SUBJECT
  WHERE UPPER(BDD.CODE) LIKE 'ASUP#%';
   	AND DT_TO >= p_date;


  COMMIT; 

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_DET_EMPLOYEE_ASUP)
  WHERE ID_LOG = v_id_log;

  COMMIT;

END LOAD_UOR_DET_EMPLOYEE_ASUP;


PROCEDURE LOAD_UOR_FCT_STAFFTURNOVER 
			(
			p_date IN DATE  -- dt_to
			)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_FCT_STAFFTURNOVER';
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;

	
  OR_LOG( P_ID_LOG    => v_id_log,
	      P_DATA1    => null,
	      P_DATA2       => p_date,
	      P_NAME_PROC => v_name_proc,
	      P_ROW_COUNT => v_row_count
	     );
	         
  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_FCT_STAFFTURNOVER';
	--- DELETE BUDM_UOR.UOR_FCT_STAFFTURNOVER; --variant 2
	
  INSERT INTO BUDM_UOR.UOR_FCT_STAFFTURNOVER
  SELECT * FROM BMRT.BM_ FCT_STAFFTURNOVER;
	
  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_FCT_STAFFTURNOVER)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;
		
END LOAD_UOR_FCT_STAFFTURNOVER;






PROCEDURE LOAD_UOR_ FCT_ASCEVENT 
			(
			p_date IN DATE   -- dt_to
			)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_ FCT_ASCEVENT'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;


  OR_LOG( P_ID_LOG    => v_id_log, 
	      P_DATA1    => null,
	      P_DATA2       => p_date,
	      P_NAME_PROC => v_name_proc,
	      P_ROW_COUNT => v_row_count
	      );
	         
  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_ FCT_ASCEVENT';
	--- DELETE BUDM_UOR.UOR_ FCT_ASCEVENT; --variant 2
	
  INSERT INTO BUDM_UOR.UOR_FCT_ASCEVENT
  SELECT * FROM BMRT.BM_FCT_ASCEVENT;

  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_ FCT_ASCEVENT)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;

		
END LOAD_UOR_ FCT_ASCEVENT;



PROCEDURE LOAD_UOR_FCT_EMPLOYEEABSCENE 
			(
			p_date IN DATE   -- dt_to
			)
			
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_FCT_EMPLOYEEABSCENE'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;


  OR_LOG( P_ID_LOG    => v_id_log, 
	      P_DATA1    => null,
	      P_DATA2       => p_date,
	      P_NAME_PROC => v_name_proc,
	      P_ROW_COUNT => v_row_count
	     );
	         
  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_FCT_ASCEVENT';
	--- DELETE BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE; --variant 2
	
  INSERT INTO BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE
  SELECT * FROM BMRT.BM_FCT_EMPLOYEEABSCENE

  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;

		
END LOAD_UOR_FCT_EMPLOYEEABSCENE;



PROCEDURE LOAD_UOR_DET_DET_DEPARTMENT
				(
				p_date IN DATE  -- dt_to
				)
IS
  v_name_proc varchar2(50);
  v_row_count number;
  v_id_log number;

BEGIN 
  v_name_proc := 'LOAD_UOR_BM_DET_DEPARTMENT'; 
  v_row_count := 0;
  v_id_log := SEQ_OPER_LOG.NEXTVAL;


  OR_LOG( P_ID_LOG    => v_id_log, 
	      P_DATA1    => null,
	      P_DATA2       => p_date,
	      P_NAME_PROC => v_name_proc,
	      P_ROW_COUNT => v_row_count
	     );
	 
  EXECUTE IMMEDIATE 'truncate table BUDM_UOR.UOR_BM_DET_DEPARTMENT';
	--- DELETE BUDM_UOR.UOR_BM_DET_DEPARTMENT; --variant 2

  INSERT INTO BUDM_UOR.UOR_BM_DET_DEPARTMENT
	
  select 
  BDD.Code                                        
  BDD.NAME_DEPARTMENT           
  BDO.NAME                      
  BDD_PARENT.CODE                
  BDD_PARENT.Name_Department     
  BDO3.NAME                      
  BDD.CODE_DEPARTMENTTYPE        
  BDO4.NAME                   
  from BMRT.Bm_Det_Department BDD
  inner join BMRT.BM_ASS_SUBJECT BAS on BAS.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
  inner join BMRT.Bm_Det_Subject BDS on BDS.ID_SUBJECT = BAS.ID_SUBJECT
  inner join BMRT.Bm_Fct_Subject_Attr BFSA on BFSA.ID_SUBJECT = BDS.ID_SUBJECT
  inner join BMRT.Bm_Det_Objectattr BDO on BDO.ID_OBJECTATTR = BFSA.ID_OBJECTATTR

  inner join BMRT.BM_ASS_SUBJECT BAS2 on BAS2.ID_SUBJECT = BDD.ID_DEPARTMENT
  inner join BMRT.Bm_Det_Department BDD_PARENT on BDD_PARENT.ID_DEPARTMENT = BAS2.ID_SUBJECT_LINKED

  inner join BMRT.BM_ASS_SUBJECT BAS3 on BAS3.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
  inner join BMRT.Bm_Det_Subject BDS3 on BDS3.ID_SUBJECT = BAS3.ID_SUBJECT
  inner join BMRT.Bm_Fct_Subject_Attr BFSA3 on BFSA3.ID_SUBJECT = BDS3.ID_SUBJECT
  inner join BMRT.Bm_Det_Objectattr BDO3 on BDO3.ID_OBJECTATTR = BFSA3.ID_OBJECTATTR

  inner join BMRT.BM_ASS_SUBJECT BAS4 on BAS4.ID_SUBJECT_LINKED = BDD.ID_DEPARTMENT
  inner join BMRT.Bm_Det_Subject BDS4 on BDS4.ID_SUBJECT = BAS4.ID_SUBJECT
  inner join BMRT.Bm_Fct_Subject_Attr BFSA4 on BFSA4.ID_SUBJECT = BDS4.ID_SUBJECT
  inner join BMRT.Bm_Det_Objectattr BDO4 on BDO4.ID_OBJECTATTR = BFSA4.ID_OBJECTATTR
  --inner join BMRT.BM_DET_DEPARTMENTTYPE  BDDT on BDDT.ID_CLVALUE = BDD.ID_DEPARTMENTTYPE
  where upper(BDO.CODE) like ('%RDM#SUBJECT_ATTR#VSP_NAME_SHORT#JURIDICPERSON#BANK%') 
   	and upper(BDO3.CODE) like ('%RDM#SUBJECT_ATTR#VSP_ASUP_FIL#JURIDICPERSON#BANK%')
   	and upper(BDO3.CODE) like ('%RDM#SUBJECT_ATTR#VSP_CODE_BALANCE#JURIDICPERSON#BANK%')
	
   		
  COMMIT;

  UPDATE BUDM_UOR_TMD.OR_LOG_TMD
  SET END_DATE = SYSTIMESTAMP,
	  ROW_COUNT = (select count(*)
	               from BUDM_UOR.UOR_BM_DET_DEPARTMENT)
  WHERE ID_LOG = v_id_log;
	
  COMMIT;
	 

END LOAD_UOR_DET_DET_DEPARTMENT;




PROCEDURE OR_LOG(P_ID_LOG IN NUMBER,
                 P_DATA1 IN DATE,
                 P_DATA2 in DATE,
                 P_NAME_PROC IN VARCHAR2,
                 P_ROW_COUNT IN NUMBER
                )
IS
BEGIN

  INSERT INTO BUDM_UOR.OR_LOG_TMD(ID_LOG,
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


END DM_LOADER_UOR_ASUOR;





