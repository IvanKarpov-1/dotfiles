#!/usr/bin/env bash

M_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
M_CONFIG_DIR=$( cd -- "$M_SCRIPT_DIR/../.config" &> /dev/null && pwd )
M_LOCAL_DIR=$( cd -- "$M_SCRIPT_DIR/../.local/bin" &> /dev/null && pwd )
M_FIRST_RUN_DIR=$( cd -- "$M_SCRIPT_DIR/first-run" &> /dev/null && pwd )

echo "Using config dir: $M_CONFIG_DIR"
echo "Using local dir:  $M_LOCAL_DIR"

config="$HOME/.config"
local_bin="$HOME/.local/bin"

# mkdir -p "$config" "$local_bin"

# if [ -d "$config" ]; then
#     echo "Backing up old config..."
#     mv "$config" "$HOME/.config.backup.$(date +%s)"
# fi

# if [ -f "$HOME/.zshenv" ]; then
#     echo "Backing up old .zshenv..."
#     mv "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%s)"
# fi

# if [ -f "$M_CONFIG_DIR/zsh/.zshenv" ]; then
#     ln -sfn "$M_CONFIG_DIR/zsh/.zshenv" "$HOME/.zshenv"
# fi

# echo "Linking configs..."
# for c in "$M_CONFIG_DIR"/*; do
#     ln -sfn "$c" "$config/$(basename "$c")"
# done

echo "Linking local executables..."
for b in "$M_LOCAL_DIR"/*; do
    ln -sfn "$b" "$local_bin/$(basename "$b")"
done

echo "Executing first run scripts..."
bash "$M_FIRST_RUN_DIR/battery-monitor.sh"

echo "All done!"