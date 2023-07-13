--
-- PostgreSQL database cluster dump
--

-- Started on 2023-07-13 22:15:38 WIB

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.3

-- Started on 2023-07-13 22:15:39 WIB

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

-- Completed on 2023-07-13 22:15:44 WIB

--
-- PostgreSQL database dump complete
--

--
-- Database "ecommerce" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.3

-- Started on 2023-07-13 22:15:44 WIB

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
-- TOC entry 3409 (class 1262 OID 16430)
-- Name: ecommerce; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE ecommerce WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE ecommerce OWNER TO postgres;

\connect ecommerce

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
-- TOC entry 223 (class 1255 OID 17660)
-- Name: delete_merchant_on_user_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_merchant_on_user_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM merchants
    WHERE merchant_id = OLD.merchant_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.delete_merchant_on_user_delete() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 17699)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id text NOT NULL,
    category_name text,
    merchant_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17743)
-- Name: detail_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detail_transactions (
    detail_transaction_id text NOT NULL,
    transaction_id text,
    product_id text,
    quantity integer,
    price numeric,
    subtotal numeric,
    merchant_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.detail_transactions OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17691)
-- Name: merchants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchants (
    merchant_id text NOT NULL,
    merchant_name text,
    merchant_address text,
    merchant_image text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.merchants OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17767)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id text NOT NULL,
    buyer_id text,
    amount numeric,
    payment_method text,
    detail_transaction jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17712)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id text NOT NULL,
    category_id text,
    merchant_id text,
    product_name text,
    product_price text,
    product_image text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17663)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id text NOT NULL,
    role_name text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17780)
-- Name: shippings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shippings (
    shipping_id text NOT NULL,
    buyer_id text,
    ship_name text,
    ship_address text,
    ship_city text,
    ship_state text,
    ship_country text,
    ship_phone text,
    tracking_number text,
    detail_transaction jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.shippings OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17730)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id text NOT NULL,
    buyer_id text,
    transaction_date date,
    status text,
    total_amount numeric,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17673)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    uuid text NOT NULL,
    username text,
    email text,
    password text,
    role_id text,
    merchant_id text,
    verification boolean DEFAULT false,
    user_detail jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3398 (class 0 OID 17699)
-- Dependencies: 217
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name, merchant_id, created_at, updated_at) FROM stdin;
82d7c5dc-c277-482e-a54b-6a5f8e0690e9	Drinks	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:53:48.470175	2023-07-13 14:53:48.432393+00
108af15b-099f-4f9e-b8ef-dcb36e05dc5e	Food	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:55:19.615456	2023-07-13 14:55:19.599636+00
\.


--
-- TOC entry 3401 (class 0 OID 17743)
-- Dependencies: 220
-- Data for Name: detail_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detail_transactions (detail_transaction_id, transaction_id, product_id, quantity, price, subtotal, merchant_id, created_at, updated_at) FROM stdin;
DETAIL_af17c7cc-9750-4b35-991b-a527bba81885	TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544	c37bd544-3d5c-4c01-acc3-c1e36b72ad38	10	3000	30000	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:57:44.60771	2023-07-13 14:57:44.612524+00
DETAIL_2e3a1d0a-7cf5-4cd6-8f67-3b3ef4c259fc	TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544	3494c445-8881-453e-95aa-b79d36b7292b	12	12000	144000	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:57:44.60771	2023-07-13 14:57:44.612524+00
DETAIL_e46c74ae-9e69-4428-b876-1b66b3ef8784	TRX_43b857ea-eb72-41ab-9646-9477e5692965	c37bd544-3d5c-4c01-acc3-c1e36b72ad38	4	3000	12000	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:57:48.948595	2023-07-13 14:57:48.913799+00
DETAIL_3634ca6d-8e74-48bc-afd9-8fe0ccdf1f9e	TRX_43b857ea-eb72-41ab-9646-9477e5692965	3494c445-8881-453e-95aa-b79d36b7292b	3	12000	36000	9d25b210-0619-43df-bb29-fcbd9e3cd62e	2023-07-13 23:57:48.948595	2023-07-13 14:57:48.913799+00
\.


--
-- TOC entry 3397 (class 0 OID 17691)
-- Dependencies: 216
-- Data for Name: merchants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchants (merchant_id, merchant_name, merchant_address, merchant_image, created_at, updated_at) FROM stdin;
9d25b210-0619-43df-bb29-fcbd9e3cd62e	Krenz Snack Official	Purwokerto	https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg	2023-07-13 23:52:48.238776	2023-07-13 14:52:48.264696+00
\.


--
-- TOC entry 3402 (class 0 OID 17767)
-- Dependencies: 221
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, buyer_id, amount, payment_method, detail_transaction, created_at) FROM stdin;
525bafbe-47be-402a-92d9-3c39b93a4bbb	59dcf375-80fe-4278-8dff-416399e0b5a4	222000	Bank Transfer	[{"total_amount": 174000, "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction": [{"price": 3000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 10, "subtotal": 30000, "created_at": "2023-07-13T23:57:44.60771Z", "product_id": "c37bd544-3d5c-4c01-acc3-c1e36b72ad38", "updated_at": "2023-07-13T21:57:44.612524+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction_id": "DETAIL_af17c7cc-9750-4b35-991b-a527bba81885"}, {"price": 12000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 12, "subtotal": 144000, "created_at": "2023-07-13T23:57:44.60771Z", "product_id": "3494c445-8881-453e-95aa-b79d36b7292b", "updated_at": "2023-07-13T21:57:44.612524+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction_id": "DETAIL_2e3a1d0a-7cf5-4cd6-8f67-3b3ef4c259fc"}]}, {"total_amount": 48000, "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction": [{"price": 3000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 4, "subtotal": 12000, "created_at": "2023-07-13T23:57:48.948595Z", "product_id": "c37bd544-3d5c-4c01-acc3-c1e36b72ad38", "updated_at": "2023-07-13T21:57:48.913799+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction_id": "DETAIL_e46c74ae-9e69-4428-b876-1b66b3ef8784"}, {"price": 12000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 3, "subtotal": 36000, "created_at": "2023-07-13T23:57:48.948595Z", "product_id": "3494c445-8881-453e-95aa-b79d36b7292b", "updated_at": "2023-07-13T21:57:48.913799+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction_id": "DETAIL_3634ca6d-8e74-48bc-afd9-8fe0ccdf1f9e"}]}]	2023-07-13 15:10:00.225801
\.


