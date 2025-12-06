#!/usr/bin/env bash

# If an rofi process is running, kill it
if pgrep rofi > /dev/null 2>&1; then
    killall rofi
else
    rofi \
        -show power-menu -modi power-menu:~/.config/rofi/scripts/rofi-power-menu.sh \
        -theme "~/.config/rofi/modes/power-menu.rasi"
fi
