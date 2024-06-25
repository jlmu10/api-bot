--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)

-- Started on 2024-06-25 07:29:23 -04

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
-- TOC entry 4 (class 2615 OID 16409)
-- Name: bitacora; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bitacora;


ALTER SCHEMA bitacora OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 16385)
-- Name: insumo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA insumo;


ALTER SCHEMA insumo OWNER TO postgres;

--
-- TOC entry 837 (class 1247 OID 16436)
-- Name: log_type; Type: TYPE; Schema: bitacora; Owner: postgres
--

CREATE TYPE bitacora.log_type AS ENUM (
    'Registro',
    'Reserva Desayuno',
    'Reserva Almuerzo',
    'Reserva Cena',
    'Retiro Logistica',
    'Generar Reporte',
    'Reserva Invitados',
    'No existe en personal',
    'Existe personal -> Falta password'
);


ALTER TYPE bitacora.log_type OWNER TO postgres;

--
-- TOC entry 843 (class 1247 OID 16471)
-- Name: sumario; Type: TYPE; Schema: bitacora; Owner: postgres
--

CREATE TYPE bitacora.sumario AS (
	cod character varying(3),
	acc bitacora.log_type,
	cam character varying,
	res boolean,
	msj character varying(80)
);


ALTER TYPE bitacora.sumario OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16481)
-- Name: validar_usuario(character varying, json); Type: FUNCTION; Schema: insumo; Owner: postgres
--

CREATE FUNCTION insumo.validar_usuario(pcedula character varying, pvalores json) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
cedula_found varchar(9);
resultado bitacora.sumario;
parse_logs jsonb;
BEGIN
	SELECT cedula FROM insumo.personal WHERE 
	insumo.personal.busqueda @@ to_tsquery('V10826854')and insumo.personal.baneado = false into cedula_found;
  
  if cedula_found IS NOT NULL THEN
    -- Se agrega a la bitacora el intento de inicio de sesión:
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'No existe en personal');
	select '100' into resultado.cod;
	select 'No existe en personal' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select false into resultado.res;
	select 'No se encuentra el número de cédula registrado en alguna dirección' into resultado.msj;
	select json_agg(x) into parse_logs from
    (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
	return parse_logs;
 else
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'Existe personal -> Falta password');
	select '200' into resultado.cod;
	select 'Existe personal -> Falta password' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select true into resultado.res;
	select 'La cédula existe asociada a una dirección, pero no se registrado completamente' into resultado.msj;
	select json_agg(x) into parse_logs from (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
		return 
			parse_logs;
end if;
END;
$_$;


ALTER FUNCTION insumo.validar_usuario(pcedula character varying, pvalores json) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16476)
-- Name: validar_usuario(character varying, jsonb); Type: FUNCTION; Schema: insumo; Owner: postgres
--

CREATE FUNCTION insumo.validar_usuario(cedula character varying, valores jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
cedula_found varchar(9);
resultado bitacora.sumario;
parse_logs jsonb;
BEGIN
	SELECT cedula FROM insumo.personal WHERE 
	insumo.personal.busqueda @@ to_tsquery('V10826854')and insumo.personal.baneado = false into cedula_found;
  
  if cedula_found IS NOT NULL THEN
    -- Se agrega a la bitacora el intento de inicio de sesión:
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'No existe en personal');
	select '100' into resultado.cod;
	select 'No existe en personal' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select false into resultado.res;
	select 'No se encuentra el número de cédula registrado en alguna dirección' into resultado.msj;
	select json_agg(x) into parse_logs from
    (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
	return parse_logs;
 else
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'Existe personal -> Falta password');
	select '200' into resultado.cod;
	select 'Existe personal -> Falta password' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select true into resultado.res;
	select 'La cédula existe asociada a una dirección, pero no se registrado completamente' into resultado.msj;
	select json_agg(x) into parse_logs from (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
		return 
			parse_logs;
end if;
END;
$_$;


ALTER FUNCTION insumo.validar_usuario(cedula character varying, valores jsonb) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16452)
-- Name: bitacora; Type: TABLE; Schema: bitacora; Owner: postgres
--

CREATE TABLE bitacora.bitacora (
    id_bitacora integer NOT NULL,
    cedula character varying(9) NOT NULL,
    logs jsonb NOT NULL,
    accion bitacora.log_type NOT NULL,
    creado_al timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE bitacora.bitacora OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16451)
-- Name: bitacora_id_bitacora_seq; Type: SEQUENCE; Schema: bitacora; Owner: postgres
--

CREATE SEQUENCE bitacora.bitacora_id_bitacora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bitacora.bitacora_id_bitacora_seq OWNER TO postgres;

--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 214
-- Name: bitacora_id_bitacora_seq; Type: SEQUENCE OWNED BY; Schema: bitacora; Owner: postgres
--

ALTER SEQUENCE bitacora.bitacora_id_bitacora_seq OWNED BY bitacora.bitacora.id_bitacora;


--
-- TOC entry 212 (class 1259 OID 16387)
-- Name: direccion; Type: TABLE; Schema: insumo; Owner: postgres
--

CREATE TABLE insumo.direccion (
    id_gerencia integer NOT NULL,
    direccion character varying(50)
);


