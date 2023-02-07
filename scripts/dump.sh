#!/bin/bash
docker exec -it pgsql > /bin/sh pg_dump postgres://postgres:Tv9WT0ZAbUlPh0eP@db.bdrfsldnykzfwnvnwztn.supabase.co:5432/postgres --schema public > /var/lib/postgresql/data/backup.sql