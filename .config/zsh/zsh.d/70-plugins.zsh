# Load auto suggestion plugin
source $ZDOTDIR/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load syntax highlighting plugin
source $ZDOTDIR/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Load completetion plugin
fpath=($ZDOTDIR/custom/plugins/zsh-completions/src $fpath)

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# Load sudo plugin (easily prefix your current or previous commands with sudo)
source $ZDOTDIR/custom/plugins/sudo/sudo.plugin.zsh

# Load dirhistory plugin (navigate the history of previous working directories using keyboard shortcuts)
source $ZDOTDIR/custom/plugins/dirhistory/dirhistory.plugin.zsh

# Load colored man pages plugin
source $ZDOTDIR/custom/plugins/colored-man-pages/colored-man-pages.plugin.zsh