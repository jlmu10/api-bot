--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)

-- Started on 2024-06-24 11:41:35 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 16385)
-- Name: insumo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA insumo;


ALTER SCHEMA insumo OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 16387)
-- Name: direccion; Type: TABLE; Schema: insumo; Owner: postgres
--

CREATE TABLE insumo.direccion (
    id_gerencia integer NOT NULL,
    direccion character varying(50)
);


ALTER TABLE insumo.direccion OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16386)
-- Name: direccion_id_gerencia_seq; Type: SEQUENCE; Schema: insumo; Owner: postgres
--

CREATE SEQUENCE insumo.direccion_id_gerencia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE insumo.direccion_id_gerencia_seq OWNER TO postgres;

--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 210
-- Name: direccion_id_gerencia_seq; Type: SEQUENCE OWNED BY; Schema: insumo; Owner: postgres
--

ALTER SEQUENCE insumo.direccion_id_gerencia_seq OWNED BY insumo.direccion.id_gerencia;


--
-- TOC entry 212 (class 1259 OID 16393)
-- Name: personal; Type: TABLE; Schema: insumo; Owner: postgres
--

CREATE TABLE insumo.personal (
    cedula character varying(9) NOT NULL,
    pass character varying(256) NOT NULL,
    id_gerencia integer NOT NULL,
    baneado boolean NOT NULL,
    suspendido boolean NOT NULL,
    busqueda tsvector
);


ALTER TABLE insumo.personal OWNER TO postgres;

--
-- TOC entry 3252 (class 2604 OID 16390)
-- Name: direccion id_gerencia; Type: DEFAULT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.direccion ALTER COLUMN id_gerencia SET DEFAULT nextval('insumo.direccion_id_gerencia_seq'::regclass);


--
-- TOC entry 3401 (class 0 OID 16387)
-- Dependencies: 211
-- Data for Name: direccion; Type: TABLE DATA; Schema: insumo; Owner: postgres
--

COPY insumo.direccion (id_gerencia, direccion) FROM stdin;
1	UTD
\.


--
-- TOC entry 3402 (class 0 OID 16393)
-- Dependencies: 212
-- Data for Name: personal; Type: TABLE DATA; Schema: insumo; Owner: postgres
--

COPY insumo.personal (cedula, pass, id_gerencia, baneado, suspendido, busqueda) FROM stdin;
V10826854	f4572303d8f422888595170124cfe3fe12d8ed3a32cce1ad80bb25e5763c7e2e	1	f	f	\N
\.


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 210
-- Name: direccion_id_gerencia_seq; Type: SEQUENCE SET; Schema: insumo; Owner: postgres
--

SELECT pg_catalog.setval('insumo.direccion_id_gerencia_seq', 1, true);


--
-- TOC entry 3254 (class 2606 OID 16392)
-- Name: direccion direccion_pk; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.direccion
    ADD CONSTRAINT direccion_pk PRIMARY KEY (id_gerencia);


--
-- TOC entry 3256 (class 2606 OID 16397)
-- Name: personal personal_pkey; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT personal_pkey PRIMARY KEY (cedula);


--
-- TOC entry 3258 (class 2606 OID 16404)
-- Name: personal unique_cedula; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT unique_cedula UNIQUE (cedula) INCLUDE (cedula);


--
-- TOC entry 3260 (class 2620 OID 16408)
-- Name: personal usuario_search_vector_refresh; Type: TRIGGER; Schema: insumo; Owner: postgres
--

CREATE TRIGGER usuario_search_vector_refresh BEFORE INSERT OR UPDATE ON insumo.personal FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('busqueda', 'pg_catalog.english', 'cedula');


--
-- TOC entry 3259 (class 2606 OID 16398)
-- Name: personal fk_id_direccion; Type: FK CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT fk_id_direccion FOREIGN KEY (id_gerencia) REFERENCES insumo.direccion(id_gerencia) NOT VALID;


-- Completed on 2024-06-24 11:41:35 -04

--
-- PostgreSQL database dump complete
--

