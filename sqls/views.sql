drop table viewpoints;

CREATE SEQUENCE viewpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.viewpoints_id_seq OWNER TO mapsndata;

CREATE TABLE viewpoints (
    id integer DEFAULT nextval('viewpoints_id_seq'::regclass) NOT NULL,
    viewpoint_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	viewpoint_data json
);


ALTER TABLE public.viewpoints OWNER TO mapsndata;

ALTER TABLE ONLY viewpoints
    ADD CONSTRAINT viewpoints_pkey PRIMARY KEY (id);
--
-- Name: viewpoints_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER viewpoints_update_trg BEFORE UPDATE ON viewpoints FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: viewpoints_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY viewpoints
    ADD CONSTRAINT viewpoints_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: viewpoints_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY viewpoints
    ADD CONSTRAINT viewpoints_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


