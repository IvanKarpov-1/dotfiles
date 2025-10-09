# Define modules directory
ZSH_MODULE_DIR="${ZDOTDIR}/zsh.d"

# Source each modular file in order
if [ -d "$ZSH_MODULE_DIR" ]; then
  for f in "$ZSH_MODULE_DIR"/*.zsh; do
    [ -r "$f" ] && source "$f"
  done
fi