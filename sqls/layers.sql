drop table layers;

CREATE SEQUENCE layers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.layers_id_seq OWNER TO mapsndata;

CREATE TABLE layers (
    id integer DEFAULT nextval('layers_id_seq'::regclass) NOT NULL,
    layer_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t
);


ALTER TABLE public.layers OWNER TO mapsndata;

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);
--
-- Name: layers_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER layers_update_trg BEFORE UPDATE ON layers FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: layers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: layers_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

