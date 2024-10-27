#!/bin/bash
# Kill and restart waybar whenever its config files change

CONFIG_FILES="$HOME/.dotfiles/config/waybar_config/config"
STYLE_FILES="$HOME/.dotfiles/config/watvar_config/styles.css"

trap "killall waybar" EXIT

while true; do
	echo -i "$0: Starting waybar in the background..."
	exec waybar -c ~/.dotfiles/config/waybar_config/config -s ~/.dotfiles/config/waybar_config/styles.css & 
	echo -i "$0: Started waybar PID=$!. Waiting for modifications to ${CONFIG_FILES};${STYLE_FILES}..."
	inotifywait -e modify ${CONFIG_FILES} 2>&1 | logger -i
	logger -i "$0: inotifywait returned $?. Killing all waybar processes..."
	killall waybar 2>&1 | logger -i
	logger -i "$0: killall waybar returned $?, wait a sec..."
	sleep 1
done
