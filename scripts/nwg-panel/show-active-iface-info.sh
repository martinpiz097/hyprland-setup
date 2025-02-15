#!/bin/bash
ip_addr=$(nmcli -g IP4.ADDRESS device show $(nmcli -g DEVICE connection show --active | head -n1))

echo /usr/share/gopsuinfo/icons_light/net.svg
echo $ip_addr
