#!/usr/bin/env bash

sed -i -E 's/\r$//' .env # Converting CRLF (\r\n) to LF (\n)
source .env && export $(cut -d= -f1 .env)
while true; do
	./polling.lua
	sleep 10
done
