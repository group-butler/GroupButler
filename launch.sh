#!/bin/bash

# Tmux session name
NAME=GroupButler

if [ ! -f "/usr/bin/tmux" ]; then
	clear
	echo -e '\e[0;31mError. Tmux not found\e[0m' && read -t5 -r -p 'Press enter to install tmux'
	sudo apt-get install tmux
	clear
fi

if [ "$1" = "" ]; then
	while true; do
		lua bot.lua
		sleep 4s
	done
fi

if [ "$1" = "tmux" ]; then
  tmux kill-session -t $NAME 
  clear
  tmux new-session -d -s $NAME "lua bot.lua" && echo -e '\e[0;32mBot started sucessfully.\e[0m'
  echo "Tmux session with name $NAME" || echo -e '\e[0;31mError.\e[0m'

fi

if [ "$1" = "attach" ]; then
  clear
  tmux attach -t $NAME
fi

if [ "$1" = "kill" ]; then
  clear
  tmux kill-session -t $NAME
fi
