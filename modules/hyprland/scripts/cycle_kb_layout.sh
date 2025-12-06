#!/bin/bash

# Configuration
DEVICE="royuan-akko-multi-modes-keyboard-b"
SWITCH_CMD="hyprctl switchxkblayout $DEVICE next"

$SWITCH_CMD

# We query hyprctl devices in JSON format and filter for your specific keyboard
NEW_LAYOUT=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name == \"$DEVICE\") | .active_keymap")

# The '-h ...' flag replaces the existing notification instead of stacking them
notify-send -u low -h string:x-canonical-private-synchronous:kbd_layout "Keyboard Layout" "$NEW_LAYOUT"