#!/usr/bin/env bash

# If an waybar process is running, kill it
if pgrep waybar > /dev/null 2>&1; then
    killall waybar
else
    waybar
    # Kill KDE process to fix tray
    killall kded6
fi
