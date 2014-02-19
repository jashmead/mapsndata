drop table data_sets;

CREATE SEQUENCE data_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.data_sets_id_seq OWNER TO mapsndata;


CREATE TABLE data_sets (
    id integer DEFAULT nextval('data_sets_id_seq'::regclass) NOT NULL,
    data_set_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	url url_t,
	columns json[],
	rowes json[],
	cells json[][]
);

comment on column data_sets.rowes is 'weird spelling to avoid clash with PostgreSQL key word rows';
comment on column data_sets.columns is 'do not seem to be able to use column_t domain here';
comment on column data_sets.cells is 'do not seem to be able to use cell_t domain here';

ALTER TABLE public.data_sets OWNER TO mapsndata;

ALTER TABLE ONLY data_sets
    ADD CONSTRAINT data_sets_pkey PRIMARY KEY (id);
--
-- Name: data_sets_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER data_sets_update_trg BEFORE UPDATE ON data_sets FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: data_sets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY data_sets
    ADD CONSTRAINT data_sets_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: data_sets_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY data_sets
    ADD CONSTRAINT data_sets_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;