--
-- TOC entry 3399 (class 0 OID 17712)
-- Dependencies: 218
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, category_id, merchant_id, product_name, product_price, product_image, created_at, updated_at) FROM stdin;
c37bd544-3d5c-4c01-acc3-c1e36b72ad38	82d7c5dc-c277-482e-a54b-6a5f8e0690e9	9d25b210-0619-43df-bb29-fcbd9e3cd62e	Coca-cola	3000	https://is3.cloudhost.id/ecommerce/picture/c37bd544-3d5c-4c01-acc3-c1e36b72ad38.jpeg	2023-07-13 23:55:08.23138	2023-07-13 14:55:08.18858+00
3494c445-8881-453e-95aa-b79d36b7292b	108af15b-099f-4f9e-b8ef-dcb36e05dc5e	9d25b210-0619-43df-bb29-fcbd9e3cd62e	Mie Ayam	12000	https://is3.cloudhost.id/ecommerce/picture/3494c445-8881-453e-95aa-b79d36b7292b.jpeg	2023-07-13 23:55:33.273375	2023-07-13 14:55:33.230396+00
\.


--
-- TOC entry 3395 (class 0 OID 17663)
-- Dependencies: 214
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, created_at, updated_at) FROM stdin;
ec7c293c-586f-41cd-bd45-de86091d5816	Seller	2023-07-13 18:44:39.91178	2023-07-13 09:44:39.65155+00
9a7d654c-fd02-4aa5-9fd8-5064bbfaa813	Buyer	2023-07-13 18:44:42.931649	2023-07-13 09:44:42.670904+00
\.


