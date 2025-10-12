#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$( cd -- $SCRIPT_DIR/../.config &> /dev/null && pwd )
echo $CONFIG_DIR

# if [ ! -d $HOME/.local/bin ]; then
#     mkdir -p $HOME/.local/bin
# fi

echo "Backing up old config"
mv "$HOME/.config" "$HOME/.config.backup"
mv "$HOME/.zshenv" "$HOME/.zshenv.backup"

echo "Linking new config"
new_config="$HOME/.config"
mkdir "$new_config"

ln -s "$CONFIG_DIR/gtk-3.0" "$new_config/gtk-3.0"
ln -s "$CONFIG_DIR/gtk-4.0" "$new_config/gtk-4.0"
ln -s "$CONFIG_DIR/hypr" "$new_config/hypr"
ln -s "$CONFIG_DIR/kitty" "$new_config/kitty"
ln -s "$CONFIG_DIR/matugen" "$new_config/matugen"
ln -s "$CONFIG_DIR/mimic" "$new_config/mimic"
ln -s "$CONFIG_DIR/qt5ct" "$new_config/qt5ct"
ln -s "$CONFIG_DIR/qt6ct" "$new_config/qt6ct"
ln -s "$CONFIG_DIR/rofi" "$new_config/rofi"
ln -s "$CONFIG_DIR/swaync" "$new_config/swaync"
ln -s "$CONFIG_DIR/vivaldi" "$new_config/vivaldi"
ln -s "$CONFIG_DIR/waybar" "$new_config/waybar"
ln -s "$CONFIG_DIR/waypaper" "$new_config/waypaper"
ln -s "$CONFIG_DIR/wlogout" "$new_config/wlogout"
ln -s "$CONFIG_DIR/xdg-desktop-portal" "$new_config/xdg-desktop-portal"
ln -s "$CONFIG_DIR/zsh" "$new_config/zsh"
ln -s "$CONFIG_DIR/zsh/.zshenv" "$HOME/.zshenv"
ln -s "$CONFIG_DIR/mimeapps.list" "$new_config/mimeapps.list"
