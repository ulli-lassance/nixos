#!/usr/bin/env bash

# If an rofi process is running, kill it
if pgrep rofi > /dev/null 2>&1; then
    killall rofi
else
    rofi \
        -show window \
        -theme "~/.config/rofi/modes/window-switcher.rasi"
fi