#!/usr/bin/env bash

# Lua Version
LUA=5.2

# Dependencies and libraries
NATIVE="libreadline-dev libssl-dev luarocks liblua$LUA-dev git make unzip redis-server curl libcurl4-gnutls-dev deborphan"
ROCKS="luasocket luasec redis-lua lua-term serpent lua-cjson Lua-cURL"

# Color variables
Green='\033[0;32m'
Orange='\033[0;33m'
Blue='\033[0;34m'
Cyan='\033[0;36m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
Default='\033[0m'

read -p "Do you want me to install Group Butler Bot? (Y/N): "

case $REPLY in [yY])
	# Install Dependencies
	clear
	echo -en "${Blue}The packages will be installed:${Default} ${NATIVE}\n${Cyan}Do you want to install the dependencies (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
		wget https://www.lua.org/ftp/lua-5.2.4.tar.gz && tar -vzxf lua-5.2.4.tar.gz && cd lua-5.2.4 && sudo make linux test
		cd .. && rm -rf lua-5.2.4*
		sudo apt-get install $NATIVE -y
	fi

	# Install Luarocks
	clear
	echo -en "${Cyan}Do you want to download and install luarocks (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
		git clone http://github.com/keplerproject/luarocks
		cd luarocks
		./configure --lua-version=$LUA
		make build
		sudo make install
		cd ..
		rm -rf luarocks*
	fi

	clear
	echo -en "${Cyan}Do you want to download the luarocks libraries (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
		for ROCK in $ROCKS; do
			sudo luarocks install $ROCK
		done
	fi

	clear
	if [ ! -d .git ]; then
		echo -en "${Green}Would you like to clone the source of GroupButler? (Y/N): ${Default}"
		read REPLY
		if [[ $REPLY == [yY] ]]; then
			echo -en "${Orange}Fetching latest Group Butler source code\n${Default}"
			git clone -b master https://github.com/RememberTheAir/GroupButler.git && cd GroupButler
		fi
	fi

	if [ -d .git ]; then
	echo -en "${Green}Do you want to use the beta branch (If you modified something we will do a stash)? (Y/N): ${Default}"
	read REPLY
		git stash
		git checkout beta
	fi;

	clear
	echo -en "${BGreen}Group Butler successfully installed! Change values in config file and run ${BRed}./launch.sh${BGreen}.${Default}";;
	*) echo "Exiting...";;
esac
