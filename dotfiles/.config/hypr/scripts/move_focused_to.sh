#!/bin/bash

#current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')
workspace_dest=$1
focused_window_address=$(hyprctl clients -j | jq -r ".[] | select(.focusHistoryID == 0) | .address")

hyprctl dispatch movetoworkspace "$workspace_dest,address:$focused_window_address"


