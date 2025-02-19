#!/bin/bash

selected_theme=$1
base_config_folder=~/.config/nwg-panel
themes_folder=$base_config_folder/themes

echo "Loading style..."
unlink $base_config_folder/style.css || true
unlink $base_config_folder/menu-start.css || true

ln -s $themes_folder/$selected_theme/style.css $base_config_folder/style.css
ln -s $themes_folder/$selected_theme/menu-start.css $base_config_folder/menu-start.css

echo "Reloading nwg-panel..."
sh ~/.config/nwg-panel/scripts/launch.sh &
