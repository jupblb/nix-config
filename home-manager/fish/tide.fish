# https://github.com/IlanCosman/tide/wiki/Configuration
set -g tide_prompt_add_newline_before false
set -g tide_left_prompt_items context pwd nix_shell character
set -g tide_right_prompt_items status cmd_duration jobs git
set -g tide_character_icon "~>"
set -g tide_cmd_duration_icon " "
set -g tide_jobs_icon " "
set -g tide_nix_shell_icon " "
set -g tide_pwd_markers BUILD $tide_pwd_markers
set -g tide_status_icon " "
set -g tide_status_icon_failure " "
