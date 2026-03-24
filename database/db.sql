--
-- PostgreSQL database dump
--

\restrict QBF7AUMLlgc4LJlK8xCadk5hMLFOUsFtxj29XrTbrySnw2wSuifkxoDu6OelAhO

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS fk_rp_role;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS fk_rp_permission;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS fk_roles_company;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS fk_permissions_module;
ALTER TABLE IF EXISTS ONLY public.company_users DROP CONSTRAINT IF EXISTS fk_cu_user;
ALTER TABLE IF EXISTS ONLY public.company_users DROP CONSTRAINT IF EXISTS fk_cu_role;
ALTER TABLE IF EXISTS ONLY public.company_users DROP CONSTRAINT IF EXISTS fk_cu_company;
ALTER TABLE IF EXISTS ONLY public.company_modules DROP CONSTRAINT IF EXISTS fk_cm_module;
ALTER TABLE IF EXISTS ONLY public.company_modules DROP CONSTRAINT IF EXISTS fk_cm_company;
DROP INDEX IF EXISTS public.idx_rp_role;
DROP INDEX IF EXISTS public.idx_roles_company;
DROP INDEX IF EXISTS public.idx_permissions_module;
DROP INDEX IF EXISTS public.idx_cu_user;
DROP INDEX IF EXISTS public.idx_cu_company;
DROP INDEX IF EXISTS public.idx_cm_company;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS uq_role_permission;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS uq_permission_code;
ALTER TABLE IF EXISTS ONLY public.company_users DROP CONSTRAINT IF EXISTS uq_company_user;
ALTER TABLE IF EXISTS ONLY public.company_modules DROP CONSTRAINT IF EXISTS uq_company_module;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS role_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.modules DROP CONSTRAINT IF EXISTS modules_pkey;
ALTER TABLE IF EXISTS ONLY public.modules DROP CONSTRAINT IF EXISTS modules_code_key;
ALTER TABLE IF EXISTS ONLY public.company_users DROP CONSTRAINT IF EXISTS company_users_pkey;
ALTER TABLE IF EXISTS ONLY public.company_modules DROP CONSTRAINT IF EXISTS company_modules_pkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_pkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_name_key;
ALTER TABLE IF EXISTS public.companies ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.roles;
DROP TABLE IF EXISTS public.role_permissions;
DROP TABLE IF EXISTS public.permissions;
DROP TABLE IF EXISTS public.modules;
DROP TABLE IF EXISTS public.company_users;
DROP TABLE IF EXISTS public.company_modules;
DROP SEQUENCE IF EXISTS public.companies_id_seq;
DROP FUNCTION IF EXISTS public.update_company(p_id integer, p_name text, p_legal_name text, p_city text, p_rfc text, p_phone text, p_email text, p_suscription_plan text);
DROP FUNCTION IF EXISTS public.get_company_by_id(p_id integer);
DROP FUNCTION IF EXISTS public.get_all_companies();
DROP FUNCTION IF EXISTS public.delete_company(p_id integer);
DROP FUNCTION IF EXISTS public.create_company(p_name text, p_legal_name text, p_city text, p_rfc text, p_phone text, p_email text, p_suscription_plan text);
DROP TABLE IF EXISTS public.companies;
DROP EXTENSION IF EXISTS "uuid-ossp";
--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    legal_name character varying(255) NOT NULL,
    city character varying(100) NOT NULL,
    rfc character varying(15) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(255) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    suscription_plan character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: create_company(text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_company(p_name text, p_legal_name text, p_city text, p_rfc text, p_phone text, p_email text, p_suscription_plan text) RETURNS public.companies
    LANGUAGE sql
    AS $$
    INSERT INTO companies (name, legal_name, city, rfc, phone, email, suscription_plan)
    VALUES (p_name, p_legal_name, p_city, p_rfc, p_phone, p_email, p_suscription_plan)
    RETURNING *;
$$;


--
-- Name: delete_company(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_company(p_id integer) RETURNS integer
    LANGUAGE sql
    AS $$
    DELETE FROM companies WHERE id = p_id
    RETURNING id;
$$;


--
-- Name: get_all_companies(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_all_companies() RETURNS SETOF public.companies
    LANGUAGE sql
    AS $$
    SELECT * FROM companies;
$$;


--
-- Name: get_company_by_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_company_by_id(p_id integer) RETURNS TABLE(id integer, name text, legal_name text, city text, rfc text, phone text, email text, suscription_plan text)
    LANGUAGE sql
    AS $$
    SELECT id, name, legal_name, city, rfc, phone, email, suscription_plan FROM companies WHERE id = p_id;
$$;


--
-- Name: update_company(integer, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_company(p_id integer, p_name text, p_legal_name text, p_city text, p_rfc text, p_phone text, p_email text, p_suscription_plan text) RETURNS public.companies
    LANGUAGE sql
    AS $$
    UPDATE companies
    SET name = p_name,
        legal_name = p_legal_name,
        city = p_city,
        rfc = p_rfc,
        phone = p_phone,
        email = p_email,
        suscription_plan = p_suscription_plan
    WHERE id = p_id
    RETURNING *;
$$;


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_modules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    company_id integer NOT NULL,
    module_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    activated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: company_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    company_id integer NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying
);


--
-- Name: modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_core boolean DEFAULT false
);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    module_id uuid NOT NULL,
    code character varying(100) NOT NULL,
    description text
);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    company_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    username character varying(100),
    email character varying(150) NOT NULL,
    password_hash text NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    is_global_admin boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: companies companies_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_name_key UNIQUE (name);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_modules company_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_modules
    ADD CONSTRAINT company_modules_pkey PRIMARY KEY (id);


--
-- Name: company_users company_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT company_users_pkey PRIMARY KEY (id);


--
-- Name: modules modules_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_code_key UNIQUE (code);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: company_modules uq_company_module; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_modules
    ADD CONSTRAINT uq_company_module UNIQUE (company_id, module_id);


--
-- Name: company_users uq_company_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT uq_company_user UNIQUE (company_id, user_id);


--
-- Name: permissions uq_permission_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT uq_permission_code UNIQUE (module_id, code);


--
-- Name: role_permissions uq_role_permission; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_cm_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cm_company ON public.company_modules USING btree (company_id);


--
-- Name: idx_cu_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cu_company ON public.company_users USING btree (company_id);


--
-- Name: idx_cu_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cu_user ON public.company_users USING btree (user_id);


--
-- Name: idx_permissions_module; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_permissions_module ON public.permissions USING btree (module_id);


--
-- Name: idx_roles_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_company ON public.roles USING btree (company_id);


--
-- Name: idx_rp_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rp_role ON public.role_permissions USING btree (role_id);


--
-- Name: company_modules fk_cm_company; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_modules
    ADD CONSTRAINT fk_cm_company FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_modules fk_cm_module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_modules
    ADD CONSTRAINT fk_cm_module FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- Name: company_users fk_cu_company; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT fk_cu_company FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_users fk_cu_role; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT fk_cu_role FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: company_users fk_cu_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT fk_cu_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: permissions fk_permissions_module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT fk_permissions_module FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- Name: roles fk_roles_company; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT fk_roles_company FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_rp_permission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rp_permission FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_rp_role; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rp_role FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QBF7AUMLlgc4LJlK8xCadk5hMLFOUsFtxj29XrTbrySnw2wSuifkxoDu6OelAhO

