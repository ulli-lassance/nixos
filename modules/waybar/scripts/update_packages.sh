#!/bin/bash
UPDATE_CMD="sh -c 'yay -Syu; pkill -SIGRTMIN+8 waybar; echo \"Done - Press enter to exit\"; read'"
TERMINAL="kitty"

hyprctl dispatch exec "[float;size 900 700] $TERMINAL $UPDATE_CMD"
