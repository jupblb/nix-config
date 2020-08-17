set fish_greeting
if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end
if test -e ~/mdproxy/mdproxy_bash_profile
  bass source ~/mdproxy/mdproxy_bash_profile
end
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"; exec sway; end

