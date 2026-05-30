#!/usr/bin/env bash

# -----------------------------------------------------
# Detect Theme
# -----------------------------------------------------

SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
THEME_PREF=$(grep -E '^gtk-application-prefer-dark-theme=' "$SETTINGS_FILE" | awk -F'=' '{print $2}')

# -----------------------------------------------------
# Apply variant
# -----------------------------------------------------

config="$HOME/.config/kitty";

if [ "$THEME_PREF" -eq 1 ]; then
    cat "$config/themes/colors-dark.conf" >> "$config/themes/colors-matugen.conf"
else
    cat "$config/themes/colors-light.conf" >> "$config/themes/colors-matugen.conf"
fi