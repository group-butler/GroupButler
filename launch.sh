#!/bin/bash

if [ "$1" = "" ]; then
	while true; do
		lua bot.lua
		sleep 4s
	done
fi


if [ "$1" = "tmux" ]; then
  clear
  tmux kill-session -t tmuxsession 
  tmux new-session -d -s tmuxsession "lua bot.lua" && echo -e '\e[0;32mBot started with tmux.\e[0m'
  echo "Nombre de tmux con nombre running" || echo -e '\e[0;31mError.\e[0m'

fi

if [ "$1" = "attach" ]; then
  clear
  tmux attach -t tmuxsession
fi

if [ "$1" = "kill" ]; then
  clear
  tmux kill-session -t tmuxsession
fi
