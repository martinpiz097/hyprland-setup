#!/bin/bash
nmcli -g IP4.ADDRESS device show $(nmcli -g DEVICE connection show --active | head -n1)
