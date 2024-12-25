#!/bin/bash

# -------------------------------------------------------------------------------------------------------------------------------------------
# dirname archivo -> indica la referencia desde mi posicion actual a la ruta de la carpeta padre de un archivo x
# readlink -f archivo -> indica la ruta completa de un archivo dado su nombre
# $0 -> referencia al nombre del archivo actual, parametro por defecto
# -------------------------------------------------------------------------------------------------------------------------------------------

ROOT_FOLDER=~/hyprland-setup/scripts/personal-setup-scripts
SET_WALLPAPER_SCRIPT=~/hyprland-setup/scripts/set-wallpaper.sh

sh $ROOT_FOLDER/clear_current_setup.sh
sh $ROOT_FOLDER/load_personal_setup.sh
sh $ROOT_FOLDER/reload_ui.sh

#sudo rm /usr/bin/set-wallpaper || true
#sudo cp $SET_WALLPAPER_SCRIPT /usr/bin/set-wallpaper
#sudo chmod 777 /usr/bin/set-wallpaper

echo "Setup finalizado!"
