--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: buda
--

CREATE TABLE public.faculty (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    place character varying(255),
    address character varying(255)
);


ALTER TABLE public.faculty OWNER TO buda;

--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: buda
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_id_seq OWNER TO buda;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buda
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: faculty_student; Type: TABLE; Schema: public; Owner: buda
--

CREATE TABLE public.faculty_student (
    faculty_id integer NOT NULL,
    student_id integer NOT NULL
);


ALTER TABLE public.faculty_student OWNER TO buda;

--
-- Name: student; Type: TABLE; Schema: public; Owner: buda
--

CREATE TABLE public.student (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    address character varying(255),
    place character varying(255),
    postal_code character varying(10),
    date_of_birth date,
    active boolean NOT NULL
);


ALTER TABLE public.student OWNER TO buda;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: buda
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_id_seq OWNER TO buda;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buda
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: faculty_student faculty_student_pkey; Type: CONSTRAINT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.faculty_student
    ADD CONSTRAINT faculty_student_pkey PRIMARY KEY (faculty_id, student_id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: faculty_student faculty_student_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.faculty_student
    ADD CONSTRAINT faculty_student_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_student faculty_student_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buda
--

ALTER TABLE ONLY public.faculty_student
    ADD CONSTRAINT faculty_student_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

