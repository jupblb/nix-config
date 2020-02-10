# Set default field separators
set -gx IFS \n\ \t

# Make sudope mimic behaviour from sudo plugin in oh-my-zsh
set -g sudope_sequence \e\e

# Theme settings (bobthefish)
set -g theme_color_scheme          solarized-light
set -g theme_title_display_process yes
set -g default_user                jupblb
set -g theme_display_user          ssh
set -g theme_display_hostname      ssh
set -g theme_display_date          no

