#!/bin/bash

CONFIG_FILES="$HOME/.dotfiles/config/waybar_config/config"

trap "killall waybar" EXIT

while true; do
    waybar -c ~/.dotfiles/config/waybar_config/config -s ~/.dotfiles/config/waybar_config/style.css &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
