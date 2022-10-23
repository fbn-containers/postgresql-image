<p><img src="https://icon-library.com/images/postgresql-icon/postgresql-icon-20.jpg" alt="pg-logo" title="pg" align="top" height=180 /></p>

*PostgreSQL is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads. PostgreSQL has earned a strong reputation for its proven architecture, reliability, data integrity, robust feature set, extensibility, and the dedication of the open source community behind the software to consistently deliver performant and innovative solutions.*

### General informations

This repository contains personal configurations to build a PostgreSQL server image in OCI format (usage with Docker, Podman and/or Kubernetes).

**References**

  - PostgreSQL : https://www.postgresql.org/

### Environment Variables

*To be implemented*

### How to use this image ?

* **Start a simple instance**

  ```shell
  podman run -d --name mypostgres -p 5432:5432 postgresql:15
  ```

* **Start an instance with custom instance configurations**

  ```shell
  podman run -d \
    --name my-custom-postgres \
    -p 5432:5432 \
    -v /path/to/postgresql.conf:/etc/postgresql/postgresql.conf \
    -v /path/to/pg_hba.conf:/etc/postgresql/pg_hba.conf \
    postgresql:15
  ```

### How to build this image ?

* **Build the image using Buildah and cache overlay mount**

  You can build this image using Buildah and using a neat feature to reduce build times, overlay mounts (especially for the DNF/YUM package manager which is slow to sync packages metadatas). Generate the packages metadatas cache with Podman :
  
  ```shell
  # Create cache directory
  mkdir -p /home/user/.cache/buildah/dnf/f36
  
  # Generate DNF metadata cache
  export BUILDAH_DNF_CACHE="/home/user/.cache/buildah/dnf"
  podman run -v ${BUILDAH_DNF_CACHE}/f36:/var/cache/dnf fedora:36 dnf makecache
  ```
  
  Since the image is based on Fedora 36 distribution, we can use the dedicated cache that we have just created using overlay mount (with the `:O` mount option) :
  
  ```shell
  buildah bud -v ${BUILDAH_DNF_CACHE}/f36:/var/cache/dnf:O -t postgresql:15 -f Containerfile .
  ```

* **Build an image with a different version of PostgreSQL**

  ```shell
  buildah bud [options] --build-arg PG_RELEASE=14 --build-arg PG_VERSION=14.5 -t postgresql:14.5 -f Containerfile .
  ```

