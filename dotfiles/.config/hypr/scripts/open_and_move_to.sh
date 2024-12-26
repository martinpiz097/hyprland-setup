#!/bin/sh

program=$1
program_class=$2
workspace_dest=$3

echo "Openning $program..."
$program &
sleep 0.2

echo "Moving $program..."
sh ~/.config/hypr/scripts/move_recent_to.sh $workspace_dest $program_class
