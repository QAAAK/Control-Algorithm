-- comments view
COMMENT ON TABLE  EDM_UOR.UOR_DET_EMPLOYEE IS 'Данные о работниках';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.em_id  IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.surname is 'Фамилия';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.lname IS 'Имя';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.patronymic IS 'Отчество';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.sub_id  IS 'Идентификатор подразделения АСУП, в котором работник работает';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.employee_subsection_code IS 'Подраздел персонала';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.employee_subsection_name IS 'Наименование под-раздела персонала';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.post_id IS 'Код штатной должности';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.post_name IS 'Наименование штатной должности';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.is_ruk is 'Признак руководителя';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.fire_date IS 'Дата увольнения';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.email  IS 'Электронная почта в формате хххх@rshb.ru';
COMMENT ON COLUMN EDM_UOR.UOR_DET_EMPLOYEE.upload_date IS 'Дата выгрузки данных';

COMMENT ON TABLE  EDM_UOR.UOR_BM_DET_DEPARTMENT IS 'Организационно-штатная структура';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.sub_id IS 'Уникальный идентификатор подразделения АСУП';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.lname is 'Полное наименование подразделения';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.abbrv IS 'Код подразделения/Аббревиатура';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.parent_id IS 'Идентификатор вышестоящего подразделения АСУП. Null для верхнеуровневых подразделений.';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.root_id IS 'Филиал';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.sub_type is 'Тип подразделения идентификатора объекта (РФ/ГО)';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.balance_code IS 'Код балансовой единицы';
COMMENT ON COLUMN EDM_UOR.UOR_BM_DET_DEPARTMENT.upload_date is 'Дата выгрузки данных';

COMMENT ON TABLE EDM_UOR.UOR_FCT_STAFFTURNOVER IS 'Текучесть персонала';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.YEAR IS 'Календарный год';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.quarter IS 'Календарный квартал';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.sub_id IS 'Идентификатор подразделения АСУП';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.sub_name IS 'Полное наименование подразделения';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.shtat_begda IS 'Штатная численность начало периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.shtat_enddate IS 'Штатная численность конец периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.shtat_delta IS 'Штатная численность изменения';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.fact_begda IS 'Фактическая численность начало периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.fact_endda IS 'Фактическая численность конец периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.fact_delta IS 'Фактическая численность изменения';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.spis_begda IS 'Списочная численность начало периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.spis_endda IS 'Списочная численность конец периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.spis_delta IS 'Списочная численность изменения';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.sredn_spis_all IS 'Среднесписочная численность за период';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.sredn_spis_top IS 'Среднесписочная численность  в т.ч.руководителей';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.sredn_spis_spc IS 'Среднесписочная численность в т.ч. специалистов';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.vac_begda IS 'Количество вакансий начало периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.vac_enddda IS 'Количество вакансий конец периода';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.acc_all IS 'Принято за период всего';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.acc_top IS 'Принято за период в т.ч. руководителей';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.fire_all IS 'Уволено за период всего';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.fire_top IS 'Уволено за период в т.ч. руководителей';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.turn_all IS 'Текучесть за период' ;
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.turn_top IS 'Текучесть в т.ч.руководителей';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.turn_spc IS 'Текучесть в т.ч. специалистов';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_STAFFTURNOVER.REPORT_DATE  IS 'Дата выгрузки данных';

COMMENT ON TABLE EDM_UOR.UOR_FCT_ASCEVENT IS 'Данные о входах и выходах работников (СКУД)';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_ASCEVENT.em_id IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_ASCEVENT.ldate IS 'Дата в формате ГГГГММДД';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_ASCEVENT.ltime IS 'Время в формате ЧЧММСС';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_ASCEVENT.ltype IS 'Вид временного события';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_ASCEVENT.upload_date IS 'Дата выгрузки данных';

COMMENT ON TABLE EDM_UOR.UOR_FCT_EMPLOYEEABSCENE IS 'Таблица отсутствия работников';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.em_id IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.absence_type IS 'Вид отсутствия';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.is_block IS 'Индикатор блокирования';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.begin_date IS 'Дата начала' ;
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.end_date IS 'Дата окончания';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.lname IS 'Наименование отсутствия';
COMMENT ON COLUMN EDM_UOR.UOR_FCT_EMPLOYEEABSCENE.upload_date IS 'Дата и время выгрузки данных';




