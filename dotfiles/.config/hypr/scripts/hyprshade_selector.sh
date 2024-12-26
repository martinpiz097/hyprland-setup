#!/bin/bash
# hyprshade on blue-light-filter-50 

# Seleccionar hora de inicio
start_time=$(zenity --entry --title="HyprShade" --text="Introduce la hora de inicio (HH:MM, 24h):")
if [ -z "$start_time" ]; then
    zenity --error --text="No se seleccionó una hora de inicio."
    exit 1
fi

# Seleccionar hora de fin
end_time=$(zenity --entry --title="HyprShade" --text="Introduce la hora de fin (HH:MM, 24h):")
if [ -z "$end_time" ]; then
    zenity --error --text="No se seleccionó una hora de fin."
    exit 1
fi

# Validar formato de hora
if ! [[ "$start_time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ && "$end_time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
    zenity --error --text="Formato de hora inválido. Usa HH:MM (24h)."
    exit 1
fi

# Guardar la configuración en un archivo
config_file="$HOME/.config/hypr/hyprshade_schedule"
mkdir -p "$(dirname "$config_file")"
echo "$start_time $end_time" > "$config_file"

# Confirmación al usuario
zenity --info --text="HyprShade configurado para activarse de $start_time a $end_time."

# Ejecutar el script scheduler para ajustar el estado inicial según la configuración actual
scheduler_script="$HOME/.config/hypr/scripts/hyprshade_scheduler.sh"
if [ -f "$scheduler_script" ]; then
    bash "$scheduler_script"
else
    zenity --error --text="No se encontró el script hyprshade_scheduler.sh en $scheduler_script."
fi

