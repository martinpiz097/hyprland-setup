#!/bin/bash
CURRENT_WALLPAPER_PATH=/home/martin/hyprland-setup/dotfiles/dot_config/ml4w/cache/current_wallpaper

waypaper --wallpaper $1
rm $CURRENT_WALLPAPER_PATH || true
touch $CURRENT_WALLPAPER_PATH || true
echo "$1" >> $CURRENT_WALLPAPER_PATH
