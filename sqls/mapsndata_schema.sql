--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

--
-- Name: attribute_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN attribute_t AS hstore;


ALTER DOMAIN public.attribute_t OWNER TO mapsndata;

--
-- Name: cell_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN cell_t AS json;


ALTER DOMAIN public.cell_t OWNER TO mapsndata;

--
-- Name: column_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN column_t AS json;


ALTER DOMAIN public.column_t OWNER TO mapsndata;

--
-- Name: datetime_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN datetime_t AS timestamp without time zone NOT NULL DEFAULT now();


ALTER DOMAIN public.datetime_t OWNER TO mapsndata;

--
-- Name: desc_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN desc_t AS text;


ALTER DOMAIN public.desc_t OWNER TO mapsndata;

--
-- Name: email_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN email_t AS character varying(256);


ALTER DOMAIN public.email_t OWNER TO mapsndata;

--
-- Name: path_name_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN path_name_t AS character varying(256);


ALTER DOMAIN public.path_name_t OWNER TO mapsndata;

--
-- Name: row_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN row_t AS json;


ALTER DOMAIN public.row_t OWNER TO mapsndata;

--
-- Name: title_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN title_t AS character varying(256);


ALTER DOMAIN public.title_t OWNER TO mapsndata;

--
-- Name: type_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN type_t AS character varying(64) NOT NULL DEFAULT ''::character varying;


ALTER DOMAIN public.type_t OWNER TO mapsndata;

--
-- Name: url_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN url_t AS character varying(128);


ALTER DOMAIN public.url_t OWNER TO mapsndata;

--
-- Name: user_id_t; Type: DOMAIN; Schema: public; Owner: mapsndata
--

CREATE DOMAIN user_id_t AS bigint NOT NULL DEFAULT 1;


ALTER DOMAIN public.user_id_t OWNER TO mapsndata;

--
-- Name: link_check(); Type: FUNCTION; Schema: public; Owner: mapsndata
--

CREATE FUNCTION link_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
declare 
	table1 character varying(64);
	count1 int;
begin
	/*
		do we care if the link points to itself?
			-- may be useful, actually
	*/
	table1 := new.from_table_name;
	execute 'select count(*) from ' || table1 || ' where id = $1 '
		into strict count1 using new.from_table_id;
	if count1 != 1 then
		raise exception 'Link''s from table % is invalid', table1
			using hint = 'Please notify support';
	end if;

	table1 := new.to_table_name;
	execute 'select count(*) from ' || table1 || ' where id = $1 '
		into strict count1 using new.to_table_id;
	if count1 != 1 then
		raise exception 'Link''s to table % is invalid', table1
			using hint = 'Please notify support';
	end if;

	RETURN NEW;
END;
$_$;


ALTER FUNCTION public.link_check() OWNER TO mapsndata;

--
-- Name: link_delete(); Type: FUNCTION; Schema: public; Owner: mapsndata
--

CREATE FUNCTION link_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	/*
		should we delete the 'to' row if this is the last link to it?
	*/
	delete from links where 
		( from_table_name = TG_TABLE_NAME and from_table_id = old.id ) or
		( to_table_name = TG_TABLE_NAME and to_table_id = old.id );
	RETURN OLD;

END;
$$;


ALTER FUNCTION public.link_delete() OWNER TO mapsndata;

--
-- Name: updated_on_func(); Type: FUNCTION; Schema: public; Owner: mapsndata
--

CREATE FUNCTION updated_on_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.updated_on := current_timestamp;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.updated_on_func() OWNER TO mapsndata;

--
-- Name: controls_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE controls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.controls_id_seq OWNER TO mapsndata;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: controls; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE controls; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE controls IS 'manage controls per map';


--
-- Name: data_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE data_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_sets_id_seq OWNER TO mapsndata;

--
-- Name: data_sets; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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
    cells json[]
);


ALTER TABLE public.data_sets OWNER TO mapsndata;

--
-- Name: TABLE data_sets; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE data_sets IS '3rd simplest possible datasource: stores table for use in charts and so on';


--
-- Name: COLUMN data_sets.columns; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON COLUMN data_sets.columns IS 'do not seem to be able to use column_t domain here';


--
-- Name: COLUMN data_sets.rowes; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON COLUMN data_sets.rowes IS 'weird spelling to avoid clash with PostgreSQL key word rows';


--
-- Name: COLUMN data_sets.cells; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON COLUMN data_sets.cells IS 'do not seem to be able to use cell_t domain here';


--
-- Name: geographics_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE geographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geographics_id_seq OWNER TO mapsndata;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_id_seq OWNER TO mapsndata;

--
-- Name: images; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE images; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE images IS 'manage images & their file system storage; will need appropriate triggers';


--
-- Name: layers_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE layers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layers_id_seq OWNER TO mapsndata;

--
-- Name: layers; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE layers; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE layers IS 'a place holder to let you arbitrarily nest maps & other structures';


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE links_id_seq
    START WITH 3000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO mapsndata;

--
-- Name: links; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