--
-- TOC entry 3403 (class 0 OID 17780)
-- Dependencies: 222
-- Data for Name: shippings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shippings (shipping_id, buyer_id, ship_name, ship_address, ship_city, ship_state, ship_country, ship_phone, tracking_number, detail_transaction, created_at) FROM stdin;
ccd8c2cf-8c68-40fc-94bc-13674352b3c0	59dcf375-80fe-4278-8dff-416399e0b5a4	Septiyan	Jl. KH Hasyim Ashari No.11	Kota Tangerang	Kel. Pinang	Kec. Pinang	081210917179	WADXX210221221	[{"total_amount": 174000, "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction": [{"price": 3000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 10, "subtotal": 30000, "created_at": "2023-07-13T23:57:44.60771Z", "product_id": "c37bd544-3d5c-4c01-acc3-c1e36b72ad38", "updated_at": "2023-07-13T21:57:44.612524+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction_id": "DETAIL_af17c7cc-9750-4b35-991b-a527bba81885"}, {"price": 12000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 12, "subtotal": 144000, "created_at": "2023-07-13T23:57:44.60771Z", "product_id": "3494c445-8881-453e-95aa-b79d36b7292b", "updated_at": "2023-07-13T21:57:44.612524+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544", "detail_transaction_id": "DETAIL_2e3a1d0a-7cf5-4cd6-8f67-3b3ef4c259fc"}]}, {"total_amount": 48000, "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction": [{"price": 3000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 4, "subtotal": 12000, "created_at": "2023-07-13T23:57:48.948595Z", "product_id": "c37bd544-3d5c-4c01-acc3-c1e36b72ad38", "updated_at": "2023-07-13T21:57:48.913799+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction_id": "DETAIL_e46c74ae-9e69-4428-b876-1b66b3ef8784"}, {"price": 12000, "merchant": {"created_at": "2023-07-13T23:52:48.238776Z", "updated_at": "2023-07-13T21:52:48.264696+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "merchant_name": "Krenz Snack Official", "merchant_image": "https://is3.cloudhost.id/ecommerce/picture/9d25b210-0619-43df-bb29-fcbd9e3cd62e.jpeg", "merchant_address": "Purwokerto"}, "quantity": 3, "subtotal": 36000, "created_at": "2023-07-13T23:57:48.948595Z", "product_id": "3494c445-8881-453e-95aa-b79d36b7292b", "updated_at": "2023-07-13T21:57:48.913799+07:00", "merchant_id": "9d25b210-0619-43df-bb29-fcbd9e3cd62e", "transaction_id": "TRX_43b857ea-eb72-41ab-9646-9477e5692965", "detail_transaction_id": "DETAIL_3634ca6d-8e74-48bc-afd9-8fe0ccdf1f9e"}]}]	2023-07-13 15:10:00.380143
\.


--
-- TOC entry 3400 (class 0 OID 17730)
-- Dependencies: 219
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, buyer_id, transaction_date, status, total_amount, created_at, updated_at) FROM stdin;
TRX_9cb2e4c0-9990-4b91-b2ba-899c73737544	59dcf375-80fe-4278-8dff-416399e0b5a4	2023-07-13	Paid	174000	2023-07-13 23:57:44.60771	2023-07-13 15:09:59.574623+00
TRX_43b857ea-eb72-41ab-9646-9477e5692965	59dcf375-80fe-4278-8dff-416399e0b5a4	2023-07-13	Paid	48000	2023-07-13 23:57:48.948595	2023-07-13 15:09:59.797129+00
\.


--
-- TOC entry 3396 (class 0 OID 17673)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (uuid, username, email, password, role_id, merchant_id, verification, user_detail, created_at, updated_at) FROM stdin;
59dcf375-80fe-4278-8dff-416399e0b5a4	septiyan	septiyan@septiyan.com	$2a$10$MjRwdBF2GfBzHO5oaWJVSeb.Qs3eM16wDpejqBC8C7ZrgBJzwFYbO	9a7d654c-fd02-4aa5-9fd8-5064bbfaa813		t	{"Address": "Jl. KH Hasyim Ashari No.11", "picture": "https://is3.cloudhost.id/ecommerce/picture/septiyan.jpeg", "telepon": "081210917179", "full_name": "Septiyan Dwi Nugroho"}	2023-07-13 18:47:53.816159	2023-07-13 09:48:48.688396+00
0afcd532-dd68-4b96-ac51-ffe33cf0df5c	seller	seller@seller.com	$2a$10$kvxOKOgDNvsPBUSVIF1nkev9qTQKoCk3UzpK6mD/pNRmtY8.UfMdu	ec7c293c-586f-41cd-bd45-de86091d5816	9d25b210-0619-43df-bb29-fcbd9e3cd62e	t	{"Address": "Jl. KH Hasyim Ashari No.11", "picture": "https://is3.cloudhost.id/ecommerce/picture/seller.jpeg", "telepon": "081210917179", "full_name": "Candra Novita"}	2023-07-13 18:48:42.565868	2023-07-13 14:52:48.90513+00
\.


--
-- TOC entry 3231 (class 2606 OID 17706)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 3237 (class 2606 OID 17750)
-- Name: detail_transactions detail_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transactions
    ADD CONSTRAINT detail_transactions_pkey PRIMARY KEY (detail_transaction_id);


--
-- TOC entry 3229 (class 2606 OID 17698)
-- Name: merchants merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_pkey PRIMARY KEY (merchant_id);


--
-- TOC entry 3239 (class 2606 OID 17774)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 3233 (class 2606 OID 17719)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 3219 (class 2606 OID 17670)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 3221 (class 2606 OID 17672)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 3241 (class 2606 OID 17787)
-- Name: shippings shippings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shippings
    ADD CONSTRAINT shippings_pkey PRIMARY KEY (shipping_id);


--
-- TOC entry 3235 (class 2606 OID 17737)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 3223 (class 2606 OID 17685)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3225 (class 2606 OID 17681)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3227 (class 2606 OID 17683)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3252 (class 2620 OID 17766)
-- Name: users delete_merchant_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER delete_merchant_trigger AFTER DELETE ON public.users FOR EACH ROW EXECUTE FUNCTION public.delete_merchant_on_user_delete();


--
-- TOC entry 3244 (class 2606 OID 17720)
-- Name: products fk_categories_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_categories_product FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3243 (class 2606 OID 17707)
-- Name: categories fk_merchants_categories; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_merchants_categories FOREIGN KEY (merchant_id) REFERENCES public.merchants(merchant_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3247 (class 2606 OID 17761)
-- Name: detail_transactions fk_merchants_detail; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transactions
    ADD CONSTRAINT fk_merchants_detail FOREIGN KEY (merchant_id) REFERENCES public.merchants(merchant_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3245 (class 2606 OID 17725)
-- Name: products fk_merchants_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_merchants_product FOREIGN KEY (merchant_id) REFERENCES public.merchants(merchant_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3250 (class 2606 OID 17775)
-- Name: payments fk_payments_buyer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_buyer FOREIGN KEY (buyer_id) REFERENCES public.users(uuid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3248 (class 2606 OID 17756)
-- Name: detail_transactions fk_products_detail; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transactions
    ADD CONSTRAINT fk_products_detail FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3251 (class 2606 OID 17788)
-- Name: shippings fk_shippings_buyer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shippings
    ADD CONSTRAINT fk_shippings_buyer FOREIGN KEY (buyer_id) REFERENCES public.users(uuid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3246 (class 2606 OID 17738)
-- Name: transactions fk_transactions_buyer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_buyer FOREIGN KEY (buyer_id) REFERENCES public.users(uuid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3249 (class 2606 OID 17751)
-- Name: detail_transactions fk_transactions_details; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transactions
    ADD CONSTRAINT fk_transactions_details FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3242 (class 2606 OID 17686)
-- Name: users fk_users_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2023-07-13 22:15:47 WIB

--
-- PostgreSQL database dump complete
--

--
-- Database "kedaiprogrammer" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.3

-- Started on 2023-07-13 22:15:47 WIB

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
-- TOC entry 3351 (class 1262 OID 16384)
-- Name: kedaiprogrammer; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE kedaiprogrammer WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE kedaiprogrammer OWNER TO postgres;

\connect kedaiprogrammer

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
-- TOC entry 218 (class 1259 OID 16422)
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles (
    article_id text,
    title text,
    description text,
    body text,
    slug text,
    category_id text,
    author_id text,
    main_image text,
    publised_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    status bigint
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16397)
-- Name: businesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businesses (
    business_id text,
    business_name text,
    business_description text,
    domain text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.businesses OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16416)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id text,
    category_name text,
    tag text,
    is_active boolean,
    service_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16410)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id text,
    service_name text,
    is_active boolean,
    business_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16389)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    uuid text,
    username text,
    email text,
    password text,
    token text,
    user_info jsonb,
    business_id text,
    role text DEFAULT 'user'::text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3345 (class 0 OID 16422)
-- Dependencies: 218
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articles (article_id, title, description, body, slug, category_id, author_id, main_image, publised_at, created_at, updated_at, status) FROM stdin;
c8f40d8f-5e43-476b-8b1c-a4a8a6e8ae72	testing testing hayokkk sukses12	testing testing hayokkk sukses1	<p>testing testing hayokkk sukses1</p>	testing-testing-hayokkk-sukses12	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses12.jpeg	\N	2023-05-02 19:37:10.395398	2023-05-02 10:37:10.397831+00	1
8ed77112-6ce1-478c-b61a-6acd8d30c3cf	Gopath Dan Workspace	Setup Go project menggunakan GOPATH kurang dianjurkan untuk Go versi terbaru.	ini adalah bodyh article	gopath-dan-workspace	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	berkenalan-dengan-golang.png	\N	2023-04-21 04:06:49.086759	2023-04-20 19:06:56.14618+00	1
73134417-81a5-4d7b-9cbb-7afe8a7c0c0a	awdawdwadawd	awdawdwd	<p>awdawdawd</p>	awdawdwadawd	e438a111-eedb-4779-9b55-fd3831aff5a6	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawdwadawd.jpeg	\N	2023-05-03 12:18:10.835376	2023-05-03 03:18:10.84382+00	1
681c9e8f-2414-4875-8926-305080903f93	awdawdwadawd	awdawdwd	<p>awdawdawd</p>	awdawdwadawd	e438a111-eedb-4779-9b55-fd3831aff5a6	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawdwadawd.jpeg	\N	2023-05-03 12:19:47.919169	2023-05-03 03:19:47.910274+00	1
b3f2815c-e518-4c58-aca9-9a46abebd0d7	Instalasi Golang	Hal pertama yang perlu dilakukan sebelum bisa menggunakan Go adalah meng-install-nya terlebih dahulu	<h1 id="belajar-golang">Belajar Golang</h1>	instalasi-golang	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	berkenalan-dengan-golang.png	\N	2023-04-21 03:59:16.201817	2023-04-20 18:59:23.269753+00	1
6158c660-25b7-4321-9de2-021a886b1977	Berkenalan Dengan Golang	Golang (atau biasa disebut dengan Go) adalah bahasa pemrograman yang dikembangkan di Google	ini adalah bodyh article	berkenalan-dengan-golang	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	berkenalan-dengan-golang.png	\N	2023-04-21 03:06:16.157909	2023-04-20 18:06:23.249986+00	1
79775a55-aeb7-4f80-9c3e-c65291fdf548	Setup Project Dengan Go Modules	Pada bagian ini kita akan belajar cara inisialisasi project menggunakan Go Modules (atau Modules).	ini adalah bodyh article	setup-go-project-dengan-go-modules	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	berkenalan-dengan-golang.png	\N	2023-04-21 04:06:47.161916	2023-04-20 19:06:54.224801+00	1
e0456e5e-7181-47a6-83c1-8e09ddde6875	awdaw	adawdaw	awdaw	awdaw	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdaw.png	\N	2023-04-26 17:15:52.934741	2023-04-26 08:15:53.810427+00	1
d6767a11-3266-4aae-b7c0-2dd404b229d5	awdaw	dwadawdwawd		awdaw	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdaw.png	\N	2023-04-26 18:13:19.779779	2023-04-26 09:13:20.632963+00	1
7bde96cc-704a-42cb-aff9-55494e6aa27e	awdawd	dwadawdwo	<p>dawkodwakdoawkdwaodaw</p>	awdawd	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawd.png	\N	2023-04-26 18:29:17.987603	2023-04-26 09:29:18.835148+00	1
b9dd2ba6-058e-4587-9ad3-bf5b2a83b43d	awdawd	dwadawdwo	<div id="book-search-results">\n<div class="search-noresults">\n<section class="normal markdown-section">\n<h1 id="belajar-golang">Belajar Golang</h1>\n<p><strong><a href="https://golang.org/" target="_blank" rel="noopener">Golang</a></strong>&nbsp;(atau biasa disebut dengan&nbsp;<strong>Go</strong>) adalah bahasa pemrograman yang dikembangkan di&nbsp;<strong>Google</strong>&nbsp;oleh&nbsp;<strong><a href="https://github.com/griesemer" target="_blank" rel="noopener">Robert Griesemer</a></strong>,&nbsp;<strong><a href="https://en.wikipedia.org/wiki/Rob_Pike" target="_blank" rel="noopener">Rob Pike</a></strong>, dan&nbsp;<strong><a href="https://en.wikipedia.org/wiki/Ken_Thompson" target="_blank" rel="noopener">Ken Thompson</a></strong>&nbsp;pada tahun 2007 dan mulai diperkenalkan ke publik tahun 2009.</p>\n<p>Penciptaan bahasa Go didasari bahasa&nbsp;<strong>C</strong>&nbsp;dan&nbsp;<strong>C++</strong>, oleh karena itu gaya sintaksnya mirip.</p>\n<h4 id="kelebihan-go">Kelebihan Go</h4>\n<p>Go memiliki kelebihan dibanding bahasa lainnya, beberapa di antaranya:</p>\n<ul>\n<li>Mendukung konkurensi di level bahasa dengan pengaplikasian cukup mudah</li>\n<li>Mendukung pemrosesan data dengan banyak prosesor dalam waktu yang bersamaan&nbsp;<em>(pararel processing)</em></li>\n<li>Memiliki&nbsp;<em>garbage collector</em></li>\n<li>Proses kompilasi sangat cepat</li>\n<li>Bukan bahasa pemrograman yang hirarkial dan bukan&nbsp;<em>strict</em>&nbsp;OOP, memberikan kebebasan ke developer perihal bagaimana cara penulisan kode.</li>\n<li>Dependensi dan&nbsp;<em>tooling</em>&nbsp;yang disediakan terbilang lengkap.</li>\n<li>Dukungan komunitas sangat bagus. Banyak tools yang tersedia secara gratis dan&nbsp;<em>open source</em>&nbsp;yang bisa langsung dimanfaatkan.</li>\n</ul>\n<p>Sudah banyak industri dan perusahaan yg menggunakan Go sampai level production, termasuk di antaranya adalah Google sendiri, dan juga tempat di mana penulis bekerja 😁</p>\n<hr>\n<p>Pada buku ini (terutama semua serial chapter A) kita akan belajar tentang dasar pemrograman Go, mulai dari 0.</p>\n<p><img src="https://dasarpemrogramangolang.novalagung.com/images/A_introduction_1_logo.png" alt="Dasar Pemrograman Golang - The Go Logo"></p>\n</section>\n</div>\n</div>	awdawd	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawd.png	\N	2023-04-26 18:29:54.196531	2023-04-26 09:29:55.040052+00	1
40e81ee4-9cf2-41d6-8ce5-36979cb84e8d	mancing belut	mancing belut	<div id="book-search-results">\n<div class="search-noresults">\n<section class="normal markdown-section">\n<h1 id="belajar-golang">Belajar Golang</h1>\n<p><strong><a href="https://golang.org/" target="_blank" rel="noopener">Golang</a></strong>&nbsp;(atau biasa disebut dengan&nbsp;<strong>Go</strong>) adalah bahasa pemrograman yang dikembangkan di&nbsp;<strong>Google</strong>&nbsp;oleh&nbsp;<strong><a href="https://github.com/griesemer" target="_blank" rel="noopener">Robert Griesemer</a></strong>,&nbsp;<strong><a href="https://en.wikipedia.org/wiki/Rob_Pike" target="_blank" rel="noopener">Rob Pike</a></strong>, dan&nbsp;<strong><a href="https://en.wikipedia.org/wiki/Ken_Thompson" target="_blank" rel="noopener">Ken Thompson</a></strong>&nbsp;pada tahun 2007 dan mulai diperkenalkan ke publik tahun 2009.</p>\n<p>Penciptaan bahasa Go didasari bahasa&nbsp;<strong>C</strong>&nbsp;dan&nbsp;<strong>C++</strong>, oleh karena itu gaya sintaksnya mirip.</p>\n<h4 id="kelebihan-go">Kelebihan Go</h4>\n<p>Go memiliki kelebihan dibanding bahasa lainnya, beberapa di antaranya:</p>\n<ul>\n<li>Mendukung konkurensi di level bahasa dengan pengaplikasian cukup mudah</li>\n<li>Mendukung pemrosesan data dengan banyak prosesor dalam waktu yang bersamaan&nbsp;<em>(pararel processing)</em></li>\n<li>Memiliki&nbsp;<em>garbage collector</em></li>\n<li>Proses kompilasi sangat cepat</li>\n<li>Bukan bahasa pemrograman yang hirarkial dan bukan&nbsp;<em>strict</em>&nbsp;OOP, memberikan kebebasan ke developer perihal bagaimana cara penulisan kode.</li>\n<li>Dependensi dan&nbsp;<em>tooling</em>&nbsp;yang disediakan terbilang lengkap.</li>\n<li>Dukungan komunitas sangat bagus. Banyak tools yang tersedia secara gratis dan&nbsp;<em>open source</em>&nbsp;yang bisa langsung dimanfaatkan.</li>\n</ul>\n<p>Sudah banyak industri dan perusahaan yg menggunakan Go sampai level production, termasuk di antaranya adalah Google sendiri, dan juga tempat di mana penulis bekerja 😁</p>\n<hr>\n<p>Pada buku ini (terutama semua serial chapter A) kita akan belajar tentang dasar pemrograman Go, mulai dari 0.</p>\n<p><img src="https://dasarpemrogramangolang.novalagung.com/images/A_introduction_1_logo.png" alt="Dasar Pemrograman Golang - The Go Logo"></p>\n</section>\n</div>\n</div>	mancing-belut	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	mancing-belut.png	\N	2023-04-26 18:30:16.220905	2023-04-26 09:30:17.065017+00	1
da4731ca-2a0a-482f-9fdf-468a9d80cf59	awdawdaw	awdawdaw		awdawdaw	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawdaw.png	\N	2023-04-27 12:39:30.743836	2023-04-27 03:39:30.903181+00	1
c682184a-fad9-467d-8c33-cd55e5d85f63	testing	testing	<h1 id="belajar-golang" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 2em; margin-top: 0px !important; margin-right: 0px; margin-bottom: 0.85em; margin-left: 0px; break-after: avoid; font-weight: 700; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: 0.2px; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Belajar Golang</h1><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://golang.org/" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; font-size: inherit; color: rgb(65, 131, 196); background: 0px 0px;">Golang</a></strong><span>&nbsp;</span>(atau biasa disebut dengan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">Go</strong>) adalah bahasa pemrograman yang dikembangkan di<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">Google</strong><span>&nbsp;</span>oleh<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://github.com/griesemer" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; font-size: inherit; color: rgb(65, 131, 196); background: 0px 0px;">Robert Griesemer</a></strong>,<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://en.wikipedia.org/wiki/Rob_Pike" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; font-size: inherit; color: rgb(65, 131, 196); background: 0px 0px;">Rob Pike</a></strong>, dan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://en.wikipedia.org/wiki/Ken_Thompson" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; font-size: inherit; color: rgb(65, 131, 196); background: 0px 0px;">Ken Thompson</a></strong><span>&nbsp;</span>pada tahun 2007 dan mulai diperkenalkan ke publik tahun 2009.</p><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Penciptaan bahasa Go didasari bahasa<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">C</strong><span>&nbsp;</span>dan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">C++</strong>, oleh karena itu gaya sintaksnya mirip.</p><h4 id="kelebihan-go" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 1.25em; orphans: 3; widows: 3; break-after: avoid; margin-top: 1.275em; margin-bottom: 0.85em; font-weight: 700; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Kelebihan Go</h4><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Go memiliki kelebihan dibanding bahasa lainnya, beberapa di antaranya:</p><ul style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; margin: 0px 0px 0.85em; padding: 0px 0px 0px 2em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Mendukung konkurensi di level bahasa dengan pengaplikasian cukup mudah</li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Mendukung pemrosesan data dengan banyak prosesor dalam waktu yang bersamaan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit; font-style: italic;">(pararel processing)</em></li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Memiliki<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit; font-style: italic;">garbage collector</em></li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Proses kompilasi sangat cepat</li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Bukan bahasa pemrograman yang hirarkial dan bukan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit; font-style: italic;">strict</em><span>&nbsp;</span>OOP, memberikan kebebasan ke developer perihal bagaimana cara penulisan kode.</li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Dependensi dan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit; font-style: italic;">tooling</em><span>&nbsp;</span>yang disediakan terbilang lengkap.</li><li style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit;">Dukungan komunitas sangat bagus. Banyak tools yang tersedia secara gratis dan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: inherit; font-style: italic;">open source</em><span>&nbsp;</span>yang bisa langsung dimanfaatkan.</li></ul><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Sudah banyak industri dan perusahaan yg menggunakan Go sampai level production, termasuk di antaranya adalah Google sendiri, dan juga tempat di mana penulis bekerja 😁</p><hr style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; height: 4px; font-size: 16px; padding: 0px; margin: 1.7em 0px; overflow: hidden; background-color: rgb(231, 231, 231); border: none; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Pada buku ini (terutama semua serial chapter A) kita akan belajar tentang dasar pemrograman Go, mulai dari 0.</p><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-size: 16px; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0px !important; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><img src="https://dasarpemrogramangolang.novalagung.com/images/A_introduction_1_logo.png" alt="Dasar Pemrograman Golang - The Go Logo" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; border: 0px; font-size: inherit; break-inside: avoid; max-width: 100%;"></p>	awdawwa	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	awdawwa.png	\N	2023-04-27 12:44:45.778811	2023-04-27 03:44:45.702579+00	1
903d91d0-73b9-486c-a0ff-e64cff774ad7	septiyan	septiyan		septiyan	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septiyan.png	\N	2023-04-27 15:43:36.307066	2023-04-27 06:43:36.17123+00	1
c402992c-2365-4ec6-a3db-91851dba3af7	septiyan	septiyan		septiyan	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septiyan.png	\N	2023-04-27 15:43:46.75943	2023-04-27 06:43:46.61942+00	1
12a59446-df06-4ab9-991a-a67c0e4ecf58	septiyan	septiyan		septiyan	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septiyan.png	\N	2023-04-27 15:46:17.444392	2023-04-27 06:46:17.303766+00	1
333e772b-8c25-454e-971e-3b43ecebb780	septiyan	septiyan		septiyan	1	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septiyan.png	\N	2023-04-27 15:47:34.902349	2023-04-27 06:47:34.761726+00	1
1f5c9752-dde3-43a4-8a33-e69cd3895598	septi asep	septi asep	<h1 id="belajar-golang" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; margin-right: 0px; margin-bottom: 0.85em; margin-left: 0px; break-after: avoid; font-weight: 700; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: 0.2px; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; margin-top: 0px !important; font-size: 2em;">Belajar Golang</h1><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;"><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://golang.org/" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; color: rgb(65, 131, 196); background: 0px 0px; font-size: inherit;">Golang</a></strong><span>&nbsp;</span>(atau biasa disebut dengan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">Go</strong>) adalah bahasa pemrograman yang dikembangkan di<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">Google</strong><span>&nbsp;</span>oleh<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://github.com/griesemer" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; color: rgb(65, 131, 196); background: 0px 0px; font-size: inherit;">Robert Griesemer</a></strong>,<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://en.wikipedia.org/wiki/Rob_Pike" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; color: rgb(65, 131, 196); background: 0px 0px; font-size: inherit;">Rob Pike</a></strong>, dan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;"><a href="https://en.wikipedia.org/wiki/Ken_Thompson" target="_blank" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; text-decoration: none; color: rgb(65, 131, 196); background: 0px 0px; font-size: inherit;">Ken Thompson</a></strong><span>&nbsp;</span>pada tahun 2007 dan mulai diperkenalkan ke publik tahun 2009.</p><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;">Penciptaan bahasa Go didasari bahasa<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">C</strong><span>&nbsp;</span>dan<span>&nbsp;</span><strong style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-weight: 700; font-size: inherit;">C++</strong>, oleh karena itu gaya sintaksnya mirip.</p><h4 id="kelebihan-go" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; break-after: avoid; margin-top: 1.275em; margin-bottom: 0.85em; font-weight: 700; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 1.25em;">Kelebihan Go</h4><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;">Go memiliki kelebihan dibanding bahasa lainnya, beberapa di antaranya:</p><ul style="list-style-type: circle;"><li style="margin-left: 20px;">Mendukung konkurensi di level bahasa dengan pengaplikasian cukup mudah</li><li style="margin-left: 20px;">Memiliki<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">garbage collector</em></li><li style="margin-left: 20px;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">Mendukung pemrosesan data dengan banyak prosesor dalam waktu yang bersamaan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">(pararel processing)</em></em></li><li style="margin-left: 20px;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">Proses kompilasi sangat cepat</em></em></li><li style="margin-left: 20px;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">Bukan bahasa pemrograman yang hirarkial dan bukan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">strict</em><span>&nbsp;</span>OOP, memberikan kebebasan ke developer perihal bagaimana cara penulisan kode.</em></em></li><li style="margin-left: 20px;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">Dependensi dan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">tooling</em><span>&nbsp;</span>yang disediakan terbilang lengkap.</em></em></li><li style="margin-left: 20px;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">Dukungan komunitas sangat bagus. Banyak tools yang tersedia secara gratis dan<span>&nbsp;</span><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;">open source</em><span>&nbsp;</span>yang bisa langsung dimanfaatkan.</em></em><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><em style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; font-style: italic; font-size: inherit;"><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;"><br>Sudah banyak industri dan perusahaan yg menggunakan Go sampai level production, termasuk di antaranya adalah Google sendiri, dan juga tempat di mana penulis bekerja 😁</p></em></em></li></ul><pre>septiyan adalah&nbsp;<br></pre><hr style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; height: 4px; padding: 0px; margin: 1.7em 0px; overflow: hidden; background-color: rgb(231, 231, 231); border: none; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;"><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; margin-bottom: 0.85em; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; font-size: 16px;">Pada buku ini (terutama semua serial chapter A) kita akan belajar tentang dasar pemrograman Go, mulai dari 0.</p><p style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; orphans: 3; widows: 3; margin-top: 0px; color: rgb(51, 51, 51); font-family: &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: 0.2px; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; margin-bottom: 0px !important; font-size: 16px;"><img src="https://dasarpemrogramangolang.novalagung.com/images/A_introduction_1_logo.png" alt="Dasar Pemrograman Golang - The Go Logo" style="box-sizing: border-box; -webkit-tap-highlight-color: transparent; text-size-adjust: none; -webkit-font-smoothing: antialiased; border: 0px; break-inside: avoid; max-width: 100%; font-size: inherit;"></p>	septi-asep	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septi-asep.png	\N	2023-04-27 15:51:57.97412	2023-04-27 06:51:58.061735+00	1
f80a3147-a262-41d7-b3ae-7f894169556d	teting code	testing code	<pre>type&nbsp;feedHandler struct {<br>    services feed.Services</pre><pre>&nbsp;&nbsp;&nbsp;&nbsp;dbs cdc.KedaiHelper<br>}<br><br><br></pre><p>Testing Quote</p><blockquote>testing quote ygy</blockquote>	teting-code	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	teting-code.png	\N	2023-04-27 19:33:50.903432	2023-04-27 10:33:50.913046+00	1
b9b304ff-e452-47c4-974d-6063b764f2b0	Berkenalan Dengan Golang	berkenalan-dengan-golang	ini adalah bodyh article	berkenalan-dengan-golang	db90dd5d-9abd-4db1-9105-fb11a1eb7695	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	berkenalan-dengan-golang.png	\N	2023-04-29 02:20:55.543299	2023-04-28 17:20:55.543618+00	1
147ceefd-ef99-4ec0-9637-148a120622c5	Dhshsjsj	Shejsjjee	<p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">Rhuehehe</font></font></p>	dhshsjsj	2	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	dhshsjsj.jpeg	\N	2023-04-30 19:40:36.169313	2023-04-30 10:40:36.16964+00	1
1b5aa7c4-779c-46f3-b7dd-da4f7b69cef1	Dhshsjsj	Shejsjjee	<p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">Rhuehehe</font></font></p>	dhshsjsj	2	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	dhshsjsj.jpeg	\N	2023-04-30 19:40:37.6956	2023-04-30 10:40:37.695937+00	1
8cbe8947-151a-41ea-a749-a678369483cc	testing testing yak	testing testing yak	<p>testing testing yak</p>	testing-testing-yak	5bf74c04-4e47-4e6e-b154-02eed8136ea6	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-yak.jpeg	\N	2023-05-02 18:54:32.619195	2023-05-02 09:54:32.737638+00	1
53879f46-2b86-40d9-874f-6d3aa161d08b	testing testing hayokkk sukses	testing testing hayokkk sukses	<p>testing testing hayokkk sukses</p>	testing-testing-hayokkk-sukses	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses.jpeg	\N	2023-05-02 19:02:41.597337	2023-05-02 10:02:41.597692+00	1
371d79c4-ab63-4922-a6f9-330655930c49	testing testing hayokkk sukses1	testing testing hayokkk sukses1	<p>testing testing hayokkk sukses1</p>	testing-testing-hayokkk-sukses1	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses1.jpeg	\N	2023-05-02 19:14:08.942985	2023-05-02 10:14:08.943395+00	1
b20673fc-0a03-49df-8a41-5bf0525a4921	testing testing hayokkk sukses1	testing testing hayokkk sukses1	<p>testing testing hayokkk sukses1</p>	testing-testing-hayokkk-sukses1	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses1.jpeg	\N	2023-05-02 19:14:53.088867	2023-05-02 10:14:53.089173+00	1
a83f5fe5-24e9-4094-a127-ca2787bb9f91	testing testing hayokkk sukses1	testing testing hayokkk sukses1	<p>testing testing hayokkk sukses1</p>	testing-testing-hayokkk-sukses1	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses1.jpeg	\N	2023-05-02 19:16:03.899744	2023-05-02 10:16:03.900077+00	1
7f86498a-0b18-4e8b-8d27-0e1de7e244c7	testing testing hayokkk sukses12	testing testing hayokkk sukses1	<p>testing testing hayokkk sukses1</p>	testing-testing-hayokkk-sukses12	51ec668c-6a5a-4c30-b6bf-53f8e72980be	79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	testing-testing-hayokkk-sukses12.jpeg	\N	2023-05-02 19:16:12.821223	2023-05-02 10:16:12.821553+00	1
\.


--
-- TOC entry 3342 (class 0 OID 16397)
-- Dependencies: 215
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesses (business_id, business_name, business_description, domain, is_active, created_at, updated_at) FROM stdin;
78644a5d-7ab5-4730-8090-c9609eb0b11e	Kedai Edukasi	Website Kedaiedukasi.id Adalah Webite Blog Untuk Edukasi Seputar Teknologi Informasi	https://edukasi.kedaiprogrammer.com	t	2023-04-09 13:55:29.764618	0001-01-01 00:00:00+00
05cea9db-b05a-4306-88ff-b9e2e871a237	Kedai Programmer Indonesia	Website Kedai Programmer Indonesia Adalah Webite Jasa Pembuatan Website	https://kedaiprogrammer.com	t	2023-04-10 03:14:32.428529	0001-01-01 00:00:00+00
\.


--
-- TOC entry 3344 (class 0 OID 16416)
-- Dependencies: 217
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name, tag, is_active, service_id, created_at, updated_at) FROM stdin;
925f7c5b-2214-428e-8953-22dfdafcd260	Programming	Software Developer	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:14:27.915751	0001-01-01 00:00:00+00
8b4c2c6e-3016-4dee-96fe-b95153b0f5ea	Programming	Javascript	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:14:40.035877	0001-01-01 00:00:00+00
3b2fbea3-0380-4c71-ba02-fd8a1c362021	Programming	Web Development	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:15:10.916514	0001-01-01 00:00:00+00
5d1140b0-89d6-4d8e-90dd-fbdb217a3b8d	Programming	Python	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:15:26.42789	0001-01-01 00:00:00+00
2890d95e-9b16-44b4-8f11-82261ef812c4	Programming	Software Engineering	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:10.299879	0001-01-01 00:00:00+00
db90dd5d-9abd-4db1-9105-fb11a1eb7695	Programming	Golang	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:23.899714	0001-01-01 00:00:00+00
e270b9bd-f0bc-4135-b91e-6445be510f7f	Programming	NextJS	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:27.395454	0001-01-01 00:00:00+00
ba5aaaba-8177-4275-bd61-005bc3f8fdba	Programming	ReactJS	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:30.187641	0001-01-01 00:00:00+00
cff79c34-9581-449b-b358-408830e12b52	Programming	React Native	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:34.27556	0001-01-01 00:00:00+00
51ec668c-6a5a-4c30-b6bf-53f8e72980be	Programming	Laravel	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:40.87568	0001-01-01 00:00:00+00
e8daa3fe-adec-43dd-b4dc-ee861db5a7d0	Programming	HTML	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:44.059396	0001-01-01 00:00:00+00
66c6f8b6-8a70-463b-93f4-44f425f9173e	Programming	Codeigniter	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:48.267578	0001-01-01 00:00:00+00
e438a111-eedb-4779-9b55-fd3831aff5a6	Programming	Tailwind CSS	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:57.740226	0001-01-01 00:00:00+00
5bf74c04-4e47-4e6e-b154-02eed8136ea6	Data Science	Data Science	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:00.19579	0001-01-01 00:00:00+00
adfbc775-6eab-43fb-a6e9-e54c4972d38a	Teknologi	Machine Learning	t	e4480957-16de-43a8-92e1-58234e8411f0	2023-04-20 02:16:17.947671	0001-01-01 00:00:00+00
\.


--
-- TOC entry 3343 (class 0 OID 16410)
-- Dependencies: 216
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, service_name, is_active, business_id, created_at, updated_at) FROM stdin;
caf03b23-aceb-47c6-8aea-40125a1c1a94	Manage Content Sosial Media	t	05cea9db-b05a-4306-88ff-b9e2e871a237	2023-04-10 03:15:20.640566	0001-01-01 00:00:00+00
e4480957-16de-43a8-92e1-58234e8411f0	Edukasi	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-17 03:41:33.86546	0001-01-01 00:00:00+00
a450d849-a273-4c19-974f-a0bd7b4468d1	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:30:19.012451	0001-01-01 00:00:00+00
c3e012c0-3892-48ed-bec1-cced9d31b015	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:34:53.759098	0001-01-01 00:00:00+00
676f9bff-9ffa-49d3-8ec7-4289dffec8cc	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:36:31.587401	0001-01-01 00:00:00+00
8f68aedb-6136-41a5-ab14-0b67e6fa3610	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:39:02.547698	0001-01-01 00:00:00+00
f9ed5662-c9e9-4ca3-899f-ae8e66ba693b	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:41:02.095166	0001-01-01 00:00:00+00
f2b0cbe6-7bf2-4d8a-9fe6-c8803d347635	Blog Edukasi 1	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-24 04:42:14.75125	0001-01-01 00:00:00+00
f9ac8a5e-be1b-4747-a436-53b8c62d3dea	awdawd	t	dwadawwa	2023-04-25 02:26:28.369046	0001-01-01 00:00:00+00
1260c5d6-73fd-42ba-82fa-f0663c040aec	awdawdawdawdwa	t	awdawdawdawdwa	2023-04-25 02:27:38.3851	0001-01-01 00:00:00+00
29b5ff98-11c9-4d9d-9240-40107e59a4ee	awdawwdawawawdawdawdaw	t	adwww	2023-04-25 02:29:43.073031	0001-01-01 00:00:00+00
b3941516-c0a2-435b-b306-5659ce0bce97	Jasa Pembuatan Website	t	05cea9db-b05a-4306-88ff-b9e2e871a237	2023-04-25 02:37:00.563774	0001-01-01 00:00:00+00
2ef45153-adb2-42bf-9341-4c607a690e7c	https://cms.kedaiprogrammer.com	t	05cea9db-b05a-4306-88ff-b9e2e871a237	2023-04-25 02:37:31.095714	0001-01-01 00:00:00+00
8c8b219a-6938-447b-bd9c-624d0ddbd89f	<p>     <span style="font-size: 18px;">Quill Rich Text Editor</span> </p> <p>     <br> </p> <p>Quill is a free,     <a href="https://github.com/quilljs/quill/" target="_blank">open source</a>WYSIWYG editor built for the modern web. With its     <a href="http://quilljs.com/docs/modules/" target="_blank">extensible architecture</a>and a     <a href="http://quilljs.com/docs/api/" target="_blank">expressive API</a>you can completely customize it to fulfill your needs. Some built in features include:</p> <p>     <br> </p> <ul>     <li>Fast and lightweight</li>     <li>Semantic markup</li>     <li>Standardized HTML between browsers</li>     <li>Cross browser support including Chrome, Firefox, Safari, and IE 9+</li> </ul> <p>     <br> </p> <p>     <span style="font-size: 18px;">Downloads</span> </p> <p>     <br> </p> <ul>     <li>         <a href="https://quilljs.com" target="_blank">Quill.js</a>, the free, open source WYSIWYG editor</li>     <li>         <a href="https://zenoamaro.github.io/react-quill" target="_blank">React-quill</a>, a React component that wraps Quill.js</li> </ul>	t	78644a5d-7ab5-4730-8090-c9609eb0b11e	2023-04-26 01:04:43.134072	0001-01-01 00:00:00+00
\.


--
-- TOC entry 3341 (class 0 OID 16389)
-- Dependencies: 214
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (uuid, username, email, password, token, user_info, business_id, role, is_active, created_at, updated_at) FROM stdin;
79e4a3b8-b163-4fd3-8de6-a4a18e0a9b24	septiyan	superadmin@superadmin.com	$2a$10$4WekjsSOIaZpazpbbeE2COponbkbOzXdwAsqcMwIR3MokMX2oOfHW	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiSlI4TlpoQXBXT0lKOWJVMUZYNFN3VDIyc0RlRXc2eUFkSHFBSFhtaDFYVmFuRTUxMHpfbjJpU1hGOG00Z0I5Rm83MFVuQT09IiwidXNlcm5hbWUiOiJzZXB0aXlhbiIsImV4cCI6MTY4OTE0Nzg0Mn0.PeXOL0o0e4baj2jDzEfx_No9RGDdgLeb8LXFPs-6EQE	{"Address": "Jl. KH Hasyim Ashari No.90 RT02 RW03 Kel. Pinang Kec. Pinang Kota Tangerang", "picture": "", "telepon": "081210917179", "full_name": "Septiyan Dwi Nugroho", "business_inheritance": true}		user	t	2023-04-09 06:17:35.018437	0001-01-01 00:00:00+00
\.


-- Completed on 2023-07-13 22:15:50 WIB

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.3

-- Started on 2023-07-13 22:15:50 WIB

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

-- Completed on 2023-07-13 22:15:53 WIB

--
-- PostgreSQL database dump complete
--

-- Completed on 2023-07-13 22:15:53 WIB

--
-- PostgreSQL database cluster dump complete
--

