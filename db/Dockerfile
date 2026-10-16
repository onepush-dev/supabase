FROM supabase/postgres:17.6.1.136@sha256:f371b5f3f2ac0a05703f33d6e6134515fb2498cab708fb948a0aeb7481467c00
# Init scripts the upstream docker-compose bind-mounts (Railway can't bind-mount files)
COPY sql/realtime.sql   /docker-entrypoint-initdb.d/migrations/99-realtime.sql
COPY sql/webhooks.sql   /docker-entrypoint-initdb.d/init-scripts/98-webhooks.sql
COPY sql/roles.sql      /docker-entrypoint-initdb.d/init-scripts/99-roles.sql
COPY sql/jwt.sql        /docker-entrypoint-initdb.d/init-scripts/99-jwt.sql
COPY sql/_supabase.sql  /docker-entrypoint-initdb.d/migrations/97-_supabase.sql
COPY sql/logs.sql       /docker-entrypoint-initdb.d/migrations/99-logs.sql
COPY sql/pooler.sql     /docker-entrypoint-initdb.d/migrations/99-pooler.sql
COPY --chown=postgres:postgres --chmod=0755 pgsodium_getkey.sh /usr/lib/postgresql/bin/pgsodium_getkey.sh
# Railway volume root contains lost+found, so keep PGDATA in a subdirectory
ENV PGDATA=/var/lib/postgresql/data/pgdata
CMD ["postgres","-D","/etc/postgresql","-c","config_file=/etc/postgresql/postgresql.conf","-c","log_min_messages=fatal"]
