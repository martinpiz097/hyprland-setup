#!/bin/bash

SCRIPT_PARENT_FOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
CURRENT_WALLPAPER_PATH=$HOME/.config/ml4w/cache/current_wallpaper
CONFIG_FILE=$HOME/.config/waypaper/config.ini
LAST_WALLPAPER=$1

echo "--------------------------------------------------"
echo "CURRENT_WALLPAPER_PATH: $CURRENT_WALLPAPER_PATH"
echo "CONFIG_FILE: $CONFIG_FILE"
echo "LAST_WALLPAPER: $LAST_WALLPAPER"
echo "--------------------------------------------------"

echo "Eliminando current_wallpaper info..."
rm $CURRENT_WALLPAPER_PATH || true

echo "Cargando nueva info de wallpaper..."
touch $CURRENT_WALLPAPER_PATH || true
echo "$LAST_WALLPAPER" > $CURRENT_WALLPAPER_PATH
sed -i "s|~|$HOME|g" "$CURRENT_WALLPAPER_PATH"

echo "Modificando color scheme..."
source "$HOME/.cache/wal/colors.sh"
wal -q -i $(cat $CURRENT_WALLPAPER_PATH) &

echo "Cargando blur wallpaper..."
sh $SCRIPT_PARENT_FOLDER/generate_blur_wallpaper.sh
