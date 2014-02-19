drop table controls;

CREATE SEQUENCE controls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.controls_id_seq OWNER TO mapsndata;

CREATE TABLE controls (
    id integer DEFAULT nextval('controls_id_seq'::regclass) NOT NULL,
    control_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	control_data json
);


ALTER TABLE public.controls OWNER TO mapsndata;

ALTER TABLE ONLY controls
    ADD CONSTRAINT controls_pkey PRIMARY KEY (id);
--
-- Name: controls_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER controls_update_trg BEFORE UPDATE ON controls FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: controls_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY controls
    ADD CONSTRAINT controls_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: controls_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY controls
    ADD CONSTRAINT controls_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

