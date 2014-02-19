CREATE or replace FUNCTION updated_on_func() RETURNS trigger AS $updated_on_func$
BEGIN
	NEW.updated_on := current_timestamp;
	RETURN NEW;
END;
$updated_on_func$ LANGUAGE plpgsql;
