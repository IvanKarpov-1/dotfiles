# Define XDG variables if missing
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Helper functions to safely modify PATH
path_prepend() { [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
path_append()  { [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

# User-local bin directories
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# Other paths
path_append "$HOME/.cargo/bin"