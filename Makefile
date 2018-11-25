all: dev_polling logs

clean: kill down
	# docker system prune -fa

pot:
	find . -name "*.lua" | sort | xgettext --from-code=utf-8 \
		--add-comments=TRANSLATORS \
		--force-po \
		--keyword=i18n \
		--files-from=/dev/stdin \
		--output=/dev/stdout | msgmerge --backup=off --update locales/en_GB.po /dev/stdin

luacheck:
	luacheck . --exclude-files lua/vendor src

logs:
	docker-compose logs -f --tail 20

kill:
	docker-compose kill groupbutler

down:
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml down

pull:
	docker-compose pull

easy_deploy: pull
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.deploy.yml up -d

build_polling:
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml build

build_webhooks:
	docker-compose -f docker-compose.yml -f docker/docker-compose.webhooks.yml build

dev_polling: kill build_polling
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml up

dev_webhooks: kill build_webhooks
	docker-compose -f docker-compose.yml -f docker/docker-compose.webhooks.yml up

dump_pg:
	rm -f schema.sql && docker-compose exec postgres pg_dump -U postgres groupbutler --schema-only > schema.sql

restore_pg:
	docker-compose exec postgres dropdb -U postgres groupbutler
	docker-compose exec postgres createdb -U postgres groupbutler
	docker-compose exec postgres pg_restore -U postgres -C -d groupbutler < schema.sql
