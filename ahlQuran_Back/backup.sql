--
-- PostgreSQL database dump
--

\restrict Ytnfj1SOiM1NwZSjCPrhfyFSGDC6T6B0FQTTpJgTeWfPsVFgi31aJc0V89NrdQ9

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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
-- Name: participationstatus; Type: TYPE; Schema: public; Owner: Rahim
--

CREATE TYPE public.participationstatus AS ENUM (
    'PRESENT',
    'ABSENT',
    'EXCUSED',
    'LATE',
    'LEFT_EARLY'
);


ALTER TYPE public.participationstatus OWNER TO "Rahim";

--
-- Name: userroleenum; Type: TYPE; Schema: public; Owner: Rahim
--

CREATE TYPE public.userroleenum AS ENUM (
    'PRESIDENT',
    'SUPERVISOR',
    'TEACHER',
    'STUDENT'
);


ALTER TYPE public.userroleenum OWNER TO "Rahim";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.achievements (
    id integer NOT NULL,
    student_id integer NOT NULL,
    from_surah character varying(50) NOT NULL,
    to_surah character varying(50) NOT NULL,
    from_verse integer NOT NULL,
    to_verse integer NOT NULL,
    note text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.achievements OWNER TO "Rahim";

--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.achievements_id_seq OWNER TO "Rahim";

--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    "user" character varying NOT NULL,
    password character varying NOT NULL,
    role character varying NOT NULL,
    created_by_id integer,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.admins OWNER TO "Rahim";

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO "Rahim";

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO "Rahim";

--
-- Name: lecture_teachers; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.lecture_teachers (
    lecture_id integer NOT NULL,
    teacher_id integer NOT NULL
);


ALTER TABLE public.lecture_teachers OWNER TO "Rahim";

--
-- Name: lectures; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.lectures (
    id integer NOT NULL,
    lecture_name_ar character varying(200) NOT NULL,
    lecture_name_en character varying(200) NOT NULL,
    circle_type character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    shown_on_website boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.lectures OWNER TO "Rahim";

--
-- Name: lectures_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.lectures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lectures_id_seq OWNER TO "Rahim";

--
-- Name: lectures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.lectures_id_seq OWNED BY public.lectures.id;


--
-- Name: presidents; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.presidents (
    id integer NOT NULL,
    user_id integer NOT NULL,
    school_name character varying(100) NOT NULL,
    phone_number character varying(20),
    approval_date timestamp without time zone,
    approved_by integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.presidents OWNER TO "Rahim";

--
-- Name: presidents_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.presidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presidents_id_seq OWNER TO "Rahim";

--
-- Name: presidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.presidents_id_seq OWNED BY public.presidents.id;


--
-- Name: session_participations; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.session_participations (
    id integer NOT NULL,
    student_id integer NOT NULL,
    session_id integer NOT NULL,
    status public.participationstatus NOT NULL,
    notes text,
    score double precision,
    verses_recited character varying(100),
    mistakes_count integer,
    memorized_verses character varying(100),
    revision_verses character varying(100),
    behavior_rating integer,
    participation_level integer,
    marked_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    recorded_by_id integer,
    lecture_id integer
);


ALTER TABLE public.session_participations OWNER TO "Rahim";

--
-- Name: session_participations_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.session_participations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.session_participations_id_seq OWNER TO "Rahim";

--
-- Name: session_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.session_participations_id_seq OWNED BY public.session_participations.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    teacher_id integer,
    session_date timestamp without time zone NOT NULL,
    session_time character varying(20) NOT NULL,
    duration_minutes integer NOT NULL,
    topic character varying(200) NOT NULL,
    description text,
    location character varying(100),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.sessions OWNER TO "Rahim";

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO "Rahim";

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.students (
    id integer NOT NULL,
    user_id integer NOT NULL,
    enrollment_date timestamp with time zone NOT NULL,
    parent_name character varying(255),
    parent_phone character varying(20),
    guardian_email character varying(255),
    created_by_id integer NOT NULL,
    "Golden" boolean,
    sex character varying(10),
    date_of_birth character varying(20),
    place_of_birth character varying(100),
    home_address character varying(255),
    nationality character varying(50),
    academic_level character varying(50),
    grade character varying(50),
    school_name character varying(100),
    guardian_id integer,
    first_name_en character varying(50),
    last_name_en character varying(50),
    father_status character varying(50),
    mother_status character varying(50)
);


ALTER TABLE public.students OWNER TO "Rahim";

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_id_seq OWNER TO "Rahim";

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: supervisors; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.supervisors (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.supervisors OWNER TO "Rahim";

--
-- Name: supervisors_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.supervisors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supervisors_id_seq OWNER TO "Rahim";

--
-- Name: supervisors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.supervisors_id_seq OWNED BY public.supervisors.id;


--
-- Name: teachers; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    riwaya character varying(100) NOT NULL,
    hire_date timestamp with time zone NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.teachers OWNER TO "Rahim";

--
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teachers_id_seq OWNER TO "Rahim";

--
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.users (
    id integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    role public.userroleenum NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE public.users OWNER TO "Rahim";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO "Rahim";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: weekly_schedules; Type: TABLE; Schema: public; Owner: Rahim
--

CREATE TABLE public.weekly_schedules (
    id integer NOT NULL,
    lecture_id integer NOT NULL,
    day_of_week character varying(20) NOT NULL,
    start_time character varying(10) NOT NULL,
    end_time character varying(10) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.weekly_schedules OWNER TO "Rahim";

--
-- Name: weekly_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: Rahim
--

CREATE SEQUENCE public.weekly_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weekly_schedules_id_seq OWNER TO "Rahim";

--
-- Name: weekly_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Rahim
--

ALTER SEQUENCE public.weekly_schedules_id_seq OWNED BY public.weekly_schedules.id;


--
-- Name: achievements id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: lectures id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.lectures ALTER COLUMN id SET DEFAULT nextval('public.lectures_id_seq'::regclass);


--
-- Name: presidents id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.presidents ALTER COLUMN id SET DEFAULT nextval('public.presidents_id_seq'::regclass);


--
-- Name: session_participations id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations ALTER COLUMN id SET DEFAULT nextval('public.session_participations_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: supervisors id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.supervisors ALTER COLUMN id SET DEFAULT nextval('public.supervisors_id_seq'::regclass);


--
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: weekly_schedules id; Type: DEFAULT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.weekly_schedules ALTER COLUMN id SET DEFAULT nextval('public.weekly_schedules_id_seq'::regclass);


--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.achievements (id, student_id, from_surah, to_surah, from_verse, to_verse, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.admins (id, "user", password, role, created_by_id, created_at) FROM stdin;
1	admin	admin123	admin	\N	2025-12-12 18:38:55.268902+00
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.alembic_version (version_num) FROM stdin;
282029d1d9cb
\.


--
-- Data for Name: lecture_teachers; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.lecture_teachers (lecture_id, teacher_id) FROM stdin;
\.


--
-- Data for Name: lectures; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.lectures (id, lecture_name_ar, lecture_name_en, circle_type, category, shown_on_website, created_at, updated_at) FROM stdin;
1	حلقة أحمدجج	ahmed lectur	memorization and revision	male	t	2025-12-14 14:15:30.300166+00	2025-12-14 15:14:41.412039+00
\.


--
-- Data for Name: presidents; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.presidents (id, user_id, school_name, phone_number, approval_date, approved_by, created_at, is_verified) FROM stdin;
2	2	سلمان الفارسي	\N	\N	\N	2025-12-12 18:45:21.434315+00	f
3	3	سلمان الفارسي	\N	\N	\N	2025-12-12 18:45:42.422488+00	f
4	4	سلمان الفارسي	\N	\N	\N	2025-12-12 18:48:52.842527+00	f
5	5	سلمان الفارسي	\N	\N	\N	2025-12-12 18:50:44.476185+00	f
1	1	سلمان الفارسي	\N	2025-12-12 19:06:07.652237	\N	2025-12-12 18:41:23.41316+00	f
\.


--
-- Data for Name: session_participations; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.session_participations (id, student_id, session_id, status, notes, score, verses_recited, mistakes_count, memorized_verses, revision_verses, behavior_rating, participation_level, marked_at, updated_at, recorded_by_id, lecture_id) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.sessions (id, teacher_id, session_date, session_time, duration_minutes, topic, description, location, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.students (id, user_id, enrollment_date, parent_name, parent_phone, guardian_email, created_by_id, "Golden", sex, date_of_birth, place_of_birth, home_address, nationality, academic_level, grade, school_name, guardian_id, first_name_en, last_name_en, father_status, mother_status) FROM stdin;
2	13	2025-12-13 16:02:05.966482+00	hd dfd	0555368741	df@gmail.com	1	f	male	2011-12-13	bourouba	aadl	Algerian	متوسط	سنة اولى متوسط	lyayda	\N	\N	\N	\N	\N
3	14	2025-12-14 12:02:15.39731+00	\N	055889966	\N	1	f	male	2012-12-14	alharachh	aadl	Algerian	تحضيري	تحضيري	ad	\N	ahmedr	moutasim	alive	alive
\.


--
-- Data for Name: supervisors; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.supervisors (id, user_id, created_by_id, created_at) FROM stdin;
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.teachers (id, user_id, riwaya, hire_date, created_by_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.users (id, firstname, lastname, email, hashed_password, role, is_active) FROM stdin;
2	younes	pres	younew@gmail.com	koko1234_?	PRESIDENT	f
3	younes	pres	younes@gmail.com	koko1234_?	PRESIDENT	f
4	abdou	abd	abdou@gmail.com	koko1234_?	PRESIDENT	f
5	abdou	abd	abdouu@gmail.com	koko1234_?	PRESIDENT	f
1	raouf	fer	raoufer@gmail.com	koko1234_?	PRESIDENT	t
12	'rtrty	terte	ertert@gmail.com	$2b$12$jNTMshJ7zx4moSZwuduOKuDhJ44I.3egvbkmvJl8La0e/rcEooX8y	STUDENT	t
13	أحمد	يعقوب	yakoube@gmail.com	$2b$12$1eIsEjFhRUesL/0WfAxOqelBm5wjSF54xXnQ.EwWH3U7Y9.YDV0Y2	STUDENT	t
14	أحمد	معتصم	ahmedmoutasim@gmail.com	$2b$12$px3lATnkXd5IiJtvr1CuJ.zR6S7QknYNE8gw44E7bJNTj0MVRTbJe	STUDENT	t
\.


--
-- Data for Name: weekly_schedules; Type: TABLE DATA; Schema: public; Owner: Rahim
--

COPY public.weekly_schedules (id, lecture_id, day_of_week, start_time, end_time, created_at) FROM stdin;
8	1	السبت	15:15	17:15	2025-12-14 15:14:41.413122+00
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.achievements_id_seq', 1, false);


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- Name: lectures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.lectures_id_seq', 2, true);


--
-- Name: presidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.presidents_id_seq', 5, true);


--
-- Name: session_participations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.session_participations_id_seq', 1, false);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.sessions_id_seq', 1, false);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.students_id_seq', 3, true);


--
-- Name: supervisors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.supervisors_id_seq', 1, false);


--
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.teachers_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.users_id_seq', 14, true);


--
-- Name: weekly_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Rahim
--

SELECT pg_catalog.setval('public.weekly_schedules_id_seq', 8, true);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: lecture_teachers lecture_teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.lecture_teachers
    ADD CONSTRAINT lecture_teachers_pkey PRIMARY KEY (lecture_id, teacher_id);


--
-- Name: lectures lectures_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT lectures_pkey PRIMARY KEY (id);


--
-- Name: presidents presidents_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.presidents
    ADD CONSTRAINT presidents_pkey PRIMARY KEY (id);


--
-- Name: session_participations session_participations_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations
    ADD CONSTRAINT session_participations_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: supervisors supervisors_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.supervisors
    ADD CONSTRAINT supervisors_pkey PRIMARY KEY (id);


--
-- Name: supervisors supervisors_user_id_key; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.supervisors
    ADD CONSTRAINT supervisors_user_id_key UNIQUE (user_id);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_key UNIQUE (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: weekly_schedules weekly_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.weekly_schedules
    ADD CONSTRAINT weekly_schedules_pkey PRIMARY KEY (id);


--
-- Name: ix_achievements_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_achievements_id ON public.achievements USING btree (id);


--
-- Name: ix_admins_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_admins_id ON public.admins USING btree (id);


--
-- Name: ix_admins_user; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE UNIQUE INDEX ix_admins_user ON public.admins USING btree ("user");


--
-- Name: ix_lectures_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_lectures_id ON public.lectures USING btree (id);


--
-- Name: ix_presidents_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_presidents_id ON public.presidents USING btree (id);


--
-- Name: ix_presidents_user_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE UNIQUE INDEX ix_presidents_user_id ON public.presidents USING btree (user_id);


--
-- Name: ix_session_participations_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_session_participations_id ON public.session_participations USING btree (id);


--
-- Name: ix_session_participations_lecture_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_session_participations_lecture_id ON public.session_participations USING btree (lecture_id);


--
-- Name: ix_session_participations_session_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_session_participations_session_id ON public.session_participations USING btree (session_id);


--
-- Name: ix_session_participations_student_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_session_participations_student_id ON public.session_participations USING btree (student_id);


--
-- Name: ix_sessions_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_sessions_id ON public.sessions USING btree (id);


--
-- Name: ix_students_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_students_id ON public.students USING btree (id);


--
-- Name: ix_supervisors_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_supervisors_id ON public.supervisors USING btree (id);


--
-- Name: ix_teachers_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_teachers_id ON public.teachers USING btree (id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_weekly_schedules_id; Type: INDEX; Schema: public; Owner: Rahim
--

CREATE INDEX ix_weekly_schedules_id ON public.weekly_schedules USING btree (id);


--
-- Name: achievements achievements_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: lecture_teachers lecture_teachers_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.lecture_teachers
    ADD CONSTRAINT lecture_teachers_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lectures(id) ON DELETE CASCADE;


--
-- Name: lecture_teachers lecture_teachers_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.lecture_teachers
    ADD CONSTRAINT lecture_teachers_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


--
-- Name: presidents presidents_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.presidents
    ADD CONSTRAINT presidents_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.admins(id) ON DELETE SET NULL;


--
-- Name: presidents presidents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.presidents
    ADD CONSTRAINT presidents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: session_participations session_participations_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations
    ADD CONSTRAINT session_participations_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lectures(id) ON DELETE SET NULL;


--
-- Name: session_participations session_participations_recorded_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations
    ADD CONSTRAINT session_participations_recorded_by_id_fkey FOREIGN KEY (recorded_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: session_participations session_participations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations
    ADD CONSTRAINT session_participations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: session_participations session_participations_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.session_participations
    ADD CONSTRAINT session_participations_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: students students_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: supervisors supervisors_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.supervisors
    ADD CONSTRAINT supervisors_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: supervisors supervisors_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.supervisors
    ADD CONSTRAINT supervisors_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: teachers teachers_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: teachers teachers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: weekly_schedules weekly_schedules_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Rahim
--

ALTER TABLE ONLY public.weekly_schedules
    ADD CONSTRAINT weekly_schedules_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lectures(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Ytnfj1SOiM1NwZSjCPrhfyFSGDC6T6B0FQTTpJgTeWfPsVFgi31aJc0V89NrdQ9

