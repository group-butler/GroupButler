all: dev_polling logs

clean: kill down
	# docker system prune -fa

pot:
	find . -name "*.lua" | sort | xgettext --from-code=utf-8 \
		--add-comments=TRANSLATORS \
		--force-po \
		--keyword=i18n \
		--files-from=/dev/stdin \
		--output=/dev/stdout | msgmerge --backup=off --update locales/en.po /dev/stdin

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
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml up -d

build_polling:
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml build

build_webhooks:
	docker-compose -f docker-compose.yml -f docker/docker-compose.webhooks.yml build

dev_polling: kill build_polling
	docker-compose -f docker-compose.yml -f docker/docker-compose.polling.yml up

dev_webhooks: kill build_webhooks
	docker-compose -f docker-compose.yml -f docker/docker-compose.webhooks.yml up
