set fish_greeting
if type -q python; bass source ~/.nix-profile/etc/profile.d/nix.sh; end
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"; exec sway; end

