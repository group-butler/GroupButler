#!/bin/bash

if [ "$1" = "" ]; then
	while true; do
		lua bot.lua
		sleep 4s
	done
fi


if [ "$1" = "tmux" ]; then
  tmux kill-session -t tmuxsession 
  clear
  tmux new-session -d -s tmuxsession "lua bot.lua" && echo -e '\e[0;32mBot started sucessfully.\e[0m'
  echo "Tmux session with name tmuxsession" || echo -e '\e[0;31mError.\e[0m'

fi

if [ "$1" = "attach" ]; then
  clear
  tmux attach -t tmuxsession
fi

if [ "$1" = "kill" ]; then
  clear
  tmux kill-session -t tmuxsession
fi
