#!/usr/bin/env bash

read -p "Do you want me to install Group Butler Bot? (yes/no):"

if [ "$REPLY" != "yes" ]; then
    echo "Exiting!!!"
else
    echo -e "\e[1;36mUpdating packages\e[0m"
    sudo apt-get update -y

    echo -e "\e[1;36mInstalling dependencies\e[0m"
    sudo apt-get install libreadline-dev libssl-dev lua5.2 luarocks liblua5.2-dev git make unzip redis-server curl libcurl4-gnutls-dev -y
    
    echo -e "\e[1;36mInstalling rocks\e[0m"
    sudo luarocks install luasocket
    sudo luarocks install luasec
    sudo luarocks install redis-lua
    sudo luarocks install lua-term
    sudo luarocks install serpent
    sudo luarocks install dkjson
    sudo luarocks install lanes
    sudo luarocks install Lua-cURL
    
    echo -e "\e[1;36mFetching latest Group Butler source code\e[0m"
    git clone https://github.com/RememberTheAir/GroupButler.git && cd GroupButler
    sudo chmod 777 launch.sh
    
    echo -e "\e[1;32mGroup Butler successfully installed!, change values in config file and run ./launch.sh\e[0m"
    echo " "
fi