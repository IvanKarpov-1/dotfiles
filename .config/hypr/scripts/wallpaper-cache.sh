#!/usr/bin/env bash
mimic_cache_folder="$HOME/.cache/mimic/hyprland-dotfiles"
generated_versions="$mimic_cache_folder/wallpaper-generated"
rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify-send "Wallpaper cache cleared"
