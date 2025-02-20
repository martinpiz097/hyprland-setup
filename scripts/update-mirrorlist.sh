#!/bin/bash
sudo reflector --country $1 --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy
