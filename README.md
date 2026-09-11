*This project has been created as part of the 42 curriculum by bahbibe.*

# Inception

## Description

Inception is a system administration project. The goal is to build a small web
infrastructure with Docker Compose, inside a virtual machine, where every service
runs in its own container built from a Dockerfile written by hand.

The mandatory stack:

- **nginx**: the only entry point, on port 443, TLSv1.2 and TLSv1.3 only.
- **wordpress**: WordPress with php-fpm, no web server inside.
- **mariadb**: the WordPress database.

The bonus services:

- **redis**: object cache for WordPress.
- **ftp**: vsftpd server pointing to the WordPress files volume.
- **website**: a static showcase site.
- **adminer**: web UI for the database.
- **portainer**: web UI to manage the Docker containers (service of my choice).

### Project description

All images are built from `alpine:3.23`, the penultimate stable Alpine release.
No ready-made image is pulled from Docker Hub. Each service has its own folder in
`srcs/requirements/` with a `Dockerfile` and, when needed, a `conf/` and `tools/`
folder. The Makefile calls `docker compose` with `srcs/docker-compose.yml`.

Main design choices:

- Each container runs one process in the foreground as PID 1. Setup scripts end
  with `exec`, so the daemon gets the signals from Docker and stops cleanly.
- MariaDB is initialised once with `mariadb-install-db` and `mariadbd --bootstrap`.
  The script does nothing on later starts because the data is already in the volume.
- WordPress is installed with WP-CLI on the first start. The script waits until
  MariaDB answers before it runs.
- Configuration comes from `srcs/.env`, which is not tracked by git.
  `srcs/.env.template` lists the variables.
- Containers talk over one user-defined bridge network called `inception`.

**Virtual Machines vs Docker.** A VM emulates a full machine and runs its own
kernel, so it is heavy and slow to start. A container shares the host kernel and
only isolates processes with namespaces and cgroups. It starts in a second and
uses much less memory, but the isolation is weaker.

**Secrets vs Environment Variables.** Environment variables are easy to use but
they are visible in `docker inspect`, in `/proc/<pid>/environ` and in child
processes. Docker secrets are mounted as files in `/run/secrets/` and are only
given to the services that need them. This project uses a `.env` file that is
ignored by git.

**Docker Network vs Host Network.** With the host network a container uses the
host network stack directly, so every port it opens is open on the host and there
is no isolation. A Docker bridge network gives each container its own IP and a
DNS name (`mariadb`, `wordpress`, ...). Only the ports listed in `ports:` are
published on the host.

**Docker Volumes vs Bind Mounts.** A bind mount maps any host path into the
container and depends on the host folder layout. A named volume is managed by
Docker, has a name, and can be listed, inspected and removed with `docker volume`.
Here the two named volumes use the `local` driver with their data stored in
`/home/bahbibe/data`.

## Instructions

Requirements: a Linux VM with Docker Engine, the Docker Compose plugin, `make`
and `sudo`.

```sh
cp srcs/.env.template srcs/.env      # then fill in every value
echo "127.0.0.1 bahbibe.42.fr" | sudo tee -a /etc/hosts
make                                  # create data dirs, build, start
```

Open https://bahbibe.42.fr (the certificate is self-signed).

- `make down` stops the stack.
- `make rm` also deletes the volumes and the data in `/home/$USER/data`.
- `make re` rebuilds everything from scratch.

See [USER_DOC.md](USER_DOC.md) and [DEV_DOC.md](DEV_DOC.md) for more.

## Resources

- Docker docs: https://docs.docker.com/
- Compose file reference: https://docs.docker.com/reference/compose-file/
- Dockerfile best practices: https://docs.docker.com/build/building/best-practices/
- nginx SSL module: https://nginx.org/en/docs/http/ngx_http_ssl_module.html
- MariaDB `mariadb-install-db`: https://mariadb.com/kb/en/mariadb-install-db/
- WP-CLI commands: https://developer.wordpress.org/cli/commands/
- vsftpd manual: https://security.appspot.com/vsftpd/vsftpd_conf.html
- PID 1 in containers: https://docs.docker.com/engine/containers/multi-service_container/

### AI usage

AI (Claude Code) was used for:

- Reviewing the repository against the subject and listing problems.
- Fixing the setup scripts: MariaDB bootstrap, WP-CLI as root, waiting for the
  database, `exec` for PID 1, idempotent FTP setup.
- Updating the base images to Alpine 3.23.
- Writing a first draft of this README, USER_DOC.md and DEV_DOC.md.

Every change was read, tested and understood before being kept.
