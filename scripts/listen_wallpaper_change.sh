#!/bin/bash

SCRIPT_PARENT_FOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
POSTSCRIPT_PATH=$SCRIPT_PARENT_FOLDER/wallpaper_change_postscript.sh
CURRENT_WALLPAPER_PATH=$HOME/.config/ml4w/cache/current_wallpaper
CONFIG_FILE=$HOME/.config/waypaper/config.ini
LAST_WALLPAPER=""

get_current_wallpaper() {
    grep -oP '^wallpaper\s*=\s*\K.*' "$CONFIG_FILE"
}

LAST_WALLPAPER=$(get_current_wallpaper)

inotifywait -m -e modify "$CONFIG_FILE" | while read -r path event file; do
    CURRENT_WALLPAPER=$(get_current_wallpaper)

    if [[ "$CURRENT_WALLPAPER" != "$LAST_WALLPAPER" ]]; then
        LAST_WALLPAPER=$CURRENT_WALLPAPER
        echo "El wallpaper ha cambiado: $CURRENT_WALLPAPER"
        sh $POSTSCRIPT_PATH $LAST_WALLPAPER
    fi
    sleep 0.01
done
