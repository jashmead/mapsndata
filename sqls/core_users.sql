/*
	only run this during startup!
*/
truncate users;

INSERT INTO "public"."users" ("id","type","name","title","created_by","updated_by", "email", "description")
	VALUES (1,'ANON','anonymous','Anonymous','1','1', 'anonymous@mapsndata.com', 'Anonymous User');

INSERT INTO "public"."users" ("id","type","name","title","created_by","updated_by", "email", "description")
	VALUES (2,'ADMIN','jashmead','John Ashmead','1','1', 'john.ashmead@mapsndata.com', 'Developer');

INSERT INTO "public"."users" ("id","type","name","title","created_by","updated_by", "email", "description")
	VALUES (3,'USER','jrandomuser','J Random User','1','1', 'jrandomuser@mapsndata.com', 'Typical user, used for testing and examples');

/*
CREATE SEQUENCE users_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;
*/

