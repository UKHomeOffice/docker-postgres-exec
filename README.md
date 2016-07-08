# Docker Postgres executor

Docker container for initialising and manipulating external postgres
databases by executing postgres SQL scripts.

## Usage

To use this image you will need to either mount in your SQL scripts when
you run this image or you will need to derive a new image from this one
and copy your scripts across in your `Dockerfile`.

The scripts should be placed in `/docker-entrypoint-initdb.d/`.

An example of executing an image built in this way can be found below:

```
docker run \
       -e POSTGRES_HOST=your-postgres-server \
       -e POSTGRES_DB=your-db-name \
       -e POSTGRES_USER=your-postgres-user \
       -e POSTGRES_PASSWORD=your-password \
       your-image
```

The login credentials can also be mounted into the image rather than
provided as environment variables.

### Environment Variables

The variables and the defaults are shown below.

* `POSTGRES_HOST` The host to connect to.
* `POSTGRES_PORT=5432` The port to connect to.
* `POSTGRES_DB_SECRET=/etc/postgres/db` The location in which to look for the database name.
* `POSTGRES_USER_SECRET=/etc/postgres/user` The location in which to look for the postgres username.
* `POSTGRES_PASSWORD_SECRET=/etc/postgres/password` The location in which to look for the postgres password.
* `POSTGRES_DB` The database name (overrides the secret).
* `POSTGRES_USER` The postgres username (overrides the secret).
* `POSTGRES_PASSWORD` The postgres password (overrides the secret).

## Contributing

Feel free to submit pull requests and issues. If it's a particularly large PR, you may wish to discuss
it in an issue first.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/UKHomeOffice/docker-postgres-exec/tags).

## Authors

* **Daniel Martin** - *Initial work* - [Daniel A.C. Martin](https://github.com/daniel-ac-martin)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
