if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end
if test -e ~/mdproxy/mdproxy_bash_profile
  bass source ~/mdproxy/mdproxy_bash_profile
end
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"; exec sway; end

alias cat 'bat -p --paging=never'
alias less 'bat -p --paging=always'
alias nix-shell 'nix-shell --command fish'
alias ssh 'kitty +kitten ssh'
alias vim 'nvim'

function fish_greeting; end
function fish_right_prompt; end

set -gx BAT_THEME gruvbox
set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--color=light"

set -g theme_nerd_fonts yes
set -g theme_color_scheme solarized-light

