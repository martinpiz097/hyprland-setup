#!/bin/sh

# devolver el estado actual de la ventana focused, si esta maximizada o cualquier otro estado, incluido fullscreen
# si esta maximizada, cambiar estado junto con otras que tengan estado maximizado
# sino, maximizarla junto con las otras que esten distintas

maximized_state=1

if [ -z "$1" ]; then
    echo "workspace param not found!"
    exit 1
fi

current_workspace=cat $(hyprctl -j activeworkspace | jq -r ".id")
current_window=$(hyprctl clients -j | jq -r "[.[] | select(.workspace.id == $current_workspace)] | .[-1]" | grep -v '^$')
current_window_maximized=$(echo "$current_window" | jq -r ".fullscreen == $maximized_state" | grep -v '^$')
another_windows


if [[ $(echo "$current_window_maximized" | xargs) == "true" ]]; then
    echo "La ventana está maximizada."
else
    echo "La ventana no está maximizada."
fi
