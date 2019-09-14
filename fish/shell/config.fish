# Set default field separators
set -g IFS \n\ \t

# Make sudope mimic behaviour from sudo plugin in oh-my-zsh
set -g sudope_sequence \e\e

# Add kitty completions
kitty + complete setup fish | source

# Theme settings (bobthefish)
set -g theme_color_scheme           solarized-light
set -g theme_display_vagrant        yes
set -g theme_display_docker_machine yes
set -g theme_display_virtualenv     yes
set -g theme_title_display_process  yes
set -g default_user                 jupblb
set -g theme_display_user           ssh
set -g theme_display_hostname       ssh

# General env variables
set -x EDITOR             vim
set -x GIT_MERGE_AUTOEDIT no
set -x SBT_OPTS           "-Xms2G -Xmx8G -Xss4m"
set -x COURSIER_CACHE     "/home/jupblb/.cache/coursier"
set -x BAT_THEME          "OneHalfDark"

# Load /etc/profile
bass source /etc/profile
