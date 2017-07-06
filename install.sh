#!/usr/bin/env bash

# Lua Version
LUA=5.2

# Dependencies and libraries
NATIVE="libreadline-dev libssl-dev lua$LUA luarocks liblua$LUA-dev git make unzip redis-server curl libcurl4-gnutls-dev deborphan"
ROCKS="luasocket luasec redis-lua lua-term serpent cjson Lua-cURL"

# Color variables
Red='\033[0;31m'
Green='\033[0;32m'
Orange='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
BOrange='\033[1;33m'
BBlue='\033[1;34m'
BPurple='\033[1;35m'
BCyan='\033[1;36m'
Default='\033[0m'

read -p "Do you want me to install Group Butler Bot? (Y/N): "

case $REPLY in [yY])
	# Update System
	clear
	echo -en "${Cyan}Do you want to upgrade your system (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
		sudo apt-get update
		sudo apt-get upgrade -y
		sudo apt-get dist-upgrade -y
	fi

	# Install Dependencies
	clear
	echo -en "${Blue}The packages will be installed:${Default} ${NATIVE}\n${Cyan}Do you want to install the dependencies (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
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

	# Clean System
	clear
	echo -en "${Cyan}Do you want to clean your system (Y/N): ${Default}"
	read REPLY
	if [[ $REPLY == [yY] ]]; then
		sudo apt-get autoremove -y
		sudo apt-get remove $(deborphan)
		sudo apt-get autoclean -y
		sudo apt-get clean -y
	fi

	clear
	echo -en "${Green}Do you want to use the beta branch? (Y/N): ${Default}"
	read REPLY
	if [ -d .git ]; then
		git stash
		git checkout beta
	else
		echo -en "${Orange}Fetching latest Group Butler source code\n${Default}"
		git clone -b beta https://github.com/RememberTheAir/GroupButler.git
		cd GroupButler
	fi;

	clear
	echo -en "${BGreen}Group Butler successfully installed! Change values in config file and run ${BRed}./launch.sh${BGreen}.${Default}";;
	*) echo "Exiting...";;
esac
