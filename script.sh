#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$DOTFILES_DIR/config"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
WALLPAPERS_DIR="$DOTFILES_DIR/wallpapers_mov"

print_intro() {
  cat <<EOL
Dotfiles setup script for Hyprland environment
1) Install
2) Repair
3) Remove
EOL
}

install_packages() {
  sudo pacman -Sy --needed --noconfirm hyprland waybar kitty rofi thunar \
    network-manager-applet swww starship micro
}

copy_repo() {
  if [ "$PWD" != "$DOTFILES_DIR" ]; then
    echo "Copying repository to $DOTFILES_DIR..."
    mkdir -p "$DOTFILES_DIR"
    rsync -a --delete --exclude '.git' "$PWD/" "$DOTFILES_DIR/"
  fi
}

install_configs() {
  mkdir -p "$HOME/.config"
  rsync -a "$CONFIG_DIR/hypr/" "$HOME/.config/hypr/"
  rsync -a "$CONFIG_DIR/kitty/" "$HOME/.config/kitty/"
  rsync -a "$CONFIG_DIR/rofi/" "$HOME/.config/rofi/"
  rsync -a "$CONFIG_DIR/waybar_config/" "$HOME/.config/waybar/"
  rsync -a "$CONFIG_DIR/Thunar/" "$HOME/.config/Thunar/"
  rsync -a "$CONFIG_DIR/micro/" "$HOME/.config/micro/"
  mkdir -p "$HOME/.config/starship"
  rsync -a "$CONFIG_DIR/starshipconfig/starship.toml" \
    "$HOME/.config/starship/starship.toml"
  rsync -a "$SCRIPTS_DIR" "$DOTFILES_DIR/"
  rsync -a "$WALLPAPERS_DIR" "$DOTFILES_DIR/"
}

remove_all() {
  rm -rf "$HOME/.config/hypr" "$HOME/.config/kitty" "$HOME/.config/rofi" \
    "$HOME/.config/waybar" "$HOME/.config/Thunar" "$HOME/.config/micro" \
    "$HOME/.config/starship" "$DOTFILES_DIR"
}

print_intro
read -rp "Select option: " opt
case "$opt" in
  1)
    install_packages
    copy_repo
    install_configs
    echo "Installation completed."
    ;;
  2)
    copy_repo
    install_configs
    echo "Repair completed."
    ;;
  3)
    echo "This will remove all installed files. Continue? [y/N]";
    read -r confirm
    if [[ $confirm =~ ^[yY]$ ]]; then
      remove_all
      echo "Removed."
    else
      echo "Aborted."
    fi
    ;;
  *)
    echo "Invalid option.";
    ;;
esac

