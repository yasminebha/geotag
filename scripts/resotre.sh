#!/bin/bash
docker exec -it pgsql pg_restore postgres://postgres:Tv9WT0ZAbUlPh0eP@db.bdrfsldnykzfwnvnwztn.supabase.co:5432/postgres --schema public > /var/lib/postgresql/backups/20230228_public.sql