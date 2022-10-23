#!/bin/bash
set -eo pipefail

# Ensure data directory exists with correct perms
echo -e "* Prepare database instance directories..."
chown -R postgres:postgres /var/lib/postgresql
chmod 700 /var/lib/postgresql/data
chmod 755 /var/lib/postgresql/backups

# Basic test to check if instance has already been initialized
if [ ! -d "$DATADIR"/PG_VERSION ]; then

  echo -e "* Initializing database instance...\n"
  /usr/pgsql/bin/initdb \
    --pgdata=/var/lib/postgresql/data \
    --locale="C.UTF-8" \
    --encoding="UTF8"
fi

exec "$@"
