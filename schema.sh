#!/bin/bash

docker-compose up -d db

if [ "$1" = "dump" ]; then
	rm -f schema.sql && docker-compose exec db pg_dump -U postgres groupbutler --schema-only > schema.sql
elif [[ "$1" = "restore" ]]; then
	docker-compose exec db dropdb -U postgres groupbutler
	docker-compose exec db createdb -U postgres groupbutler
	# This will not work until https://github.com/docker/compose/issues/3352 is fixed
	# docker-compose exec db pg_restore -U postgres -C -d groupbutler < schema.sql
	DOCKER_DB_NAME="$(docker-compose ps -q db)"
	docker exec -i "${DOCKER_DB_NAME}" psql -U postgres groupbutler < schema.sql
fi

docker-compose stop db
