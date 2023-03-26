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
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO postgres;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: publication; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.publication AS (
	id integer,
	user_id uuid,
	description text,
	user_metadata jsonb,
	geo point,
	distance numeric,
	created_at timestamp without time zone
);


ALTER TYPE public.publication OWNER TO postgres;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: create_friendship(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_friendship(user_id uuid, friend_id uuid) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
begin
  insert into friendships ("userID", "friendID") values (create_friendship.user_id, create_friendship.friend_id);
  insert into friendships ("userID", "friendID") values (create_friendship.friend_id, create_friendship.user_id);
  return 0;
end;
$$;


ALTER FUNCTION public.create_friendship(user_id uuid, friend_id uuid) OWNER TO postgres;

--
-- Name: nearby_posts(numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nearby_posts(lng numeric, lat numeric, rad numeric) RETURNS SETOF public.publication
    LANGUAGE plpgsql
    AS $$
DECLARE
    r publication%rowtype;
BEGIN
   
    FOR r IN
      SELECT posts.id, auth.users.id as user_id, description, auth.users.raw_user_meta_data as user_metadata, geo, posts.geo<@>point(nearby_posts.lng, nearby_posts.lat) as distance, posts.created_at
      FROM posts JOIN auth.users 
      ON posts."userID" = auth.users.id
      WHERE posts.geo<@>point(nearby_posts.lng, nearby_posts.lat) < nearby_posts.rad
      ORDER BY distance
    LOOP
       RETURN NEXT r;
    END LOOP;
    RETURN;
END;
$$;


ALTER FUNCTION public.nearby_posts(lng numeric, lat numeric, rad numeric) OWNER TO postgres;

--
-- Name: remove_friendship(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_friendship(user_id uuid, friend_id uuid) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
begin
  delete from friendships where "userID" = remove_friendship.user_id and "friendID" = remove_friendship.friend_id;
  delete from friendships where "friendID" = remove_friendship.user_id and "userID" = remove_friendship.friend_id;
  return 0;               
end;
$$;


ALTER FUNCTION public.remove_friendship(user_id uuid, friend_id uuid) OWNER TO postgres;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying(15) DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying(15) DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friendships (
    id bigint NOT NULL,
    "userID" uuid NOT NULL,
    "friendID" uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.friendships OWNER TO postgres;

--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.friendships ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	394bc555-cee5-47f3-b7bb-386a804be43b	{"action":"user_confirmation_requested","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 13:31:53.963545+00	
00000000-0000-0000-0000-000000000000	f6298ea9-a8d5-48ae-9408-e06811ea3d31	{"action":"user_confirmation_requested","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 13:33:27.13029+00	
00000000-0000-0000-0000-000000000000	e9f3316d-92de-42ac-90cc-e84193e9485a	{"action":"user_recovery_requested","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"user"}	2023-01-28 14:39:53.990551+00	
00000000-0000-0000-0000-000000000000	3cb9c20f-9380-4d0f-8b27-3709e1b65a02	{"action":"user_confirmation_requested","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 14:43:08.792814+00	
00000000-0000-0000-0000-000000000000	14b03760-2cfa-4bc6-a4ad-a71a58fb7c2f	{"action":"user_confirmation_requested","actor_id":"d42719bc-e0d7-4e01-a1a0-2a6ccee80c0c","actor_username":"hello@world.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 14:43:13.217737+00	
00000000-0000-0000-0000-000000000000	56eb9fcc-6357-48d8-bffd-55c08867b79f	{"action":"user_confirmation_requested","actor_id":"d42719bc-e0d7-4e01-a1a0-2a6ccee80c0c","actor_username":"hello@world.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 14:44:37.748397+00	
00000000-0000-0000-0000-000000000000	dfa08f0e-bcb4-4275-9c4b-0fb8dc82d18d	{"action":"user_confirmation_requested","actor_id":"fae36f80-b12f-4352-87a7-d94ae85507a5","actor_username":"tester@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 15:01:08.75765+00	
00000000-0000-0000-0000-000000000000	398b3f0a-8142-42be-a3a9-3c1ec5b8bbb9	{"action":"user_signedup","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"team"}	2023-01-28 15:15:35.781986+00	
00000000-0000-0000-0000-000000000000	303c093a-85ec-4538-951c-16cb2b6e6e41	{"action":"login","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 15:16:11.78768+00	
00000000-0000-0000-0000-000000000000	14539ad4-0fed-4cfc-880c-3a68813eae68	{"action":"login","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 15:18:08.085059+00	
00000000-0000-0000-0000-000000000000	8d053337-3ad9-493b-9417-f7af98875655	{"action":"login","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 15:44:03.652416+00	
00000000-0000-0000-0000-000000000000	adf63487-e4b8-4d9a-a841-48069f4621b3	{"action":"login","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 15:45:36.142982+00	
00000000-0000-0000-0000-000000000000	d5c91e3c-8a2f-4696-9d31-83d422b4f24d	{"action":"login","actor_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 15:50:04.799823+00	
00000000-0000-0000-0000-000000000000	d1bb15da-60d1-4191-b2a8-ed3c987a69ac	{"action":"user_confirmation_requested","actor_id":"f524212d-5a64-4ffb-8ea3-3eb7b3e19a16","actor_username":"hello5@world.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 15:51:17.714037+00	
00000000-0000-0000-0000-000000000000	08f4cd2d-9e5e-41d1-9c64-dd780007d6c1	{"action":"user_confirmation_requested","actor_id":"f524212d-5a64-4ffb-8ea3-3eb7b3e19a16","actor_username":"hello5@world.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 17:18:13.803737+00	
00000000-0000-0000-0000-000000000000	c28da6fe-3745-4f63-b725-e6f1c91c3e02	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"hello5@world.com","user_id":"f524212d-5a64-4ffb-8ea3-3eb7b3e19a16","user_phone":""}}	2023-01-28 17:19:30.16124+00	
00000000-0000-0000-0000-000000000000	6a98843d-ce5e-4b8d-a124-86e0858412d2	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ybelhajali@gmail.com","user_id":"28ba0f7a-b2c7-4a37-86f3-89c868ab7ec3","user_phone":""}}	2023-01-28 17:19:38.242029+00	
00000000-0000-0000-0000-000000000000	1f8085d5-9e1b-411f-b187-b0025f1c2993	{"action":"user_confirmation_requested","actor_id":"d2fe262c-0050-436e-9929-143ae590c41f","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 18:04:14.746701+00	
00000000-0000-0000-0000-000000000000	b1e5ca24-82f3-4338-81b9-fc7f7110644c	{"action":"user_confirmation_requested","actor_id":"dfc0fd38-9169-48cf-a9a2-dbe13f965691","actor_username":"hyxejelicu@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 19:20:36.588526+00	
00000000-0000-0000-0000-000000000000	12e92242-ff72-4a8f-832b-081989725ee2	{"action":"user_confirmation_requested","actor_id":"08010fc3-6d81-4638-b8bf-5abbd95431c2","actor_username":"vawa@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 19:22:36.859574+00	
00000000-0000-0000-0000-000000000000	fd6d960b-a2b9-476d-8f96-a201694d4b1e	{"action":"user_confirmation_requested","actor_id":"1dece5d9-3682-49f9-903d-75adc40efbe9","actor_username":"sedexizimy@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 19:24:06.517706+00	
00000000-0000-0000-0000-000000000000	d96fe253-40cf-4806-b78d-51da14bcc546	{"action":"user_confirmation_requested","actor_id":"d2fe262c-0050-436e-9929-143ae590c41f","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 19:52:07.134576+00	
00000000-0000-0000-0000-000000000000	25fd780e-dba4-4bc2-bb53-99dba6ea877a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ybelhajali@gmail.com","user_id":"d2fe262c-0050-436e-9929-143ae590c41f","user_phone":""}}	2023-01-28 19:54:24.576854+00	
00000000-0000-0000-0000-000000000000	a8c11c52-b7f5-42e8-ba65-15a6469e6428	{"action":"user_confirmation_requested","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-28 19:54:52.176077+00	
00000000-0000-0000-0000-000000000000	0c7fe06d-b381-47fc-b43b-84dc403ada79	{"action":"user_signedup","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"team"}	2023-01-28 19:55:46.273422+00	
00000000-0000-0000-0000-000000000000	dfec03c7-a2df-4281-b199-62d8cd1e441d	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-28 20:19:30.762381+00	
00000000-0000-0000-0000-000000000000	0e7ae032-98f6-4ec1-bf57-d4e2512889a3	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 10:07:13.490288+00	
00000000-0000-0000-0000-000000000000	601c4770-3e0f-49d7-bd9f-e18bbdf10c9b	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 10:07:13.490987+00	
00000000-0000-0000-0000-000000000000	3e9c4f73-4f1d-4097-871d-e1cf78c7b3aa	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:07:26.841977+00	
00000000-0000-0000-0000-000000000000	ab739268-4e62-4ece-bf62-bbe9cfb88e70	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:45:08.570587+00	
00000000-0000-0000-0000-000000000000	92419829-fb05-414c-94f2-bf1b0c68f077	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:46:41.244765+00	
00000000-0000-0000-0000-000000000000	e8c1346d-47e4-4839-8ffb-148721c0a810	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:47:09.63452+00	
00000000-0000-0000-0000-000000000000	4a592555-eee4-430e-8a72-a8c6e166819c	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:47:15.685053+00	
00000000-0000-0000-0000-000000000000	fe6fc766-c922-4028-b22a-649df62d0cff	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:49:49.250525+00	
00000000-0000-0000-0000-000000000000	0384e0bf-5b3b-40c0-80b5-6ebda0ffcfad	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:50:44.154434+00	
00000000-0000-0000-0000-000000000000	5954e8d3-4028-494d-832a-75da61bb8548	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:51:49.266166+00	
00000000-0000-0000-0000-000000000000	7b5f0936-e0e8-41de-a1cd-78d593590c95	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:54:20.698476+00	
00000000-0000-0000-0000-000000000000	39741cad-3e8e-4dbb-8e32-149869138623	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:54:31.296786+00	
00000000-0000-0000-0000-000000000000	e3b250af-ddbc-4e25-b2d3-bd2fb4832970	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:54:33.916389+00	
00000000-0000-0000-0000-000000000000	40e1a045-4155-424b-96f4-c552608d5c43	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:54:57.108307+00	
00000000-0000-0000-0000-000000000000	48320a25-ea29-4195-87db-f063e992ce16	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 10:55:05.080743+00	
00000000-0000-0000-0000-000000000000	7b2005cc-5f6c-45f6-9995-46672fe1c498	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 10:55:12.550974+00	
00000000-0000-0000-0000-000000000000	b54c830c-c4b9-4b7a-91cc-c296c1c14567	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:11:16.650447+00	
00000000-0000-0000-0000-000000000000	215e3ab4-e3d0-4684-a3da-8897e7a4d518	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:11:29.410395+00	
00000000-0000-0000-0000-000000000000	b5d9da40-4862-4304-addb-a9247aacfe3f	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:19:38.905635+00	
00000000-0000-0000-0000-000000000000	a08f2ba4-b47c-4fde-b5a9-e88ed7aad359	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:19:45.177676+00	
00000000-0000-0000-0000-000000000000	c70face4-d62f-40d2-af9c-ac43dfe594a3	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:19:54.624665+00	
00000000-0000-0000-0000-000000000000	7678aeeb-a871-4c0a-8cd2-a7e7073db3e1	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:21:40.406965+00	
00000000-0000-0000-0000-000000000000	54a3ee54-9d13-4511-b645-1e0d1abcef89	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:21:52.340972+00	
00000000-0000-0000-0000-000000000000	ce2cd119-e99e-4b9b-b3c3-bcacf3844228	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:21:59.582005+00	
00000000-0000-0000-0000-000000000000	cfbface7-537f-407e-8c54-45230208bc89	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:34:27.468443+00	
00000000-0000-0000-0000-000000000000	f3f69fcb-18c1-408d-9aaa-657755f100b1	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:35:52.211691+00	
00000000-0000-0000-0000-000000000000	cd92190f-e1a8-4ba2-bc3e-ce344ee34cbd	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:36:10.5836+00	
00000000-0000-0000-0000-000000000000	0dcd1309-3985-4088-9b7a-ac46c2864356	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:38:36.577711+00	
00000000-0000-0000-0000-000000000000	344c3fbb-dae3-4f3d-8de1-29048eac628a	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:38:46.794113+00	
00000000-0000-0000-0000-000000000000	c398ee2f-be62-489e-9527-9351ba1c03ad	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:40:12.295183+00	
00000000-0000-0000-0000-000000000000	9d9b9947-1a92-4b4d-b644-0eb7e134d6d8	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:40:14.732869+00	
00000000-0000-0000-0000-000000000000	f7e58fad-26f0-4561-83b0-3618714da586	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:41:09.570431+00	
00000000-0000-0000-0000-000000000000	5dad5af1-66f1-40fa-9f82-e7a2be2a8999	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 11:41:40.614043+00	
00000000-0000-0000-0000-000000000000	239b7641-06fd-4895-9a01-7c8c6c7ecddc	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:41:43.516827+00	
00000000-0000-0000-0000-000000000000	c9d0d44d-79fc-48fa-9b66-88ee62dfbff6	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:41:47.246571+00	
00000000-0000-0000-0000-000000000000	f7a4ab93-e4b8-4e92-93b1-c108dbfd103c	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 11:42:03.275324+00	
00000000-0000-0000-0000-000000000000	da37af40-52f5-44a4-9d23-9c6850ad010f	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 12:39:02.18446+00	
00000000-0000-0000-0000-000000000000	e19b9c3d-9c51-4b33-82ea-62ffee8c7ebc	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 12:39:37.39829+00	
00000000-0000-0000-0000-000000000000	502d2104-53a3-41a5-a3b4-293162775aa9	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 13:39:08.321168+00	
00000000-0000-0000-0000-000000000000	e6acbe20-afa3-409a-8676-0b9279ed7e65	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 13:39:08.321857+00	
00000000-0000-0000-0000-000000000000	4501ebf9-d3a9-4abf-9ec1-7837c1acb7dd	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 15:09:31.208112+00	
00000000-0000-0000-0000-000000000000	7b495da0-efe4-4370-84e0-ef6781b9a7f0	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 15:09:31.208831+00	
00000000-0000-0000-0000-000000000000	65ab6104-944b-44d4-9617-c81f0c1495e1	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 15:17:55.585948+00	
00000000-0000-0000-0000-000000000000	009e83d5-f9cb-4d1c-b77b-a31627d2bf92	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 15:18:04.31443+00	
00000000-0000-0000-0000-000000000000	f5b2982b-d94e-46e3-9c28-ab9af7c9660b	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 16:17:38.318676+00	
00000000-0000-0000-0000-000000000000	91bc0ddb-d6e8-4a61-8ee4-5e98e5b89dae	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 16:17:38.319435+00	
00000000-0000-0000-0000-000000000000	040af398-21a3-4603-8395-bf2554071c14	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 17:07:01.931492+00	
00000000-0000-0000-0000-000000000000	cd7c7e60-690e-4c4b-ba54-ca082e844a28	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 17:17:11.305092+00	
00000000-0000-0000-0000-000000000000	b118594a-e6e0-4215-9681-7a04a3bcde28	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 17:17:11.305832+00	
00000000-0000-0000-0000-000000000000	63282559-cfa6-421c-95b2-9bd3599225fe	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 18:18:31.989789+00	
00000000-0000-0000-0000-000000000000	31696107-19ae-4b62-83bb-7bfd6791b09c	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-29 18:18:31.99049+00	
00000000-0000-0000-0000-000000000000	2a2cbef7-2bdc-423d-bc0a-63c7b229582a	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-29 18:19:03.140195+00	
00000000-0000-0000-0000-000000000000	a31657b4-7ab9-424a-bb47-9e59af8cc36e	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-29 18:19:06.112913+00	
00000000-0000-0000-0000-000000000000	7bd4c35f-67ea-4b14-b60f-8c8b4f163906	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 09:12:38.883897+00	
00000000-0000-0000-0000-000000000000	e7455acd-0607-452a-a465-3fb072e5130e	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 09:12:38.884587+00	
00000000-0000-0000-0000-000000000000	28d004d9-04c8-49fa-829f-1f28d761da9a	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 10:12:10.761805+00	
00000000-0000-0000-0000-000000000000	1124e4d6-f1db-462e-8b19-fa996947622d	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 10:12:10.76259+00	
00000000-0000-0000-0000-000000000000	5f87f182-0815-4328-8374-0831c7132c74	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 11:01:22.996033+00	
00000000-0000-0000-0000-000000000000	ce8857bb-a20d-451f-8033-ab7c5511e723	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 11:14:56.168807+00	
00000000-0000-0000-0000-000000000000	f854138a-3b88-4e7d-99a7-714bf86764a1	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 11:32:17.491494+00	
00000000-0000-0000-0000-000000000000	c6d578ea-5355-485b-a606-cba6689bd351	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 11:32:17.852561+00	
00000000-0000-0000-0000-000000000000	0f8d6015-3d26-4d14-b0b7-cbd9b309112d	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 11:32:26.20364+00	
00000000-0000-0000-0000-000000000000	c79073c1-509a-4122-adb2-b825a010156e	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 11:32:30.522258+00	
00000000-0000-0000-0000-000000000000	dd97f66a-4485-425b-9da2-fa4b26adc040	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 11:32:33.522578+00	
00000000-0000-0000-0000-000000000000	96f47c64-7347-4ee3-8532-47400c5c0b32	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 11:37:48.941452+00	
00000000-0000-0000-0000-000000000000	4e98b8fb-08c0-4ace-90d8-cf6e7bd02955	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 11:56:27.469571+00	
00000000-0000-0000-0000-000000000000	7eb3033b-7595-48cc-86d3-1ce8bdd1d82f	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 12:59:42.564208+00	
00000000-0000-0000-0000-000000000000	924f0286-e51c-49f5-a992-3d038987b847	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 12:59:42.564916+00	
00000000-0000-0000-0000-000000000000	2dfa476a-5e58-413f-aef6-02b63b25d479	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 13:01:55.088873+00	
00000000-0000-0000-0000-000000000000	73e822af-5021-4698-a552-b9e85f618e8a	{"action":"user_confirmation_requested","actor_id":"e286b9dc-78b2-4603-8bd6-6c11acf66230","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-30 13:03:20.054969+00	
00000000-0000-0000-0000-000000000000	5e3bc8ac-7813-46b0-ac77-b56bcb6b3192	{"action":"user_signedup","actor_id":"e286b9dc-78b2-4603-8bd6-6c11acf66230","actor_username":"yasminebha5@gmail.com","log_type":"team"}	2023-01-30 13:04:44.018692+00	
00000000-0000-0000-0000-000000000000	8162ee84-1ce1-4f83-ae82-fd283727efce	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 13:07:03.141786+00	
00000000-0000-0000-0000-000000000000	eee9eb00-543d-425d-bfa8-c5951eac6c1c	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 16:28:54.987638+00	
00000000-0000-0000-0000-000000000000	cfc7f0ba-d36c-485c-a04d-038451faf265	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 16:28:54.988404+00	
00000000-0000-0000-0000-000000000000	e4b8b706-bbd7-4bc4-a217-c3994b18fc07	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 16:30:32.088924+00	
00000000-0000-0000-0000-000000000000	9aca695b-0df0-4bdd-ace8-805eb5dd3ba8	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 16:30:37.041037+00	
00000000-0000-0000-0000-000000000000	bb1af01a-bfb1-4c88-a1bb-97f0bcadc498	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 17:30:07.977279+00	
00000000-0000-0000-0000-000000000000	e9796a87-a90f-44bd-90ae-cfcc0ca6fcd3	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 17:30:07.978127+00	
00000000-0000-0000-0000-000000000000	eb47f5b0-97c9-4e74-99cf-705b2577926a	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 18:33:03.135953+00	
00000000-0000-0000-0000-000000000000	058a71c1-7a66-407f-bf9d-bd345b16b33b	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 18:33:03.136755+00	
00000000-0000-0000-0000-000000000000	5575fc99-f46a-4f21-a140-c9326ae50f5a	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-30 19:26:27.40792+00	
00000000-0000-0000-0000-000000000000	f170b334-7f6c-4695-bb76-eb52e2d16180	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-30 19:26:31.620568+00	
00000000-0000-0000-0000-000000000000	b9fe53b1-9177-481b-9dcb-7335bd532dbc	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 20:31:05.029986+00	
00000000-0000-0000-0000-000000000000	cd6f2d41-f199-4231-8335-2630dadbe452	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 20:31:05.030937+00	
00000000-0000-0000-0000-000000000000	1da60621-a86d-42f1-9b01-82b2b341c5e7	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 21:30:40.284943+00	
00000000-0000-0000-0000-000000000000	7be9bc20-09de-484c-b469-1776d444fce9	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-30 21:30:40.285823+00	
00000000-0000-0000-0000-000000000000	e7cdd70a-3075-4c07-aff4-847133c883c3	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 09:51:46.723464+00	
00000000-0000-0000-0000-000000000000	0fbf515b-4886-4532-8a38-e0995b32591d	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 09:51:46.724305+00	
00000000-0000-0000-0000-000000000000	5e59762c-cdd5-4d3f-a999-42d5728d4050	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 10:52:11.728065+00	
00000000-0000-0000-0000-000000000000	6b37e77e-3d02-43d4-8276-109f8487fc04	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 10:52:11.72873+00	
00000000-0000-0000-0000-000000000000	58398080-e54e-4c11-9a66-cea38e3001dc	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 11:53:20.407088+00	
00000000-0000-0000-0000-000000000000	026c3d2b-51c2-4e1f-9478-0eb2546a908d	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 11:53:20.407828+00	
00000000-0000-0000-0000-000000000000	fde8025f-ea5d-4fad-9865-f8f8295a96f2	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 13:21:23.598682+00	
00000000-0000-0000-0000-000000000000	005ef5ef-9ac2-4cef-b695-893e47eba24d	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 13:21:23.599383+00	
00000000-0000-0000-0000-000000000000	3a48b7e1-2280-4ced-ba77-6ba0fb0c1463	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"yasminebha5@gmail.com","user_id":"e286b9dc-78b2-4603-8bd6-6c11acf66230","user_phone":""}}	2023-01-31 13:28:51.757751+00	
00000000-0000-0000-0000-000000000000	8b082f8a-d0c5-44b0-bffa-2431f39b4185	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-31 13:28:57.044207+00	
00000000-0000-0000-0000-000000000000	355dbe58-c823-43a7-8dc2-7d352f4e6479	{"action":"user_confirmation_requested","actor_id":"001515d1-4f42-4ce3-a94c-57f80ef1c6ff","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-01-31 13:54:40.123582+00	
00000000-0000-0000-0000-000000000000	40474123-c6ee-496a-aca9-fdb24667e030	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-31 14:49:44.535237+00	
00000000-0000-0000-0000-000000000000	aa9dd241-ce5c-4225-909a-51c289da4c1b	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-31 14:50:03.680173+00	
00000000-0000-0000-0000-000000000000	e5c21b6e-ae07-4901-99db-54649dc78f35	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-31 14:53:56.803515+00	
00000000-0000-0000-0000-000000000000	34491c4a-ce94-4051-894b-c9d38f3d8485	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 15:53:54.950726+00	
00000000-0000-0000-0000-000000000000	5e997763-31e3-47d0-9576-b5d227ed46f9	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 15:53:54.95138+00	
00000000-0000-0000-0000-000000000000	6f2ff673-e9d7-49b8-ac78-2c6594b884c4	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 18:46:19.332318+00	
00000000-0000-0000-0000-000000000000	9ab274d9-5259-438d-880a-c9a958a42288	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 18:46:19.333031+00	
00000000-0000-0000-0000-000000000000	1e395548-c0ef-48d5-8631-26d177f94f7b	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 19:57:57.725865+00	
00000000-0000-0000-0000-000000000000	2cc76cb6-2a68-49b5-8e1c-797d5ec6f2c6	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-01-31 19:57:57.726613+00	
00000000-0000-0000-0000-000000000000	a3d1d9b6-75a9-46ec-b09f-5ae7461d09b8	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-01-31 20:28:38.996399+00	
00000000-0000-0000-0000-000000000000	ecee29b5-8598-4344-ae35-6fdc6aea858a	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-01-31 20:33:43.602621+00	
00000000-0000-0000-0000-000000000000	9a9904b6-0689-4979-985d-1fd6b32bc909	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 10:29:24.81073+00	
00000000-0000-0000-0000-000000000000	e407851d-64c3-41a4-947d-cdff1478b553	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-01 11:00:41.052666+00	
00000000-0000-0000-0000-000000000000	4bdd8eb9-eb7d-435b-a932-0438a5d737ce	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 11:03:47.22646+00	
00000000-0000-0000-0000-000000000000	4d8a4128-b2ea-4fc6-847d-0fb96b126614	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-01 11:06:41.968316+00	
00000000-0000-0000-0000-000000000000	18907e03-9cfa-4054-a11c-4887e016d8a7	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 11:06:51.070731+00	
00000000-0000-0000-0000-000000000000	c48281d5-f32e-4806-893a-8a85c1bf3020	{"action":"login","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 11:22:09.680485+00	
00000000-0000-0000-0000-000000000000	3858e7a1-265b-43a9-b870-01cf61048d67	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 12:20:36.18915+00	
00000000-0000-0000-0000-000000000000	28bee9ac-75d9-4996-ad30-7adbb171af05	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 12:20:36.189828+00	
00000000-0000-0000-0000-000000000000	5767ca60-918e-4eda-aa9f-95ff36b77669	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 12:21:54.919074+00	
00000000-0000-0000-0000-000000000000	50c04d2e-4c2e-436e-b07d-97270a423e9b	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 12:21:54.919738+00	
00000000-0000-0000-0000-000000000000	b88a53c5-ec8a-42ab-990e-82ddf1e68283	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 13:21:32.024195+00	
00000000-0000-0000-0000-000000000000	bf10806d-9d37-4bd4-943d-02807bf57890	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 13:21:32.025005+00	
00000000-0000-0000-0000-000000000000	39c6be7a-62fd-47dc-a651-be20787e9ac1	{"action":"token_refreshed","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 14:26:40.58307+00	
00000000-0000-0000-0000-000000000000	3a173fc1-2dab-4df0-8ee2-fed40d9e8ab3	{"action":"token_revoked","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 14:26:40.583891+00	
00000000-0000-0000-0000-000000000000	aec0b3a2-3f56-4678-97a8-d0c4e7b24396	{"action":"logout","actor_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-01 14:55:43.487265+00	
00000000-0000-0000-0000-000000000000	d5771b08-1f27-4198-a5ae-0adba1c5be39	{"action":"user_confirmation_requested","actor_id":"001515d1-4f42-4ce3-a94c-57f80ef1c6ff","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 14:57:21.296984+00	
00000000-0000-0000-0000-000000000000	70500736-a6c8-4559-9781-1c353793b33e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"yasminebha5@gmail.com","user_id":"001515d1-4f42-4ce3-a94c-57f80ef1c6ff","user_phone":""}}	2023-02-01 15:07:14.140472+00	
00000000-0000-0000-0000-000000000000	b3e80adf-260b-49ed-90f0-9ecb3c2dee37	{"action":"user_confirmation_requested","actor_id":"c0bc5511-df64-445c-b7a1-5dc06fd3a0d6","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:07:43.962325+00	
00000000-0000-0000-0000-000000000000	c28eaf2a-0342-4ed4-a163-8c44175e97cf	{"action":"user_signedup","actor_id":"c0bc5511-df64-445c-b7a1-5dc06fd3a0d6","actor_username":"yasminebha5@gmail.com","log_type":"team"}	2023-02-01 15:13:49.883651+00	
00000000-0000-0000-0000-000000000000	9979d248-e3e5-42ef-b1bc-a4a26cb690f7	{"action":"login","actor_id":"c0bc5511-df64-445c-b7a1-5dc06fd3a0d6","actor_username":"yasminebha5@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 15:21:23.505046+00	
00000000-0000-0000-0000-000000000000	29758b80-c358-4618-bafb-ac988ebc2212	{"action":"logout","actor_id":"c0bc5511-df64-445c-b7a1-5dc06fd3a0d6","actor_username":"yasminebha5@gmail.com","log_type":"account"}	2023-02-01 15:40:37.09924+00	
00000000-0000-0000-0000-000000000000	ffdeedf4-6d94-4b56-9cff-05f38c6eda8b	{"action":"user_confirmation_requested","actor_id":"6f1f417c-c7e7-4f74-94f6-ab7f87913bac","actor_username":"zige@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:41:35.533147+00	
00000000-0000-0000-0000-000000000000	906df76d-74f7-41a2-a9c3-9e4727104646	{"action":"user_confirmation_requested","actor_id":"6f1f417c-c7e7-4f74-94f6-ab7f87913bac","actor_username":"zige@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:45:08.547661+00	
00000000-0000-0000-0000-000000000000	7fbe0932-f10a-4363-9ac6-b623a816a3da	{"action":"user_confirmation_requested","actor_id":"1edd7deb-3593-4068-a5d6-b95416f5cd46","actor_username":"qycybapyb@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:47:19.851396+00	
00000000-0000-0000-0000-000000000000	30646b1e-63d6-4bbf-b80e-a3ee1b1075e2	{"action":"user_confirmation_requested","actor_id":"5bfee79f-7dfa-4771-b6f8-573633c9c04b","actor_username":"gyhogo@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:48:34.712672+00	
00000000-0000-0000-0000-000000000000	f28cd35f-6d32-40ed-ab89-68a205173b1e	{"action":"user_confirmation_requested","actor_id":"020c70f4-bca0-42bf-ad33-a35ba214d4d2","actor_username":"kosovy@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:51:10.50434+00	
00000000-0000-0000-0000-000000000000	60824e0b-b15a-42da-8655-2060ac62f756	{"action":"user_confirmation_requested","actor_id":"8c1c41f7-aa27-4f0b-9216-2c24be7e4082","actor_username":"cefum@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 15:51:52.421178+00	
00000000-0000-0000-0000-000000000000	c56cf747-be2f-4e3d-8d57-14a6313389c0	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"hello@world.com","user_id":"d42719bc-e0d7-4e01-a1a0-2a6ccee80c0c","user_phone":""}}	2023-02-01 16:00:41.89875+00	
00000000-0000-0000-0000-000000000000	209b2b0b-385b-457d-a960-5b1f8dbc9d42	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"tester@gmail.com","user_id":"fae36f80-b12f-4352-87a7-d94ae85507a5","user_phone":""}}	2023-02-01 16:00:46.114898+00	
00000000-0000-0000-0000-000000000000	dcd35528-1950-4d20-8446-7756920c8d31	{"action":"user_confirmation_requested","actor_id":"39740559-bebf-4449-95e7-5b3f085db4eb","actor_username":"hello@world.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 16:01:03.781247+00	
00000000-0000-0000-0000-000000000000	9cce4b24-c8aa-4055-b4eb-da110b4bafe1	{"action":"user_confirmation_requested","actor_id":"a80a3135-2564-4456-ad30-39ae293d8cd1","actor_username":"venulu@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 16:05:16.777544+00	
00000000-0000-0000-0000-000000000000	8114e192-c987-4dfb-840a-1f81807a1045	{"action":"user_confirmation_requested","actor_id":"5e2a3a76-67c1-46ad-b354-1958c12bcaeb","actor_username":"dekuzatuk@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 16:08:28.071089+00	
00000000-0000-0000-0000-000000000000	389e9c65-91da-46f1-9764-05e2211db418	{"action":"user_confirmation_requested","actor_id":"de735f61-c7a0-4a3f-ba0d-98b13d3a89ff","actor_username":"xavegemohi@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 16:29:07.621265+00	
00000000-0000-0000-0000-000000000000	9cd41a60-a2ba-48dd-859c-c24b096a95a8	{"action":"user_confirmation_requested","actor_id":"7b9daf8c-6b30-40a5-98bc-1dc7e7141820","actor_username":"mara@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 16:51:46.062801+00	
00000000-0000-0000-0000-000000000000	95e1a124-5e59-4e76-9d77-933db2a254fe	{"action":"user_confirmation_requested","actor_id":"299ec939-6051-4205-93d3-8189738e3ade","actor_username":"jinoj@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:00:30.756608+00	
00000000-0000-0000-0000-000000000000	1cdd5947-7989-476f-8595-549b911ec8c0	{"action":"user_confirmation_requested","actor_id":"e1b2d872-6b30-45c9-9322-383948080111","actor_username":"namezitolu@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:03:39.020455+00	
00000000-0000-0000-0000-000000000000	35e90765-57d7-42c1-a900-414253ac4cbe	{"action":"user_repeated_signup","actor_id":"c0bc5511-df64-445c-b7a1-5dc06fd3a0d6","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:06:05.962681+00	
00000000-0000-0000-0000-000000000000	f2b097b4-ac84-4584-bbc5-920d297db7cc	{"action":"user_confirmation_requested","actor_id":"8fb43075-8869-468f-bfb5-249bc621b4ce","actor_username":"ladufolu@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:06:31.017507+00	
00000000-0000-0000-0000-000000000000	edf96600-8ec2-4b64-9199-1c7b1bc1b8ad	{"action":"user_confirmation_requested","actor_id":"3f406093-feb0-4bcf-b4ff-817a3159d3a8","actor_username":"rijinari@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:07:39.049551+00	
00000000-0000-0000-0000-000000000000	6b54cb55-1b3a-4c64-83ed-298aecf7d729	{"action":"user_confirmation_requested","actor_id":"33d5395e-5313-4d38-9536-4beda549d60c","actor_username":"luvoz@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:24:49.299305+00	
00000000-0000-0000-0000-000000000000	b28a799c-2170-4233-8c65-30cd09a04f1a	{"action":"user_confirmation_requested","actor_id":"e05ddf3b-4344-4fae-bbc7-a396f60a28eb","actor_username":"mazev@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:30:59.828539+00	
00000000-0000-0000-0000-000000000000	097e61e5-c62c-4cbf-b342-f5127c590208	{"action":"user_confirmation_requested","actor_id":"19dd1495-9d22-41cf-a616-44b0f16df121","actor_username":"byqolop@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:37:51.072114+00	
00000000-0000-0000-0000-000000000000	0b23872f-fb02-4cfe-848b-2d0289d4c993	{"action":"user_confirmation_requested","actor_id":"4adfa2b9-ab74-4fce-b175-a7a1a92bc2b8","actor_username":"mivemo@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:44:12.901895+00	
00000000-0000-0000-0000-000000000000	d43754b0-7a79-4240-963d-88b78d9cbd23	{"action":"user_confirmation_requested","actor_id":"94cab22f-38c2-4974-887b-959e333cabdb","actor_username":"lesid@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 17:56:16.804109+00	
00000000-0000-0000-0000-000000000000	795cdf97-f2d4-4ce4-89c9-69e28a0428d4	{"action":"user_confirmation_requested","actor_id":"76dcfaa7-bdb1-4e73-9d68-36477aaa83a3","actor_username":"ryjubulujo@mailinator.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 18:02:23.280383+00	
00000000-0000-0000-0000-000000000000	725872c8-57ce-42a8-8d6e-6bfcc7b9bfc4	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ryjubulujo@mailinator.com","user_id":"76dcfaa7-bdb1-4e73-9d68-36477aaa83a3","user_phone":""}}	2023-02-01 18:03:33.661799+00	
00000000-0000-0000-0000-000000000000	9997886e-82b8-4509-9635-92480aa14bd2	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"lesid@mailinator.com","user_id":"94cab22f-38c2-4974-887b-959e333cabdb","user_phone":""}}	2023-02-01 18:04:06.60582+00	
00000000-0000-0000-0000-000000000000	2a7e933e-e96e-48e9-ae2a-6518846b8626	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"mivemo@mailinator.com","user_id":"4adfa2b9-ab74-4fce-b175-a7a1a92bc2b8","user_phone":""}}	2023-02-01 18:04:10.125907+00	
00000000-0000-0000-0000-000000000000	f08067ad-1905-4ce6-b654-989dadb6687b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"byqolop@mailinator.com","user_id":"19dd1495-9d22-41cf-a616-44b0f16df121","user_phone":""}}	2023-02-01 18:04:14.558105+00	
00000000-0000-0000-0000-000000000000	03cad436-9875-4bf3-870f-ff1529bf1afe	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"mazev@mailinator.com","user_id":"e05ddf3b-4344-4fae-bbc7-a396f60a28eb","user_phone":""}}	2023-02-01 18:04:18.086639+00	
00000000-0000-0000-0000-000000000000	f31bc0a5-cf4d-48f2-a0e2-43b9469e28a5	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ybelhajali@gmail.com","user_id":"91c5fac0-1ccf-4cfa-a54e-8691fb722794","user_phone":""}}	2023-02-01 18:10:02.179255+00	
00000000-0000-0000-0000-000000000000	4dcb2258-14c7-425c-8a07-e9a1f9afbc90	{"action":"user_confirmation_requested","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 18:11:06.565404+00	
00000000-0000-0000-0000-000000000000	24e182d6-37e0-450f-83bf-d9b1f845e626	{"action":"user_signedup","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"team"}	2023-02-01 18:21:13.497998+00	
00000000-0000-0000-0000-000000000000	c78e2f27-2b24-4d9e-8dbc-26e03e472622	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 18:21:18.55245+00	
00000000-0000-0000-0000-000000000000	08c8395b-cbe3-4e44-ad5d-b4a966a583f4	{"action":"logout","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-01 18:31:41.487451+00	
00000000-0000-0000-0000-000000000000	848f6fe2-596e-43b5-99ff-b284544e8a0c	{"action":"user_confirmation_requested","actor_id":"2954a3b1-8b72-4b76-a9a4-14548f381701","actor_username":"yasminebha5@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-01 18:32:03.754247+00	
00000000-0000-0000-0000-000000000000	5d6c9e75-868c-4bb8-937c-77a5da0619bf	{"action":"user_signedup","actor_id":"2954a3b1-8b72-4b76-a9a4-14548f381701","actor_username":"yasminebha5@gmail.com","log_type":"team"}	2023-02-01 18:32:18.59205+00	
00000000-0000-0000-0000-000000000000	1e7e1278-c0a3-4c4b-ac47-e2816b51101c	{"action":"login","actor_id":"2954a3b1-8b72-4b76-a9a4-14548f381701","actor_username":"yasminebha5@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 18:32:25.429231+00	
00000000-0000-0000-0000-000000000000	bb009b98-7996-4be8-b89b-b92153826730	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-01 18:51:51.459918+00	
00000000-0000-0000-0000-000000000000	cf2cd6ce-6c57-4481-8803-8a8684c48ca9	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 19:51:22.858156+00	
00000000-0000-0000-0000-000000000000	5a77eceb-bf23-4ad0-b90c-9b113a294914	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 19:51:22.858845+00	
00000000-0000-0000-0000-000000000000	b1467b0d-ba84-4909-85eb-bd58d2bd11ae	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 20:50:59.3711+00	
00000000-0000-0000-0000-000000000000	60ac4324-af34-4783-b3bf-9e40d890f023	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-01 20:50:59.372006+00	
00000000-0000-0000-0000-000000000000	8c5ad12d-62d0-4b2b-82f2-9242b6f175e1	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 10:22:41.121952+00	
00000000-0000-0000-0000-000000000000	dad3c357-679d-4326-a6dc-dc0f492f2417	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 10:22:41.122632+00	
00000000-0000-0000-0000-000000000000	accce399-a6c6-4113-84ac-4d43837a337b	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 11:22:20.317281+00	
00000000-0000-0000-0000-000000000000	7f925d8d-30cb-453b-9ac2-cdc3dd38bfec	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 11:22:20.318036+00	
00000000-0000-0000-0000-000000000000	9ef969ef-4d5e-4b7a-a23b-eeb77eece309	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 13:48:52.134229+00	
00000000-0000-0000-0000-000000000000	7fc4cf2c-9d49-4878-90b8-d726cda24896	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 13:48:52.135034+00	
00000000-0000-0000-0000-000000000000	db1cb683-ac55-4b2f-8efd-a283dcd4bf02	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 14:48:25.763866+00	
00000000-0000-0000-0000-000000000000	1661dfa8-c866-411e-b19c-8da93f1c5f6c	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 14:48:25.764617+00	
00000000-0000-0000-0000-000000000000	2677925f-ee8b-4c02-bf1e-4314cab2aefb	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 15:48:04.782912+00	
00000000-0000-0000-0000-000000000000	fcc11cc1-d0ef-4e8b-8e22-d8dd11ca995d	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 15:48:04.785357+00	
00000000-0000-0000-0000-000000000000	063d0747-41a1-4322-bb13-25708a1a3749	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-02 15:57:15.622117+00	
00000000-0000-0000-0000-000000000000	fa9c4031-f61d-49fb-8beb-9895f0df193f	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-02 16:00:04.529375+00	
00000000-0000-0000-0000-000000000000	d883cdb3-56a5-4f9d-a28d-13acf982084c	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 16:49:57.450771+00	
00000000-0000-0000-0000-000000000000	1ae1ea9b-a7a2-467d-a81e-88002e2fa457	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 16:49:57.453128+00	
00000000-0000-0000-0000-000000000000	c8e18efa-9cbb-4db3-8041-945af10fa120	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 16:59:51.761976+00	
00000000-0000-0000-0000-000000000000	3f1bbf90-e96d-4677-99c3-1b8f2ee86fd0	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 16:59:51.763614+00	
00000000-0000-0000-0000-000000000000	dcef656a-5fc7-4caf-897b-5950eaaa63f9	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 18:42:17.285554+00	
00000000-0000-0000-0000-000000000000	b86b52f6-a607-4812-a9ba-c185c2b0cfaf	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-02 18:42:17.28636+00	
00000000-0000-0000-0000-000000000000	8abc7852-f19e-428d-ba9e-24b8a2e72a5b	{"action":"logout","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-02 18:54:22.161718+00	
00000000-0000-0000-0000-000000000000	342589f9-bce2-45e6-bc31-bf1410bcb1b7	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-02 19:03:33.000169+00	
00000000-0000-0000-0000-000000000000	855e4fca-e69f-42cd-aab2-b415c1c528e4	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-03 10:28:25.897798+00	
00000000-0000-0000-0000-000000000000	a80282e7-37cc-4acb-a59b-d36a3c07df92	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 10:31:54.539768+00	
00000000-0000-0000-0000-000000000000	93d85e36-18f8-4160-a057-d3289603eb28	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 10:31:54.540518+00	
00000000-0000-0000-0000-000000000000	80fd4162-846f-4faa-b025-80f5ca946520	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-03 10:49:04.647816+00	
00000000-0000-0000-0000-000000000000	a78561e1-e48b-4853-9d2e-3d15c6fbf22c	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 11:40:58.731089+00	
00000000-0000-0000-0000-000000000000	04b306af-fe5e-4b8b-98c9-51c5f271c2c8	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 11:40:58.732237+00	
00000000-0000-0000-0000-000000000000	06b789e5-0fed-4632-9df9-04a9900795e9	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 11:49:35.757315+00	
00000000-0000-0000-0000-000000000000	61ad462d-764d-4333-8268-4405126539ce	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 11:49:35.758015+00	
00000000-0000-0000-0000-000000000000	aec4e973-e3ea-4fab-aeca-d89303dc7511	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 12:49:09.66725+00	
00000000-0000-0000-0000-000000000000	3687c136-7b35-4721-984c-cf4433354c6d	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 12:49:09.668001+00	
00000000-0000-0000-0000-000000000000	62e87627-c1b0-41c9-8d2a-ea823c242caf	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 13:48:48.300153+00	
00000000-0000-0000-0000-000000000000	7ad48a5f-b88b-48f1-bf50-34837ecfcc67	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-03 13:48:48.300871+00	
00000000-0000-0000-0000-000000000000	21de9fa8-b166-4c06-ac38-fd5ac16925fb	{"action":"logout","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account"}	2023-02-03 14:48:17.727898+00	
00000000-0000-0000-0000-000000000000	7a704fd7-aaa4-439f-b941-20b4e579e36f	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-03 14:48:24.351241+00	
00000000-0000-0000-0000-000000000000	7e30806f-bdf6-4d6d-b3ea-8070c6dd5ad2	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 11:27:54.82531+00	
00000000-0000-0000-0000-000000000000	3d421004-bc28-4465-9fe3-a038e1d4ee0a	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 11:27:54.828354+00	
00000000-0000-0000-0000-000000000000	09e0ffbf-ace1-437e-8540-545b55047e52	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 12:33:08.552724+00	
00000000-0000-0000-0000-000000000000	a8632d2a-02ef-4504-a042-a59684ade4d1	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 12:33:08.555215+00	
00000000-0000-0000-0000-000000000000	33fa33eb-9499-49a9-bcef-abece251652d	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 13:32:56.359611+00	
00000000-0000-0000-0000-000000000000	fd25163e-2db6-4a0a-9877-4f7c78638bf8	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 13:32:56.361911+00	
00000000-0000-0000-0000-000000000000	e533588e-81e0-404f-8df2-c799edafcaf6	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 14:32:36.851146+00	
00000000-0000-0000-0000-000000000000	3c9d759d-642f-4f3d-b726-e0089b0b7471	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 14:32:36.853901+00	
00000000-0000-0000-0000-000000000000	7d59e9d7-d20f-4304-b416-c339629da7e2	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 15:40:55.255312+00	
00000000-0000-0000-0000-000000000000	01409872-92dc-4b52-a932-f4d927ef3141	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 15:40:55.259153+00	
00000000-0000-0000-0000-000000000000	44652c03-5089-4e72-9c3d-5ebd8dc0366a	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 17:08:28.529867+00	
00000000-0000-0000-0000-000000000000	4d91eca9-5cba-4a11-93f8-71ee130672e8	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 17:08:28.530833+00	
00000000-0000-0000-0000-000000000000	517ebb45-aeef-4d38-86c8-7efa602757ab	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 20:26:51.824829+00	
00000000-0000-0000-0000-000000000000	c766807b-acea-4c4d-a4f1-aa6790c4f239	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-04 20:26:51.825716+00	
00000000-0000-0000-0000-000000000000	f651038c-3a74-4111-bfbd-e3b61d836110	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 11:34:04.643814+00	
00000000-0000-0000-0000-000000000000	26855504-4112-47cb-86d9-252efc487955	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 11:34:04.646943+00	
00000000-0000-0000-0000-000000000000	9472de63-dd80-49c8-ac71-4e88c80b3eb8	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 12:34:34.0873+00	
00000000-0000-0000-0000-000000000000	d23e23e3-e2c1-4068-bd6a-e3cd012d7a08	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 12:34:34.089294+00	
00000000-0000-0000-0000-000000000000	063f5543-270a-4a3b-95a8-0965cc30be1e	{"action":"user_confirmation_requested","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-02-05 12:58:37.193433+00	
00000000-0000-0000-0000-000000000000	80974424-5134-4fb6-86cb-a94dd5291561	{"action":"user_signedup","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"team"}	2023-02-05 13:00:18.379841+00	
00000000-0000-0000-0000-000000000000	8001a39d-9b70-4662-bec1-af582518b564	{"action":"login","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-05 13:00:31.733458+00	
00000000-0000-0000-0000-000000000000	1cc19643-53fb-486f-bb6d-529bd0c82063	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 13:43:33.078939+00	
00000000-0000-0000-0000-000000000000	04fa19ce-3cc5-4683-b706-5a97a0f14534	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 13:43:33.079667+00	
00000000-0000-0000-0000-000000000000	8db1be37-11d7-440d-8970-c99209decf26	{"action":"token_refreshed","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-05 14:05:05.507819+00	
00000000-0000-0000-0000-000000000000	756f049a-632a-4cdd-be43-abd1332dde04	{"action":"token_revoked","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-05 14:05:05.508647+00	
00000000-0000-0000-0000-000000000000	defcf5d8-5dea-4c00-ba69-d234495b101e	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-05 14:08:41.712519+00	
00000000-0000-0000-0000-000000000000	081283c9-8e20-4ee5-8148-1ab38c9aa302	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 17:56:47.337286+00	
00000000-0000-0000-0000-000000000000	d8769c6b-ad27-4969-acd6-990b390fd000	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 17:56:47.339429+00	
00000000-0000-0000-0000-000000000000	10c99212-5ca8-4aaa-83d0-df40c3a96a43	{"action":"token_refreshed","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-05 17:56:47.530987+00	
00000000-0000-0000-0000-000000000000	ec737f22-82dc-4027-96c0-5537b85239f8	{"action":"token_revoked","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-05 17:56:47.53163+00	
00000000-0000-0000-0000-000000000000	2acb556b-b80a-4e8a-a808-c6f191e359d1	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 18:56:19.02712+00	
00000000-0000-0000-0000-000000000000	d7725d60-8571-40dd-b9a5-0295abcaa0ec	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-05 18:56:19.027826+00	
00000000-0000-0000-0000-000000000000	e06d7219-0b9c-4782-b86e-96b120316d59	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-07 10:36:40.386669+00	
00000000-0000-0000-0000-000000000000	3eb1d673-f887-4e30-ad07-2fc3440dde74	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-08 10:11:32.363452+00	
00000000-0000-0000-0000-000000000000	b4478328-3ba8-455e-aa3a-eb13e70d3108	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-08 10:11:32.366545+00	
00000000-0000-0000-0000-000000000000	6a40ce6e-3371-4fe4-84d8-5757356ef07a	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-13 08:39:57.092693+00	
00000000-0000-0000-0000-000000000000	8fbfbdf5-58cd-47b2-99c0-11c533dbf213	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-13 08:39:57.096096+00	
00000000-0000-0000-0000-000000000000	1abb381c-aff1-46eb-ac33-dac037f2d1d4	{"action":"token_refreshed","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-13 08:43:49.474909+00	
00000000-0000-0000-0000-000000000000	db523d2e-3b61-49d6-aa3e-502992193e09	{"action":"token_revoked","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"token"}	2023-02-13 08:43:49.475598+00	
00000000-0000-0000-0000-000000000000	7bbe3207-67d0-41b3-be11-18d797cdba0d	{"action":"logout","actor_id":"314decbc-a5b7-45fb-8217-0fa8b37f3139","actor_username":"obha121@gmail.com","log_type":"account"}	2023-02-13 08:43:57.245887+00	
00000000-0000-0000-0000-000000000000	8614845f-bb43-49e8-9692-80b6d30ed6e2	{"action":"login","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"account","traits":{"provider":"email"}}	2023-02-13 08:44:05.985344+00	
00000000-0000-0000-0000-000000000000	f48574f4-c4b0-426d-ad5b-eb682c71bdcf	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 17:53:45.594082+00	
00000000-0000-0000-0000-000000000000	a00490ab-214a-46f2-bee5-86d88ebe50d0	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 17:53:45.603741+00	
00000000-0000-0000-0000-000000000000	c50c451a-b170-4db7-a9b5-3a1c6727a878	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 18:53:24.541626+00	
00000000-0000-0000-0000-000000000000	38f11afa-8336-4237-8888-45f0b178be88	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 18:53:24.544718+00	
00000000-0000-0000-0000-000000000000	da80ddea-9a9d-442b-801f-d6cce1263bca	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 19:52:59.155793+00	
00000000-0000-0000-0000-000000000000	6c24b8a7-e39e-4402-9bd8-3e863871a1b5	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 19:52:59.157858+00	
00000000-0000-0000-0000-000000000000	4cbbd380-508a-4695-b098-16eff9274986	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 20:57:19.924153+00	
00000000-0000-0000-0000-000000000000	cb4308f5-10fe-414d-b197-17dc4a78914f	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-17 20:57:19.926999+00	
00000000-0000-0000-0000-000000000000	de1fa564-ed79-4681-8d50-2bf365086e57	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-18 09:10:17.51651+00	
00000000-0000-0000-0000-000000000000	97d24304-2e6e-4bdc-bdc8-49c7ceb12b34	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-18 09:10:17.519755+00	
00000000-0000-0000-0000-000000000000	9fcfb5b5-5420-4c74-b124-5b9ffcf0a0b8	{"action":"token_refreshed","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-22 17:00:33.00739+00	
00000000-0000-0000-0000-000000000000	68c01fa6-5398-445c-bc3a-5a25b1de90b8	{"action":"token_revoked","actor_id":"211f9ab1-82d6-4f79-8de4-1b3ced8081d3","actor_username":"ybelhajali@gmail.com","log_type":"token"}	2023-02-22 17:00:33.021927+00	
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
211f9ab1-82d6-4f79-8de4-1b3ced8081d3	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	{"sub": "211f9ab1-82d6-4f79-8de4-1b3ced8081d3", "email": "ybelhajali@gmail.com"}	email	2023-02-01 18:11:06.564255+00	2023-02-01 18:11:06.564289+00	2023-02-01 18:11:06.564289+00
2954a3b1-8b72-4b76-a9a4-14548f381701	2954a3b1-8b72-4b76-a9a4-14548f381701	{"sub": "2954a3b1-8b72-4b76-a9a4-14548f381701", "email": "yasminebha5@gmail.com"}	email	2023-02-01 18:32:03.753155+00	2023-02-01 18:32:03.753196+00	2023-02-01 18:32:03.753196+00
314decbc-a5b7-45fb-8217-0fa8b37f3139	314decbc-a5b7-45fb-8217-0fa8b37f3139	{"sub": "314decbc-a5b7-45fb-8217-0fa8b37f3139", "email": "obha121@gmail.com"}	email	2023-02-05 12:58:37.19149+00	2023-02-05 12:58:37.19154+00	2023-02-05 12:58:37.19154+00
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
387745bb-048e-488a-8400-6ca638214202	2023-02-01 18:32:18.597627+00	2023-02-01 18:32:18.597627+00	otp	dd04535e-fe29-43a9-aaeb-ecafdf2c1445
383167ba-43f4-4e84-b7f6-777608eee305	2023-02-01 18:32:25.432722+00	2023-02-01 18:32:25.432722+00	password	8ae8fa03-7ebe-4949-a046-cd43240f9a67
35ceccc4-1d08-4d93-8b25-0fd96907b505	2023-02-03 14:48:24.355942+00	2023-02-03 14:48:24.355942+00	password	993bcf4e-5e20-43d8-b994-b260a60f6037
a65d0f9e-4c9d-425b-93db-9b466b708d60	2023-02-05 14:08:41.716263+00	2023-02-05 14:08:41.716263+00	password	2150fffb-9320-4eff-ab01-df61caa7838f
3958cddf-d7bd-4feb-9cfc-a9e36157e181	2023-02-07 10:36:40.39698+00	2023-02-07 10:36:40.39698+00	password	d0c08abf-6955-4a8e-a3fd-87d4a04e89ff
9f9df3dc-b6bf-441a-bee7-3efc5e8b01c7	2023-02-13 08:44:05.990923+00	2023-02-13 08:44:05.990923+00	password	05c8e3f0-d4a0-45cd-9b4d-113ecfaa491d
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	78	czzp_NibqgISg2hZandq_g	2954a3b1-8b72-4b76-a9a4-14548f381701	f	2023-02-01 18:32:18.594675+00	2023-02-01 18:32:18.594675+00	\N	387745bb-048e-488a-8400-6ca638214202
00000000-0000-0000-0000-000000000000	79	Vsk4Q3td9Y-qpiLbIR-sNw	2954a3b1-8b72-4b76-a9a4-14548f381701	f	2023-02-01 18:32:25.430832+00	2023-02-01 18:32:25.430832+00	\N	383167ba-43f4-4e84-b7f6-777608eee305
00000000-0000-0000-0000-000000000000	121	bFMKi8tdXaGQogU-vV4JhA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-13 08:39:57.099619+00	2023-02-17 17:53:45.604514+00	1W9UfY_aRln6bukD_v-dwA	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	124	bgeBCxtQ9VlSygB3IyAoMg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-17 17:53:45.609417+00	2023-02-17 18:53:24.545318+00	bFMKi8tdXaGQogU-vV4JhA	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	125	OgwAKMvGCd_sKCPYzTmE3g	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-17 18:53:24.547066+00	2023-02-17 19:52:59.158531+00	bgeBCxtQ9VlSygB3IyAoMg	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	126	8XIXdDfI_F_aXF8dDzi9Jg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-17 19:52:59.160416+00	2023-02-17 20:57:19.927606+00	OgwAKMvGCd_sKCPYzTmE3g	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	127	NbtJEN7R5dou1EarcoeWCg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-17 20:57:19.929961+00	2023-02-18 09:10:17.522626+00	8XIXdDfI_F_aXF8dDzi9Jg	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	128	67P-N0MYYkITnun3QxTR5w	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-18 09:10:17.526116+00	2023-02-22 17:00:33.02276+00	NbtJEN7R5dou1EarcoeWCg	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	129	IKtBqGvMbde7tqAvmyEAiQ	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	f	2023-02-22 17:00:33.037917+00	2023-02-22 17:00:33.037917+00	67P-N0MYYkITnun3QxTR5w	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	101	5t8Dv96zf6bXcSAWbyDaSw	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-03 14:48:24.353903+00	2023-02-04 11:27:54.829007+00	\N	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	102	CpGYCuvpEHpa34tASp2wEg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 11:27:54.832307+00	2023-02-04 12:33:08.555775+00	5t8Dv96zf6bXcSAWbyDaSw	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	103	EEsxs4Y39Sbv70DoM_PZqg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 12:33:08.55871+00	2023-02-04 13:32:56.36261+00	CpGYCuvpEHpa34tASp2wEg	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	104	ajGXmc_6iK6Ev8_r9GzNoQ	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 13:32:56.365105+00	2023-02-04 14:32:36.85451+00	EEsxs4Y39Sbv70DoM_PZqg	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	105	Nz5SoNm7IaFg0wpVSKNjiA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 14:32:36.856201+00	2023-02-04 15:40:55.259862+00	ajGXmc_6iK6Ev8_r9GzNoQ	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	106	qYINm-x3d8wLDbPVlLBVXg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 15:40:55.261588+00	2023-02-04 17:08:28.531399+00	Nz5SoNm7IaFg0wpVSKNjiA	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	107	vpX-z02-oUDZodwDjTkwBw	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 17:08:28.533332+00	2023-02-04 20:26:51.826309+00	qYINm-x3d8wLDbPVlLBVXg	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	108	lGQib9wup9-eizfWbFi-Yw	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-04 20:26:51.827552+00	2023-02-05 11:34:04.647632+00	vpX-z02-oUDZodwDjTkwBw	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	109	-Ta6ba7QkM17gFXSJXabUA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-05 11:34:04.648081+00	2023-02-05 12:34:34.089915+00	lGQib9wup9-eizfWbFi-Yw	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	110	i-IPb-PGAuiHm9zV0_Q67g	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-05 12:34:34.093401+00	2023-02-05 13:43:33.080283+00	-Ta6ba7QkM17gFXSJXabUA	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	113	dKnmgc4a2pXsxuCVJ5N-eA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	f	2023-02-05 13:43:33.080668+00	2023-02-05 13:43:33.080668+00	i-IPb-PGAuiHm9zV0_Q67g	35ceccc4-1d08-4d93-8b25-0fd96907b505
00000000-0000-0000-0000-000000000000	115	ufd2VGwlQMaHiHm0RqSiqQ	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-05 14:08:41.714261+00	2023-02-05 17:56:47.340089+00	\N	a65d0f9e-4c9d-425b-93db-9b466b708d60
00000000-0000-0000-0000-000000000000	116	BgPcCCAzLw8jBnc_FVRPUQ	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-05 17:56:47.34235+00	2023-02-05 18:56:19.028374+00	ufd2VGwlQMaHiHm0RqSiqQ	a65d0f9e-4c9d-425b-93db-9b466b708d60
00000000-0000-0000-0000-000000000000	118	ukpry27P2HOQn4MQmCuXXw	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	f	2023-02-05 18:56:19.032004+00	2023-02-05 18:56:19.032004+00	BgPcCCAzLw8jBnc_FVRPUQ	a65d0f9e-4c9d-425b-93db-9b466b708d60
00000000-0000-0000-0000-000000000000	119	T6cDZmkoiZAXeAC2LyNmVA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-07 10:36:40.39161+00	2023-02-08 10:11:32.367233+00	\N	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	120	1W9UfY_aRln6bukD_v-dwA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	t	2023-02-08 10:11:32.37057+00	2023-02-13 08:39:57.096757+00	T6cDZmkoiZAXeAC2LyNmVA	3958cddf-d7bd-4feb-9cfc-a9e36157e181
00000000-0000-0000-0000-000000000000	123	zkSytDKHnL8CdefUK8JZYA	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	f	2023-02-13 08:44:05.988012+00	2023-02-13 08:44:05.988012+00	\N	9f9df3dc-b6bf-441a-bee7-3efc5e8b01c7
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, from_ip_address, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after) FROM stdin;
387745bb-048e-488a-8400-6ca638214202	2954a3b1-8b72-4b76-a9a4-14548f381701	2023-02-01 18:32:18.593552+00	2023-02-01 18:32:18.593552+00	\N	aal1	\N
383167ba-43f4-4e84-b7f6-777608eee305	2954a3b1-8b72-4b76-a9a4-14548f381701	2023-02-01 18:32:25.43001+00	2023-02-01 18:32:25.43001+00	\N	aal1	\N
35ceccc4-1d08-4d93-8b25-0fd96907b505	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-03 14:48:24.35206+00	2023-02-03 14:48:24.35206+00	\N	aal1	\N
a65d0f9e-4c9d-425b-93db-9b466b708d60	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-05 14:08:41.713301+00	2023-02-05 14:08:41.713301+00	\N	aal1	\N
3958cddf-d7bd-4feb-9cfc-a9e36157e181	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-07 10:36:40.389433+00	2023-02-07 10:36:40.389433+00	\N	aal1	\N
9f9df3dc-b6bf-441a-bee7-3efc5e8b01c7	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-13 08:44:05.986581+00	2023-02-13 08:44:05.986581+00	\N	aal1	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user) FROM stdin;
00000000-0000-0000-0000-000000000000	2954a3b1-8b72-4b76-a9a4-14548f381701	authenticated	authenticated	yasminebha5@gmail.com	$2a$10$rIVLQhv3v9S.8PT9hApk1eHtszLm9aES/q6yP.ONUr31sgI80Pvo2	2023-02-01 18:32:18.592692+00	\N		2023-02-01 18:32:03.754812+00		\N			\N	2023-02-01 18:32:25.42995+00	{"provider": "email", "providers": ["email"]}	{"picture": "https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/yasmine2bhapothos.jpg", "username": "yasmine2bha"}	\N	2023-02-01 18:32:03.750555+00	2023-02-01 18:32:25.431909+00	\N	\N			\N		0	\N		\N	f
00000000-0000-0000-0000-000000000000	314decbc-a5b7-45fb-8217-0fa8b37f3139	authenticated	authenticated	obha121@gmail.com	$2a$10$YTQOGmyuG3I.BXO2ROd5SOCmZWUFBZ68kqH8P70D3SsnPqAV5FRCG	2023-02-05 13:00:18.381291+00	\N		2023-02-05 12:58:37.196935+00		\N			\N	2023-02-05 13:00:31.734151+00	{"provider": "email", "providers": ["email"]}	{"picture": "https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/ouchemaundefined", "username": "ouchema"}	\N	2023-02-05 12:58:37.182634+00	2023-02-13 08:43:49.483336+00	\N	\N			\N		0	\N		\N	f
00000000-0000-0000-0000-000000000000	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	authenticated	authenticated	ybelhajali@gmail.com	$2a$10$krLtE6q.E1Ky05zLpew.TupmQM5fKIUrtEYZ6omBUKLnxj.dVjkeC	2023-02-01 18:21:13.498658+00	\N		2023-02-01 18:11:06.56603+00		\N			\N	2023-02-13 08:44:05.986052+00	{"provider": "email", "providers": ["email"]}	{"picture": "https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/yasminebhacactus.jpg", "username": "yasminebha"}	\N	2023-02-01 18:11:06.561585+00	2023-02-22 17:00:33.054763+00	\N	\N			\N		0	\N		\N	f
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: postgres
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friendships (id, "userID", "friendID", created_at) FROM stdin;
20	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2954a3b1-8b72-4b76-a9a4-14548f381701	2023-02-08 10:26:58.564811+00
21	2954a3b1-8b72-4b76-a9a4-14548f381701	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-08 10:26:58.564811+00
22	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	314decbc-a5b7-45fb-8217-0fa8b37f3139	2023-02-13 08:49:20.936856+00
23	314decbc-a5b7-45fb-8217-0fa8b37f3139	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-13 08:49:20.936856+00
\.


--
-- Data for Name: medias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medias (id, created_at, type, source, "postID") FROM stdin;
55	2023-02-01 18:22:01.449508+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675275714537.jpeg	52
56	2023-02-01 18:22:06.7306+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675275714640.jpeg	52
57	2023-02-01 18:28:48.535188+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675276125916.jpeg	53
58	2023-02-01 18:33:04.04341+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/2954a3b1-8b72-4b76-a9a4-14548f381701/images/1675276381170.jpeg	54
59	2023-02-01 18:33:04.044581+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/2954a3b1-8b72-4b76-a9a4-14548f381701/images/1675276381271.jpeg	54
60	2023-02-02 16:03:38.009526+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751467.jpeg	55
61	2023-02-02 16:03:39.489266+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751689.jpeg	55
62	2023-02-02 16:03:40.195437+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751577.jpeg	55
63	2023-02-02 16:06:17.724867+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353956867.jpeg	56
64	2023-02-02 16:06:30.93164+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353956976.jpeg	56
65	2023-02-02 19:05:23.376732+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675364721599.jpeg	57
66	2023-02-05 14:27:40.135484+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/314decbc-a5b7-45fb-8217-0fa8b37f3139/images/1675607254409.jpeg	59
67	2023-02-13 08:40:52.04343+00	image	https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1676277650406.jpeg	60
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, created_at, "userID", description, geo) FROM stdin;
52	2023-02-01 18:21:54.62372+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	first post	(10.2095525,36.713434)
54	2023-02-01 18:33:01.414035+00	2954a3b1-8b72-4b76-a9a4-14548f381701	3rd post by 2nd user	(10.5596815,35.9118987)
55	2023-02-02 16:02:32.02705+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	3rd post	(10.5596836,35.9118995)
56	2023-02-02 16:05:58.072831+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	4th post	(10.5596836,35.9118995)
57	2023-02-02 19:05:21.265349+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	5th post	(10.5596828,35.9118987)
53	2023-02-01 18:28:45+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2nd post	(10.562417,35.913885)
59	2023-02-05 14:27:34.693039+00	314decbc-a5b7-45fb-8217-0fa8b37f3139	6th post	(10.5597029,35.9118962)
60	2023-02-13 08:40:49.965386+00	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	7th post	(10.7600196,34.739822)
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
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public) FROM stdin;
medias	medias	\N	2023-01-29 14:15:56.167587+00	2023-01-29 14:15:56.167587+00	t
avatars	avatars	\N	2023-02-01 14:53:40.235131+00	2023-02-01 14:53:40.235131+00	t
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2023-01-27 20:36:45.867802
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2023-01-27 20:36:45.887096
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2023-01-27 20:36:45.892148
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2023-01-27 20:36:45.952274
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2023-01-27 20:36:45.957028
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2023-01-27 20:36:45.962366
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2023-01-27 20:36:45.967868
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2023-01-27 20:36:45.972186
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2023-01-27 20:36:45.977067
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2023-01-27 20:36:45.981505
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2023-01-27 20:36:45.987776
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata) FROM stdin;
11fccd6e-dc20-4883-ac49-4680b0688b5e	avatars	yasminebhacactus.jpg	\N	2023-02-01 18:11:05.279148+00	2023-02-01 18:11:05.743095+00	2023-02-01 18:11:05.279148+00	{"eTag": "\\"de9d7400c9eabc647fb0a10845b61ae3\\"", "size": 258089, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:11:06.000Z", "contentLength": 258089, "httpStatusCode": 200}
186aa1f1-8447-4a98-bf1d-59b476bdea6d	medias	2954a3b1-8b72-4b76-a9a4-14548f381701/images/1675276381170.jpeg	2954a3b1-8b72-4b76-a9a4-14548f381701	2023-02-01 18:33:03.257354+00	2023-02-01 18:33:03.743017+00	2023-02-01 18:33:03.257354+00	{"eTag": "\\"f73e0a8633b527bd76daf9d482470ef0\\"", "size": 222094, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:33:04.000Z", "contentLength": 222094, "httpStatusCode": 200}
ddc3172e-27a3-4ab5-95e1-1e529e493d34	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751467.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 16:03:08.2301+00	2023-02-02 16:03:08.502502+00	2023-02-02 16:03:08.2301+00	{"eTag": "\\"de9d7400c9eabc647fb0a10845b61ae3\\"", "size": 258089, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T16:03:09.000Z", "contentLength": 258089, "httpStatusCode": 200}
5f4f19cb-aafe-4384-8602-e3d1627099e4	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751689.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 16:03:38.414019+00	2023-02-02 16:03:38.718303+00	2023-02-02 16:03:38.414019+00	{"eTag": "\\"14cf9205eb71f94af06c2a8c123d81b5\\"", "size": 221319, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T16:03:39.000Z", "contentLength": 221319, "httpStatusCode": 200}
7a8d2051-f312-464d-a2a9-43c5c686e8ef	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353751577.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 16:03:39.653136+00	2023-02-02 16:03:39.931622+00	2023-02-02 16:03:39.653136+00	{"eTag": "\\"ff132166b87299887df6b434780e07e8\\"", "size": 216582, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T16:03:40.000Z", "contentLength": 216582, "httpStatusCode": 200}
79f96680-d025-40c3-96a1-6f2ce05ae53c	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675364721599.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 19:05:22.595025+00	2023-02-02 19:05:23.087935+00	2023-02-02 19:05:22.595025+00	{"eTag": "\\"de9d7400c9eabc647fb0a10845b61ae3\\"", "size": 258089, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T19:05:23.000Z", "contentLength": 258089, "httpStatusCode": 200}
622c3dc5-ff4a-4918-9ab9-6ac53f52b66e	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675275714537.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-01 18:21:58.913555+00	2023-02-01 18:21:59.130796+00	2023-02-01 18:21:58.913555+00	{"eTag": "\\"463c10225562347d90047a8078df1f96\\"", "size": 98687, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:21:59.000Z", "contentLength": 98687, "httpStatusCode": 200}
277c04d1-54f7-4369-bebf-83c2829144f0	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675275714640.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-01 18:22:05.610399+00	2023-02-01 18:22:06.321422+00	2023-02-01 18:22:05.610399+00	{"eTag": "\\"3b86648d45636f079e017ecb9d9600df\\"", "size": 312745, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:22:06.000Z", "contentLength": 312745, "httpStatusCode": 200}
5e51b30f-2bd1-45d6-a7da-1476835ab434	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675276125916.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-01 18:28:47.93825+00	2023-02-01 18:28:48.297389+00	2023-02-01 18:28:47.93825+00	{"eTag": "\\"dc0510aaa36be864459c2f014e70e006\\"", "size": 263287, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:28:49.000Z", "contentLength": 263287, "httpStatusCode": 200}
259b4c56-148f-4225-8864-3e496e3e994a	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353956867.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 16:06:09.623515+00	2023-02-02 16:06:09.763634+00	2023-02-02 16:06:09.623515+00	{"eTag": "\\"ff132166b87299887df6b434780e07e8\\"", "size": 216582, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T16:06:10.000Z", "contentLength": 216582, "httpStatusCode": 200}
a5be15f1-eb89-43e6-b1eb-1103fa6c5c6d	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1675353956976.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-02 16:06:30.262192+00	2023-02-02 16:06:30.706142+00	2023-02-02 16:06:30.262192+00	{"eTag": "\\"cc60210cc4057a8d2f9d5e095b811006\\"", "size": 253615, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-02T16:06:31.000Z", "contentLength": 253615, "httpStatusCode": 200}
ccaf9f03-f58b-40d8-9852-937215e4963e	avatars	ouchemaundefined	\N	2023-02-05 12:58:36.587913+00	2023-02-05 12:58:36.775689+00	2023-02-05 12:58:36.587913+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain;charset=UTF-8", "cacheControl": "max-age=3600", "lastModified": "2023-02-05T12:58:37.000Z", "contentLength": 0, "httpStatusCode": 200}
abdeeb11-69d8-4106-9130-77ca551f727f	avatars	yasmine2bhapothos.jpg	\N	2023-02-01 18:32:02.919899+00	2023-02-01 18:32:03.418522+00	2023-02-01 18:32:02.919899+00	{"eTag": "\\"cc60210cc4057a8d2f9d5e095b811006\\"", "size": 253615, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:32:04.000Z", "contentLength": 253615, "httpStatusCode": 200}
2a6245be-be50-4c13-9369-c01ea695831b	medias	2954a3b1-8b72-4b76-a9a4-14548f381701/images/1675276381271.jpeg	2954a3b1-8b72-4b76-a9a4-14548f381701	2023-02-01 18:33:03.37633+00	2023-02-01 18:33:03.764221+00	2023-02-01 18:33:03.37633+00	{"eTag": "\\"14cf9205eb71f94af06c2a8c123d81b5\\"", "size": 221319, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:33:04.000Z", "contentLength": 221319, "httpStatusCode": 200}
df9a0d1b-5ef8-4b22-9807-54718bb04d64	medias	314decbc-a5b7-45fb-8217-0fa8b37f3139/images/1675607254409.jpeg	314decbc-a5b7-45fb-8217-0fa8b37f3139	2023-02-05 14:27:36.031401+00	2023-02-05 14:27:36.230997+00	2023-02-05 14:27:36.031401+00	{"eTag": "\\"073562347143fc48f65aad953cf5f445\\"", "size": 48600, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-05T14:27:37.000Z", "contentLength": 48600, "httpStatusCode": 200}
1379289b-b125-4caa-8642-a439c1802dcd	medias	211f9ab1-82d6-4f79-8de4-1b3ced8081d3/images/1676277650406.jpeg	211f9ab1-82d6-4f79-8de4-1b3ced8081d3	2023-02-13 08:40:51.143719+00	2023-02-13 08:40:51.664452+00	2023-02-13 08:40:51.143719+00	{"eTag": "\\"14cf9205eb71f94af06c2a8c123d81b5\\"", "size": 221319, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-02-13T08:40:52.000Z", "contentLength": 221319, "httpStatusCode": 200}
8419bd91-d2bc-4cc9-a737-5327264707e3	avatars	.emptyFolderPlaceholder	\N	2023-02-01 15:15:41.595802+00	2023-02-01 15:15:41.688187+00	2023-02-01 15:15:41.595802+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T15:15:42.000Z", "contentLength": 0, "httpStatusCode": 200}
faa7ba85-9df0-46c7-80d2-b9d42b784624	medias	91c5fac0-1ccf-4cfa-a54e-8691fb722794/images/.emptyFolderPlaceholder	\N	2023-02-01 18:09:40.90069+00	2023-02-01 18:09:40.98949+00	2023-02-01 18:09:40.90069+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2023-02-01T18:09:41.000Z", "contentLength": 0, "httpStatusCode": 200}
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 129, true);


--
-- Name: friendships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.friendships_id_seq', 35, true);


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_id_seq', 67, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 60, true);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 30, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_userID_friendID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT "friendships_userID_friendID_key" UNIQUE ("userID", "friendID");


--
-- Name: medias media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


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
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: friendships friendships_friendID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT "friendships_friendID_fkey" FOREIGN KEY ("friendID") REFERENCES auth.users(id);


--
-- Name: friendships friendships_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT "friendships_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id);


--
-- Name: medias medias_postID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT "medias_postID_fkey" FOREIGN KEY ("postID") REFERENCES public.posts(id);


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
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects Enable all for authenticated users and anon; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable all for authenticated users and anon" ON storage.objects TO anon, authenticated WITH CHECK (true);


--
-- Name: buckets Enable insert for authenticated users and anon; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable insert for authenticated users and anon" ON storage.buckets FOR INSERT TO anon, authenticated WITH CHECK (true);


--
-- Name: objects Enable insert for authenticated users only; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON storage.objects FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: buckets Enable read access for all users; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable read access for all users" ON storage.buckets TO authenticated USING (true);


--
-- Name: objects Enable read access for all users; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable read access for all users" ON storage.objects TO authenticated;


--
-- Name: objects Give anon users access to JPG images in folder 1h7a3v3_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1h7a3v3_0" ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'medias'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1h7a3v3_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1h7a3v3_1" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'medias'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1h7a3v3_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1h7a3v3_2" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'medias'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1h7a3v3_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1h7a3v3_3" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'medias'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1oj01fe_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1oj01fe_0" ON storage.objects FOR SELECT USING (((bucket_id = 'avatars'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1oj01fe_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1oj01fe_1" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'avatars'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1oj01fe_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1oj01fe_2" ON storage.objects FOR UPDATE USING (((bucket_id = 'avatars'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: objects Give anon users access to JPG images in folder 1oj01fe_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder 1oj01fe_3" ON storage.objects FOR DELETE USING (((bucket_id = 'avatars'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA pgsodium; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA pgsodium FROM supabase_admin;
REVOKE USAGE ON SCHEMA pgsodium FROM PUBLIC;
GRANT ALL ON SCHEMA pgsodium TO postgres;
GRANT USAGE ON SCHEMA pgsodium TO PUBLIC;


--
-- Name: SCHEMA pgsodium_masks; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA pgsodium_masks FROM supabase_admin;
REVOKE USAGE ON SCHEMA pgsodium_masks FROM pgsodium_keyiduser;
GRANT ALL ON SCHEMA pgsodium_masks TO postgres;
GRANT USAGE ON SCHEMA pgsodium_masks TO pgsodium_keyiduser;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION cube_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_in(cstring) TO anon;
GRANT ALL ON FUNCTION public.cube_in(cstring) TO authenticated;
GRANT ALL ON FUNCTION public.cube_in(cstring) TO service_role;


--
-- Name: FUNCTION cube_out(public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_out(public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_out(public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_out(public.cube) TO service_role;


--
-- Name: FUNCTION cube_recv(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_recv(internal) TO anon;
GRANT ALL ON FUNCTION public.cube_recv(internal) TO authenticated;
GRANT ALL ON FUNCTION public.cube_recv(internal) TO service_role;


--
-- Name: FUNCTION cube_send(public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_send(public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_send(public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_send(public.cube) TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- Name: FUNCTION get_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO service_role;


--
-- Name: FUNCTION increment_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.increment_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: TABLE key; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON TABLE pgsodium.key FROM supabase_admin;
REVOKE ALL ON TABLE pgsodium.key FROM pgsodium_keymaker;
GRANT ALL ON TABLE pgsodium.key TO postgres;
GRANT ALL ON TABLE pgsodium.key TO pgsodium_keymaker;


--
-- Name: TABLE valid_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON TABLE pgsodium.valid_key FROM supabase_admin;
REVOKE ALL ON TABLE pgsodium.valid_key FROM pgsodium_keyholder;
REVOKE SELECT ON TABLE pgsodium.valid_key FROM pgsodium_keyiduser;
GRANT ALL ON TABLE pgsodium.valid_key TO postgres;
GRANT ALL ON TABLE pgsodium.valid_key TO pgsodium_keyholder;
GRANT SELECT ON TABLE pgsodium.valid_key TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION crypto_aead_det_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO PUBLIC;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_aead_ietf_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_aead_ietf_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth_hmacsha256(message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth_hmacsha256_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth_hmacsha512(message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_auth_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_auth_verify(mac bytea, message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_box(message bytea, nonce bytea, public bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_box_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_new_keypair() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_box_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_noncegen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_noncegen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_box_seed_new_keypair(seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_generichash(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_generichash_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_generichash_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_generichash_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_kdf_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_kx_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_kx_new_seed(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_seed() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_seed() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_seed() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_seed() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_kx_seed_new_keypair(seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_secretbox(message bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_secretbox_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_secretbox_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_shorthash(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION crypto_shorthash_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_sign_final_create(state bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_sign_final_verify(state bytea, signature bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_sign_init(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_init() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_init() FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_init() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_init() TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_sign_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_sign_update(state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_sign_update_agg1(state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_signcrypt_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() TO pgsodium_keymaker;


--
-- Name: FUNCTION crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- Name: FUNCTION derive_key(key_id bigint, key_len integer, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) TO pgsodium_keymaker;


--
-- Name: FUNCTION pgsodium_derive(key_id bigint, key_len integer, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) TO pgsodium_keymaker;


--
-- Name: FUNCTION randombytes_buf(size integer); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_buf(size integer) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf(size integer) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf(size integer) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf(size integer) TO pgsodium_keyiduser;


--
-- Name: FUNCTION randombytes_buf_deterministic(size integer, seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM pgsodium_keymaker;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO pgsodium_keyiduser;


--
-- Name: FUNCTION randombytes_new_seed(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_new_seed() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_new_seed() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.randombytes_new_seed() TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_new_seed() TO pgsodium_keymaker;


--
-- Name: FUNCTION randombytes_random(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_random() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_random() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_random() TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_random() TO pgsodium_keyiduser;


--
-- Name: FUNCTION randombytes_uniform(upper_bound integer); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) TO pgsodium_keyiduser;


--
-- Name: FUNCTION create_friendship(user_id uuid, friend_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_friendship(user_id uuid, friend_id uuid) TO anon;
GRANT ALL ON FUNCTION public.create_friendship(user_id uuid, friend_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.create_friendship(user_id uuid, friend_id uuid) TO service_role;


--
-- Name: FUNCTION cube(double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(double precision[]) TO anon;
GRANT ALL ON FUNCTION public.cube(double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.cube(double precision[]) TO service_role;


--
-- Name: FUNCTION cube(double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(double precision) TO anon;
GRANT ALL ON FUNCTION public.cube(double precision) TO authenticated;
GRANT ALL ON FUNCTION public.cube(double precision) TO service_role;


--
-- Name: FUNCTION cube(double precision[], double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(double precision[], double precision[]) TO anon;
GRANT ALL ON FUNCTION public.cube(double precision[], double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.cube(double precision[], double precision[]) TO service_role;


--
-- Name: FUNCTION cube(double precision, double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(double precision, double precision) TO anon;
GRANT ALL ON FUNCTION public.cube(double precision, double precision) TO authenticated;
GRANT ALL ON FUNCTION public.cube(double precision, double precision) TO service_role;


--
-- Name: FUNCTION cube(public.cube, double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(public.cube, double precision) TO anon;
GRANT ALL ON FUNCTION public.cube(public.cube, double precision) TO authenticated;
GRANT ALL ON FUNCTION public.cube(public.cube, double precision) TO service_role;


--
-- Name: FUNCTION cube(public.cube, double precision, double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube(public.cube, double precision, double precision) TO anon;
GRANT ALL ON FUNCTION public.cube(public.cube, double precision, double precision) TO authenticated;
GRANT ALL ON FUNCTION public.cube(public.cube, double precision, double precision) TO service_role;


--
-- Name: FUNCTION cube_cmp(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_cmp(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_cmp(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_cmp(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_contained(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_contained(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_contained(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_contained(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_contains(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_contains(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_contains(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_contains(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_coord(public.cube, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_coord(public.cube, integer) TO anon;
GRANT ALL ON FUNCTION public.cube_coord(public.cube, integer) TO authenticated;
GRANT ALL ON FUNCTION public.cube_coord(public.cube, integer) TO service_role;


--
-- Name: FUNCTION cube_coord_llur(public.cube, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_coord_llur(public.cube, integer) TO anon;
GRANT ALL ON FUNCTION public.cube_coord_llur(public.cube, integer) TO authenticated;
GRANT ALL ON FUNCTION public.cube_coord_llur(public.cube, integer) TO service_role;


--
-- Name: FUNCTION cube_dim(public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_dim(public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_dim(public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_dim(public.cube) TO service_role;


--
-- Name: FUNCTION cube_distance(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_distance(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_distance(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_distance(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_enlarge(public.cube, double precision, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_enlarge(public.cube, double precision, integer) TO anon;
GRANT ALL ON FUNCTION public.cube_enlarge(public.cube, double precision, integer) TO authenticated;
GRANT ALL ON FUNCTION public.cube_enlarge(public.cube, double precision, integer) TO service_role;


--
-- Name: FUNCTION cube_eq(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_eq(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_eq(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_eq(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_ge(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_ge(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_ge(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_ge(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_gt(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_gt(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_gt(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_gt(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_inter(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_inter(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_inter(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_inter(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_is_point(public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_is_point(public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_is_point(public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_is_point(public.cube) TO service_role;


--
-- Name: FUNCTION cube_le(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_le(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_le(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_le(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_ll_coord(public.cube, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_ll_coord(public.cube, integer) TO anon;
GRANT ALL ON FUNCTION public.cube_ll_coord(public.cube, integer) TO authenticated;
GRANT ALL ON FUNCTION public.cube_ll_coord(public.cube, integer) TO service_role;


--
-- Name: FUNCTION cube_lt(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_lt(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_lt(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_lt(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_ne(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_ne(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_ne(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_ne(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_overlap(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_overlap(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_overlap(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_overlap(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_size(public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_size(public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_size(public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_size(public.cube) TO service_role;


--
-- Name: FUNCTION cube_subset(public.cube, integer[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_subset(public.cube, integer[]) TO anon;
GRANT ALL ON FUNCTION public.cube_subset(public.cube, integer[]) TO authenticated;
GRANT ALL ON FUNCTION public.cube_subset(public.cube, integer[]) TO service_role;


--
-- Name: FUNCTION cube_union(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_union(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.cube_union(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.cube_union(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION cube_ur_coord(public.cube, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cube_ur_coord(public.cube, integer) TO anon;
GRANT ALL ON FUNCTION public.cube_ur_coord(public.cube, integer) TO authenticated;
GRANT ALL ON FUNCTION public.cube_ur_coord(public.cube, integer) TO service_role;


--
-- Name: FUNCTION distance_chebyshev(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.distance_chebyshev(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.distance_chebyshev(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.distance_chebyshev(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION distance_taxicab(public.cube, public.cube); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.distance_taxicab(public.cube, public.cube) TO anon;
GRANT ALL ON FUNCTION public.distance_taxicab(public.cube, public.cube) TO authenticated;
GRANT ALL ON FUNCTION public.distance_taxicab(public.cube, public.cube) TO service_role;


--
-- Name: FUNCTION earth(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.earth() TO anon;
GRANT ALL ON FUNCTION public.earth() TO authenticated;
GRANT ALL ON FUNCTION public.earth() TO service_role;


--
-- Name: FUNCTION earth_box(public.earth, double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.earth_box(public.earth, double precision) TO anon;
GRANT ALL ON FUNCTION public.earth_box(public.earth, double precision) TO authenticated;
GRANT ALL ON FUNCTION public.earth_box(public.earth, double precision) TO service_role;


--
-- Name: FUNCTION earth_distance(public.earth, public.earth); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.earth_distance(public.earth, public.earth) TO anon;
GRANT ALL ON FUNCTION public.earth_distance(public.earth, public.earth) TO authenticated;
GRANT ALL ON FUNCTION public.earth_distance(public.earth, public.earth) TO service_role;


--
-- Name: FUNCTION g_cube_consistent(internal, public.cube, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_consistent(internal, public.cube, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_consistent(internal, public.cube, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_consistent(internal, public.cube, smallint, oid, internal) TO service_role;


--
-- Name: FUNCTION g_cube_distance(internal, public.cube, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_distance(internal, public.cube, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_distance(internal, public.cube, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_distance(internal, public.cube, smallint, oid, internal) TO service_role;


--
-- Name: FUNCTION g_cube_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_penalty(internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_penalty(internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_penalty(internal, internal, internal) TO service_role;


--
-- Name: FUNCTION g_cube_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_picksplit(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_picksplit(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_picksplit(internal, internal) TO service_role;


--
-- Name: FUNCTION g_cube_same(public.cube, public.cube, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_same(public.cube, public.cube, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_same(public.cube, public.cube, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_same(public.cube, public.cube, internal) TO service_role;


--
-- Name: FUNCTION g_cube_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.g_cube_union(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.g_cube_union(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.g_cube_union(internal, internal) TO service_role;


--
-- Name: FUNCTION gc_to_sec(double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gc_to_sec(double precision) TO anon;
GRANT ALL ON FUNCTION public.gc_to_sec(double precision) TO authenticated;
GRANT ALL ON FUNCTION public.gc_to_sec(double precision) TO service_role;


--
-- Name: FUNCTION geo_distance(point, point); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.geo_distance(point, point) TO anon;
GRANT ALL ON FUNCTION public.geo_distance(point, point) TO authenticated;
GRANT ALL ON FUNCTION public.geo_distance(point, point) TO service_role;


--
-- Name: FUNCTION latitude(public.earth); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.latitude(public.earth) TO anon;
GRANT ALL ON FUNCTION public.latitude(public.earth) TO authenticated;
GRANT ALL ON FUNCTION public.latitude(public.earth) TO service_role;


--
-- Name: FUNCTION ll_to_earth(double precision, double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ll_to_earth(double precision, double precision) TO anon;
GRANT ALL ON FUNCTION public.ll_to_earth(double precision, double precision) TO authenticated;
GRANT ALL ON FUNCTION public.ll_to_earth(double precision, double precision) TO service_role;


--
-- Name: FUNCTION longitude(public.earth); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.longitude(public.earth) TO anon;
GRANT ALL ON FUNCTION public.longitude(public.earth) TO authenticated;
GRANT ALL ON FUNCTION public.longitude(public.earth) TO service_role;


--
-- Name: FUNCTION nearby_posts(lng numeric, lat numeric, rad numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.nearby_posts(lng numeric, lat numeric, rad numeric) TO anon;
GRANT ALL ON FUNCTION public.nearby_posts(lng numeric, lat numeric, rad numeric) TO authenticated;
GRANT ALL ON FUNCTION public.nearby_posts(lng numeric, lat numeric, rad numeric) TO service_role;


--
-- Name: FUNCTION remove_friendship(user_id uuid, friend_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_friendship(user_id uuid, friend_id uuid) TO anon;
GRANT ALL ON FUNCTION public.remove_friendship(user_id uuid, friend_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.remove_friendship(user_id uuid, friend_id uuid) TO service_role;


--
-- Name: FUNCTION sec_to_gc(double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sec_to_gc(double precision) TO anon;
GRANT ALL ON FUNCTION public.sec_to_gc(double precision) TO authenticated;
GRANT ALL ON FUNCTION public.sec_to_gc(double precision) TO service_role;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;
GRANT ALL ON TABLE auth.audit_log_entries TO PUBLIC;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;
GRANT ALL ON TABLE auth.identities TO PUBLIC;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;
GRANT ALL ON TABLE auth.instances TO PUBLIC;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;
GRANT ALL ON TABLE auth.mfa_amr_claims TO PUBLIC;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;
GRANT ALL ON TABLE auth.mfa_challenges TO PUBLIC;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;
GRANT ALL ON TABLE auth.mfa_factors TO PUBLIC;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;
GRANT ALL ON TABLE auth.refresh_tokens TO PUBLIC;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;
GRANT ALL ON TABLE auth.saml_providers TO PUBLIC;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;
GRANT ALL ON TABLE auth.saml_relay_states TO PUBLIC;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;
GRANT ALL ON TABLE auth.schema_migrations TO PUBLIC;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;
GRANT ALL ON TABLE auth.sessions TO PUBLIC;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;
GRANT ALL ON TABLE auth.sso_domains TO PUBLIC;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;
GRANT ALL ON TABLE auth.sso_providers TO PUBLIC;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;
GRANT ALL ON TABLE auth.users TO PUBLIC;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: SEQUENCE key_key_id_seq; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON SEQUENCE pgsodium.key_key_id_seq FROM supabase_admin;
REVOKE ALL ON SEQUENCE pgsodium.key_key_id_seq FROM pgsodium_keymaker;
GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO postgres;
GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO pgsodium_keymaker;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE friendships; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.friendships TO anon;
GRANT ALL ON TABLE public.friendships TO authenticated;
GRANT ALL ON TABLE public.friendships TO service_role;


--
-- Name: SEQUENCE friendships_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.friendships_id_seq TO anon;
GRANT ALL ON SEQUENCE public.friendships_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.friendships_id_seq TO service_role;


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
-- Name: TABLE posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.posts TO anon;
GRANT ALL ON TABLE public.posts TO authenticated;
GRANT ALL ON TABLE public.posts TO service_role;


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
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


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
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

