#!/bin/bash

  sudo screen -X -S keepsession kill
  
clear

  sudo screen -S keepsession -t screen lua bot.lua

exit
