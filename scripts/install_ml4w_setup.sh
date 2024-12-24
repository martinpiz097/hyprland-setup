#!/bin/bash

echo "Instalando capa de personalizacion ML4W par Hyprland..."
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)

echo "Configurando plugins..."
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
