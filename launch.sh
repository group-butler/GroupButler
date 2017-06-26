#!/usr/bin/env bash

make_template() {
	find . -name "lua/*.lua" | sort |
		xgettext --from-code=utf-8 \
			--add-comments=TRANSLATORS \
			--package-name=GroupButler \
			--package-version=4.2 \
			--msgid-bugs-address=https://telegram.me/bac0nnn \
			--force-po \
			--files-from=/dev/stdin \
			--output=/dev/stdout
}

case $1 in bot | "")
	cd lua
	while true; do
		lua bot.lua
		sleep 10
	done

	;; create-locale)
	if [ -z "$2" ]; then
		echo "Using: $0 $1 <locale_name>" >&2
	elif [ -a locales/$2.po ]; then
		echo "Locale exists" >&2
	else
		make_template | msginit --locale=$2 \
			--input=/dev/stdin \
			--output-file=locales/$2.po
	fi
	exit

	;; update-locale)
	if [ -z "$2" ]; then
		echo "Using: $0 $1 <locale_name>" >&2
	else
		make_template | msgmerge --update locales/$2.po /dev/stdin
	fi
	exit
esac

echo "Using: $0 [ bot | create-locale | update-locale ]" >&2
