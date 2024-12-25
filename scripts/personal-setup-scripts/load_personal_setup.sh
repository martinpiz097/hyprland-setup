#!/bin/bash

# -------------------------------------------------------------------------------------------------------------------------------------------
# dirname archivo -> indica la referencia desde mi posición actual a la ruta de la carpeta padre de un archivo x
# readlink -f archivo -> indica la ruta completa de un archivo dado su nombre
# $0 -> referencia al nombre del archivo actual, parámetro por defecto
# -------------------------------------------------------------------------------------------------------------------------------------------

PERSONAL_SETUP_PATH=$HOME/hyprland-setup
PERSONAL_DOTFILES_PATH=$PERSONAL_SETUP_PATH/dotfiles
CONFIG_PATH=$HOME/.config
ML4W_DOTFILES_PATH=$HOME/dotfiles

echo "Cargando setup personalizado..."

create_symlink() {
    local source_path=$1
    local target_path=$2

    if [ ! -L "$target_path" ]; then
        echo "Creating symlink: $source_path -> $target_path"
        ln -s "$source_path" "$target_path"
    else
        echo "Symlink already exists: $source_path -> $target_path"
    fi
}

define_symlinks() {
    declare -n symlinks=$1
    local source_base=$2
    local target_base=$3

    for source_file in "${!symlinks[@]}"; do
        target_files=${symlinks[$source_file]}
        source_path="$source_base/$source_file"

        if [[ $target_files == *","* ]]; then
            IFS=',' read -r -a targets <<< "$target_files"
            for target in "${targets[@]}"; do
                target_path="$target_base/$target"
                create_symlink "$source_path" "$target_path"
            done
        else
            target_path="$target_base/$target_files"
            create_symlink "$source_path" "$target_path"
        fi
    done
}

declare -A symlinks_to_create=(
    ["dot_bashrc"]=".bashrc"
    ["dot_config"]=".config"
    ["dot_gtkrc-2.0"]=".gtkrc-2.0"
    ["dot_Xresources"]=".Xresources"
    ["dot_zshrc"]=".zshrc"
    ["ml4w-hyprland-settings"]="ml4w-hyprland-settings"
)
define_symlinks symlinks_to_create "$PERSONAL_DOTFILES_PATH" "$ML4W_DOTFILES_PATH"

declare -A symlinks_to_create=(
    ["ml4w-hyprland-settings"]="ml4w-hyprland-settings"
)
define_symlinks symlinks_to_create "$ML4W_DOTFILES_PATH" "$CONFIG_PATH"

declare -A files_to_link=(
    [".bashrc"]=".bashrc"
    [".gtkrc-2.0"]=".gtkrc-2.0"
    [".Xresources"]=".Xresources"
    [".zshrc"]=".zshrc,.zshrc.pre-oh-my-zsh"
)
define_symlinks files_to_link "$ML4W_DOTFILES_PATH" "$HOME"

if [ -d "$ML4W_DOTFILES_PATH/.config" ]; then
    for folder in "$ML4W_DOTFILES_PATH/.config"/*; do
        if [ -d "$folder" ]; then
            folder_name=$(basename "$folder")
            target_path="$CONFIG_PATH/$folder_name"
            create_symlink "$folder" "$target_path"
        fi
    done
fi

echo "Symlinks created successfully."

echo "Modificando comportamiento del botón de apagado, favor reiniciar logind"
sudo sed -i 's/#HandlePowerKey.*/HandlePowerKey=ignore/' /etc/pacman.conf
