CREATE OR REPLACE package BUDM_UOR_TMD.DM_LOADER_BUDM_UOR_ASUOR
AS
/***********************************************************************************/
/* Наименование объекта: DM_LOADER_ASUOR
/* Назначение объекта: проводки
/* Основание для реализации: < BIQ-15733> */
/* История изменений объекта:
/*  25.12.2023 Создал Санталов Д.В. РСХБ-ИНТЕХ SantalovDV@intech.rshb.ru
/***********************************************************************************/

 --результат - выгрузка в таблицу BUDM_UOR.UOR_DET_EMPLOYEE
-- PROCEDURE LOAD_UOR_DET_EMPLOYEE -- Данные о работниках
--                       (
--                        p_date in date  -- Дата С
--                        );

 --результат - выгрузка в таблицу BUDM_UOR.UOR_FCT_STAFFTURNOVER
 PROCEDURE LOAD_UOR_FCT_STAFFTURNOVER -- Организационно-штатная структура
	                     (
	                        p_date  in date  -- Дата С
	                     );

-- результат - выгрузка в таблицу BUDM_UOR.UOR_FCT_ASCEVENT
 PROCEDURE LOAD_UOR_FCT_ASCEVENT -- Текучесть персонала
						(
						p_date IN date -- Дата С
						);


-- результат - выгрузка в таблицу BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE               
 PROCEDURE LOAD_UOR_FCT_EMPLOYEEABSCENE -- Данные о входах и выходах работников (СКУД)
						(
						p_date IN DATE   -- Дата С
						);

		
 -- результат - выгрузка в таблицу BUDM_UOR.UOR_DET_DET_DEPARTMENT
-- PROCEDURE LOAD_UOR_BM_DET_DEPARTMENT -- Таблица отсутствия работников
--						(
--						p_date IN DATE  -- Дата С
--						);
			

			
-- результат - логгирование процедур в таблицу BUDM_UOR_TMD.OR_LOG_TMD		
  procedure OR_LOG(P_ID_LOG IN NUMBER,
                  P_DATA1 IN DATE,
                  P_DATA2 IN DATE,
                  P_NAME_PROC IN VARCHAR2,
                  P_ROW_COUNT IN NUMBER
                  );
END DM_LOADER_BUDM_UOR_ASUOR;