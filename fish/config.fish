# Set default field separators
set -g IFS \n\ \t

# Make sudope mimic behaviour from sudo plugin in oh-my-zsh
set -g sudope_sequence \e\e

# Add kitty completions
kitty + complete setup fish | source

# Theme settings (bobthefish)
set -g theme_color_scheme gruvbox
set -g theme_display_vagrant yes
set -g theme_display_docker_machine yes
set -g theme_display_virtualenv yes
set -g theme_title_display_process yes
set -g default_user jupblb
set -g theme_display_user ssh
set -g theme_display_hostname ssh
