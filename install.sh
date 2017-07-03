#!/usr/bin/env bash

. bin/misc

read -p "Do you want me to install Group Butler Bot? (Y/N): "

case $REPLY in [yY])
	updateSystem
	install
	installRocks
	cleanSystem
	finish;;
	*) echo "Exiting...";;
esac
