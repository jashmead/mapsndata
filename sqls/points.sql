/*
	points.sql -- points is the most primitive data source
		-- but still include a url,
		-- description can be a text area
*/
drop table points;

CREATE SEQUENCE points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.points_id_seq OWNER TO mapsndata;

CREATE TABLE points (
    id integer DEFAULT nextval('points_id_seq'::regclass) NOT NULL,
    point_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t,
	url url_t
);


ALTER TABLE public.points OWNER TO mapsndata;

ALTER TABLE ONLY points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
--
-- Name: points_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER points_update_trg BEFORE UPDATE ON points FOR EACH ROW EXECUTE PROCEDURE updated_on_func();
--
-- Name: points_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: points_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

