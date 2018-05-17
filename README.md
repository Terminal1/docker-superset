# Docker container for Apache Superset

[![](https://images.microbadger.com/badges/image/terminal1/superset.svg)](https://hub.docker.com/r/terminal1/superset/)
![Docker Automated build](https://img.shields.io/docker/automated/terminal1/superset.svg)


* Alpine container based [Apache Superset](https://superset.apache.org/) container
* Has PostgreSQL and Redis backends pre-installed

### Example
Run the container in detached mode and follow the [official documentation](https://superset.apache.org/installation.html#superset-installation-and-initialization):
```
# Run container in detached mode and share its port
docker run -p 127.0.0.1:8088:8088 --rm --detach --name superset_container terminal1/superset

# Create an admin and migrate the database
docker exec -it superset_container fabmanager create-admin --app superset
docker exec -it superset_container superset db upgrade
docker exec -it superset_container superset init
```
Open [127.0.0.1:8088](http://127.0.0.1:8088) in your browser and enjoy playing with Superset.

To stop the detached container use the following command:
```
docker stop superset_container
```

### Yet another docker image for superset?
This container is similar to [amancevice/superset](https://hub.docker.com/r/amancevice/superset/) but has some differences:

* Alpine based (instead of Debian), total size ~4x smaller.
* Works only with PostgreSQL and Redis.
* Result image uses gunicorn + gevent for the webserver instead of [deprecated](https://github.com/apache/incubator-superset/blob/0.25.0/superset/cli.py#L113-L114) "superset runserver".
