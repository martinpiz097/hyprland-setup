#!/bin/bash

#current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')
workspace_dest=$1
program_class=$2
newest_window_address=$(hyprctl clients -j | jq -r "[.[] | select(.class == \"${program_class}\")] | .[-1].address")

hyprctl dispatch movetoworkspace "$workspace_dest,address:$newest_window_address"