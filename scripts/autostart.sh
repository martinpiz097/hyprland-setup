#!/bin/bash

until pids=$(pidof waybar)
do
	sleep 0.01
done

sleep 0.1

autostart_apps=(
    "megasync"
)

hap cleanall

counter=0
for app in "${autostart_apps[@]}"; do
	counter=$[$counter +1]
	hap run $app
	hap rename $counter "app-$app"
done

echo "Hapless status"
hap status
