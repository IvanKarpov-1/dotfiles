#!/bin/sh

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CATPPUCCIN_THEME="Catppuccin-Macchiato-Standard-Teal-Dark"
CATPPUCCIN_CURSOR="Afterglow-Recolored-Catppuccin-Teal-v3"

# create temp directories
TEMP_DIR="${SCRIPT_DIR}/temp"
# create temp directory for theme
THEME_TEMP="${TEMP_DIR}/theme"
mkdir -p "$THEME_TEMP"
# create temp directory for cursor
CURSOR_TEMP="${TEMP_DIR}/cursor"
mkdir -p "$CURSOR_TEMP"
# create temp directory for bat theme
BAT_TEMP="${TEMP_DIR}/bat_theme"
mkdir -p "$BAT_TEMP"

# download theme
if ! compgen -G "$THEME_TEMP/archive/${CATPPUCCIN_THEME}.zip" > /dev/null; then
    theme_url=$(curl -s https://api.github.com/repos/catppuccin/gtk/releases/latest \
        | jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url" \
        | grep "$CATPPUCCIN_THEME.zip")
    wget -P "$THEME_TEMP/archive" "$theme_url"
fi

# download cursor
if ! compgen -G "$CURSOR_TEMP/archive/${CATPPUCCIN_CURSOR}.tar.gz" > /dev/null; then
    cursor_url=$(curl -s https://api.github.com/repos/TeddyBearKilla/Afterglow-Cursors-Recolored/releases/tags/Catppuccin \
        | jq -r ".assets[] | select(.name | test (\"${spruce_type}\")) | .browser_download_url" \
        | grep "$CATPPUCCIN_CURSOR.tar.gz")
    wget -P "$CURSOR_TEMP/archive" "$cursor_url"
fi


# theme installation
# unzip themes
unzip -u "$THEME_TEMP/archive/$CATPPUCCIN_THEME.zip" -d "${THEME_TEMP}/$(basename -s .zip "$CATPPUCCIN_THEME.zip")" > /dev/null

# create directory for user theme if not exists yet
THEMES_DIR="${HOME}/.themes"
mkdir -p "$THEMES_DIR"

# copy unziped theme to themes directory
cp -r -n "${THEME_TEMP}/${CATPPUCCIN_THEME}/${CATPPUCCIN_THEME}" "$THEMES_DIR" > /dev/null 2>&1

# create simlimks for GTK 4 applications
mkdir -p "${HOME}/.config/gtk-4.0"
ln -sf "$THEMES_DIR/${CATPPUCCIN_THEME}/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
ln -sf "$THEMES_DIR/${CATPPUCCIN_THEME}/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "$THEMES_DIR/${CATPPUCCIN_THEME}/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

# applying theme
gsettings set org.gnome.desktop.wm.preferences theme $CATPPUCCIN_THEME
gsettings set org.gnome.desktop.interface gtk-theme $CATPPUCCIN_THEME

# give Flatpak apps access to GTK themes location
flatpak --user override --filesystem="$THEMES_DIR/:ro"
flatpak --user override --env=GTK_THEME=$CATPPUCCIN_THEME


# cursor installation
# unzip cursor
UNZIPED_CURSOR_DIR="${CURSOR_TEMP}/$(basename -s .tar.gz "$CATPPUCCIN_CURSOR.tar.gz")"
mkdir -p "$UNZIPED_CURSOR_DIR"
tar -xzf "$CURSOR_TEMP/archive/$CATPPUCCIN_CURSOR.tar.gz" -C "$UNZIPED_CURSOR_DIR" > /dev/null

# create a directory for user cursor if not exists yet
CURSOR_DIR="${HOME}/.local/share/icons"
mkdir -p "$CURSOR_DIR"

# copy unziped cursor to cirsors directory
cp -r -n "${CURSOR_TEMP}/${CATPPUCCIN_CURSOR}/${CATPPUCCIN_CURSOR}" "$CURSOR_DIR" > /dev/null 2>&1

# applying cursor
gsettings set org.gnome.desktop.interface cursor-theme $CATPPUCCIN_CURSOR

# give Flatpak apps access to cursor themes location
flatpak --user override --filesystem="$CURSOR_DIR/:ro"
flatpak --user override --env=CURSOR_THEME=$CATPPUCCIN_CURSOR


# theme for bat
# clone repo
if ! compgen -G "$BAT_TEMP/.git" > /dev/null; then
    git clone https://github.com/catppuccin/bat "$BAT_TEMP"
fi

# create directory for bat themes
mkdir -p "$(bat --config-dir)/themes"

# copy all .tmTheme files
cp "${BAT_TEMP}/"*".tmTheme" "$(bat --config-dir)/themes" > /dev/null 2>&1

# rebuild bat's cache
bat cache --build

# add theme to config files
echo "--theme=\"Catppuccin-macchiato\"" >> "$(bat --config-file)"


# theme for silicon
# without this directory silicon --build-cache won't work
mkdir -p "$(bat --config-dir)/syntaxes"

# cd to bat --config-dir
cd "$(bat --config-dir)"

# rebuild silicon cache
silicon --build-cache

# cd back to script dir
cd "$SCRIPT_DIR"


# remove temp directory
rm -rf "${TEMP_DIR}"
