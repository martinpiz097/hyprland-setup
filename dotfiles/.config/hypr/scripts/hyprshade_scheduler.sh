#!/bin/bash

# Leer horario configurado
if [ ! -f ~/.config/hypr/hyprshade_schedule ]; then
    echo "No hay horario configurado para HyprShade."
    exit 1
fi

read start_time end_time < ~/.config/hypr/hyprshade_schedule

# Convertir horas a segundos para comparación
current_time=$(date +%s)
start_seconds=$(date -d "$start_time" +%s)
end_seconds=$(date -d "$end_time" +%s)

# Activar o desactivar HyprShade
if (( current_time >= start_seconds && current_time <= end_seconds )); then
    # Activar HyprShade
    ~/.config/hypr/scripts/hyprshade.sh on blue-light-filter-50
else
    # Desactivar HyprShade
    ~/.config/hypr/scripts/hyprshade.sh off
fi
