# Developer documentation

## Prerequisites

- A Linux virtual machine
- Docker Engine and the Docker Compose plugin (`docker compose`)
- `make` and `sudo`
- Your user in the `docker` group, or run the commands with `sudo`

## Set up from scratch

1. Clone the repository.
2. Create the environment file and fill in every value:

   ```sh
   cp srcs/.env.template srcs/.env
   ```

   | Variable            | Used by          | Notes                                       |
   |---------------------|------------------|---------------------------------------------|
   | `LOGIN`             | compose, Makefile | your 42 login, volumes go in `/home/<LOGIN>/data` |
   | `DB_NAME`           | mariadb, wp      | database name                               |
   | `DB_USER`           | mariadb, wp      | WordPress database user                     |
   | `CERT_PATH`/`KEY_PATH` | nginx (build) | where the self-signed cert is written       |
   | `WP_URL`            | nginx, wp        | must be `bahbibe.42.fr`                     |
   | `WP_ADMIN`/`WP_EMAIL` | wp             | admin name must not contain "admin"         |
   | `WP_USER`/`WP_USER_EMAIL` | wp         | second user, role author                    |
   | `FTP_USER`          | ftp              | FTP login                                   |

   No password is in `.env`. Passwords are docker secrets, in `secrets/` at
   the root of the repository:

   | File                            | Content                                   |
   |---------------------------------|-------------------------------------------|
   | `secrets/db_password.txt`       | the `DB_USER` password, one line           |
   | `secrets/db_root_password.txt`  | the MariaDB root password, one line        |
   | `secrets/credentials.txt`       | `WP_PASS=`, `WP_USER_PASS=`, `FTP_PASS=`   |

   Compose mounts them read-only at `/run/secrets/<name>` in the services that
   need them, and the setup scripts read the files. Create the three files from
   the templates and put your own values in them:

   ```sh
   for f in secrets/*.template; do cp "$f" "${f%.template}"; done
   ```

   `srcs/.env` and `secrets/*.txt` are in `.gitignore`. Never commit them.

3. Point the domain to the VM:

   ```sh
   echo "127.0.0.1 bahbibe.42.fr" | sudo tee -a /etc/hosts
   ```

## Build and launch

```sh
make          # same as make up
```

`make up` runs these steps in order:

1. `dirs`: creates `/home/<LOGIN>/data/wordpress` and `/home/<LOGIN>/data/mariadb`.
   `LOGIN` is read from `srcs/.env`, so the path is the same with or without `sudo`.
2. `build`: `docker compose -f srcs/docker-compose.yml build`.
3. `docker compose ... up` in the foreground.

On the first start:

- mariadb creates the database, the root password and the WordPress user.
- wordpress waits for mariadb, downloads WordPress, writes `wp-config.php`,
  installs the site, creates the second user and enables the redis cache.

On later starts both scripts skip this step because the data is already there.

## Makefile targets

| Target  | What it does                                                        |
|---------|---------------------------------------------------------------------|
| `all`   | same as `up`                                                        |
| `dirs`  | create the host data folders                                        |
| `build` | build all images                                                    |
| `up`    | `dirs` + `build`, then start the stack in the foreground            |
| `ps`    | list the project containers                                         |
| `logs`  | show the logs of all services                                       |
| `down`  | stop and remove the containers and the network, keep the volumes    |
| `rm`    | `down` plus remove the volumes and delete the data folders content  |
| `prune` | `rm` plus remove the project images                                 |
| `re`    | `prune` then `up`, a full rebuild from zero                         |

All targets only touch this project, not other containers on the machine.

## Useful commands

```sh
docker compose -f srcs/docker-compose.yml up -d --build wordpress   # rebuild one service
docker exec -it wordpress sh                                         # shell in a container
docker exec -it mariadb mariadb -uroot -p                            # SQL as root
docker exec wordpress wp user list                                   # WordPress users
docker volume ls                                                     # list volumes
docker volume inspect wordpress                                      # see where data lives
docker network inspect inception                                     # see container IPs
```

## Where the data is stored

| Volume      | Mounted in container      | Data on the host                |
|-------------|---------------------------|---------------------------------|
| `mariadb`   | `/var/lib/mysql`          | `/home/<LOGIN>/data/mariadb`       |
| `wordpress` | `/var/www/html/wordpress` | `/home/<LOGIN>/data/wordpress`     |
| `mailpit`   | `/data`                   | Docker default volume location  |

The `mariadb` and `wordpress` volumes are named volumes that use the `local`
driver with `type: none` and `o: bind`, so Docker stores their content in the
host folders above.

Data survives `make down` and a VM reboot. Only `make rm`, `make prune` and
`make re` delete it.

If you change the volume options in `docker-compose.yml`, remove the old volumes
first (`make rm`). Otherwise compose refuses to start because the existing volume
config does not match.