CREATE TABLE links (
    id integer DEFAULT nextval('links_id_seq'::regclass) NOT NULL,
    link_type type_t DEFAULT ''::character varying NOT NULL,
    comment title_t,
    created_on datetime_t,
    updated_on datetime_t,
    attributes attribute_t,
    from_table_name character varying(64) DEFAULT 'maps'::character varying NOT NULL,
    from_table_id bigint NOT NULL,
    to_table_name character varying DEFAULT 'points'::character varying NOT NULL,
    to_table_id bigint NOT NULL
);


ALTER TABLE public.links OWNER TO mapsndata;

--
-- Name: TABLE links; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE links IS 'manage linkages between map to source linkages as well as other, more complex';


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lists_id_seq OWNER TO mapsndata;

--
-- Name: lists; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE lists; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE lists IS '2nd simplest possible datasource';


--
-- Name: maps_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE maps_id_seq
    START WITH 3000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.maps_id_seq OWNER TO mapsndata;

--
-- Name: maps; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

CREATE TABLE maps (
    id integer DEFAULT nextval('maps_id_seq'::regclass) NOT NULL,
    map_type type_t DEFAULT ''::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    created_by user_id_t,
    updated_on datetime_t,
    updated_by user_id_t,
    attributes attribute_t,
    description desc_t
);


ALTER TABLE public.maps OWNER TO mapsndata;

--
-- Name: TABLE maps; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE maps IS 'main table of database';


--
-- Name: COLUMN maps.map_type; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON COLUMN maps.map_type IS 'add in a check constraint when the set of allowed map types has started to sort itself out';


--
-- Name: points_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.points_id_seq OWNER TO mapsndata;

--
-- Name: points; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE points; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE points IS 'simplest possible datasource';


--
-- Name: users; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    user_type type_t DEFAULT 'USER'::character varying NOT NULL,
    name name NOT NULL,
    title title_t,
    created_on datetime_t,
    updated_on datetime_t,
    attributes attribute_t,
    email email_t NOT NULL,
    description desc_t,
    CONSTRAINT check_user_type CHECK (((user_type)::text = ANY ((ARRAY['ANON'::character varying, 'USER'::character varying, 'ADMIN'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO mapsndata;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE users IS 'only drug dealers and programmers refer to the clients as users';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO mapsndata;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapsndata
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: viewpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: mapsndata
--

CREATE SEQUENCE viewpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.viewpoints_id_seq OWNER TO mapsndata;

--
-- Name: viewpoints; Type: TABLE; Schema: public; Owner: mapsndata; Tablespace: 
--

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

--
-- Name: TABLE viewpoints; Type: COMMENT; Schema: public; Owner: mapsndata
--

COMMENT ON TABLE viewpoints IS 'how to look at a map';


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: controls_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY controls
    ADD CONSTRAINT controls_pkey PRIMARY KEY (id);


--
-- Name: data_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY data_sets
    ADD CONSTRAINT data_sets_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: layers_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: lists_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: maps_name_key; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_name_key UNIQUE (name);


--
-- Name: maps_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_pkey PRIMARY KEY (id);


--
-- Name: points_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: viewpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: mapsndata; Tablespace: 
--

ALTER TABLE ONLY viewpoints
    ADD CONSTRAINT viewpoints_pkey PRIMARY KEY (id);


--
-- Name: controls_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER controls_trg_link_delete BEFORE DELETE ON controls FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: controls_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER controls_update_trg BEFORE UPDATE ON controls FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: data_sets_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER data_sets_trg_link_delete BEFORE DELETE ON data_sets FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: data_sets_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER data_sets_update_trg BEFORE UPDATE ON data_sets FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: images_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER images_trg_link_delete BEFORE DELETE ON images FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: images_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER images_update_trg BEFORE UPDATE ON images FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: layers_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER layers_trg_link_delete BEFORE DELETE ON layers FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: layers_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER layers_update_trg BEFORE UPDATE ON layers FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: link_trg_1_validate; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER link_trg_1_validate BEFORE INSERT OR UPDATE ON links FOR EACH ROW EXECUTE PROCEDURE link_check();


--
-- Name: link_trg_2_updated; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER link_trg_2_updated BEFORE UPDATE ON links FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: links_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER links_trg_link_delete BEFORE DELETE ON links FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: lists_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER lists_trg_link_delete BEFORE DELETE ON lists FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: lists_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER lists_update_trg BEFORE UPDATE ON lists FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: map_updated_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER map_updated_trg BEFORE UPDATE ON maps FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: maps_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER maps_trg_link_delete BEFORE DELETE ON maps FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: points_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER points_trg_link_delete BEFORE DELETE ON points FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: points_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER points_update_trg BEFORE UPDATE ON points FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: user_updated_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER user_updated_trg BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


--
-- Name: users_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER users_trg_link_delete BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: viewpoints_trg_link_delete; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER viewpoints_trg_link_delete BEFORE DELETE ON viewpoints FOR EACH ROW EXECUTE PROCEDURE link_delete();


--
-- Name: viewpoints_update_trg; Type: TRIGGER; Schema: public; Owner: mapsndata
--

CREATE TRIGGER viewpoints_update_trg BEFORE UPDATE ON viewpoints FOR EACH ROW EXECUTE PROCEDURE updated_on_func();


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


--
-- Name: maps_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: maps_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapsndata
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


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


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

