
alter table maps alter column id set DEFAULT nextval('maps_id_seq'::regclass);
alter table links alter column id set DEFAULT nextval('links_id_seq'::regclass);
