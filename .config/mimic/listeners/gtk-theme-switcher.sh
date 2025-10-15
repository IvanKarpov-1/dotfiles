#!/usr/bin/env bash

# This script monitors changes to the GTK settings.ini file
# and automatically switches the 'matugen' theme between light and dark
# based on the 'gtk-application-prefer-dark-theme' setting.

# Path to the GTK settings file
SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
SETTINGS_DIR="$HOME/.config/gtk-3.0"
SETTINGS_BASENAME=$(basename "$SETTINGS_FILE")

# Ensure inotify-tools is installed
if ! command -v inotifywait &> /dev/null
then
    echo "Error: inotifywait is not installed."
    echo "Please install inotify-tools (e.g., sudo apt install inotify-tools on Debian/Ubuntu)"
    exit 1
fi

echo "Monitoring $SETTINGS_FILE for changes..."
echo "Press Ctrl+C to stop."

echo 'SCRIPT STARTED' > ~/.cache/temp_cache_from_start_script

# Loop indefinitely, reading output from inotifywait
inotifywait -m -q -e close_write,moved_to "$SETTINGS_DIR" | while read -r dir events filename; do
    if [[ "$filename" == "$SETTINGS_BASENAME" ]]; then
        echo "Change detected in $SETTINGS_FILE. Re-applying theme..."
        $HOME/.config/hypr/scripts/wallpaper.sh
    fi
done