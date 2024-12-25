#!/bin/bash

# Variables
PERSONAL_SETUP_PATH=$HOME/hyprland-setup
PERSONAL_DOTFILES_PATH=$PERSONAL_SETUP_PATH/dotfiles
CONFIG_PATH=$HOME/.config
ML4W_DOTFILES_PATH=$HOME/dotfiles

remove_symlink_if_linked_from() {
    local target_path=$1
    local source_base_path=$2

    if [ -L "$target_path" ]; then
        local linked_path=$(readlink "$target_path")
        if [[ "$linked_path" == "$source_base_path"* ]]; then
            echo "Removing symlink: $target_path (linked from $linked_path)"
            rm -rf "$target_path"
        fi
    fi
}

remove_symlinks() {
    local -n targets=$1
    local source_base=$2

    for target in "${targets[@]}"; do
        remove_symlink_if_linked_from "$target" "$source_base"
    done
}

if [ -d "$CONFIG_PATH" ]; then
    config_targets=()
    for item in "$CONFIG_PATH"/*; do
        config_targets+=("$item")
    done
    remove_symlinks config_targets "$ML4W_DOTFILES_PATH/.config"
    remove_symlink_if_linked_from "$CONFIG_PATH/ml4w-hyprland-settings" "$ML4W_DOTFILES_PATH"
else
    echo "$CONFIG_PATH does not exist. Skipping."
fi

files_to_remove=(
    "$HOME/.bashrc"
    "$HOME/.gtkrc-2.0"
    "$HOME/.Xresources"
    "$HOME/.zshrc"
    "$HOME/.zshrc.pre-oh-my-zsh"
)
remove_symlinks files_to_remove ""

rm -r $ML4W_DOTFILES_PATH
mkdir $ML4W_DOTFILES_PATH

echo "Cleanup completed."