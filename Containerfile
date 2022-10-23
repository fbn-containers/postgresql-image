FROM docker.io/fedora:36

ARG PG_RELEASE="15"
ARG PG_VERSION="${PG_RELEASE}.0"

RUN set -ex; \
      groupadd -r --gid=26 postgres; \
      useradd -r --uid=26 -g postgres --create-home --home-dir=/var/lib/postgresql --shell=/bin/bash postgres;

COPY repos/postgresql-common.repo /etc/yum.repos.d/postgresql-common.repo
COPY repos/postgresql-${PG_RELEASE}.repo /etc/yum.repos.d/postgresql-${PG_RELEASE}.repo 
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN set -ex; \
      dnf install --setopt=install_weak_deps=False -y postgresql${PG_RELEASE}-server-${PG_VERSION}; \
      dnf clean all; \
      rm -rf /var/cache/dnf/*;

RUN set -ex; \
      rm -rf /var/lib/pgsql; \
      mkdir -p /var/lib/postgresql/{data,backups} /etc/postgresql; \
      chown -R postgres:postgres /var/lib/postgresql; \
      ln -s /usr/pgsql-${PG_RELEASE} /usr/pgsql;

COPY config/postgresql.conf.default /etc/postgresql/postgresql.conf
COPY config/pg_hba.conf.default /etc/postgresql/pg_hba.conf

USER postgres

EXPOSE 5432

STOPSIGNAL SIGINT

VOLUME [ "/var/lib/postgresql/data" ]

ENV PATH="$PATH:/usr/pgsql/bin"
ENV PGDATA="/var/lib/postgresql/data"

ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "/usr/pgsql/bin/postgres", "-c", "config_file=/etc/postgresql/postgresql.conf" ]
