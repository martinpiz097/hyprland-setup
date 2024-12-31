#!/bin/bash

# -------------------------------------------------------------------------------------------------------------------------------------------
# dirname archivo -> indica la referencia desde mi posicion actual a la ruta de la carpeta padre de un archivo x
# readlink -f archivo -> indica la ruta completa de un archivo dado su nombre
# $0 -> referencia al nombre del archivo actual, parametro por defecto
# -------------------------------------------------------------------------------------------------------------------------------------------

REPO_FOLDER=$HOME/hyprland-setup/
ROOT_FOLDER=$REPO_FOLDER/scripts/personal-setup-scripts
#SET_WALLPAPER_SCRIPT=$REPO_FOLDER/scripts/set-wallpaper.sh
WALLPAPERS_PATH=$REPO_FOLDER/wallpapers

echo "Comprobando carpeta wallapers..."

if ! [ -d $WALLPAPERS_PATH ]; then
	echo "Carpeta wallpapers no existe, descargando..."	
	cd $REPO_FOLDER
	git clone https://github.com/martinpiz097/hyprland-wallpapers wallpapers
else 
	echo "Carpeta wallpapers existe, actualizando..."	
	cd $REPO_FOLDER/wallpapers
	git reset --hard
	git pull
fi

echo "Instalando hapless para procesos paralelos..."
pipx install hapless
	
sh $ROOT_FOLDER/clear_current_setup.sh
sh $ROOT_FOLDER/load_personal_setup.sh
sh $ROOT_FOLDER/reload_ui.sh

#sudo rm /usr/bin/set-wallpaper || true
#sudo cp $SET_WALLPAPER_SCRIPT /usr/bin/set-wallpaper
#sudo chmod 777 /usr/bin/set-wallpaper

echo "Setup finalizado!"
