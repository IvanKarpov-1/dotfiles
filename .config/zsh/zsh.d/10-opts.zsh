# Main opts
setopt AUTO_MENU MENU_COMPLETE    # Autocmp first menu match
setopt AUTO_CD                    # Type a dir to cd
setopt AUTO_PARAM_SLASH           # when a dir is completed, add a / instead of a trailing space
setopt NO_CASE_GLOB NO_CASE_MATCH # Make cmp case insensitive
setopt GLOB_DOTS                  # Include dotfiles
setopt EXTENDED_GLOB              # Match ~ # ^
setopt INTERACTIVE_COMMENTS       # Allow comments in shell
unsetopt PROMPT_SP                # Don't autoclean blanklines
stty stop undef                   # Disable accidental ctrl s
unsetopt BEEP                     # Remove beeping

# History opts
setopt HIST_IGNORE_DUPS           # If it's a duplicate of the previous command, do not append
setopt HIST_IGNORE_SPACE          # If the first character is SPACE, do not append
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks from each command line being  added  to  the history list
setopt INC_APPEND_HISTORY         # Append new commands immediately
setopt SHARE_HISTORY              # Share history across sessions
HISTSIZE=100000
SAVEHIST=100000

# Create cache directory
ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_CACHE_DIR"
HISTFILE="$XDG_CACHE_HOME/zsh_history" # Move histfile to cache

# Remove paste highlight
zle_highlight=('paste:none')