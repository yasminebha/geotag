--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: point; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.point AS (
	lng numeric,
	lat numeric
);


ALTER TYPE public.point OWNER TO postgres;

--
-- Name: publication; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.publication AS (
	id bigint,
	user_id uuid,
	description text,
	tags jsonb,
	user_metadata jsonb,
	geo point,
	distance numeric,
	created_at timestamp without time zone
);


ALTER TYPE public.publication OWNER TO postgres;

--
-- Name: tagged_post; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tagged_post AS (
	id bigint,
	user_id uuid,
	description text,
	tags jsonb,
	user_metadata jsonb,
	geo point,
	created_at timestamp with time zone
);


ALTER TYPE public.tagged_post OWNER TO postgres;

--
-- Name: create_friendship(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_friendship(user_id bigint, friend_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
friend_exists INTEGER;
begin
  SELECT COUNT(*) INTO friend_exists
  FROM friendships
  WHERE ("userID" = create_friendship.user_id and "friendID" = create_friendship.friend_id)
    OR ("friendID" = create_friendship.user_id and "userID" = create_friendship.friend_id);
  
  -- if friendship doesn't exist, create it
  IF friend_exists = 0 THEN
    INSERT INTO friendships("userID","friendID")
    VALUES (create_friendship.user_id,create_friendship.friend_id);
    INSERT INTO friendships("userID","friendID")
    VALUES (create_friendship.friend_id,create_friendship.user_id);
  END IF;
END;          
$$;


ALTER FUNCTION public.create_friendship(user_id bigint, friend_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userID" uuid NOT NULL,
    description text,
    geo point
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: create_post(uuid, text, character varying[], point); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_post(user_id uuid, description text, tags character varying[], geo point) RETURNS public.posts
    LANGUAGE plpgsql
    AS $$
declare
inserted_post public.posts;
current_tag public.tags;
begin
  insert into posts("userID", description, geo) values (create_post.user_id, create_post.description, create_post.geo) returning * into inserted_post;
  for i in array_lower(create_post.tags, 1)..array_upper(create_post.tags, 1) loop
     
    if (select count(*) = 0 from public.tags where "tagName" = create_post.tags[i]) then
      insert into public.tags("tagName") values (create_post.tags[i]); 
    end if;

    insert into public.postags("tagID","postID") values (create_post.tags[i], inserted_post.id);
  end loop;

  return inserted_post;
end;          
$$;


ALTER FUNCTION public.create_post(user_id uuid, description text, tags character varying[], geo point) OWNER TO postgres;

--
-- Name: deletePostByID(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."deletePostByID"(post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Delete all media files associated with the post
    DELETE FROM medias WHERE "postID" = post_id;

    -- Delete the post itself
    DELETE FROM posts WHERE id = post_id;
END;
$$;


ALTER FUNCTION public."deletePostByID"(post_id integer) OWNER TO postgres;

--
-- Name: get_nearby_posts(numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_nearby_posts(lng numeric, lat numeric, rad numeric) RETURNS SETOF public.publication
    LANGUAGE plpgsql
    AS $$
DECLARE
    r publication%rowtype;
BEGIN
    FOR r IN
      SELECT 
        posts.id as id, 
        auth.users.id as user_id,
        description as description,
        get_post_tags(posts.id)as tags,
        auth.users.raw_user_meta_data as user_metadata, 
        geo, 
        posts.geo<@>point(lng, lat) as distance, 
        posts.created_at as created_at
      FROM 
        posts JOIN auth.users 
        ON posts."userID" = auth.users.id
      WHERE 
        posts.geo<@>point(lng, lat) < rad
     
      ORDER BY distance
    LOOP
       RETURN NEXT r;
    END LOOP;
    RETURN;
END;
$$;


ALTER FUNCTION public.get_nearby_posts(lng numeric, lat numeric, rad numeric) OWNER TO postgres;

--
-- Name: get_post_tags(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_post_tags(post_id bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  results jsonb;
BEGIN
    SELECT jsonb_agg("tagID")
   
     FROM public.postags
      WHERE "postID" = post_id
     into results; 
  return results;
END;
 $$;


ALTER FUNCTION public.get_post_tags(post_id bigint) OWNER TO postgres;

--
-- Name: remove_friendship(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_friendship(user_id bigint, friend_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
delete from friendships
where ("userID" = remove_friendship.user_id and "friendID" = remove_friendship.friend_id)
OR
("friendID" = remove_friendship.user_id and "userID" = remove_friendship.friend_id);               
END;
$$;


ALTER FUNCTION public.remove_friendship(user_id bigint, friend_id bigint) OWNER TO postgres;

--
-- Name: search_posts_by_tag_link(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_posts_by_tag_link(tag character varying) RETURNS SETOF public.tagged_post
    LANGUAGE plpgsql
    AS $$
declare
  r public.tagged_post%rowtype;
begin
 FOR r IN
      SELECT 
        posts.id as id, 
        auth.users.id as user_id,
        description as description,
        get_post_tags(posts.id)as tags,
        auth.users.raw_user_meta_data as user_metadata, 
        geo,
        posts.created_at as created_at
       
      FROM 
      postags Join posts on postags."postID"=posts.id
      JOIN auth.users ON auth.users.id = posts."userID"
      WHERE 
        postags."tagID" = tag
    LOOP
       RETURN NEXT r;
    END LOOP;
    RETURN;
END;
$$;


ALTER FUNCTION public.search_posts_by_tag_link(tag character varying) OWNER TO postgres;

--
-- Name: friendships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friendships (
    created_at timestamp with time zone DEFAULT now(),
    "userID" bigint NOT NULL,
    "friendID" bigint NOT NULL
);


ALTER TABLE public.friendships OWNER TO postgres;

--
-- Name: medias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medias (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    type text NOT NULL,
    source text NOT NULL,
    "postID" bigint
);


ALTER TABLE public.medias OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.medias ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: postags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.postags (
    created_at timestamp with time zone DEFAULT now(),
    "postID" bigint NOT NULL,
    "tagID" character varying NOT NULL
);


ALTER TABLE public.postags OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.posts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id bigint NOT NULL,
    username text NOT NULL,
    biography text,
    picture text,
    created_at timestamp with time zone DEFAULT now(),
    "userID" uuid NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    "tagName" character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friendships (created_at, "userID", "friendID") FROM stdin;
\.


--
-- Data for Name: medias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medias (id, created_at, type, source, "postID") FROM stdin;
57	2023-02-01 18:28:48.535188+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675276125916.jpeg	53
58	2023-02-01 18:33:04.04341+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/2954a3b1-8b72-4b76-a9a4-14548f381701/images/1675276381170.jpeg	54
67	2023-02-13 08:40:52.04343+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1676277650406.jpeg	60
68	2023-04-07 23:38:13.074641+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1680910690910.svg+xml	100
\.


--
-- Data for Name: postags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.postags (created_at, "postID", "tagID") FROM stdin;
2023-04-07 23:38:11.629784+00	100	food
2023-04-08 01:56:30.649074+00	60	food
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, created_at, "userID", description, geo) FROM stdin;
54	2023-02-01 18:33:01.414035+00	2954a3b1-8b72-4b76-a9a4-14548f381701	3rd post by 2nd user	(10.5596815,35.9118987)
53	2023-02-01 18:28:45+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2nd post	(10.562417,35.913885)
60	2023-02-13 08:40:49.965386+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	7th post	(10.7600196,34.739822)
100	2023-04-07 23:38:11.629784+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	perle	(10.7600196,34.739822)
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, username, biography, picture, created_at, "userID") FROM stdin;
28	yasminebha	\N	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/yasminebhacactus.jpg	2023-02-01 18:11:07.492544+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3
29	yasmine2bha	\N	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/yasmine2bhapothos.jpg	2023-02-01 18:32:04.474109+00	2954a3b1-8b72-4b76-a9a4-14548f381701
30	ouchema	\N	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/ouchemaundefined	2023-02-05 12:58:43.379013+00	314decbc-a5b7-45fb-8217-0fa8b37f3139
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags ("tagName", created_at) FROM stdin;
food	2023-04-07 23:38:11.629784+00
\.


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_id_seq', 68, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 100, true);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 30, true);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY ("userID", "friendID");


--
-- Name: medias media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: postags postags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postags
    ADD CONSTRAINT postags_pkey PRIMARY KEY ("postID", "tagID");


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY ("tagName");


--
-- Name: friendships friendships_friendID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT "friendships_friendID_fkey" FOREIGN KEY ("friendID") REFERENCES public.profiles(id);


--
-- Name: friendships friendships_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT "friendships_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.profiles(id);


--
-- Name: medias medias_postID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT "medias_postID_fkey" FOREIGN KEY ("postID") REFERENCES public.posts(id);


--
-- Name: postags postags_postID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postags
    ADD CONSTRAINT "postags_postID_fkey" FOREIGN KEY ("postID") REFERENCES public.posts(id);


--
-- Name: postags postags_tagID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postags
    ADD CONSTRAINT "postags_tagID_fkey" FOREIGN KEY ("tagID") REFERENCES public.tags("tagName");


--
-- Name: posts posts_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT "posts_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id);


--
-- Name: profiles profiles_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT "profiles_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION create_friendship(user_id bigint, friend_id bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_friendship(user_id bigint, friend_id bigint) TO anon;
GRANT ALL ON FUNCTION public.create_friendship(user_id bigint, friend_id bigint) TO authenticated;
GRANT ALL ON FUNCTION public.create_friendship(user_id bigint, friend_id bigint) TO service_role;


--
-- Name: TABLE posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.posts TO anon;
GRANT ALL ON TABLE public.posts TO authenticated;
GRANT ALL ON TABLE public.posts TO service_role;


--
-- Name: FUNCTION create_post(user_id uuid, description text, tags character varying[], geo point); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_post(user_id uuid, description text, tags character varying[], geo point) TO anon;
GRANT ALL ON FUNCTION public.create_post(user_id uuid, description text, tags character varying[], geo point) TO authenticated;
GRANT ALL ON FUNCTION public.create_post(user_id uuid, description text, tags character varying[], geo point) TO service_role;


--
-- Name: FUNCTION "deletePostByID"(post_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."deletePostByID"(post_id integer) TO anon;
GRANT ALL ON FUNCTION public."deletePostByID"(post_id integer) TO authenticated;
GRANT ALL ON FUNCTION public."deletePostByID"(post_id integer) TO service_role;


--
-- Name: FUNCTION get_nearby_posts(lng numeric, lat numeric, rad numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_nearby_posts(lng numeric, lat numeric, rad numeric) TO anon;
GRANT ALL ON FUNCTION public.get_nearby_posts(lng numeric, lat numeric, rad numeric) TO authenticated;
GRANT ALL ON FUNCTION public.get_nearby_posts(lng numeric, lat numeric, rad numeric) TO service_role;


--
-- Name: FUNCTION get_post_tags(post_id bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_post_tags(post_id bigint) TO anon;
GRANT ALL ON FUNCTION public.get_post_tags(post_id bigint) TO authenticated;
GRANT ALL ON FUNCTION public.get_post_tags(post_id bigint) TO service_role;


--
-- Name: FUNCTION remove_friendship(user_id bigint, friend_id bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_friendship(user_id bigint, friend_id bigint) TO anon;
GRANT ALL ON FUNCTION public.remove_friendship(user_id bigint, friend_id bigint) TO authenticated;
GRANT ALL ON FUNCTION public.remove_friendship(user_id bigint, friend_id bigint) TO service_role;


--
-- Name: FUNCTION search_posts_by_tag_link(tag character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.search_posts_by_tag_link(tag character varying) TO anon;
GRANT ALL ON FUNCTION public.search_posts_by_tag_link(tag character varying) TO authenticated;
GRANT ALL ON FUNCTION public.search_posts_by_tag_link(tag character varying) TO service_role;


--
-- Name: TABLE friendships; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.friendships TO anon;
GRANT ALL ON TABLE public.friendships TO authenticated;
GRANT ALL ON TABLE public.friendships TO service_role;


--
-- Name: TABLE medias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.medias TO anon;
GRANT ALL ON TABLE public.medias TO authenticated;
GRANT ALL ON TABLE public.medias TO service_role;


--
-- Name: SEQUENCE media_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.media_id_seq TO anon;
GRANT ALL ON SEQUENCE public.media_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.media_id_seq TO service_role;


--
-- Name: TABLE postags; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.postags TO anon;
GRANT ALL ON TABLE public.postags TO authenticated;
GRANT ALL ON TABLE public.postags TO service_role;


--
-- Name: SEQUENCE posts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.posts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.posts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.posts_id_seq TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: SEQUENCE profiles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.profiles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO service_role;


--
-- Name: TABLE tags; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tags TO anon;
GRANT ALL ON TABLE public.tags TO authenticated;
GRANT ALL ON TABLE public.tags TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- PostgreSQL database dump complete
--

