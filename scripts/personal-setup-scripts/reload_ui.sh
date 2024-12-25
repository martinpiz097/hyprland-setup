#!/bin/bash

if pgrep -i "hyprland" > /dev/null; then
	echo "Recargando UI..."
#	$ML4W_DOTFILES_PATH/waybar/launch.sh
#	hyprpm reload -n
	hyprctl reload
else
    echo "Hyprland no activo, recarga de UI omitida!"
fi

#echo "Cargando plugins..."
#hyprpm update
#hyprpm enable hyprexpo
