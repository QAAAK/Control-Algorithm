--- КОММЕНТЫ

COMMENT ON TABLE BUDM_UOR.UOR_DET_EMPLOYEE IS 'Данные о работниках';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.CODE IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.SURNAME IS 'Фамилия';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.NAME IS 'Имя';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.SECOND_NAME IS 'Отчество';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.CODE_DEPARTMENT IS 'Идентификатор подразделения АСУП, в котором работник работает';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.ID_DEPARTMENT IS 'Подраздел персонала';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.NAME_DEPARTMENT IS 'Наименование подраздела персонала';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.CODE_POSITION IS 'Код штатной должности';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.NAME_POSITION IS 'Наименование штатной должности';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.IS_MANAGER IS 'Признак руководителя';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.DT_FIRE IS 'Дата увольнения';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.DSC_EMAIL IS 'Электронная почта в формате хххх@rshb.ru';
COMMENT ON COLUMN BUDM_UOR.UOR_DET_EMPLOYEE.DTTM_INSERT IS 'Определяется как Дата и время расчета витрины';


COMMENT ON TABLE  BUDM_UOR.UOR_BM_DET_DEPARTMENT IS 'Организационно-штатная структура';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE IS 'Уникальный идентификатор подразделения АСУП';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.NAME_DEPARTMENT IS 'Полное наименование подразделения';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE_ABBRV IS 'Код подразделения/Аббревиатура';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE_PARENT IS 'Идентификатор выше-стоящего подразделения АСУП. Null для верхнеуровневых подразделений.';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE_ASUP_FIL IS 'Филиал';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE_TYPE_DEPARTMENT IS 'Тип подразделения идентификатора объекта (РФ/ГО)';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.CODE_BALANCE IS 'Код балансовой единицы';
COMMENT ON COLUMN BUDM_UOR.UOR_BM_DET_DEPARTMENT.DTTM_INSERT IS 'Определяется как Дата и время расчета витрины';

COMMENT ON TABLE  BUDM_UOR.UOR_FCT_STAFFTURNOVER IS 'Текучесть персонала';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.YEAR IS 'Календарный год';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.QUARTER IS 'Календарный квартал';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.CODE_DEPARTMENT IS 'Идентификатор подразделения АСУП';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.NAME_DEPARTMENT IS 'Полное наименование подразделения';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.MANNINGTABLE_START IS 'Штатная численность начало периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.MANNINGTABLE_END IS 'Штатная численность конец периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.MANNINGTABLE_CHANGE IS 'Штатная численность изменения';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.EMPLOYEES_COUNT_START IS 'Фактическая численность начало периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.EMPLOYEES_COUNT_END IS 'Фактическая численность конец периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.EMPLOYEES_COUNT_CHANGE IS 'Фактическая численность изменения';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.HEADCOUNT_START IS 'Списочная численность начало периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.HEADCOUNT_END IS 'Списочная численность конец периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.HEADCOUNT_CHANGE IS 'Списочная численность изменения';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.AVG_HEADCOUNT IS 'Среднесписочная численность за период';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.AVG_HEADCOUNT_MANAGER IS 'Среднесписочная численность  в т.ч.руководителей';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.AVG_HEADCOUNT_SPECIALIST IS 'Среднесписочная численность в т.ч. специалистов';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.VACANCY_START IS 'Количество вакансий начало периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.VACANCY_END IS 'Количество вакансий конец периода';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.HIRED IS 'Принято за период всего';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.HIRED_MANAGER IS 'Принято за период в т.ч. руководителей';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.FIRED IS 'Уволено за период всего';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.FIRED_MANAGER IS 'Уволено за период в т.ч. руководителей';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.TURNOVER IS 'Текучесть за период';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.TURNOVER_MANAGER IS 'Текучесть в т.ч.руководителей';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.TURNOVER_SPECIALIST IS 'Текучесть в т.ч. специалистов';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_STAFFTURNOVER.DTTM_INSERT IS 'Определяется как Дата и время расчета витрины';


COMMENT ON TABLE BUDM_UOR.UOR_FCT_ASCEVENT IS 'Данные о входах и выходах работников (СКУД)';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_ASCEVENT.CODE_EMPLOYEE IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_ASCEVENT.DT IS 'Дата в формате ГГГГММДД';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_ASCEVENT.TIME IS 'Время в формате ЧЧММСС';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_ASCEVENT.CODE_ASCEVENTTYPE IS 'Вид временного события';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_ASCEVENT.DTTM_INSERT IS 'Определяется как Дата и время расчета витрины';


COMMENT ON TABLE BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE IS 'Таблица отсутствия работников';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.CODE_EMPLOYEE IS 'Уникальный идентификатор работника АСУП';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.CODE_EMPLOYEEABSCENEKIND IS 'Вид отсутствия';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.IS_BLOCKED IS 'Индикатор блокирования';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.DATE_START_PERIOD IS 'Дата начала' ;
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.DATE_END_PERIOD IS 'Дата окончания';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.NAME_EMPLOYEEABSCENEKIND IS 'Наименование отсутствия';
COMMENT ON COLUMN BUDM_UOR.UOR_FCT_EMPLOYEEABSCENE.DTTM_INSERT IS 'Определяется как Дата и время расчета витрины';