
--- когда происходит операция над ecm_task, обновляет таблицу ee_stg_md


create trigger trigger_ini
	after update 
	on meta_info.ecm_task 
	for each row
  	EXECUTE PROCEDURE meta_info.triggers_ini();



create or replace function meta_info.triggers_ini()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE
AS $$


begin 	
	if new.status = 1 or new.status = -1
		then 
			update meta_info.ee_stg_md set last_load_status = 'READY'
			where id = 1;
	elsif new.status = 5
		then 
			update meta_info.ee_stg_md set last_load_status = 'SUCCESFUL'
			where id = 1;
	end if;
	return new;
end;



$$
EXECUTE ON ANY;






