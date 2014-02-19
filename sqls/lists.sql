drop table lists;

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.lists_id_seq OWNER TO mapsndata;


CREATE TABLE lists (
    id integer DEFAULT nextval('lists_id_seq'::regclass) NOT NULL,
    list_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	cells json[]
);


ALTER TABLE public.lists OWNER TO mapsndata;

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
--
-- Name: lists_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER lists_update_trg BEFORE UPDATE ON lists FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: lists_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: lists_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;





