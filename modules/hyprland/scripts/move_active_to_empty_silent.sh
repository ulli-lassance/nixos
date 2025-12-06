#!/usr/bin/env bash

#
# Hyprland Script: Move Active Window to First Empty Workspace --DOES NOT CHANGE FOCUS--
#
# This script moves the active window to the first available empty workspace.
# - If the window is already the only one on its workspace, it does nothing.
# - It finds the lowest-numbered workspace that has no windows.
# - If all existing workspaces are occupied, it finds the lowest-numbered
#   workspace that doesn't exist and moves the window there.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Check for dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it to use this script." >&2
    exit 1
fi

# Get information about the currently active window, including its workspace ID
active_window_info=$(hyprctl activewindow -j)
active_ws_id=$(echo "$active_window_info" | jq -r '.workspace.id')

# Ignore special workspaces (ID < 1), like scratchpads
if [[ "$active_ws_id" -lt 1 ]]; then
    exit 0
fi

# Get a count of all windows on the active window's current workspace
window_count_on_active_ws=$(hyprctl clients -j | jq --argjson id "$active_ws_id" '[.[] | select(.workspace.id == $id)] | length')

# If there is only one window (or fewer) on the workspace, do nothing and exit.
if [[ "$window_count_on_active_ws" -le 1 ]]; then
    exit 0
fi

# Get a sorted, unique list of all workspace IDs that currently have windows
occupied_workspaces=$(hyprctl clients -j | jq -r '.[].workspace.id' | grep -v '^-' | sort -n | uniq)

# Determine the target workspace. Start checking from workspace 1.
target_ws=1
for ws in $occupied_workspaces; do
    if [[ "$target_ws" -eq "$ws" ]]; then
        # If workspace 'target_ws' is occupied, check the next one.
        ((target_ws++))
    else
        # We found a gap in the sequence (an empty workspace), so we can stop.
        break
    fi
done

# Move the active window to the found target workspace
hyprctl dispatch movetoworkspacesilent "$target_ws"
