source $ZDOTDIR/custom/themes/spaceship-prompt/spaceship.zsh-theme

SPACESHIP_PROMPT_ORDER=(
  sudo          # Cached passwordless permissions indicator
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  char          # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=false

SPACESHIP_SUDO_SHOW=true
SPACESHIP_SUDO_SUFFIX=" "
SPACESHIP_SUDO_COLOR=red

SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX=""
SPACESHIP_USER_SUFFIX=""

SPACESHIP_HOST_SHOW=always
SPACESHIP_HOST_PREFIX="@"

SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_TRUNC=0

SPACESHIP_GIT_PREFIX=""

SPACESHIP_EXEC_TIME_PREFIX=""

SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=""