#!/bin/bash
docker exec -it db pg_restore postgres://postgres:Tv9WT0ZAbUlPh0eP@db.bdrfsldnykzfwnvnwztn.supabase.co:5432/postgres --schema public > /var/lib/postgresql/data/backup.sql