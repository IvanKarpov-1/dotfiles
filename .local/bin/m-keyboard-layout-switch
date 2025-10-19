#!/usr/bin/env bash

# List your layouts here in the order they appear in hyprland.conf
LAYOUTS=("us" "ua")

# Get the block for the main keyboard
KEYBOARD_BLOCK=$(hyprctl devices | awk '
    $1 == "Keyboard" && $2 == "at" {
        block = $0 "\n"
        while (getline) {
            block = block $0 "\n"
            if ($0 ~ /main: yes/) {
                print block
                exit
            }
            if ($1 == "Keyboard" && $2 == "at") break
        }
    }
')

if [[ -z "$KEYBOARD_BLOCK" ]]; then
    echo "❌ Could not find main keyboard."
    exit 1
fi

# Extract the keyboard device name
DEVICE=$(echo "$KEYBOARD_BLOCK" | awk 'NR==2 {print $1}')

# Get current layout index from the block
CURRENT_INDEX=$(echo "$KEYBOARD_BLOCK" | grep "active layout index:" | awk '{print $4}')

if [[ -z "$CURRENT_INDEX" ]]; then
    echo "❌ Could not determine current layout index."
    exit 1
fi

# Calculate next layout index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#LAYOUTS[@]} ))

# Switch layout
hyprctl switchxkblayout "$DEVICE" "$NEXT_INDEX"
