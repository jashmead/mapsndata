drop table geographics;

CREATE SEQUENCE geographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.geographics_id_seq OWNER TO mapsndata;

CREATE TABLE geographics (
    id integer DEFAULT nextval('geographics_id_seq'::regclass) NOT NULL,
    geograph_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	geograph geometry
);


ALTER TABLE public.geographics OWNER TO mapsndata;

ALTER TABLE ONLY geographics
    ADD CONSTRAINT geographics_pkey PRIMARY KEY (id);
--
-- Name: geographics_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER geographics_update_trg BEFORE UPDATE ON geographics FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: geographics_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY geographics
    ADD CONSTRAINT geographics_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: geographics_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY geographics
    ADD CONSTRAINT geographics_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


