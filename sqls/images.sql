drop table images;

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.images_id_seq OWNER TO mapsndata;

CREATE TABLE images (
    id integer DEFAULT nextval('images_id_seq'::regclass) NOT NULL,
    image_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	path_name path_name_t
);


ALTER TABLE public.images OWNER TO mapsndata;

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);
--
-- Name: images_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER images_update_trg BEFORE UPDATE ON images FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: images_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: images_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


