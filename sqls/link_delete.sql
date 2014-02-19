CREATE or replace FUNCTION link_delete() RETURNS trigger AS $link_delete$
begin
	/*
		should we delete the 'to' row if this is the last link to it?
	*/
	delete from links where 
		( from_table_name = TG_TABLE_NAME and from_table_id = old.id ) or
		( to_table_name = TG_TABLE_NAME and to_table_id = old.id );
	RETURN OLD;

END;
$link_delete$ LANGUAGE plpgsql;