ALTER TABLE insumo.direccion OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16386)
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
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 211
-- Name: direccion_id_gerencia_seq; Type: SEQUENCE OWNED BY; Schema: insumo; Owner: postgres
--

ALTER SEQUENCE insumo.direccion_id_gerencia_seq OWNED BY insumo.direccion.id_gerencia;


--
-- TOC entry 213 (class 1259 OID 16393)
-- Name: personal; Type: TABLE; Schema: insumo; Owner: postgres
--

CREATE TABLE insumo.personal (
    cedula character varying(9) NOT NULL,
    pass character varying(256) NOT NULL,
    id_gerencia integer NOT NULL,
    baneado boolean NOT NULL,
    suspendido boolean NOT NULL,
    busqueda tsvector NOT NULL,
    registrado boolean NOT NULL
);


ALTER TABLE insumo.personal OWNER TO postgres;

--
-- TOC entry 3268 (class 2604 OID 16455)
-- Name: bitacora id_bitacora; Type: DEFAULT; Schema: bitacora; Owner: postgres
--

ALTER TABLE ONLY bitacora.bitacora ALTER COLUMN id_bitacora SET DEFAULT nextval('bitacora.bitacora_id_bitacora_seq'::regclass);


--
-- TOC entry 3267 (class 2604 OID 16390)
-- Name: direccion id_gerencia; Type: DEFAULT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.direccion ALTER COLUMN id_gerencia SET DEFAULT nextval('insumo.direccion_id_gerencia_seq'::regclass);


--
-- TOC entry 3423 (class 0 OID 16452)
-- Dependencies: 215
-- Data for Name: bitacora; Type: TABLE DATA; Schema: bitacora; Owner: postgres
--

COPY bitacora.bitacora (id_bitacora, cedula, logs, accion, creado_al) FROM stdin;
4	V10826854	{"nombre": "jose"}	No existe en personal	2024-06-24 20:43:10.280278
5	V10826854	{"nombre": "jose"}	No existe en personal	2024-06-24 20:51:41.967973
6	V10826854	{"nombre": "jose"}	No existe en personal	2024-06-24 20:51:43.652415
7	V10826854	{"nombre": "jose"}	No existe en personal	2024-06-24 20:51:48.527157
\.


--
-- TOC entry 3420 (class 0 OID 16387)
-- Dependencies: 212
-- Data for Name: direccion; Type: TABLE DATA; Schema: insumo; Owner: postgres
--

COPY insumo.direccion (id_gerencia, direccion) FROM stdin;
1	UTD
\.


--
-- TOC entry 3421 (class 0 OID 16393)
-- Dependencies: 213
-- Data for Name: personal; Type: TABLE DATA; Schema: insumo; Owner: postgres
--

COPY insumo.personal (cedula, pass, id_gerencia, baneado, suspendido, busqueda, registrado) FROM stdin;
V10826854	f4572303d8f422888595170124cfe3fe12d8ed3a32cce1ad80bb25e5763c7e2e	1	f	f	'v10826854':1	f
\.


--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 214
-- Name: bitacora_id_bitacora_seq; Type: SEQUENCE SET; Schema: bitacora; Owner: postgres
--

SELECT pg_catalog.setval('bitacora.bitacora_id_bitacora_seq', 7, true);


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 211
-- Name: direccion_id_gerencia_seq; Type: SEQUENCE SET; Schema: insumo; Owner: postgres
--

SELECT pg_catalog.setval('insumo.direccion_id_gerencia_seq', 1, true);


--
-- TOC entry 3272 (class 2606 OID 16392)
-- Name: direccion direccion_pk; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.direccion
    ADD CONSTRAINT direccion_pk PRIMARY KEY (id_gerencia);


--
-- TOC entry 3275 (class 2606 OID 16397)
-- Name: personal personal_pkey; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT personal_pkey PRIMARY KEY (cedula);


--
-- TOC entry 3277 (class 2606 OID 16404)
-- Name: personal unique_cedula; Type: CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT unique_cedula UNIQUE (cedula) INCLUDE (cedula);


--
-- TOC entry 3270 (class 1259 OID 16421)
-- Name: direccion_indx; Type: INDEX; Schema: insumo; Owner: postgres
--

CREATE INDEX direccion_indx ON insumo.direccion USING btree (id_gerencia);


--
-- TOC entry 3273 (class 1259 OID 16420)
-- Name: personal_idx; Type: INDEX; Schema: insumo; Owner: postgres
--

CREATE INDEX personal_idx ON insumo.personal USING gin (busqueda);


--
-- TOC entry 3279 (class 2620 OID 16408)
-- Name: personal usuario_search_vector_refresh; Type: TRIGGER; Schema: insumo; Owner: postgres
--

CREATE TRIGGER usuario_search_vector_refresh BEFORE INSERT OR UPDATE ON insumo.personal FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('busqueda', 'pg_catalog.english', 'cedula');


--
-- TOC entry 3278 (class 2606 OID 16398)
-- Name: personal fk_id_direccion; Type: FK CONSTRAINT; Schema: insumo; Owner: postgres
--

ALTER TABLE ONLY insumo.personal
    ADD CONSTRAINT fk_id_direccion FOREIGN KEY (id_gerencia) REFERENCES insumo.direccion(id_gerencia) NOT VALID;


-- Completed on 2024-06-25 07:29:24 -04

--
-- PostgreSQL database dump complete
--

