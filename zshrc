# If you come from bash you might have to change your $PATH.
export PATH=/home/jupblb/.local/bin:$PATH

if [ "$(tty)" = "/dev/tty1" ]; then
#  export KITTY_ENABLE_WAYLAND=1
#  export GDK_BACKEND=wayland
#  export CLUTTER_BACKEND=wayland
#  export XDG_SESSION_TYPE=wayland
#  export QT_WAYLAND_FORCE_DPI=physical
#  export SDL_VIDEODRIVER=wayland
#  export _JAVA_AWT_WM_NONREPARENTING=1
#  export XKB_DEFAULT_LAYOUT=pl
#  sway >> ~/.config/sway/sway.log 2>&1
#  exit 0
fi

# Path to your oh-my-zsh installation.
export ZSH=/home/jupblb/.dotfiles/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="risto"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
#export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  adb colored-man-pages extract git per-directory-history sudo stack httpie
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR=vim
export GIT_MERGE_AUTOEDIT=no

export SBT_OPTS="-Xms2G -Xmx8G -Xss4m -XX:MaxMetaspaceSize=1024M -XX:ReservedCodeCacheSize=1024m -XX:+TieredCompilation -XX:-UseGCOverheadLimit -XX:+CMSClassUnloadingEnabled"
export COURSIER_CACHE="/home/jupblb/.cache/coursier"
export BAT_THEME="OneHalfDark"

alias git-prune="git fetch --prune"

# Keep at the end of .zshrc
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$HOME/.vim/pack/gruvbox/gruvbox_256palette.sh"

alias kat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"

alias pulse-pci="pacmd set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo"
alias pulse-bluez="pacmd set-default-sink bluez_sink.00_1B_66_7F_A7_23.a2dp_sink"

alias rm="trash"
