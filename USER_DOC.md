# User documentation

## Services

| Service   | What it does                          | Access                         |
|-----------|---------------------------------------|--------------------------------|
| nginx     | HTTPS entry point for WordPress       | https://bahbibe.42.fr (443)    |
| wordpress | The website (php-fpm)                 | through nginx only             |
| mariadb   | Database for WordPress                | internal only (3306)           |
| redis     | Cache for WordPress                   | internal only (6379)           |
| ftp       | Upload files to the WordPress folder  | ftp://localhost:21             |
| website   | Static showcase site                  | http://localhost:1337          |
| adminer   | Web UI for the database               | http://localhost:4242          |
| portainer | Web UI to manage containers           | https://localhost:9443         |

## Start and stop

Run these from the root of the repository.

```sh
make          # build and start everything
make down     # stop and remove the containers, keep the data
make ps       # show the containers
make logs     # show the logs
```

`make` stays in the foreground and shows the logs. Press `Ctrl+C` to stop, or run
`make down` from another terminal.

## Website and admin panel

- Website: https://bahbibe.42.fr
- Admin panel: https://bahbibe.42.fr/wp-admin

The browser warns about the certificate because it is self-signed. Accept it to
continue.

If the domain does not open, check that `/etc/hosts` has this line:

```
127.0.0.1 bahbibe.42.fr
```

## Credentials

All credentials are in `srcs/.env`. This file is not in git. Ask the
administrator for it, or create it from `srcs/.env.template`.

- WordPress administrator: `WP_ADMIN` / `WP_PASS`
- WordPress second user (author): `WP_USER` / `WP_USER_PASS`
- Database user (for Adminer, server `mariadb`): `DB_USER` / `DB_PASS`
- FTP user: `FTP_USER` / `FTP_PASS`

The WordPress users are created only on the first start. Changing `.env` later
does not change them. Change passwords in the admin panel instead.

## Check that everything runs

```sh
make ps                                   # every service should be "Up"
curl -kI https://bahbibe.42.fr            # should return HTTP 200 or 302
docker logs wordpress                     # no error at the end
docker exec mariadb mariadb-admin ping    # "mysqld is alive"
```

Check the TLS versions:

```sh
openssl s_client -connect bahbibe.42.fr:443 -tls1_2 </dev/null   # works
openssl s_client -connect bahbibe.42.fr:443 -tls1_1 </dev/null   # fails
```
