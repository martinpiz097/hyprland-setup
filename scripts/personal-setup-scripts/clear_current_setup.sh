#!/bin/bash

# Variables
PERSONAL_SETUP_PATH=$HOME/hyprland-setup
PERSONAL_DOTFILES_PATH=$PERSONAL_SETUP_PATH/dotfiles
CONFIG_PATH=$HOME/.config
ML4W_DOTFILES_PATH=$HOME/dotfiles

remove_symlink_if_linked_from() {
	local source_base_path=$1
    local target_path=$2

	# si target_path tiene link quiere decir que el souece_base_path debe ser el conjunto de carpetas padre de linked_path
    if [ -L "$target_path" ]; then
        local linked_path=$(readlink "$target_path")
        #echo "$linked_path ----> $target_path"
        if [[ "$linked_path" == "$source_base_path"* ]]; then
			echo "source_base_path=$source_base_path"
			echo "target_path=$target_path"
			echo "linked_path=$linked_path"
            #echo "Removing symlink: $target_path (linked from $linked_path)"
            #unlink "$target_path"
        fi
     elif [   ]
   		
        
   	fi
    echo "==========================================================================================================================="

}

remove_symlinks() {
	local source_base=$1
    local -n targets=$2

    for target in "${targets[@]}"; do
        remove_symlink_if_linked_from "$source_base" "$target"
    done
}

########################################################################


if [ -d "$CONFIG_PATH" ]; then
    config_targets=()
    for item in "$CONFIG_PATH"/*; do
        config_targets+=("$item")
    done
    remove_symlinks "$ML4W_DOTFILES_PATH/.config" config_targets
    remove_symlink_if_linked_from "$ML4W_DOTFILES_PATH" "$CONFIG_PATH/ml4w-hyprland-settings"
else
    echo "$CONFIG_PATH does not exist. Skipping."
fi

files_to_remove=(
    "$HOME/.bashrc"
    "$HOME/.gtkrc-2.0"
    "$HOME/.Xresources"
    "$HOME/.zshrc"
)
remove_symlinks "" files_to_remove

#rm -r $ML4W_DOTFILES_PATH
#mkdir $ML4W_DOTFILES_PATH

echo "Cleanup completed."
