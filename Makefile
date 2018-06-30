pot:
	find . -name "*.lua" | sort | xgettext --from-code=utf-8 \
		--add-comments=TRANSLATORS \
		--force-po \
		--keyword=i18n \
		--files-from=/dev/stdin \
		--output=/dev/stdout | msgmerge --backup=off --update locales/en.po /dev/stdin
