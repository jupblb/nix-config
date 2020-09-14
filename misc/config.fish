set fish_greeting
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
alias ssh 'env TERM=xterm-256color ssh'
alias vim 'nvim'
alias vimdiff 'nvim -d'

set -gx BAT_THEME gruvbox
set -gx EDITOR nvim

