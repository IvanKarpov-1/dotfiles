# Create cache directory
ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# Initialize completion system
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
_comp_options+=(globdots) # With hidden files

# cmp opts
zstyle ':completion:*' menu select                             # Tab opens cmp menu
zstyle ':completion:*' special-dirs true                       # Force . and .. to show in cmp menu
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # Colorize cmp menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' squeeze-slashes false                   # Explicit disable to allow /*/ expansion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'         # Case insensetive completion
# Noraml completion, case insensetive, partial world completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on                            # Using cache
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/.zcompdump"  # Defining cache path
